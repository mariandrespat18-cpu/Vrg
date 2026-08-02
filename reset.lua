local LocalPlayer = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not cursedResetRemote
                and typeof(self) == "Instance"
                and self:IsA("RemoteEvent")
                and self.Name:sub(1,3) == "RE/" then
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

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid and humanoid.Health <= 0 then
        pcall(function()
            cursedResetRemote:FireServer(CURSED_RESET_GUID, LocalPlayer, "balloon")
        end)
        return
    end

    local resetDetected = false
    local conns = {}

    if humanoid then
        table.insert(conns, humanoid.Died:Connect(function()
            resetDetected = true
        end))

        table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then
                resetDetected = true
            end
        end))
    end

    if character then
        table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
            if not parent then
                resetDetected = true
            end
        end))
    end

    task.spawn(function()
        for _ = 1, 50 do
            if resetDetected then break end

            pcall(function()
                cursedResetRemote:FireServer(CURSED_RESET_GUID, LocalPlayer, "balloon")
            end)

            task.wait()
        end

        for _, conn in ipairs(conns) do
            pcall(function()
                conn:Disconnect()
            end)
        end
    end)
end

-- ==========================================
-- INTERFAZ GRÁFICA (UI) - CORREGIDA
-- ==========================================

local resetPanel = Instance.new("ScreenGui")
resetPanel.Name = "InstaResetButton_Small"
resetPanel.ResetOnSpawn = false
resetPanel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
resetPanel.DisplayOrder = 20

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(resetPanel)
    end
end)

if not pcall(function()
    resetPanel.Parent = CoreGui
end) then
    resetPanel.Parent = LocalPlayer.PlayerGui
end

-- Usamos TextButton en lugar de Frame para tener clics 100% precisos
local btnButton = Instance.new("TextButton")
btnButton.Parent = resetPanel
btnButton.Size = UDim2.new(0, 28, 0, 28)
btnButton.Position = UDim2.new(1, -40, 0.9, 0)
btnButton.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
btnButton.BorderSizePixel = 0
btnButton.AutoButtonColor = false -- Apagamos el efecto por defecto para usar el nuestro
btnButton.Text = "R"
btnButton.Font = Enum.Font.GothamBold
btnButton.TextSize = 11
btnButton.TextColor3 = Color3.new(1, 1, 1)

Instance.new("UICorner", btnButton).CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke", btnButton)
stroke.Color = Color3.new(1, 1, 1)
stroke.Thickness = 1.5

-- Evento de clic nativo de Roblox (funciona perfecto en PC y Móvil sin fallar por movimiento)
btnButton.Activated:Connect(function()
    -- Efecto visual de presionado
    btnButton.BackgroundColor3 = Color3.fromRGB(0, 90, 180)
    
    -- Ejecuta la función principal
    cursedInstaReset()
    
    -- Regresa el color a la normalidad después de 0.3 segundos
    task.delay(0.3, function()
        if btnButton.Parent then
            btnButton.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
        end
    end)
end)
