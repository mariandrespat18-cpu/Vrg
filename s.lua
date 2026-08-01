_G.AIDS = true
_G.ISE = false
_G.ISA = 233
_G.SSV = 5
_G.ARL = true
_G.RIP = false
_G.togins = nil
_G.TargetWalkSpeed = 18.5 -- Velocidad física del personaje al robar

local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local animPlaying = false
local tracks = {}
local clone, oldRoot, hip, connection
local folderConnections = {}
local serverGhosts = {}
local ghostEnabled = true
local lagbackCallCount = 0
local lagbackWindowStart = 0
local lastLagbackTime = 0
local errorOrbActive = false
local errorOrb = nil
local antiDieConnection = nil
local antiDieDisabled = false

local lastSafeCFrame = nil

-- ==========================================
-- UI DE VELOCIDAD SÚPER COMPACTA (ARRIBA IZQ)
-- ==========================================
local speedGuiName = "SpeedModUI_Compact"
if LocalPlayer.PlayerGui:FindFirstChild(speedGuiName) then
    LocalPlayer.PlayerGui[speedGuiName]:Destroy()
end

local speedGui = Instance.new("ScreenGui")
speedGui.Name = speedGuiName
speedGui.ResetOnSpawn = false
speedGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(0, 65, 0, 18)
bgFrame.Position = UDim2.new(0, 5, 0, 5)
bgFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
bgFrame.BackgroundTransparency = 0.2
bgFrame.BorderSizePixel = 0
bgFrame.Parent = speedGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 4)
uiCorner.Parent = bgFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(1, -6, 1, 0)
speedInput.Position = UDim2.new(0, 3, 0, 0)
speedInput.BackgroundTransparency = 1
speedInput.Text = tostring(_G.TargetWalkSpeed)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Font = Enum.Font.SourceSansBold
speedInput.TextSize = 12
speedInput.TextXAlignment = Enum.TextXAlignment.Left
speedInput.ClearTextOnFocus = false
speedInput.Parent = bgFrame

-- MODIFICACIÓN DE LA VELOCIDAD FÍSICA EN TIEMPO REAL (Solo si está robando)
speedInput:GetPropertyChangedSignal("Text"):Connect(function()
    local num = tonumber(speedInput.Text)
    if num then
        _G.TargetWalkSpeed = num
        if LocalPlayer:GetAttribute("Stealing") then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = _G.TargetWalkSpeed
            end
        end
    end
end)

-- ==========================================
-- INDICADOR RAINBOW SOBRE EL JUGADOR (CON VELOCIDAD REAL)
-- ==========================================
local rainbowGui = nil
local rainbowLabel = nil

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local currentSpeed = hum and hum.WalkSpeed or 16

        if not rainbowGui or not rainbowGui.Parent then
            rainbowGui = Instance.new("BillboardGui")
            rainbowGui.Name = "RainbowIndicator"
            rainbowGui.Size = UDim2.new(0, 120, 0, 30)
            rainbowGui.StudsOffset = Vector3.new(0, 2.5, 0)
            rainbowGui.AlwaysOnTop = true
            
            rainbowLabel = Instance.new("TextLabel", rainbowGui)
            rainbowLabel.Size = UDim2.new(1, 0, 1, 0)
            rainbowLabel.BackgroundTransparency = 1
            rainbowLabel.Font = Enum.Font.SourceSansBold
            rainbowLabel.TextSize = 13
            rainbowLabel.TextStrokeTransparency = 0.3
            rainbowLabel.TextColor3 = Color3.new(1,1,1)
            
            pcall(function()
                rainbowGui.Parent = CoreGui
            end)
            if not rainbowGui.Parent then
                rainbowGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            end
        end
        
        if rainbowGui and rainbowLabel then
            rainbowGui.Adornee = char.Head
            local hue = (tick() * (currentSpeed / 15)) % 1
            rainbowLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
            rainbowLabel.Text = "⚡ " .. tostring(currentSpeed) .. " ⚡"
        end
    else
        if rainbowGui then
            rainbowGui:Destroy()
            rainbowGui = nil
            rainbowLabel = nil
        end
    end
end)

-- ==========================================
-- BOTÓN RESET REDONDO, AZUL Y MUY PEQUEÑO
-- ==========================================
local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"

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
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health <= 0 then
        pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LocalPlayer, "balloon") end)
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
            pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LocalPlayer, "balloon") end)
            task.wait()
        end
        for _, conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

local resetPanel = Instance.new("ScreenGui")
resetPanel.Name = "InstaResetButton_Small"
resetPanel.ResetOnSpawn = false
resetPanel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
resetPanel.DisplayOrder = 20
pcall(function() if syn and syn.protect_gui then syn.protect_gui(resetPanel) end end)
if not pcall(function() resetPanel.Parent = CoreGui end) then
    resetPanel.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local btnFrame = Instance.new("Frame", resetPanel)
btnFrame.Size = UDim2.new(0, 28, 0, 28) -- Súper pequeño y redondo
btnFrame.Name = "Frame"
btnFrame.Position = UDim2.new(1, -40, 0.9, 0)
btnFrame.BackgroundColor3 = Color3.fromRGB(0, 130, 255) -- Azul
btnFrame.BorderSizePixel = 0
btnFrame.ZIndex = 20

local uiCorner2 = Instance.new("UICorner", btnFrame)
uiCorner2.CornerRadius = UDim.new(1, 0) -- Completamente circular

local uiStroke = Instance.new("UIStroke", btnFrame)
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 1.5
uiStroke.Transparency = 0.2

local labelReset = Instance.new("TextLabel", btnFrame)
labelReset.Size = UDim2.new(1, 0, 1, 0)
labelReset.BackgroundTransparency = 1
labelReset.Text = "R"
labelReset.TextColor3 = Color3.fromRGB(255, 255, 255)
labelReset.Font = Enum.Font.GothamBold
labelReset.TextSize = 11
labelReset.ZIndex = 21

local function setActive(state)
    if state then
        btnFrame.BackgroundColor3 = Color3.fromRGB(0, 90, 180)
    else
        btnFrame.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
    end
end

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
                cursedInstaReset()
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

-- ==========================================
-- FUNCIONES PRINCIPALES DEL SCRIPT
-- ==========================================
local function clearErrorOrb()
    if errorOrb and errorOrb.Parent then errorOrb:Destroy() end
    errorOrb = nil; errorOrbActive = false
end

local function createErrorOrb()
    if errorOrbActive then return end
    errorOrbActive = true
    for _, ghost in pairs(serverGhosts) do if ghost and ghost.Parent then ghost:Destroy() end end
    serverGhosts = {}
    local sg = Instance.new("ScreenGui")
    sg.Name = "ErrorOrbGui"; sg.ResetOnSpawn = false
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local fr = Instance.new("Frame")
    fr.Size = UDim2.new(0, 500, 0, 60)
    fr.Position = UDim2.new(0.5, -250, 0.3, 0)
    fr.BackgroundTransparency = 1; fr.BorderSizePixel = 0; fr.Parent = sg
    local l1 = Instance.new("TextLabel")
    l1.Size = UDim2.new(1, 0, 0.5, 0); l1.BackgroundTransparency = 1
    l1.Text = "ERROR CAUSED BY PLAYER DEATH"
    l1.TextColor3 = Color3.fromRGB(255, 0, 0)
    l1.Font = Enum.Font.SourceSansBold; l1.TextScaled = true; l1.Parent = fr
    local l2 = Instance.new("TextLabel")
    l2.Size = UDim2.new(1, 0, 0.5, 0); l2.Position = UDim2.new(0, 0, 0.5, 0)
    l2.BackgroundTransparency = 1; l2.Text = "MUST RESET TO FIX ERROR"
    l2.TextColor3 = Color3.fromRGB(255, 0, 0)
    l2.Font = Enum.Font.SourceSansBold; l2.TextScaled = true; l2.Parent = fr
    errorOrb = sg
end

local function createServerGhost(position)
    if not ghostEnabled or errorOrbActive then return end
    local now = tick()
    if now - lastLagbackTime < 0.05 then return end
    lastLagbackTime = now
    if now - lagbackWindowStart > 1 then lagbackCallCount = 0; lagbackWindowStart = now end
    lagbackCallCount = lagbackCallCount + 1
    if lagbackCallCount >= 7 then createErrorOrb(); return end
    for _, g in pairs(serverGhosts) do if g and g.Parent then g:Destroy() end end
    serverGhosts = {}
    local ghost = Instance.new("Part")
    ghost.Name = "LagbackGhost"; ghost.Shape = Enum.PartType.Ball
    ghost.Size = Vector3.new(3, 3, 3); ghost.Color = Color3.fromRGB(255, 0, 0)
    ghost.Material = Enum.Material.Glass; ghost.Transparency = 0.3
    ghost.CanCollide = false; ghost.Anchored = true; ghost.CastShadow = false
    ghost.Position = position + Vector3.new(0, 5, 0); ghost.Parent = Workspace.CurrentCamera
    table.insert(serverGhosts, ghost)
end

local function clearAllGhosts()
    for _, ghost in pairs(serverGhosts) do pcall(function() if ghost and ghost.Parent then ghost:Destroy() end end) end
    serverGhosts = {}; clearErrorOrb(); lagbackCallCount = 0; lastLagbackTime = 0
end

local function removeFolders()
    local pf = Workspace:FindFirstChild(LocalPlayer.Name)
    if not pf then return end
    local dr = pf:FindFirstChild("DoubleRig")
    if dr then
        local rr = dr:FindFirstChild("HumanoidRootPart") or dr:FindFirstChildWhichIsA("BasePart")
        if rr and ghostEnabled then createServerGhost(rr.Position) end
        dr:Destroy()
    end
    local cs = pf:FindFirstChild("Constraints")
    if cs then cs:Destroy() end
    local conn = pf.ChildAdded:Connect(function(child)
        if child.Name == "DoubleRig" then
            task.defer(function()
                local rr = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChildWhichIsA("BasePart")
                if rr and ghostEnabled then createServerGhost(rr.Position) end
                child:Destroy()
            end)
        elseif child.Name == "Constraints" then child:Destroy() end
    end)
    table.insert(folderConnections, conn)
end

local function doClone()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
        hip = character.Humanoid.HipHeight
        oldRoot = character:FindFirstChild("HumanoidRootPart")
        if not oldRoot or not oldRoot.Parent then return false end
        for _, c in pairs(oldRoot:GetChildren()) do
            if c:IsA("Attachment") and (c.Name:find("Beam") or c.Name:find("Attach")) then c:Destroy() end
        end
        for _, c in pairs(oldRoot:GetChildren()) do if c:IsA("Beam") then c:Destroy() end end
        local tmp = Instance.new("Model"); tmp.Parent = game
        character.Parent = tmp
        clone = oldRoot:Clone(); clone.Parent = character
        oldRoot.Parent = Workspace.CurrentCamera
        clone.CFrame = oldRoot.CFrame; character.PrimaryPart = clone
        character.Parent = Workspace
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == oldRoot then v.Part0 = clone end
                if v.Part1 == oldRoot then v.Part1 = clone end
            end
        end
        tmp:Destroy(); return true
    end
    return false
end

local function revertClone()
    local character = LocalPlayer.Character
    if not oldRoot or not oldRoot:IsDescendantOf(Workspace) or not character or character.Humanoid.Health <= 0 then return end
    local tmp = Instance.new("Model"); tmp.Parent = game
    character.Parent = tmp
    oldRoot.Parent = character; character.PrimaryPart = oldRoot
    character.Parent = Workspace; oldRoot.CanCollide = true
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("Weld") or v:IsA("Motor6D") then
            if v.Part0 == clone then v.Part0 = oldRoot end
            if v.Part1 == clone then v.Part1 = oldRoot end
        end
    end
    if clone then local p = clone.CFrame; clone:Destroy(); clone = nil; oldRoot.CFrame = p end
    
    if lastSafeCFrame then
        local params = OverlapParams.new()
        params.FilterDescendantsInstances = {character, Workspace.CurrentCamera}
        params.FilterType = Enum.RaycastFilterType.Exclude
        
        local partsInPlayer = Workspace:GetPartsInPart(oldRoot, params)
        local stuck = false
        for _, part in ipairs(partsInPlayer) do
            if part.CanCollide then
                stuck = true
                break
            end
        end
        
        if stuck then
            oldRoot.CFrame = lastSafeCFrame
        end
    end

    oldRoot = nil
    if character and character.Humanoid then character.Humanoid.HipHeight = hip end
    clearAllGhosts()
end

local function animationTrickery()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
        local anim = Instance.new("Animation")
        anim.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
        local humanoid = character.Humanoid
        local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
        local animTrack = animator:LoadAnimation(anim)
        animTrack.Priority = Enum.AnimationPriority.Action4
        animTrack:Play(0, 1, 0); anim:Destroy()
        table.insert(tracks, animTrack)
        animTrack.Stopped:Connect(function() if animPlaying then animationTrickery() end end)
        task.delay(0, function()
            animTrack.TimePosition = 0.7
            task.delay(0.3, function() if animTrack then animTrack:AdjustSpeed(1) end end)
        end)
    end
end

local function turnOff()
    clearAllGhosts()
    if not animPlaying then return end
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    animPlaying = false; _G.ISE = false
    for _, t in pairs(tracks) do pcall(function() t:Stop() end) end
    tracks = {}
    if connection then connection:Disconnect(); connection = nil end
    for _, c in ipairs(folderConnections) do if c then c:Disconnect() end end
    folderConnections = {}
    revertClone(); clearAllGhosts()
    if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
end

local function turnOn()
    if animPlaying then return end
    local character = LocalPlayer.Character
    if not character then return end
    
    if character.PrimaryPart then
        lastSafeCFrame = character.PrimaryPart.CFrame
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    animPlaying = true; _G.ISE = true
    tracks = {}; removeFolders()
    local success = doClone()
    if success then
        task.wait(0.05); animationTrickery()
        local lastSetPosition = nil; local skipFrames = 5
        connection = RunService.PreSimulation:Connect(function()
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 and oldRoot then
                local root = character.PrimaryPart or character:FindFirstChild("HumanoidRootPart")
                if root then
                    if skipFrames > 0 then skipFrames = skipFrames - 1; lastSetPosition = nil
                    elseif lastSetPosition and ghostEnabled then
                        local currentPos = oldRoot.Position
                        local jumpDist = (currentPos - lastSetPosition).Magnitude
                        if jumpDist > 3 and not _G.RIP then
                            lastSetPosition = nil; createServerGhost(currentPos)
                            if _G.ARL and _G.togins then
                                _G.RIP = true
                                task.spawn(function()
                                    pcall(_G.togins); task.wait(0.5)
                                    pcall(_G.togins); _G.RIP = false
                                end)
                            end
                        end
                    end
                    
                    if clone then clone.CanCollide = true end 
                    
                    for _, c in pairs(oldRoot:GetChildren()) do
                        if c:IsA("Attachment") or c:IsA("Beam") then c:Destroy() end
                    end
                    local rotAngle = _G.ISA
                    local sa = _G.SSV * 0.5
                    local cf = root.CFrame - Vector3.new(0, sa, 0)
                    oldRoot.CFrame = cf * CFrame.Angles(math.rad(rotAngle), 0, 0)
                    oldRoot.AssemblyLinearVelocity = root.AssemblyLinearVelocity
                    oldRoot.CanCollide = false
                    lastSetPosition = oldRoot.Position
                end
            end
        end)
    end
end

_G.togins = function()
    if animPlaying then turnOff() else turnOn() end
end

_G.invisible = function()
    _G.AIDS = true
end

_G.disableInvisible = function()
    _G.AIDS = false
    if _G.ISE and _G.togins then
        pcall(_G.togins)
    end
end

local function setupAntiDie()
    if antiDieDisabled then return end
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if antiDieConnection then antiDieConnection:Disconnect() end
    antiDieConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if antiDieDisabled then return end
        if humanoid.Health <= 0 then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

LocalPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
    local isStealing = LocalPlayer:GetAttribute("Stealing")
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    -- Ajustar la velocidad física (WalkSpeed) solo al robar
    if humanoid then
        humanoid.WalkSpeed = isStealing and _G.TargetWalkSpeed or 16
    end

    if isStealing then
        if _G.AIDS and _G.togins and not _G.ISE then
            task.delay(0.1, function()
                if LocalPlayer:GetAttribute("Stealing") and not _G.ISE then
                    pcall(_G.togins)
                end
            end)
        end
    else
        if _G.AIDS and _G.togins and _G.ISE then
            pcall(_G.togins)
        end
    end
end)

local function onCharacterAdded(newChar)
    clearAllGhosts(); lagbackCallCount = 0
    if oldRoot then pcall(function() oldRoot:Destroy() end); oldRoot = nil end
    if clone then pcall(function() clone:Destroy() end); clone = nil end
    animPlaying = false; _G.ISE = false
    task.wait(0.2)
    setupAntiDie()
    
    local humanoid = newChar:FindFirstChildOfClass("Humanoid")
    if humanoid and LocalPlayer:GetAttribute("Stealing") then
        humanoid.WalkSpeed = _G.TargetWalkSpeed
    end

    local camera = Workspace.CurrentCamera
    if camera and newChar then
        if humanoid then camera.CameraSubject = humanoid; camera.CameraType = Enum.CameraType.Custom end
    end
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
setupAntiDie()
