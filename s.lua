_G.AIDS = true
_G.ISE = false
_G.ISA = 233
_G.SSV = 5
_G.ARL = true
_G.RIP = false
_G.togins = nil

local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

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

-- NUEVO: Velocidad deseada del jugador
local TARGET_SPEED = 18.5
local speedConnection = nil

-- NUEVO: Variables para guardar la posición segura
local lastSafeCFrame = nil

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
    
    -- SISTEMA ANTI-ATASCO: Comprobar si al volver estamos dentro de una pared
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
        
        -- Si estamos dentro de una pared, regresamos a la posición segura
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
            task.delay(0.3, function() if animTrack then animTrack:AdjustSpeed(math.huge) end end)
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
    
    -- GUARDAR POSICIÓN SEGURA ANTES DE ACTIVAR NOCLIP
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
                    if clone then clone.CanCollide = false end
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

-- NUEVO: Función para mantener siempre la velocidad en 18.5
local function setupSpeedLock()
    if speedConnection then speedConnection:Disconnect() end
    speedConnection = RunService.RenderStepped:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid.WalkSpeed = TARGET_SPEED
            end
        end
    end)
end

-- SE ELIMINÓ EL task.spawn() CON EL WHILE LOOP QUE CAUSABA EL BUG DEL NOCLIP ALEATORIO

LocalPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
    local isStealing = LocalPlayer:GetAttribute("Stealing")
    if isStealing then
        if _G.AIDS and _G.togins and not _G.ISE then
            -- Pequeño delay para que no sea instantáneo y rompa animaciones
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
    local camera = Workspace.CurrentCamera
    if camera and newChar then
        local h = newChar:FindFirstChildOfClass("Humanoid")
        if h then camera.CameraSubject = h; camera.CameraType = Enum.CameraType.Custom end
    end
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
setupAntiDie()
setupSpeedLock() -- Iniciar el bucle de velocidad al ejecutar el script
