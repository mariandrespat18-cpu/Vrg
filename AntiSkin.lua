
--==================================================
-- ANTI SKIN COMPACT - OPTIMIZADO
-- Event-driven / bajo consumo / restauración completa
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

Config = Config or {}
Config.AntiSkin = Config.AntiSkin or false

--==================================================
-- POSICIÓN
--==================================================

local POSITION_FILE = "AntiSkin_Position.json"

local defaultPosition = UDim2.new(0, 15, 0.5, -14)
local savedPosition = defaultPosition

pcall(function()
    if isfile and readfile and isfile(POSITION_FILE) then
        local data = HttpService:JSONDecode(readfile(POSITION_FILE))

        if type(data) == "table"
            and data.XScale ~= nil
            and data.XOffset ~= nil
            and data.YScale ~= nil
            and data.YOffset ~= nil then

            savedPosition = UDim2.new(
                tonumber(data.XScale) or 0,
                tonumber(data.XOffset) or 15,
                tonumber(data.YScale) or 0.5,
                tonumber(data.YOffset) or -14
            )
        end
    end
end)

if savedPosition == defaultPosition then
    pcall(function()
        local p = Config.AntiSkinPos

        if type(p) == "table" and #p >= 4 then
            savedPosition = UDim2.new(
                tonumber(p[1]) or 0,
                tonumber(p[2]) or 15,
                tonumber(p[3]) or 0.5,
                tonumber(p[4]) or -14
            )
        end
    end)
end

local function saveButtonPosition(position)
    pcall(function()

        Config.AntiSkinPos = {
            position.X.Scale,
            position.X.Offset,
            position.Y.Scale,
            position.Y.Offset
        }

        if writefile then
            writefile(
                POSITION_FILE,
                HttpService:JSONEncode({
                    XScale = position.X.Scale,
                    XOffset = position.X.Offset,
                    YScale = position.Y.Scale,
                    YOffset = position.Y.Offset
                })
            )
        end

    end)
end

--==================================================
-- GUI PARENT
--==================================================

local GuiParent

pcall(function()
    if gethui then
        GuiParent = gethui()
    end
end)

if not GuiParent then
    GuiParent = game:GetService("CoreGui")
end

--==================================================
-- ELIMINAR GUI ANTERIOR
--==================================================

pcall(function()
    local old = GuiParent:FindFirstChild("AntiSkinCompact")

    if old then
        old:Destroy()
    end
end)

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiSkinCompact"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GuiParent

local Button = Instance.new("TextButton")
Button.Name = "AntiSkin"
Button.Size = UDim2.new(0, 82, 0, 28)
Button.Position = savedPosition
Button.BackgroundColor3 = Color3.fromRGB(190, 40, 40)
Button.BorderSizePixel = 0
Button.AutoButtonColor = false
Button.Text = "AntiSkin"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 13
Button.Font = Enum.Font.GothamBold
Button.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 7)
Corner.Parent = Button

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1
Stroke.Transparency = 0.25
Stroke.Parent = Button

--==================================================
-- RGB
-- Baja frecuencia para no gastar FPS
--==================================================

task.spawn(function()

    local hue = 0

    while ScreenGui.Parent do

        hue = hue + 0.0125

        if hue >= 1 then
            hue = 0
        end

        Stroke.Color = Color3.fromHSV(
            hue,
            0.9,
            1
        )

        task.wait(0.05)
    end

end)

--==================================================
-- ESTADO DEL ANTI SKIN
--==================================================

local SIMPLE_COLOR = Color3.fromRGB(170, 170, 170)

local Whitelist = {
    ["Tokito_2025Muichiro"] = true,
    ["DavidAlejandro78892"] = true,
    ["KenalGotas789"] = true
}

--==================================================
-- SISTEMA DE SNAPSHOTS
--
-- Guarda SOLO lo que realmente modificamos.
-- Al apagar:
--    -> restaura propiedades
--    -> desconecta listeners
--    -> elimina estados
--==================================================

local CharacterStates = {}
local ProcessingToken = 0

local function getCharacterState(character)

    local state = CharacterStates[character]

    if state then
        return state
    end

    state = {
        snapshots = {},
        connections = {},
        processed = {},
        active = true,
        generation = ProcessingToken
    }

    CharacterStates[character] = state

    return state
end

--==================================================
-- SNAPSHOT
--==================================================

local function snapshot(instance, property)

    local state = CharacterStates[instance:FindFirstAncestorOfClass("Model")]

    if not state then
        return
    end

    local data = state.snapshots[instance]

    if not data then
        data = {}
        state.snapshots[instance] = data
    end

    if data[property] == nil then
        local ok, value = pcall(function()
            return instance[property]
        end)

        if ok then
            data[property] = value
        end
    end
end

--==================================================
-- RESTAURAR UNA INSTANCIA
--==================================================

local function restoreInstance(instance, data)

    if not instance or not data then
        return
    end

    for property, value in pairs(data) do

        pcall(function()
            instance[property] = value
        end)

    end
end

--==================================================
-- RESTAURAR PERSONAJE
--==================================================

local function restoreCharacter(character)

    local state = CharacterStates[character]

    if not state then
        return
    end

    state.active = false

    for _, connection in ipairs(state.connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    state.connections = {}

    for instance, data in pairs(state.snapshots) do

        restoreInstance(instance, data)

    end

    state.snapshots = {}
    state.processed = {}

    CharacterStates[character] = nil
end

--==================================================
-- HELPERS
--==================================================

local function setProperty(instance, property, value)

    local character = instance:FindFirstAncestorOfClass("Model")

    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    local state = CharacterStates[character]

    if not state then
        return
    end

    local data = state.snapshots[instance]

    if not data then
        data = {}
        state.snapshots[instance] = data
    end

    if data[property] == nil then

        local ok, oldValue = pcall(function()
            return instance[property]
        end)

        if ok then
            data[property] = oldValue
        end

    end

    pcall(function()
        instance[property] = value
    end)

end

--==================================================
-- PROCESAR INSTANCIA
--==================================================

local function simplifyInstance(character, instance)

    if not Config.AntiSkin then
        return
    end

    if not instance
        or not instance.Parent
        or not character
        or not character.Parent then
        return
    end

    local state = CharacterStates[character]

    if not state or not state.active then
        return
    end

    if state.processed[instance] then
        return
    end

    state.processed[instance] = true

    ------------------------------------------------
    -- BASE PART
    ------------------------------------------------

    if instance:IsA("BasePart") then

        -- No tocar tamaños ni posiciones:
        -- evita romper físicas y hace la reversión limpia.

        setProperty(
            instance,
            "Material",
            Enum.Material.SmoothPlastic
        )

        setProperty(
            instance,
            "Color",
            SIMPLE_COLOR
        )

        -- Ocultar partes de accesorios sin destruirlas.
        if instance.Parent
            and instance.Parent:IsA("Accessory") then

            setProperty(
                instance,
                "Transparency",
                1
            )
        end

    ------------------------------------------------
    -- MESHPART
    ------------------------------------------------

        if instance:IsA("MeshPart") then

            setProperty(
                instance,
                "TextureID",
                ""
            )

        end

    ------------------------------------------------
    -- SPECIAL MESH
    ------------------------------------------------

    elseif instance:IsA("SpecialMesh") then

        setProperty(
            instance,
            "TextureId",
            ""
        )

    ------------------------------------------------
    -- ACCESSORY
    ------------------------------------------------

    elseif instance:IsA("Accessory") then

        -- No Destroy().
        -- Simplemente se oculta mediante sus partes.

    ------------------------------------------------
    -- ROPA
    ------------------------------------------------

    elseif instance:IsA("Shirt") then

        setProperty(
            instance,
            "ShirtTemplate",
            ""
        )

    elseif instance:IsA("Pants") then

        setProperty(
            instance,
            "PantsTemplate",
            ""
        )

    elseif instance:IsA("ShirtGraphic") then

        setProperty(
            instance,
            "Graphic",
            ""
        )

    ------------------------------------------------
    -- DECALS / TEXTURAS
    ------------------------------------------------

    elseif instance:IsA("Decal")
        or instance:IsA("Texture") then

        setProperty(
            instance,
            "Transparency",
            1
        )

    ------------------------------------------------
    -- WRAP
    ------------------------------------------------

    elseif instance:IsA("WrapLayer") then

        pcall(function()

            setProperty(
                instance,
                "Enabled",
                false
            )

        end)

    ------------------------------------------------
    -- EFECTOS
    ------------------------------------------------

    elseif instance:IsA("ParticleEmitter")
        or instance:IsA("Trail")
        or instance:IsA("Beam")
        or instance:IsA("Smoke")
        or instance:IsA("Fire")
        or instance:IsA("Sparkles") then

        setProperty(
            instance,
            "Enabled",
            false
        )

    ------------------------------------------------
    -- LUCES
    ------------------------------------------------

    elseif instance:IsA("PointLight")
        or instance:IsA("SpotLight")
        or instance:IsA("SurfaceLight") then

        setProperty(
            instance,
            "Enabled",
            false
        )

    ------------------------------------------------
    -- GUI VISUAL
    ------------------------------------------------

    elseif instance:IsA("BillboardGui")
        or instance:IsA("SurfaceGui") then

        setProperty(
            instance,
            "Enabled",
            false
        )

    end
end

--==================================================
-- BODY COLORS
--==================================================

local function simplifyBodyColors(character)

    local bodyColors =
        character:FindFirstChildOfClass("BodyColors")

    if not bodyColors then
        return
    end

    local color = BrickColor.new(SIMPLE_COLOR)

    local properties = {
        "HeadColor",
        "LeftArmColor",
        "RightArmColor",
        "LeftLegColor",
        "RightLegColor",
        "TorsoColor"
    }

    for _, property in ipairs(properties) do
        setProperty(
            bodyColors,
            property,
            color
        )
    end
end

--==================================================
-- PROCESAMIENTO INICIAL
--
-- Se divide en pequeños lotes para evitar
-- un pico grande de FPS al activarlo.
--==================================================

local function processCharacter(character)

    if not character
        or not character.Parent
        or not Config.AntiSkin then
        return
    end

    local state = getCharacterState(character)

    state.active = true

    simplifyBodyColors(character)

    local descendants = character:GetDescendants()

    local batchSize = 60

    for index, instance in ipairs(descendants) do

        if not Config.AntiSkin
            or not character.Parent
            or not state.active then

            return
        end

        simplifyInstance(
            character,
            instance
        )

        if index % batchSize == 0 then
            task.wait()
        end
    end

    ------------------------------------------------
    -- Nuevos objetos solamente
    ------------------------------------------------

    if not state.active then
        return
    end

    local connection = character.DescendantAdded:Connect(
        function(instance)

            if not Config.AntiSkin
                or not state.active then
                return
            end

            -- defer evita procesar durante el ciclo
            -- de creación del objeto.
            task.defer(function()

                if Config.AntiSkin
                    and state.active
                    and character.Parent
                    and instance.Parent then

                    simplifyInstance(
                        character,
                        instance
                    )

                end

            end)

        end
    )

    table.insert(
        state.connections,
        connection
    )
end

--==================================================
-- ACTUALIZAR UN PERSONAJE
--==================================================

local function activateCharacter(character)

    if not character
        or not character.Parent
        or not Config.AntiSkin then
        return
    end

    if not CharacterStates[character] then

        task.spawn(function()
            processCharacter(character)
        end)

    end
end

--==================================================
-- ACTIVAR TODO
--==================================================

local function enableAntiSkin()

    ProcessingToken += 1

    for _, player in ipairs(Players:GetPlayers()) do

        if player ~= LocalPlayer
            and not Whitelist[player.Name] then

            local character = player.Character

            if character then
                activateCharacter(character)
            end

        end

    end
end

--==================================================
-- DESACTIVAR TODO
--==================================================

local function disableAntiSkin()

    ProcessingToken += 1

    local characters = {}

    for character in pairs(CharacterStates) do
        table.insert(characters, character)
    end

    for _, character in ipairs(characters) do
        restoreCharacter(character)
    end
end

--==================================================
-- TOGGLE
--==================================================

local function updateButton(animated)

    local targetColor

    if Config.AntiSkin then
        targetColor = Color3.fromRGB(35, 190, 75)
    else
        targetColor = Color3.fromRGB(190, 40, 40)
    end

    if animated then

        TweenService:Create(
            Button,
            TweenInfo.new(
                0.16,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                BackgroundColor3 = targetColor
            }
        ):Play()

    else

        Button.BackgroundColor3 = targetColor

    end
end

updateButton(false)

Button.MouseButton1Click:Connect(function()

    Config.AntiSkin = not Config.AntiSkin

    if Config.AntiSkin then
        enableAntiSkin()
    else
        disableAntiSkin()
    end

    updateButton(true)
end)

--==================================================
-- DRAG
--==================================================

local dragging = false
local dragStart
local startPos
local dragInput

local function updateDrag(input)

    local delta = input.Position - dragStart

    Button.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,

        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )

end

Button.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Button.Position

    end

end)

Button.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input

    end

end)

local inputChangedConnection =
    UserInputService.InputChanged:Connect(function(input)

        if dragging and input == dragInput then
            updateDrag(input)
        end

    end)

local inputEndedConnection =
    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            if dragging then

                dragging = false

                saveButtonPosition(
                    Button.Position
                )

            end
        end

    end)

--==================================================
-- PLAYER SETUP
--==================================================

local playerConnections = {}

local function setupPlayer(player)

    if player == LocalPlayer then
        return
    end

    if playerConnections[player] then
        pcall(function()
            playerConnections[player]:Disconnect()
        end)
    end

    playerConnections[player] =
        player.CharacterAdded:Connect(function(character)

            if not Config.AntiSkin then
                return
            end

            if Whitelist[player.Name] then
                return
            end

            -- Esperar solamente a que el humanoide exista.
            task.spawn(function()

                character:WaitForChild(
                    "Humanoid",
                    5
                )

                if Config.AntiSkin
                    and character.Parent then

                    activateCharacter(character)

                end

            end)

        end)

    if player.Character
        and Config.AntiSkin
        and not Whitelist[player.Name] then

        activateCharacter(
            player.Character
        )

    end
end

--==================================================
-- PLAYERS EXISTENTES
--==================================================

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

--==================================================
-- NUEVOS PLAYERS
--==================================================

Players.PlayerAdded:Connect(function(player)
    setupPlayer(player)
end)

--==================================================
-- PLAYER REMOVAL
--==================================================

Players.PlayerRemoving:Connect(function(player)

    local connection = playerConnections[player]

    if connection then

        pcall(function()
            connection:Disconnect()
        end)

        playerConnections[player] = nil
    end

end)

--==================================================
-- LIMPIEZA SI EL GUI SE DESTRUYE
--==================================================

ScreenGui.Destroying:Connect(function()

    Config.AntiSkin = false

    disableAntiSkin()

    pcall(function()
        inputChangedConnection:Disconnect()
    end)

    pcall(function()
        inputEndedConnection:Disconnect()
    end)

    for player, connection in pairs(playerConnections) do

        pcall(function()
            connection:Disconnect()
        end)

        playerConnections[player] = nil
    end

end)

--==================================================
-- SI Config YA VENÍA ACTIVADO
--==================================================

if Config.AntiSkin then
    task.defer(enableAntiSkin)
end
