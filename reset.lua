local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"

-- Auto-captura del remote
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
    -- Solo busca si no existe o si fue destruido
    if cursedResetRemote and cursedResetRemote.Parent then return end
    
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

local function forceInstaReset()
    -- 1. Intentar encontrar el remote siempre
    findCursedResetRemote()

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    -- 2. Fallback súper agresivo de Roblox (Asegura la muerte local sí o sí)
    if humanoid then
        pcall(function() humanoid.Health = 0 end)
    end
    if character then
        pcall(function() character:BreakJoints() end)
    end

    -- 3. Spam del remote SIN DETENERSE. 
    -- Mandar 15 señales garantiza que el servidor procese al menos una, sin importar el lag.
    task.spawn(function()
        for i = 1, 15 do
            if cursedResetRemote then
                pcall(function()
                    cursedResetRemote:FireServer(CURSED_RESET_GUID, LocalPlayer, "balloon")
                end)
            end
            task.wait(0.03) -- Pausa pequeñísima para no colapsar el juego, pero asegurar el envío
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

local btnButton = Instance.new("TextButton")
btnButton.Parent = resetPanel
btnButton.Size = UDim2.new(0, 28, 0, 28)
btnButton.Position = UDim2.new(1, -40, 0.9, 0)
btnButton.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
btnButton.BorderSizePixel = 0
btnButton.AutoButtonColor = false
btnButton.Text = "R"
btnButton.Font = Enum.Font.GothamBold
btnButton.TextSize = 11
btnButton.TextColor3 = Color3.new(1, 1, 1)

Instance.new("UICorner", btnButton).CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke", btnButton)
stroke.Color = Color3.new(1, 1, 1)
stroke.Thickness = 1.5

-- Sistema anti-doble clic para evitar errores
local isResetting = false

local function onButtonClick()
    if isResetting then return end
    isResetting = true

    -- Efecto visual
    btnButton.BackgroundColor3 = Color3.fromRGB(0, 90, 180)
    
    -- Ejecutar reseteo agresivo
    forceInstaReset()
    
    -- Restaurar botón rápidamente
    task.delay(0.2, function()
        if btnButton.Parent then
            btnButton.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
        end
        isResetting = false
    end)
end

-- Enlazamos 3 tipos distintos de detección de clics para asegurar 100% de precisión
btnButton.Activated:Connect(onButtonClick)
btnButton.MouseButton1Click:Connect(onButtonClick)
btnButton.TouchTap:Connect(onButtonClick)
