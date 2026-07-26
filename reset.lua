-- =========================== INSTA RESET FLOTANTE ===========================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local instaResetFloatingPos = nil

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not cursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
                cursedResetRemote = self
            end
            return oldFire(self, ...)
        end))
    end
end)

local function findCursedResetRemote()
    if cursedResetRemote then return end
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
            cursedResetRemote = desc
            return
        end
    end
end
task.spawn(function()
    task.wait(2)
    findCursedResetRemote()
end)

local function cursedInstaReset()
    if not cursedResetRemote then
        findCursedResetRemote()
        if not cursedResetRemote then return end
    end
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health <= 0 then
        pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
        return
    end
    local resetDetected = false
    local conns = {}
    if humanoid then
        table.insert(conns, humanoid.Died:Connect(function() resetDetected = true end))
        table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then resetDetected = true end
        end))
    end
    if character then
        table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
            if not parent then resetDetected = true end
        end))
    end
    task.spawn(function()
        for _ = 1, 50 do
            if resetDetected then break end
            pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
            task.wait()
        end
        for _, conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

-- Crear Interfaz Gráfica del Botón
local panel = Instance.new("ScreenGui")
panel.Name = "InstaResetButton"
panel.ResetOnSpawn = false
panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
panel.DisplayOrder = 20
pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
if not pcall(function() panel.Parent = CoreGui end) then
    panel.Parent = LP:WaitForChild("PlayerGui")
end

local btnFrame = Instance.new("Frame", panel)
btnFrame.Size = UDim2.new(0, 70, 0, 40)
btnFrame.Name = "Frame"
btnFrame.Position = UDim2.new(1, -90, 0.85, 0)
btnFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
btnFrame.BorderSizePixel = 0
btnFrame.ZIndex = 20

local uiCorner = Instance.new("UICorner", btnFrame)
uiCorner.CornerRadius = UDim.new(0, 8)

-- Borde Azul Neón más profundo y visible
local uiStroke = Instance.new("UIStroke", btnFrame)
uiStroke.Color = Color3.fromRGB(0, 130, 255)
uiStroke.Thickness = 2.5
uiStroke.Transparency = 0

local label = Instance.new("TextLabel", btnFrame)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "RESET"
-- Texto en BLANCO PURO para que resalte perfectamente
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBold
label.TextSize = 14
label.ZIndex = 21

local function setActive(state)
    if state then
        btnFrame.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btnFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Lógica para hacer el botón movible (Draggable) sin afectar los clics rápidos
local dragging = false
local hasMoved = false
local dragStart = nil
local startPos = nil
local dragThreshold = 5

btnFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        hasMoved = false
        dragStart = input.Position
        startPos = btnFrame.Position
    end
end)

local function onInputEnded(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            if not hasMoved then
                setActive(true)
                cursedInstaReset() -- Ejecuta la lógica exacta del hub
                task.delay(0.3, function()
                    if btnFrame and btnFrame.Parent then
                        setActive(false)
                    end
                end)
            end
            dragging = false
            hasMoved = false
        end
    end
end

btnFrame.InputEnded:Connect(onInputEnded)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
            hasMoved = true
        end
        if hasMoved then
            btnFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        onInputEnded(input)
    end
end)
-- ============================================================================
