-- [[ TOKITO AIMBOT LASER CAPA - PREMIUM BLUE EDITION (ANDROID) ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()

local AimbotEnabled = false
local Minimized = false
local CurrentTarget = nil

-- Lista de usuarios a ignorar (Puedes agregar más nombres aquí si lo necesitas)
local WhitelistedUsers = {
    ["Toki"] = true,
    ["Tokito"] = true
}

-- --- 1. CREACIÓN DE LA INTERFAZ PREMIUM ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TokitoLaserGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local success, result = pcall(function() return gethui() or game:GetService("CoreGui") end)
ScreenGui.Parent = success and result or game:GetService("CoreGui")

-- Marco Principal (Glassmorphism Oscuro)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 180, 0, 90)
MainFrame.Position = UDim2.new(0.5, -90, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Borde Neón Azul (UIStroke)
local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Transparency = 0.2

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 140, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Text = "Tokito Aimbot Laser Capa"
Title.TextColor3 = Color3.fromRGB(0, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Botón de Minimizar (_)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 8)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 12
MinimizeBtn.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local MinStroke = Instance.new("UIStroke")
MinStroke.Parent = MinimizeBtn
MinStroke.Color = Color3.fromRGB(0, 170, 255)
MinStroke.Thickness = 1

-- Botón Toggle (Aimbot OFF/ON)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 160, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 45)
ToggleBtn.Text = "AIMBOT: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent = ToggleBtn
ToggleStroke.Color = Color3.fromRGB(100, 100, 100)
ToggleStroke.Thickness = 1.5

-- --- 2. ANIMACIÓN RGB AZUL (Efecto de respiración) ---
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        -- Efecto de pulso en el borde cuando está encendido
        local timePos = tick() * 3
        local glow = math.abs(math.sin(timePos)) * 0.5 + 0.5
        MainStroke.Color = Color3.fromRGB(0, math.floor(150 * glow) + 100, 255)
        ToggleStroke.Color = Color3.fromRGB(0, math.floor(150 * glow) + 100, 255)
    else
        MainStroke.Color = Color3.fromRGB(0, 120, 200)
    end
end)

-- --- 3. SISTEMA DE ARRASTRE TÁCTIL (ANDROID) ---
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()  
            if input.UserInputState == Enum.UserInputState.End then  
                dragging = false  
            end  
        end)  
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- --- 4. LÓGICA DE LA INTERFAZ ---
MinimizeBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        MainFrame:TweenSize(UDim2.new(0, 180, 0, 40), "Out", "Quad", 0.2, true)
        ToggleBtn.Visible = false
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 180, 0, 90), "Out", "Quad", 0.2, true)
        ToggleBtn.Visible = true
        MinimizeBtn.Text = "—"
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        ToggleBtn.Text = "AIMBOT: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
        ToggleStroke.Color = Color3.fromRGB(0, 200, 255)
    else
        ToggleBtn.Text = "AIMBOT: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
        ToggleStroke.Color = Color3.fromRGB(100, 100, 100)
        CurrentTarget = nil
    end
end)

-- --- 5. BÚSQUEDA DEL OBJETIVO LÁSER (360 GRADOS) ---
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end

    local Target = nil  
    local ShortestDistance = math.huge  
      
    -- Obtenemos la posición de tu personaje para medir desde ahí  
    local MyCharacter = LocalPlayer.Character  
    local MyRoot = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")  

    for _, v in pairs(Players:GetPlayers()) do  
        -- Filtro principal: No ser tú mismo, estar vivo, y NO estar en la Whitelist (Revisa Nombre y DisplayName)
        if v ~= LocalPlayer and not WhitelistedUsers[v.Name] and not WhitelistedUsers[v.DisplayName] and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then  
              
            local Hitbox = v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("HumanoidRootPart")  
              
            if Hitbox and (v.Team ~= LocalPlayer.Team or v.Team == nil) then  
                if MyRoot then  
                    -- Calculamos la distancia 3D real entre tu personaje y el enemigo  
                    local Distance = (Hitbox.Position - MyRoot.Position).Magnitude  
                      
                    -- Selecciona al enemigo más cercano a ti, sin importar si lo miras o no  
                    if Distance < ShortestDistance then  
                        Target = Hitbox  
                        ShortestDistance = Distance  
                    end  
                end  
            end  
        end  
    end  
      
    CurrentTarget = Target
end)

-- --- 6. INTERCEPCIÓN DEL DISPARO (WALLBANG ACTIVADO) ---
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Args = {...}
    local Method = getnamecallmethod()

    if AimbotEnabled and CurrentTarget and not checkcaller() then  
        -- 1. Método antiguo (FindPartOnRay, FindPartOnRayWithIgnoreList, etc.)  
        if string.find(Method, "FindPartOnRay") then  
            -- WALLBANG: Falsificamos el resultado del impacto.   
            -- Ignoramos el cálculo físico y le devolvemos al juego directamente la pieza del objetivo.  
            return CurrentTarget, CurrentTarget.Position, Vector3.new(0, 1, 0), Enum.Material.Plastic  
              
        -- 2. Método moderno (workspace:Raycast)  
        elseif Method == "Raycast" then  
            local Origin = Args[1]  
            local Direction = (CurrentTarget.Position - Origin).Unit * 10000  
              
            -- WALLBANG: Creamos nuevos parámetros de Raycast.  
            -- Esto hace que las paredes se vuelvan transparentes para la bala,  
            -- obligando al rayo a interactuar ÚNICAMENTE con el personaje del objetivo.  
            local WallbangParams = RaycastParams.new()  
            WallbangParams.FilterType = Enum.RaycastFilterType.Include -- En motores viejos era Whitelist  
            WallbangParams.FilterDescendantsInstances = {CurrentTarget.Parent} -- El Character entero del objetivo  
            WallbangParams.IgnoreWater = true  
              
            Args[2] = Direction  
            Args[3] = WallbangParams  
              
            return OldNamecall(self, unpack(Args))  
        end  
    end  

    return OldNamecall(self, ...)
end))

local OldIndex
OldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Index)
    if AimbotEnabled and CurrentTarget and not checkcaller() then
        if self == Mouse then
            if Index == "Hit" or Index == "hit" then
                return CurrentTarget.CFrame
            elseif Index == "Target" or Index == "target" then
                return CurrentTarget
            end
        end
    end

    return OldIndex(self, Index)
end))
