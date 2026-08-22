--==================================================
-- ANTI SKIN COMPACT
-- Simplifica incluso skins normales
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

Config = Config or {}
Config.AntiSkin = Config.AntiSkin or false

--==================================================
-- POSICIÓN GUARDADA
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

-- Compatibilidad con Config
if savedPosition == defaultPosition then
    pcall(function()
        if Config and Config.AntiSkinPos then
            local p = Config.AntiSkinPos

            if type(p) == "table" and #p >= 4 then
                savedPosition = UDim2.new(
                    tonumber(p[1]) or 0,
                    tonumber(p[2]) or 15,
                    tonumber(p[3]) or 0.5,
                    tonumber(p[4]) or -14
                )
            end
        end
    end)
end

--==================================================
-- GUARDAR POSICIÓN
--==================================================

local function saveButtonPosition(position)
    pcall(function()

        if Config then
            Config.AntiSkinPos = {
                position.X.Scale,
                position.X.Offset,
                position.Y.Scale,
                position.Y.Offset
            }
        end

        if writefile then
            local data = {
                XScale = position.X.Scale,
                XOffset = position.X.Offset,
                YScale = position.Y.Scale,
                YOffset = position.Y.Offset
            }

            writefile(
                POSITION_FILE,
                HttpService:JSONEncode(data)
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
-- REMOVE OLD GUI
--==================================================

pcall(function()
    local old = GuiParent:FindFirstChild("AntiSkinCompact")

    if old then
        old:Destroy()
    end
end)

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "AntiSkinCompact"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GuiParent

--==================================================
-- TOGGLE
--==================================================

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
-- RGB BORDE
--==================================================

local RGBStrokeColor = 0

task.spawn(function()
    while Button and Button.Parent do
        RGBStrokeColor += 1.5

        if RGBStrokeColor >= 360 then
            RGBStrokeColor = 0
        end

        Stroke.Color = Color3.fromHSV(
            RGBStrokeColor / 360,
            0.9,
            1
        )

        task.wait(0.03)
    end
end)

--==================================================
-- ACTUALIZAR TOGGLE
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
                0.18,
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

--==================================================
-- TOGGLE
--==================================================

Button.MouseButton1Click:Connect(function()

    Config.AntiSkin = not Config.AntiSkin

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

UserInputService.InputChanged:Connect(function(input)

    if dragging and input == dragInput then
        updateDrag(input)
    end

end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        if dragging then
            dragging = false
            saveButtonPosition(Button.Position)
        end

    end

end)

--==================================================
-- WHITELIST
--==================================================

local Whitelist = {
    ["Tokito_2025Muichiro"] = true,
    ["DavidAlejandro78892"] = true,
    ["KenalGotas789"] = true
}

--==================================================
-- CONFIGURACIÓN DE SKIN SIMPLE
--==================================================

local SIMPLE_COLOR = Color3.fromRGB(170, 170, 170)

--==================================================
-- ELIMINAR ACCESORIOS
--==================================================

local function removeAccessories(character)

    for _, obj in ipairs(character:GetChildren()) do

        if obj:IsA("Accessory") then
            pcall(function()
                obj:Destroy()
            end)
        end

    end

end

--==================================================
-- SIMPLIFICAR DESCRIPCIÓN
--==================================================

local function simplifyHumanoid(humanoid)

    if not humanoid then
        return
    end

    pcall(function()

        humanoid.HipHeight = 0

        local desc = humanoid:GetAppliedDescription()

        if not desc then
            return
        end

        -- Escalas normales
        desc.HeightScale = 1
        desc.WidthScale = 1
        desc.HeadScale = 1
        desc.DepthScale = 1
        desc.BodyTypeScale = 0
        desc.ProportionScale = 0

        -- Accesorios
        desc.BackAccessory = ""
        desc.FaceAccessory = ""
        desc.FrontAccessory = ""
        desc.HairAccessory = ""
        desc.HatAccessory = ""
        desc.NeckAccessory = ""
        desc.ShouldersAccessory = ""
        desc.WaistAccessory = ""

        -- Ropa
        desc.Shirt = 0
        desc.Pants = 0
        desc.GraphicTShirt = 0

        humanoid:ApplyDescription(desc)

    end)

end

--==================================================
-- LIMPIAR APARIENCIA
--==================================================

local function simplifyAppearance(character)

    if not character then
        return
    end

    for _, obj in ipairs(character:GetDescendants()) do

        ------------------------------------------------
        -- PARTES DEL CUERPO
        ------------------------------------------------

        if obj:IsA("BasePart") then

            -- Material simple
            pcall(function()
                obj.Material = Enum.Material.SmoothPlastic
            end)

            -- Color uniforme
            pcall(function()
                obj.Color = SIMPLE_COLOR
            end)

            -- MeshPart sin textura
            if obj:IsA("MeshPart") then
                pcall(function()
                    obj.TextureID = ""
                end)
            end

            -- Tamaños anormales
            if obj.Size.X > 8
                or obj.Size.Y > 8
                or obj.Size.Z > 8 then

                pcall(function()
                    obj.Size = Vector3.new(2, 2, 1)
                end)
            end

            -- Coordenadas extremas
            if math.abs(obj.Position.Y) > 800
                or math.abs(obj.Position.X) > 4000
                or math.abs(obj.Position.Z) > 4000 then

                pcall(function()
                    obj.Transparency = 1
                    obj.CanCollide = false
                    obj.Anchored = true
                end)

            end

        ------------------------------------------------
        -- ACCESORIOS
        ------------------------------------------------

        elseif obj:IsA("Accessory") then

            pcall(function()
                obj:Destroy()
            end)

        ------------------------------------------------
        -- ROPA
        ------------------------------------------------

        elseif obj:IsA("Shirt")
            or obj:IsA("Pants")
            or obj:IsA("ShirtGraphic") then

            pcall(function()
                obj:Destroy()
            end)

        ------------------------------------------------
        -- TEXTURAS / DECALS
        ------------------------------------------------

        elseif obj:IsA("Decal")
            or obj:IsA("Texture")
            or obj:IsA("SurfaceAppearance") then

            pcall(function()
                obj:Destroy()
            end)

        ------------------------------------------------
        -- WRAP
        ------------------------------------------------

        elseif obj:IsA("WrapLayer") then

            pcall(function()
                obj.Enabled = false
            end)

        end

    end

    --==================================================
    -- BODY COLORS
    --==================================================

    local bodyColors = character:FindFirstChildOfClass("BodyColors")

    if bodyColors then
        pcall(function()

            local simpleBrickColor = BrickColor.new(
                SIMPLE_COLOR
            )

            bodyColors.HeadColor = simpleBrickColor
            bodyColors.LeftArmColor = simpleBrickColor
            bodyColors.RightArmColor = simpleBrickColor
            bodyColors.LeftLegColor = simpleBrickColor
            bodyColors.RightLegColor = simpleBrickColor
            bodyColors.TorsoColor = simpleBrickColor

        end)
    end
end

--==================================================
-- ANTI SKIN COMPLETO
--==================================================

local function neutralizeAbnormalities(character)

    if not character then
        return
    end

    ------------------------------------------------
    -- HUMANOID
    ------------------------------------------------

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        simplifyHumanoid(humanoid)
    end

    ------------------------------------------------
    -- PRIMERA LIMPIEZA
    ------------------------------------------------

    simplifyAppearance(character)

    ------------------------------------------------
    -- SEGUNDA LIMPIEZA
    -- Evita que accesorios reaparecidos por
    -- ApplyDescription se mantengan.
    ------------------------------------------------

    task.delay(0.15, function()

        if not character
            or not character.Parent
            or not Config.AntiSkin then
            return
        end

        removeAccessories(character)
        simplifyAppearance(character)

    end)

end

--==================================================
-- ESCANEO DE JUGADORES
--==================================================

task.spawn(function()

    while true do

        task.wait(0.3)

        -- Si está apagado, no hace nada
        if not Config.AntiSkin then
            continue
        end

        for _, player in ipairs(Players:GetPlayers()) do

            if player ~= LocalPlayer
                and not Whitelist[player.Name] then

                local character = player.Character

                if character then
                    neutralizeAbnormalities(character)
                end

            end

        end

    end

end)

--==================================================
-- DETECTAR NUEVOS PERSONAJES
--==================================================

local function setupPlayer(player)

    if player == LocalPlayer then
        return
    end

    if Whitelist[player.Name] then
        return
    end

    player.CharacterAdded:Connect(function(character)

        if not Config.AntiSkin then
            return
        end

        -- Esperar a que cargue el personaje
        task.wait(0.5)

        if character and character.Parent then
            neutralizeAbnormalities(character)
        end

    end)

end

-- Jugadores actuales
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

-- Nuevos jugadores
Players.PlayerAdded:Connect(function(player)
    setupPlayer(player)
end)
