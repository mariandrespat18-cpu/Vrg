local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    Workspace = game:GetService("Workspace"),
    GuiService = game:GetService("GuiService"),
    Debris = game:GetService("Debris")
}

local Players = Services.Players
local RunService = Services.RunService
local UserInputService = Services.UserInputService
local Workspace = Services.Workspace
local Debris = Services.Debris
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local isTpMoving = false
local cancelMovement = false

-- ==========================================
-- LÓGICA PARA ENCONTRAR EL MÁS VALIOSO
-- ==========================================
local function getBestPetData()
    local debris = Workspace:FindFirstChild("Debris")
    if not debris then return nil end

    local bestValue = -1
    local bestPet = nil

    for _, t in ipairs(debris:GetChildren()) do
        if t.Name == "FastOverheadTemplate" then
            local sg = t:FindFirstChildOfClass("SurfaceGui")
            if sg and sg.Adornee and sg.Adornee.Parent then
                local ownerLabel = sg:FindFirstChild("Owner", true)
                local owner = ownerLabel and ownerLabel.Text or ""

                if owner ~= LocalPlayer.Name then
                    local gen = sg:FindFirstChild("Generation", true)
                    if gen then
                        local txt = gen.Text or ""
                        local firstValue = txt:match("^%$([^%s]+)/s") or txt:match("^%$([^/]+)/s")

                        if firstValue then
                            local cleanText = firstValue:gsub(" ", "")
                            local multiplier = 1
                            local valueText = cleanText

                            if cleanText:find("T") then
                                multiplier = 1000000000000
                                valueText = cleanText:gsub("T", "")
                            elseif cleanText:find("B") then
                                multiplier = 1000000000
                                valueText = cleanText:gsub("B", "")
                            elseif cleanText:find("M") then
                                multiplier = 1000000
                                valueText = cleanText:gsub("M", "")
                            elseif cleanText:find("K") then
                                multiplier = 1000
                                valueText = cleanText:gsub("K", "")
                            end

                            local numValue = tonumber(valueText)
                            local earningValue = numValue and (numValue * multiplier) or 0

                            if earningValue > bestValue then
                                bestValue = earningValue

                                local plot, slot = "Unknown", "1"
                                local current = sg.Adornee

                                while current and current ~= Workspace do
                                    if current.Name == "AnimalPodiums" and current.Parent then
                                        slot = current.Name

                                        if current.Parent.Parent then
                                            plot = current.Parent.Parent.Name
                                        end

                                        break
                                    end

                                    current = current.Parent
                                end

                                bestPet = {
                                    part = sg.Adornee,
                                    plot = plot,
                                    slot = slot,
                                    value = earningValue
                                }
                            end
                        end
                    end
                end
            end
        end
    end

    return bestPet
end

-- ==========================================
-- PRIORIDAD DE HERRAMIENTAS
-- Cupid's Wings > Flying Carpet > otras
-- ==========================================
local function getAvailableTool()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack

    -- PRIORIDAD 1: Cupid's Wings
    if (char and char:FindFirstChild("Cupid's Wings"))
        or (backpack and backpack:FindFirstChild("Cupid's Wings")) then
        return "Cupid's Wings"
    end

    -- PRIORIDAD 2: Flying Carpet
    if (char and char:FindFirstChild("Flying Carpet"))
        or (backpack and backpack:FindFirstChild("Flying Carpet")) then
        return "Flying Carpet"
    end

    -- PRIORIDAD 3: Santa's Sleigh
    if (char and char:FindFirstChild("Santa's Sleigh"))
        or (backpack and backpack:FindFirstChild("Santa's Sleigh")) then
        return "Santa's Sleigh"
    end

    -- PRIORIDAD 4: Witch's Broom
    if (char and char:FindFirstChild("Witch's Broom"))
        or (backpack and backpack:FindFirstChild("Witch's Broom")) then
        return "Witch's Broom"
    end

    return nil
end

local function findAdorneeGlobal(animalData)
    if not animalData then return nil end

    if animalData.part and animalData.part.Parent then
        return animalData.part
    end

    return nil
end

local BASES_LOW = {
    [1] = Vector3.new(-460, -6, 219),
    [5] = Vector3.new(-355, -6, 217),
    [2] = Vector3.new(-460, -6, 111),
    [6] = Vector3.new(-355, -6, 113),
    [3] = Vector3.new(-460, -6, 5),
    [7] = Vector3.new(-355, -6, 5),
    [4] = Vector3.new(-460, -6, -100),
    [8] = Vector3.new(-355, -6, -100)
}

local BASES_HIGH = {
    [1] = Vector3.new(-476.474853515625, 20.732906341552734, 220.94090270996094),
    [2] = Vector3.new(-476.5684814453125, 20.70664405822754, 113.77315521240234),
    [3] = Vector3.new(-476.8675842285156, 20.74148178100586, 6.178487777709961),
    [4] = Vector3.new(-476.6324768066406, 20.74494934082031, -101.07275390625),
    [5] = Vector3.new(-342.5367126464844, 20.69801902770996, 221.44737243652344),
    [6] = Vector3.new(-342.8604736328125, 20.669641494750977, 113.41409301757812),
    [7] = Vector3.new(-342.42108154296875, 20.68766784667969, 6.249461650848389),
    [8] = Vector3.new(-342.7937927246094, 20.748071670532227, -99.73458862304688)
}

local CLONE_POSITIONS_FLOOR = {
    Vector3.new(-476, -4, 221),
    Vector3.new(-476, -4, 114),
    Vector3.new(-476, -4, 7),
    Vector3.new(-476, -4, -100),
    Vector3.new(-342, -4, -100),
    Vector3.new(-342, -4, 6),
    Vector3.new(-342, -4, 114),
    Vector3.new(-342, -4, 220)
}

local FACE_TARGETS = {
    Vector3.new(-519, -3, 221),
    Vector3.new(-519, -3, 114),
    Vector3.new(-518, -3, 7),
    Vector3.new(-519, -3, -100),
    Vector3.new(-301, -3, -100),
    Vector3.new(-301, -3, 7),
    Vector3.new(-302, -3, 114),
    Vector3.new(-300, -3, 220)
}

local function getClosestBaseIdx(pos)
    local closest, dist = 1, math.huge

    for i, basePos in pairs(BASES_LOW) do
        local d = (
            Vector2.new(pos.X, pos.Z)
            - Vector2.new(basePos.X, basePos.Z)
        ).Magnitude

        if d < dist then
            dist = d
            closest = i
        end
    end

    return closest
end

-- ==========================================
-- SISTEMA DE VUELO RÁPIDO
-- ==========================================
local function smoothFlyTo(targetPos, globalStart)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if not hrp then return end

    local at = Instance.new("Attachment", hrp)

    local lv = Instance.new("LinearVelocity", at)
    lv.Attachment0 = at
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.RelativeTo = Enum.ActuatorRelativeTo.World

    local ao = Instance.new("AlignOrientation", at)
    ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
    ao.Attachment0 = at
    ao.MaxTorque = math.huge
    ao.MaxAngularVelocity = math.huge
    ao.Responsiveness = 140

    while true do
        if cancelMovement then
            break
        end

        local currentPos = hrp.Position
        local distance = (currentPos - targetPos).Magnitude

        if distance <= 4 then
            break
        end

        if tick() - globalStart > 10 then
            break
        end

        if LocalPlayer:GetAttribute("Stealing") then
            break
        end

        local dir = (targetPos - currentPos).Unit

        if distance < 15 then
            lv.VectorVelocity = dir * 35
        else
            lv.VectorVelocity = dir * 200
        end

        ao.CFrame = CFrame.lookAt(
            currentPos,
            currentPos + Vector3.new(dir.X, 0, dir.Z)
        )

        RunService.Heartbeat:Wait()
    end

    lv:Destroy()
    ao:Destroy()
    at:Destroy()

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

local function walkForward(seconds)
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if not hum or not hrp then return end

    local lookVector = hrp.CFrame.LookVector
    local startTime = os.clock()
    local conn

    conn = RunService.RenderStepped:Connect(function()
        if os.clock() - startTime >= seconds or cancelMovement then
            conn:Disconnect()
            hum:Move(Vector3.zero, false)
            return
        end

        hum:Move(lookVector, false)
    end)
end

-- ==========================================
-- CLONACIÓN SEGURA MULTI-EVENTO
-- ==========================================
local function instantClone()
    if _G.isCloning then return end

    _G.isCloning = true

    local toolName = "Quantum Cloner"
    local char = LocalPlayer.Character

    if not char then
        _G.isCloning = false
        return
    end

    local tool =
        LocalPlayer.Backpack:FindFirstChild(toolName)
        or char:FindFirstChild(toolName)

    local hum = char:FindFirstChild("Humanoid")

    if tool and hum then
        hum:EquipTool(tool)

        task.wait(0.2)

        if cancelMovement then
            _G.isCloning = false
            return
        end

        tool:Activate()

        local cloneName = ("%*_Clone"):format(LocalPlayer.UserId)
        local cloneAppeared = false
        local timeout = 5
        local startTime = tick()

        while tick() - startTime < timeout do
            if cancelMovement then
                break
            end

            if workspace:FindFirstChild(cloneName) then
                cloneAppeared = true
                break
            end

            task.wait(0.1)
        end

        if cloneAppeared and not cancelMovement then
            task.wait(0.2)

            local pGui = LocalPlayer:FindFirstChild("PlayerGui")
            local tf = pGui and pGui:FindFirstChild("ToolsFrames")
            local qc = tf and tf:FindFirstChild("QuantumCloner")
            local tpButton = qc and qc:FindFirstChild("TeleportToClone")

            if tpButton and tpButton.Visible then
                local eventsToFire = {
                    "Activated",
                    "TouchTap",
                    "MouseButton1Click",
                    "MouseButton1Down",
                    "MouseButton1Up"
                }

                for _, eventName in ipairs(eventsToFire) do
                    pcall(function()
                        if getconnections and tpButton[eventName] then
                            for _, conn in pairs(getconnections(tpButton[eventName])) do
                                conn:Fire()
                            end
                        elseif firesignal and tpButton[eventName] then
                            firesignal(tpButton[eventName])
                        end
                    end)
                end
            end
        end
    end

    _G.isCloning = false
end

-- ==========================================
-- VERIFICACIÓN DE PLOT DESBLOQUEADO
-- ==========================================
_G._isTargetPlotUnlocked = function(plotName)
    local ok, res = pcall(function()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return false end

        local targetPlot = plots:FindFirstChild(plotName)
        if not targetPlot then return false end

        local unlockFolder = targetPlot:FindFirstChild("Unlock")
        if not unlockFolder then return true end

        local unlockItems = {}

        for _, item in pairs(unlockFolder:GetChildren()) do
            local pos = nil

            if item:IsA("Model") then
                pcall(function()
                    pos = item:GetPivot().Position
                end)
            elseif item:IsA("BasePart") then
                pos = item.Position
            end

            if pos then
                table.insert(unlockItems, {
                    Object = item,
                    Height = pos.Y
                })
            end
        end

        table.sort(unlockItems, function(a, b)
            return a.Height < b.Height
        end)

        if #unlockItems == 0 then
            return true
        end

        local floor1Door = unlockItems[1].Object

        for _, desc in ipairs(floor1Door:GetDescendants()) do
            if desc:IsA("ProximityPrompt") and desc.Enabled then
                return false
            end
        end

        for _, child in ipairs(floor1Door:GetChildren()) do
            if child:IsA("ProximityPrompt") and child.Enabled then
                return false
            end
        end

        return true
    end)

    return ok and res or false
end

-- ==========================================
-- MOVIMIENTO PRINCIPAL
-- ==========================================
local function executeMovement()
    local targetPetData = getBestPetData()
    if not targetPetData then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if not hrp or not hum or hum.Health <= 0 then
        return
    end

    local globalStart = tick()

    local targetPart = findAdorneeGlobal(targetPetData)
    if not targetPart then
        return
    end

    local exactPos = targetPart.Position

    -- ==========================================
    -- SELECCIÓN DE HERRAMIENTA
    -- Cupid's Wings primero.
    -- Flying Carpet solo si no existe Cupid's Wings.
    -- ==========================================
    local toolName = getAvailableTool()

    if not toolName then
        return
    end

    local tool =
        LocalPlayer.Backpack:FindFirstChild(toolName)
        or char:FindFirstChild(toolName)

    if not tool then
        return
    end

    hum:EquipTool(tool)

    task.wait(0.01)

    if cancelMovement then
        return
    end

    local isSecondFloor = exactPos.Y > 10
    local plotIndex = getClosestBaseIdx(exactPos)
    local targetBasePos =
        isSecondFloor
        and BASES_HIGH[plotIndex]
        or BASES_LOW[plotIndex]

    -- ==========================================
    -- 1. VUELA HACIA LA BASE
    -- ==========================================
    smoothFlyTo(targetBasePos, globalStart)

    if tick() - globalStart > 10 or cancelMovement then
        return
    end

    -- ==========================================
    -- PLATAFORMA DE SOPORTE PARA SEGUNDO PISO
    -- ==========================================
    if isSecondFloor then
        local supportPlatform = Instance.new("Part")

        supportPlatform.Size = Vector3.new(12, 1, 12)
        supportPlatform.Anchored = true
        supportPlatform.CanCollide = true
        supportPlatform.Transparency = 1
        supportPlatform.Position = hrp.Position - Vector3.new(0, 3.2, 0)
        supportPlatform.Parent = Workspace

        Debris:AddItem(supportPlatform, 6)
    end

    -- ==========================================
    -- POSICIÓN DE CLONACIÓN EN PRIMER PISO
    -- ==========================================
    if not isSecondFloor then
        local bestSpot = CLONE_POSITIONS_FLOOR[1]
        local minDst = math.huge

        for _, v in ipairs(CLONE_POSITIONS_FLOOR) do
            local d = (targetPart.Position - v).Magnitude

            if d < minDst then
                minDst = d
                bestSpot = v
            end
        end

        smoothFlyTo(bestSpot, globalStart)

        if tick() - globalStart > 10 or cancelMovement then
            return
        end
    end

    -- ==========================================
    -- 2. ORIENTAR PERSONAJE
    -- ==========================================
    local bestFace = FACE_TARGETS[1]
    local minFaceDist = math.huge

    for _, v in ipairs(FACE_TARGETS) do
        local d = (hrp.Position - v).Magnitude

        if d < minFaceDist then
            minFaceDist = d
            bestFace = v
        end
    end

    hrp.CFrame = CFrame.lookAt(
        hrp.Position,
        Vector3.new(bestFace.X, hrp.Position.Y, bestFace.Z)
    )

    -- ==========================================
    -- 3. CAMINAR Y CLONAR
    -- ==========================================
    if isSecondFloor or not _G._isTargetPlotUnlocked(targetPetData.plot) then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        task.wait(0.05)

        if cancelMovement then
            return
        end

        walkForward(0.4)

        task.wait(0.4)

        if cancelMovement then
            return
        end

        instantClone()

        task.wait(0.3)

        if cancelMovement then
            return
        end
    end

    if tick() - globalStart > 10 or cancelMovement then
        return
    end

    -- ==========================================
    -- ASEGURAR HERRAMIENTA SELECCIONADA
    -- Cupid's Wings sigue teniendo prioridad
    -- ==========================================
    local currentToolName = getAvailableTool()

    if currentToolName then
        local currentTool =
            LocalPlayer.Backpack:FindFirstChild(currentToolName)
            or char:FindFirstChild(currentToolName)

        if currentTool then
            hum:EquipTool(currentTool)
            tool = currentTool
        end
    end

    -- ==========================================
    -- 4. VUELO FINAL A LA MASCOTA
    -- ==========================================
    local finalPos = targetPart.Position + Vector3.new(0, 3, 0)

    smoothFlyTo(finalPos, globalStart)

    if cancelMovement then
        return
    end

    -- ==========================================
    -- PLATAFORMA FINAL PARA SEGUNDO PISO
    -- ==========================================
    if exactPos.Y > 10 then
        local platform = Instance.new("Part")

        platform.Size = Vector3.new(6, 0.5, 6)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Material = Enum.Material.Neon
        platform.Color = Color3.fromRGB(0, 85, 255)
        platform.Position = hrp.Position - Vector3.new(0, 3.2, 0)
        platform.Parent = Workspace

        Debris:AddItem(platform, 4)
    end

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    task.wait(0.05)

    hum:UnequipTools()

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

-- ==========================================
-- INTERFAZ (BOTÓN)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPButton"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local button = Instance.new("TextButton")
button.Name = "TpBestButton"
button.Text = "Tp Best"
button.Size = UDim2.new(0, 60, 0, 30)
button.Position = UDim2.new(1, -30, 0.5, -95)
button.AnchorPoint = Vector2.new(1, 0.5)
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.Parent = screenGui

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

local dragging = false
local dragInput
local dragStart
local startPos

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = button.Position
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart

        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

button.MouseButton1Click:Connect(function()
    if isTpMoving then
        cancelMovement = true
    else
        isTpMoving = true
        cancelMovement = false
        button.BackgroundColor3 = Color3.fromRGB(40, 200, 40)

        task.spawn(function()
            executeMovement()

            isTpMoving = false
            cancelMovement = false
            button.BackgroundColor3 = Color3.new(0, 0, 0)
        end)
    end
end)
