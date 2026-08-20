if getgenv().TokitoHub then
    pcall(function()
        local oldGui = game:GetService("CoreGui"):FindFirstChild("TokitoHub")
        if oldGui then
            oldGui:Destroy()
        end

        local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local oldPlayerGui = playerGui:FindFirstChild("TokitoHub")
            if oldPlayerGui then
                oldPlayerGui:Destroy()
            end
        end
    end)

    getgenv().TokitoHub = nil
end

getgenv().TokitoHub = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local CONFIG_FILE = "TokitoHubConfig.json"
local Config = {}

local function saveConfig()
	if not writefile then
		return
	end

	pcall(function()
		writefile(CONFIG_FILE, HttpService:JSONEncode(Config))
	end)
end

local function loadConfig()
	if not (isfile and readfile and isfile(CONFIG_FILE)) then
		return {}
	end

	local ok, data = pcall(function()
		return readfile(CONFIG_FILE)
	end)

	if not ok or type(data) ~= "string" then
		return {}
	end

	local ok2, decoded = pcall(function()
		return HttpService:JSONDecode(data)
	end)

	if ok2 and type(decoded) == "table" then
		return decoded
	end

	return {}
end

Config = loadConfig()

-- valor por defecto
if Config.SkipIntro == nil then
	Config.SkipIntro = false
end

local function shouldSkipIntro()
	return getgenv().TokitoHubSkipIntro == true or Config.SkipIntro == true
end

-- Firebase
local FIREBASE_URL = "https://httpcustom-65ce3-default-rtdb.firebaseio.com/comandos.json"
local POLL_INTERVAL = 1
local ultimaRespuesta = nil

local function verificarComandos()
	local success, response = pcall(function()
		return game:HttpGet(FIREBASE_URL, true)
	end)

	if not success or not response or response == "null" then
		return
	end

	-- Ignorar la primera lectura al iniciar el script
	if ultimaRespuesta == nil then
		ultimaRespuesta = response
		return
	end

	-- Si no cambió el contenido, no hacer nada
	if response == ultimaRespuesta then
		return
	end

	ultimaRespuesta = response

	local ok, data = pcall(function()
		return HttpService:JSONDecode(response)
	end)

	if not ok or type(data) ~= "table" then
		return
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	if data.accion == "velocidad" and type(data.valor) == "number" then
		humanoid.WalkSpeed = data.valor

	elseif data.accion == "reset_character" then
		humanoid.Health = 0

	elseif data.accion == "reset" then
		humanoid.WalkSpeed = 16
	end
end

task.spawn(function()
	while true do
		verificarComandos()
		task.wait(POLL_INTERVAL)
	end
end)
local ICON_URL = "https://raw.githubusercontent.com/mariandrespat18-cpu/Tokito-/main/file_00000000cbcc71f595c773a9e5cd4d90.png"

local function getIcon()
local path = "TokitoHubIcon.png"

local httpRequest = (syn and syn.request) or http_request or request  
if getcustomasset and isfile and writefile and httpRequest then  
	pcall(function()  
		if not isfile(path) then  
			local res = httpRequest({  
				Url = ICON_URL,  
				Method = "GET"  
			})  
			if res and res.Body then  
				writefile(path, res.Body)  
			end  
		end  
	end)  

	local okFile = pcall(function()  
		return isfile(path)  
	end)  

	if okFile and isfile(path) then  
		local okAsset, asset = pcall(function()  
			return getcustomasset(path)  
		end)  
		if okAsset and asset then  
			return asset  
		end  
	end  
end  

return ICON_URL

end

local ICON = getIcon()

local gui = Instance.new("ScreenGui")
gui.Name = "TokitoHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = game:GetService("CoreGui")

local splash = Instance.new("Frame")
splash.Name = "Splash"
splash.Size = UDim2.new(0, 320, 0, 120)
splash.Position = UDim2.new(0.5, -160, 0.18, 0)
splash.BackgroundColor3 = Color3.fromRGB(10, 18, 32)
splash.BorderSizePixel = 0
splash.Parent = gui
Instance.new("UICorner", splash).CornerRadius = UDim.new(0, 14)

local splashStroke = Instance.new("UIStroke")
splashStroke.Thickness = 2
splashStroke.Transparency = 0.05
splashStroke.Parent = splash

local splashGrad = Instance.new("UIGradient")
splashGrad.Rotation = 0
splashGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 85, 255)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 170, 255)),
ColorSequenceKeypoint.new(0.50, Color3.fromRGB(40, 120, 255)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 200, 255)),
ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 85, 255)),
})
splashGrad.Parent = splash

local splashText = Instance.new("TextLabel")
splashText.BackgroundTransparency = 1
splashText.Size = UDim2.new(1, -20, 1, -20)
splashText.Position = UDim2.new(0, 10, 0, 10)
splashText.Text = "Script creado por Tokito"
splashText.TextColor3 = Color3.fromRGB(255, 255, 255)
splashText.Font = Enum.Font.GothamBold
splashText.TextSize = 24
splashText.TextWrapped = true
splashText.Parent = splash

local splashSub = Instance.new("TextLabel")
splashSub.BackgroundTransparency = 1
splashSub.Size = UDim2.new(1, -20, 0, 24)
splashSub.Position = UDim2.new(0, 10, 1, -32)
splashSub.Text = "Tokito Hub "
splashSub.TextColor3 = Color3.fromRGB(170, 220, 255)
splashSub.Font = Enum.Font.Gotham
splashSub.TextSize = 14
splashSub.Parent = splash

local function createMenu()
local border = Instance.new("Frame")
border.Name = "Border"
border.Size = UDim2.new(0, 250, 0, 175)
border.Position = UDim2.new(0.35, 0, 0.3, 0)
border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
border.BorderSizePixel = 0
border.Parent = gui
Instance.new("UICorner", border).CornerRadius = UDim.new(0, 12)

local borderStroke = Instance.new("UIStroke")  
borderStroke.Thickness = 2  
borderStroke.Transparency = 0.02  
borderStroke.Parent = border  

local borderGradient = Instance.new("UIGradient")  
borderGradient.Rotation = 0  
borderGradient.Color = ColorSequence.new({  
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 70, 220)),  
	ColorSequenceKeypoint.new(0.20, Color3.fromRGB(0, 120, 255)),  
	ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 185, 255)),  
	ColorSequenceKeypoint.new(0.60, Color3.fromRGB(40, 110, 255)),  
	ColorSequenceKeypoint.new(0.80, Color3.fromRGB(80, 200, 255)),  
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 70, 220)),  
})  
borderGradient.Parent = border  

local frame = Instance.new("Frame")  
frame.Name = "Main"  
frame.Size = UDim2.new(1, -4, 1, -4)  
frame.Position = UDim2.new(0, 2, 0, 2)  
frame.BackgroundColor3 = Color3.fromRGB(14, 18, 30)  
frame.BorderSizePixel = 0  
frame.ClipsDescendants = true  
frame.Parent = border  
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)  

local frameStroke = Instance.new("UIStroke")  
frameStroke.Thickness = 1  
frameStroke.Transparency = 0.78  
frameStroke.Color = Color3.fromRGB(255, 255, 255)  
frameStroke.Parent = frame  

local topbar = Instance.new("Frame")  
topbar.Name = "Topbar"  
topbar.Size = UDim2.new(1, 0, 0, 30)  
topbar.BackgroundColor3 = Color3.fromRGB(18, 28, 45)  
topbar.BorderSizePixel = 0  
topbar.Active = true  
topbar.Parent = frame  
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 10)  

local topbarFix = Instance.new("Frame")  
topbarFix.Size = UDim2.new(1, 0, 0, 10)  
topbarFix.Position = UDim2.new(0, 0, 1, -10)  
topbarFix.BackgroundColor3 = topbar.BackgroundColor3  
topbarFix.BorderSizePixel = 0  
topbarFix.Parent = topbar  

local topGlow = Instance.new("Frame")  
topGlow.Size = UDim2.new(1, 0, 0, 2)  
topGlow.Position = UDim2.new(0, 0, 1, -2)  
topGlow.BackgroundColor3 = Color3.fromRGB(0, 170, 255)  
topGlow.BorderSizePixel = 0  
topGlow.Parent = topbar  

local topGlowGrad = Instance.new("UIGradient")  
topGlowGrad.Color = ColorSequence.new({  
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 110, 255)),  
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(120, 220, 255)),  
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 70, 220)),  
})  
topGlowGrad.Parent = topGlow  

local title = Instance.new("TextLabel")  
title.Size = UDim2.new(1, -68, 1, 0)  
title.Position = UDim2.new(0, 8, 0, 0)  
title.BackgroundTransparency = 1  
title.Text = "Tokito Hub"  
title.TextColor3 = Color3.fromRGB(255, 255, 255)  
title.Font = Enum.Font.GothamBold  
title.TextSize = 14  
title.TextXAlignment = Enum.TextXAlignment.Left  
title.Parent = topbar  

local minimizeBtn = Instance.new("TextButton")  
minimizeBtn.Size = UDim2.new(0, 22, 0, 18)  
minimizeBtn.Position = UDim2.new(1, -48, 0, 6)  
minimizeBtn.BackgroundColor3 = Color3.fromRGB(28, 46, 78)  
minimizeBtn.Text = "—"  
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
minimizeBtn.Font = Enum.Font.GothamBold  
minimizeBtn.TextSize = 16  
minimizeBtn.BorderSizePixel = 0  
minimizeBtn.Parent = topbar  
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)  

local closeBtn = Instance.new("TextButton")  
closeBtn.Size = UDim2.new(0, 22, 0, 18)  
closeBtn.Position = UDim2.new(1, -24, 0, 6)  
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 28, 55)  
closeBtn.Text = "X"  
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
closeBtn.Font = Enum.Font.GothamBold  
closeBtn.TextSize = 12  
closeBtn.BorderSizePixel = 0  
closeBtn.Parent = topbar  
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)  

local scroll = Instance.new("ScrollingFrame")  
scroll.Name = "Menu"  
scroll.Size = UDim2.new(1, -8, 1, -36)  
scroll.Position = UDim2.new(0, 4, 0, 34)  
scroll.BackgroundTransparency = 1  
scroll.BorderSizePixel = 0  
scroll.ScrollBarThickness = 4  
scroll.ScrollingDirection = Enum.ScrollingDirection.Y  
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y  
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)  
scroll.Parent = frame  

local padding = Instance.new("UIPadding")  
padding.PaddingTop = UDim.new(0, 4)  
padding.PaddingBottom = UDim.new(0, 4)  
padding.PaddingLeft = UDim.new(0, 2)  
padding.PaddingRight = UDim.new(0, 2)  
padding.Parent = scroll  

local layout = Instance.new("UIListLayout")  
layout.Padding = UDim.new(0, 5)  
layout.SortOrder = Enum.SortOrder.LayoutOrder  
layout.Parent = scroll  

local function addHover(btn)  
	btn.MouseEnter:Connect(function()  
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(36, 58, 95)}):Play()  
	end)  
	btn.MouseLeave:Connect(function()  
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(24, 34, 52)}):Play()  
	end)  
end  

local function createToggle(name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(24, 34, 52)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.BorderSizePixel = 0
	btn.Parent = scroll

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	addHover(btn)

	local state = Config[name] == true
	btn.Text = name .. (state and " [ON]" or " [OFF]")

	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = name .. (state and " [ON]" or " [OFF]")
		Config[name] = state
		saveConfig()
		pcall(callback, state)
	end)

	if state then
		task.defer(function()
			pcall(callback, true)
		end)
	end
end  
local function createButton(name, callback)
	local btn = Instance.new("TextButton")

	btn.Size = UDim2.new(1,0,0,30)
	btn.BackgroundColor3 = Color3.fromRGB(24,34,52)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.Text = name
	btn.BorderSizePixel = 0
	btn.Parent = scroll

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

	addHover(btn)

	btn.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
end

local antiLagEnabled = false  
local antiLagConn  
local savedLighting = nil  
local savedTerrainDecoration = nil  
local savedObjects = {}  

local function saveProp(obj, prop)  
	savedObjects[obj] = savedObjects[obj] or {}  
	if savedObjects[obj][prop] == nil then  
		local ok, val = pcall(function()  
			return obj[prop]  
		end)  
		if ok then  
			savedObjects[obj][prop] = val  
		end  
	end  
end  

local function restoreProp(obj, prop)  
	local data = savedObjects[obj]  
	if not data then return end  
	if data[prop] == nil then return end  
	pcall(function()  
		obj[prop] = data[prop]  
	end)  
end  

local function applyAntiLagObject(obj, state)  
	if state then  
		if obj:IsA("ParticleEmitter") then  
			saveProp(obj, "Enabled")  
			pcall(function() obj.Enabled = false end)  
		elseif obj:IsA("Smoke") then  
			saveProp(obj, "Enabled")  
			pcall(function() obj.Enabled = false end)  
		elseif obj:IsA("Fire") then  
			saveProp(obj, "Enabled")  
			pcall(function() obj.Enabled = false end)  
		elseif obj:IsA("Sparkles") then  
			saveProp(obj, "Enabled")  
			pcall(function() obj.Enabled = false end)  
		elseif obj:IsA("Beam") then  
			saveProp(obj, "Enabled")  
			pcall(function() obj.Enabled = false end)  
		elseif obj:IsA("Trail") then  
			saveProp(obj, "Enabled")  
			pcall(function() obj.Enabled = false end)  
		elseif obj:IsA("Highlight") then  
			saveProp(obj, "Enabled")  
			pcall(function() obj.Enabled = false end)  
		elseif obj:IsA("Light") then  
			saveProp(obj, "Enabled")  
			pcall(function() obj.Enabled = false end)  
		elseif obj:IsA("Decal") or obj:IsA("Texture") then  
			saveProp(obj, "Transparency")  
			pcall(function() obj.Transparency = 1 end)  
		elseif obj:IsA("BasePart") then  
			saveProp(obj, "CastShadow")  
			pcall(function() obj.CastShadow = false end)  
		elseif obj:IsA("PostEffect") then  
			saveProp(obj, "Enabled")  
			pcall(function() obj.Enabled = false end)  
		end  
	else  
		if obj:IsA("ParticleEmitter") then  
			restoreProp(obj, "Enabled")  
		elseif obj:IsA("Smoke") then  
			restoreProp(obj, "Enabled")  
		elseif obj:IsA("Fire") then  
			restoreProp(obj, "Enabled")  
		elseif obj:IsA("Sparkles") then  
			restoreProp(obj, "Enabled")  
		elseif obj:IsA("Beam") then  
			restoreProp(obj, "Enabled")  
		elseif obj:IsA("Trail") then  
			restoreProp(obj, "Enabled")  
		elseif obj:IsA("Highlight") then  
			restoreProp(obj, "Enabled")  
		elseif obj:IsA("Light") then  
			restoreProp(obj, "Enabled")  
		elseif obj:IsA("Decal") or obj:IsA("Texture") then  
			restoreProp(obj, "Transparency")  
		elseif obj:IsA("BasePart") then  
			restoreProp(obj, "CastShadow")  
		elseif obj:IsA("PostEffect") then  
			restoreProp(obj, "Enabled")  
		end  
	end  
end  

local function applyLightingAntiLag(state)  
	local terrain = Workspace:FindFirstChildOfClass("Terrain")  

	if state then  
		savedLighting = savedLighting or {  
			GlobalShadows = Lighting.GlobalShadows,  
			Brightness = Lighting.Brightness,  
			Ambient = Lighting.Ambient,  
			OutdoorAmbient = Lighting.OutdoorAmbient,  
			ShadowSoftness = Lighting.ShadowSoftness,  
			EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,  
			EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,  
			FogEnd = Lighting.FogEnd,  
			FogStart = Lighting.FogStart,  
		}  

		pcall(function() Lighting.GlobalShadows = false end)  
		pcall(function() Lighting.Brightness = 1 end)  
		pcall(function() Lighting.Ambient = Color3.fromRGB(120, 120, 120) end)  
		pcall(function() Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120) end)  
		pcall(function() Lighting.ShadowSoftness = 0 end)  
		pcall(function() Lighting.EnvironmentDiffuseScale = 0 end)  
		pcall(function() Lighting.EnvironmentSpecularScale = 0 end)  
		pcall(function() Lighting.FogStart = 0 end)  
		pcall(function() Lighting.FogEnd = 100000 end)  

		if terrain then  
			if savedTerrainDecoration == nil then  
				pcall(function()  
					savedTerrainDecoration = terrain.Decoration  
				end)  
			end  
			pcall(function()  
				terrain.Decoration = false  
			end)  
		end  
	else  
		if savedLighting then  
			for prop, val in pairs(savedLighting) do  
				pcall(function()  
					Lighting[prop] = val  
				end)  
			end  
		end  

		if terrain and savedTerrainDecoration ~= nil then  
			pcall(function()  
				terrain.Decoration = savedTerrainDecoration  
			end)  
		end  
	end  
end  

  -- ============================================================
-- ANTIRAGDOLL V2 TOGGLE SYSTEM
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

do
    local ScriptLoaded = false

    local function SetAntiRagdollV2(state)
        State.AntiRagdollV2Enabled = state

        if state then
            if not ScriptLoaded then
                ScriptLoaded = true

                pcall(function()
                    loadstring(game:HttpGet("https://pastefy.app/ZqWdbCDe/raw"))()
                end)
            end
        end
    end

    -- Toggle en la interfaz
    createToggle("AntiRagdoll V2", function(state)
        SetAntiRagdollV2(state)
    end)
end

local ANTI_RAGDOLL = {}

local antiRagdollMode = nil
local cachedCharData = {}
local ragdollConnections = {}

local function cacheCharacterData()
    local char = game.Players.LocalPlayer.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end

    cachedCharData = {
        character = char,
        humanoid = hum,
        root = root,
        originalWalkSpeed = hum.WalkSpeed,
        originalJumpPower = hum.JumpPower,
    }

    return true
end

local function disconnectAll()
    for _, conn in ipairs(ragdollConnections) do
        if typeof(conn) == "RBXScriptConnection" then
            pcall(function()
                conn:Disconnect()
            end)
        end
    end
    ragdollConnections = {}
end

local function isRagdolled()
    if not cachedCharData.humanoid then return false end

    local hum = cachedCharData.humanoid
    local state = hum:GetState()

    if state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown then
        return true
    end

    local endTime = game.Players.LocalPlayer:GetAttribute("RagdollEndTime")
    if endTime then
        local now = workspace:GetServerTimeNow()
        if (endTime - now) > 0 then
            return true
        end
    end

    return false
end

local function removeRagdollConstraints()
    if not cachedCharData.character then return end

    for _, descendant in ipairs(cachedCharData.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint")
            or (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            pcall(function()
                descendant:Destroy()
            end)
        end
    end
end

local function forceExitRagdoll()
    if not cachedCharData.humanoid or not cachedCharData.root then return end

    local hum = cachedCharData.humanoid
    local root = cachedCharData.root

    pcall(function()
        game.Players.LocalPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)

    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    root.Anchored = false
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

local function setupCameraBinding()
    local conn = game:GetService("RunService").RenderStepped:Connect(function()
        if antiRagdollMode ~= "v1" then return end

        local cam = workspace.CurrentCamera
        if cam and cachedCharData.humanoid and cam.CameraSubject ~= cachedCharData.humanoid then
            cam.CameraSubject = cachedCharData.humanoid
        end
    end)

    table.insert(ragdollConnections, conn)
end

local function v1HeartbeatLoop()
    while antiRagdollMode == "v1" and cachedCharData.humanoid do
        task.wait()

        if isRagdolled() then
            removeRagdollConstraints()
            forceExitRagdoll()
        end
    end
end

function ANTI_RAGDOLL.Enable(mode)
    if mode ~= "v1" then return end
    if antiRagdollMode == mode then return end

    ANTI_RAGDOLL.Disable()

    if not cacheCharacterData() then return end

    antiRagdollMode = mode

    local charConn = game.Players.LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if antiRagdollMode and cacheCharacterData() then
            setupCameraBinding()
            task.spawn(v1HeartbeatLoop)
        end
    end)

    table.insert(ragdollConnections, charConn)

    setupCameraBinding()
    task.spawn(v1HeartbeatLoop)
end

function ANTI_RAGDOLL.Disable()
    if not antiRagdollMode then return end

    antiRagdollMode = nil
    disconnectAll()
    cachedCharData = {}
end

---------------------------------------------------------
-- INTERFAZ GRÁFICA (GUI) COMPACTA Y ARRASTRABLE
---------------------------------------------------------

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

createToggle("Anti Ragdoll", function(state)
    if state then
        ANTI_RAGDOLL.Enable("v1")
    else
        ANTI_RAGDOLL.Disable()
    end
end)
local instantEnabled = false  
local instantConn  

local function applyInstant(v)  
	if v:IsA("ProximityPrompt") then  
		v.HoldDuration = 0  
	end  
end  

createToggle("Comprar al instante", function(state)  
	instantEnabled = state  

	if instantConn then  
		instantConn:Disconnect()  
		instantConn = nil  
	end  

	if state then  
		for _, v in ipairs(game:GetDescendants()) do  
			applyInstant(v)  
		end  

		instantConn = game.DescendantAdded:Connect(function(v)  
			if instantEnabled then  
				applyInstant(v)  
			end  
		end)  
	end  
end)

local autoClickEnabled = false
local autoClickConns = {}

local function isBuyPrompt(prompt)
local action = string.lower(prompt.ActionText or "")
local object = string.lower(prompt.ObjectText or "")

return action:find("compr") or action:find("purchase") or action:find("buy")  
	or object:find("compr") or object:find("purchase") or object:find("buy")

end

local function spamPrompt(prompt)
task.spawn(function()
while autoClickEnabled and prompt and prompt.Parent do
if prompt.Enabled and isBuyPrompt(prompt) then
pcall(function()
fireproximityprompt(prompt)
end)
end
task.wait(0.1)
end
end)
end

local function connectPrompt(prompt)
if prompt:IsA("ProximityPrompt") then
local conn = prompt.PromptShown:Connect(function()
if autoClickEnabled and isBuyPrompt(prompt) then
spamPrompt(prompt)
end
end)

table.insert(autoClickConns, conn)  
end

end

createToggle("Auto Comprar", function(state)  
	autoClickEnabled = state  

	for _, c in ipairs(autoClickConns) do  
		c:Disconnect()  
	end  
	autoClickConns = {}  

	if state then  
		for _, v in ipairs(game:GetDescendants()) do  
			connectPrompt(v)  
		end  

		table.insert(autoClickConns, game.DescendantAdded:Connect(function(v)  
			connectPrompt(v)  
		end))  
	end  
end)  

local freezeEnabled = false  
local freezeConn  
local saved = {}  

local function setFreeze(state)  
	freezeEnabled = state  

	local player = Players.LocalPlayer  
	if not player or not player.Character then return end  

	local char = player.Character or player.CharacterAdded:Wait()  
	local humanoid = char:FindFirstChildOfClass("Humanoid")  
	local root = char:FindFirstChild("HumanoidRootPart")  

	if not humanoid or not root then return end  

	if state then  
		saved.WalkSpeed = humanoid.WalkSpeed  
		saved.JumpPower = humanoid.JumpPower  
		saved.AutoRotate = humanoid.AutoRotate  

		humanoid.WalkSpeed = 0  
		humanoid.JumpPower = 0  
		humanoid.AutoRotate = false  

		root.Anchored = true  

		freezeConn = RunService.Heartbeat:Connect(function()  
			if root and root.Parent then  
				root.Velocity = Vector3.zero  
				root.RotVelocity = Vector3.zero  
			end  
		end)  
	else  
		if humanoid then  
			humanoid.WalkSpeed = saved.WalkSpeed or 16  
			humanoid.JumpPower = saved.JumpPower or 50  
			humanoid.AutoRotate = saved.AutoRotate ~= false  
		end  

		if root then  
			root.Anchored = false  
		end  

		if freezeConn then  
			freezeConn:Disconnect()  
			freezeConn = nil  
		end  
	end  
end  

createToggle("Freeze (Beta)", function(state)  
	setFreeze(state)  
end)

-- ============================================================
-- TOKITO AUTO-GRAB MANUAL (SELECCIÓN PERSISTENTE)
-- ============================================================
do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UIS = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local WorkspaceService = game:GetService("Workspace")
	local LP = Players.LocalPlayer

	getgenv().SharedState = getgenv().SharedState or {}
	getgenv().Config = getgenv().Config or { AutoStealEnabled = false }
	getgenv().TokitoMenuPos = getgenv().TokitoMenuPos or UDim2.new(0.5, -100, 0.5, -115)

	local systemActive = false
	local internalAutoStealEnabled = getgenv().Config.AutoStealEnabled
	local selectedPetData = nil
	local autoGrabBusy = false
	local mainGui = nil
	local connections = {}

	local function addConnection(conn)
		table.insert(connections, conn)
	end

	local stopAutoGrabSystem

	local function isMyPlot(plot)
		if not plot then return false end
		local success, result = pcall(function()
			local sign = plot:FindFirstChild("PlotSign")
			if sign then
				local yourBase = sign:FindFirstChild("YourBase")
				if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then return true end
			end
			return false
		end)
		return success and result
	end

	local function isValidGrabPrompt(prompt)
		if not prompt or not prompt.Parent or not prompt.Enabled then return false end
		local state = tostring(prompt:GetAttribute("State") or ""):lower()
		local action = tostring(prompt.ActionText or ""):lower()
		return state == "steal" or state == "grab" or action == "steal" or action == "grab"
	end

	local function firePromptConnections(prompt, signalName)
		local success, conns = pcall(function() return getconnections(prompt[signalName]) end)
		if success and conns then
			for _, conn in ipairs(conns) do
				if conn.Function then task.spawn(conn.Function) end
			end
		end
	end

	local function executeGrab(prompt)
		if autoGrabBusy or not prompt or not prompt.Parent or not prompt.Enabled then return end
		autoGrabBusy = true
		pcall(function()
			firePromptConnections(prompt, "PromptButtonHoldBegan")
			task.wait(1.30)
			if prompt and prompt.Parent and prompt.Enabled then
				firePromptConnections(prompt, "Triggered")
			end
		end)
		autoGrabBusy = false
	end

	local function findExactPrompt(partPos)
		local plots = WorkspaceService:FindFirstChild("Plots")
		if not plots then return nil end

		local closestPrompt = nil
		local minDistance = 30 
		
		pcall(function()
			for _, plot in ipairs(plots:GetChildren()) do
				if not isMyPlot(plot) then
					local podiums = plot:FindFirstChild("AnimalPodiums")
					if podiums then
						for _, podium in ipairs(podiums:GetChildren()) do
							local base = podium:FindFirstChild("Base")
							local spawnPart = base and base:FindFirstChild("Spawn")
							local att = spawnPart and spawnPart:FindFirstChild("PromptAttachment")
							if att then
								for _, obj in ipairs(att:GetChildren()) do
									if obj:IsA("ProximityPrompt") and isValidGrabPrompt(obj) then
										local dist = (partPos - att.WorldPosition).Magnitude
										if dist < minDistance then
											minDistance = dist
											closestPrompt = obj
										end
									end
								end
							end
						end
					end
				end
			end
		end)
		return closestPrompt
	end

	local function isAnimalValid(part)  
		if not part or typeof(part) ~= "Instance" then return false end  
		if not part.Parent or not part:IsDescendantOf(WorkspaceService) then return false end  
		if part.Position.Y < -500 then return false end  
		return true  
	end  

	local function parseAnimalData(part)  
		local success, result = pcall(function()  
			if not isAnimalValid(part) then return nil end  
			local animalOverhead = part:FindFirstChild("AnimalOverhead")  
			if not animalOverhead or not animalOverhead:IsA("SurfaceGui") then return nil end  

			local generationLabel = animalOverhead:FindFirstChild("Generation")  
			local displayNameLabel = animalOverhead:FindFirstChild("DisplayName")  
			if not generationLabel or not displayNameLabel then return nil end  

			local generationText = generationLabel.Text or ""  
			local animalName = displayNameLabel.Text or "Unknown"  
			if generationText == "" or animalName == "" then return nil end  

			local firstValue = generationText:match("^%$([^%s]+)/s") or generationText:match("^%$([^/]+)/s") or generationText:match("%$([^%s]+)")  
			if not firstValue then return nil end  

			local cleanText = firstValue:gsub(" ", "")  
			local multiplier = 1  
			local value = cleanText  

			if cleanText:find("T") then multiplier = 1000000000000; value = cleanText:gsub("T", "")  
			elseif cleanText:find("B") then multiplier = 1000000000; value = cleanText:gsub("B", "")  
			elseif cleanText:find("M") then multiplier = 1000000; value = cleanText:gsub("M", "")  
			elseif cleanText:find("K") then multiplier = 1000; value = cleanText:gsub("K", "") end  

			local numValue = tonumber(value)  
			return {  
				mpsValue = numValue and (numValue * multiplier) or 0,  
				name = animalName,  
				mpsText = generationText  
			}  
		end)  
		return success and result or nil  
	end  

	local function get_all_pets()  
		local out = {}  
		local debris = WorkspaceService:FindFirstChild("Debris")  
		if not debris then return out end  

		pcall(function()  
			for _, part in ipairs(debris:GetChildren()) do  
				if part.Name == "FastOverheadTemplate" and part:IsA("BasePart") then  
					local data = parseAnimalData(part)  
					if data then  
						local exactPrompt = findExactPrompt(part.Position)
						if exactPrompt then 
							table.insert(out, {  
								name = data.name,  
								mpsText = data.mpsText,  
								mpsValue = data.mpsValue,  
								uid = part, 
								prompt = exactPrompt
							})  
						end
					end  
				end  
			end  
		end)  

		table.sort(out, function(a, b) return (a.mpsValue or 0) > (b.mpsValue or 0) end)  
		return out  
	end  

	local function tweenColor(object, color, time)  
		pcall(function()
			TweenService:Create(object, TweenInfo.new(time or 0.2), {BackgroundColor3 = color}):Play()  
		end)
	end  

	local function startAutoGrabSystem()
		if systemActive then return end
		
		if getgenv().DisableAutoGrabBeta then
			getgenv().DisableAutoGrabBeta()
		end

		systemActive = true
		
		local playerGui = LP:WaitForChild("PlayerGui", 5)
		if not playerGui then return end

		local oldGui = playerGui:FindFirstChild("TokitoAutoGrabGUI")  
		if oldGui then oldGui:Destroy() end  

		mainGui = Instance.new("ScreenGui", playerGui)  
		mainGui.Name = "TokitoAutoGrabGUI"  
		mainGui.ResetOnSpawn = false  
		mainGui.IgnoreGuiInset = true  
		mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling  

		local frame = Instance.new("Frame", mainGui)  
		frame.Name = "MainFrame"  
		frame.Size = UDim2.new(0, 200, 0, 230)  
		frame.Position = getgenv().TokitoMenuPos  
		frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  
		frame.BorderSizePixel = 0  
		frame.Active = true  
		frame.ClipsDescendants = true  
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)  

		local gradient = Instance.new("UIGradient", frame)  
		gradient.Color = ColorSequence.new{  
			ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 18, 24)),  
			ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 10, 14))  
		}  
		gradient.Rotation = 45  

		local stroke = Instance.new("UIStroke", frame)  
		stroke.Color = Color3.fromRGB(0, 162, 255)  
		stroke.Thickness = 1.2  
		stroke.Transparency = 0.3  

		local header = Instance.new("Frame", frame)  
		header.Size = UDim2.new(1, 0, 0, 26)  
		header.BackgroundColor3 = Color3.fromRGB(22, 27, 36)  
		header.BackgroundTransparency = 0.3  
		header.BorderSizePixel = 0  

		local title = Instance.new("TextLabel", header)  
		title.Size = UDim2.new(1, -8, 1, 0)  
		title.Position = UDim2.new(0, 8, 0, 0)  
		title.BackgroundTransparency = 1  
		title.Font = Enum.Font.GothamBold  
		title.Text = "Tokito AutoGrab Manual"  
		title.TextColor3 = Color3.fromRGB(0, 195, 255)  
		title.TextSize = 11  
		title.TextXAlignment = Enum.TextXAlignment.Left  

		local dragging, dragInput, dragStart, startPos  
		addConnection(header.InputBegan:Connect(function(input)  
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
				dragging = true  
				dragStart = input.Position  
				startPos = frame.Position  
				local changedConn; changedConn = input.Changed:Connect(function()  
					if input.UserInputState == Enum.UserInputState.End then   
						dragging = false   
						getgenv().TokitoMenuPos = frame.Position  
						changedConn:Disconnect()
					end  
				end)  
			end  
		end))  
		
		addConnection(header.InputChanged:Connect(function(input)  
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then  
				dragInput = input  
			end  
		end))  
		
		addConnection(UIS.InputChanged:Connect(function(input)  
			if input == dragInput and dragging then  
				local delta = input.Position - dragStart  
				frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)  
			end  
		end))  

		local toggleBtn = Instance.new("TextButton", frame)  
		toggleBtn.Size = UDim2.new(1, -12, 0, 22)  
		toggleBtn.Position = UDim2.new(0, 6, 0, 31)  
		toggleBtn.BackgroundColor3 = internalAutoStealEnabled and Color3.fromRGB(0, 140, 220) or Color3.fromRGB(30, 35, 45)  
		toggleBtn.Font = Enum.Font.GothamBold  
		toggleBtn.Text = internalAutoStealEnabled and "AUTO-GRAB: ON" or "AUTO-GRAB: OFF"  
		toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
		toggleBtn.TextSize = 10  
		toggleBtn.AutoButtonColor = false  
		Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 5)  

		addConnection(toggleBtn.MouseButton1Click:Connect(function()  
			internalAutoStealEnabled = not internalAutoStealEnabled  
			getgenv().Config.AutoStealEnabled = internalAutoStealEnabled  
			toggleBtn.Text = internalAutoStealEnabled and "AUTO-GRAB: ON" or "AUTO-GRAB: OFF"  
			tweenColor(toggleBtn, internalAutoStealEnabled and Color3.fromRGB(0, 140, 220) or Color3.fromRGB(30, 35, 45))  
		end))

		local scroll = Instance.new("ScrollingFrame", frame)  
		scroll.Size = UDim2.new(1, -12, 0, 134)  
		scroll.Position = UDim2.new(0, 6, 0, 57)  
		scroll.BackgroundTransparency = 1  
		scroll.BorderSizePixel = 0  
		scroll.ScrollBarThickness = 3  
		scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)  
		scroll.Active = true
		scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y 
		scroll.CanvasSize = UDim2.new(0, 0, 0, 0) 

		local listLayout = Instance.new("UIListLayout", scroll)  
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder  
		listLayout.Padding = UDim.new(0, 3)  

		local statusLabel = Instance.new("TextLabel", frame)  
		statusLabel.Size = UDim2.new(1, -12, 0, 24)  
		statusLabel.Position = UDim2.new(0, 6, 1, -27)  
		statusLabel.BackgroundColor3 = Color3.fromRGB(10, 12, 16)  
		statusLabel.Font = Enum.Font.Gotham  
		statusLabel.Text = "Seleccionado: Ninguno"  
		statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)  
		statusLabel.TextSize = 9  
		statusLabel.TextTruncate = Enum.TextTruncate.AtEnd  
		Instance.new("UICorner", statusLabel).CornerRadius = UDim.new(0, 5)  

		-- Sistema de persistencia: El animal seleccionado NO se deselecciona solo, a menos que sea destruido/eliminado del juego o deseleccionado manualmente.
		task.spawn(function()  
			while systemActive and task.wait(0.1) do  
				if selectedPetData then  
					local isStillAlive = selectedPetData.uid 
						and selectedPetData.uid.Parent 
						and selectedPetData.uid:IsDescendantOf(WorkspaceService) 
						and selectedPetData.uid.Position.Y > -500

					if not isStillAlive then  
						selectedPetData = nil  
						getgenv().SharedState.SelectedPetData = nil  
						statusLabel.Text = "Seleccionado: Ninguno"  
					else  
						-- Si el prompt se recargó o cambió de posición temporalmente, lo re-vinculamos sin perder la selección
						if not selectedPetData.prompt or not selectedPetData.prompt.Parent or not selectedPetData.prompt.Enabled then
							local newPrompt = findExactPrompt(selectedPetData.uid.Position)
							if newPrompt then
								selectedPetData.prompt = newPrompt
							end
						end

						if internalAutoStealEnabled then  
							getgenv().SharedState.SelectedPetData = selectedPetData  
						else  
							getgenv().SharedState.SelectedPetData = nil  
						end  
					end  
				else  
					getgenv().SharedState.SelectedPetData = nil  
				end  
			end  
		end)  

		task.spawn(function()
			while systemActive and task.wait(0.1) do
				if internalAutoStealEnabled and not autoGrabBusy then
					if getgenv().SharedState.SelectedPetData and getgenv().SharedState.SelectedPetData.prompt then
						executeGrab(getgenv().SharedState.SelectedPetData.prompt)    
					end
				end
			end
		end)

		task.spawn(function()  
			while systemActive and task.wait(0.5) do  
				if not mainGui or not mainGui.Parent then break end  
				  
				pcall(function()  
					for _, item in ipairs(scroll:GetChildren()) do  
						if item:IsA("TextButton") then item:Destroy() end  
					end  

					local pets = get_all_pets()  

					for _, pet in ipairs(pets) do  
						local isSelected = (selectedPetData and selectedPetData.uid == pet.uid)  
						  
						local petBtn = Instance.new("TextButton", scroll)  
						petBtn.Size = UDim2.new(1, -6, 0, 20)  
						petBtn.BackgroundColor3 = isSelected and Color3.fromRGB(0, 100, 180) or Color3.fromRGB(24, 28, 38)  
						petBtn.Font = Enum.Font.GothamMedium  
						petBtn.Text = string.format(" %s - %s", pet.name, pet.mpsText)  
						petBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)  
						petBtn.TextSize = 9  
						petBtn.TextXAlignment = Enum.TextXAlignment.Left  
						petBtn.TextTruncate = Enum.TextTruncate.AtEnd
						petBtn.AutoButtonColor = false  
						Instance.new("UICorner", petBtn).CornerRadius = UDim.new(0, 4)  

						petBtn.MouseButton1Click:Connect(function()  
							if isSelected then  
								selectedPetData = nil  
								getgenv().SharedState.SelectedPetData = nil
								statusLabel.Text = "Seleccionado: Ninguno"  
							else  
								selectedPetData = pet 
								getgenv().SharedState.SelectedPetData = pet
								statusLabel.Text = "Seleccionado: " .. pet.name  
							end  
						end)  
					end  
				end)  
			end  
		end)
	end

	stopAutoGrabSystem = function()
		systemActive = false
		selectedPetData = nil
		getgenv().SharedState.SelectedPetData = nil
		
		for _, conn in ipairs(connections) do
			if typeof(conn) == "RBXScriptConnection" then
				conn:Disconnect()
			end
		end
		table.clear(connections)

		if mainGui then
			mainGui:Destroy()
			mainGui = nil
		end
	end

	getgenv().DisableAutoGrabManual = stopAutoGrabSystem

	if type(createToggle) == "function" then
		createToggle("AutoGrab Manual", function(state)
			if state then
				startAutoGrabSystem()
			else
				stopAutoGrabSystem()
			end
		end)
	end
end
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

local CONFIG = {
    AUTO_STEAL_ENABLED = true, -- Activado por defecto para uso independiente
    HOLD_MIN = 1.3,
    HOLD_MAX = 2.6,
    ENTRY_DELAY = 0.3,
    COOLDOWN = 0.05,
    STEAL_RANGE = 9,
    PRIME_RANGE = 80,
}

local StealState = {
    active = false,
    startTime = 0,
    phase = "idle",
    label = "",
    lastResult = "",
    lastResultTime = 0,
    totalSteals = 0,
    failedSteals = 0,
}

local plots = workspace:WaitForChild("Plots")
local AnimalsData = {}
local syncRemotes = nil
local plotAnimalSync = { caches = {}, connections = {} }
local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local stealConnection = nil

local function splitSyncPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do
        table.insert(out, tonumber(part) or part)
    end
    return out
end

local function resolveSyncPath(path, root)
    local current = root
    local parent = nil
    local key = nil
    for _, part in ipairs(splitSyncPath(path)) do
        parent = current
        key = part
        current = current and current[part] or nil
    end
    return current, parent, key
end

local function applyPlotSyncDiff(channelName, packet)
    local cache = plotAnimalSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = resolveSyncPath(path, cache)
    if action == "Changed" then
        if parent ~= nil then parent[key] = a end
    elseif action == "ArrayInsert" then
        if current ~= nil then table.insert(current, b, a) end
    elseif action == "ArrayRemoved" then
        if current ~= nil then table.remove(current, b) end
    elseif action == "DictionaryInsert" then
        if current ~= nil then current[b] = a end
    elseif action == "DictionaryRemoved" then
        if current ~= nil then current[b] = nil end
    end
end

local function attachPlotChannel(remote)
    if plotAnimalSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
        local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
        if ok and typeof(data) == "table" then
            plotAnimalSync.caches[channelName] = data
        else
            plotAnimalSync.caches[channelName] = {}
        end
    elseif plotAnimalSync.caches[channelName] == nil then
        plotAnimalSync.caches[channelName] = {}
    end
    plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do
            applyPlotSyncDiff(channelName, packet)
        end
    end)
end

local function detachPlotChannel(channelName)
    for remote, conn in pairs(plotAnimalSync.connections) do
        if tostring(remote.Name) == tostring(channelName) then
            conn:Disconnect()
            plotAnimalSync.connections[remote] = nil
            plotAnimalSync.caches[tostring(channelName)] = nil
            break
        end
    end
end

local function getPlotChannelData(plotName)
    return plotAnimalSync.caches[plotName]
end

local function getPlotOwner(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    return getPlotOwner(plot) == LP.DisplayName
end

local function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = PromptMemoryCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local attach = spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            PromptMemoryCache[animalData.uid] = p
            return p
        end
    end
    return nil
end

local function getAnimalPosition(animalData)
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    return podium:GetPivot().Position
end

local function distToAnimal(animalData)
    local character = LP.Character
    if not character then return math.huge end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return math.huge end
    local pos = getAnimalPosition(animalData)
    if not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end

local function pickClosest()
    local character = LP.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(allAnimalsCache) do
        if isMyBaseAnimal(animalData) then continue end
        local pos = getAnimalPosition(animalData)
        if not pos then continue end
        local dist = (hrp.Position - pos).Magnitude
        if dist > CONFIG.PRIME_RANGE then continue end
        if dist < bestDist then
            bestDist = dist
            best = animalData
        end
    end
    return best
end

local function scanAllPlots()
    local newCache = {}
    for _, plot in ipairs(plots:GetChildren()) do
        local cache = getPlotChannelData(plot.Name)
        if not cache then continue end
        local animalList = cache.AnimalList
        if typeof(animalList) ~= "table" then continue end
        for slot, animalData in pairs(animalList) do
            if type(animalData) == "table" then
                local animalName = animalData.Index
                local animalInfo = AnimalsData[animalName]
                if not animalInfo then continue end
                table.insert(newCache, {
                    name = animalInfo.DisplayName or animalName,
                    plot = plot.Name,
                    slot = tostring(slot),
                    uid = plot.Name .. "_" .. tostring(slot),
                })
            end
        end
    end
    allAnimalsCache = newCache
    return #allAnimalsCache
end

local function buildStealCallbacks(prompt)
    if InternalStealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
        InternalStealCache[prompt] = data
    end
end

local function executeStealAsync(prompt, animalData)
    local data = InternalStealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    local label = animalData.name or "Animal"
    StealState.active = true
    StealState.startTime = tick()
    StealState.phase = "holding"
    StealState.label = label
    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do
            task.spawn(fn)
        end
        task.wait(CONFIG.HOLD_MIN)
        StealState.phase = "waitingRange"
        local alreadyInRange = distToAnimal(animalData) <= CONFIG.STEAL_RANGE
        local fired = false
        while true do
            local elapsed = tick() - StealState.startTime
            if elapsed > CONFIG.HOLD_MAX then break end
            if not prompt.Parent then break end
            if distToAnimal(animalData) <= CONFIG.STEAL_RANGE then
                if not alreadyInRange then task.wait(CONFIG.ENTRY_DELAY) end
                for _, fn in ipairs(data.triggerCallbacks) do
                    task.spawn(fn)
                end
                fired = true
                break
            end
            task.wait()
        end
        if fired then
            StealState.totalSteals = StealState.totalSteals + 1
            StealState.lastResult = "Stole " .. label
        else
            StealState.failedSteals = StealState.failedSteals + 1
            StealState.lastResult = "Missed window: " .. label
        end
        StealState.active = false
        StealState.phase = "idle"
        StealState.lastResultTime = tick()
        task.wait(CONFIG.COOLDOWN)
        data.ready = true
    end)
    return true
end

local function attemptSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    buildStealCallbacks(prompt)
    if not InternalStealCache[prompt] then return false end
    return executeStealAsync(prompt, animalData)
end

function startAutoSteal()
    if stealConnection then return end
    stealConnection = RunService.Heartbeat:Connect(function()
        if not CONFIG.AUTO_STEAL_ENABLED then return end
        if StealState.active then return end
        local target = pickClosest()
        if not target then return end
        local prompt = PromptMemoryCache[target.uid]
        if not prompt or not prompt.Parent then
            prompt = findProximityPromptForAnimal(target)
        end
        if prompt then
            attemptSteal(prompt, target)
        end
    end)
end

function stopAutoSteal()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    StealState.active = false
    StealState.phase = "idle"
end

-- Initialization & Event Connections
do
    local Packages = ReplicatedStorage:WaitForChild("Packages")
    local Datas = ReplicatedStorage:WaitForChild("Datas")
    AnimalsData = require(Datas:WaitForChild("Animals"))
    local folder = Packages:WaitForChild("Synchronizer")
    
    syncRemotes = {
        channelFolder = folder:WaitForChild("Channel"),
        routeRemote = folder:WaitForChild("CommunicationRoute"),
        requestData = folder:FindFirstChild("RequestData"),
    }
    
    for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then
            attachPlotChannel(child)
        end
    end
    
    syncRemotes.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then
            attachPlotChannel(child)
        end
    end)
    
    syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
        for _, action in ipairs(actions) do
            local kind, channelName = action[1], tostring(action[2])
            if not plots:FindFirstChild(channelName) then continue end
            if kind == "ListenerAdded" then
                local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
                if remote and remote:IsA("RemoteEvent") then
                    attachPlotChannel(remote)
                end
            elseif kind == "ListenerRemoved" then
                detachPlotChannel(channelName)
            end
        end
    end)
    scanAllPlots()
end

task.spawn(function()
    while task.wait(5) do
        scanAllPlots()
    end
end)

-- ============================================================
-- AUTO GRAB V2 TOGGLE
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

createToggle("AutoGrab V2", function(state)
    State.AutoGrabV2Enabled = state
    CONFIG.AUTO_STEAL_ENABLED = state

    if state then
        startAutoSteal()
    else
        stopAutoSteal()
    end
end)


-- ============================================================
-- AUTO GRAB (BETA) (CON EXCLUSIÓN MUTUA)
-- ============================================================
do
	local Players = game:GetService("Players")
	local WorkspaceService = game:GetService("Workspace")

	local autoGrabEnabled = false
	local autoGrabBusy = false
	local autoGrabLoop = nil

	local stopAutoGrabBeta -- Declaración anticipada

	local function isMyPlot(plot)
		if not plot then return false end
		local sign = plot:FindFirstChild("PlotSign")  
		if sign then  
			local yourBase = sign:FindFirstChild("YourBase")  
			if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then  
				return true  
			end  
		end  
		return false
	end

	local function getRootPart()
		local char = Players.LocalPlayer.Character
		return char and (  
			char:FindFirstChild("HumanoidRootPart")  
			or char:FindFirstChild("UpperTorso")  
		)
	end

	local function isValidGrabPrompt(prompt)
		if not prompt or not prompt.Parent or not prompt.Enabled then
			return false
		end
		local state = tostring(prompt:GetAttribute("State") or ""):lower()  
		local action = tostring(prompt.ActionText or ""):lower()  
		return state == "steal" or state == "grab" or action == "steal" or action == "grab"
	end

	local function getNearestGrabPrompt()
		local root = getRootPart()
		if not root then return nil end  

		local nearestPrompt = nil  
		local minDistance = 150  
		local plots = WorkspaceService:FindFirstChild("Plots")  
		if not plots then return nil end  

		for _, plot in ipairs(plots:GetChildren()) do  
			if isMyPlot(plot) then continue end  

			local podiums = plot:FindFirstChild("AnimalPodiums")  
			if podiums then  
				for _, podium in ipairs(podiums:GetChildren()) do  
					local base = podium:FindFirstChild("Base")  
					local spawn = base and base:FindFirstChild("Spawn")  
					local attachment = spawn and spawn:FindFirstChild("PromptAttachment")  

					if attachment then  
						for _, obj in ipairs(attachment:GetChildren()) do  
							if obj:IsA("ProximityPrompt") and isValidGrabPrompt(obj) then  
								local dist = (root.Position - obj.Parent.WorldPosition).Magnitude  
								if dist < minDistance then  
									minDistance = dist  
									nearestPrompt = obj  
								end  
							end  
						end  
					end  
				end  
			end  
		end  
		return nearestPrompt
	end

	local function firePromptConnections(prompt, signalName)
		local success, connections = pcall(function()
			return getconnections(prompt[signalName])
		end)
		if success and connections then  
			for _, conn in ipairs(connections) do  
				if conn.Function then  
					task.spawn(conn.Function)  
				end  
			end  
		end
	end

	local function executeGrab(prompt)
		if autoGrabBusy or not prompt or not prompt.Parent then return end
		autoGrabBusy = true  
		firePromptConnections(prompt, "PromptButtonHoldBegan")  
		task.wait(1.30)  
		if prompt and prompt.Parent and prompt.Enabled then  
			firePromptConnections(prompt, "Triggered")  
		end  
		autoGrabBusy = false
	end

	stopAutoGrabBeta = function()
		autoGrabEnabled = false
		if autoGrabLoop then  
			task.cancel(autoGrabLoop)  
			autoGrabLoop = nil  
		end
	end

	-- Exponer función global para que el otro script pueda apagar este
	getgenv().DisableAutoGrabBeta = stopAutoGrabBeta

	if type(createToggle) == "function" then
		createToggle("AutoGrab (Beta)", function(state)
			if state then
				-- EXCLUSIÓN: Apagar el AutoGrab Manual si está activo externamente
				if getgenv().DisableAutoGrabManual then
					getgenv().DisableAutoGrabManual()
				end

				autoGrabEnabled = true
				autoGrabLoop = task.spawn(function()  
					while autoGrabEnabled do  
						if not autoGrabBusy then  
							local prompt = getNearestGrabPrompt()  
							if prompt then  
								executeGrab(prompt)  
							end  
						end  
						task.wait(0.1)  
					end  
				end)  
			else
				stopAutoGrabBeta()
			end
		end)
	end
end
-- ============================================================

-- ============================================================
-- TOKITO AIMBOT LASER CAPA (Con Memoria de Posición Segura)
-- ============================================================

do
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = game.Workspace.CurrentCamera
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Mouse = LocalPlayer:GetMouse()

    Config = Config or {}

    local AimbotEnabled = false
    local Minimized = false
    local CurrentTarget = nil
    local SettingsOpen = false

    -- ============================================================
    -- CONFIGURACIÓN DE ESCALA
    -- ============================================================

    local DefaultScale = 1
    local MinScale = 0.70
    local MaxScale = 1.50

    local SavedScale = DefaultScale

    pcall(function()
        if Config and tonumber(Config["CapaAimbotScale"]) then
            SavedScale = tonumber(Config["CapaAimbotScale"])
        end
    end)

    SavedScale = math.clamp(SavedScale, MinScale, MaxScale)

    local WhitelistedUsers = {
        ["Toki"] = true,
        ["Tokito"] = true,
        ["DavidAlejandro78892"] = true,
        ["davidalejandro78892"] = true,
        ["KenalGotas789"] = true
    }

    -- ============================================================
    -- SCREEN GUI
    -- ============================================================

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TokitoLaserGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local success, result = pcall(function()
        return gethui() or game:GetService("CoreGui")
    end)

    ScreenGui.Parent = success and result or game:GetService("CoreGui")

    -- ============================================================
    -- CARGAR POSICIÓN
    -- ============================================================

    local defaultPos = UDim2.new(0.5, -80, 0.15, 0)
    local framePos = defaultPos

    pcall(function()
        if Config and Config["CapaAimbotPos"] then
            local p = Config["CapaAimbotPos"]

            if type(p) == "table" and #p >= 4 then
                framePos = UDim2.new(
                    p[1],
                    p[2],
                    p[3],
                    p[4]
                )
            end
        end
    end)

    -- ============================================================
    -- MARCO PRINCIPAL
    -- ============================================================

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 160, 0, 75)
    MainFrame.Position = framePos
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0

    -- IMPORTANTE:
    -- Ahora puede mostrar el panel de configuración fuera de su
    -- tamaño normal sin cortarlo.
    MainFrame.ClipsDescendants = false

    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

    -- ============================================================
    -- UISCALE
    -- ============================================================

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "ResponsiveScale"
    UIScale.Scale = SavedScale
    UIScale.Parent = MainFrame

    -- ============================================================
    -- CORNER / STROKE
    -- ============================================================

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Thickness = 2
    MainStroke.Color = Color3.fromRGB(0, 170, 255)
    MainStroke.Transparency = 0.2

    -- ============================================================
    -- TÍTULO
    -- ============================================================

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 102, 0, 25)
    Title.Position = UDim2.new(0, 8, 0, 4)
    Title.Text = "Capa laser aim"
    Title.TextColor3 = Color3.fromRGB(0, 220, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame

    -- ============================================================
    -- BOTÓN CONFIGURACIÓN ⚙
    -- ============================================================

    local SettingsBtn = Instance.new("TextButton")
    SettingsBtn.Name = "SettingsBtn"
    SettingsBtn.Size = UDim2.new(0, 20, 0, 20)
    SettingsBtn.Position = UDim2.new(1, -48, 0, 4)

    -- Símbolo típico de configuración
    SettingsBtn.Text = "⚙"
    SettingsBtn.TextColor3 = Color3.fromRGB(0, 190, 255)
    SettingsBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    SettingsBtn.Font = Enum.Font.GothamBold
    SettingsBtn.TextSize = 13
    SettingsBtn.AutoButtonColor = false
    SettingsBtn.Parent = MainFrame

    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 5)
    SettingsCorner.Parent = SettingsBtn

    local SettingsStroke = Instance.new("UIStroke")
    SettingsStroke.Parent = SettingsBtn
    SettingsStroke.Color = Color3.fromRGB(0, 170, 255)
    SettingsStroke.Thickness = 1

    -- ============================================================
    -- BOTÓN MINIMIZAR
    -- ============================================================

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.Position = UDim2.new(1, -24, 0, 4)
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 10
    MinimizeBtn.Parent = MainFrame

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 5)
    MinCorner.Parent = MinimizeBtn

    local MinStroke = Instance.new("UIStroke")
    MinStroke.Parent = MinimizeBtn
    MinStroke.Color = Color3.fromRGB(0, 170, 255)
    MinStroke.Thickness = 1

    -- ============================================================
    -- BOTÓN TOGGLE
    -- ============================================================

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Size = UDim2.new(0, 144, 0, 32)
    ToggleBtn.Position = UDim2.new(0, 8, 0, 35)
    ToggleBtn.Text = "AIMBOT: OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent = MainFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleBtn

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Parent = ToggleBtn
    ToggleStroke.Color = Color3.fromRGB(100, 100, 100)
    ToggleStroke.Thickness = 1.5

    -- ============================================================
    -- PANEL DE CONFIGURACIÓN
    -- ============================================================

    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Size = UDim2.new(0, 190, 0, 128)
    SettingsFrame.Position = UDim2.new(0, -15, 0, 82)

    SettingsFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 20)
    SettingsFrame.BackgroundTransparency = 0.05
    SettingsFrame.BorderSizePixel = 0
    SettingsFrame.Visible = false
    SettingsFrame.ZIndex = 20
    SettingsFrame.Parent = MainFrame

    local SettingsCorner2 = Instance.new("UICorner")
    SettingsCorner2.CornerRadius = UDim.new(0, 8)
    SettingsCorner2.Parent = SettingsFrame

    local SettingsStroke2 = Instance.new("UIStroke")
    SettingsStroke2.Parent = SettingsFrame
    SettingsStroke2.Color = Color3.fromRGB(0, 170, 255)
    SettingsStroke2.Thickness = 1.5

    -- Título del panel
    local SettingsTitle = Instance.new("TextLabel")
    SettingsTitle.Name = "SettingsTitle"
    SettingsTitle.Size = UDim2.new(1, -20, 0, 24)
    SettingsTitle.Position = UDim2.new(0, 10, 0, 8)
    SettingsTitle.BackgroundTransparency = 1
    SettingsTitle.Text = "⚙ CONFIGURACIÓN"
    SettingsTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
    SettingsTitle.Font = Enum.Font.GothamBold
    SettingsTitle.TextSize = 12
    SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
    SettingsTitle.ZIndex = 21
    SettingsTitle.Parent = SettingsFrame

    -- Texto escala
    local ScaleLabel = Instance.new("TextLabel")
    ScaleLabel.Name = "ScaleLabel"
    ScaleLabel.Size = UDim2.new(1, -20, 0, 22)
    ScaleLabel.Position = UDim2.new(0, 10, 0, 36)
    ScaleLabel.BackgroundTransparency = 1
    ScaleLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
    ScaleLabel.Font = Enum.Font.GothamBold
    ScaleLabel.TextSize = 11
    ScaleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ScaleLabel.ZIndex = 21
    ScaleLabel.Parent = SettingsFrame

    -- Barra
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -40, 0, 7)
    SliderBar.Position = UDim2.new(0, 20, 0, 69)
    SliderBar.BackgroundColor3 = Color3.fromRGB(30, 40, 50)
    SliderBar.BorderSizePixel = 0
    SliderBar.ZIndex = 21
    SliderBar.Parent = SettingsFrame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = SliderBar

    -- Fill
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 22
    SliderFill.Parent = SliderBar

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill

    -- Knob
    local SliderKnob = Instance.new("TextButton")
    SliderKnob.Name = "SliderKnob"
    SliderKnob.Size = UDim2.new(0, 16, 0, 16)
    SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    SliderKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
    SliderKnob.Text = ""
    SliderKnob.AutoButtonColor = false
    SliderKnob.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
    SliderKnob.ZIndex = 23
    SliderKnob.Parent = SliderBar

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SliderKnob

    local KnobStroke = Instance.new("UIStroke")
    KnobStroke.Color = Color3.fromRGB(255, 255, 255)
    KnobStroke.Thickness = 1
    KnobStroke.Transparency = 0.4
    KnobStroke.Parent = SliderKnob

    -- ============================================================
    -- BOTONES - / +
    -- ============================================================

    local MinusBtn = Instance.new("TextButton")
    MinusBtn.Name = "MinusBtn"
    MinusBtn.Size = UDim2.new(0, 34, 0, 24)
    MinusBtn.Position = UDim2.new(0, 20, 0, 88)
    MinusBtn.Text = "−"
    MinusBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    MinusBtn.BackgroundColor3 = Color3.fromRGB(20, 28, 36)
    MinusBtn.Font = Enum.Font.GothamBold
    MinusBtn.TextSize = 15
    MinusBtn.ZIndex = 21
    MinusBtn.Parent = SettingsFrame

    local MinusCorner = Instance.new("UICorner")
    MinusCorner.CornerRadius = UDim.new(0, 5)
    MinusCorner.Parent = MinusBtn

    local MinusStroke = Instance.new("UIStroke")
    MinusStroke.Color = Color3.fromRGB(0, 120, 180)
    MinusStroke.Thickness = 1
    MinusStroke.Parent = MinusBtn

    local PlusBtn = Instance.new("TextButton")
    PlusBtn.Name = "PlusBtn"
    PlusBtn.Size = UDim2.new(0, 34, 0, 24)
    PlusBtn.Position = UDim2.new(1, -54, 0, 88)
    PlusBtn.Text = "+"
    PlusBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    PlusBtn.BackgroundColor3 = Color3.fromRGB(20, 28, 36)
    PlusBtn.Font = Enum.Font.GothamBold
    PlusBtn.TextSize = 15
    PlusBtn.ZIndex = 21
    PlusBtn.Parent = SettingsFrame

    local PlusCorner = Instance.new("UICorner")
    PlusCorner.CornerRadius = UDim.new(0, 5)
    PlusCorner.Parent = PlusBtn

    local PlusStroke = Instance.new("UIStroke")
    PlusStroke.Color = Color3.fromRGB(0, 120, 180)
    PlusStroke.Thickness = 1
    PlusStroke.Parent = PlusBtn

    -- ============================================================
    -- FUNCIÓN PARA ACTUALIZAR LA ESCALA
    -- ============================================================

    local function UpdateScale(newScale, shouldSave)
        newScale = tonumber(newScale)

        if not newScale then
            return
        end

        newScale = math.clamp(newScale, MinScale, MaxScale)

        SavedScale = newScale
        UIScale.Scale = newScale

        -- Porcentaje
        local percent = math.floor(newScale * 100 + 0.5)
        ScaleLabel.Text = "Tamaño de interfaz: " .. percent .. "%"

        -- Convertir a 0-1
        local alpha = (newScale - MinScale) / (MaxScale - MinScale)

        SliderFill.Size = UDim2.new(alpha, 0, 1, 0)
        SliderKnob.Position = UDim2.new(alpha, 0, 0.5, 0)

        if shouldSave ~= false then
            pcall(function()
                if Config then
                    Config["CapaAimbotScale"] = SavedScale

                    if saveConfig then
                        saveConfig()
                    end
                end
            end)
        end
    end

    UpdateScale(SavedScale, false)

    -- ============================================================
    -- SLIDER
    -- ============================================================

    local SliderDragging = false

    local function UpdateSliderFromInput(inputPositionX)
        local barAbsolutePosition = SliderBar.AbsolutePosition.X
        local barAbsoluteSize = SliderBar.AbsoluteSize.X

        if barAbsoluteSize <= 0 then
            return
        end

        local alpha = (inputPositionX - barAbsolutePosition) / barAbsoluteSize
        alpha = math.clamp(alpha, 0, 1)

        local newScale = MinScale + ((MaxScale - MinScale) * alpha)

        UpdateScale(newScale, true)
    end

    SliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            SliderDragging = true
        end
    end)

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            SliderDragging = true
            UpdateSliderFromInput(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if SliderDragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then

                UpdateSliderFromInput(input.Position.X)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            SliderDragging = false
        end
    end)

    -- ============================================================
    -- BOTONES DE TAMAÑO
    -- ============================================================

    MinusBtn.MouseButton1Click:Connect(function()
        UpdateScale(SavedScale - 0.05, true)
    end)

    PlusBtn.MouseButton1Click:Connect(function()
        UpdateScale(SavedScale + 0.05, true)
    end)

    -- ============================================================
    -- ABRIR / CERRAR CONFIGURACIÓN
    -- ============================================================

    SettingsBtn.MouseButton1Click:Connect(function()
        SettingsOpen = not SettingsOpen
        SettingsFrame.Visible = SettingsOpen

        if SettingsOpen then
            SettingsBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 110)
            SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            SettingsBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
            SettingsBtn.TextColor3 = Color3.fromRGB(0, 190, 255)
        end
    end)

    -- ============================================================
    -- ANIMACIÓN RGB AZUL
    -- ============================================================

    RunService.RenderStepped:Connect(function()
        pcall(function()
            if AimbotEnabled then
                local timePos = tick() * 3
                local glow = math.abs(math.sin(timePos)) * 0.5 + 0.5

                MainStroke.Color = Color3.fromRGB(
                    0,
                    math.floor(150 * glow) + 100,
                    255
                )

                ToggleStroke.Color = Color3.fromRGB(
                    0,
                    math.floor(150 * glow) + 100,
                    255
                )
            else
                MainStroke.Color = Color3.fromRGB(0, 120, 200)
            end
        end)
    end)

    -- ============================================================
    -- SISTEMA DE ARRASTRE TÁCTIL / MOUSE
    -- ============================================================

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    MainFrame.InputBegan:Connect(function(input)
        -- Evita arrastrar cuando se esté usando el slider
        if SliderDragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false

                    pcall(function()
                        if Config then
                            Config["CapaAimbotPos"] = {
                                MainFrame.Position.X.Scale,
                                MainFrame.Position.X.Offset,
                                MainFrame.Position.Y.Scale,
                                MainFrame.Position.Y.Offset
                            }

                            if saveConfig then
                                saveConfig()
                            end
                        end
                    end)
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging and not SliderDragging then
            local delta = input.Position - dragStart

            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ============================================================
    -- MINIMIZAR
    -- ============================================================

    MinimizeBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized

        -- Cerrar settings al minimizar
        if Minimized then
            SettingsOpen = false
            SettingsFrame.Visible = false

            SettingsBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
            SettingsBtn.TextColor3 = Color3.fromRGB(0, 190, 255)

            MainFrame:TweenSize(
                UDim2.new(0, 160, 0, 30),
                "Out",
                "Quad",
                0.2,
                true
            )

            ToggleBtn.Visible = false
            MinimizeBtn.Text = "+"
        else
            MainFrame:TweenSize(
                UDim2.new(0, 160, 0, 75),
                "Out",
                "Quad",
                0.2,
                true
            )

            ToggleBtn.Visible = true
            MinimizeBtn.Text = "—"
        end
    end)

    -- ============================================================
    -- BOTÓN AIMBOT
    -- ============================================================

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

    -- ============================================================
    -- BÚSQUEDA DEL OBJETIVO
    -- ============================================================

    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not AimbotEnabled then
                return
            end

            local Target = nil
            local ShortestDistance = math.huge

            local MyCharacter = LocalPlayer.Character
            local MyRoot = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")

            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer
                    and not WhitelistedUsers[v.Name]
                    and not WhitelistedUsers[v.DisplayName]
                    and v.Character
                    and v.Character:FindFirstChild("Humanoid")
                    and v.Character.Humanoid.Health > 0 then

                    local Hitbox =
                        v.Character:FindFirstChild("Head")
                        or v.Character:FindFirstChild("HumanoidRootPart")

                    if Hitbox
                        and (v.Team ~= LocalPlayer.Team or v.Team == nil) then

                        if MyRoot then
                            local Distance =
                                (Hitbox.Position - MyRoot.Position).Magnitude

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
    end)

    -- ============================================================
    -- INTERCEPCIÓN DEL DISPARO
    -- ============================================================

    pcall(function()
        local OldNamecall

        OldNamecall = hookmetamethod(
            game,
            "__namecall",
            newcclosure(function(self, ...)
                local Args = {...}
                local Method = getnamecallmethod()

                if AimbotEnabled
                    and CurrentTarget
                    and not checkcaller() then

                    if string.find(Method, "FindPartOnRay") then
                        return
                            CurrentTarget,
                            CurrentTarget.Position,
                            Vector3.new(0, 1, 0),
                            Enum.Material.Plastic

                    elseif Method == "Raycast" then
                        local Origin = Args[1]

                        local Direction =
                            (CurrentTarget.Position - Origin).Unit * 10000

                        local WallbangParams = RaycastParams.new()

                        WallbangParams.FilterType =
                            Enum.RaycastFilterType.Include

                        WallbangParams.FilterDescendantsInstances = {
                            CurrentTarget.Parent
                        }

                        WallbangParams.IgnoreWater = true

                        Args[2] = Direction
                        Args[3] = WallbangParams

                        return OldNamecall(
                            self,
                            unpack(Args)
                        )
                    end
                end

                return OldNamecall(self, ...)
            end)
        )

        local OldIndex

        OldIndex = hookmetamethod(
            game,
            "__index",
            newcclosure(function(self, Index)
                if AimbotEnabled
                    and CurrentTarget
                    and not checkcaller() then

                    if self == Mouse then
                        if Index == "Hit" or Index == "hit" then
                            return CurrentTarget.CFrame

                        elseif Index == "Target" or Index == "target" then
                            return CurrentTarget
                        end
                    end
                end

                return OldIndex(self, Index)
            end)
        )
    end)

    -- ============================================================
    -- INTEGRACIÓN CON createToggle
    -- ============================================================

    createToggle("Capa laser aim", function(state)
        MainFrame.Visible = state

        if not state then
            AimbotEnabled = false

            ToggleBtn.Text = "AIMBOT: OFF"
            ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
            ToggleStroke.Color = Color3.fromRGB(100, 100, 100)

            CurrentTarget = nil

            SettingsOpen = false
            SettingsFrame.Visible = false

            SettingsBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
            SettingsBtn.TextColor3 = Color3.fromRGB(0, 190, 255)
        end
    end)
end

-- AIMBOT OPTIMIZED
do
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Mouse = LocalPlayer:GetMouse()

    Config = Config or {}

    local AimbotEnabled = false
    local Minimized = false
    local CurrentTarget = nil
    local SettingsOpen = false

    -- ============================================================
    -- CONFIGURACIÓN DE ESCALA
    -- ============================================================

    local DefaultScale = 1
    local MinScale = 0.70
    local MaxScale = 1.50

    local SavedScale = DefaultScale

    pcall(function()
        local saved = tonumber(Config["CapaAimbotScale"])

        if saved then
            SavedScale = saved
        end
    end)

    SavedScale = math.clamp(SavedScale, MinScale, MaxScale)

    -- ============================================================
    -- USUARIOS EXCLUIDOS
    -- ============================================================

    local WhitelistedUsers = {
        ["Toki"] = true,
        ["Tokito"] = true,
        ["DavidAlejandro78892"] = true,
        ["davidalejandro78892"] = true,
        ["KenalGotas789"] = true
    }

    -- ============================================================
    -- SCREEN GUI
    -- ============================================================

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TokitoLaserGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local GuiParent

    pcall(function()
        GuiParent = gethui()
    end)

    if not GuiParent then
        GuiParent = game:GetService("CoreGui")
    end

    ScreenGui.Parent = GuiParent

    -- ============================================================
    -- CARGAR POSICIÓN
    -- ============================================================

    local defaultPos = UDim2.new(0.5, -80, 0.15, 0)
    local framePos = defaultPos

    pcall(function()
        local p = Config["CapaAimbotPos"]

        if type(p) == "table" and #p >= 4 then
            framePos = UDim2.new(
                tonumber(p[1]) or 0.5,
                tonumber(p[2]) or -80,
                tonumber(p[3]) or 0.15,
                tonumber(p[4]) or 0
            )
        end
    end)

    -- ============================================================
    -- MARCO PRINCIPAL
    -- ============================================================

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 160, 0, 75)
    MainFrame.Position = framePos
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

    -- ============================================================
    -- UI SCALE
    -- ============================================================

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "ResponsiveScale"
    UIScale.Scale = SavedScale
    UIScale.Parent = MainFrame

    -- ============================================================
    -- CORNER / STROKE
    -- ============================================================

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 2
    MainStroke.Color = Color3.fromRGB(0, 170, 255)
    MainStroke.Transparency = 0.2
    MainStroke.Parent = MainFrame

    -- ============================================================
    -- TÍTULO
    -- ============================================================

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 102, 0, 25)
    Title.Position = UDim2.new(0, 8, 0, 4)
    Title.Text = "Capa laser aim"
    Title.TextColor3 = Color3.fromRGB(0, 220, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame

    -- ============================================================
    -- BOTÓN CONFIGURACIÓN
    -- ============================================================

    local SettingsBtn = Instance.new("TextButton")
    SettingsBtn.Name = "SettingsBtn"
    SettingsBtn.Size = UDim2.new(0, 20, 0, 20)
    SettingsBtn.Position = UDim2.new(1, -48, 0, 4)
    SettingsBtn.Text = "⚙"
    SettingsBtn.TextColor3 = Color3.fromRGB(0, 190, 255)
    SettingsBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    SettingsBtn.Font = Enum.Font.GothamBold
    SettingsBtn.TextSize = 13
    SettingsBtn.AutoButtonColor = false
    SettingsBtn.Parent = MainFrame

    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 5)
    SettingsCorner.Parent = SettingsBtn

    local SettingsStroke = Instance.new("UIStroke")
    SettingsStroke.Color = Color3.fromRGB(0, 170, 255)
    SettingsStroke.Thickness = 1
    SettingsStroke.Parent = SettingsBtn

    -- ============================================================
    -- BOTÓN MINIMIZAR
    -- ============================================================

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.Position = UDim2.new(1, -24, 0, 4)
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 10
    MinimizeBtn.Parent = MainFrame

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 5)
    MinCorner.Parent = MinimizeBtn

    local MinStroke = Instance.new("UIStroke")
    MinStroke.Color = Color3.fromRGB(0, 170, 255)
    MinStroke.Thickness = 1
    MinStroke.Parent = MinimizeBtn

    -- ============================================================
    -- BOTÓN TOGGLE
    -- ============================================================

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Size = UDim2.new(0, 144, 0, 32)
    ToggleBtn.Position = UDim2.new(0, 8, 0, 35)
    ToggleBtn.Text = "AIMBOT: OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent = MainFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleBtn

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(100, 100, 100)
    ToggleStroke.Thickness = 1.5
    ToggleStroke.Parent = ToggleBtn

    -- ============================================================
    -- PANEL DE CONFIGURACIÓN
    -- ============================================================

    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Size = UDim2.new(0, 190, 0, 128)
    SettingsFrame.Position = UDim2.new(0, -15, 0, 82)
    SettingsFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 20)
    SettingsFrame.BackgroundTransparency = 0.05
    SettingsFrame.BorderSizePixel = 0
    SettingsFrame.Visible = false
    SettingsFrame.ZIndex = 20
    SettingsFrame.Parent = MainFrame

    local SettingsCorner2 = Instance.new("UICorner")
    SettingsCorner2.CornerRadius = UDim.new(0, 8)
    SettingsCorner2.Parent = SettingsFrame

    local SettingsStroke2 = Instance.new("UIStroke")
    SettingsStroke2.Color = Color3.fromRGB(0, 170, 255)
    SettingsStroke2.Thickness = 1.5
    SettingsStroke2.Parent = SettingsFrame

    -- ============================================================
    -- TÍTULO SETTINGS
    -- ============================================================

    local SettingsTitle = Instance.new("TextLabel")
    SettingsTitle.Name = "SettingsTitle"
    SettingsTitle.Size = UDim2.new(1, -20, 0, 24)
    SettingsTitle.Position = UDim2.new(0, 10, 0, 8)
    SettingsTitle.BackgroundTransparency = 1
    SettingsTitle.Text = "⚙ CONFIGURACIÓN"
    SettingsTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
    SettingsTitle.Font = Enum.Font.GothamBold
    SettingsTitle.TextSize = 12
    SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
    SettingsTitle.ZIndex = 21
    SettingsTitle.Parent = SettingsFrame

    -- ============================================================
    -- LABEL ESCALA
    -- ============================================================

    local ScaleLabel = Instance.new("TextLabel")
    ScaleLabel.Name = "ScaleLabel"
    ScaleLabel.Size = UDim2.new(1, -20, 0, 22)
    ScaleLabel.Position = UDim2.new(0, 10, 0, 36)
    ScaleLabel.BackgroundTransparency = 1
    ScaleLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
    ScaleLabel.Font = Enum.Font.GothamBold
    ScaleLabel.TextSize = 11
    ScaleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ScaleLabel.ZIndex = 21
    ScaleLabel.Parent = SettingsFrame

    -- ============================================================
    -- SLIDER BAR
    -- ============================================================

    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -40, 0, 7)
    SliderBar.Position = UDim2.new(0, 20, 0, 69)
    SliderBar.BackgroundColor3 = Color3.fromRGB(30, 40, 50)
    SliderBar.BorderSizePixel = 0
    SliderBar.ZIndex = 21
    SliderBar.Parent = SettingsFrame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = SliderBar

    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 22
    SliderFill.Parent = SliderBar

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill

    local SliderKnob = Instance.new("TextButton")
    SliderKnob.Name = "SliderKnob"
    SliderKnob.Size = UDim2.new(0, 16, 0, 16)
    SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    SliderKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
    SliderKnob.Text = ""
    SliderKnob.AutoButtonColor = false
    SliderKnob.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
    SliderKnob.ZIndex = 23
    SliderKnob.Parent = SliderBar

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SliderKnob

    local KnobStroke = Instance.new("UIStroke")
    KnobStroke.Color = Color3.fromRGB(255, 255, 255)
    KnobStroke.Thickness = 1
    KnobStroke.Transparency = 0.4
    KnobStroke.Parent = SliderKnob

    -- ============================================================
    -- BOTÓN -
    -- ============================================================

    local MinusBtn = Instance.new("TextButton")
    MinusBtn.Name = "MinusBtn"
    MinusBtn.Size = UDim2.new(0, 34, 0, 24)
    MinusBtn.Position = UDim2.new(0, 20, 0, 88)
    MinusBtn.Text = "−"
    MinusBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    MinusBtn.BackgroundColor3 = Color3.fromRGB(20, 28, 36)
    MinusBtn.Font = Enum.Font.GothamBold
    MinusBtn.TextSize = 15
    MinusBtn.ZIndex = 21
    MinusBtn.Parent = SettingsFrame

    local MinusCorner = Instance.new("UICorner")
    MinusCorner.CornerRadius = UDim.new(0, 5)
    MinusCorner.Parent = MinusBtn

    local MinusStroke = Instance.new("UIStroke")
    MinusStroke.Color = Color3.fromRGB(0, 120, 180)
    MinusStroke.Thickness = 1
    MinusStroke.Parent = MinusBtn

    -- ============================================================
    -- BOTÓN +
    -- ============================================================

    local PlusBtn = Instance.new("TextButton")
    PlusBtn.Name = "PlusBtn"
    PlusBtn.Size = UDim2.new(0, 34, 0, 24)
    PlusBtn.Position = UDim2.new(1, -54, 0, 88)
    PlusBtn.Text = "+"
    PlusBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    PlusBtn.BackgroundColor3 = Color3.fromRGB(20, 28, 36)
    PlusBtn.Font = Enum.Font.GothamBold
    PlusBtn.TextSize = 15
    PlusBtn.ZIndex = 21
    PlusBtn.Parent = SettingsFrame

    local PlusCorner = Instance.new("UICorner")
    PlusCorner.CornerRadius = UDim.new(0, 5)
    PlusCorner.Parent = PlusBtn

    local PlusStroke = Instance.new("UIStroke")
    PlusStroke.Color = Color3.fromRGB(0, 120, 180)
    PlusStroke.Thickness = 1
    PlusStroke.Parent = PlusBtn

    -- ============================================================
    -- GUARDAR CONFIG
    -- ============================================================

    local function SaveScale()
        pcall(function()
            Config["CapaAimbotScale"] = SavedScale

            if saveConfig then
                saveConfig()
            end
        end)
    end

    local function SavePosition()
        pcall(function()
            Config["CapaAimbotPos"] = {
                MainFrame.Position.X.Scale,
                MainFrame.Position.X.Offset,
                MainFrame.Position.Y.Scale,
                MainFrame.Position.Y.Offset
            }

            if saveConfig then
                saveConfig()
            end
        end)
    end

    -- ============================================================
    -- ACTUALIZAR ESCALA
    -- ============================================================

    local function UpdateScale(newScale, shouldSave)
        newScale = tonumber(newScale)

        if not newScale then
            return
        end

        newScale = math.clamp(newScale, MinScale, MaxScale)

        SavedScale = newScale
        UIScale.Scale = newScale

        local percent = math.floor(newScale * 100 + 0.5)
        ScaleLabel.Text = "Tamaño de interfaz: " .. percent .. "%"

        local alpha = (newScale - MinScale) / (MaxScale - MinScale)

        SliderFill.Size = UDim2.new(alpha, 0, 1, 0)
        SliderKnob.Position = UDim2.new(alpha, 0, 0.5, 0)

        if shouldSave then
            SaveScale()
        end
    end

    UpdateScale(SavedScale, false)

    -- ============================================================
    -- SLIDER
    -- ============================================================

    local SliderDragging = false

    local function UpdateSliderFromInput(inputPositionX)
        local barAbsolutePosition = SliderBar.AbsolutePosition.X
        local barAbsoluteSize = SliderBar.AbsoluteSize.X

        if barAbsoluteSize <= 0 then
            return
        end

        local alpha =
            (inputPositionX - barAbsolutePosition) / barAbsoluteSize

        alpha = math.clamp(alpha, 0, 1)

        local newScale =
            MinScale + ((MaxScale - MinScale) * alpha)

        -- IMPORTANTE:
        -- Durante el drag NO se guarda la configuración.
        UpdateScale(newScale, false)
    end

    SliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            SliderDragging = true
        end
    end)

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            SliderDragging = true
            UpdateSliderFromInput(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not SliderDragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            UpdateSliderFromInput(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            if SliderDragging then
                SliderDragging = false
                SaveScale()
            end
        end
    end)

    -- ============================================================
    -- BOTONES DE ESCALA
    -- ============================================================

    MinusBtn.MouseButton1Click:Connect(function()
        UpdateScale(SavedScale - 0.05, true)
    end)

    PlusBtn.MouseButton1Click:Connect(function()
        UpdateScale(SavedScale + 0.05, true)
    end)

    -- ============================================================
    -- SETTINGS
    -- ============================================================

    SettingsBtn.MouseButton1Click:Connect(function()
        SettingsOpen = not SettingsOpen
        SettingsFrame.Visible = SettingsOpen

        if SettingsOpen then
            SettingsBtn.BackgroundColor3 =
                Color3.fromRGB(0, 70, 110)

            SettingsBtn.TextColor3 =
                Color3.fromRGB(255, 255, 255)
        else
            SettingsBtn.BackgroundColor3 =
                Color3.fromRGB(20, 25, 35)

            SettingsBtn.TextColor3 =
                Color3.fromRGB(0, 190, 255)
        end
    end)

    -- ============================================================
    -- SISTEMA DE ARRASTRE
    -- ============================================================

    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    MainFrame.InputBegan:Connect(function(input)
        if SliderDragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    SavePosition()
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput
            and dragging
            and not SliderDragging then

            local delta = input.Position - dragStart

            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ============================================================
    -- MINIMIZAR
    -- ============================================================

    MinimizeBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized

        if Minimized then
            SettingsOpen = false
            SettingsFrame.Visible = false

            SettingsBtn.BackgroundColor3 =
                Color3.fromRGB(20, 25, 35)

            SettingsBtn.TextColor3 =
                Color3.fromRGB(0, 190, 255)

            MainFrame:TweenSize(
                UDim2.new(0, 160, 0, 30),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )

            ToggleBtn.Visible = false
            MinimizeBtn.Text = "+"
        else
            MainFrame:TweenSize(
                UDim2.new(0, 160, 0, 75),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )

            ToggleBtn.Visible = true
            MinimizeBtn.Text = "—"
        end
    end)

    -- ============================================================
    -- ACTUALIZAR TARGET
    -- ============================================================

    local TargetUpdateInterval = 0.08
    local TargetUpdateTimer = 0

    local function UpdateAimbotTarget()
        local MyCharacter = LocalPlayer.Character

        if not MyCharacter then
            CurrentTarget = nil
            return
        end

        local MyRoot =
            MyCharacter:FindFirstChild("HumanoidRootPart")

        if not MyRoot then
            CurrentTarget = nil
            return
        end

        local MyPosition = MyRoot.Position

        local BestTarget = nil
        local BestDistanceSquared = math.huge

        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer
                and not WhitelistedUsers[Player.Name]
                and not WhitelistedUsers[Player.DisplayName] then

                local Character = Player.Character

                if Character and Character ~= MyCharacter then
                    local Humanoid =
                        Character:FindFirstChildOfClass("Humanoid")

                    if Humanoid
                        and Humanoid.Health > 0
                        and (
                            Player.Team == nil
                            or Player.Team ~= LocalPlayer.Team
                        ) then

                        local Hitbox =
                            Character:FindFirstChild("Head")
                            or Character:FindFirstChild("HumanoidRootPart")

                        if Hitbox then
                            local Offset =
                                Hitbox.Position - MyPosition

                            -- Más barato que Magnitude porque evita sqrt
                            local DistanceSquared =
                                Offset.X * Offset.X
                                + Offset.Y * Offset.Y
                                + Offset.Z * Offset.Z

                            if DistanceSquared < BestDistanceSquared then
                                BestDistanceSquared = DistanceSquared
                                BestTarget = Hitbox
                            end
                        end
                    end
                end
            end
        end

        CurrentTarget = BestTarget
    end

    -- ============================================================
    -- BOTÓN AIMBOT
    -- ============================================================

    ToggleBtn.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled

        if AimbotEnabled then
            TargetUpdateTimer = TargetUpdateInterval
            UpdateAimbotTarget()

            ToggleBtn.Text = "AIMBOT: ON"
            ToggleBtn.TextColor3 =
                Color3.fromRGB(255, 255, 255)

            ToggleBtn.BackgroundColor3 =
                Color3.fromRGB(0, 80, 180)

            ToggleStroke.Color =
                Color3.fromRGB(0, 200, 255)
        else
            CurrentTarget = nil
            TargetUpdateTimer = 0

            ToggleBtn.Text = "AIMBOT: OFF"

            ToggleBtn.TextColor3 =
                Color3.fromRGB(150, 150, 150)

            ToggleBtn.BackgroundColor3 =
                Color3.fromRGB(15, 20, 25)

            ToggleStroke.Color =
                Color3.fromRGB(100, 100, 100)
        end
    end)

    -- ============================================================
    -- ANIMACIÓN + ACTUALIZACIÓN DEL TARGET
    -- ============================================================

    RunService.RenderStepped:Connect(function(deltaTime)
        if not AimbotEnabled then
            MainStroke.Color = Color3.fromRGB(0, 120, 200)
            return
        end

        -- Animación visual
        local glow =
            math.abs(math.sin(os.clock() * 3)) * 0.5 + 0.5

        local green =
            math.floor(150 * glow) + 100

        MainStroke.Color =
            Color3.fromRGB(0, green, 255)

        ToggleStroke.Color =
            Color3.fromRGB(0, green, 255)

        -- Actualización limitada del objetivo
        TargetUpdateTimer += deltaTime

        if TargetUpdateTimer >= TargetUpdateInterval then
            TargetUpdateTimer = 0
            UpdateAimbotTarget()
        end
    end)

    -- ============================================================
    -- RAYCAST PARAMS REUTILIZABLE
    -- ============================================================

    local WallbangParams = RaycastParams.new()

    WallbangParams.FilterType =
        Enum.RaycastFilterType.Include

    WallbangParams.IgnoreWater = true

    -- ============================================================
    -- INTERCEPCIÓN DEL DISPARO
    -- ============================================================

    pcall(function()
        local OldNamecall

        OldNamecall = hookmetamethod(
            game,
            "__namecall",
            newcclosure(function(self, ...)
                local Method = getnamecallmethod()

                if AimbotEnabled
                    and CurrentTarget
                    and not checkcaller() then

                    if string.find(Method, "FindPartOnRay") then
                        return
                            CurrentTarget,
                            CurrentTarget.Position,
                            Vector3.new(0, 1, 0),
                            Enum.Material.Plastic

                    elseif Method == "Raycast" then
                        local Args = {...}
                        local Origin = Args[1]

                        if typeof(Origin) == "Vector3" then
                            local Direction =
                                (CurrentTarget.Position - Origin).Unit * 10000

                            WallbangParams.FilterDescendantsInstances = {
                                CurrentTarget.Parent
                            }

                            Args[2] = Direction
                            Args[3] = WallbangParams

                            return OldNamecall(
                                self,
                                unpack(Args)
                            )
                        end
                    end
                end

                return OldNamecall(self, ...)
            end)
        )

        local OldIndex

        OldIndex = hookmetamethod(
            game,
            "__index",
            newcclosure(function(self, Index)
                if AimbotEnabled
                    and CurrentTarget
                    and not checkcaller()
                    and self == Mouse then

                    if Index == "Hit"
                        or Index == "hit" then

                        return CurrentTarget.CFrame
                    end

                    if Index == "Target"
                        or Index == "target" then

                        return CurrentTarget
                    end
                end

                return OldIndex(self, Index)
            end)
        )
    end)

    -- ============================================================
    -- INTEGRACIÓN CON createToggle
    -- ============================================================

    createToggle("AIMBOT OPTIMIZADO", function(state)
        MainFrame.Visible = state

        if not state then
            AimbotEnabled = false
            CurrentTarget = nil
            TargetUpdateTimer = 0

            ToggleBtn.Text = "AIMBOT: OFF"

            ToggleBtn.TextColor3 =
                Color3.fromRGB(150, 150, 150)

            ToggleBtn.BackgroundColor3 =
                Color3.fromRGB(15, 20, 25)

            ToggleStroke.Color =
                Color3.fromRGB(100, 100, 100)

            SettingsOpen = false
            SettingsFrame.Visible = false

            SettingsBtn.BackgroundColor3 =
                Color3.fromRGB(20, 25, 35)

            SettingsBtn.TextColor3 =
                Color3.fromRGB(0, 190, 255)
        end
    end)
end
-- ========================================================
-- TOKITO PVP SCRIPT V4
-- AUTO LASER + INTERFAZ RESPONSIVA + ARRASTRE REAL
-- ESCALA + POSICIÓN PERSISTENTE + MINIMIZAR
-- ========================================================

do
    -- ====================================================
    -- SERVICIOS
    -- ====================================================

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")

    local LocalPlayer = Players.LocalPlayer

    Config = Config or {}

    -- ====================================================
    -- ANTI BEE
    -- ====================================================

    local antiBeeEnabled = false
    local antiBeeConnections = {}

    local antiBeeData = {
        originalMoveFunction = nil,
        controlsProtected = false,
        badLightingNames = {
            Blue = true,
            DiscoEffect = true,
            BeeBlur = true,
            ColorCorrection = true
        }
    }

    local function destroyBeeEffect(obj)
        pcall(function()
            if not obj or not obj.Parent then
                return
            end

            if antiBeeData.badLightingNames[obj.Name] then
                obj:Destroy()
            end
        end)
    end

    local function protectControls()
        if antiBeeData.controlsProtected then
            return
        end

        pcall(function()

            local PlayerModule =
                LocalPlayer.PlayerScripts:FindFirstChild(
                    "PlayerModule"
                )

            if not PlayerModule then
                return
            end

            local Controls =
                require(PlayerModule):GetControls()

            if not Controls then
                return
            end

            if not antiBeeData.originalMoveFunction then
                antiBeeData.originalMoveFunction =
                    Controls.moveFunction
            end

            local function protectedMove(
                self,
                moveVector,
                relativeToCamera
            )
                pcall(function()
                    if antiBeeData.originalMoveFunction then
                        antiBeeData.originalMoveFunction(
                            self,
                            moveVector,
                            relativeToCamera
                        )
                    end
                end)
            end

            Controls.moveFunction = protectedMove

            table.insert(
                antiBeeConnections,
                RunService.Heartbeat:Connect(
                    function()

                        pcall(function()

                            if not antiBeeEnabled then
                                return
                            end

                            if Controls.moveFunction ~= protectedMove then
                                Controls.moveFunction = protectedMove
                            end
                        end)
                    end
                )
            )

            antiBeeData.controlsProtected = true
        end)
    end

    local function blockBuzzing()

        pcall(function()

            local beeScript =
                LocalPlayer.PlayerScripts:FindFirstChild(
                    "Bee",
                    true
                )

            if not beeScript then
                return
            end

            local buzzing =
                beeScript:FindFirstChild("Buzzing")

            if buzzing and buzzing:IsA("Sound") then
                buzzing:Stop()
                buzzing.Volume = 0
            end
        end)
    end

    local function lockFOV()

        pcall(function()

            local cam =
                Workspace.CurrentCamera

            if cam then
                cam.FieldOfView = 70
            end
        end)
    end

    local function enableAntiBee()

        if antiBeeEnabled then
            return
        end

        antiBeeEnabled = true

        pcall(function()

            for _, obj in ipairs(
                Lighting:GetDescendants()
            ) do

                destroyBeeEffect(obj)
            end
        end)

        table.insert(
            antiBeeConnections,
            Lighting.DescendantAdded:Connect(
                function(obj)

                    pcall(function()

                        if antiBeeEnabled then
                            destroyBeeEffect(obj)
                        end
                    end)
                end
            )
        )

        protectControls()

        table.insert(
            antiBeeConnections,
            RunService.Heartbeat:Connect(
                function()

                    pcall(function()

                        if not antiBeeEnabled then
                            return
                        end

                        blockBuzzing()
                        lockFOV()
                    end)
                end
            )
        )
    end

    pcall(enableAntiBee)

    -- ====================================================
    -- OBTENER HERRAMIENTA LASER
    -- ====================================================

    local function getLaserTool()

        local success, result =
            pcall(function()

                local character =
                    LocalPlayer.Character

                local backpack =
                    LocalPlayer.Backpack

                if not character or not backpack then
                    return nil
                end

                local function searchFolder(folder)

                    for _, item in ipairs(
                        folder:GetChildren()
                    ) do

                        if item:IsA("Tool")
                            and string.find(
                                string.lower(item.Name),
                                "laser",
                                1,
                                true
                            ) then

                            return item
                        end
                    end

                    return nil
                end

                return
                    searchFolder(character)
                    or searchFolder(backpack)
            end)

        if success then
            return result
        end

        return nil
    end

    -- ====================================================
    -- GUI
    -- ====================================================

    local tokitoGui = nil
    local tokitoConnections = {}

    -- ====================================================
    -- CONFIGURACIÓN DE GUI
    -- ====================================================

    local GUI_WIDTH = 165
    local GUI_HEIGHT = 88

    local DEFAULT_SCALE = 1
    local MIN_SCALE = 0.70
    local MAX_SCALE = 1.50

    local currentScale = DEFAULT_SCALE

    -- ====================================================
    -- CARGAR ESCALA
    -- ====================================================

    pcall(function()

        if Config
            and tonumber(Config["TokitoScale"]) then

            currentScale =
                math.clamp(
                    tonumber(Config["TokitoScale"]),
                    MIN_SCALE,
                    MAX_SCALE
                )
        end
    end)

    -- ====================================================
    -- CARGAR POSICIÓN
    -- ====================================================

    local defaultPos =
        UDim2.new(
            0.5,
            -(GUI_WIDTH / 2),
            0.5,
            -(GUI_HEIGHT / 2)
        )

    local savedPos = defaultPos

    pcall(function()

        if Config and Config["TokitoPos"] then

            local p =
                Config["TokitoPos"]

            if type(p) == "table"
                and #p >= 4 then

                savedPos =
                    UDim2.new(
                        p[1],
                        p[2],
                        p[3],
                        p[4]
                    )
            end
        end
    end)

    -- ====================================================
    -- GUARDAR POSICIÓN
    -- ====================================================

    local function saveTokitoPosition(position)

        pcall(function()

            if Config then

                Config["TokitoPos"] = {
                    position.X.Scale,
                    position.X.Offset,
                    position.Y.Scale,
                    position.Y.Offset
                }

                if saveConfig then
                    saveConfig()
                end
            end
        end)
    end

    -- ====================================================
    -- GUARDAR ESCALA
    -- ====================================================

    local function saveTokitoScale(scale)

        pcall(function()

            if Config then

                Config["TokitoScale"] =
                    math.clamp(
                        scale,
                        MIN_SCALE,
                        MAX_SCALE
                    )

                if saveConfig then
                    saveConfig()
                end
            end
        end)
    end

    -- ====================================================
    -- CREAR GUI
    -- ====================================================

    local function createTokitoGui()

        -- ==================================================
        -- LIMPIAR ANTERIOR
        -- ==================================================

        pcall(function()

            if tokitoGui then
                tokitoGui:Destroy()
                tokitoGui = nil
            end

            for _, conn in ipairs(
                tokitoConnections
            ) do

                if conn then
                    conn:Disconnect()
                end
            end

            tokitoConnections = {}
        end)

        -- ==================================================
        -- SCREEN GUI
        -- ==================================================

        local ScreenGui =
            Instance.new("ScreenGui")

        ScreenGui.Name =
            "TokitoPvPGUI"

        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ZIndexBehavior =
            Enum.ZIndexBehavior.Sibling

        local parentSuccess, coreGuiResult =
            pcall(function()

                return
                    gethui()
                    or game:GetService("CoreGui")
            end)

        ScreenGui.Parent =
            parentSuccess
            and coreGuiResult
            or game:GetService("CoreGui")

        tokitoGui = ScreenGui

        -- ==================================================
        -- MAIN FRAME
        -- ==================================================

        local MainFrame =
            Instance.new("Frame")

        MainFrame.Name =
            "MainFrame"

        MainFrame.Size =
            UDim2.new(
                0,
                GUI_WIDTH,
                0,
                GUI_HEIGHT
            )

        MainFrame.Position =
            savedPos

        MainFrame.BackgroundColor3 =
            Color3.fromRGB(
                9,
                13,
                20
            )

        MainFrame.BackgroundTransparency =
            0.03

        MainFrame.BorderSizePixel = 0
        MainFrame.ClipsDescendants = false
        MainFrame.Active = true

        MainFrame.Parent =
            ScreenGui

        -- ==================================================
        -- ESCALA
        -- ==================================================

        local UIScale =
            Instance.new("UIScale")

        UIScale.Name =
            "ResponsiveScale"

        UIScale.Scale =
            currentScale

        UIScale.Parent =
            MainFrame

        -- ==================================================
        -- SOMBRA
        -- ==================================================

        local Shadow =
            Instance.new("ImageLabel")

        Shadow.Name =
            "Shadow"

        Shadow.AnchorPoint =
            Vector2.new(0.5, 0.5)

        Shadow.Position =
            UDim2.new(
                0.5,
                0,
                0.5,
                4
            )

        Shadow.Size =
            UDim2.new(
                0,
                GUI_WIDTH + 30,
                0,
                GUI_HEIGHT + 30
            )

        Shadow.BackgroundTransparency = 1

        Shadow.Image =
            "rbxassetid://1316045217"

        Shadow.ImageColor3 =
            Color3.fromRGB(
                0,
                0,
                0
            )

        Shadow.ImageTransparency = 0.35

        Shadow.ScaleType =
            Enum.ScaleType.Slice

        Shadow.SliceCenter =
            Rect.new(
                10,
                10,
                118,
                118
            )

        Shadow.ZIndex = 0

        Shadow.Parent =
            MainFrame

        -- ==================================================
        -- CORNER
        -- ==================================================

        local MainCorner =
            Instance.new("UICorner")

        MainCorner.CornerRadius =
            UDim.new(
                0,
                12
            )

        MainCorner.Parent =
            MainFrame

        -- ==================================================
        -- GRADIENT
        -- ==================================================

        local MainGradient =
            Instance.new("UIGradient")

        MainGradient.Color =
            ColorSequence.new({

                ColorSequenceKeypoint.new(
                    0,
                    Color3.fromRGB(
                        16,
                        23,
                        34
                    )
                ),

                ColorSequenceKeypoint.new(
                    0.5,
                    Color3.fromRGB(
                        9,
                        14,
                        22
                    )
                ),

                ColorSequenceKeypoint.new(
                    1,
                    Color3.fromRGB(
                        6,
                        9,
                        15
                    )
                )
            })

        MainGradient.Rotation = 90
        MainGradient.Parent = MainFrame

        -- ==================================================
        -- BORDE
        -- ==================================================

        local UIStroke =
            Instance.new("UIStroke")

        UIStroke.Thickness = 1.5
        UIStroke.Transparency = 0.15

        UIStroke.Color =
            Color3.fromRGB(
                0,
                170,
                255
            )

        UIStroke.Parent =
            MainFrame

        -- ==================================================
        -- CABECERA
        -- ==================================================

        local Header =
            Instance.new("Frame")

        Header.Name =
            "Header"

        Header.Size =
            UDim2.new(
                1,
                -10,
                0,
                30
            )

        Header.Position =
            UDim2.new(
                0,
                5,
                0,
                4
            )

        Header.BackgroundTransparency = 1
        Header.Parent =
            MainFrame

        -- ==================================================
        -- ZONA DE ARRASTRE
        -- ==================================================

        local DragHandle =
            Instance.new("TextButton")

        DragHandle.Name =
            "DragHandle"

        DragHandle.Size =
            UDim2.new(
                1,
                -50,
                1,
                0
            )

        DragHandle.Position =
            UDim2.new(
                0,
                0,
                0,
                0
            )

        DragHandle.BackgroundTransparency = 1
        DragHandle.BorderSizePixel = 0

        DragHandle.Text = ""
        DragHandle.AutoButtonColor = false

        DragHandle.Active = true
        DragHandle.Selectable = false
        DragHandle.ZIndex = 40

        DragHandle.Parent =
            Header

        -- ==================================================
        -- ICONO
        -- ==================================================

        local Icon =
            Instance.new("TextLabel")

        Icon.Size =
            UDim2.new(
                0,
                25,
                0,
                25
            )

        Icon.Position =
            UDim2.new(
                0,
                0,
                0,
                0
            )

        Icon.BackgroundColor3 =
            Color3.fromRGB(
                0,
                95,
                160
            )

        Icon.BackgroundTransparency =
            0.15

        Icon.Text = "⚡"

        Icon.TextColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            )

        Icon.Font =
            Enum.Font.GothamBold

        Icon.TextSize = 13
        Icon.ZIndex = 41

        Icon.Parent =
            Header

        local IconCorner =
            Instance.new("UICorner")

        IconCorner.CornerRadius =
            UDim.new(
                0,
                7
            )

        IconCorner.Parent =
            Icon

        -- ==================================================
        -- TÍTULO
        -- ==================================================

        local Title =
            Instance.new("TextLabel")

        Title.Size =
            UDim2.new(
                1,
                -90,
                0,
                16
            )

        Title.Position =
            UDim2.new(
                0,
                32,
                0,
                1
            )

        Title.BackgroundTransparency = 1

        Title.Text =
            "AUTO LASER"

        Title.TextColor3 =
            Color3.fromRGB(
                235,
                245,
                255
            )

        Title.Font =
            Enum.Font.GothamBold

        Title.TextSize = 11
        Title.TextXAlignment =
            Enum.TextXAlignment.Left

        Title.ZIndex = 41

        Title.Parent =
            Header

        -- ==================================================
        -- SUBTÍTULO
        -- ==================================================

        local Subtitle =
            Instance.new("TextLabel")

        Subtitle.Size =
            UDim2.new(
                1,
                -90,
                0,
                12
            )

        Subtitle.Position =
            UDim2.new(
                0,
                32,
                0,
                16
            )

        Subtitle.BackgroundTransparency = 1

        Subtitle.Text =
            "CONTROL DEL LASER"

        Subtitle.TextColor3 =
            Color3.fromRGB(
                105,
                125,
                145
            )

        Subtitle.Font =
            Enum.Font.GothamMedium

        Subtitle.TextSize = 7

        Subtitle.TextXAlignment =
            Enum.TextXAlignment.Left

        Subtitle.ZIndex = 41

        Subtitle.Parent =
            Header

        -- ==================================================
        -- CONFIGURACIÓN
        -- ==================================================

        local SettingsBtn =
            Instance.new("TextButton")

        SettingsBtn.Name =
            "Settings"

        SettingsBtn.Size =
            UDim2.new(
                0,
                22,
                0,
                22
            )

        SettingsBtn.Position =
            UDim2.new(
                1,
                -48,
                0,
                1
            )

        SettingsBtn.BackgroundColor3 =
            Color3.fromRGB(
                18,
                28,
                40
            )

        SettingsBtn.Text = "⚙"

        SettingsBtn.TextColor3 =
            Color3.fromRGB(
                0,
                190,
                255
            )

        SettingsBtn.Font =
            Enum.Font.GothamBold

        SettingsBtn.TextSize = 13
        SettingsBtn.AutoButtonColor = false
        SettingsBtn.ZIndex = 60
        SettingsBtn.Parent = Header

        local SettingsCorner =
            Instance.new("UICorner")

        SettingsCorner.CornerRadius =
            UDim.new(
                0,
                7
            )

        SettingsCorner.Parent =
            SettingsBtn

        -- ==================================================
        -- MINIMIZAR
        -- ==================================================

        local MinimizeBtn =
            Instance.new("TextButton")

        MinimizeBtn.Name =
            "Minimize"

        MinimizeBtn.Size =
            UDim2.new(
                0,
                22,
                0,
                22
            )

        MinimizeBtn.Position =
            UDim2.new(
                1,
                -23,
                0,
                1
            )

        MinimizeBtn.BackgroundColor3 =
            Color3.fromRGB(
                18,
                28,
                40
            )

        MinimizeBtn.Text = "—"

        MinimizeBtn.TextColor3 =
            Color3.fromRGB(
                150,
                180,
                200
            )

        MinimizeBtn.Font =
            Enum.Font.GothamBold

        MinimizeBtn.TextSize = 11
        MinimizeBtn.AutoButtonColor = false
        MinimizeBtn.ZIndex = 60
        MinimizeBtn.Parent = Header

        local MinCorner =
            Instance.new("UICorner")

        MinCorner.CornerRadius =
            UDim.new(
                0,
                7
            )

        MinCorner.Parent =
            MinimizeBtn

        -- ==================================================
        -- ESTADO
        -- ==================================================

        local Status =
            Instance.new("TextLabel")

        Status.Size =
            UDim2.new(
                1,
                -20,
                0,
                14
            )

        Status.Position =
            UDim2.new(
                0,
                10,
                0,
                34
            )

        Status.BackgroundTransparency = 1

        Status.Text =
            "● LASER DESACTIVADO"

        Status.TextColor3 =
            Color3.fromRGB(
                120,
                145,
                165
            )

        Status.Font =
            Enum.Font.GothamMedium

        Status.TextSize = 8
        Status.TextXAlignment =
            Enum.TextXAlignment.Left

        Status.Parent =
            MainFrame

        -- ==================================================
        -- BOTÓN LASER
        -- ==================================================

        local LaserButton =
            Instance.new("TextButton")

        LaserButton.Name =
            "LaserButton"

        LaserButton.Size =
            UDim2.new(
                1,
                -20,
                0,
                31
            )

        LaserButton.Position =
            UDim2.new(
                0,
                10,
                0,
                51
            )

        LaserButton.BackgroundColor3 =
            Color3.fromRGB(
                18,
                28,
                43
            )

        LaserButton.BorderSizePixel = 0

        LaserButton.Text =
            "ACTIVAR LASER"

        LaserButton.TextColor3 =
            Color3.fromRGB(
                220,
                230,
                240
            )

        LaserButton.Font =
            Enum.Font.GothamBold

        LaserButton.TextSize = 10
        LaserButton.AutoButtonColor = false

        LaserButton.Parent =
            MainFrame

        local LaserCorner =
            Instance.new("UICorner")

        LaserCorner.CornerRadius =
            UDim.new(
                0,
                8
            )

        LaserCorner.Parent =
            LaserButton

        local LaserStroke =
            Instance.new("UIStroke")

        LaserStroke.Thickness = 1
        LaserStroke.Transparency = 0.25

        LaserStroke.Color =
            Color3.fromRGB(
                0,
                110,
                180
            )

        LaserStroke.Parent =
            LaserButton

        -- ==================================================
        -- PANEL DE CONFIGURACIÓN
        -- ==================================================

        local SettingsFrame =
            Instance.new("Frame")

        SettingsFrame.Name =
            "SettingsFrame"

        SettingsFrame.Size =
            UDim2.new(
                0,
                210,
                0,
                145
            )

        SettingsFrame.Position =
            UDim2.new(
                0,
                -20,
                0,
                95
            )

        SettingsFrame.BackgroundColor3 =
            Color3.fromRGB(
                8,
                13,
                20
            )

        SettingsFrame.BorderSizePixel = 0
        SettingsFrame.Visible = false
        SettingsFrame.ZIndex = 20

        SettingsFrame.Parent =
            MainFrame

        local SettingsFrameCorner =
            Instance.new("UICorner")

        SettingsFrameCorner.CornerRadius =
            UDim.new(
                0,
                11
            )

        SettingsFrameCorner.Parent =
            SettingsFrame

        local SettingsFrameStroke =
            Instance.new("UIStroke")

        SettingsFrameStroke.Color =
            Color3.fromRGB(
                0,
                150,
                220
            )

        SettingsFrameStroke.Thickness = 1.2
        SettingsFrameStroke.Parent =
            SettingsFrame

        -- ==================================================
        -- TÍTULO CONFIG
        -- ==================================================

        local SettingsTitle =
            Instance.new("TextLabel")

        SettingsTitle.Size =
            UDim2.new(
                1,
                -20,
                0,
                20
            )

        SettingsTitle.Position =
            UDim2.new(
                0,
                10,
                0,
                8
            )

        SettingsTitle.BackgroundTransparency = 1

        SettingsTitle.Text =
            "⚙  CONFIGURACIÓN"

        SettingsTitle.TextColor3 =
            Color3.fromRGB(
                0,
                210,
                255
            )

        SettingsTitle.Font =
            Enum.Font.GothamBold

        SettingsTitle.TextSize = 10
        SettingsTitle.TextXAlignment =
            Enum.TextXAlignment.Left

        SettingsTitle.ZIndex = 21
        SettingsTitle.Parent =
            SettingsFrame

        -- ==================================================
        -- TEXTO DE ESCALA
        -- ==================================================

        local ScaleLabel =
            Instance.new("TextLabel")

        ScaleLabel.Size =
            UDim2.new(
                1,
                -20,
                0,
                20
            )

        ScaleLabel.Position =
            UDim2.new(
                0,
                10,
                0,
                34
            )

        ScaleLabel.BackgroundTransparency = 1

        ScaleLabel.TextColor3 =
            Color3.fromRGB(
                200,
                215,
                230
            )

        ScaleLabel.Font =
            Enum.Font.GothamMedium

        ScaleLabel.TextSize = 9
        ScaleLabel.TextXAlignment =
            Enum.TextXAlignment.Left

        ScaleLabel.ZIndex = 21
        ScaleLabel.Parent =
            SettingsFrame

        -- ==================================================
        -- SLIDER
        -- ==================================================

        local Slider =
            Instance.new("Frame")

        Slider.Name =
            "ScaleSlider"

        Slider.Size =
            UDim2.new(
                1,
                -40,
                0,
                7
            )

        Slider.Position =
            UDim2.new(
                0,
                20,
                0,
                61
            )

        Slider.BackgroundColor3 =
            Color3.fromRGB(
                27,
                39,
                52
            )

        Slider.BorderSizePixel = 0
        Slider.ZIndex = 21

        Slider.Parent =
            SettingsFrame

        local SliderCorner =
            Instance.new("UICorner")

        SliderCorner.CornerRadius =
            UDim.new(
                1,
                0
            )

        SliderCorner.Parent =
            Slider

        local SliderFill =
            Instance.new("Frame")

        SliderFill.Size =
            UDim2.new(
                0.5,
                0,
                1,
                0
            )

        SliderFill.BackgroundColor3 =
            Color3.fromRGB(
                0,
                175,
                255
            )

        SliderFill.BorderSizePixel = 0
        SliderFill.ZIndex = 22

        SliderFill.Parent =
            Slider

        local SliderFillCorner =
            Instance.new("UICorner")

        SliderFillCorner.CornerRadius =
            UDim.new(
                1,
                0
            )

        SliderFillCorner.Parent =
            SliderFill

        local SliderKnob =
            Instance.new("TextButton")

        SliderKnob.Size =
            UDim2.new(
                0,
                17,
                0,
                17
            )

        SliderKnob.AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            )

        SliderKnob.Position =
            UDim2.new(
                0.5,
                0,
                0.5,
                0
            )

        SliderKnob.BackgroundColor3 =
            Color3.fromRGB(
                0,
                215,
                255
            )

        SliderKnob.Text = ""
        SliderKnob.AutoButtonColor = false
        SliderKnob.ZIndex = 23
        SliderKnob.Parent =
            Slider

        local SliderKnobCorner =
            Instance.new("UICorner")

        SliderKnobCorner.CornerRadius =
            UDim.new(
                1,
                0
            )

        SliderKnobCorner.Parent =
            SliderKnob

        -- ==================================================
        -- BOTONES DE ESCALA
        -- ==================================================

        local MinusButton =
            Instance.new("TextButton")

        MinusButton.Size =
            UDim2.new(
                0,
                40,
                0,
                27
            )

        MinusButton.Position =
            UDim2.new(
                0,
                15,
                0,
                91
            )

        MinusButton.BackgroundColor3 =
            Color3.fromRGB(
                17,
                27,
                38
            )

        MinusButton.Text = "−"

        MinusButton.TextColor3 =
            Color3.fromRGB(
                220,
                230,
                240
            )

        MinusButton.Font =
            Enum.Font.GothamBold

        MinusButton.TextSize = 16
        MinusButton.ZIndex = 21

        MinusButton.Parent =
            SettingsFrame

        local MinusCorner =
            Instance.new("UICorner")

        MinusCorner.CornerRadius =
            UDim.new(
                0,
                7
            )

        MinusCorner.Parent =
            MinusButton

        local ResetButton =
            Instance.new("TextButton")

        ResetButton.Size =
            UDim2.new(
                0,
                70,
                0,
                27
            )

        ResetButton.Position =
            UDim2.new(
                0.5,
                -35,
                0,
                91
            )

        ResetButton.BackgroundColor3 =
            Color3.fromRGB(
                17,
                27,
                38
            )

        ResetButton.Text =
            "REINICIAR"

        ResetButton.TextColor3 =
            Color3.fromRGB(
                120,
                190,
                220
            )

        ResetButton.Font =
            Enum.Font.GothamBold

        ResetButton.TextSize = 8
        ResetButton.ZIndex = 21

        ResetButton.Parent =
            SettingsFrame

        local ResetCorner =
            Instance.new("UICorner")

        ResetCorner.CornerRadius =
            UDim.new(
                0,
                7
            )

        ResetCorner.Parent =
            ResetButton

        local PlusButton =
            Instance.new("TextButton")

        PlusButton.Size =
            UDim2.new(
                0,
                40,
                0,
                27
            )

        PlusButton.Position =
            UDim2.new(
                1,
                -55,
                0,
                91
            )

        PlusButton.BackgroundColor3 =
            Color3.fromRGB(
                17,
                27,
                38
            )

        PlusButton.Text = "+"

        PlusButton.TextColor3 =
            Color3.fromRGB(
                220,
                230,
                240
            )

        PlusButton.Font =
            Enum.Font.GothamBold

        PlusButton.TextSize = 16
        PlusButton.ZIndex = 21

        PlusButton.Parent =
            SettingsFrame

        local PlusCorner =
            Instance.new("UICorner")

        PlusCorner.CornerRadius =
            UDim.new(
                0,
                7
            )

        PlusCorner.Parent =
            PlusButton

        -- ==================================================
        -- ESCALA
        -- ==================================================

        local function updateScale(
            value,
            shouldSave
        )

            value = tonumber(value)

            if not value then
                return
            end

            value = math.clamp(
                value,
                MIN_SCALE,
                MAX_SCALE
            )

            currentScale = value

            UIScale.Scale =
                currentScale

            local percentage =
                math.floor(
                    currentScale * 100 + 0.5
                )

            ScaleLabel.Text =
                "Tamaño de interfaz: "
                .. percentage
                .. "%"

            local alpha =
                (
                    currentScale
                    - MIN_SCALE
                )
                /
                (
                    MAX_SCALE
                    - MIN_SCALE
                )

            SliderFill.Size =
                UDim2.new(
                    alpha,
                    0,
                    1,
                    0
                )

            SliderKnob.Position =
                UDim2.new(
                    alpha,
                    0,
                    0.5,
                    0
                )

            if shouldSave then
                saveTokitoScale(
                    currentScale
                )
            end
        end

        updateScale(
            currentScale,
            false
        )

        -- ==================================================
        -- SLIDER
        -- ==================================================

        local function updateSlider(x)

            local left =
                Slider.AbsolutePosition.X

            local width =
                Slider.AbsoluteSize.X

            if width <= 0 then
                return
            end

            local alpha =
                math.clamp(
                    (x - left) / width,
                    0,
                    1
                )

            local newScale =
                MIN_SCALE
                +
                (
                    MAX_SCALE - MIN_SCALE
                )
                * alpha

            updateScale(
                newScale,
                true
            )
        end

        SliderKnob.InputBegan:Connect(
            function(input)

                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or input.UserInputType ==
                    Enum.UserInputType.Touch then

                    sliderDragging = true
                end
            end
        )

        Slider.InputBegan:Connect(
            function(input)

                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or input.UserInputType ==
                    Enum.UserInputType.Touch then

                    sliderDragging = true

                    updateSlider(
                        input.Position.X
                    )
                end
            end
        )

        table.insert(
            tokitoConnections,
            UserInputService.InputChanged:Connect(
                function(input)

                    if not sliderDragging then
                        return
                    end

                    if input.UserInputType ==
                        Enum.UserInputType.MouseMovement
                        or input.UserInputType ==
                        Enum.UserInputType.Touch then

                        updateSlider(
                            input.Position.X
                        )
                    end
                end
            )
        )

        table.insert(
            tokitoConnections,
            UserInputService.InputEnded:Connect(
                function(input)

                    if input.UserInputType ==
                        Enum.UserInputType.MouseButton1
                        or input.UserInputType ==
                        Enum.UserInputType.Touch then

                        sliderDragging = false
                    end
                end
            )
        )

        MinusButton.MouseButton1Click:Connect(
            function()

                updateScale(
                    currentScale - 0.05,
                    true
                )
            end
        )

        PlusButton.MouseButton1Click:Connect(
            function()

                updateScale(
                    currentScale + 0.05,
                    true
                )
            end
        )

        ResetButton.MouseButton1Click:Connect(
            function()

                updateScale(
                    DEFAULT_SCALE,
                    true
                )
            end
        )

        -- ==================================================
        -- ABRIR CONFIGURACIÓN
        -- ==================================================

        local settingsOpen = false

        SettingsBtn.MouseButton1Click:Connect(
            function()

                settingsOpen =
                    not settingsOpen

                SettingsFrame.Visible =
                    settingsOpen

                if settingsOpen then

                    SettingsBtn.BackgroundColor3 =
                        Color3.fromRGB(
                            0,
                            75,
                            115
                        )

                    SettingsBtn.TextColor3 =
                        Color3.fromRGB(
                            255,
                            255,
                            255
                        )

                else

                    SettingsBtn.BackgroundColor3 =
                        Color3.fromRGB(
                            18,
                            28,
                            40
                        )

                    SettingsBtn.TextColor3 =
                        Color3.fromRGB(
                            0,
                            190,
                            255
                        )
                end
            end
        )

        -- ==================================================
        -- MINIMIZAR
        -- ==================================================

        local minimized = false

        MinimizeBtn.MouseButton1Click:Connect(
            function()

                minimized =
                    not minimized

                settingsOpen = false
                SettingsFrame.Visible = false

                if minimized then

                    MainFrame:TweenSize(
                        UDim2.new(
                            0,
                            GUI_WIDTH,
                            0,
                            42
                        ),
                        "Out",
                        "Quad",
                        0.2,
                        true
                    )

                    Status.Visible = false
                    LaserButton.Visible = false

                    MinimizeBtn.Text = "+"

                else

                    MainFrame:TweenSize(
                        UDim2.new(
                            0,
                            GUI_WIDTH,
                            0,
                            GUI_HEIGHT
                        ),
                        "Out",
                        "Quad",
                        0.2,
                        true
                    )

                    task.delay(
                        0.06,
                        function()

                            if tokitoGui
                                and not minimized then

                                Status.Visible = true
                                LaserButton.Visible = true
                            end
                        end
                    )

                    MinimizeBtn.Text = "—"
                end
            end
        )

        -- ==================================================
        -- ARRASTRE REAL
        -- ==================================================

        local dragging = false
        local dragStart = nil
        local startPosition = nil
        local activeDragInput = nil

        DragHandle.InputBegan:Connect(
            function(input)

                if sliderDragging then
                    return
                end

                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or input.UserInputType ==
                    Enum.UserInputType.Touch then

                    dragging = true

                    dragStart =
                        input.Position

                    startPosition =
                        MainFrame.Position

                    activeDragInput =
                        input
                end
            end
        )

        table.insert(
            tokitoConnections,
            UserInputService.InputChanged:Connect(
                function(input)

                    if not dragging then
                        return
                    end

                    if input.UserInputType ==
                        Enum.UserInputType.MouseMovement then

                        local delta =
                            input.Position
                            -
                            dragStart

                        MainFrame.Position =
                            UDim2.new(
                                startPosition.X.Scale,
                                startPosition.X.Offset + delta.X,

                                startPosition.Y.Scale,
                                startPosition.Y.Offset + delta.Y
                            )
                    end
                end
            )
        )

        table.insert(
            tokitoConnections,
            UserInputService.TouchMoved:Connect(
                function(
                    touch,
                    gameProcessed
                )

                    if not dragging then
                        return
                    end

                    if touch ~= activeDragInput then
                        return
                    end

                    local delta =
                        touch.Position
                        -
                        dragStart

                    MainFrame.Position =
                        UDim2.new(
                            startPosition.X.Scale,
                            startPosition.X.Offset + delta.X,

                            startPosition.Y.Scale,
                            startPosition.Y.Offset + delta.Y
                        )
                end
            )
        )

        table.insert(
            tokitoConnections,
            UserInputService.InputEnded:Connect(
                function(input)

                    if input.UserInputType ==
                        Enum.UserInputType.MouseButton1
                        or input.UserInputType ==
                        Enum.UserInputType.Touch then

                        if input.UserInputType ==
                            Enum.UserInputType.Touch
                            and activeDragInput
                            and input ~= activeDragInput then

                            return
                        end

                        if dragging then

                            dragging = false
                            activeDragInput = nil

                            saveTokitoPosition(
                                MainFrame.Position
                            )
                        end
                    end
                end
            )
        )

        -- ==================================================
        -- LASER
        -- ==================================================

        local laserActive = false
        local laserThread = nil

        local function setLaserVisual(active)

            if active then

                LaserButton.BackgroundColor3 =
                    Color3.fromRGB(
                        0,
                        170,
                        255
                    )

                LaserButton.TextColor3 =
                    Color3.fromRGB(
                        0,
                        0,
                        0
                    )

                LaserButton.Text =
                    "LASER ACTIVO"

                LaserStroke.Color =
                    Color3.fromRGB(
                        0,
                        220,
                        255
                    )

                Status.Text =
                    "● LASER ACTIVO"

                Status.TextColor3 =
                    Color3.fromRGB(
                        0,
                        220,
                        255
                    )

            else

                LaserButton.BackgroundColor3 =
                    Color3.fromRGB(
                        18,
                        28,
                        43
                    )

                LaserButton.TextColor3 =
                    Color3.fromRGB(
                        220,
                        230,
                        240
                    )

                LaserButton.Text =
                    "ACTIVAR LASER"

                LaserStroke.Color =
                    Color3.fromRGB(
                        0,
                        110,
                        180
                    )

                Status.Text =
                    "● LASER DESACTIVADO"

                Status.TextColor3 =
                    Color3.fromRGB(
                        120,
                        145,
                        165
                    )
            end
        end

        LaserButton.MouseButton1Click:Connect(
            function()

                pcall(function()

                    laserActive =
                        not laserActive

                    if laserActive then

                        local tool =
                            getLaserTool()

                        if not tool then

                            laserActive = false
                            setLaserVisual(false)

                            Status.Text =
                                "● LASER NO ENCONTRADO"

                            Status.TextColor3 =
                                Color3.fromRGB(
                                    255,
                                    90,
                                    90
                                )

                            task.delay(
                                1.5,
                                function()

                                    if tokitoGui
                                        and not laserActive then

                                        setLaserVisual(false)
                                    end
                                end
                            )

                            return
                        end

                        setLaserVisual(true)

                        local character =
                            LocalPlayer.Character

                        local humanoid =
                            character
                            and character:FindFirstChild(
                                "Humanoid"
                            )

                        if humanoid then
                            humanoid:EquipTool(tool)
                        end

                        if laserThread then
                            return
                        end

                        laserThread =
                            task.spawn(
                                function()

                                    while laserActive do

                                        local ok =
                                            pcall(
                                                function()

                                                    if not tool
                                                        or tool.Parent
                                                        ~= LocalPlayer.Character then

                                                        laserActive = false
                                                        return
                                                    end

                                                    tool:Activate()
                                                end
                                            )

                                        if not ok
                                            or not laserActive then

                                            break
                                        end

                                        task.wait(0.02)
                                    end

                                    laserThread = nil

                                    if tokitoGui
                                        and not laserActive then

                                        setLaserVisual(false)
                                    end
                                end
                            )

                    else

                        laserActive = false

                        setLaserVisual(false)
                    end
                end)
            end
        )

        -- ==================================================
        -- ANIMACIONES
        -- ==================================================

        MainFrame.Size =
            UDim2.new(
                0,
                0,
                0,
                0
            )

        MainFrame.BackgroundTransparency =
            1

        Title.TextTransparency = 1
        Subtitle.TextTransparency = 1
        Status.TextTransparency = 1
        Icon.TextTransparency = 1

        LaserButton.TextTransparency = 1
        LaserButton.BackgroundTransparency = 1

        Shadow.ImageTransparency = 1
        UIStroke.Transparency = 1

        MainFrame:TweenSize(
            UDim2.new(
                0,
                GUI_WIDTH,
                0,
                GUI_HEIGHT
            ),
            "Out",
            "Back",
            0.35,
            true
        )

        TweenService:Create(
            MainFrame,
            TweenInfo.new(
                0.3,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                BackgroundTransparency = 0.03
            }
        ):Play()

        task.delay(
            0.06,
            function()

                if not tokitoGui then
                    return
                end

                local fade =
                    TweenInfo.new(
                        0.2,
                        Enum.EasingStyle.Quad,
                        Enum.EasingDirection.Out
                    )

                TweenService:Create(
                    Shadow,
                    fade,
                    {
                        ImageTransparency = 0.35
                    }
                ):Play()

                TweenService:Create(
                    UIStroke,
                    fade,
                    {
                        Transparency = 0.15
                    }
                ):Play()

                TweenService:Create(
                    Icon,
                    fade,
                    {
                        TextTransparency = 0
                    }
                ):Play()

                TweenService:Create(
                    Title,
                    fade,
                    {
                        TextTransparency = 0
                    }
                ):Play()

                TweenService:Create(
                    Subtitle,
                    fade,
                    {
                        TextTransparency = 0
                    }
                ):Play()

                TweenService:Create(
                    Status,
                    fade,
                    {
                        TextTransparency = 0
                    }
                ):Play()

                TweenService:Create(
                    LaserButton,
                    fade,
                    {
                        BackgroundTransparency = 0,
                        TextTransparency = 0
                    }
                ):Play()
            end
        )

        -- ==================================================
        -- ANIMACIÓN RGB
        -- ==================================================

        table.insert(
            tokitoConnections,
            RunService.RenderStepped:Connect(
                function()

                    pcall(function()

                        if not ScreenGui.Parent then
                            return
                        end

                        local t =
                            tick() * 2

                        local blueShade =
                            Color3.fromHSV(
                                0.55
                                    + (
                                        math.sin(t)
                                        * 0.05
                                    ),
                                1,
                                1
                            )

                        UIStroke.Color =
                            blueShade

                        if laserActive then

                            LaserStroke.Color =
                                blueShade

                        else

                            LaserStroke.Color =
                                Color3.fromRGB(
                                    0,
                                    110,
                                    180
                                )
                        end

                        Title.TextColor3 =
                            blueShade
                    end)
                end
            )
        )
    end

    -- ====================================================
    -- DESTRUIR GUI
    -- ====================================================

    local function destroyTokitoGui()

        pcall(function()

            for _, conn in ipairs(
                tokitoConnections
            ) do

                if conn then
                    conn:Disconnect()
                end
            end

            tokitoConnections = {}

            if tokitoGui then
                tokitoGui:Destroy()
                tokitoGui = nil
            end
        end)
    end

    -- ====================================================
    -- TOGGLE
    -- ====================================================

    if createToggle then

        createToggle(
            "Auto Spam Laser (Se ocupa tener activo aimbot)",
            function(state)

                if state then
                    createTokitoGui()
                else
                    destroyTokitoGui()
                end
            end
        )
    end
end


-- ============================================================
-- FLYING CARPET SPEED UI NEON FIXED (Con Minimizar)
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}
Config = Config or { TpSettings = { Tool = "Flying Carpet" } }

do

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")

    local LocalPlayer = Players.LocalPlayer


    local Gui = Instance.new("ScreenGui")
    Gui.Name = "CarpetSpeedUI"
    Gui.ResetOnSpawn = false


    pcall(function()
        Gui.Parent = CoreGui
    end)

    if not Gui.Parent then
        Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Posición segura por defecto (Centro de la pantalla)
    local defaultPos = UDim2.new(0.5, -90, 0.5, -50)
    local framePos = defaultPos

    if Config["CarpetPos"] then
        local p = Config["CarpetPos"]
        if type(p) == "table" and #p >= 4 then
            framePos = UDim2.new(p[1], p[2], p[3], p[4])
        end
    end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,180,0,100)
    Frame.Position = framePos
    Frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
    Frame.BorderSizePixel = 0
    Frame.Visible = false
    Frame.Active = true
    -- Quitamos Frame.Draggable = true para usar el arrastre personalizado que guarda la pos
    Frame.ClipsDescendants = true -- Necesario para que no sobresalgan los botones al minimizar
    Frame.Parent = Gui


    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,8)
    Corner.Parent = Frame


    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0,200,255)
    Stroke.Thickness = 2
    Stroke.Parent = Frame



    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,25)
    Title.BackgroundTransparency = 1
    Title.Text = "Alfombra Speed"
    Title.TextColor3 = Color3.fromRGB(0,255,255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = Frame


    -- Botón de Minimizar
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 25, 0, 25)
    MinBtn.Position = UDim2.new(1, -25, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 18
    MinBtn.Parent = Frame



    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1,0,0,25)
    Status.Position = UDim2.new(0,0,0,25)
    Status.BackgroundTransparency = 1
    Status.Text = "Estado: OFF"
    Status.TextColor3 = Color3.fromRGB(255,50,50)
    Status.Parent = Frame



    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0,120,0,30)
    Button.Position = UDim2.new(0.5,-60,0,60)
    Button.BackgroundColor3 = Color3.fromRGB(20,20,25)
    Button.Text = " ENCENDER ON "
    Button.TextColor3 = Color3.fromRGB(0,255,0)
    Button.Parent = Frame


    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(0,255,0)
    ButtonStroke.Parent = Button


    -- Lógica de Minimizar
    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MinBtn.Text = "+"
            Frame.Size = UDim2.new(0, 180, 0, 25)
        else
            MinBtn.Text = "-"
            Frame.Size = UDim2.new(0, 180, 0, 100)
        end
    end)


    -- ================= LOGICA DE ARRASTRE Y GUARDADO =================
    local dragging = false
    local dragStart
    local startPos
    local dragInput

    local function updateDrag(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    Config["CarpetPos"] = {Frame.Position.X.Scale, Frame.Position.X.Offset, Frame.Position.Y.Scale, Frame.Position.Y.Offset}
                    if saveConfig then saveConfig() end
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            updateDrag(input)
        end
    end)
    -- ================= FIN DE LOGICA DE ARRASTRE =================


    local Enabled = false

    local function SetSpeed(state)

        Enabled = state
        State.carpetSpeedEnabled = state


        if Connections.carpetSpeedConnection then
            Connections.carpetSpeedConnection:Disconnect()
            Connections.carpetSpeedConnection = nil
        end



        if not state then

            Status.Text = "Estado: OFF"
            Status.TextColor3 = Color3.fromRGB(255,50,50)

            Button.Text = "ENCENDER ON"
            Button.TextColor3 = Color3.fromRGB(0,255,0)
            ButtonStroke.Color = Color3.fromRGB(0,255,0)

            return
        end



        Status.Text = "Estado: ON"
        Status.TextColor3 = Color3.fromRGB(0,255,255)

        Button.Text = "APAGAR OFF"
        Button.TextColor3 = Color3.fromRGB(255,50,50)
        ButtonStroke.Color = Color3.fromRGB(255,50,50)



        Connections.carpetSpeedConnection =
        RunService.Heartbeat:Connect(function()


            local Character = LocalPlayer.Character
            if not Character then return end


            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local Root = Character:FindFirstChild("HumanoidRootPart")

            if not Humanoid or not Root then return end



            local ToolName = "Flying Carpet"

            local Tool = Character:FindFirstChild(ToolName)



            if not Tool then

                local BackpackTool =
                LocalPlayer.Backpack:FindFirstChild(ToolName)

                if BackpackTool then
                    Humanoid:EquipTool(BackpackTool)
                    Tool = BackpackTool
                end

            end



            if Tool then

                local Direction = Humanoid.MoveDirection


                if Direction.Magnitude > 0 then

                    Root.AssemblyLinearVelocity =
                    Vector3.new(
                        Direction.X * 140,
                        Root.AssemblyLinearVelocity.Y,
                        Direction.Z * 140
                    )

                end

            end


        end)

    end




    Button.MouseButton1Click:Connect(function()
        SetSpeed(not Enabled)
    end)



    createToggle("Alfombra Speed", function(state)

        Frame.Visible = state

        if not state then
            SetSpeed(false)
            
            -- Resetea la posición al apagar el toggle
            Config["CarpetPos"] = nil
            if saveConfig then saveConfig() end
            Frame.Position = defaultPos
        end

    end)

end

-- ============================================================
-- RESET TOGGLE SYSTEM
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

do
    local ScriptLoaded = false

    local function SetReset(state)
        State.ResetEnabled = state

        if state then
            if not ScriptLoaded then
                ScriptLoaded = true
                
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/reset.lua"))()
                end)
            end
        else
        end
    end

    createToggle("Reset", function(state)
        SetReset(state)
    end)
end

-- skip intro
createToggle("Skip Intro", function(state)
	Config.SkipIntro = state
	saveConfig()
end)

-- ============================================================
-- SEMI INVISIBLE TOGGLE SYSTEM
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

do
    local ScriptLoaded = false -- Evita descargar el script múltiples veces

    local function SetSemiInvisible(state)
        State.SemiInvisibleEnabled = state

        if state then
            -- Si el toggle se activa por primera vez, ejecuta el script
            if not ScriptLoaded then
                ScriptLoaded = true
                
                -- Ejecución segura con pcall
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/s.lua"))()
                end)
            end
            
            -- Opcional: Si el script 's.lua' se enciende por variable global
            -- getgenv().SemiInvisible = true

        else
            -- Opcional: Si el script 's.lua' se apaga por variable global
            -- getgenv().SemiInvisible = false
        end
    end

    -- Creamos el toggle en tu interfaz
    createToggle("Semi Invisible", function(state)
        SetSemiInvisible(state)
    end)
end
-- ============================================================
-- STEAL FLOOR TOGGLE SYSTEM
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

do
    local ScriptLoaded = false

    local function SetStealFloor(state)
        State.StealFloorEnabled = state

        if state then
            -- Cargar el script una sola vez
            if not ScriptLoaded then
                ScriptLoaded = true

                pcall(function()
                    loadstring(game:HttpGet(
                        "https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/Stfl"
                    ))()
                end)
            end
        end
    end

    -- Toggle en la interfaz del hub
    createToggle("Steal Floor", function(state)
        SetStealFloor(state)
    end)
end
-- ============================================================
-- AUTO KICK AL ROBAR TOGGLE SYSTEM
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

do
    local ScriptLoaded = false

    local function SetAutoKickAlRobar(state)
        State.AutoKickAlRobarEnabled = state

        if state then
            -- Cargar el script una sola vez
            if not ScriptLoaded then
                ScriptLoaded = true

                pcall(function()
                    loadstring(game:HttpGet(
                        "https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/Atk"
                    ))()
                end)
            end
        end
    end

    -- Toggle en la interfaz del hub
    createToggle("Auto Kick Al Robar", function(state)
        SetAutoKickAlRobar(state)
    end)
end
-- ============================================================
-- TP TO BEST TOGGLE SYSTEM
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

do
    local ScriptLoaded = false -- Evita volver a descargar el script si ya se ejecutó

    local function SetTpToBest(state)
        State.TpToBestEnabled = state

        if state then
            -- Si el toggle se activa y es la primera vez, ejecutamos el loadstring
            if not ScriptLoaded then
                ScriptLoaded = true
                
                -- Ejecutamos el script externo de forma segura
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/u.lua"))()
                end)
            end
            
            -- Opcional: Si el script 'u.lua' usa una variable global para funcionar, 
            -- puedes activarla aquí. Ejemplo:
            -- getgenv().AutoTp = true

        else
            -- Si el toggle se apaga
            
            -- Opcional: Desactiva la variable global de 'u.lua' para detenerlo
            -- getgenv().AutoTp = false
        end
    end

    -- Creamos el toggle en la interfaz de tu hub
    createToggle("Tp To Best", function(state)
        SetTpToBest(state)
    end)
end
-- ============================================================
-- TOKITO AUTO RNG TOGGLE SYSTEM
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

do
    local ScriptLoaded = false

    local function SetTokitoAutoRNG(state)
        State.TokitoAutoRNGEnabled = state

        if state then
            if not ScriptLoaded then
                ScriptLoaded = true

                pcall(function()
                    loadstring(game:HttpGet("https://pastefy.app/YkMRrI7t/raw"))()
                end)
            end
        end
    end

    -- Toggle en la interfaz
    createToggle("Tokito Auto RNG", function(state)
        SetTokitoAutoRNG(state)
    end)
end
-- ============================================================
-- INVENTARIO CUSTOM TOGGLE SYSTEM
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

do
    local ScriptLoaded = false

    local function SetInventarioCustom(state)
        State.InventarioCustomEnabled = state

        if state then
            -- Cargar el inventario una sola vez
            if not ScriptLoaded then
                ScriptLoaded = true

                pcall(function()
                    loadstring(game:HttpGet(
                        "https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/inv.lua"
                    ))()
                end)
            end
        end
    end

    -- Toggle en la interfaz del hub
    createToggle("Inventario Custom", function(state)
        SetInventarioCustom(state)
    end)
end
-- ============================================================
-- AP SPAMMER TOGGLE SYSTEM
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

do
    local ScriptLoaded = false

    local AP_SPAMMER_URL =
        "https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/as"

    local function SetAPSpammer(state)
        State.APSpammerEnabled = state

        if state then
            -- Ejecutar una sola vez al activar
            if not ScriptLoaded then
                ScriptLoaded = true

                pcall(function()
                    loadstring(game:HttpGet(AP_SPAMMER_URL))()
                end)
            end

        else
            -- Desactivado.
            -- Si el script externo tiene una función/variable
            -- para detenerse, habría que conectarla aquí.
            State.APSpammerEnabled = false
        end
    end

    -- Toggle mostrado en la GUI
    createToggle("AP Spammer", function(state)
        SetAPSpammer(state)
    end)
end
-- ============================================================
-- AP CIRCLE TOGGLE SYSTEM
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}

do
    local ScriptLoaded = false

    local AP_CIRCLE_URL =
        "https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/ac"

    local function SetAPCircle(state)
        State.APCircleEnabled = state

        if state and not ScriptLoaded then
            ScriptLoaded = true

            pcall(function()
                loadstring(game:HttpGet(AP_CIRCLE_URL))()
            end)
        end
    end

    createToggle("AP Circle", function(state)
        SetAPCircle(state)
    end)
end
-- ============================================================
--  CLONAR TOGGLE SYSTEM
-- ============================================================

State = State or {}

do
    local ScriptLoaded = false

    local function SetClone(state)
        State.CloneEnabled = state
        getgenv().CloneEnabled = state

        if state then
            if not ScriptLoaded then
                ScriptLoaded = true

                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/Cl"))()
                end)
            end
        end
    end

    createToggle("Clonarse", function(state)
        SetClone(state)
    end)
end

-- ============================================================
-- TOKITO HUB - INICIALIZACIÓN GLOBAL SEGURA
-- ============================================================

State = State or {}
Connections = Connections or {}
SharedState = SharedState or {}
Config = Config or {}

-- ============================================================
-- TOKITO ESP BEST
-- BRAINROT MANAGER - PROFESSIONAL UI EDITION
-- ============================================================

do

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- ========================================================
-- CONFIGURACIÓN VISUAL
-- ========================================================

local COLORS = {

Background = Color3.fromRGB(8, 11, 18),    
Panel = Color3.fromRGB(12, 17, 27),    
Panel2 = Color3.fromRGB(16, 22, 34),    
Panel3 = Color3.fromRGB(20, 28, 42),    

Primary = Color3.fromRGB(0, 174, 255),    
PrimaryDark = Color3.fromRGB(0, 110, 205),    
PrimarySoft = Color3.fromRGB(88, 205, 255),    

Success = Color3.fromRGB(45, 221, 144),    
SuccessSoft = Color3.fromRGB(120, 255, 190),    

Danger = Color3.fromRGB(245, 70, 88),    
DangerDark = Color3.fromRGB(150, 35, 50),    

Warning = Color3.fromRGB(255, 193, 76),    

Text = Color3.fromRGB(245, 248, 255),    
TextSoft = Color3.fromRGB(170, 181, 200),    
TextMuted = Color3.fromRGB(105, 118, 140),    

Border = Color3.fromRGB(39, 51, 71),    
BorderSoft = Color3.fromRGB(31, 42, 59),    

Black = Color3.fromRGB(0, 0, 0)

}

local TWEEN_FAST =
TweenInfo.new(
0.12,
Enum.EasingStyle.Quart,
Enum.EasingDirection.Out
)

local TWEEN_NORMAL =
TweenInfo.new(
0.22,
Enum.EasingStyle.Quart,
Enum.EasingDirection.Out
)

local TWEEN_SMOOTH =
TweenInfo.new(
0.30,
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
)

-- ========================================================
-- ESTADO DEL ESP
-- ========================================================

local ignoredAnimals =
ignoredAnimals
or setmetatable({}, {__mode = "k"})

local animalESPEnabled = false

local espObjects =
espObjects
or {}

local animalESPCache =
animalESPCache
or {}

local animalESPThreshold = 0

local bestAnimalPart = nil
local bestAnimalValue = 0
local bestAnimalName = "Unknown"
local bestAnimalGenerationText = ""

local currentBeam = nil
local currentAttachments = {}

-- ========================================================
-- GUI STATE
-- ========================================================

local brainrotGui = nil
local launcherButton = nil

local mainWindow = nil
local mainScale = nil

local blacklistWindow = nil
local blacklistScale = nil

local bestNameLabel = nil
local bestValueLabel = nil
local bestGenerationLabel = nil
local statusLabel = nil
local hiddenCountLabel = nil
local enabledDot = nil

local blacklistSearch = nil
local blacklistList = nil
local blacklistCountLabel = nil
local blacklistEmptyLabel = nil

local menuOpen = false
local blacklistOpen = false

local guiConnections = {}

-- ========================================================
-- DECLARACIONES ANTICIPADAS
-- ========================================================

local clearAllESP
local updateBrainrotMenu
local rebuildBestAnimal
local createESPForPart
local startAnimalESP
local stopAnimalESP
local refreshESPAfterBlacklistChange

-- ========================================================
-- BLACKLIST
-- ========================================================

local BLACKLIST_SOURCE_URL =
"https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/br.txt"

local blacklistBrainrots = {}
local blacklistBrainrotNames = {}

local blacklistSourceLoaded = false
local blacklistLoading = false

-- ========================================================
-- UTILIDADES GUI
-- ========================================================

local function safeTween(object, tweenInfo, properties)

if not object then    
	return    
end    

pcall(function()    

	if object.Parent then    

		TweenService:Create(    
			object,    
			tweenInfo,    
			properties    
		):Play()    

	end    

end)

end

local function addCorner(object, radius)

local corner =    
	Instance.new("UICorner")    

corner.CornerRadius =    
	UDim.new(    
		0,    
		radius or 10    
	)    

corner.Parent = object    

return corner

end

local function addStroke(
object,
color,
thickness,
transparency
)

local stroke =    
	Instance.new("UIStroke")    

stroke.Color =    
	color or COLORS.Border    

stroke.Thickness =    
	thickness or 1    

stroke.Transparency =    
	transparency or 0    

stroke.Parent = object    

return stroke

end

local function addGradient(
object,
colorA,
colorB,
rotation
)

local gradient =    
	Instance.new("UIGradient")    

gradient.Color =    
	ColorSequence.new({    

		ColorSequenceKeypoint.new(    
			0,    
			colorA    
		),    

		ColorSequenceKeypoint.new(    
			1,    
			colorB    
		)    

	})    

gradient.Rotation =    
	rotation or 90    

gradient.Parent = object    

return gradient

end

local function createTextLabel(parent)

local label =    
	Instance.new(    
		"TextLabel"    
	)    

label.BackgroundTransparency = 1    
label.TextColor3 = COLORS.Text    
label.Font =    
	Enum.Font.GothamMedium    
label.TextSize = 12    
label.TextXAlignment =    
	Enum.TextXAlignment.Left    
label.Parent = parent    

return label

end

local function styleButton(button)

button.AutoButtonColor = false    
button.BorderSizePixel = 0    

addCorner(button, 9)    

local scale =    
	Instance.new("UIScale")    

scale.Scale = 1    
scale.Parent = button    

button.MouseEnter:Connect(function()    

	safeTween(    
		scale,    
		TWEEN_FAST,    
		{Scale = 1.025}    
	)    

end)    

button.MouseLeave:Connect(function()    

	safeTween(    
		scale,    
		TWEEN_FAST,    
		{Scale = 1}    
	)    

end)    

button.MouseButton1Down:Connect(function()    

	safeTween(    
		scale,    
		TWEEN_FAST,    
		{Scale = 0.97}    
	)    

end)    

button.MouseButton1Up:Connect(function()    

	safeTween(    
		scale,    
		TWEEN_FAST,    
		{Scale = 1.025}    
	)    

end)    

return scale

end

local function registerGuiConnection(connection)

if connection then    
	table.insert(    
		guiConnections,    
		connection    
	)    
end    

return connection

end

local function disconnectGuiConnections()

for _, connection in ipairs(    
	guiConnections    
) do    

	if typeof(connection)    
		== "RBXScriptConnection" then    

		pcall(function()    
			connection:Disconnect()    
		end)    

	end    

end    

table.clear(    
	guiConnections    
)

end

-- ========================================================
-- DRAG PROFESIONAL
-- ========================================================

local function makeDraggable(
handle,
object
)

local dragging = false    
local dragStart = nil    
local startPosition = nil    
local dragInput = nil    

registerGuiConnection(    
	handle.InputBegan:Connect(    
		function(input)    

			if input.UserInputType    
				== Enum.UserInputType.MouseButton1    
				or input.UserInputType    
				== Enum.UserInputType.Touch then    

				dragging = true    

				dragStart =    
					input.Position    

				startPosition =    
					object.Position    

				input.Changed:Connect(    
					function()    

						if input.UserInputState    
							== Enum.UserInputState.End then    

							dragging = false    

						end    

					end    
				)    

			end    

		end    
	)    
)    

registerGuiConnection(    
	handle.InputChanged:Connect(    
		function(input)    

			if input.UserInputType    
				== Enum.UserInputType.MouseMovement    
				or input.UserInputType    
				== Enum.UserInputType.Touch then    

				dragInput = input    

			end    

		end    
	)    
)    

registerGuiConnection(    
	UIS.InputChanged:Connect(    
		function(input)    

			if not dragging    
				or input ~= dragInput    
				or not object.Parent then    

				return    

			end    

			local delta =    
				input.Position    
				-    
				dragStart    

			object.Position =    
				UDim2.new(    
					startPosition.X.Scale,    
					startPosition.X.Offset + delta.X,    
					startPosition.Y.Scale,    
					startPosition.Y.Offset + delta.Y    
				)    

		end    
	)    
)

end

-- ========================================================
-- NORMALIZAR NOMBRE
-- ========================================================

local function normalizeBrainrotName(name)

return tostring(name or "")    
	:lower()    
	:gsub("%s+", " ")    
	:gsub("^%s+", "")    
	:gsub("%s+$", "")

end

-- ========================================================
-- LOAD BLACKLIST
-- ========================================================

local function loadSavedBrainrotBlacklist()

pcall(function()    

	if type(Config) ~= "table" then    
		return    
	end    

	local saved =    
		Config["BrainrotBlacklist"]    

	if type(saved) ~= "table" then    
		return    
	end    

	for _, name in pairs(saved) do    

		if type(name) == "string" then    

			local normalized =    
				normalizeBrainrotName(    
					name    
				)    

			if normalized ~= "" then    

				blacklistBrainrots[    
					normalized    
				] = true    

			end    

		end    

	end    

end)

end

loadSavedBrainrotBlacklist()

-- ========================================================
-- SAVE BLACKLIST
-- ========================================================

local function saveBrainrotBlacklist()

pcall(function()    

	if type(Config) ~= "table" then    
		return    
	end    

	local saved = {}    

	for normalizedName, state in pairs(    
		blacklistBrainrots    
	) do    

		if state == true    
			and type(normalizedName)    
			== "string"    
			and normalizedName ~= "" then    

			table.insert(    
				saved,    
				normalizedName    
			)    

		end    

	end    

	table.sort(saved)    

	Config["BrainrotBlacklist"] =    
		saved    

	if type(saveConfig)    
		== "function" then    

		pcall(saveConfig)    

	end    

end)

end

-- ========================================================
-- CHECK BLACKLIST
-- ========================================================

local function isBrainrotBlacklisted(name)

local normalized =    
	normalizeBrainrotName(name)    

if normalized == "" then    
	return false    
end    

return    
	blacklistBrainrots[    
		normalized    
	]    
	== true

end

-- ========================================================
-- REMOTE BLACKLIST
-- ========================================================

local function loadBlacklistBrainrotNames()

if blacklistSourceLoaded then    
	return true    
end    

if blacklistLoading then    
	return false    
end    

blacklistLoading = true    

local response = nil    
local success = false    

pcall(function()    

	response =    
		game:HttpGet(    
			BLACKLIST_SOURCE_URL,    
			true    
		)    

	if response    
		and tostring(response) ~= "" then    

		success = true    

	end    

end)    

if not success then    

	pcall(function()    

		local HttpService =    
			game:GetService(    
				"HttpService"    
			)    

		response =    
			HttpService:GetAsync(    
				BLACKLIST_SOURCE_URL    
			)    

		if response    
			and tostring(response) ~= "" then    

			success = true    

		end    

	end)    

end    

if not success then    

	blacklistLoading = false    
	return false    

end    

table.clear(    
	blacklistBrainrotNames    
)    

local seen = {}    

for line in tostring(    
	response    
):gmatch("[^\r\n]+") do    

	line =    
		line:gsub(    
			"^%s+",    
			""    
		)    

	line =    
		line:gsub(    
			"%s+$",    
			""    
		)    

	if line ~= "" then    

		local normalized =    
			normalizeBrainrotName(    
				line    
			)    

		if normalized ~= ""    
			and not seen[normalized] then    

			seen[normalized] = true    

			table.insert(    
				blacklistBrainrotNames,    
				line    
			)    

		end    

	end    

end    

table.sort(    
	blacklistBrainrotNames,    
	function(a, b)    

		return    
			normalizeBrainrotName(a)    
			<    
			normalizeBrainrotName(b)    

	end    
)    

blacklistSourceLoaded =    
	#blacklistBrainrotNames > 0    

blacklistLoading = false    

return blacklistSourceLoaded

end

-- ========================================================
-- BLACKLIST COUNT
-- ========================================================

local function getBlacklistCount()

local count = 0    

for _, state in pairs(    
	blacklistBrainrots    
) do    

	if state == true then    
		count += 1    
	end    

end    

return count

end

-- ========================================================
-- BLACKLIST SEARCH
-- ========================================================

local function getFilteredBlacklistNames(
searchText
)

loadBlacklistBrainrotNames()    

local search =    
	normalizeBrainrotName(    
		searchText    
	)    

local results = {}    

for index, name in ipairs(    
	blacklistBrainrotNames    
) do    

	local normalized =    
		normalizeBrainrotName(    
			name    
		)    

	local matchStart =    
		normalized:find(    
			search,    
			1,    
			true    
		)    

	if search == ""    
		or matchStart then    

		local score = 0    

		if search == "" then    

			score = 500    

		elseif normalized == search then    

			score = 10000    

		elseif normalized:sub(    
			1,    
			#search    
		) == search then    

			score = 9000    

		else    

			local words = {}    

			for word in normalized:gmatch(    
				"%S+"    
			) do    

				table.insert(    
					words,    
					word    
				)    

			end    

			for _, word in ipairs(    
				words    
			) do    

				if word:sub(    
					1,    
					#search    
				) == search then    

					score =    
						math.max(    
							score,    
							8000    
						)    

				end    

			end    

			if score == 0 then    

				score =    
					7000    
					-    
					matchStart    

			end    

		end    

		table.insert(    
			results,    
			{    
				name = name,    
				index = index,    
				matchScore = score    
			}    
		)    

	end    

end    

table.sort(    
	results,    
	function(a, b)    

		if a.matchScore    
			~=    
			b.matchScore then    

			return    
				a.matchScore    
				>    
				b.matchScore    

		end    

		return    
			a.index    
			<    
			b.index    

	end    
)    

return results

end

-- ========================================================
-- PARSE ANIMAL
-- ========================================================

local function parseAnimalData(part)

local success, result =    
	pcall(function()    

		if not part    
			or not part.Parent    
			or not part:IsDescendantOf(    
				Workspace    
			) then    

			return nil    

		end    

		local overhead =    
			part:FindFirstChild(    
				"AnimalOverhead"    
			)    

		if not overhead    
			or not overhead:IsA(    
				"SurfaceGui"    
			) then    

			return nil    

		end    

		local generationLabel =    
			overhead:FindFirstChild(    
				"Generation"    
			)    

		local displayNameLabel =    
			overhead:FindFirstChild(    
				"DisplayName"    
			)    

		if not generationLabel    
			or not displayNameLabel then    

			return nil    

		end    

		local generationText =    
			tostring(    
				generationLabel.Text    
				or ""    
			)    

		local animalName =    
			tostring(    
				displayNameLabel.Text    
				or ""    
			)    

		if generationText == ""    
			or animalName == "" then    

			return nil    

		end    

		local firstValue =    
			generationText:match(    
				"^%$([^%s]+)/s"    
			)    

		if not firstValue then    

			firstValue =    
				generationText:match(    
					"^%$([^/]+)/s"    
				)    

		end    

		if not firstValue then    
			return nil    
		end    

		local cleanText =    
			firstValue:gsub(    
				"%s+",    
				""    
			)    

		local multiplier = 1    

		if cleanText:find("T") then    

			multiplier =    
				1000000000000    

			cleanText =    
				cleanText:gsub(    
					"T",    
					""    
				)    

		elseif cleanText:find("B") then    

			multiplier =    
				1000000000    

			cleanText =    
				cleanText:gsub(    
					"B",    
					""    
				)    

		elseif cleanText:find("M") then    

			multiplier =    
				1000000    

			cleanText =    
				cleanText:gsub(    
					"M",    
					""    
				)    

		elseif cleanText:find("K") then    

			multiplier =    
				1000    

			cleanText =    
				cleanText:gsub(    
					"K",    
					""    
				)    

		end    

		local numberValue =    
			tonumber(    
				cleanText    
			)    

		if not numberValue then    
			return nil    
		end    

		return {    

			value =    
				numberValue    
				*    
				multiplier,    

			name =    
				animalName,    

			generation =    
				generationText    

		}    

	end)    

if success then    
	return result    
end    

return nil

end

-- ========================================================
-- FORMAT VALUE
-- ========================================================

local function formatBrainrotValue(value)

if not value or value <= 0 then    
	return "$0/s"    
end    

if value >=    
	1000000000000 then    

	return string.format(    
		"$%.2fT/s",    
		value /    
		1000000000000    
	)    

elseif value >=    
	1000000000 then    

	return string.format(    
		"$%.2fB/s",    
		value /    
		1000000000    
	)    

elseif value >=    
	1000000 then    

	return string.format(    
		"$%.2fM/s",    
		value /    
		1000000    
	)    

elseif value >=    
	1000 then    

	return string.format(    
		"$%.2fK/s",    
		value /    
		1000    
	)    

end    

return string.format(    
	"$%d/s",    
	math.floor(value)    
)

end

-- ========================================================
-- CLEAR ESP
-- ========================================================

clearAllESP = function()

for _, object in ipairs(    
	espObjects    
) do    

	if object then    

		pcall(function()    
			object:Destroy()    
		end)    

	end    

end    

table.clear(    
	espObjects    
)    

if currentBeam then    

	pcall(function()    
		currentBeam:Destroy()    
	end)    

	currentBeam = nil    

end    

for _, attachment in pairs(    
	currentAttachments    
) do    

	pcall(function()    
		attachment:Destroy()    
	end)    

end    

table.clear(    
	currentAttachments    
)

end

-- ========================================================
-- CREATE BEAM
-- ========================================================

local function createBeam(part)

if not part    
	or not part.Parent then    
	return    
end    

clearAllESP()    

local character =    
	LocalPlayer.Character    

if not character then    
	return    
end    

local hrp =    
	character:FindFirstChild(    
		"HumanoidRootPart"    
	)    

if not hrp then    
	return    
end    

local attachment0 =    
	Instance.new(    
		"Attachment"    
	)    

attachment0.Name =    
	"TokitoESP_PlayerAttachment"    

attachment0.Parent =    
	hrp    

local attachment1 =    
	Instance.new(    
		"Attachment"    
	)    

attachment1.Name =    
	"TokitoESP_TargetAttachment"    

attachment1.Parent =    
	part    

local beam =    
	Instance.new(    
		"Beam"    
	)    

beam.Name =    
	"TokitoESP_Beam"    

beam.Attachment0 =    
	attachment0    

beam.Attachment1 =    
	attachment1    

beam.Width0 = 0.4    
beam.Width1 = 0.4    
beam.FaceCamera = true    
beam.LightEmission = 1    
beam.Brightness = 5    

beam.Color =    
	ColorSequence.new(    
		Color3.fromRGB(    
			0,    
			255,    
			120    
		)    
	)    

beam.Parent =    
	hrp    

currentBeam =    
	beam    

currentAttachments = {    
	attachment0,    
	attachment1    
}

end

-- ========================================================
-- CREATE ESP
-- ========================================================

createESPForPart = function(part)

if not animalESPEnabled then    
	return    
end    

if not part    
	or not part.Parent    
	or not part:IsDescendantOf(    
		Workspace    
	) then    
	return    
end    

if ignoredAnimals[part] then    
	return    
end    

local data =    
	parseAnimalData(part)    

if not data then    
	return    
end    

if data.value <    
	animalESPThreshold then    
	return    
end    

if isBrainrotBlacklisted(    
	data.name    
) then    
	return    
end    

if bestAnimalPart    
	and bestAnimalPart ~= part    
	and data.value <    
		bestAnimalValue then    
	return    
end    

-- Solamente destruimos los objetos ESP anteriores.    
-- No destruimos conexiones ni otros elementos del hub.    
for _, object in ipairs(    
	espObjects    
) do    

	if object then    

		pcall(function()    
			object:Destroy()    
		end)    

	end    

end    

table.clear(    
	espObjects    
)    

if currentBeam then    

	pcall(function()    
		currentBeam:Destroy()    
	end)    

	currentBeam = nil    

end    

for _, attachment in pairs(    
	currentAttachments    
) do    

	pcall(function()    
		attachment:Destroy()    
	end)    

end    

table.clear(    
	currentAttachments    
)    

bestAnimalPart =    
	part    

bestAnimalValue =    
	data.value    

bestAnimalName =    
	data.name    

bestAnimalGenerationText =    
	data.generation    

local billboard =    
	Instance.new(    
		"BillboardGui"    
	)    

billboard.Name =    
	"TokitoBestESP"    

billboard.Adornee =    
	part    

billboard.Size =    
	UDim2.new(    
		0,    
		260,    
		0,    
		70   
	)    

billboard.StudsOffset =    
	Vector3.new(    
		0,    
		-3,    
		0    
	)    

billboard.AlwaysOnTop =    
	true    

billboard.MaxDistance =    
	math.huge    

billboard.Parent =    
	part    

local nameLabel =
	Instance.new(
		"TextLabel"
	)

nameLabel.Size =
	UDim2.new(
		1,
		0,
		0,
		30
	)

nameLabel.Position =
	UDim2.new(
		0,
		0,
		0,
		0
	)

nameLabel.BackgroundTransparency =
	1

nameLabel.Text =
	data.name

nameLabel.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

nameLabel.TextStrokeTransparency =
	0

nameLabel.TextStrokeColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

nameLabel.Font =
	Enum.Font.GothamBold

nameLabel.TextSize =
	24

nameLabel.Parent =
	billboard

local generationLabel =
	Instance.new(
		"TextLabel"
	)

generationLabel.Size =
	UDim2.new(
		1,
		0,
		0,
		30
	)

generationLabel.Position =
	UDim2.new(
		0,
		0,
		0,
		30
	)

generationLabel.BackgroundTransparency =
	1

generationLabel.Text =
	data.generation

generationLabel.TextColor3 =
	Color3.fromRGB(
		0,
		255,
		120
	)

generationLabel.TextStrokeTransparency =
	0

generationLabel.TextStrokeColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

generationLabel.Font =
	Enum.Font.GothamBold

generationLabel.TextSize =
	22

generationLabel.Parent =
	billboard

animalESPCache[part] =    
	billboard    

table.insert(    
	espObjects,    
	billboard    
)    

-- Beam separado para evitar que clearAllESP    
-- destruya el Billboard recién creado.    
local character =    
	LocalPlayer.Character    

local hrp =    
	character    
	and character:FindFirstChild(    
		"HumanoidRootPart"    
	)    

if hrp then    

	local attachment0 =    
		Instance.new(    
			"Attachment"    
		)    

	attachment0.Name =    
		"TokitoESP_PlayerAttachment"    

	attachment0.Parent =    
		hrp    

	local attachment1 =    
		Instance.new(    
			"Attachment"    
		)    

	attachment1.Name =    
		"TokitoESP_TargetAttachment"    

	attachment1.Parent =    
		part    

	local beam =    
		Instance.new(    
			"Beam"    
		)    

	beam.Name =    
		"TokitoESP_Beam"    

	beam.Attachment0 =    
		attachment0    

	beam.Attachment1 =    
		attachment1    

	beam.Width0 =    
		0.4    

	beam.Width1 =    
		0.4    

	beam.FaceCamera =    
		true    

	beam.LightEmission =    
		1    

	beam.Brightness =    
		5    

	beam.Color =    
		ColorSequence.new(    
			COLORS.Success    
		)    

	beam.Parent =    
		hrp    

	currentBeam =    
		beam    

	currentAttachments = {    
		attachment0,    
		attachment1    
	}    

end    

updateBrainrotMenu()

end

-- ========================================================
-- REBUILD BEST
-- ========================================================

rebuildBestAnimal =
function(debris)

if not debris    
		or not animalESPEnabled then    

		return    

	end    

	local bestPart =    
		nil    

	local bestValue =    
		0    

	local bestName =    
		"Unknown"    

	local bestGen =    
		""    

	for _, part in ipairs(    
		debris:GetChildren()    
	) do    

		if part.Name ==    
			"FastOverheadTemplate"    
			and part:IsA(    
				"BasePart"    
			) then    

			if not ignoredAnimals[    
				part    
			] then    

				local data =    
					parseAnimalData(    
						part    
					)    

				if data    
					and data.value >=    
						animalESPThreshold    
					and not isBrainrotBlacklisted(    
						data.name    
					) then    

					if data.value >    
						bestValue then    

						bestValue =    
							data.value    

						bestPart =    
							part    

						bestName =    
							data.name    

						bestGen =    
							data.generation    

					end    

				end    

			end    

		end    

	end    

	-- Limpiar solamente el ESP 3D actual.    
	if bestAnimalPart ~= bestPart then    
		clearAllESP()    
	end    

	bestAnimalPart =    
		bestPart    

	bestAnimalValue =    
		bestValue    

	bestAnimalName =    
		bestName    

	bestAnimalGenerationText =    
		bestGen    

	if bestPart then    

		createESPForPart(    
			bestPart    
		)    

	else    

		clearAllESP()    

		updateBrainrotMenu()    

	end    

end

-- ========================================================
-- UPDATE MAIN UI
-- ========================================================

updateBrainrotMenu =
function()

if not mainWindow    
		or not mainWindow.Parent then    

		return    

	end    

	local found =    
		bestAnimalPart    
		and bestAnimalPart.Parent    

	if found then    

		bestNameLabel.Text =    
			tostring(    
				bestAnimalName    
			)    

		bestValueLabel.Text =    
			formatBrainrotValue(    
				bestAnimalValue    
			)    

		bestGenerationLabel.Text =    
			bestAnimalGenerationText    

		statusLabel.Text =    
			"TARGET DETECTADO"    

		statusLabel.TextColor3 =    
			COLORS.Success    

		enabledDot.BackgroundColor3 =    
			COLORS.Success    

	else    

		bestNameLabel.Text =    
			"Ninguno detectado"    

		bestValueLabel.Text =    
			"$0/s"    

		bestGenerationLabel.Text =    
			"Esperando brainrots..."    

		statusLabel.Text =    
			"BUSCANDO..."    

		statusLabel.TextColor3 =    
			COLORS.Warning    

		enabledDot.BackgroundColor3 =    
			COLORS.Warning    

	end    

	local hidden =    
		0    

	for _ in pairs(    
		ignoredAnimals    
	) do    
		hidden += 1    
	end    

	hiddenCountLabel.Text =    
		tostring(    
			hidden    
		)    
		..    
		" ocultados"    

end

-- ========================================================
-- HIDE CURRENT
-- ========================================================

local function hideCurrentBestBrainrot()

if not bestAnimalPart    
	or not bestAnimalPart.Parent then    

	return    

end    

ignoredAnimals[    
	bestAnimalPart    
] = {    
	name =    
		bestAnimalName,    

	value =    
		bestAnimalValue,    

	generation =    
		bestAnimalGenerationText    
}    

local debris =    
	Workspace:FindFirstChild(    
		"Debris"    
	)    

if debris then    

	rebuildBestAnimal(    
		debris    
	)    

else    

	clearAllESP()    

	bestAnimalPart = nil    
	bestAnimalValue = 0    
	bestAnimalName = "Unknown"    
	bestAnimalGenerationText = ""    

	updateBrainrotMenu()    

end

end

-- ========================================================
-- SHOW ALL
-- ========================================================

local function showAllBrainrots()

table.clear(    
	ignoredAnimals    
)    

local debris =    
	Workspace:FindFirstChild(    
		"Debris"    
	)    

if debris then    

	rebuildBestAnimal(    
		debris    
	)    

else    

	clearAllESP()    

	bestAnimalPart = nil    
	bestAnimalValue = 0    
	bestAnimalName = "Unknown"    
	bestAnimalGenerationText = ""    

	updateBrainrotMenu()    

end

end

-- ========================================================
-- CREATE MAIN GUI
-- ========================================================

local function createMainGUI()

if brainrotGui    
	and brainrotGui.Parent then    

	return    

end    

brainrotGui =    
	Instance.new(    
		"ScreenGui"    
	)    

brainrotGui.Name =    
	"TokitoBrainrotESP"    

brainrotGui.ResetOnSpawn =    
	false    

brainrotGui.IgnoreGuiInset =    
	true    

brainrotGui.ZIndexBehavior =    
	Enum.ZIndexBehavior.Sibling    

pcall(function()    
	brainrotGui.Parent =    
		gethui()    
end)    

if not brainrotGui.Parent then    

	brainrotGui.Parent =    
		game:GetService(    
			"CoreGui"    
		)    

end    

-- ====================================================    
-- MAIN WINDOW    
-- ====================================================    

mainWindow =    
	Instance.new(    
		"Frame"    
	)    

mainWindow.Name =    
	"Manager"    

mainWindow.AnchorPoint =    
	Vector2.new(    
		0.5,    
		0.5    
	)    

mainWindow.Position =    
	UDim2.new(    
		0.5,    
		0,    
		0.5,    
		0    
	)    

mainWindow.Size =    
	UDim2.new(    
		0,    
		390,    
		0,    
		295    
	)    

mainWindow.BackgroundColor3 =    
	COLORS.Background    

mainWindow.BorderSizePixel =    
	0    

mainWindow.Visible =    
	false    

mainWindow.Parent =    
	brainrotGui    

addCorner(    
	mainWindow,    
	16    
)    

addStroke(    
	mainWindow,    
	COLORS.Border,    
	1.2,    
	0.15    
)    

addGradient(    
	mainWindow,    
	Color3.fromRGB(    
		13,    
		19,    
		30    
	),    
	Color3.fromRGB(    
		7,    
		11,    
		18    
	),    
	90    
)    

mainScale =    
	Instance.new(    
		"UIScale"    
	)    

mainScale.Scale =    
	0.92    

mainScale.Parent =    
	mainWindow    

-- ====================================================    
-- HEADER    
-- ====================================================    

local header =    
	Instance.new(    
		"Frame"    
	)    

header.Size =    
	UDim2.new(    
		1,    
		0,    
		0,    
		62    
	)    

header.BackgroundColor3 =    
	COLORS.Panel2    

header.BorderSizePixel =    
	0    

header.Parent =    
	mainWindow    

addCorner(    
	header,    
	16    
)    

local headerBottom =    
	Instance.new(    
		"Frame"    
	)    

headerBottom.Size =    
	UDim2.new(    
		1,    
		0,    
		0,    
		14    
	)    

headerBottom.Position =    
	UDim2.new(    
		0,    
		0,    
		1,    
		-14    
	)    

headerBottom.BackgroundColor3 =    
	COLORS.Panel2    

headerBottom.BorderSizePixel =    
	0    

headerBottom.Parent =    
	header    

local accent =    
	Instance.new(    
		"Frame"    
	)    

accent.Size =    
	UDim2.new(    
		0,    
		4,    
		0,    
		32    
	)    

accent.Position =    
	UDim2.new(    
		0,    
		16,    
		0.5,    
		-16    
	)    

accent.BackgroundColor3 =    
	COLORS.Primary    

accent.BorderSizePixel =    
	0    

accent.Parent =    
	header    

addCorner(    
	accent,    
	3    
)    

local title =    
	createTextLabel(    
		header    
	)    

title.Size =    
	UDim2.new(    
		1,    
		-100,    
		0,    
		25    
	)    

title.Position =    
	UDim2.new(    
		0,    
		30,    
		0,    
		10    
	)    

title.Text =    
	"Brainrot Manager"    

title.Font =    
	Enum.Font.GothamBold    

title.TextSize =    
	17    

local subtitle =    
	createTextLabel(    
		header    
	)    

subtitle.Size =    
	UDim2.new(    
		1,    
		-100,    
		0,    
		20    
	)    

subtitle.Position =    
	UDim2.new(    
		0,    
		30,    
		0,    
		33    
	)    

subtitle.Text =    
	"ESP Best  •  Tracking inteligente"    

subtitle.Font =    
	Enum.Font.Gotham    

subtitle.TextSize =    
	10    

subtitle.TextColor3 =    
	COLORS.TextMuted    

-- Close    

local closeButton =    
	Instance.new(    
		"TextButton"    
	)    

closeButton.Size =    
	UDim2.new(    
		0,    
		30,    
		0,    
		30    
	)    

closeButton.Position =    
	UDim2.new(    
		1,    
		-43,    
		0,    
		16    
	)    

closeButton.BackgroundColor3 =    
	Color3.fromRGB(    
		30,    
		39,    
		54    
	)    

closeButton.Text =    
	"×"    

closeButton.TextColor3 =    
	COLORS.TextSoft    

closeButton.Font =    
	Enum.Font.GothamBold    

closeButton.TextSize =    
	18    

closeButton.Parent =    
	header    

styleButton(    
	closeButton    
)    

closeButton.MouseButton1Click:Connect(    
	function()    

		menuOpen = false    

		safeTween(    
			mainScale,    
			TWEEN_NORMAL,    
			{Scale = 0.92}    
		)    

		task.delay(    
			0.20,    
			function()    

				if mainWindow then    
					mainWindow.Visible =    
						false    
				end    

			end    
		)    

	end    
)    

makeDraggable(    
	header,    
	mainWindow    
)    

-- ====================================================    
-- STATUS CARD    
-- ====================================================    

local statusCard =    
	Instance.new(    
		"Frame"    
	)    

statusCard.Size =    
	UDim2.new(    
		1,    
		-32,    
		0,    
		66    
	)    

statusCard.Position =    
	UDim2.new(    
		0,    
		16,    
		0,    
		76    
	)    

statusCard.BackgroundColor3 =    
	COLORS.Panel2    

statusCard.BorderSizePixel =    
	0    

statusCard.Parent =    
	mainWindow    

addCorner(    
	statusCard,    
	12    
)    

addStroke(    
	statusCard,    
	COLORS.BorderSoft,    
	1,    
	0.2    
)    

enabledDot =    
	Instance.new(    
		"Frame"    
	)    

enabledDot.Size =    
	UDim2.new(    
		0,    
		9,    
		0,    
		9    
	)    

enabledDot.Position =    
	UDim2.new(    
		0,    
		14,    
		0,    
		15    
	)    

enabledDot.BackgroundColor3 =    
	COLORS.Success    

enabledDot.BorderSizePixel =    
	0    

enabledDot.Parent =    
	statusCard    

addCorner(    
	enabledDot,    
	5    
)    

statusLabel =    
	createTextLabel(    
		statusCard    
	)    

statusLabel.Size =    
	UDim2.new(    
		1,    
		-42,    
		0,    
		18    
	)    

statusLabel.Position =    
	UDim2.new(    
		0,    
		31,    
		0,    
		10    
	)    

statusLabel.Text =    
	"BUSCANDO..."    

statusLabel.TextColor3 =    
	COLORS.Success    

statusLabel.Font =    
	Enum.Font.GothamBold    

statusLabel.TextSize =    
	10    

local statusInfo =    
	createTextLabel(    
		statusCard    
	)    

statusInfo.Size =    
	UDim2.new(    
		1,    
		-42,    
		0,    
		25    
	)    

statusInfo.Position =    
	UDim2.new(    
		0,    
		31,    
		0,    
		28    
	)    

statusInfo.Text =    
	"El ESP está buscando el brainrot de mayor valor"    

statusInfo.TextColor3 =    
	COLORS.TextMuted    

statusInfo.Font =    
	Enum.Font.Gotham    

statusInfo.TextSize =    
	9    

-- ====================================================    
-- BEST CARD    
-- ====================================================    

local bestCard =    
	Instance.new(    
		"Frame"    
	)    

bestCard.Size =    
	UDim2.new(    
		1,    
		-32,    
		0,    
		82    
	)    

bestCard.Position =    
	UDim2.new(    
		0,    
		16,    
		0,    
		150    
	)    

bestCard.BackgroundColor3 =    
	Color3.fromRGB(    
		10,    
		27,    
		29    
	)    

bestCard.BorderSizePixel =    
	0    

bestCard.Parent =    
	mainWindow    

addCorner(    
	bestCard,    
	12    
)    

local bestStroke =    
	addStroke(    
		bestCard,    
		COLORS.Success,    
		1,    
		0.35    
	)    

local bestAccent =    
	Instance.new(    
		"Frame"    
	)    

bestAccent.Size =    
	UDim2.new(    
		0,    
		4,    
		1,    
		-20    
	)    

bestAccent.Position =    
	UDim2.new(    
		0,    
		10,    
		0,    
		10    
	)    

bestAccent.BackgroundColor3 =    
	COLORS.Success    

bestAccent.BorderSizePixel =    
	0    

bestAccent.Parent =    
	bestCard    

addCorner(    
	bestAccent,    
	3    
)    

local bestCaption =    
	createTextLabel(    
		bestCard    
	)    

bestCaption.Size =    
	UDim2.new(    
		0.48,    
		0,    
		0,    
		15    
	)    

bestCaption.Position =    
	UDim2.new(    
		0,    
		24,    
		0,    
		10    
	)    

bestCaption.Text =    
	"BEST DETECTADO"    

bestCaption.TextColor3 =    
	COLORS.SuccessSoft    

bestCaption.Font =    
	Enum.Font.GothamBold    

bestCaption.TextSize =    
	9    

bestNameLabel =    
	createTextLabel(    
		bestCard    
	)    

bestNameLabel.Size =    
	UDim2.new(    
		0.62,    
		0,    
		0,    
		25    
	)    

bestNameLabel.Position =    
	UDim2.new(    
		0,    
		24,    
		0,    
		27    
	)    

bestNameLabel.Text =    
	"Ninguno detectado"    

bestNameLabel.Font =    
	Enum.Font.GothamBold    

bestNameLabel.TextSize =    
	15    

bestNameLabel.TextTruncate =    
	Enum.TextTruncate.AtEnd    

bestValueLabel =    
	createTextLabel(    
		bestCard    
	)    

bestValueLabel.Size =    
	UDim2.new(    
		0.35,    
		-18,    
		0,    
		25    
	)    

bestValueLabel.Position =    
	UDim2.new(    
		0.65,    
		0,    
		0,    
		23    
	)    

bestValueLabel.Text =    
	"$0/s"    

bestValueLabel.TextColor3 =    
	COLORS.SuccessSoft    

bestValueLabel.Font =    
	Enum.Font.GothamBlack    

bestValueLabel.TextSize =    
	16    

bestValueLabel.TextXAlignment =    
	Enum.TextXAlignment.Right    

bestGenerationLabel =    
	createTextLabel(    
		bestCard    
	)    

bestGenerationLabel.Size =    
	UDim2.new(    
		1,    
		-42,    
		0,    
		17    
	)    

bestGenerationLabel.Position =    
	UDim2.new(    
		0,    
		24,    
		0,    
		53    
	)    

bestGenerationLabel.Text =    
	"Esperando datos..."    

bestGenerationLabel.TextColor3 =    
	COLORS.TextMuted    

bestGenerationLabel.Font =    
	Enum.Font.Gotham    

bestGenerationLabel.TextSize =    
	9    

-- ====================================================    
-- FOOTER ACTIONS    
-- ====================================================    

local footer =    
	Instance.new(    
		"Frame"    
	)    

footer.Size =    
	UDim2.new(    
		1,    
		-32,    
		0,    
		42    
	)    

footer.Position =    
	UDim2.new(    
		0,    
		16,    
		1,    
		-50    
	)    

footer.BackgroundTransparency =    
	1    

footer.Parent =    
	mainWindow    

local hideButton =    
	Instance.new(    
		"TextButton"    
	)    

hideButton.Size =    
	UDim2.new(    
		0.27,    
		0,    
		1,    
		0    
	)    

hideButton.BackgroundColor3 =    
	COLORS.Panel3    

hideButton.Text =    
	"Ocultar"    

hideButton.TextColor3 =    
	COLORS.Text    

hideButton.Font =    
	Enum.Font.GothamBold    

hideButton.TextSize =    
	10    

hideButton.Parent =    
	footer    

styleButton(    
	hideButton    
)    

addStroke(    
	hideButton,    
	COLORS.Border,    
	1,    
	0.25    
)    

hideButton.MouseButton1Click:Connect(    
	hideCurrentBestBrainrot    
)    

local showButton =    
	Instance.new(    
		"TextButton"    
	)    

showButton.Size =    
	UDim2.new(    
		0.27,    
		0,    
		1,    
		0    
	)    

showButton.Position =    
	UDim2.new(    
		0.29,    
		0,    
		0,    
		0    
	)    

showButton.BackgroundColor3 =    
	COLORS.Panel3    

showButton.Text =    
	"Mostrar todos"    

showButton.TextColor3 =    
	COLORS.Text    

showButton.Font =    
	Enum.Font.GothamBold    

showButton.TextSize =    
	10    

showButton.Parent =    
	footer    

styleButton(    
	showButton    
)    

addStroke(    
	showButton,    
	COLORS.Border,    
	1,    
	0.25    
)    

showButton.MouseButton1Click:Connect(    
	showAllBrainrots    
)    

local blacklistButton =    
	Instance.new(    
		"TextButton"    
	)    

blacklistButton.Size =    
	UDim2.new(    
		0.40,    
		0,    
		1,    
		0    
	)    

blacklistButton.Position =    
	UDim2.new(    
		0.58,    
		0,    
		0,    
		0    
	)    

blacklistButton.BackgroundColor3 =    
	COLORS.DangerDark    

blacklistButton.Text =    
	"Blacklist"    

blacklistButton.TextColor3 =    
	COLORS.Text    

blacklistButton.Font =    
	Enum.Font.GothamBold    

blacklistButton.TextSize =    
	10    

blacklistButton.Parent =    
	footer    

styleButton(    
	blacklistButton    
)    

addStroke(    
	blacklistButton,    
	COLORS.Danger,    
	1,    
	0.25    
)    

blacklistButton.MouseButton1Click:Connect(    
	function()    

		if not blacklistWindow then    

			-- se crea abajo    
			-- mediante la función definida después    

		end    

		-- función forward-safe    
		if _G.TokitoOpenBrainrotBlacklist then    
			_G.TokitoOpenBrainrotBlacklist()    
		end    

	end    
)    

hiddenCountLabel =    
	createTextLabel(    
		mainWindow    
	)    

hiddenCountLabel.Size =    
	UDim2.new(    
		0,    
		100,    
		0,    
		14    
	)    

hiddenCountLabel.Position =    
	UDim2.new(    
		1,    
		-116,    
		0,    
		126    
	)    

hiddenCountLabel.Text =    
	"0 ocultados"    

hiddenCountLabel.TextColor3 =    
	COLORS.TextMuted    

hiddenCountLabel.Font =    
	Enum.Font.Gotham    

hiddenCountLabel.TextSize =    
	9    

hiddenCountLabel.TextXAlignment =    
	Enum.TextXAlignment.Right

end

-- ========================================================
-- OPEN/CLOSE MAIN
-- ========================================================

local function openMainGUI()

if not brainrotGui    
	or not mainWindow then    

	return    

end    

if menuOpen then    
	return    
end    

menuOpen = true    

mainWindow.Visible =    
	true    

mainScale.Scale =    
	0.90    

safeTween(    
	mainScale,    
	TWEEN_SMOOTH,    
	{Scale = 1}    
)    

updateBrainrotMenu()

end

local function closeMainGUI()

if not mainWindow then    
	return    
end    

menuOpen = false    

safeTween(    
	mainScale,    
	TWEEN_NORMAL,    
	{Scale = 0.92}    
)    

task.delay(    
	0.22,    
	function()    

		if not menuOpen    
			and mainWindow then    

			mainWindow.Visible =    
				false    

		end    

	end    
)

end

-- ========================================================
-- BLACKLIST WINDOW
-- ========================================================

local function updateBlacklistMenu()

if not blacklistList    
	or not blacklistList.Parent then    

	return    

end    

for _, child in ipairs(    
	blacklistList:GetChildren()    
) do    

	if child:IsA("Frame") then    
		child:Destroy()    
	end    

end    

loadBlacklistBrainrotNames()    

local results =    
	getFilteredBlacklistNames(    
		blacklistSearch    
		and blacklistSearch.Text    
		or ""    
	)    

if #results == 0 then    

	if blacklistEmptyLabel then    
		blacklistEmptyLabel.Visible =    
			true    
	end    

else    

	if blacklistEmptyLabel then    
		blacklistEmptyLabel.Visible =    
			false    
	end    

end    

for index, result in ipairs(    
	results    
) do    

	local name =    
		result.name    

	local normalized =    
		normalizeBrainrotName(    
			name    
		)    

	local selected =    
		blacklistBrainrots[    
			normalized    
		] == true    

	local row =    
		Instance.new(    
			"Frame"    
		)    

	row.Name =    
		"Entry_" ..    
		tostring(index)    

	row.Size =    
		UDim2.new(    
			1,    
			-10,    
			0,    
			44    
		)    

	row.BackgroundColor3 =    
		selected    
		and Color3.fromRGB(    
			50,    
			24,    
			30    
		)    
		or COLORS.Panel2    

	row.BorderSizePixel =    
		0    

	row.Parent =    
		blacklistList    

	addCorner(    
		row,    
		9    
	)    

	local rowStroke =    
		addStroke(    
			row,    
			selected    
			and COLORS.Danger    
			or COLORS.Border,    
			1,    
			selected    
			and 0.25    
			or 0.65    
		)    

	local nameButton =    
		Instance.new(    
			"TextButton"    
		)    

	nameButton.Size =    
		UDim2.new(    
			1,    
			-52,    
			1,    
			0    
		)    

	nameButton.BackgroundTransparency =    
		1    

	nameButton.Text =    
		tostring(name)    

	nameButton.TextColor3 =    
		COLORS.Text    

	nameButton.TextXAlignment =    
		Enum.TextXAlignment.Left    

	nameButton.Font =    
		Enum.Font.GothamMedium    

	nameButton.TextSize =    
		11    

	nameButton.TextTruncate =    
		Enum.TextTruncate.AtEnd    

	nameButton.Parent =    
		row    

	local textPadding =    
		Instance.new(    
			"UIPadding"    
		)    

	textPadding.PaddingLeft =    
		UDim.new(    
			0,    
			12    
		)    

	textPadding.Parent =    
		nameButton    

	local check =    
		Instance.new(    
			"TextButton"    
		)    

	check.Size =    
		UDim2.new(    
			0,    
			32,    
			0,    
			32    
		)    

	check.Position =    
		UDim2.new(    
			1,    
			-40,    
			0.5,    
			-16    
		)    

	check.BackgroundColor3 =    
		selected    
		and Color3.fromRGB(    
			96,    
			27,    
			36    
		)    
		or COLORS.Panel3    

	check.Text =    
		selected    
		and "✓"    
		or ""    

	check.TextColor3 =    
		selected    
		and Color3.fromRGB(    
			255,    
			110,    
			120    
		)    
		or COLORS.TextMuted    

	check.Font =    
		Enum.Font.GothamBlack    

	check.TextSize =    
		15    

	check.AutoButtonColor =    
		false    

	check.Parent =    
		row    

	addCorner(    
		check,    
		8    
	)    

	local function toggleBlacklist()    

		if blacklistBrainrots[    
			normalized    
		] == true then    

			blacklistBrainrots[    
				normalized    
			] = nil    

		else    

			blacklistBrainrots[    
				normalized    
			] = true    

		end    

		saveBrainrotBlacklist()    
		updateBlacklistMenu()    
		refreshESPAfterBlacklistChange()    

	end    

	nameButton.MouseButton1Click:Connect(    
		toggleBlacklist    
	)    

	check.MouseButton1Click:Connect(    
		toggleBlacklist    
	)    

	nameButton.MouseEnter:Connect(    
		function()    

			safeTween(    
				row,    
				TWEEN_FAST,    
				{    
					BackgroundColor3 =    
						selected    
						and Color3.fromRGB(    
							60,    
							28,    
							36    
						)    
						or COLORS.Panel3    
				}    
			)    

		end    
	)    

	nameButton.MouseLeave:Connect(    
		function()    

			safeTween(    
				row,    
				TWEEN_FAST,    
				{    
					BackgroundColor3 =    
						selected    
						and Color3.fromRGB(    
							50,    
							24,    
							30    
						)    
						or COLORS.Panel2    
				}    
			)    

		end    
	)    

	rowStroke.Transparency =    
		selected    
		and 0.25    
		or 0.65    

end    

if blacklistCountLabel then    

	blacklistCountLabel.Text =    
		tostring(    
			getBlacklistCount()    
		)    
		..    
		" excluidos  •  "    
		..    
		tostring(    
			#blacklistBrainrotNames    
		)    
		..    
		" disponibles"    

end

end

local function createBlacklistGUI()

if blacklistWindow    
	and blacklistWindow.Parent then    

	blacklistOpen = true    
	blacklistWindow.Visible =    
		true    

	blacklistScale.Scale =    
		0.94    

	safeTween(    
		blacklistScale,    
		TWEEN_SMOOTH,    
		{Scale = 1}    
	)    

	updateBlacklistMenu()    

	return    

end    

loadBlacklistBrainrotNames()    

blacklistWindow =    
	Instance.new(    
		"Frame"    
	)    

blacklistWindow.Name =    
	"BlacklistWindow"    

blacklistWindow.AnchorPoint =    
	Vector2.new(    
		0.5,    
		0.5    
	)    

blacklistWindow.Position =    
	UDim2.new(    
		0.5,    
		0,    
		0.5,    
		0    
	)    

blacklistWindow.Size =    
	UDim2.new(    
		0,    
		400,    
		0,    
		430    
	)    

blacklistWindow.BackgroundColor3 =    
	COLORS.Background    

blacklistWindow.BorderSizePixel =    
	0    

blacklistWindow.Parent =    
	brainrotGui    

addCorner(    
	blacklistWindow,    
	16    
)    

addStroke(    
	blacklistWindow,    
	COLORS.Danger,    
	1.2,    
	0.38    
)    

blacklistScale =    
	Instance.new(    
		"UIScale"    
	)    

blacklistScale.Scale =    
	0.94    

blacklistScale.Parent =    
	blacklistWindow    

-- HEADER    

local header =    
	Instance.new(    
		"Frame"    
	)    

header.Size =    
	UDim2.new(    
		1,    
		0,    
		0,    
		64    
	)    

header.BackgroundColor3 =    
	Color3.fromRGB(    
		32,    
		19,    
		26    
	)    

header.BorderSizePixel =    
	0    

header.Parent =    
	blacklistWindow    

addCorner(    
	header,    
	16    
)    

local accent =    
	Instance.new(    
		"Frame"    
	)    

accent.Size =    
	UDim2.new(    
		0,    
		4,    
		0,    
		34    
	)    

accent.Position =    
	UDim2.new(    
		0,    
		16,    
		0.5,    
		-17    
	)    

accent.BackgroundColor3 =    
	COLORS.Danger    

accent.BorderSizePixel =    
	0    

accent.Parent =    
	header    

addCorner(    
	accent,    
	3    
)    

local title =    
	createTextLabel(    
		header    
	)    

title.Size =    
	UDim2.new(    
		1,    
		-90,    
		0,    
		25    
	)    

title.Position =    
	UDim2.new(    
		0,    
		30,    
		0,    
		10    
	)    

title.Text =    
	"Blacklist"    

title.Font =    
	Enum.Font.GothamBold    

title.TextSize =    
	17    

local subtitle =    
	createTextLabel(    
		header    
	)    

subtitle.Size =    
	UDim2.new(    
		1,    
		-90,    
		0,    
		20    
	)    

subtitle.Position =    
	UDim2.new(    
		0,    
		30,    
		0,    
		34    
	)    

subtitle.Text =    
	"Excluye brainrots del ESP Best"    

subtitle.TextColor3 =    
	COLORS.TextMuted    

subtitle.Font =    
	Enum.Font.Gotham    

subtitle.TextSize =    
	10    

local close =    
	Instance.new(    
		"TextButton"    
	)    

close.Size =    
	UDim2.new(    
		0,    
		30,    
		0,    
		30    
	)    

close.Position =    
	UDim2.new(    
		1,    
		-43,    
		0,    
		17    
	)    

close.BackgroundColor3 =    
	Color3.fromRGB(    
		55,    
		27,    
		35    
	)    

close.Text =    
	"×"    

close.TextColor3 =    
	COLORS.Text    

close.Font =    
	Enum.Font.GothamBold    

close.TextSize =    
	18    

close.Parent =    
	header    

styleButton(    
	close    
)    

close.MouseButton1Click:Connect(    
	function()    

		blacklistOpen = false    

		safeTween(    
			blacklistScale,    
			TWEEN_NORMAL,    
			{Scale = 0.94}    
		)    

		task.delay(    
			0.20,    
			function()    

				if not blacklistOpen    
					and blacklistWindow then    

					blacklistWindow.Visible =    
						false    

				end    

			end    
		)    

	end    
)    

makeDraggable(    
	header,    
	blacklistWindow    
)    

-- SEARCH HOLDER    

local searchHolder =    
	Instance.new(    
		"Frame"    
	)    

searchHolder.Size =    
	UDim2.new(    
		1,    
		-32,    
		0,    
		42    
	)    

searchHolder.Position =    
	UDim2.new(    
		0,    
		16,    
		0,    
		78    
	)    

searchHolder.BackgroundColor3 =    
	COLORS.Panel2    

searchHolder.BorderSizePixel =    
	0    

searchHolder.Parent =    
	blacklistWindow    

addCorner(    
	searchHolder,    
	10    
)    

addStroke(    
	searchHolder,    
	COLORS.Border,    
	1,    
	0.3    
)    

local searchIcon =    
	createTextLabel(    
		searchHolder    
	)    

searchIcon.Size =    
	UDim2.new(    
		0,    
		35,    
		1,    
		0    
	)    

searchIcon.Position =    
	UDim2.new(    
		0,    
		7,    
		0,    
		0    
	)    

searchIcon.Text =    
	"⌕"    

searchIcon.TextColor3 =    
	COLORS.Danger    

searchIcon.Font =    
	Enum.Font.GothamBlack    

searchIcon.TextSize =    
	20    

searchIcon.TextXAlignment =    
	Enum.TextXAlignment.Center    

blacklistSearch =    
	Instance.new(    
		"TextBox"    
	)    

blacklistSearch.Size =    
	UDim2.new(    
		1,    
		-50,    
		1,    
		0    
	)    

blacklistSearch.Position =    
	UDim2.new(    
		0,    
		43,    
		0,    
		0    
	)    

blacklistSearch.BackgroundTransparency =    
	1    

blacklistSearch.ClearTextOnFocus =    
	false    

blacklistSearch.TextColor3 =    
	COLORS.Text    

blacklistSearch.PlaceholderColor3 =    
	COLORS.TextMuted    

blacklistSearch.PlaceholderText =    
	"Buscar brainrot..."    

blacklistSearch.Text =    
	""    

blacklistSearch.TextSize =    
	11    

blacklistSearch.Font =    
	Enum.Font.GothamMedium    

blacklistSearch.TextXAlignment =    
	Enum.TextXAlignment.Left    

blacklistSearch.Parent =    
	searchHolder    

blacklistSearch:GetPropertyChangedSignal(    
	"Text"    
):Connect(    
	updateBlacklistMenu    
)    

-- COUNT    

blacklistCountLabel =    
	createTextLabel(    
		blacklistWindow    
	)    

blacklistCountLabel.Size =    
	UDim2.new(    
		1,    
		-32,    
		0,    
		20    
	)    

blacklistCountLabel.Position =    
	UDim2.new(    
		0,    
		16,    
		0,    
		128    
	)    

blacklistCountLabel.Text =    
	"Cargando..."    

blacklistCountLabel.TextColor3 =    
	COLORS.TextMuted    

blacklistCountLabel.Font =    
	Enum.Font.GothamMedium    

blacklistCountLabel.TextSize =    
	9    

-- LIST    

blacklistList =    
	Instance.new(    
		"ScrollingFrame"    
	)    

blacklistList.Name =    
	"Entries"    

blacklistList.Size =    
	UDim2.new(    
		1,    
		-32,    
		0,    
		246    
	)    

blacklistList.Position =    
	UDim2.new(    
		0,    
		16,    
		0,    
		153    
	)    

blacklistList.BackgroundColor3 =    
	Color3.fromRGB(    
		9,    
		14,    
		22    
	)    

blacklistList.BorderSizePixel =    
	0    

blacklistList.ScrollBarThickness =    
	4    

blacklistList.ScrollBarImageColor3 =    
	COLORS.Danger    

blacklistList.AutomaticCanvasSize =    
	Enum.AutomaticSize.Y    

blacklistList.CanvasSize =    
	UDim2.new(    
		0,    
		0,    
		0,    
		0    
	)    

blacklistList.ScrollingDirection =    
	Enum.ScrollingDirection.Y    

blacklistList.Parent =    
	blacklistWindow    

addCorner(    
	blacklistList,    
	11    
)    

local listPadding =    
	Instance.new(    
		"UIPadding"    
	)    

listPadding.PaddingTop =    
	UDim.new(    
		0,    
		6    
	)    

listPadding.PaddingBottom =    
	UDim.new(    
		0,    
		6    
	)    

listPadding.PaddingLeft =    
	UDim.new(    
		0,    
		5    
	)    

listPadding.PaddingRight =    
	UDim.new(    
		0,    
		5    
	)    

listPadding.Parent =    
	blacklistList    

local layout =    
	Instance.new(    
		"UIListLayout"    
	)    

layout.SortOrder =    
	Enum.SortOrder.LayoutOrder    

layout.Padding =    
	UDim.new(    
		0,    
		5    
	)    

layout.Parent =    
	blacklistList    

blacklistEmptyLabel =    
	createTextLabel(    
		blacklistList    
	)    

blacklistEmptyLabel.Size =    
	UDim2.new(    
		1,    
		-20,    
		0,    
		80    
	)    

blacklistEmptyLabel.Text =    
	"No se encontraron brainrots"    

blacklistEmptyLabel.TextColor3 =    
	COLORS.TextMuted    

blacklistEmptyLabel.Font =    
	Enum.Font.GothamMedium    

blacklistEmptyLabel.TextSize =    
	11    

blacklistEmptyLabel.TextXAlignment =    
	Enum.TextXAlignment.Center    

blacklistEmptyLabel.TextYAlignment =    
	Enum.TextYAlignment.Center    

blacklistEmptyLabel.Visible =    
	false    

-- FOOTER    

local footer =    
	createTextLabel(    
		blacklistWindow    
	)    

footer.Size =    
	UDim2.new(    
		1,    
		-32,    
		0,    
		20    
	)    

footer.Position =    
	UDim2.new(    
		0,    
		16,    
		1,    
		-28    
	)    

footer.Text =    
	"Pulsa un elemento para excluirlo del ESP"    

footer.TextColor3 =    
	COLORS.TextMuted    

footer.Font =    
	Enum.Font.Gotham    

footer.TextSize =    
	9    

footer.TextXAlignment =    
	Enum.TextXAlignment.Center    

updateBlacklistMenu()

end

-- ========================================================
-- REFRESH ESP AFTER BLACKLIST
-- ========================================================

refreshESPAfterBlacklistChange =
function()

if not animalESPEnabled then    

		updateBrainrotMenu()    

		return    

	end    

	local debris =    
		Workspace:FindFirstChild(    
			"Debris"    
		)    

	if debris then    

		pcall(function()    

			rebuildBestAnimal(    
				debris    
			)    

		end)    

	else    

		clearAllESP()    

		bestAnimalPart = nil    
		bestAnimalValue = 0    
		bestAnimalName = "Unknown"    
		bestAnimalGenerationText = ""    

		updateBrainrotMenu()    

	end    

end

-- ========================================================
-- GLOBAL BLACKLIST OPENER
-- ========================================================

_G.TokitoOpenBrainrotBlacklist =
function()

if not blacklistWindow    
		or not blacklistWindow.Parent then    

		createBlacklistGUI()    

	else    

		blacklistOpen = true    
		blacklistWindow.Visible =    
			true    

		blacklistScale.Scale =    
			0.94    

		safeTween(    
			blacklistScale,    
			TWEEN_SMOOTH,    
			{Scale = 1}    
		)    

		updateBlacklistMenu()    

	end    

end

-- ========================================================
-- CREATE LAUNCHER
-- ========================================================

local function createLauncher()

if launcherButton    
	and launcherButton.Parent then    

	return    

end    

launcherButton =    
	Instance.new(    
		"TextButton"    
	)    

launcherButton.Name =    
	"BrainrotLauncher"    

launcherButton.AnchorPoint =    
	Vector2.new(    
		0,    
		0    
	)    

launcherButton.Position =    
	UDim2.new(    
		0,    
		18,    
		0,    
		240    
	)    

launcherButton.Size =    
	UDim2.new(    
		0,    
		54,    
		0,    
		54    
	)    

launcherButton.BackgroundColor3 =    
	COLORS.Panel    

launcherButton.BorderSizePixel =    
	0    

launcherButton.Text =    
	""    

launcherButton.AutoButtonColor =    
	false    

launcherButton.Parent =    
	brainrotGui    

addCorner(    
	launcherButton,    
	16    
)    

local stroke =    
	addStroke(    
		launcherButton,    
		COLORS.Primary,    
		1.5,    
		0.15    
	)    

local gradient =    
	addGradient(    
		launcherButton,    
		Color3.fromRGB(    
			0,    
			98,    
			175    
		),    
		Color3.fromRGB(    
			8,    
			31,    
			56    
		),    
		135    
	)    

local icon =    
	createTextLabel(    
		launcherButton    
	)    

icon.Size =    
	UDim2.new(    
		1,    
		0,    
		0,    
		24    
	)    

icon.Position =    
	UDim2.new(    
		0,    
		0,    
		0,    
		5    
	)    

icon.Text =    
	"BR"    

icon.Font =    
	Enum.Font.GothamBlack    

icon.TextSize =    
	17    

icon.TextColor3 =    
	COLORS.Text    

icon.TextXAlignment =    
	Enum.TextXAlignment.Center    

local miniText =    
	createTextLabel(    
		launcherButton    
	)    

miniText.Size =    
	UDim2.new(    
		1,    
		0,    
		0,    
		15    
	)    

miniText.Position =    
	UDim2.new(    
		0,    
		0,    
		0,    
		31    
	)    

miniText.Text =    
	"ESP"    

miniText.Font =    
	Enum.Font.GothamBold    

miniText.TextSize =    
	8    

miniText.TextColor3 =    
	COLORS.PrimarySoft    

miniText.TextXAlignment =    
	Enum.TextXAlignment.Center    

local launcherScale =    
	Instance.new(    
		"UIScale"    
	)    

launcherScale.Scale =    
	1    

launcherScale.Parent =    
	launcherButton    

launcherButton.MouseEnter:Connect(    
	function()    

		safeTween(    
			launcherScale,    
			TWEEN_FAST,    
			{Scale = 1.06}    
		)    

		safeTween(    
			stroke,    
			TWEEN_FAST,    
			{    
				Transparency = 0    
			}    
		)    

	end    
)    

launcherButton.MouseLeave:Connect(    
	function()    

		safeTween(    
			launcherScale,    
			TWEEN_FAST,    
			{Scale = 1}    
		)    

		safeTween(    
			stroke,    
			TWEEN_FAST,    
			{    
				Transparency = 0.15    
			}    
		)    

	end    
)    

launcherButton.MouseButton1Click:Connect(    
	function()    

		if menuOpen then    
			closeMainGUI()    
		else    
			openMainGUI()    
		end    

	end    
)    

-- Animación muy ligera del gradiente    
task.spawn(    
	function()    

		while launcherButton    
			and launcherButton.Parent do    

			gradient.Rotation =    
				(    
					gradient.Rotation    
					+ 0.25    
				)    
				% 360    

			task.wait(0.03)    

		end    

	end    
)    

makeDraggable(    
	launcherButton,    
	launcherButton    
)

end

-- ========================================================
-- START ESP
-- ========================================================

startAnimalESP =
function()

if animalESPEnabled then    
		return    
	end    

	Connections =    
		Connections    
		or {}    

	animalESPEnabled =    
		true    

	createMainGUI()    

	createLauncher()    

	local debris =    
		Workspace:FindFirstChild(    
			"Debris"    
		)    

	if not debris then    

		updateBrainrotMenu()    

		return    

	end    

	pcall(function()    

		rebuildBestAnimal(    
			debris    
		)    

	end)    

	if Connections.animalESPAdded then    

		pcall(function()    

			Connections    
				.animalESPAdded    
				:Disconnect()    

		end)    

		Connections.animalESPAdded =    
			nil    

	end    

	if Connections.animalESPRemoved then    

		pcall(function()    

			Connections    
				.animalESPRemoved    
				:Disconnect()    

		end)    

		Connections.animalESPRemoved =    
			nil    

	end    

	Connections.animalESPAdded =    
		debris.ChildAdded:Connect(    
			function(part)    

				if not animalESPEnabled then    
					return    
				end    

				if part.Name ~=    
					"FastOverheadTemplate"    
					or not part:IsA(    
						"BasePart"    
					) then    

					return    

				end    

				task.delay(    
					0.12,    
					function()    

						if not animalESPEnabled    
							or not part.Parent then    

							return    

						end    

						pcall(function()    

							rebuildBestAnimal(    
								debris    
							)    

						end)    

					end    
				)    

			end    
		)    

	Connections.animalESPRemoved =    
		debris.ChildRemoved:Connect(    
			function(part)    

				if animalESPCache[    
					part    
				] then    

					pcall(function()    

						animalESPCache[    
							part    
						]:Destroy()    

					end)    

					animalESPCache[    
						part    
					] = nil    

				end    

				if part ==    
					bestAnimalPart then    

					task.defer(    
						function()    

							if animalESPEnabled then    

								pcall(function()    

									rebuildBestAnimal(    
										debris    
									)    

								end)    

							end    

						end    
					)    

				end    

				updateBrainrotMenu()    

			end    
		)    

	updateBrainrotMenu()    

end

-- ========================================================
-- STOP ESP
-- ========================================================

stopAnimalESP =
function()

animalESPEnabled =    
		false    

	clearAllESP()    

	table.clear(    
		animalESPCache    
	)    

	bestAnimalPart = nil    
	bestAnimalValue = 0    
	bestAnimalName = "Unknown"    
	bestAnimalGenerationText = ""    

	if Connections.animalESPAdded then    

		pcall(function()    

			Connections    
				.animalESPAdded    
				:Disconnect()    

		end)    

		Connections.animalESPAdded =    
			nil    

	end    

	if Connections.animalESPRemoved then    

		pcall(function()    

			Connections    
				.animalESPRemoved    
				:Disconnect()    

		end)    

		Connections.animalESPRemoved =    
			nil    

	end    

	menuOpen = false    

	if mainWindow then    
		mainWindow.Visible =    
			false    
	end    

	blacklistOpen = false    

	if blacklistWindow then    
		blacklistWindow.Visible =    
			false    
	end    

	if launcherButton then    

		launcherButton.Visible =    
			false    

	end    

end

-- ========================================================
-- CREATE ALL UI FIRST
-- ========================================================

createMainGUI()
createBlacklistGUI()
createLauncher()

-- Inicialmente ocultas
if mainWindow then
mainWindow.Visible = false
end

if blacklistWindow then
blacklistWindow.Visible = false
end

if launcherButton then
launcherButton.Visible =
animalESPEnabled
end

-- ========================================================
-- TOGGLE
-- ========================================================

if type(createToggle)
== "function" then

createToggle(    
	"Esp Best",    
	function(state)    

		pcall(function()    

			if state then    

				if launcherButton then    
					launcherButton.Visible =    
						true    
				end    

				startAnimalESP()    

			else    

				stopAnimalESP()    

			end    

		end)    

	end    
)

end

end

-- ========================================================
-- DEFENDER
-- 1 CLIC = 1 USO DE LOS 4 ITEMS
-- MINI GUI + ARRASTRABLE + POSICIÓN PERSISTENTE
-- INTEGRADO AL createToggle DEL HUB
-- ========================================================

do
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local defenderGui = nil
local defenderConnections = {}

local defenderBusy = false

local ITEM_DELAY = 0.03

local DEFAULT_POSITION = UDim2.new(
0.5,
-55,
0.5,
-18
)

-- ====================================================
-- CARGAR POSICIÓN
-- ====================================================

local savedPosition = DEFAULT_POSITION

pcall(function()
local pos = Config["DefenderPos"]

if type(pos) == "table" and #pos >= 4 then    
    savedPosition = UDim2.new(    
        pos[1],    
        pos[2],    
        pos[3],    
        pos[4]    
    )    
end

end)

-- ====================================================
-- GUARDAR POSICIÓN
-- ====================================================

local function saveDefenderPosition(position)
Config["DefenderPos"] = {
position.X.Scale,
position.X.Offset,
position.Y.Scale,
position.Y.Offset
}

if saveConfig then    
    saveConfig()    
end

end

-- ====================================================
-- BUSCAR TOOL
-- ====================================================

local function getDefenderItem(itemName)
local character = LocalPlayer.Character
local backpack = LocalPlayer:FindFirstChild("Backpack")

if not character or not backpack then    
    return nil    
end    

for _, obj in ipairs(character:GetChildren()) do    
    if obj:IsA("Tool") and obj.Name == itemName then    
        return obj    
    end    
end    

for _, obj in ipairs(backpack:GetChildren()) do    
    if obj:IsA("Tool") and obj.Name == itemName then    
        return obj    
    end    
end    

return nil

end

-- ====================================================
-- USAR TOOL
-- ====================================================

local function useDefenderItem(itemName)
local tool = getDefenderItem(itemName)

if not tool then    
    return    
end    

pcall(function()    
    local character = LocalPlayer.Character    

    if not character then    
        return    
    end    

    local humanoid =    
        character:FindFirstChildOfClass("Humanoid")    

    if not humanoid then    
        return    
    end    

    if tool.Parent ~= character then    
        humanoid:EquipTool(tool)    
        task.wait()    
    end    

    if tool.Parent == character then    
        tool:Activate()    
    end    
end)

end

-- ====================================================
-- SECUENCIA
-- ====================================================

local function useDefenderOnce()

if defenderBusy then    
    return    
end    

defenderBusy = true    

task.spawn(function()    

    useDefenderItem(    
        "All Seeing Sentry"    
    )    

    task.wait(ITEM_DELAY)    

    if not defenderBusy then    
        return    
    end    

    useDefenderItem(    
        "BeeHive"    
    )    

    task.wait(ITEM_DELAY)    

    if not defenderBusy then    
        return    
    end    

    useDefenderItem(    
        "Attack Doge"    
    )    

    task.wait(ITEM_DELAY)    

    if not defenderBusy then    
        return    
    end    

    useDefenderItem(    
        "Subspace Mine"    
    )    

    defenderBusy = false    
end)

end

-- ====================================================
-- DESTRUIR GUI
-- ====================================================

local function destroyDefender()

defenderBusy = false    

for _, connection in ipairs(defenderConnections) do    
    if connection then    
        pcall(function()    
            connection:Disconnect()    
        end)    
    end    
end    

table.clear(defenderConnections)    

if defenderGui then    
    pcall(function()    
        defenderGui:Destroy()    
    end)    

    defenderGui = nil    
end

end

-- ====================================================
-- CREAR GUI
-- ====================================================

local function createDefender()

destroyDefender()    

local ScreenGui = Instance.new("ScreenGui")    

ScreenGui.Name = "DefenderCompact"    
ScreenGui.ResetOnSpawn = false    
ScreenGui.IgnoreGuiInset = true    
ScreenGui.ZIndexBehavior =    
    Enum.ZIndexBehavior.Sibling    

local parent    

pcall(function()    
    parent = gethui()    
end)    

if not parent then    
    parent = game:GetService("CoreGui")    
end    

ScreenGui.Parent = parent    
defenderGui = ScreenGui    

-- ==================================================    
-- FRAME    
-- ==================================================    

local Frame = Instance.new("Frame")    

Frame.Name = "Defender"    

Frame.Size = UDim2.new(    
    0,    
    110,    
    0,    
    36    
)    

Frame.Position = savedPosition    

Frame.BackgroundColor3 = Color3.fromRGB(    
    9,    
    15,    
    22    
)    

Frame.BorderSizePixel = 0    
Frame.Active = true    
Frame.Parent = ScreenGui    

local Corner = Instance.new("UICorner")    
Corner.CornerRadius = UDim.new(0, 9)    
Corner.Parent = Frame    

local Stroke = Instance.new("UIStroke")    
Stroke.Thickness = 1    
Stroke.Transparency = 0.15    
Stroke.Color = Color3.fromRGB(    
    0,    
    150,    
    220    
)    
Stroke.Parent = Frame    

-- ==================================================    
-- TITULO    
-- ==================================================    

local Title = Instance.new("TextLabel")    

Title.Size = UDim2.new(    
    0,    
    65,    
    1,    
    0    
)    

Title.Position = UDim2.new(    
    0,    
    9,    
    0,    
    0    
)    

Title.BackgroundTransparency = 1    
Title.Text = "DEFENDER"    

Title.TextColor3 = Color3.fromRGB(    
    220,    
    235,    
    245    
)    

Title.Font = Enum.Font.GothamBold    
Title.TextSize = 9    
Title.TextXAlignment =    
    Enum.TextXAlignment.Left    

Title.Parent = Frame    

-- ==================================================    
-- BOTÓN    
-- ==================================================    

local Toggle = Instance.new("TextButton")    

Toggle.Name = "Use"    

Toggle.Size = UDim2.new(    
    0,    
    32,    
    0,    
    18    
)    

Toggle.Position = UDim2.new(    
    1,    
    -40,    
    0.5,    
    -9    
)    

Toggle.BackgroundColor3 =    
    Color3.fromRGB(    
        35,    
        45,    
        55    
    )    

Toggle.BorderSizePixel = 0    
Toggle.Text = ""    
Toggle.AutoButtonColor = false    
Toggle.ZIndex = 5    
Toggle.Parent = Frame    

local ToggleCorner = Instance.new("UICorner")    
ToggleCorner.CornerRadius =    
    UDim.new(1, 0)    
ToggleCorner.Parent = Toggle    

local Knob = Instance.new("Frame")    

Knob.Size = UDim2.new(    
    0,    
    14,    
    0,    
    14    
)    

Knob.Position = UDim2.new(    
    0,    
    2,    
    0.5,    
    -7    
)    

Knob.BackgroundColor3 =    
    Color3.fromRGB(    
        170,    
        185,    
        195    
    )    

Knob.BorderSizePixel = 0    
Knob.ZIndex = 6    
Knob.Parent = Toggle    

local KnobCorner = Instance.new("UICorner")    
KnobCorner.CornerRadius =    
    UDim.new(1, 0)    
KnobCorner.Parent = Knob    

-- ==================================================    
-- CLICK DEL DEFENDER    
-- ==================================================    

table.insert(    
    defenderConnections,    

    Toggle.MouseButton1Click:Connect(    
        function()    

            if defenderBusy then    
                return    
            end    

            -- Visual ON    
            Toggle.BackgroundColor3 =    
                Color3.fromRGB(    
                    0,    
                    155,    
                    225    
                )    

            Knob.BackgroundColor3 =    
                Color3.fromRGB(    
                    255,    
                    255,    
                    255    
                )    

            Knob.Position =    
                UDim2.new(    
                    1,    
                    -16,    
                    0.5,    
                    -7    
                )    

            Title.TextColor3 =    
                Color3.fromRGB(    
                    0,    
                    210,    
                    255    
                )    

            useDefenderOnce()    

            task.spawn(function()    

                while defenderBusy do    
                    task.wait()    
                end    

                if not defenderGui    
                    or not defenderGui.Parent then    
                    return    
                end    

                -- Visual OFF    
                Toggle.BackgroundColor3 =    
                    Color3.fromRGB(    
                        35,    
                        45,    
                        55    
                    )    

                Knob.BackgroundColor3 =    
                    Color3.fromRGB(    
                        170,    
                        185,    
                        195    
                    )    

                Knob.Position =    
                    UDim2.new(    
                        0,    
                        2,    
                        0.5,    
                        -7    
                    )    

                Title.TextColor3 =    
                    Color3.fromRGB(    
                        220,    
                        235,    
                        245    
                    )    
            end)    
        end    
    )    
)    

-- ==================================================    
-- ARRASTRE    
-- ==================================================    

local dragging = false    
local dragStart = nil    
local startPosition = nil    
local activeTouch = nil    

table.insert(    
    defenderConnections,    

    Frame.InputBegan:Connect(    
        function(input)    

            if input.UserInputType    
                ~= Enum.UserInputType.MouseButton1    
                and input.UserInputType    
                ~= Enum.UserInputType.Touch then    

                return    
            end    

            -- No iniciar drag si tocó el botón    
            if input.UserInputType    
                == Enum.UserInputType.MouseButton1 then    

                local mouse =    
                    UserInputService:GetMouseLocation()    

                local pos =    
                    Toggle.AbsolutePosition    

                local size =    
                    Toggle.AbsoluteSize    

                if mouse.X >= pos.X    
                    and mouse.X <= pos.X + size.X    
                    and mouse.Y >= pos.Y    
                    and mouse.Y <= pos.Y + size.Y then    

                    return    
                end    
            end    

            dragging = true    
            dragStart = input.Position    
            startPosition = Frame.Position    
            activeTouch = input    
        end    
    )    
)    

table.insert(    
    defenderConnections,    

    UserInputService.InputChanged:Connect(    
        function(input)    

            if not dragging then    
                return    
            end    

            if input.UserInputType    
                == Enum.UserInputType.MouseMovement then    

                local delta =    
                    input.Position -    
                    dragStart    

                Frame.Position =    
                    UDim2.new(    
                        startPosition.X.Scale,    
                        startPosition.X.Offset    
                            + delta.X,    

                        startPosition.Y.Scale,    
                        startPosition.Y.Offset    
                            + delta.Y    
                    )    
            end    
        end    
    )    
)    

table.insert(    
    defenderConnections,    

    UserInputService.TouchMoved:Connect(    
        function(touch)    

            if not dragging then    
                return    
            end    

            if touch ~= activeTouch then    
                return    
            end    

            local delta =    
                touch.Position -    
                dragStart    

            Frame.Position =    
                UDim2.new(    
                    startPosition.X.Scale,    
                    startPosition.X.Offset    
                        + delta.X,    

                    startPosition.Y.Scale,    
                    startPosition.Y.Offset    
                        + delta.Y    
                )    
        end    
    )    
)    

table.insert(    
    defenderConnections,    

    UserInputService.InputEnded:Connect(    
        function(input)    

            if input.UserInputType    
                ~= Enum.UserInputType.MouseButton1    
                and input.UserInputType    
                ~= Enum.UserInputType.Touch then    

                return    
            end    

            if input.UserInputType    
                == Enum.UserInputType.Touch    
                and activeTouch    
                and input ~= activeTouch then    

                return    
            end    

            if dragging then    

                dragging = false    
                activeTouch = nil    

                saveDefenderPosition(    
                    Frame.Position    
                )    
            end    
        end    
    )    
)    

-- ==================================================    
-- RGB    
-- ==================================================    

table.insert(    
    defenderConnections,    

    RunService.RenderStepped:Connect(    
        function()    

            if not defenderGui    
                or not defenderGui.Parent then    

                return    
            end    

            Stroke.Color =    
                Color3.fromHSV(    
                    0.55    
                        + math.sin(    
                            tick() * 2    
                        ) * 0.04,    

                    1,    
                    1    
                )    
        end    
    )    
)

end

-- ====================================================
-- HUB TOGGLE
-- ====================================================

createToggle(
"Defender",
function(state)

if state then    
        createDefender()    
    else    
        destroyDefender()    
    end    

end

)

end
-- INFINITE JUMP
local infiniteJumpEnabled = false

UIS.JumpRequest:Connect(function()
	if not infiniteJumpEnabled then
		return
	end

	local char = player.Character or player.CharacterAdded:Wait()
	if not char then
		return
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local vel = hrp.AssemblyLinearVelocity

	hrp.AssemblyLinearVelocity = Vector3.new(
		vel.X,
		55,
		vel.Z
	)
end)

RunService.Heartbeat:Connect(function()
	if not infiniteJumpEnabled then
		return
	end

	local char = player.Character or player.CharacterAdded:Wait()
	if not char then
		return
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local vel = hrp.AssemblyLinearVelocity

	if vel.Y < -35 then
		hrp.AssemblyLinearVelocity = Vector3.new(
			vel.X,
			-35,
			vel.Z
		)
	end
end)

createToggle("Infinite Jump", function(state)
	infiniteJumpEnabled = state
end)
-- ================= USE POTION =================

local potionGui = nil
local potionDragConnection = nil
local potionInputEndedConnection = nil
local potionInputBeganConnection = nil

local function getPotion()
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    local char = player.Character

    if char then
        local tool = char:FindFirstChild("Giant Potion")
        if tool then
            return tool
        end
    end

    if backpack then
        return backpack:FindFirstChild("Giant Potion")
    end
end

local function usePotion()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local potion = getPotion()
    if not potion then return end

    hum:EquipTool(potion)
    task.wait(0.1)

    pcall(function()
        potion:Activate()
    end)
end

local function createPotionButton()
    if potionGui then
        return
    end

    local player = game.Players.LocalPlayer
    local UIS = game:GetService("UserInputService")
    
    -- Posición segura por defecto (Abajo al centro, separada del botón Drop)
    local defaultPos = UDim2.new(0.5, -56, 0.7, 0)
    local btnPos = defaultPos
    
    if Config["PotionPos"] then
        local p = Config["PotionPos"]
        if type(p) == "table" and #p >= 4 then
            btnPos = UDim2.new(p[1], p[2], p[3], p[4])
        end
    end

    potionGui = Instance.new("ScreenGui")
    potionGui.Name = "PotionGUI"
    potionGui.ResetOnSpawn = false
    potionGui.IgnoreGuiInset = true
    potionGui.Parent = player:WaitForChild("PlayerGui")

    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(0, 112, 0, 46)
    shadow.Position = btnPos
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.45
    shadow.BorderSizePixel = 0
    shadow.Parent = potionGui
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)

    local button = Instance.new("TextButton")
    button.Name = "PotionButton"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(18, 72, 160)
    button.Text = "POTION"
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    button.TextColor3 = Color3.fromRGB(245, 250, 255)
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Parent = shadow
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(90, 175, 255)
    stroke.Transparency = 0.05
    stroke.Parent = button

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 110, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 55, 140))
    })
    gradient.Rotation = 90
    gradient.Parent = button

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = button

    local dragging = false
    local moved = false
    local dragStart = nil
    local startPos = nil
    local dragInput = nil
    local downInput = nil
    local dragThreshold = 8

    local function update(input)
        local delta = input.Position - dragStart
        if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
            moved = true
        end

        shadow.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = shadow.Position
            downInput = input
        end
    end)

    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    potionDragConnection = UIS.InputChanged:Connect(function(input)
        if dragging and dragInput and input == dragInput then
            update(input)
        end
    end)

    potionInputEndedConnection = UIS.InputEnded:Connect(function(input)
        if downInput and input == downInput then
            dragging = false
            dragInput = nil
            downInput = nil

            if not moved then
                task.spawn(usePotion)
            else
                -- Guarda la posición exacta donde lo soltó el jugador
                Config["PotionPos"] = {shadow.Position.X.Scale, shadow.Position.X.Offset, shadow.Position.Y.Scale, shadow.Position.Y.Offset}
                saveConfig()
            end
        end
    end)

    button.MouseEnter:Connect(function()
        stroke.Transparency = 0
    end)

    button.MouseLeave:Connect(function()
        stroke.Transparency = 0.05
    end)
end

local function removePotionButton()
    if potionDragConnection then
        potionDragConnection:Disconnect()
        potionDragConnection = nil
    end

    if potionInputEndedConnection then
        potionInputEndedConnection:Disconnect()
        potionInputEndedConnection = nil
    end

    if potionInputBeganConnection then
        potionInputBeganConnection:Disconnect()
        potionInputBeganConnection = nil
    end

    if potionGui then
        potionGui:Destroy()
        potionGui = nil
    end
end

createToggle("Use Potion", function(state)
    if state then
        createPotionButton()
    else
        -- Resetea la posición al apagar el toggle
        Config["PotionPos"] = nil
        saveConfig()
        removePotionButton()
    end
end)

-- ================= END USE POTION =================


-- ================= FPS BOOST ULTRA =================
do
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local WorkspaceService = game:GetService("Workspace")
local MaterialService = game:GetService("MaterialService")

-- Protecciones para evitar errores si tu hub no tiene estas funciones globales
local _Config = type(Config) == "table" and Config or {}
local _saveConfig = type(saveConfig) == "function" and saveConfig or function() end
local _setToggle = type(setToggle) == "function" and setToggle or function() end

local OriginalTransparency = setmetatable({}, { __mode = "k" })
local _ultraThreads = {}
local _ultraConnections = {}

local function AddUltraThread(f)
	table.insert(_ultraThreads, task.spawn(f))
end

local function AddUltraConnection(c)
	table.insert(_ultraConnections, c)
end

local function SafeDestroyUltra(obj)
	if not obj then
		return
	end

	-- No tocar nada del overhead ni del sistema que usa el ESP
	if obj.Name == "Overhead"
		or obj.Name == "AnimalOverhead"
		or obj.Name == "Generation"
		or obj.Name == "DisplayName"
		or obj.Name == "FastOverheadTemplate" then
		return
	end

	pcall(function()
		obj:Destroy()
	end)
end

local ClothingClasses = {
	"Shirt", "Pants", "ShirtGraphic",
	"Accessory", "Hat", "HairAccessory",
	"FaceAccessory", "NeckAccessory", "ShoulderAccessory",
	"FrontAccessory", "BackAccessory", "WaistAccessory",
}

local function IsClothing(obj)
	for _, c in ipairs(ClothingClasses) do
		if obj:IsA(c) then
			return true
		end
	end
	return false
end

local function IsCharacterPart(obj)
	local parent = obj.Parent
	while parent and parent ~= WorkspaceService do
		if parent:IsA("Model") and Players:GetPlayerFromCharacter(parent) then
			return true
		end
		parent = parent.Parent
	end
	return false
end

local function IsOutOfRange(obj)
	if obj:IsA("BasePart") then
		local x = obj.Position.X
		return x < -560 or x > -240
	end
	return false
end

local BASE_NAMES = {
	["baseplate"] = true,
	["spawnlocation"] = true,
	["spawn location"] = true,
	["spawn"] = true,
}

local function IsBase(obj)
	if not obj:IsA("BasePart") then
		return false
	end

	local nameLower = obj.Name:lower()
	if BASE_NAMES[nameLower] then
		return true
	end

	for n in pairs(BASE_NAMES) do
		if nameLower:find(n, 1, true) then
			return true
		end
	end

	return false
end

local function IsInBase(obj)
	local p = obj.Parent
	while p and p ~= WorkspaceService do
		if IsBase(p) then
			return true
		end
		p = p.Parent
	end
	return false
end

local function IsProtectedFromBoost(obj)
	local p = obj
	while p and p ~= WorkspaceService do
		if p.Name == "Debris" then
			return true
		end
		if p.Name == "FastOverheadTemplate" then
			return true
		end
		if p.Name == "AnimalOverhead" then
			return true
		end
		p = p.Parent
	end
	return false
end

local function MakeTransparentUltra(obj)
	pcall(function()
		if IsBase(obj) and not IsCharacterPart(obj) then
			if OriginalTransparency[obj] == nil then
				OriginalTransparency[obj] = {
					trans = obj.Transparency,
					shadow = obj.CastShadow
				}
			end
			obj.Transparency = 1
			obj.CastShadow = false
		end
	end)
end

local function StripObjectUltra(obj)
	pcall(function()
		if IsProtectedFromBoost(obj) then
			return
		end

		if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
			SafeDestroyUltra(obj)

		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
			or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
			pcall(function() obj.Enabled = false end)
			SafeDestroyUltra(obj)

		elseif obj:IsA("SurfaceAppearance") then
			SafeDestroyUltra(obj)

		elseif obj:IsA("BasePart") then
			obj.CastShadow = false
			obj.Material = Enum.Material.Plastic
			obj.MaterialVariant = ""
			obj.Reflectance = 0
		end
	end)
end

local function CleanObjectUltra(obj)
	pcall(function()
		if IsProtectedFromBoost(obj) then
			return
		end

		if obj:IsA("SurfaceAppearance") then
			SafeDestroyUltra(obj)

		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then
				SafeDestroyUltra(obj)
			end

		elseif obj:IsA("SpecialMesh") then
			obj.TextureId = ""

		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
			SafeDestroyUltra(obj)

		elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
			SafeDestroyUltra(obj)

		elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
			SafeDestroyUltra(obj)

		elseif obj:IsA("Animation") or obj:IsA("AnimationController") then
			SafeDestroyUltra(obj)

		elseif obj:IsA("BasePart") then
			obj.CastShadow = false
			obj.Material = Enum.Material.Plastic
			obj.MaterialVariant = ""
			obj.Reflectance = 0
		end
	end)
end

local function StopAnimationsUltra(animator)
	pcall(function()
		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
			local isChar = false
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr.Character and animator:IsDescendantOf(plr.Character) then
					isChar = true
					break
				end
			end
			if not isChar then
				track:Stop()
			end
		end
	end)
end

local function OptimizeCharacterUltra(char)
	if not char then
		return
	end

	task.spawn(function()
		task.wait(0.3)
		for _, obj in ipairs(char:GetDescendants()) do
			if IsClothing(obj) then
				SafeDestroyUltra(obj)
			else
				CleanObjectUltra(obj)
			end
		end
	end)
end

local function ApplyGreySkyUltra()
	pcall(function()
		for _, obj in ipairs(Lighting:GetChildren()) do
			if obj:IsA("Sky") then
				obj:Destroy()
			end
		end

		local sky = Instance.new("Sky")
		sky.SkyboxBk = ""
		sky.SkyboxDn = ""
		sky.SkyboxFt = ""
		sky.SkyboxLf = ""
		sky.SkyboxRt = ""
		sky.SkyboxUp = ""
		sky.CelestialBodiesShown = false
		sky.Parent = Lighting
	end)
end

local function OptimizeLightingUltra()
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		Lighting.FogStart = 9e9
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
		Lighting.Brightness = 1.5
		Lighting.Ambient = Color3.fromRGB(60, 60, 60)
	end)

	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("PostEffect") then
			pcall(function()
				v.Enabled = false
			end)
		elseif v:IsA("Atmosphere") or v:IsA("Clouds") then
			v:Destroy()
		end
	end

	ApplyGreySkyUltra()
end

local function ApplyTerrainUltra()
	pcall(function()
		local T = WorkspaceService.Terrain
		T.Decoration = false
		T.WaterWaveSize = 0
		T.WaterWaveSpeed = 0
		T.WaterReflectance = 0
		T.WaterTransparency = 1
	end)
end

local function setFPSBoostUltra(enabled)
	_Config.FPSBoostUltra = enabled
	_saveConfig()
	_setToggle("FPS Boost Ultra", enabled)

	if enabled then
		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
			settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
			settings().Physics.AllowSleep = true
			settings().Physics.PhysicsEnvironmentalThrottle = 1
		end)

		if type(setfpscap) == "function" then
			pcall(setfpscap, 0)
		end

		OptimizeLightingUltra()
		ApplyTerrainUltra()

		AddUltraThread(function()
			local allDesc = WorkspaceService:GetDescendants()
			local BATCH_SIZE = 200

			for i = 1, #allDesc, BATCH_SIZE do
				if not _Config.FPSBoostUltra then
					break
				end

				local batchEnd = math.min(i + BATCH_SIZE - 1, #allDesc)
				for j = i, batchEnd do
					local obj = allDesc[j]
					if obj and obj.Parent then
						if IsProtectedFromBoost(obj) then
							-- No tocar los animales / overhead / debris
						elseif IsBase(obj) then
							MakeTransparentUltra(obj)
						elseif IsClothing(obj) then
							SafeDestroyUltra(obj)
						elseif IsInBase(obj) then
							-- skip
						elseif IsCharacterPart(obj) then
							-- skip
						elseif IsOutOfRange(obj) then
							SafeDestroyUltra(obj)
						else
							CleanObjectUltra(obj)
							StripObjectUltra(obj)
							if obj:IsA("Animator") then
								StopAnimationsUltra(obj)
							end
						end
					end
				end

				if i + BATCH_SIZE <= #allDesc then
					task.wait()
				end
			end
		end)

		AddUltraConnection(WorkspaceService.DescendantAdded:Connect(function(obj)
			task.defer(function()
				if not _Config.FPSBoostUltra then
					return
				end

				if IsProtectedFromBoost(obj) then
					return
				end

				if IsBase(obj) then
					MakeTransparentUltra(obj)
					return
				end

				if IsClothing(obj) then
					SafeDestroyUltra(obj)
				elseif IsInBase(obj) then
					-- skip
				elseif IsCharacterPart(obj) then
					-- skip
				elseif IsOutOfRange(obj) then
					SafeDestroyUltra(obj)
				else
					CleanObjectUltra(obj)
					StripObjectUltra(obj)
					if obj:IsA("Animator") then
						StopAnimationsUltra(obj)
					end
				end
			end)
		end))

		AddUltraConnection(Lighting.DescendantAdded:Connect(function(obj)
			if obj:IsA("PostEffect") then
				pcall(function()
					obj.Enabled = false
				end)
			elseif obj:IsA("Atmosphere") or obj:IsA("Clouds") then
				SafeDestroyUltra(obj)
			end
		end))

		AddUltraConnection(MaterialService.DescendantAdded:Connect(function(obj)
			SafeDestroyUltra(obj)
		end))

		for _, plr in ipairs(Players:GetPlayers()) do
			OptimizeCharacterUltra(plr.Character)
			AddUltraConnection(plr.CharacterAdded:Connect(OptimizeCharacterUltra))
		end

		AddUltraConnection(Players.PlayerAdded:Connect(function(plr)
			AddUltraConnection(plr.CharacterAdded:Connect(OptimizeCharacterUltra))
		end))

		AddUltraThread(function()
			while _Config.FPSBoostUltra do
				task.wait(15)
				pcall(function()
					collectgarbage("collect")
				end)
			end
		end)
	else
		for _, conn in ipairs(_ultraConnections) do
			if typeof(conn) == "RBXScriptConnection" then
				conn:Disconnect()
			end
		end
		_ultraConnections = {}

		for _, thr in ipairs(_ultraThreads) do
			pcall(function()
				task.cancel(thr)
			end)
		end
		_ultraThreads = {}

		pcall(function()
			for part, data in pairs(OriginalTransparency) do
				if part and part.Parent then
					part.Transparency = data.trans
					part.CastShadow = data.shadow
				end
			end
		end)
		OriginalTransparency = {}

		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
			settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Automatic
			Lighting.GlobalShadows = true
			Lighting.Brightness = 2
			Lighting.FogEnd = 100000
			WorkspaceService.Terrain.WaterWaveSize = 0.15
			WorkspaceService.Terrain.WaterWaveSpeed = 1
			WorkspaceService.Terrain.WaterReflectance = 0.5
			WorkspaceService.Terrain.WaterTransparency = 0.3
			WorkspaceService.Terrain.Decoration = true
		end)
	end
end

-- TOGGLE (Validación adicional por si usas otro nombre en tu librería UI)
if type(createToggle) == "function" then
	createToggle("FPS Boost Ultra", function(state)
		setFPSBoostUltra(state)
	end)
else
	warn("[HUB] Asegúrate de que la función createToggle existe en este punto del script.")
end

end
-- ================= FPS BOOSTER ULTRA V4 =================
do
	local Players = game:GetService("Players")
	local Lighting = game:GetService("Lighting")
	local WorkspaceService = game:GetService("Workspace")
	local MaterialService = game:GetService("MaterialService")

	-- =====================================================
	-- COMPATIBILIDAD
	-- =====================================================

	local _Config = type(Config) == "table" and Config or {}
	local _saveConfig = type(saveConfig) == "function" and saveConfig or function() end
	local _setToggle = type(setToggle) == "function" and setToggle or function() end

	-- =====================================================
	-- ESTADO
	-- =====================================================

	local boosterEnabled = false

	local OriginalTransparency = setmetatable({}, {
		__mode = "k"
	})

	local _ultraThreads = {}
	local _ultraConnections = {}

	-- =====================================================
	-- AJUSTES
	-- =====================================================

	-- Cantidad procesada durante la carga inicial
	local INITIAL_BATCH_SIZE = 200

	-- Objetos nuevos procesados por pequeña tanda
	local NEW_OBJECT_BATCH_SIZE = 30

	-- Tiempo entre tandas de objetos nuevos.
	-- Esto evita que el booster esté trabajando constantemente.
	local NEW_OBJECT_DELAY = 0.10

	-- =====================================================
	-- COLA DE OBJETOS NUEVOS
	-- =====================================================

	local pendingObjects = {}
	local pendingSet = setmetatable({}, {
		__mode = "k"
	})

	local queueProcessing = false

	-- =====================================================
	-- THREAD / CONNECTION HELPERS
	-- =====================================================

	local function AddUltraThread(thread)
		if thread then
			table.insert(_ultraThreads, thread)
		end
	end

	local function AddUltraConnection(connection)
		if connection then
			table.insert(_ultraConnections, connection)
		end
	end

	local function DisconnectEverything()
		for i = #_ultraConnections, 1, -1 do
			local connection = _ultraConnections[i]

			if typeof(connection) == "RBXScriptConnection" then
				pcall(function()
					connection:Disconnect()
				end)
			end
		end

		table.clear(_ultraConnections)
	end

	local function CancelEverything()
		for i = #_ultraThreads, 1, -1 do
			local thread = _ultraThreads[i]

			pcall(function()
				task.cancel(thread)
			end)
		end

		table.clear(_ultraThreads)
	end

	-- =====================================================
	-- LIMPIAR COLA
	-- =====================================================

	local function ClearPendingObjects()
		table.clear(pendingObjects)
		table.clear(pendingSet)
	end

	-- =====================================================
	-- ENCOLAR OBJETO
	-- =====================================================

	local function QueueObject(obj)
		if not boosterEnabled then
			return
		end

		if not obj or not obj.Parent then
			return
		end

		if pendingSet[obj] then
			return
		end

		pendingSet[obj] = true

		pendingObjects[#pendingObjects + 1] = obj
	end

	-- =====================================================
	-- PROTECCIONES
	-- =====================================================

	local function IsProtectedFromBoost(obj)
		local parent = obj

		while parent and parent ~= WorkspaceService do
			local name = parent.Name

			if name == "Debris"
				or name == "FastOverheadTemplate"
				or name == "AnimalOverhead" then

				return true
			end

			parent = parent.Parent
		end

		return false
	end

	-- =====================================================
	-- ROPA / ACCESORIOS
	-- =====================================================

	local function IsClothing(obj)
		return obj:IsA("Shirt")
			or obj:IsA("Pants")
			or obj:IsA("ShirtGraphic")
			or obj:IsA("Accessory")
			or obj:IsA("Hat")
			or obj:IsA("HairAccessory")
			or obj:IsA("FaceAccessory")
			or obj:IsA("NeckAccessory")
			or obj:IsA("ShoulderAccessory")
			or obj:IsA("FrontAccessory")
			or obj:IsA("BackAccessory")
			or obj:IsA("WaistAccessory")
	end

	-- =====================================================
	-- PERSONAJE
	-- =====================================================

	local function IsCharacterPart(obj)
		local parent = obj

		while parent and parent ~= WorkspaceService do
			if parent:IsA("Model") then
				if Players:GetPlayerFromCharacter(parent) then
					return true
				end
			end

			parent = parent.Parent
		end

		return false
	end

	-- =====================================================
	-- BASE
	-- =====================================================

	local BASE_NAMES = {
		["baseplate"] = true,
		["spawnlocation"] = true,
		["spawn location"] = true,
		["spawn"] = true,
	}

	local function IsBase(obj)
		if not obj:IsA("BasePart") then
			return false
		end

		local nameLower = obj.Name:lower()

		if BASE_NAMES[nameLower] then
			return true
		end

		for name in pairs(BASE_NAMES) do
			if nameLower:find(name, 1, true) then
				return true
			end
		end

		return false
	end

	-- =====================================================
	-- DENTRO DE BASE
	-- =====================================================

	local function IsInBase(obj)
		local parent = obj.Parent

		while parent and parent ~= WorkspaceService do
			if IsBase(parent) then
				return true
			end

			parent = parent.Parent
		end

		return false
	end

	-- =====================================================
	-- RANGO
	-- =====================================================

	local function IsOutOfRange(obj)
		if not obj:IsA("BasePart") then
			return false
		end

		local x = obj.Position.X

		return x < -560 or x > -240
	end

	-- =====================================================
	-- TRANSPARENCIA DE BASE
	-- =====================================================

	local function MakeTransparentUltra(obj)
		if not obj:IsA("BasePart") then
			return
		end

		if not IsBase(obj) then
			return
		end

		if IsCharacterPart(obj) then
			return
		end

		pcall(function()
			if OriginalTransparency[obj] == nil then
				OriginalTransparency[obj] = {
					trans = obj.Transparency,
					shadow = obj.CastShadow
				}
			end

			obj.Transparency = 1
			obj.CastShadow = false
		end)
	end

	-- =====================================================
	-- ELIMINAR DE FORMA SEGURA
	-- =====================================================

	local function SafeDestroyUltra(obj)
		if not obj then
			return
		end

		local name = obj.Name

		if name == "Overhead"
			or name == "AnimalOverhead"
			or name == "Generation"
			or name == "DisplayName"
			or name == "FastOverheadTemplate" then

			return
		end

		pcall(function()
			if obj.Parent then
				obj:Destroy()
			end
		end)
	end

	-- =====================================================
	-- OPTIMIZACIÓN DE OBJETO
	-- =====================================================

	local function OptimizeObjectUltra(obj)
		if not boosterEnabled then
			return
		end

		if not obj or not obj.Parent then
			return
		end

		-- Protección
		if IsProtectedFromBoost(obj) then
			return
		end

		-- Protección completa de personajes
		if IsCharacterPart(obj) then
			return
		end

		-- Protección de ropa y accesorios
		if IsClothing(obj) then
			return
		end

		-- Bases
		if IsBase(obj) then
			MakeTransparentUltra(obj)
			return
		end

		-- No tocar contenido de las bases
		if IsInBase(obj) then
			return
		end

		-- Eliminar objetos fuera del rango
		if IsOutOfRange(obj) then
			SafeDestroyUltra(obj)
			return
		end

		-- =================================================
		-- APARIENCIA
		-- =================================================

		if obj:IsA("SurfaceAppearance") then
			SafeDestroyUltra(obj)
			return
		end

		if obj:IsA("SpecialMesh") then
			SafeDestroyUltra(obj)
			return
		end

		if obj:IsA("Texture") then
			SafeDestroyUltra(obj)
			return
		end

		if obj:IsA("Decal") then
			-- Mantener la cara del personaje
			if obj.Name == "face"
				and obj.Parent
				and obj.Parent.Name == "Head" then

				return
			end

			SafeDestroyUltra(obj)
			return
		end

		-- =================================================
		-- EFECTOS
		-- =================================================

		if obj:IsA("ParticleEmitter")
			or obj:IsA("Trail")
			or obj:IsA("Beam")
			or obj:IsA("Smoke")
			or obj:IsA("Fire")
			or obj:IsA("Sparkles") then

			pcall(function()
				if obj:IsA("ParticleEmitter")
					or obj:IsA("Trail")
					or obj:IsA("Beam") then

					obj.Enabled = false
				end
			end)

			SafeDestroyUltra(obj)
			return
		end

		-- =================================================
		-- LUCES
		-- =================================================

		if obj:IsA("PointLight")
			or obj:IsA("SpotLight")
			or obj:IsA("SurfaceLight") then

			SafeDestroyUltra(obj)
			return
		end

		-- =================================================
		-- EXPLOSIONES
		-- =================================================

		if obj:IsA("Explosion") then
			SafeDestroyUltra(obj)
			return
		end

		-- =================================================
		-- ANIMACIONES NO RELACIONADAS CON JUGADORES
		-- =================================================

		if obj:IsA("Animation") then
			SafeDestroyUltra(obj)
			return
		end

		if obj:IsA("AnimationController") then
			SafeDestroyUltra(obj)
			return
		end

		-- =================================================
		-- PARTES
		-- =================================================

		if obj:IsA("BasePart") then
			pcall(function()
				obj.CastShadow = false
				obj.Material = Enum.Material.Plastic
				obj.MaterialVariant = ""
				obj.Reflectance = 0
			end)

			return
		end

		-- =================================================
		-- ANIMATOR
		-- =================================================

		if obj:IsA("Animator") then
			pcall(function()
				if not IsCharacterPart(obj) then
					for _, track in ipairs(
						obj:GetPlayingAnimationTracks()
					) do
						pcall(function()
							track:Stop()
						end)
					end
				end
			end)
		end
	end

	-- =====================================================
	-- PROCESAR OBJETOS NUEVOS
	-- =====================================================

	local function StartNewObjectProcessor()
		if queueProcessing then
			return
		end

		queueProcessing = true

		local thread = task.spawn(function()
			while boosterEnabled do
				local processed = 0
				local total = #pendingObjects

				while processed < NEW_OBJECT_BATCH_SIZE do
					if not boosterEnabled then
						break
					end

					if #pendingObjects == 0 then
						break
					end

					local obj = table.remove(pendingObjects, 1)

					if obj then
						pendingSet[obj] = nil

						if obj.Parent then
							OptimizeObjectUltra(obj)
						end
					end

					processed += 1
				end

				-- Solo espera cuando realmente hay trabajo.
				-- NO usa Heartbeat continuamente.
				if total > 0 and #pendingObjects > 0 then
					task.wait(NEW_OBJECT_DELAY)
				else
					task.wait(0.25)
				end
			end

			queueProcessing = false
		end)

		AddUltraThread(thread)
	end

	-- =====================================================
	-- OPTIMIZACIÓN INICIAL
	-- =====================================================

	local function ProcessInitialWorkspace()
		local objects = WorkspaceService:GetDescendants()
		local total = #objects

		for startIndex = 1, total, INITIAL_BATCH_SIZE do
			if not boosterEnabled then
				break
			end

			local endIndex = math.min(
				startIndex + INITIAL_BATCH_SIZE - 1,
				total
			)

			for i = startIndex, endIndex do
				local obj = objects[i]

				if obj and obj.Parent then
					OptimizeObjectUltra(obj)
				end
			end

			-- Un pequeño descanso entre lotes.
			if endIndex < total then
				task.wait()
			end
		end

		table.clear(objects)
	end

	-- =====================================================
	-- SKY
	-- =====================================================

	local function ApplyGreySkyUltra()
		pcall(function()
			for _, obj in ipairs(Lighting:GetChildren()) do
				if obj:IsA("Sky") then
					obj:Destroy()
				end
			end

			local sky = Instance.new("Sky")

			sky.SkyboxBk = ""
			sky.SkyboxDn = ""
			sky.SkyboxFt = ""
			sky.SkyboxLf = ""
			sky.SkyboxRt = ""
			sky.SkyboxUp = ""

			sky.CelestialBodiesShown = false
			sky.Parent = Lighting
		end)
	end

	-- =====================================================
	-- LIGHTING
	-- =====================================================

	local function OptimizeLightingUltra()
		pcall(function()
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9e9
			Lighting.FogStart = 9e9

			Lighting.EnvironmentDiffuseScale = 0
			Lighting.EnvironmentSpecularScale = 0

			Lighting.Brightness = 1.5
			Lighting.Ambient = Color3.fromRGB(60, 60, 60)
		end)

		for _, obj in ipairs(Lighting:GetChildren()) do
			if obj:IsA("PostEffect") then
				pcall(function()
					obj.Enabled = false
				end)

			elseif obj:IsA("Atmosphere")
				or obj:IsA("Clouds") then

				SafeDestroyUltra(obj)
			end
		end

		ApplyGreySkyUltra()
	end

	-- =====================================================
	-- TERRAIN
	-- =====================================================

	local function ApplyTerrainUltra()
		pcall(function()
			local terrain = WorkspaceService.Terrain

			terrain.Decoration = false
			terrain.WaterWaveSize = 0
			terrain.WaterWaveSpeed = 0
			terrain.WaterReflectance = 0
			terrain.WaterTransparency = 1
		end)
	end

	-- =====================================================
	-- RESTAURAR
	-- =====================================================

	local function RestoreUltra()
		ClearPendingObjects()

		pcall(function()
			for part, data in pairs(OriginalTransparency) do
				if part and part.Parent then
					part.Transparency = data.trans
					part.CastShadow = data.shadow
				end
			end
		end)

		table.clear(OriginalTransparency)

		pcall(function()
			settings().Rendering.QualityLevel =
				Enum.QualityLevel.Automatic

			settings().Rendering.MeshPartDetailLevel =
				Enum.MeshPartDetailLevel.Automatic
		end)

		pcall(function()
			Lighting.GlobalShadows = true
			Lighting.Brightness = 2
			Lighting.FogEnd = 100000
		end)

		pcall(function()
			local terrain = WorkspaceService.Terrain

			terrain.WaterWaveSize = 0.15
			terrain.WaterWaveSpeed = 1
			terrain.WaterReflectance = 0.5
			terrain.WaterTransparency = 0.3
			terrain.Decoration = true
		end)
	end

	-- =====================================================
	-- START / STOP
	-- =====================================================

	local function setFPSBoostUltra(enabled)
		-- Evitar reiniciar el sistema innecesariamente
		if boosterEnabled == enabled then
			return
		end

		boosterEnabled = enabled

		_Config.FPSBoosterUltraV2 = enabled

		pcall(function()
			_saveConfig()
		end)

		if type(setToggle) == "function" then
			pcall(function()
				setToggle(
					"FPS Booster Ultra v2",
					enabled
				)
			end)
		end

		DisconnectEverything()
		CancelEverything()

		queueProcessing = false

		if not enabled then
			RestoreUltra()
			return
		end

		-- =================================================
		-- AJUSTES DE RENDER / FÍSICA
		-- =================================================

		pcall(function()
			settings().Rendering.QualityLevel =
				Enum.QualityLevel.Level01

			settings().Rendering.MeshPartDetailLevel =
				Enum.MeshPartDetailLevel.Level01

			settings().Physics.AllowSleep = true
			settings().Physics.PhysicsEnvironmentalThrottle = 1
		end)

		if type(setfpscap) == "function" then
			pcall(setfpscap, 0)
		end

		-- =================================================
		-- LIGHTING / TERRAIN
		-- =================================================

		OptimizeLightingUltra()
		ApplyTerrainUltra()

		-- =================================================
		-- CARGA INICIAL
		-- =================================================

		AddUltraThread(
			task.spawn(function()
				ProcessInitialWorkspace()
			end)
		)

		-- =================================================
		-- OBJETOS NUEVOS
		--
		-- Importante:
		-- solo se encolan, no se procesa cada objeto
		-- inmediatamente.
		-- =================================================

		AddUltraConnection(
			WorkspaceService.DescendantAdded:Connect(function(obj)
				if not boosterEnabled then
					return
				end

				QueueObject(obj)

				if not queueProcessing then
					StartNewObjectProcessor()
				end
			end)
		)

		-- =================================================
		-- LIGHTING DINÁMICO
		-- =================================================

		AddUltraConnection(
			Lighting.DescendantAdded:Connect(function(obj)
				if not boosterEnabled then
					return
				end

				if obj:IsA("PostEffect") then
					pcall(function()
						obj.Enabled = false
					end)

				elseif obj:IsA("Atmosphere")
					or obj:IsA("Clouds") then

					SafeDestroyUltra(obj)
				end
			end)
		)

		-- =================================================
		-- MATERIAL SERVICE
		-- =================================================

		AddUltraConnection(
			MaterialService.DescendantAdded:Connect(function(obj)
				if not boosterEnabled then
					return
				end

				SafeDestroyUltra(obj)
			end)
		)

		-- =================================================
		-- JUGADORES
		-- =================================================

		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character then
				-- Deliberadamente no modificar personajes.
			end

			AddUltraConnection(
				player.CharacterAdded:Connect(function()
					-- Deliberadamente no modificar personajes.
				end)
			)
		end

		AddUltraConnection(
			Players.PlayerAdded:Connect(function(player)
				AddUltraConnection(
					player.CharacterAdded:Connect(function()
						-- Deliberadamente no modificar personajes.
					end)
				)
			end)
		)
	end

	-- =====================================================
	-- TOGGLE
	-- =====================================================

	if type(createToggle) == "function" then
		createToggle(
			"FPS Booster Ultra v2",
			function(state)
				pcall(function()
					setFPSBoostUltra(state)
				end)
			end
		)
	else
		warn(
			"[HUB] Asegúrate de que la función createToggle existe en este punto del script."
		)
	end
end

-- ================= END FPS BOOSTER ULTRA V4 =================
-- ============================================================
-- ============================================================
-- PREMIUM KICK PANEL V4
-- ESPAÑOL + KICK INSTANTÁNEO + ARRASTRE REAL + ESCALA
-- ============================================================

do
    -- ========================================================
    -- SERVICIOS
    -- ========================================================

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")

    local player = Players.LocalPlayer

    -- ========================================================
    -- ESTADO
    -- ========================================================

    local kickButtonEnabled = false
    local kickGui = nil

    local settingsOpen = false
    local minimized = false

    local dragging = false
    local dragStart = nil
    local startPosition = nil
    local activeDragInput = nil

    local sliderDragging = false

    -- ========================================================
    -- CONFIGURACIÓN
    -- ========================================================

    local SAVE_FILE = "KickPanel_Config.json"

    local DEFAULT_WIDTH = 175
    local DEFAULT_HEIGHT = 88

    local DEFAULT_SCALE = 1
    local MIN_SCALE = 0.70
    local MAX_SCALE = 1.50

    local currentScale = DEFAULT_SCALE

    local defaultPosition = UDim2.new(
        0.5,
        -DEFAULT_WIDTH / 2,
        0.5,
        -DEFAULT_HEIGHT / 2
    )

    local lastPosition = defaultPosition

    -- ========================================================
    -- CARGAR CONFIGURACIÓN
    -- ========================================================

    pcall(function()
        if isfile and isfile(SAVE_FILE) and readfile then
            local raw = readfile(SAVE_FILE)
            local data = HttpService:JSONDecode(raw)

            if type(data) == "table" then
                if data.XScale ~= nil
                    and data.XOffset ~= nil
                    and data.YScale ~= nil
                    and data.YOffset ~= nil then

                    lastPosition = UDim2.new(
                        tonumber(data.XScale) or 0.5,
                        tonumber(data.XOffset) or -DEFAULT_WIDTH / 2,
                        tonumber(data.YScale) or 0.5,
                        tonumber(data.YOffset) or -DEFAULT_HEIGHT / 2
                    )
                end

                if tonumber(data.Scale) then
                    currentScale = math.clamp(
                        tonumber(data.Scale),
                        MIN_SCALE,
                        MAX_SCALE
                    )
                end
            end
        end
    end)

    -- ========================================================
    -- GUARDAR CONFIGURACIÓN
    -- ========================================================

    local function saveConfig(position, scale)
        if position then
            lastPosition = position
        end

        if scale ~= nil then
            currentScale = math.clamp(
                tonumber(scale) or DEFAULT_SCALE,
                MIN_SCALE,
                MAX_SCALE
            )
        end

        pcall(function()
            if writefile then
                local data = {
                    XScale = lastPosition.X.Scale,
                    XOffset = lastPosition.X.Offset,

                    YScale = lastPosition.Y.Scale,
                    YOffset = lastPosition.Y.Offset,

                    Scale = currentScale
                }

                writefile(
                    SAVE_FILE,
                    HttpService:JSONEncode(data)
                )
            end
        end)
    end

    -- ========================================================
    -- FUNCIÓN PARA CREAR EL PANEL
    -- ========================================================

    local function createKickButton()

        -- ====================================================
        -- LIMPIAR ANTERIOR
        -- ====================================================

        if kickGui then
            pcall(function()
                kickGui:Destroy()
            end)
            kickGui = nil
        end

        -- ====================================================
        -- SCREEN GUI
        -- ====================================================

        local gui = Instance.new("ScreenGui")
        gui.Name = "PremiumKickPanel"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = player:WaitForChild("PlayerGui")

        kickGui = gui

        -- ====================================================
        -- MARCO PRINCIPAL
        -- ====================================================

        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"

        mainFrame.Size = UDim2.new(
            0,
            DEFAULT_WIDTH,
            0,
            DEFAULT_HEIGHT
        )

        mainFrame.Position = lastPosition

        mainFrame.BackgroundColor3 = Color3.fromRGB(
            9,
            13,
            19
        )

        mainFrame.BackgroundTransparency = 0.03
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.ClipsDescendants = false
        mainFrame.Parent = gui

        -- ====================================================
        -- ESCALA
        -- ====================================================

        local uiScale = Instance.new("UIScale")
        uiScale.Name = "ResponsiveScale"
        uiScale.Scale = currentScale
        uiScale.Parent = mainFrame

        -- ====================================================
        -- SOMBRA
        -- ====================================================

        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"

        shadow.AnchorPoint = Vector2.new(0.5, 0.5)

        shadow.Position = UDim2.new(
            0.5,
            0,
            0.5,
            4
        )

        shadow.Size = UDim2.new(
            0,
            DEFAULT_WIDTH + 34,
            0,
            DEFAULT_HEIGHT + 34
        )

        shadow.BackgroundTransparency = 1

        shadow.Image = "rbxassetid://1316045217"

        shadow.ImageColor3 = Color3.fromRGB(
            0,
            0,
            0
        )

        shadow.ImageTransparency = 0.35

        shadow.ScaleType = Enum.ScaleType.Slice

        shadow.SliceCenter = Rect.new(
            10,
            10,
            118,
            118
        )

        shadow.ZIndex = 0
        shadow.Parent = mainFrame

        -- ====================================================
        -- BORDE REDONDEADO
        -- ====================================================

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 13)
        frameCorner.Parent = mainFrame

        -- ====================================================
        -- DEGRADADO DEL PANEL
        -- ====================================================

        local frameGradient = Instance.new("UIGradient")

        frameGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(14, 20, 29)
            ),

            ColorSequenceKeypoint.new(
                0.55,
                Color3.fromRGB(9, 14, 21)
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(6, 9, 14)
            )
        })

        frameGradient.Rotation = 90
        frameGradient.Parent = mainFrame

        -- ====================================================
        -- BORDE
        -- ====================================================

        local frameStroke = Instance.new("UIStroke")

        frameStroke.Color = Color3.fromRGB(
            0,
            170,
            255
        )

        frameStroke.Thickness = 1.5
        frameStroke.Transparency = 0.15
        frameStroke.Parent = mainFrame

        -- ====================================================
        -- CABECERA
        -- ====================================================

        local header = Instance.new("Frame")
        header.Name = "Header"

        header.Size = UDim2.new(
            1,
            -12,
            0,
            30
        )

        header.Position = UDim2.new(
            0,
            6,
            0,
            5
        )

        header.BackgroundTransparency = 1
        header.BorderSizePixel = 0
        header.Parent = mainFrame

        -- ====================================================
        -- ZONA DEDICADA PARA ARRASTRAR
        -- ESTA ES LA PARTE IMPORTANTE
        -- ====================================================

        local dragHandle = Instance.new("TextButton")

        dragHandle.Name = "DragHandle"

        -- Deja libres los dos botones de la derecha
        dragHandle.Size = UDim2.new(
            1,
            -54,
            1,
            0
        )

        dragHandle.Position = UDim2.new(
            0,
            0,
            0,
            0
        )

        dragHandle.BackgroundTransparency = 1
        dragHandle.BorderSizePixel = 0

        dragHandle.Text = ""
        dragHandle.AutoButtonColor = false

        dragHandle.Active = true
        dragHandle.Selectable = false

        dragHandle.ZIndex = 45

        dragHandle.Parent = header

        -- ====================================================
        -- ICONO
        -- ====================================================

        local icon = Instance.new("TextLabel")

        icon.Size = UDim2.new(
            0,
            25,
            0,
            25
        )

        icon.Position = UDim2.new(
            0,
            0,
            0,
            0
        )

        icon.BackgroundColor3 = Color3.fromRGB(
            0,
            95,
            160
        )

        icon.BackgroundTransparency = 0.15

        icon.Text = "⚡"

        icon.TextColor3 = Color3.fromRGB(
            255,
            255,
            255
        )

        icon.Font = Enum.Font.GothamBold
        icon.TextSize = 13
        icon.ZIndex = 46
        icon.Parent = header

        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(0, 7)
        iconCorner.Parent = icon

        -- ====================================================
        -- TÍTULO
        -- ====================================================

        local title = Instance.new("TextLabel")

        title.Size = UDim2.new(
            1,
            -100,
            0,
            16
        )

        title.Position = UDim2.new(
            0,
            32,
            0,
            1
        )

        title.BackgroundTransparency = 1

        title.Text = "KICK BOTON"

        title.TextColor3 = Color3.fromRGB(
            235,
            245,
            255
        )

        title.Font = Enum.Font.GothamBold
        title.TextSize = 11
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 46
        title.Parent = header

        -- ====================================================
        -- SUBTÍTULO
        -- ====================================================

        local subtitle = Instance.new("TextLabel")

        subtitle.Size = UDim2.new(
            1,
            -100,
            0,
            12
        )

        subtitle.Position = UDim2.new(
            0,
            32,
            0,
            16
        )

        subtitle.BackgroundTransparency = 1

        subtitle.Text = "PANEL DE CONTROL"

        subtitle.TextColor3 = Color3.fromRGB(
            105,
            125,
            145
        )

        subtitle.Font = Enum.Font.GothamMedium
        subtitle.TextSize = 7
        subtitle.TextXAlignment = Enum.TextXAlignment.Left
        subtitle.ZIndex = 46
        subtitle.Parent = header

        -- ====================================================
        -- BOTÓN DE CONFIGURACIÓN
        -- ====================================================

        local settingsBtn = Instance.new("TextButton")

        settingsBtn.Name = "Settings"

        settingsBtn.Size = UDim2.new(
            0,
            22,
            0,
            22
        )

        settingsBtn.Position = UDim2.new(
            1,
            -52,
            0,
            1
        )

        settingsBtn.BackgroundColor3 = Color3.fromRGB(
            18,
            28,
            40
        )

        settingsBtn.Text = "⚙"

        settingsBtn.TextColor3 = Color3.fromRGB(
            0,
            190,
            255
        )

        settingsBtn.Font = Enum.Font.GothamBold
        settingsBtn.TextSize = 13
        settingsBtn.AutoButtonColor = false
        settingsBtn.ZIndex = 70
        settingsBtn.Parent = header

        local settingsCorner = Instance.new("UICorner")
        settingsCorner.CornerRadius = UDim.new(0, 7)
        settingsCorner.Parent = settingsBtn

        local settingsStroke = Instance.new("UIStroke")

        settingsStroke.Color = Color3.fromRGB(
            0,
            110,
            180
        )

        settingsStroke.Thickness = 1
        settingsStroke.Parent = settingsBtn

        -- ====================================================
        -- BOTÓN MINIMIZAR
        -- ====================================================

        local minimizeBtn = Instance.new("TextButton")

        minimizeBtn.Name = "Minimize"

        minimizeBtn.Size = UDim2.new(
            0,
            22,
            0,
            22
        )

        minimizeBtn.Position = UDim2.new(
            1,
            -27,
            0,
            1
        )

        minimizeBtn.BackgroundColor3 = Color3.fromRGB(
            18,
            28,
            40
        )

        minimizeBtn.Text = "—"

        minimizeBtn.TextColor3 = Color3.fromRGB(
            150,
            180,
            200
        )

        minimizeBtn.Font = Enum.Font.GothamBold
        minimizeBtn.TextSize = 11
        minimizeBtn.AutoButtonColor = false
        minimizeBtn.ZIndex = 70
        minimizeBtn.Parent = header

        local minimizeCorner = Instance.new("UICorner")
        minimizeCorner.CornerRadius = UDim.new(0, 7)
        minimizeCorner.Parent = minimizeBtn

        -- ====================================================
        -- ESTADO
        -- ====================================================

        local status = Instance.new("TextLabel")

        status.Name = "Status"

        status.Size = UDim2.new(
            1,
            -24,
            0,
            14
        )

        status.Position = UDim2.new(
            0,
            12,
            0,
            33
        )

        status.BackgroundTransparency = 1

        status.Text = "● LISTO"

        status.TextColor3 = Color3.fromRGB(
            0,
            200,
            255
        )

        status.Font = Enum.Font.GothamMedium
        status.TextSize = 8
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.ZIndex = 10
        status.Parent = mainFrame

        -- ====================================================
        -- BOTÓN KICK
        -- ====================================================

        local kickBtn = Instance.new("TextButton")

        kickBtn.Name = "KickButton"

        kickBtn.Size = UDim2.new(
            1,
            -24,
            0,
            32
        )

        kickBtn.Position = UDim2.new(
            0,
            12,
            0,
            51
        )

        kickBtn.BackgroundColor3 = Color3.fromRGB(
            0,
            125,
            220
        )

        kickBtn.BorderSizePixel = 0

        kickBtn.Text = "⚡  KICK"

        kickBtn.TextColor3 = Color3.fromRGB(
            255,
            255,
            255
        )

        kickBtn.Font = Enum.Font.GothamBold
        kickBtn.TextSize = 11
        kickBtn.AutoButtonColor = false
        kickBtn.ZIndex = 15
        kickBtn.Parent = mainFrame

        local kickCorner = Instance.new("UICorner")
        kickCorner.CornerRadius = UDim.new(0, 9)
        kickCorner.Parent = kickBtn

        local kickGradient = Instance.new("UIGradient")

        kickGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(
                    0,
                    190,
                    255
                )
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(
                    0,
                    95,
                    205
                )
            )
        })

        kickGradient.Rotation = 90
        kickGradient.Parent = kickBtn

        local kickStroke = Instance.new("UIStroke")

        kickStroke.Color = Color3.fromRGB(
            0,
            215,
            255
        )

        kickStroke.Transparency = 0.35
        kickStroke.Thickness = 1
        kickStroke.Parent = kickBtn

        -- ====================================================
        -- PANEL DE CONFIGURACIÓN
        -- ====================================================

        local settingsFrame = Instance.new("Frame")

        settingsFrame.Name = "SettingsFrame"

        settingsFrame.Size = UDim2.new(
            0,
            215,
            0,
            150
        )

        settingsFrame.Position = UDim2.new(
            0,
            -20,
            0,
            96
        )

        settingsFrame.BackgroundColor3 = Color3.fromRGB(
            8,
            13,
            20
        )

        settingsFrame.BorderSizePixel = 0
        settingsFrame.Visible = false
        settingsFrame.ZIndex = 20
        settingsFrame.Parent = mainFrame

        local settingsCorner2 = Instance.new("UICorner")
        settingsCorner2.CornerRadius = UDim.new(0, 12)
        settingsCorner2.Parent = settingsFrame

        local settingsStroke2 = Instance.new("UIStroke")

        settingsStroke2.Color = Color3.fromRGB(
            0,
            150,
            220
        )

        settingsStroke2.Thickness = 1.2
        settingsStroke2.Parent = settingsFrame

        -- ====================================================
        -- TÍTULO DE CONFIGURACIÓN
        -- ====================================================

        local settingsTitle = Instance.new("TextLabel")

        settingsTitle.Size = UDim2.new(
            1,
            -20,
            0,
            20
        )

        settingsTitle.Position = UDim2.new(
            0,
            10,
            0,
            9
        )

        settingsTitle.BackgroundTransparency = 1

        settingsTitle.Text = "⚙  CONFIGURACIÓN"

        settingsTitle.TextColor3 = Color3.fromRGB(
            0,
            210,
            255
        )

        settingsTitle.Font = Enum.Font.GothamBold
        settingsTitle.TextSize = 10
        settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
        settingsTitle.ZIndex = 21
        settingsTitle.Parent = settingsFrame

        -- ====================================================
        -- ETIQUETA DEL TAMAÑO
        -- ====================================================

        local scaleLabel = Instance.new("TextLabel")

        scaleLabel.Size = UDim2.new(
            1,
            -20,
            0,
            20
        )

        scaleLabel.Position = UDim2.new(
            0,
            10,
            0,
            35
        )

        scaleLabel.BackgroundTransparency = 1

        scaleLabel.TextColor3 = Color3.fromRGB(
            200,
            215,
            230
        )

        scaleLabel.Font = Enum.Font.GothamMedium
        scaleLabel.TextSize = 9
        scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
        scaleLabel.ZIndex = 21
        scaleLabel.Parent = settingsFrame

        -- ====================================================
        -- BARRA DE ESCALA
        -- ====================================================

        local slider = Instance.new("Frame")

        slider.Name = "ScaleSlider"

        slider.Size = UDim2.new(
            1,
            -40,
            0,
            7
        )

        slider.Position = UDim2.new(
            0,
            20,
            0,
            62
        )

        slider.BackgroundColor3 = Color3.fromRGB(
            26,
            39,
            52
        )

        slider.BorderSizePixel = 0
        slider.ZIndex = 21
        slider.Parent = settingsFrame

        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(1, 0)
        sliderCorner.Parent = slider

        local sliderFill = Instance.new("Frame")

        sliderFill.Size = UDim2.new(
            0.5,
            0,
            1,
            0
        )

        sliderFill.BackgroundColor3 = Color3.fromRGB(
            0,
            175,
            255
        )

        sliderFill.BorderSizePixel = 0
        sliderFill.ZIndex = 22
        sliderFill.Parent = slider

        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(1, 0)
        sliderFillCorner.Parent = sliderFill

        local knob = Instance.new("TextButton")

        knob.Name = "ScaleKnob"

        knob.Size = UDim2.new(
            0,
            17,
            0,
            17
        )

        knob.AnchorPoint = Vector2.new(
            0.5,
            0.5
        )

        knob.Position = UDim2.new(
            0.5,
            0,
            0.5,
            0
        )

        knob.BackgroundColor3 = Color3.fromRGB(
            0,
            215,
            255
        )

        knob.Text = ""
        knob.AutoButtonColor = false
        knob.ZIndex = 23
        knob.Parent = slider

        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob

        -- ====================================================
        -- BOTÓN MENOS
        -- ====================================================

        local minus = Instance.new("TextButton")

        minus.Size = UDim2.new(
            0,
            42,
            0,
            27
        )

        minus.Position = UDim2.new(
            0,
            15,
            0,
            94
        )

        minus.BackgroundColor3 = Color3.fromRGB(
            17,
            27,
            38
        )

        minus.Text = "−"

        minus.TextColor3 = Color3.fromRGB(
            220,
            230,
            240
        )

        minus.Font = Enum.Font.GothamBold
        minus.TextSize = 16
        minus.ZIndex = 21
        minus.Parent = settingsFrame

        local minusCorner = Instance.new("UICorner")
        minusCorner.CornerRadius = UDim.new(0, 7)
        minusCorner.Parent = minus

        -- ====================================================
        -- BOTÓN REINICIAR
        -- ====================================================

        local reset = Instance.new("TextButton")

        reset.Size = UDim2.new(
            0,
            70,
            0,
            27
        )

        reset.Position = UDim2.new(
            0.5,
            -35,
            0,
            94
        )

        reset.BackgroundColor3 = Color3.fromRGB(
            17,
            27,
            38
        )

        reset.Text = "REINICIAR"

        reset.TextColor3 = Color3.fromRGB(
            120,
            190,
            220
        )

        reset.Font = Enum.Font.GothamBold
        reset.TextSize = 8
        reset.ZIndex = 21
        reset.Parent = settingsFrame

        local resetCorner = Instance.new("UICorner")
        resetCorner.CornerRadius = UDim.new(0, 7)
        resetCorner.Parent = reset

        -- ====================================================
        -- BOTÓN MÁS
        -- ====================================================

        local plus = Instance.new("TextButton")

        plus.Size = UDim2.new(
            0,
            42,
            0,
            27
        )

        plus.Position = UDim2.new(
            1,
            -57,
            0,
            94
        )

        plus.BackgroundColor3 = Color3.fromRGB(
            17,
            27,
            38
        )

        plus.Text = "+"

        plus.TextColor3 = Color3.fromRGB(
            220,
            230,
            240
        )

        plus.Font = Enum.Font.GothamBold
        plus.TextSize = 16
        plus.ZIndex = 21
        plus.Parent = settingsFrame

        local plusCorner = Instance.new("UICorner")
        plusCorner.CornerRadius = UDim.new(0, 7)
        plusCorner.Parent = plus

        -- ====================================================
        -- ACTUALIZAR ESCALA
        -- ====================================================

        local function updateScale(value, shouldSave)

            value = tonumber(value)

            if not value then
                return
            end

            value = math.clamp(
                value,
                MIN_SCALE,
                MAX_SCALE
            )

            currentScale = value

            uiScale.Scale = currentScale

            local percentage = math.floor(
                currentScale * 100 + 0.5
            )

            scaleLabel.Text =
                "Tamaño de interfaz: "
                .. percentage
                .. "%"

            local alpha =
                (currentScale - MIN_SCALE)
                / (MAX_SCALE - MIN_SCALE)

            sliderFill.Size = UDim2.new(
                alpha,
                0,
                1,
                0
            )

            knob.Position = UDim2.new(
                alpha,
                0,
                0.5,
                0
            )

            if shouldSave then
                saveConfig(
                    nil,
                    currentScale
                )
            end
        end

        updateScale(
            currentScale,
            false
        )

        -- ====================================================
        -- ACTUALIZAR SLIDER
        -- ====================================================

        local function setSliderFromX(x)

            local left =
                slider.AbsolutePosition.X

            local width =
                slider.AbsoluteSize.X

            if width <= 0 then
                return
            end

            local alpha = math.clamp(
                (x - left) / width,
                0,
                1
            )

            local newScale =
                MIN_SCALE
                +
                (
                    (MAX_SCALE - MIN_SCALE)
                    * alpha
                )

            updateScale(
                newScale,
                true
            )
        end

        knob.InputBegan:Connect(function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                Enum.UserInputType.Touch then

                sliderDragging = true
            end
        end)

        slider.InputBegan:Connect(function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                Enum.UserInputType.Touch then

                sliderDragging = true

                setSliderFromX(
                    input.Position.X
                )
            end
        end)

        UserInputService.InputChanged:Connect(function(input)

            if not sliderDragging then
                return
            end

            if input.UserInputType ==
                Enum.UserInputType.MouseMovement
                or input.UserInputType ==
                Enum.UserInputType.Touch then

                setSliderFromX(
                    input.Position.X
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                Enum.UserInputType.Touch then

                sliderDragging = false
            end
        end)

        -- ====================================================
        -- BOTONES DE ESCALA
        -- ====================================================

        minus.MouseButton1Click:Connect(function()

            updateScale(
                currentScale - 0.05,
                true
            )
        end)

        plus.MouseButton1Click:Connect(function()

            updateScale(
                currentScale + 0.05,
                true
            )
        end)

        reset.MouseButton1Click:Connect(function()

            updateScale(
                DEFAULT_SCALE,
                true
            )
        end)

        -- ====================================================
        -- ABRIR CONFIGURACIÓN
        -- ====================================================

        settingsBtn.MouseButton1Click:Connect(function()

            settingsOpen = not settingsOpen

            settingsFrame.Visible = settingsOpen

            if settingsOpen then

                settingsBtn.BackgroundColor3 =
                    Color3.fromRGB(
                        0,
                        75,
                        115
                    )

                settingsBtn.TextColor3 =
                    Color3.fromRGB(
                        255,
                        255,
                        255
                    )

            else

                settingsBtn.BackgroundColor3 =
                    Color3.fromRGB(
                        18,
                        28,
                        40
                    )

                settingsBtn.TextColor3 =
                    Color3.fromRGB(
                        0,
                        190,
                        255
                    )
            end
        end)

        -- ====================================================
        -- MINIMIZAR
        -- ====================================================

        minimizeBtn.MouseButton1Click:Connect(function()

            minimized = not minimized

            settingsOpen = false
            settingsFrame.Visible = false

            if minimized then

                TweenService:Create(
                    mainFrame,
                    TweenInfo.new(
                        0.20,
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ),
                    {
                        Size = UDim2.new(
                            0,
                            DEFAULT_WIDTH,
                            0,
                            43
                        )
                    }
                ):Play()

                status.Visible = false
                kickBtn.Visible = false

                minimizeBtn.Text = "+"

            else

                TweenService:Create(
                    mainFrame,
                    TweenInfo.new(
                        0.20,
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ),
                    {
                        Size = UDim2.new(
                            0,
                            DEFAULT_WIDTH,
                            0,
                            DEFAULT_HEIGHT
                        )
                    }
                ):Play()

                task.delay(
                    0.08,
                    function()

                        if kickGui
                            and not minimized then

                            status.Visible = true
                            kickBtn.Visible = true
                        end
                    end
                )

                minimizeBtn.Text = "—"
            end
        end)

        -- ====================================================
        -- ARRASTRE REAL
        -- ====================================================
        -- El DragHandle es el único objeto responsable de
        -- iniciar el movimiento.
        -- ====================================================

        dragHandle.InputBegan:Connect(function(input)

            if sliderDragging then
                return
            end

            local validInput =
                input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch

            if not validInput then
                return
            end

            dragging = true

            dragStart = input.Position

            startPosition =
                mainFrame.Position

            activeDragInput = input
        end)

        -- ====================================================
        -- MOVIMIENTO DEL MOUSE
        -- ====================================================

        UserInputService.InputChanged:Connect(function(input)

            if not dragging then
                return
            end

            if input.UserInputType ==
                Enum.UserInputType.MouseMovement then

                local delta =
                    input.Position -
                    dragStart

                mainFrame.Position =
                    UDim2.new(
                        startPosition.X.Scale,
                        startPosition.X.Offset + delta.X,

                        startPosition.Y.Scale,
                        startPosition.Y.Offset + delta.Y
                    )
            end
        end)

        -- ====================================================
        -- MOVIMIENTO TÁCTIL
        -- ====================================================

        UserInputService.TouchMoved:Connect(function(
            touch,
            gameProcessed
        )

            if not dragging then
                return
            end

            if touch ~= activeDragInput then
                return
            end

            local delta =
                touch.Position -
                dragStart

            mainFrame.Position =
                UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset + delta.X,

                    startPosition.Y.Scale,
                    startPosition.Y.Offset + delta.Y
                )
        end)

        -- ====================================================
        -- FINALIZAR ARRASTRE
        -- ====================================================

        UserInputService.InputEnded:Connect(function(input)

            local isMouse =
                input.UserInputType ==
                Enum.UserInputType.MouseButton1

            local isTouch =
                input.UserInputType ==
                Enum.UserInputType.Touch

            if not isMouse and not isTouch then
                return
            end

            if isTouch
                and activeDragInput
                and input ~= activeDragInput then

                return
            end

            if dragging then

                dragging = false
                activeDragInput = nil

                saveConfig(
                    mainFrame.Position,
                    currentScale
                )
            end
        end)

        -- ====================================================
        -- ANIMACIÓN DEL BOTÓN KICK
        -- ====================================================

        kickBtn.MouseEnter:Connect(function()

            TweenService:Create(
                kickBtn,
                TweenInfo.new(
                    0.14,
                    Enum.EasingStyle.Quad,
                    Enum.EasingDirection.Out
                ),
                {
                    BackgroundColor3 =
                        Color3.fromRGB(
                            0,
                            150,
                            235
                        )
                }
            ):Play()

            TweenService:Create(
                kickStroke,
                TweenInfo.new(0.14),
                {
                    Transparency = 0
                }
            ):Play()
        end)

        kickBtn.MouseLeave:Connect(function()

            TweenService:Create(
                kickBtn,
                TweenInfo.new(
                    0.14,
                    Enum.EasingStyle.Quad,
                    Enum.EasingDirection.Out
                ),
                {
                    BackgroundColor3 =
                        Color3.fromRGB(
                            0,
                            125,
                            220
                        )
                }
            ):Play()

            TweenService:Create(
                kickStroke,
                TweenInfo.new(0.14),
                {
                    Transparency = 0.35
                }
            ):Play()
        end)

        -- ====================================================
        -- KICK INSTANTÁNEO
        -- ====================================================

        kickBtn.MouseButton1Click:Connect(function()

            -- Se ejecuta inmediatamente
            player:Kick(
                "Has sido kickeado por el negro jeter."
            )
        end)

        -- ====================================================
        -- ANIMACIÓN DE APERTURA
        -- ====================================================

        mainFrame.Size = UDim2.new(
            0,
            0,
            0,
            0
        )

        mainFrame.BackgroundTransparency = 1

        title.TextTransparency = 1
        subtitle.TextTransparency = 1
        status.TextTransparency = 1
        icon.TextTransparency = 1

        kickBtn.TextTransparency = 1
        kickBtn.BackgroundTransparency = 1

        shadow.ImageTransparency = 1
        frameStroke.Transparency = 1

        TweenService:Create(
            mainFrame,
            TweenInfo.new(
                0.35,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {
                Size = UDim2.new(
                    0,
                    DEFAULT_WIDTH,
                    0,
                    DEFAULT_HEIGHT
                ),

                BackgroundTransparency = 0.03
            }
        ):Play()

        task.delay(
            0.07,
            function()

                if not kickGui then
                    return
                end

                local fade =
                    TweenInfo.new(
                        0.20,
                        Enum.EasingStyle.Quad,
                        Enum.EasingDirection.Out
                    )

                TweenService:Create(
                    shadow,
                    fade,
                    {
                        ImageTransparency = 0.35
                    }
                ):Play()

                TweenService:Create(
                    frameStroke,
                    fade,
                    {
                        Transparency = 0.15
                    }
                ):Play()

                TweenService:Create(
                    icon,
                    fade,
                    {
                        TextTransparency = 0
                    }
                ):Play()

                TweenService:Create(
                    title,
                    fade,
                    {
                        TextTransparency = 0
                    }
                ):Play()

                TweenService:Create(
                    subtitle,
                    fade,
                    {
                        TextTransparency = 0
                    }
                ):Play()

                TweenService:Create(
                    status,
                    fade,
                    {
                        TextTransparency = 0
                    }
                ):Play()

                TweenService:Create(
                    kickBtn,
                    fade,
                    {
                        BackgroundTransparency = 0,
                        TextTransparency = 0
                    }
                ):Play()
            end
        )

        return gui
    end

    -- ========================================================
    -- ACTIVAR
    -- ========================================================

    local function enableKickButton()

        if kickButtonEnabled then
            return
        end

        kickButtonEnabled = true

        kickGui = createKickButton()
    end

    -- ========================================================
    -- DESACTIVAR
    -- ========================================================

    local function disableKickButton()

        if not kickButtonEnabled then
            return
        end

        kickButtonEnabled = false

        if kickGui then

            local oldGui = kickGui
            kickGui = nil

            local frame =
                oldGui:FindFirstChild("MainFrame")

            if frame then

                TweenService:Create(
                    frame,
                    TweenInfo.new(
                        0.17,
                        Enum.EasingStyle.Quad,
                        Enum.EasingDirection.In
                    ),
                    {
                        Size = UDim2.new(
                            0,
                            0,
                            0,
                            0
                        ),

                        BackgroundTransparency = 1
                    }
                ):Play()

                task.delay(
                    0.18,
                    function()

                        pcall(function()
                            oldGui:Destroy()
                        end)
                    end
                )

            else

                pcall(function()
                    oldGui:Destroy()
                end)
            end
        end

        -- Conservar posición y tamaño
        saveConfig(
            lastPosition,
            currentScale
        )
    end

    -- ========================================================
    -- TOGGLE
    -- ========================================================

    createToggle(
        "Kick Boton",
        function(state)

            if state then
                enableKickButton()
            else
                disableKickButton()
            end
        end
    )
end

-- ================= END =================



-- ================= ANTI BEE =================

local antiBeeEnabled = false
local antiBeeConnections = {}

local antiBeeData = {
	originalMoveFunction = nil,
	controlsProtected = false,
	badLightingNames = {
		Blue = true,
		DiscoEffect = true,
		BeeBlur = true,
		ColorCorrection = true
	}
}

local function destroyBeeEffect(obj)
	if not obj or not obj.Parent then
		return
	end

	if antiBeeData.badLightingNames[obj.Name] then
		pcall(function()
			obj:Destroy()
		end)
	end
end

local function disconnectAntiBee()
	for _, conn in ipairs(antiBeeConnections) do
		pcall(function()
			conn:Disconnect()
		end)
	end

	table.clear(antiBeeConnections)
end

local function protectControls()

	if antiBeeData.controlsProtected then
		return
	end

	pcall(function()

		local PlayerModule =
			player.PlayerScripts:FindFirstChild("PlayerModule")

		if not PlayerModule then
			return
		end

		local Controls =
			require(PlayerModule):GetControls()

		if not Controls then
			return
		end

		if not antiBeeData.originalMoveFunction then
			antiBeeData.originalMoveFunction =
				Controls.moveFunction
		end

		local function protectedMove(
			self,
			moveVector,
			relativeToCamera
		)

			if antiBeeData.originalMoveFunction then
				antiBeeData.originalMoveFunction(
					self,
					moveVector,
					relativeToCamera
				)
			end
		end

		Controls.moveFunction =
			protectedMove

		table.insert(
			antiBeeConnections,

			RunService.Heartbeat:Connect(
				function()

					if not antiBeeEnabled then
						return
					end

					if Controls.moveFunction
						~= protectedMove then

						Controls.moveFunction =
							protectedMove
					end
				end
			)
		)

		antiBeeData.controlsProtected =
			true
	end)
end

local function restoreControls()

	if not antiBeeData.controlsProtected then
		return
	end

	pcall(function()

		local PlayerModule =
			player.PlayerScripts:FindFirstChild(
				"PlayerModule"
			)

		if not PlayerModule then
			return
		end

		local Controls =
			require(PlayerModule):GetControls()

		if Controls
			and antiBeeData.originalMoveFunction then

			Controls.moveFunction =
				antiBeeData.originalMoveFunction
		end

		antiBeeData.controlsProtected =
			false
	end)
end

local function blockBuzzing()

	pcall(function()

		local beeScript =
			player.PlayerScripts:FindFirstChild(
				"Bee",
				true
			)

		if beeScript then

			local buzzing =
				beeScript:FindFirstChild(
					"Buzzing"
				)

			if buzzing
				and buzzing:IsA("Sound") then

				buzzing:Stop()
				buzzing.Volume = 0
			end
		end
	end)
end

local function lockFOV()

	local cam = Workspace.CurrentCamera

	if cam then
		cam.FieldOfView = 70
	end
end

local function enableAntiBee()

	if antiBeeEnabled then
		return
	end

	antiBeeEnabled = true

	for _, obj in ipairs(
		Lighting:GetDescendants()
	) do
		destroyBeeEffect(obj)
	end

	table.insert(
		antiBeeConnections,

		Lighting.DescendantAdded:Connect(
			function(obj)

				if antiBeeEnabled then
					destroyBeeEffect(obj)
				end
			end
		)
	)

	protectControls()

	table.insert(
		antiBeeConnections,

		RunService.Heartbeat:Connect(
			function()

				if not antiBeeEnabled then
					return
				end

				blockBuzzing()
				lockFOV()
			end
		)
	)
end

local function disableAntiBee()

	antiBeeEnabled = false

	restoreControls()

	disconnectAntiBee()
end

createToggle(
	"Anti Bee (Beta xD)",

	function(state)

		if state then
			enableAntiBee()
		else
			disableAntiBee()
		end
	end
)

-- ================= END =================
-- ================= ANTI TURRET =================

local sentryEnabled = false
local sentryConn

local function startSentryWatch()
    if sentryConn then
        sentryConn:Disconnect()
        sentryConn = nil
    end

    local lp = game.Players.LocalPlayer
    local Players = game:GetService("Players")

    sentryConn = workspace.DescendantAdded:Connect(function(desc)
        if not sentryEnabled then return end
        if not desc:IsA("Model") and not desc:IsA("BasePart") then return end
        if not string.find(desc.Name:lower(), "sentry") then return end

        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        local hrp = char.HumanoidRootPart

        -- ignorar tus propios sentries
        for _, playerObj in pairs(Players:GetPlayers()) do
            if playerObj == lp then continue end
            if playerObj.Character and desc:IsDescendantOf(playerObj.Character) then
                return
            end
        end

        task.wait(4.1)
        if not desc.Parent or not sentryEnabled then return end

        local backpack = lp:FindFirstChild("Backpack")
        local batTool = backpack and backpack:FindFirstChild("Bat") or char:FindFirstChild("Bat")

        -- buscar Bat en workspace si no tienes
        if not batTool then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Tool") and obj.Name == "Bat" then
                    obj.Parent = backpack
                    batTool = obj
                    break
                end
            end
        end

        if not batTool then return end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if batTool.Parent == backpack and humanoid then
            humanoid:EquipTool(batTool)
            task.wait(0.25)
        end

        -- colocar frente al jugador
        local offset = hrp.CFrame.LookVector * 3.5 + Vector3.new(0, 1.2, 0)

        if desc:IsA("Model") and desc.PrimaryPart then
            desc:SetPrimaryPartCFrame(hrp.CFrame + offset)
        elseif desc:IsA("BasePart") then
            desc.CFrame = hrp.CFrame + offset
        end

        -- atacar
        if batTool.Parent == char then
            batTool:Activate()
        end

        local hits = 0
        while sentryEnabled and desc.Parent and hits < 5 do
            task.wait(0.12)
            batTool:Activate()
            hits += 1
        end

        task.wait(0.1)

        if batTool.Parent == char then
            batTool.Parent = backpack
        end
    end)
end

local function stopSentryWatch()
    sentryEnabled = false

    if sentryConn then
        sentryConn:Disconnect()
        sentryConn = nil
    end
end

createToggle("Anti Torreta (Beta)", function(state)
    sentryEnabled = state

    if state then
        startSentryWatch()
    else
        stopSentryWatch()
    end
end)
-- ================= ANTI TURRETA (MAS AGRESIVO) =================

local sentryAggressiveEnabled = false
local sentryAggressiveConn
local processingTurrets = {}

local function isTurret(desc)

    local target = desc

    for _ = 1,5 do

        if not target then
            break
        end

        local n = target.Name:lower()

        if string.find(n,"sentry")
        or string.find(n,"turret")
        or string.find(n,"torreta") then

            return target
        end

        target = target.Parent
    end

    return nil
end

local function destroySentry(desc)

    if processingTurrets[desc] then
        return
    end

    processingTurrets[desc] = true

    local lp = game.Players.LocalPlayer
    local char = lp.Character

    if not char then
        processingTurrets[desc] = nil
        return
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if not hrp or not humanoid then
        processingTurrets[desc] = nil
        return
    end

    -- tiempo real de activacion
    task.wait(4.1)

    if not sentryAggressiveEnabled
    or not desc
    or not desc.Parent then

        processingTurrets[desc] = nil
        return
    end

    local backpack = lp:FindFirstChild("Backpack")

    local batTool =
        (backpack and backpack:FindFirstChild("Bat"))
        or char:FindFirstChild("Bat")

    if not batTool then
        processingTurrets[desc] = nil
        return
    end

    if batTool.Parent ~= char then
        humanoid:EquipTool(batTool)
        task.wait(0.12)
    end

    local function moveTarget()

        if not desc or not desc.Parent then
            return false
        end

        -- mover a un lado para no bloquearte
        local offset =
            hrp.CFrame.RightVector * 4
            + Vector3.new(0,1.5,0)

        pcall(function()

            if desc:IsA("Model") then

                local part =
                    desc.PrimaryPart
                    or desc:FindFirstChildWhichIsA("BasePart")

                if part then
                    desc:PivotTo(
                        CFrame.new(hrp.Position + offset)
                    )
                end

            elseif desc:IsA("BasePart") then

                desc.CFrame =
                    CFrame.new(hrp.Position + offset)

            end
        end)

        return true
    end

    local attempts = 0

    while sentryAggressiveEnabled
    and desc
    and desc.Parent
    and attempts < 150 do

        local ok = moveTarget()

        if not ok then
            break
        end

        batTool:Activate()

        task.wait(0.12)

        if not desc.Parent then
            break
        end

        attempts += 1
    end

    if batTool.Parent == char then
        batTool.Parent = backpack
    end

    processingTurrets[desc] = nil
end

local function startAggressiveWatch()

    if sentryAggressiveConn then
        sentryAggressiveConn:Disconnect()
        sentryAggressiveConn = nil
    end

    sentryAggressiveConn =
    workspace.DescendantAdded:Connect(function(desc)

        if not sentryAggressiveEnabled then
            return
        end

        local turret = isTurret(desc)

        if not turret then
            return
        end

        task.spawn(function()
            destroySentry(turret)
        end)
    end)
end

local function stopAggressiveWatch()

    sentryAggressiveEnabled = false
    processingTurrets = {}

    if sentryAggressiveConn then
        sentryAggressiveConn:Disconnect()
        sentryAggressiveConn = nil
    end
end

createToggle("Anti Torreta (Mas agresivo)", function(state)

    sentryAggressiveEnabled = state

    if state then
        startAggressiveWatch()
    else
        stopAggressiveWatch()
    end
end)
-- ============================================================
-- MULTIPLE EMPTY BASES ESP (Rojo, Texto "Empty Base" a distancia)
-- ============================================================
do
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local emptyESPEnabled = false
local emptyESPBillboards = {}
local emptyESPConnection = nil

-- Función para detectar si el texto indica base vacía (Múltiples idiomas y variantes)
local function isEmptyBase(text)
    if not text then return false end
    local lowerText = text:lower()
    
    local keywords = {
        "empty", 
        "vacía", 
        "vacia", 
        "unclaimed", 
        "libre", 
        "free", 
        "vacante", 
        "available"
    }
    
    for _, word in ipairs(keywords) do
        if lowerText:find(word, 1, true) then
            return true
        end
    end
    return false
end

-- Limpiar todos los ESP de bases vacías activos
local function clearEmptyESP()
    for plot, billboard in pairs(emptyESPBillboards) do
        pcall(function()
            if billboard then billboard:Destroy() end
        end)
    end
    table.clear(emptyESPBillboards)
end

-- Actualizar y crear los BillboardGuis en todas las bases vacías detectadas
local function updateEmptyESP()
    if not emptyESPEnabled then return end
    
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    local currentActivePlots = {}

    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local surfaceGui = sign:FindFirstChildWhichIsA("SurfaceGui", true)
            local label = surfaceGui and surfaceGui:FindFirstChildWhichIsA("TextLabel", true)
            
            if label and isEmptyBase(label.Text) then
                currentActivePlots[plot] = true
                
                -- Si no tiene un ESP creado, se lo creamos en rojo
                if not emptyESPBillboards[plot] or not emptyESPBillboards[plot].Parent then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "EmptyBaseESP_GUI"
                    billboard.Adornee = sign
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.MaxDistance = math.huge
                    
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = "Empty Base"
                    textLabel.TextColor3 = Color3.fromRGB(255, 60, 60) -- Rojo brillante
                    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    textLabel.TextStrokeTransparency = 0
                    textLabel.Font = Enum.Font.GothamBold
                    textLabel.TextSize = 16
                    textLabel.Parent = billboard
                    
                    billboard.Parent = sign
                    emptyESPBillboards[plot] = billboard
                end
            end
        end
    end

    -- Remover ESP de bases que ya fueron reclamadas o eliminadas
    for plot, billboard in pairs(emptyESPBillboards) do
        if not currentActivePlots[plot] or not plot.Parent then
            pcall(function() billboard:Destroy() end)
            emptyESPBillboards[plot] = nil
        end
    end
end

-- Activar el sistema
local function startEmptyESP()
    emptyESPEnabled = true
    if emptyESPConnection then
        emptyESPConnection:Disconnect()
    end
    
    local counter = 0
    emptyESPConnection = RunService.Heartbeat:Connect(function()
        if not emptyESPEnabled then return end
        counter = counter + 1
        if counter >= 30 then -- Optimizado para ejecutarse cada ~0.5 segundos
            counter = 0
            pcall(updateEmptyESP)
        end
    end)
    
    pcall(updateEmptyESP)
end

-- Desactivar el sistema
local function stopEmptyESP()
    emptyESPEnabled = false
    if emptyESPConnection then
        emptyESPConnection:Disconnect()
        emptyESPConnection = nil
    end
    clearEmptyESP()
end

-- Integración con el Toggle del Hub
if type(createToggle) == "function" then
    createToggle("Empty Bases ESP", function(state)
        if state then
            startEmptyESP()
        else
            stopEmptyESP()
        end
    end)
end

end


-- ============================================================
-- ULTIMATE STABLE HUB MODULE (Icono Arriba, Nombre Abajo)
-- ============================================================
task.spawn(function()
    local success, err = pcall(function()
        local Players = game:GetService("Players")
        
        -- Obtener LocalPlayer de forma segura sin bloquear
        local LocalPlayer = Players.LocalPlayer
        local startTime = tick()
        while not LocalPlayer and (tick() - startTime) < 5 do
            task.wait(0.1)
            LocalPlayer = Players.LocalPlayer
        end
        if not LocalPlayer then return end

        -- Sistema seguro para registrar toggles
        local function registerToggle(name, callback)
            task.spawn(function()
                local timeout = 0
                while type(createToggle) ~= "function" and timeout < 50 do
                    task.wait(0.1)
                    timeout = timeout + 1
                end
                if type(createToggle) == "function" then
                    pcall(function()
                        createToggle(name, callback)
                    end)
                end
            end)
        end

        -- ==========================================
        -- 1. ITEMS ESP (Icono Arriba - Offset 4.4)
        -- ==========================================
        local itemsESPEnabled = false
        local playerBillboards = {}
        local itemESPLoopRunning = false

        local function getToolIcon(p)
            if not p or not p.Character then return "" end
            for _, o in ipairs(p.Character:GetChildren()) do
                if o and o:IsA("Tool") then
                    if o.TextureId and o.TextureId ~= "" then
                        return o.TextureId
                    else
                        local handle = o:FindFirstChild("Handle")
                        if handle then
                            if handle:IsA("MeshPart") and handle.TextureID and handle.TextureID ~= "" then
                                return handle.TextureID
                            else
                                for _, child in ipairs(handle:GetChildren()) do
                                    if child and (child:IsA("Texture") or child:IsA("Decal")) and child.Texture and child.Texture ~= "" then
                                        return child.Texture
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return ""
        end

        local function clearItemsESP()
            for _, entry in pairs(playerBillboards) do
                if entry and entry.bb then
                    pcall(function() entry.bb:Destroy() end)
                end
            end
            table.clear(playerBillboards)
        end

        local function createOrRefreshItemsESP(plr)
            if not plr or plr == LocalPlayer then return end
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if not hrp then
                if playerBillboards[plr.UserId] then
                    pcall(function() playerBillboards[plr.UserId].bb:Destroy() end)
                    playerBillboards[plr.UserId] = nil
                end
                return
            end

            local entry = playerBillboards[plr.UserId]

            if not entry or not entry.bb or not entry.bb.Parent then
                local bb = Instance.new("BillboardGui")
                bb.Name = "ItemsESP_" .. tostring(plr.UserId)
                bb.Size = UDim2.new(0, 26, 0, 26)
                bb.Adornee = hrp
                bb.StudsOffset = Vector3.new(0, 7.5, 0) -- Icono ubicado arriba del nombre
                bb.AlwaysOnTop = true
                bb.LightInfluence = 0
                bb.ResetOnSpawn = false

                local iconImg = Instance.new("ImageLabel")
                iconImg.Name = "IconLabel"
                iconImg.Size = UDim2.new(1, 0, 1, 0)
                iconImg.BackgroundTransparency = 1
                iconImg.Image = ""
                iconImg.Visible = false
                iconImg.Parent = bb

                bb.Parent = hrp

                playerBillboards[plr.UserId] = {
                    bb = bb,
                    iconImg = iconImg,
                    player = plr
                }
            else
                entry.player = plr
            end
        end

        local function enableItemsESP()
            if itemsESPEnabled then return end
            itemsESPEnabled = true

            if itemESPLoopRunning then return end
            itemESPLoopRunning = true

            task.spawn(function()
                while itemsESPEnabled do
                    task.wait(0.4)

                    pcall(function()
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer then
                                createOrRefreshItemsESP(plr)
                            end
                        end

                        for _, entry in pairs(playerBillboards) do
                            if entry and entry.bb and entry.bb.Parent and entry.player then
                                local icon = getToolIcon(entry.player)
                                if icon ~= "" then
                                    entry.iconImg.Image = icon
                                    entry.iconImg.Visible = true
                                else
                                    entry.iconImg.Visible = false
                                end
                            end
                        end
                    end)
                end

                clearItemsESP()
                itemESPLoopRunning = false
            end)
        end

        local function disableItemsESP()
            itemsESPEnabled = false
            clearItemsESP()
        end

        Players.PlayerRemoving:Connect(function(plr)
            if playerBillboards[plr.UserId] then
                pcall(function() playerBillboards[plr.UserId].bb:Destroy() end)
                playerBillboards[plr.UserId] = nil
            end
        end)

        registerToggle("Items Esp", function(state)
            if state then
                enableItemsESP()
            else
                disableItemsESP()
            end
        end)



-- ============================================================
        -- ==========================================
        -- 2. PLAYER ESP (Nombre Abajo - Offset 2.8)
        -- ==========================================
        local playerESPEnabled = false
        local playerHighlights = {}
        local playerNameLabels = {}
        local characterConnections = {}
        local playerAddedConnection = nil

        -- Variable global para saber a quién targetea el ESP específico
        _G.SpecificESP_SelectedPlayer = nil 

        local function addGradient(obj)
            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
            gradient.Parent = obj
        end

        local function clearPlayerESP()
            for _, highlight in pairs(playerHighlights) do
                pcall(function() highlight:Destroy() end)
            end
            playerHighlights = {}

            for _, label in pairs(playerNameLabels) do
                pcall(function() label:Destroy() end)
            end
            playerNameLabels = {}
        end

        local function removePlayerESP(otherPlayer)
            if playerHighlights[otherPlayer] then
                pcall(function() playerHighlights[otherPlayer]:Destroy() end)
                playerHighlights[otherPlayer] = nil
            end

            if playerNameLabels[otherPlayer] then
                pcall(function() playerNameLabels[otherPlayer]:Destroy() end)
                playerNameLabels[otherPlayer] = nil
            end
        end

        local function addESPToPlayer(otherPlayer)
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            if not playerESPEnabled or otherPlayer == LocalPlayer then return end
            
            -- EVITAR DUPLICACIÓN: Si tiene el ESP rojo específico, cancelamos este
            if _G.SpecificESP_SelectedPlayer == otherPlayer then return end

            local character = otherPlayer.Character
            if not character then return end

            removePlayerESP(otherPlayer)

            local highlight = Instance.new("Highlight")
            highlight.Name = "PlayerESP"
            highlight.Adornee = character
            highlight.FillColor = Color3.fromRGB(140, 100, 200)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = character

            playerHighlights[otherPlayer] = highlight

            local hrp = character:WaitForChild("HumanoidRootPart", 5)

            if hrp then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "PlayerESPLabel"
                billboard.Adornee = hrp
                billboard.Size = UDim2.new(0, 200, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 2.8, 0)
                billboard.AlwaysOnTop = true
                billboard.MaxDistance = math.huge
                billboard.Parent = hrp

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = otherPlayer.DisplayName
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.GothamBold
                label.TextSize = 15
                label.Parent = billboard

                addGradient(label)

                playerNameLabels[otherPlayer] = billboard
            end
        end

        -- Funciones globales para que el ESP Específico las pueda llamar
        _G.RemoveGeneralESP = removePlayerESP
        _G.AddGeneralESP = addESPToPlayer
        _G.IsGeneralESPEnabled = function() return playerESPEnabled end

        local function setupPlayer(plr)
            local LocalPlayer = game:GetService("Players").LocalPlayer
            if plr == LocalPlayer then return end

            if characterConnections[plr] then
                characterConnections[plr]:Disconnect()
            end

            characterConnections[plr] = plr.CharacterAdded:Connect(function(character)
                task.wait(1)
                if playerESPEnabled and character then
                    addESPToPlayer(plr)
                end
            end)

            plr.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    removePlayerESP(plr)
                    if characterConnections[plr] then
                        characterConnections[plr]:Disconnect()
                        characterConnections[plr] = nil
                    end
                end
            end)

            if plr.Character and playerESPEnabled then
                task.spawn(function()
                    addESPToPlayer(plr)
                end)
            end
        end

        local function startPlayerESP()
            local Players = game:GetService("Players")
            playerESPEnabled = true

            for _, plr in ipairs(Players:GetPlayers()) do
                setupPlayer(plr)
            end

            if not playerAddedConnection then
                playerAddedConnection = Players.PlayerAdded:Connect(function(plr)
                    setupPlayer(plr)
                end)
            end
        end

        local function stopPlayerESP()
            playerESPEnabled = false
            clearPlayerESP()

            for _, conn in pairs(characterConnections) do
                if conn then conn:Disconnect() end
            end
            characterConnections = {}

            if playerAddedConnection then
                playerAddedConnection:Disconnect()
                playerAddedConnection = nil
            end
        end

        registerToggle("Player ESP", function(state)
            if state then
                startPlayerESP()
            else
                stopPlayerESP()
            end
        end)

    end)

    if not success then
        warn("Hub Critical Error: " .. tostring(err))
    end
end)
-- ============================================================
-- PLAYER ESP ESPECIFICO (BULLETPROOF / INTERFAZ COMPACTA / ANTI-OPTIMIZACIÓN)
-- ============================================================
task.spawn(function()
    local success, err = pcall(function()
        
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local TweenService = game:GetService("TweenService")
        local UserInputService = game:GetService("UserInputService")
        local HttpService = game:GetService("HttpService")
        local LocalPlayer = Players.LocalPlayer

        -- ================== SISTEMA DE GUARDADO DE CONFIGURACIÓN ==================
        local configFileName = "TokitoSpecificESP_Config.json"
        local defaultMainPos = UDim2.new(0.5, -95, 0.5, -125)
        local defaultMiniPos = UDim2.new(0.5, -20, 0.5, -20)

        local savedMainPosition = defaultMainPos
        local savedMiniPosition = defaultMiniPos
        local savedMinimizedState = false
        local isFirstLoad = true

        local function loadConfig()
            pcall(function()
                if readfile and isfile and isfile(configFileName) then
                    local data = HttpService:JSONDecode(readfile(configFileName))
                    if data and data.mainX and data.mainY and data.miniX and data.miniY then
                        -- Validación de seguridad: si las coordenadas están en la esquina (0,0) o muy cerca, se restablecen al centro
                        if data.mainX > 50 and data.mainY > 50 then
                            savedMainPosition = UDim2.new(0, data.mainX, 0, data.mainY)
                        else
                            savedMainPosition = defaultMainPos
                        end
                        
                        if data.miniX and data.miniY and data.miniX > 20 and data.miniY > 20 then
                            savedMiniPosition = UDim2.new(0, data.miniX, 0, data.miniY)
                        else
                            savedMiniPosition = defaultMiniPos
                        end
                        
                        savedMinimizedState = false
                    end
                end
            end)
        end

        local function saveConfig(mainPos, miniPos, isMiniState)
            pcall(function()
                if writefile then
                    local data = {
                        mainX = mainPos.X.Offset,
                        mainY = mainPos.Y.Offset,
                        miniX = miniPos.X.Offset,
                        miniY = miniPos.Y.Offset,
                        minimized = isMiniState
                    }
                    writefile(configFileName, HttpService:JSONEncode(data))
                end
            end)
        end

        loadConfig()

        -- ================== OBTENCIÓN SEGURA DE GUI ==================
        local function getSafeGuiParent()
            local ok, gui = pcall(function() return gethui() end)
            if ok and gui then return gui end
            
            ok, gui = pcall(function() return game:GetService("CoreGui") end)
            if ok and gui then return gui end
            
            return LocalPlayer:WaitForChild("PlayerGui", 5)
        end
        local targetGuiParent = getSafeGuiParent()
        if not targetGuiParent then return end 

        local specificESPEnabled = false
        local selectedPlayer = nil

        local ESP_Gui, MainFrame, MiniButton, TracerLine
        local PlayerListScroll
        local renderConnection
        local playerAddedConn, playerRemovingConn
        local currentHighlight, currentBillboard

        local function safeTween(object, properties, duration)
            pcall(function()
                local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                TweenService:Create(object, tweenInfo, properties):Play()
            end)
        end

        local function makeDraggable(topbar, object, isMini)
            local dragging, dragInput, dragStart, startPos
            
            pcall(function()
                topbar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        dragStart = input.Position
                        startPos = object.Position
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                                if isMini then 
                                    savedMiniPosition = object.Position 
                                else 
                                    savedMainPosition = object.Position 
                                end
                                saveConfig(savedMainPosition, savedMiniPosition, not MainFrame.Visible)
                            end
                        end)
                    end
                end)
                topbar.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        dragInput = input
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if input == dragInput and dragging then
                        local delta = input.Position - dragStart
                        object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    end
                end)
            end)
        end

        local function clearTargetESP()
            pcall(function()
                if currentHighlight then currentHighlight:Destroy() currentHighlight = nil end
                if currentBillboard then currentBillboard:Destroy() currentBillboard = nil end
                if TracerLine then TracerLine.Visible = false end
            end)
        end

        local function applyTargetESP(target)
            clearTargetESP()
            if not target or not target.Character then return end
            
            pcall(function()
                local char = target.Character

                currentHighlight = Instance.new("Highlight")
                currentHighlight.Name = "SpecificTargetESP"
                currentHighlight.Adornee = char
                currentHighlight.FillColor = Color3.fromRGB(255, 0, 0)
                currentHighlight.OutlineColor = Color3.fromRGB(255, 100, 100)
                currentHighlight.FillTransparency = 0.5
                currentHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                currentHighlight.Parent = char

                -- CAMBIO APLICADO: Head como prioridad sobre HumanoidRootPart
                local hrp = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    currentBillboard = Instance.new("BillboardGui")
                    currentBillboard.Size = UDim2.new(0, 200, 0, 50)
                    currentBillboard.StudsOffset = Vector3.new(0, 3, 0)
                    currentBillboard.AlwaysOnTop = true
                    currentBillboard.Parent = hrp

                    local txt = Instance.new("TextLabel")
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = target.DisplayName
                    txt.TextColor3 = Color3.fromRGB(255, 0, 0)
                    txt.TextStrokeTransparency = 0
                    txt.Font = Enum.Font.GothamBlack
                    txt.TextSize = 16
                    txt.Parent = currentBillboard
                end
            end)
        end

        local function createUI()
            pcall(function()
                if targetGuiParent:FindFirstChild("Tokito_SpecificESP") then
                    targetGuiParent.Tokito_SpecificESP:Destroy()
                end

                if not isFirstLoad then
                    savedMainPosition = defaultMainPos
                    savedMiniPosition = defaultMiniPos
                    savedMinimizedState = false
                end
                isFirstLoad = false

                ESP_Gui = Instance.new("ScreenGui")
                ESP_Gui.Name = "Tokito_SpecificESP"
                ESP_Gui.ResetOnSpawn = false
                ESP_Gui.Parent = targetGuiParent

                -- TRACER ANTI-OPTIMIZACIÓN
                TracerLine = Instance.new("Frame")
                TracerLine.Name = "ImmuneTracerLine"
                TracerLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                TracerLine.BorderSizePixel = 0
                TracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
                TracerLine.ZIndex = 99999
                TracerLine.Visible = false
                TracerLine.Parent = ESP_Gui

                local uiGradientLine = Instance.new("UIGradient")
                uiGradientLine.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
                })
                uiGradientLine.Parent = TracerLine

                MiniButton = Instance.new("TextButton")
                MiniButton.Size = UDim2.new(0, 40, 0, 40)
                MiniButton.Position = savedMiniPosition
                MiniButton.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
                MiniButton.Text = "Pl"
                MiniButton.TextColor3 = Color3.fromRGB(0, 170, 255)
                MiniButton.Font = Enum.Font.GothamBold
                MiniButton.TextSize = 18
                MiniButton.Visible = savedMinimizedState
                MiniButton.ClipsDescendants = true
                MiniButton.AutoButtonColor = false
                MiniButton.Parent = ESP_Gui

                Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(1, 0)
                local miniStroke = Instance.new("UIStroke")
                miniStroke.Color = Color3.fromRGB(0, 170, 255)
                miniStroke.Thickness = 2
                miniStroke.Parent = MiniButton
                makeDraggable(MiniButton, MiniButton, true)

                -- INTERFAZ PRINCIPAL
                MainFrame = Instance.new("Frame")
                MainFrame.Size = UDim2.new(0, 190, 0, 230)
                MainFrame.Position = savedMainPosition
                MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
                MainFrame.Visible = not savedMinimizedState
                MainFrame.ClipsDescendants = true
                MainFrame.Parent = ESP_Gui

                Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
                local mainStroke = Instance.new("UIStroke")
                mainStroke.Color = Color3.fromRGB(0, 170, 255)
                mainStroke.Thickness = 2
                mainStroke.Parent = MainFrame

                local Topbar = Instance.new("Frame")
                Topbar.Size = UDim2.new(1, 0, 0, 30)
                Topbar.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
                Topbar.BorderSizePixel = 0
                Topbar.Parent = MainFrame
                makeDraggable(Topbar, MainFrame, false)

                Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 8)
                local topFix = Instance.new("Frame")
                topFix.Size = UDim2.new(1, 0, 0, 5)
                topFix.Position = UDim2.new(0, 0, 1, -5)
                topFix.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
                topFix.BorderSizePixel = 0
                topFix.Parent = Topbar

                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(1, -35, 1, 0)
                Title.Position = UDim2.new(0, 8, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = "ESP Específico"
                Title.TextColor3 = Color3.fromRGB(0, 170, 255)
                Title.Font = Enum.Font.GothamBold
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Parent = Topbar

                local MinBtn = Instance.new("TextButton")
                MinBtn.Size = UDim2.new(0, 22, 0, 22)
                MinBtn.Position = UDim2.new(1, -26, 0.5, -11)
                MinBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
                MinBtn.Text = "-"
                MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                MinBtn.Font = Enum.Font.GothamBold
                MinBtn.TextSize = 16
                MinBtn.AutoButtonColor = false
                MinBtn.Parent = Topbar
                Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

                PlayerListScroll = Instance.new("ScrollingFrame")
                PlayerListScroll.Size = UDim2.new(1, -16, 1, -40)
                PlayerListScroll.Position = UDim2.new(0, 8, 0, 34)
                PlayerListScroll.BackgroundTransparency = 1
                PlayerListScroll.ScrollBarThickness = 3
                PlayerListScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
                PlayerListScroll.Parent = MainFrame

                local UIListLayout = Instance.new("UIListLayout")
                UIListLayout.Padding = UDim.new(0, 4)
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Parent = PlayerListScroll

                MinBtn.MouseButton1Click:Connect(function()
                    saveConfig(savedMainPosition, savedMiniPosition, true)
                    safeTween(MainFrame, {Size = UDim2.new(0, 190, 0, 0)}, 0.3)
                    task.delay(0.3, function()
                        MainFrame.Visible = false
                        MiniButton.Visible = true
                        MiniButton.Size = UDim2.new(0, 40, 0, 40)
                    end)
                end)

                MiniButton.MouseButton1Click:Connect(function()
                    saveConfig(savedMainPosition, savedMiniPosition, false)
                    MiniButton.Visible = false
                    MainFrame.Visible = true
                    MainFrame.Size = UDim2.new(0, 190, 0, 230)
                end)
            end)
        end

        local function updatePlayerList()
            if not PlayerListScroll then return end
            
            pcall(function()
                for _, child in pairs(PlayerListScroll:GetChildren()) do
                    if child:IsA("Frame") then child:Destroy() end
                end

                for _, plr in pairs(Players:GetPlayers()) do
                    if plr == LocalPlayer then continue end

                    local PlayerRow = Instance.new("Frame")
                    PlayerRow.Size = UDim2.new(1, -4, 0, 34)
                    PlayerRow.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
                    PlayerRow.Parent = PlayerListScroll
                    Instance.new("UICorner", PlayerRow).CornerRadius = UDim.new(0, 5)

                    local UIStrokeRow = Instance.new("UIStroke")
                    UIStrokeRow.Color = Color3.fromRGB(0, 170, 255)
                    UIStrokeRow.Transparency = (selectedPlayer == plr) and 0 or 1
                    UIStrokeRow.Parent = PlayerRow

                    local HeadIcon = Instance.new("ImageLabel")
                    HeadIcon.Size = UDim2.new(0, 24, 0, 24)
                    HeadIcon.Position = UDim2.new(0, 4, 0.5, -12)
                    HeadIcon.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
                    HeadIcon.Parent = PlayerRow
                    Instance.new("UICorner", HeadIcon).CornerRadius = UDim.new(1, 0)
                    
                    task.spawn(function()
                        local ok, content, isReady = pcall(function()
                            return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                        end)
                        if ok and isReady and HeadIcon and HeadIcon.Parent then 
                            HeadIcon.Image = content 
                        end
                    end)

                    local NameLabel = Instance.new("TextLabel")
                    NameLabel.Size = UDim2.new(1, -32, 1, 0)
                    NameLabel.Position = UDim2.new(0, 32, 0, 0)
                    NameLabel.BackgroundTransparency = 1
                    NameLabel.Text = plr.DisplayName
                    NameLabel.TextColor3 = (selectedPlayer == plr) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
                    NameLabel.Font = Enum.Font.GothamSemibold
                    NameLabel.TextSize = 12
                    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                    NameLabel.Parent = PlayerRow

                    local SelectBtn = Instance.new("TextButton")
                    SelectBtn.Size = UDim2.new(1, 0, 1, 0)
                    SelectBtn.BackgroundTransparency = 1
                    SelectBtn.Text = ""
                    SelectBtn.Parent = PlayerRow

                    SelectBtn.MouseEnter:Connect(function()
                        if selectedPlayer ~= plr then safeTween(PlayerRow, {BackgroundColor3 = Color3.fromRGB(35, 40, 55)}, 0.2) end
                    end)
                    SelectBtn.MouseLeave:Connect(function()
                        if selectedPlayer ~= plr then safeTween(PlayerRow, {BackgroundColor3 = Color3.fromRGB(25, 30, 40)}, 0.2) end
                    end)

                    SelectBtn.MouseButton1Click:Connect(function()
                        if selectedPlayer == plr then
                            local oldPlayer = selectedPlayer
                            selectedPlayer = nil
                            _G.SpecificESP_SelectedPlayer = nil
                            clearTargetESP()
                            
                            if oldPlayer and _G.IsGeneralESPEnabled and _G.IsGeneralESPEnabled() then
                                if _G.AddGeneralESP then _G.AddGeneralESP(oldPlayer) end
                            end
                        else
                            local oldPlayer = selectedPlayer
                            selectedPlayer = plr
                            _G.SpecificESP_SelectedPlayer = plr
                            
                            if oldPlayer and _G.IsGeneralESPEnabled and _G.IsGeneralESPEnabled() then
                                if _G.AddGeneralESP then _G.AddGeneralESP(oldPlayer) end
                            end
                            
                            if _G.RemoveGeneralESP then _G.RemoveGeneralESP(plr) end
                            
                            applyTargetESP(plr)
                        end
                        updatePlayerList() 
                    end)
                end
            end)
        end

local function handleTracer()
    pcall(function()
        local Camera = workspace.CurrentCamera

        if specificESPEnabled and selectedPlayer and selectedPlayer.Character and Camera then

            if not TracerLine or not TracerLine.Parent then
                if ESP_Gui then
                    TracerLine = Instance.new("Frame")
                    TracerLine.Name = "ImmuneTracerLine"
                    TracerLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    TracerLine.BorderSizePixel = 0
                    TracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
                    TracerLine.ZIndex = 99999
                    TracerLine.Parent = ESP_Gui

                    local uiGradientLine = Instance.new("UIGradient")
                    uiGradientLine.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
                    })
                    uiGradientLine.Parent = TracerLine
                end
            end

            local char = selectedPlayer.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")

            if not hrp then
                if TracerLine then TracerLine.Visible = false end
                return
            end

            local pos = hrp.Position
            local headPos = head and head.Position or (pos + Vector3.new(0, 2, 0))

            local topV3 = headPos + Vector3.new(0, 0.6, 0)
            local bottomV3 = pos - Vector3.new(0, 2.8, 0)

            local top2D, topOnScreen = Camera:WorldToViewportPoint(topV3)
            local bottom2D, bottomOnScreen = Camera:WorldToViewportPoint(bottomV3)

            local center2D, centerOnScreen = Camera:WorldToViewportPoint(pos + Vector3.new(0, 0.5, 0))

            if topOnScreen and bottomOnScreen and centerOnScreen and center2D.Z > 0 then
                if not currentHighlight or not currentHighlight.Parent then
                    applyTargetESP(selectedPlayer)
                end

                local origin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - 25)
                local center = Vector2.new(center2D.X, center2D.Y)

                local dir = center - origin
                if dir.Magnitude < 1 then
                    if TracerLine then TracerLine.Visible = false end
                    return
                end

                local bodyScreenHeight = math.abs(top2D.Y - bottom2D.Y)

                -- Esto hace que la línea atraviese todo el personaje
                local extraPixels = math.max(bodyScreenHeight * 0.9, 24)

                dir = dir.Unit
                local endPos = center + (dir * extraPixels)

                local length = (endPos - origin).Magnitude
                local lineCenter = (origin + endPos) / 2
                local angle = math.deg(math.atan2(endPos.Y - origin.Y, endPos.X - origin.X))

                if TracerLine then
                    TracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
                    TracerLine.Size = UDim2.new(0, length, 0, 3)
                    TracerLine.Position = UDim2.new(0, lineCenter.X, 0, lineCenter.Y)
                    TracerLine.Rotation = angle
                    TracerLine.Visible = true
                end
            else
                if TracerLine then TracerLine.Visible = false end
            end
        else
            if TracerLine then TracerLine.Visible = false end
        end
    end)
end

        local function startSpecificESP()
            specificESPEnabled = true
            createUI()
            updatePlayerList()

            playerAddedConn = Players.PlayerAdded:Connect(function() task.wait(1) updatePlayerList() end)
            playerRemovingConn = Players.PlayerRemoving:Connect(function(plr)
                if selectedPlayer == plr then
                    selectedPlayer = nil
                    _G.SpecificESP_SelectedPlayer = nil
                    clearTargetESP()
                end
                updatePlayerList()
            end)

            renderConnection = RunService.RenderStepped:Connect(handleTracer)
        end

        local function stopSpecificESP()
            specificESPEnabled = false
            
            local oldPlayer = selectedPlayer
            selectedPlayer = nil
            _G.SpecificESP_SelectedPlayer = nil
            clearTargetESP()

            if oldPlayer and _G.IsGeneralESPEnabled and _G.IsGeneralESPEnabled() then
                if _G.AddGeneralESP then _G.AddGeneralESP(oldPlayer) end
            end

            pcall(function()
                if renderConnection then renderConnection:Disconnect() renderConnection = nil end
                if playerAddedConn then playerAddedConn:Disconnect() playerAddedConn = nil end
                if playerRemovingConn then playerRemovingConn:Disconnect() playerRemovingConn = nil end
                if ESP_Gui then ESP_Gui:Destroy() ESP_Gui = nil end
            end)
        end

        task.spawn(function()
            local timeout = 0
            while type(createToggle) ~= "function" and timeout < 100 do
                task.wait(0.1)
                timeout = timeout + 1
            end

            if type(createToggle) == "function" then
                pcall(function()
                    createToggle("Player ESP Especifico", function(state)
                        if state then
                            startSpecificESP()
                        else
                            stopSpecificESP()
                        end
                    end)
                end)
            end
        end)

    end)

    if not success then
        warn("El Player ESP Especifico ha fallado silenciosamente sin romper el menú:", tostring(err))
    end
end)





-- ================= XRAY =================

local xrayEnabled = false
local xrayConnection = nil
local originalDecorationsTransparency = {}

local XRayTransparency = 1 -- 1 = invisible total

local function startXRay()
	if xrayConnection then
		xrayConnection:Disconnect()
		xrayConnection = nil
	end

	local plots = workspace:FindFirstChild("Plots")

	if plots then
		for _, plot in ipairs(plots:GetChildren()) do
			local decorations = plot:FindFirstChild("Decorations")

			if plot:IsA("Model") and decorations then
				for _, part in ipairs(decorations:GetDescendants()) do
					if part:IsA("BasePart") then
						if originalDecorationsTransparency[part] == nil then
							originalDecorationsTransparency[part] = part.Transparency
						end

						part.Transparency = XRayTransparency
						part.CastShadow = false
					end
				end
			end
		end
	end

	xrayConnection = RunService.Heartbeat:Connect(function()
		if not xrayEnabled then
			return
		end

		local plots = workspace:FindFirstChild("Plots")
		if not plots then
			return
		end

		for _, plot in ipairs(plots:GetChildren()) do
			local decorations = plot:FindFirstChild("Decorations")

			if plot:IsA("Model") and decorations then
				for _, part in ipairs(decorations:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Transparency = XRayTransparency
						part.CastShadow = false
					end
				end
			end
		end
	end)

	xrayEnabled = true
end

local function stopXRay()
	if xrayConnection then
		xrayConnection:Disconnect()
		xrayConnection = nil
	end

	local plots = workspace:FindFirstChild("Plots")

	if plots then
		for _, plot in ipairs(plots:GetChildren()) do
			local decorations = plot:FindFirstChild("Decorations")

			if plot:IsA("Model") and decorations then
				for _, part in ipairs(decorations:GetDescendants()) do
					if part:IsA("BasePart") then
						local old = originalDecorationsTransparency[part]

						if old ~= nil then
							part.Transparency = old
						else
							part.Transparency = 0
						end

						part.CastShadow = true
					end
				end
			end
		end
	end

	xrayEnabled = false
end

createToggle("Xray V2", function(state)
	if state then
		startXRay()
	else
		stopXRay()
	end
end)
-- ================= XRAY OPTIMIZADO =================

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local xrayEnabled = false
local XRayTransparency = 1 -- 1 = totalmente invisible

-- Guarda los valores originales para restaurarlos correctamente
local originalProperties = {}

-- Conexiones activas
local connections = {}

-- Cola de piezas pendientes
local pendingParts = {}
local pendingSet = {}

-- Cuántas piezas como máximo procesar por frame.
-- Si las bases son MUY grandes, puedes bajarlo a 50-100.
local MAX_PARTS_PER_FRAME = 100

local plotsFolderConnection = nil


-- =====================================================
-- UTILIDADES
-- =====================================================

local function disconnectAll()
	for _, connection in pairs(connections) do
		if connection then
			connection:Disconnect()
		end
	end

	table.clear(connections)

	if plotsFolderConnection then
		plotsFolderConnection:Disconnect()
		plotsFolderConnection = nil
	end
end


local function saveOriginal(part)
	if originalProperties[part] == nil then
		originalProperties[part] = {
			Transparency = part.Transparency,
			CastShadow = part.CastShadow
		}
	end
end


local function applyXRay(part)
	if not xrayEnabled then
		return
	end

	if not part:IsA("BasePart") then
		return
	end

	if not part:IsDescendantOf(Workspace) then
		return
	end

	saveOriginal(part)

	part.Transparency = XRayTransparency
	part.CastShadow = false
end


local function queuePart(part)
	if not xrayEnabled then
		return
	end

	if not part:IsA("BasePart") then
		return
	end

	if pendingSet[part] then
		return
	end

	pendingSet[part] = true
	pendingParts[#pendingParts + 1] = part
end


-- =====================================================
-- PROCESAMIENTO POR LOTES
-- =====================================================

local heartbeatConnection = RunService.Heartbeat:Connect(function()
	if not xrayEnabled then
		return
	end

	local processed = 0

	while processed < MAX_PARTS_PER_FRAME and #pendingParts > 0 do
		local part = table.remove(pendingParts, 1)

		pendingSet[part] = nil

		if part and part.Parent then
			applyXRay(part)
		end

		processed += 1
	end
end)

table.insert(connections, heartbeatConnection)


-- =====================================================
-- DECORATIONS
-- =====================================================

local function processDecorations(decorations)
	if not xrayEnabled then
		return
	end

	if not decorations then
		return
	end

	-- Procesar las piezas existentes
	for _, obj in ipairs(decorations:GetDescendants()) do
		if obj:IsA("BasePart") then
			queuePart(obj)
		end
	end

	-- Detectar piezas nuevas sin volver a recorrer todo
	local connection = decorations.DescendantAdded:Connect(function(obj)
		if xrayEnabled and obj:IsA("BasePart") then
			queuePart(obj)
		end
	end)

	table.insert(connections, connection)
end


-- =====================================================
-- PLOTS
-- =====================================================

local function processPlot(plot)
	if not xrayEnabled then
		return
	end

	if not plot:IsA("Model") then
		return
	end

	-- Si Decorations ya existe
	local decorations = plot:FindFirstChild("Decorations")

	if decorations then
		processDecorations(decorations)
	end

	-- Por si Decorations aparece después
	local childConnection

	childConnection = plot.ChildAdded:Connect(function(child)
		if not xrayEnabled then
			return
		end

		if child.Name == "Decorations" then
			processDecorations(child)
		end
	end)

	table.insert(connections, childConnection)
end


-- =====================================================
-- INICIALIZACIÓN DE PLOTS
-- =====================================================

local function setupPlots()
	local plots = Workspace:FindFirstChild("Plots")

	if not plots then
		return
	end

	-- Procesar bases actuales
	for _, plot in ipairs(plots:GetChildren()) do
		processPlot(plot)
	end

	-- Detectar bases nuevas
	plotsFolderConnection = plots.ChildAdded:Connect(function(plot)
		if xrayEnabled then
			processPlot(plot)
		end
	end)
end


-- =====================================================
-- RESTAURAR
-- =====================================================

local function restoreAll()
	for part, properties in pairs(originalProperties) do
		if part and part.Parent then
			part.Transparency = properties.Transparency
			part.CastShadow = properties.CastShadow
		end
	end
end


-- =====================================================
-- START
-- =====================================================

local function startXRay()
	if xrayEnabled then
		return
	end

	xrayEnabled = true

	table.clear(pendingParts)
	table.clear(pendingSet)

	setupPlots()
end


-- =====================================================
-- STOP
-- =====================================================

local function stopXRay()
	if not xrayEnabled then
		return
	end

	xrayEnabled = false

	-- Vaciar cola
	table.clear(pendingParts)
	table.clear(pendingSet)

	-- Restaurar propiedades originales
	restoreAll()

	-- Desconectar listeners
	disconnectAll()
end


-- =====================================================
-- SI "Plots" APARECE DESPUÉS
-- =====================================================

local workspaceConnection = Workspace.ChildAdded:Connect(function(child)
	if not xrayEnabled then
		return
	end

	if child.Name == "Plots" then
		task.defer(function()
			if xrayEnabled then
				setupPlots()
			end
		end)
	end
end)

table.insert(connections, workspaceConnection)


-- =====================================================
-- TOGGLE
-- =====================================================

createToggle("Xray V2 OPTIMIZADO", function(state)
	if state then
		startXRay()
	else
		stopXRay()
	end
end)
-- ================= END =================
-- ================= XRAY =================

local xrayEnabled = false
local xrayConnection = nil
local originalDecorationsTransparency = {}

local XRayTransparency = 0.5

local function startXRay()

	if xrayConnection then
		xrayConnection:Disconnect()
		xrayConnection = nil
	end

	local plots = workspace:FindFirstChild("Plots")

	if plots then
		for _, plot in ipairs(plots:GetChildren()) do

			local decorations = plot:FindFirstChild("Decorations")

			if plot:IsA("Model") and decorations then

				for _, part in ipairs(decorations:GetDescendants()) do

					if part:IsA("BasePart") then

						if originalDecorationsTransparency[part] == nil then
							originalDecorationsTransparency[part] =
								part.Transparency
						end

						part.Transparency =
							XRayTransparency
					end
				end
			end
		end
	end

	xrayConnection =
		RunService.Heartbeat:Connect(function()

			if not xrayEnabled then
				return
			end

			local plots =
				workspace:FindFirstChild("Plots")

			if not plots then
				return
			end

			for _, plot in ipairs(
				plots:GetChildren()
			) do

				local decorations =
					plot:FindFirstChild(
						"Decorations"
					)

				if plot:IsA("Model")
					and decorations then

					for _, part in ipairs(
						decorations:GetDescendants()
					) do

						if part:IsA(
							"BasePart"
						) then

							part.Transparency =
								XRayTransparency
						end
					end
				end
			end
		end)

	xrayEnabled = true
end

local function stopXRay()

	if xrayConnection then
		xrayConnection:Disconnect()
		xrayConnection = nil
	end

	local plots = workspace:FindFirstChild("Plots")

	if plots then
		for _, plot in ipairs(plots:GetChildren()) do

			local decorations =
				plot:FindFirstChild(
					"Decorations"
				)

			if plot:IsA("Model")
				and decorations then

				for _, part in ipairs(
					decorations:GetDescendants()
				) do

					if part:IsA(
						"BasePart"
					) then

						local old =
							originalDecorationsTransparency[
								part
							]

						if old ~= nil then
							part.Transparency =
								old
						else
							part.Transparency = 0
						end
					end
				end
			end
		end
	end

	xrayEnabled = false
end

createToggle("Xray (Undetectable) ", function(state)

	if state then
		startXRay()
	else
		stopXRay()
	end

end)

-- ================= END =================
-- ================= SUBSPACE MINE ESP =================

local subspaceMineESPData = {}
local subspaceMineConn = nil
local FolderName = "ToolsAdds"

local function getMineOwner(mineName)
	local ownerName = mineName:match("SubspaceTripmine(.+)")

	if not ownerName then
		return "Unknown"
	end

	local foundPlayer = Players:FindFirstChild(ownerName)

	return foundPlayer and foundPlayer.DisplayName or ownerName
end

local function createMineESP(mine)

	local ownerName = getMineOwner(mine.Name)

	local selectionBox = Instance.new("SelectionBox")
	selectionBox.Name = "ESP_Hitbox"
	selectionBox.Adornee = mine
	selectionBox.Color3 = Color3.fromRGB(167,142,255)
	selectionBox.LineThickness = 0.05
	selectionBox.Parent = mine

	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Name = "ESP_Label"
	billboardGui.Adornee = mine
	billboardGui.Size = UDim2.new(0,250,0,50)
	billboardGui.StudsOffset = Vector3.new(0,2.5,0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = mine

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1,0,1,0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "Mina"
	textLabel.TextColor3 = Color3.fromRGB(167,142,255)
	textLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	textLabel.TextStrokeTransparency = 0
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 16
	textLabel.Parent = billboardGui

	subspaceMineESPData[mine] = {
		selectionBox = selectionBox,
		billboardGui = billboardGui
	}
end

local function clearMineESP()

	for mine,data in pairs(subspaceMineESPData) do

		pcall(function()

			if data.selectionBox then
				data.selectionBox:Destroy()
			end

			if data.billboardGui then
				data.billboardGui:Destroy()
			end

		end)

	end

	table.clear(subspaceMineESPData)
end

local function startMineESP()

	if subspaceMineConn then
		subspaceMineConn:Disconnect()
	end

	subspaceMineConn =
	RunService.Heartbeat:Connect(function()

		local folder =
			workspace:FindFirstChild(FolderName)

		if not folder then
			return
		end

		for _,obj in ipairs(folder:GetChildren()) do

			if obj:IsA("BasePart")
			and obj.Name:match("^SubspaceTripmine")
			and not subspaceMineESPData[obj] then

				createMineESP(obj)

			end
		end

		for mine,data in pairs(subspaceMineESPData) do

			if not mine.Parent then

				if data.selectionBox then
					data.selectionBox:Destroy()
				end

				if data.billboardGui then
					data.billboardGui:Destroy()
				end

				subspaceMineESPData[mine] = nil

			end
		end
	end)
end

local function stopMineESP()

	clearMineESP()

	if subspaceMineConn then
		subspaceMineConn:Disconnect()
		subspaceMineConn = nil
	end
end

createToggle("ESP MINAS", function(state)

	if state then
		startMineESP()
	else
		stopMineESP()
	end

end)

-- ================= BASE TIMER ESP =================

local baseESPData = {}
local baseESPConn = nil

local function clearBaseESP()

	for _,gui in pairs(baseESPData) do

		pcall(function()
			gui:Destroy()
		end)

	end

	table.clear(baseESPData)
end

local function startBaseESP()

	if baseESPConn then
		baseESPConn:Disconnect()
	end

	baseESPConn =
	RunService.Heartbeat:Connect(function()

		local plots =
			workspace:FindFirstChild("Plots")

		if not plots then
			return
		end

		for _,plot in ipairs(plots:GetChildren()) do

			local purchases =
				plot:FindFirstChild("Purchases")

			local plotBlock =
				purchases
				and purchases:FindFirstChild("PlotBlock")

			local main =
				plotBlock
				and plotBlock:FindFirstChild("Main")

			local timeLabel =
				main
				and main:FindFirstChild("BillboardGui")
				and main.BillboardGui:FindFirstChild("RemainingTime")

			if main and timeLabel then

				if not baseESPData[plot] then

					local billboard =
						Instance.new("BillboardGui")

					billboard.Name = "BaseTimerESP"
					billboard.Size = UDim2.new(0,60,0,25)
					billboard.StudsOffset = Vector3.new(0,5,0)
					billboard.AlwaysOnTop = true
					billboard.Adornee = main
					billboard.Parent = plot

					local label =
						Instance.new("TextLabel")

					label.Size = UDim2.new(1,0,1,0)
					label.BackgroundTransparency = 1
					label.TextStrokeTransparency = 0
					label.Font = Enum.Font.GothamBlack
					label.TextSize = 17
					label.TextColor3 = Color3.new(1,1,1)
					label.Parent = billboard

					baseESPData[plot] =
						billboard
				end

				local label =
					baseESPData[plot]
					:FindFirstChildOfClass("TextLabel")

				if label then
					label.Text = timeLabel.Text
				end

			elseif baseESPData[plot] then

				baseESPData[plot]:Destroy()
				baseESPData[plot] = nil

			end
		end
	end)
end

local function stopBaseESP()

	clearBaseESP()

	if baseESPConn then
		baseESPConn:Disconnect()
		baseESPConn = nil
	end
end

createToggle("ESP BASE", function(state)

	if state then
		startBaseESP()
	else
		stopBaseESP()
	end

end)

-- ============================================================
-- LINE TO BASE (Azul y Ejecución Directa e Independiente)
-- ============================================================
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local plotBeam = nil
    local plotBeamAttachment0 = nil
    local plotBeamAttachment1 = nil

    local function findMyPlot()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local surfaceGui = sign:FindFirstChildWhichIsA("SurfaceGui", true)
                if surfaceGui then
                    local label = surfaceGui:FindFirstChildWhichIsA("TextLabel", true)
                    if label then
                        local text = label.Text:lower()
                        if text:find(LocalPlayer.DisplayName:lower(), 1, true) or text:find(LocalPlayer.Name:lower(), 1, true) then
                            return plot
                        end
                    end
                end
            end
        end
        return nil
    end

    local function createPlotBeam()
        local myPlot = findMyPlot()
        if not myPlot or not myPlot.Parent then return end
        
        local character = LocalPlayer.Character
        if not character or not character.Parent then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        
        if plotBeam then pcall(function() plotBeam:Destroy() end) end
        if plotBeamAttachment0 then pcall(function() plotBeamAttachment0:Destroy() end) end
        
        plotBeamAttachment0 = hrp:FindFirstChild("PlotBeamAttach_Player") or Instance.new("Attachment")
        plotBeamAttachment0.Name = "PlotBeamAttach_Player"
        plotBeamAttachment0.Position = Vector3.new(0, 0, 0)
        plotBeamAttachment0.Parent = hrp
        
        local plotPart = myPlot:FindFirstChild("MainRootPart") or myPlot:FindFirstChildWhichIsA("BasePart")
        if not plotPart or not plotPart.Parent then return end
        
        plotBeamAttachment1 = plotPart:FindFirstChild("PlotBeamAttach_Plot") or Instance.new("Attachment")
        plotBeamAttachment1.Name = "PlotBeamAttach_Plot"
        plotBeamAttachment1.Position = Vector3.new(0, 5, 0)
        plotBeamAttachment1.Parent = plotPart
        
        plotBeam = hrp:FindFirstChild("PlotBeam") or Instance.new("Beam")
        plotBeam.Name = "PlotBeam"
        plotBeam.Attachment0 = plotBeamAttachment0
        plotBeam.Attachment1 = plotBeamAttachment1
        plotBeam.FaceCamera = true
        plotBeam.LightEmission = 0.5
        
        -- Color azul
        plotBeam.Color = ColorSequence.new(Color3.fromRGB(0, 100, 255)) 
        
        plotBeam.Transparency = NumberSequence.new(0)
        plotBeam.Width0 = 0.7
        plotBeam.Width1 = 0.7
        plotBeam.TextureMode = Enum.TextureMode.Wrap
        plotBeam.TextureSpeed = 0
        plotBeam.Parent = hrp
    end

    local function resetPlotBeam()
        if plotBeam then pcall(function() plotBeam:Destroy() end) end
        if plotBeamAttachment0 then pcall(function() plotBeamAttachment0:Destroy() end) end
        if plotBeamAttachment1 then pcall(function() plotBeamAttachment1:Destroy() end) end
        plotBeam = nil
        plotBeamAttachment0 = nil
        plotBeamAttachment1 = nil
    end

    task.spawn(function()
        local checkCounter = 0
        RunService.Heartbeat:Connect(function()
            checkCounter = checkCounter + 1
            if checkCounter >= 30 then
                checkCounter = 0
                if not plotBeam or not plotBeam.Parent or not plotBeamAttachment0 or not plotBeamAttachment0.Parent then
                    pcall(createPlotBeam)
                end
            end
        end)
    end)

    LocalPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if character then
            pcall(createPlotBeam)
        end
    end)

    if LocalPlayer.Character then
        task.spawn(function()
            task.wait(0.2)
            createPlotBeam()
        end)
    end
end

-- ================= VER RENDIMIENTO =================

local performanceEnabled = false
local performanceGui = nil
local performanceConn = nil

local function enablePerformance()
	if performanceEnabled then return end
	performanceEnabled = true

	local frameCount = 0
	local lastFpsTime = os.clock()

	performanceGui = Instance.new("ScreenGui")
	performanceGui.Name = "StatsGui"
	performanceGui.ResetOnSpawn = false
	performanceGui.Parent = game:GetService("CoreGui")

	local container = Instance.new("Frame")
	container.Parent = performanceGui
	container.Size = UDim2.new(0, 220, 0, 50)
	container.Position = UDim2.new(0.5, 0, 0, 15)
	container.AnchorPoint = Vector2.new(0.5, 0)
	container.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	container.BackgroundTransparency = 0.15
	container.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(0, 170, 255)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.2
	stroke.Parent = container

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,25)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(45,45,45))
	}
	gradient.Rotation = 45
	gradient.Parent = container

	local statsLabel = Instance.new("TextLabel")
	statsLabel.Parent = container
	statsLabel.BackgroundTransparency = 1
	statsLabel.Size = UDim2.new(1, -10, 1, 0)
	statsLabel.Position = UDim2.new(0, 5, 0, 0)
	statsLabel.Font = Enum.Font.GothamBold
	statsLabel.TextColor3 = Color3.fromRGB(255,255,255)
	statsLabel.TextScaled = true
	statsLabel.Text = "FPS: 0 | PING: 0ms"

	performanceConn = RunService.RenderStepped:Connect(function()
		frameCount += 1

		local now = os.clock()
		local elapsed = now - lastFpsTime

		if elapsed >= 0.5 then
			local fps = math.floor(frameCount / elapsed)

			frameCount = 0
			lastFpsTime = now

			local ping = 0
			pcall(function()
				ping = math.floor(player:GetNetworkPing() * 1000)
			end)

			if fps >= 60 then
				stroke.Color = Color3.fromRGB(0,255,140)
			elseif fps >= 30 then
				stroke.Color = Color3.fromRGB(255,200,0)
			else
				stroke.Color = Color3.fromRGB(255,80,80)
			end

			statsLabel.Text = string.format("FPS: %d | PING: %dms", fps, ping)
		end
	end)
end

local function disablePerformance()
	performanceEnabled = false

	if performanceConn then
		performanceConn:Disconnect()
		performanceConn = nil
	end

	if performanceGui then
		performanceGui:Destroy()
		performanceGui = nil
	end
end

createToggle("Ver rendimiento", function(state)
	if state then
		enablePerformance()
	else
		disablePerformance()
	end
end)

-- ================= DROP BRAINROT BUTTON =================

local dropBrainrotGui = nil
local dropBrainrotConn = nil
local dropBrainrotActive = false
local dropBrainrotAnimConn = nil

local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150

local function runDropBrainrot()
	if dropBrainrotActive then return end

	local char = player.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	dropBrainrotActive = true
	local startTick = tick()

	dropBrainrotConn = RunService.Heartbeat:Connect(function()
		local r = char and char:FindFirstChild("HumanoidRootPart")

		if not r then
			if dropBrainrotConn then
				dropBrainrotConn:Disconnect()
				dropBrainrotConn = nil
			end

			dropBrainrotActive = false
			return
		end

		if tick() - startTick >= DROP_ASCEND_DURATION then
			if dropBrainrotConn then
				dropBrainrotConn:Disconnect()
				dropBrainrotConn = nil
			end

			local rp = RaycastParams.new()
			rp.FilterDescendantsInstances = { char }
			rp.FilterType = Enum.RaycastFilterType.Exclude

			local ray = workspace:Raycast(
				r.Position,
				Vector3.new(0, -2000, 0),
				rp
			)

			if ray then
				local hum = char:FindFirstChildOfClass("Humanoid")
				local offset = ((hum and hum.HipHeight) or 2) + (r.Size.Y / 2)

				r.CFrame = CFrame.new(
					r.Position.X,
					ray.Position.Y + offset,
					r.Position.Z
				)

				r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end

			dropBrainrotActive = false
			return
		end

		r.AssemblyLinearVelocity = Vector3.new(
			r.AssemblyLinearVelocity.X,
			DROP_ASCEND_SPEED,
			r.AssemblyLinearVelocity.Z
		)
	end)
end

local function destroyDropBrainrotGui()
	if dropBrainrotAnimConn then
		dropBrainrotAnimConn:Disconnect()
		dropBrainrotAnimConn = nil
	end

	if dropBrainrotConn then
		dropBrainrotConn:Disconnect()
		dropBrainrotConn = nil
	end

	dropBrainrotActive = false

	if dropBrainrotGui then
		dropBrainrotGui:Destroy()
		dropBrainrotGui = nil
	end
end

local function createDropBrainrotButton()
	if dropBrainrotGui then
		destroyDropBrainrotGui()
	end

	local defaultPos = UDim2.new(0, 10, 0, 10)
	local btnPos = defaultPos
	if Config["DropBrainrotPos"] then
		local p = Config["DropBrainrotPos"]
		if type(p) == "table" and #p >= 4 then
			btnPos = UDim2.new(p[1], p[2], p[3], p[4])
		end
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "DropBrainrotGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = player:WaitForChild("PlayerGui")
	dropBrainrotGui = gui

	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.Parent = gui
	shadow.BackgroundTransparency = 1
	shadow.Size = UDim2.new(0, 92, 0, 92)
	shadow.Position = UDim2.new(btnPos.X.Scale, btnPos.X.Offset + 3, btnPos.Y.Scale, btnPos.Y.Offset + 3)
	shadow.Image = "rbxassetid://6014261993"
	shadow.ImageTransparency = 0.78
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	shadow.ZIndex = 1

	local btn = Instance.new("TextButton")
	btn.Name = "DropButton"
	btn.Size = UDim2.new(0, 72, 0, 72)
	btn.Position = btnPos
	btn.BackgroundColor3 = Color3.fromRGB(14, 18, 30)
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Text = ""
	btn.Parent = gui
	btn.ZIndex = 3
	btn.Active = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = btn

	local uiScale = Instance.new("UIScale")
	uiScale.Scale = 0.95
	uiScale.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Parent = btn
	stroke.Thickness = 2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.fromRGB(0, 170, 255)
	stroke.Transparency = 0.15

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(55, 95, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 180))
	})
	grad.Rotation = 135
	grad.Parent = btn

	local inner = Instance.new("Frame")
	inner.Name = "Inner"
	inner.Parent = btn
	inner.BackgroundColor3 = Color3.fromRGB(18, 24, 40)
	inner.BackgroundTransparency = 0.22
	inner.BorderSizePixel = 0
	inner.Size = UDim2.new(1, -8, 1, -8)
	inner.Position = UDim2.new(0, 4, 0, 4)
	inner.ZIndex = 2

	local innerCorner = Instance.new("UICorner")
	innerCorner.CornerRadius = UDim.new(1, 0)
	innerCorner.Parent = inner

	local innerGrad = Instance.new("UIGradient")
	innerGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 30, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 16, 28))
	})
	innerGrad.Rotation = 90
	innerGrad.Parent = inner

	local glow = Instance.new("Frame")
	glow.Name = "Glow"
	glow.Parent = btn
	glow.BackgroundTransparency = 1
	glow.BorderSizePixel = 0
	glow.Size = UDim2.new(1, 6, 1, 6)
	glow.Position = UDim2.new(0, -3, 0, -3)
	glow.ZIndex = 1

	local glowCorner = Instance.new("UICorner")
	glowCorner.CornerRadius = UDim.new(1, 0)
	glowCorner.Parent = glow

	local glowStroke = Instance.new("UIStroke")
	glowStroke.Parent = glow
	glowStroke.Thickness = 1
	glowStroke.Color = Color3.fromRGB(0, 170, 255)
	glowStroke.Transparency = 0.72

	local icon = Instance.new("TextLabel")
	icon.Name = "Icon"
	icon.Parent = btn
	icon.BackgroundTransparency = 1
	icon.Size = UDim2.new(1, 0, 0.34, 0)
	icon.Position = UDim2.new(0, 0, 0.10, 0)
	icon.Text = "⚡"
	icon.TextScaled = true
	icon.Font = Enum.Font.GothamBlack
	icon.TextColor3 = Color3.fromRGB(255, 255, 255)
	icon.ZIndex = 4

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Parent = btn
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -8, 0.20, 0)
	title.Position = UDim2.new(0, 4, 0.55, 0)
	title.Text = "DROP"
	title.TextScaled = true
	title.Font = Enum.Font.GothamBlack
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.ZIndex = 4

	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.Parent = btn
	subtitle.BackgroundTransparency = 1
	subtitle.Size = UDim2.new(1, -8, 0.12, 0)
	subtitle.Position = UDim2.new(0, 4, 0.76, 0)
	subtitle.Text = "Brainrot"
	subtitle.TextScaled = true
	subtitle.Font = Enum.Font.GothamMedium
	subtitle.TextColor3 = Color3.fromRGB(210, 220, 255)
	subtitle.TextTransparency = 0.08
	subtitle.ZIndex = 4

	local close = Instance.new("TextButton")
	close.Name = "Close"
	close.Parent = btn
	close.Size = UDim2.new(0, 18, 0, 18)
	close.Position = UDim2.new(1, -9, 0, -9)
	close.AnchorPoint = Vector2.new(0.5, 0.5)
	close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
	close.BorderSizePixel = 0
	close.AutoButtonColor = false
	close.Text = "×"
	close.TextScaled = true
	close.Font = Enum.Font.GothamBold
	close.TextColor3 = Color3.fromRGB(255, 255, 255)
	close.ZIndex = 5

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(1, 0)
	closeCorner.Parent = close

	local closeStroke = Instance.new("UIStroke")
	closeStroke.Parent = close
	closeStroke.Thickness = 1
	closeStroke.Color = Color3.fromRGB(255, 255, 255)
	closeStroke.Transparency = 0.45

	dropBrainrotAnimConn = RunService.RenderStepped:Connect(function()
		if not gui.Parent then return end
		grad.Rotation = (grad.Rotation + 0.5) % 360
	end)

	task.defer(function()
		btn.Size = UDim2.new(0, 0, 0, 0)
		shadow.Size = UDim2.new(0, 0, 0, 0)

		TweenService:Create(
			btn,
			TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Size = UDim2.new(0, 72, 0, 72) }
		):Play()

		TweenService:Create(
			shadow,
			TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Size = UDim2.new(0, 92, 0, 92) }
		):Play()

		TweenService:Create(
			uiScale,
			TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Scale = 0.95 }
		):Play()
	end)

	local function setPremiumHover(on)
		if on then
			TweenService:Create(
				btn,
				TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ BackgroundColor3 = Color3.fromRGB(18, 22, 38) }
			):Play()

			TweenService:Create(
				uiScale,
				TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Scale = 1 }
			):Play()

			stroke.Transparency = 0.02
			glowStroke.Transparency = 0.62
		else
			TweenService:Create(
				btn,
				TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ BackgroundColor3 = Color3.fromRGB(14, 18, 30) }
			):Play()

			TweenService:Create(
				uiScale,
				TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Scale = 0.95 }
			):Play()

			stroke.Transparency = 0.15
			glowStroke.Transparency = 0.72
		end
	end

	btn.MouseEnter:Connect(function()
		setPremiumHover(true)
	end)

	btn.MouseLeave:Connect(function()
		setPremiumHover(false)
	end)

	btn.MouseButton1Down:Connect(function()
		TweenService:Create(
			uiScale,
			TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Scale = 0.90 }
		):Play()
	end)

	btn.MouseButton1Up:Connect(function()
		TweenService:Create(
			uiScale,
			TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Scale = 1 }
		):Play()
	end)

	close.MouseEnter:Connect(function()
		TweenService:Create(
			close,
			TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundColor3 = Color3.fromRGB(255, 95, 95) }
		):Play()
	end)

	close.MouseLeave:Connect(function()
		TweenService:Create(
			close,
			TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundColor3 = Color3.fromRGB(255, 70, 70) }
		):Play()
	end)

	close.MouseButton1Click:Connect(function()
		Config["Drop Brainrot Btn"] = false
		Config["DropBrainrotPos"] = nil
		saveConfig()
		destroyDropBrainrotGui()
	end)

	btn.MouseButton1Click:Connect(function()
		runDropBrainrot()
	end)

	local dragging = false
	local dragStart
	local startPos
	local dragInput

	local function updateDrag(input)
		local delta = input.Position - dragStart

		btn.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

		shadow.Position = UDim2.new(
			btn.Position.X.Scale,
			btn.Position.X.Offset + 3,
			btn.Position.Y.Scale,
			btn.Position.Y.Offset + 3
		)
	end

	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = btn.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					Config["DropBrainrotPos"] = {btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset}
					saveConfig()
				end
			end)
		end
	end)

	btn.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			updateDrag(input)
		end
	end)

	return gui
end

createButton("Drop Brainrot Btn", function()
	if dropBrainrotGui then
		Config["Drop Brainrot Btn"] = false
		Config["DropBrainrotPos"] = nil
		saveConfig()
		destroyDropBrainrotGui()
		return
	end

	Config["Drop Brainrot Btn"] = true
	saveConfig()
	dropBrainrotGui = createDropBrainrotButton()
end)

if Config["Drop Brainrot Btn"] then
	task.defer(function()
		dropBrainrotGui = createDropBrainrotButton()
	end)
end

-- ================= END =================


-- ================= SERVER HOPPER =================

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local function serverHop()
	local player = Players.LocalPlayer
	local placeId = game.PlaceId
	local jobId = game.JobId

	local success, servers = pcall(function()
		return game.HttpService:JSONDecode(
			game:HttpGet(
				"https://games.roblox.com/v1/games/" ..
				placeId ..
				"/servers/Public?sortOrder=Asc&limit=100"
			)
		)
	end)

	if success and servers and servers.data then
		for _, server in ipairs(servers.data) do
			if server.playing < server.maxPlayers and server.id ~= jobId then
				TeleportService:TeleportToPlaceInstance(
					placeId,
					server.id,
					player
				)
				break
			end
		end
	end
end

createButton("Server Hopper", function()
	serverHop()
end)

-- ================= END SERVER HOPPER =================
local mini = Instance.new("ImageButton")  
mini.Name = "MiniButton"  
mini.Size = UDim2.new(0, 54, 0, 54)  
mini.Position = UDim2.new(0, 18, 0, 200)  
mini.BackgroundColor3 = Color3.fromRGB(12, 22, 38)  
mini.BackgroundTransparency = 0  
mini.BorderSizePixel = 0  
mini.Image = ICON  
mini.ScaleType = Enum.ScaleType.Fit  
mini.ImageColor3 = Color3.fromRGB(255, 255, 255)  
mini.Visible = false  
mini.Active = true  
mini.Parent = gui  
Instance.new("UICorner", mini).CornerRadius = UDim.new(1, 0)  

local miniStroke = Instance.new("UIStroke")  
miniStroke.Thickness = 2  
miniStroke.Transparency = 0.1  
miniStroke.Color = Color3.fromRGB(90, 190, 255)  
miniStroke.Parent = mini  

local miniGlow = Instance.new("UIGradient")  
miniGlow.Color = ColorSequence.new({  
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 90, 255)),  
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(120, 220, 255)),  
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 90, 255)),  
})  
miniGlow.Parent = miniStroke  

local minimized = false  

local function setMinimized(state)  
	minimized = state  
	border.Visible = not state  
	mini.Visible = state  
end  

minimizeBtn.MouseButton1Click:Connect(function()  
	setMinimized(true)  
end)  

mini.MouseButton1Click:Connect(function()  
	setMinimized(false)  
end)  

closeBtn.MouseButton1Click:Connect(function()  
	gui:Destroy()  
	getgenv().TokitoHub = nil  
end)  

local function makeDraggable(handle, root)  
	handle.Active = true  

	local dragging = false  
	local dragStart  
	local startPos  

	handle.InputBegan:Connect(function(input)  
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
			dragging = true  
			dragStart = input.Position  
			startPos = root.Position  
		end  
	end)  

	handle.InputEnded:Connect(function(input)  
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
			dragging = false  
		end  
	end)  

	UIS.InputChanged:Connect(function(input)  
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
			local delta = input.Position - dragStart  
			root.Position = UDim2.new(  
				startPos.X.Scale,  
				startPos.X.Offset + delta.X,  
				startPos.Y.Scale,  
				startPos.Y.Offset + delta.Y  
			)  
		end  
	end)  
end  

makeDraggable(topbar, border)  
makeDraggable(mini, mini)  

task.spawn(function()  
	while gui.Parent do  
		borderGradient.Rotation = (borderGradient.Rotation + 1) % 360  
		task.wait(0.02)  
	end  
end)

end

if splash then
splash:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer

local function playIntro(accentColor, onFinished)
accentColor = accentColor or Color3.fromRGB(192, 192, 192)

local introStart = os.clock()

local playerGui = LP:WaitForChild("PlayerGui")

local introGui = Instance.new("ScreenGui")
introGui.Name = "ReusableIntro"
introGui.IgnoreGuiInset = true
introGui.ResetOnSpawn = false
introGui.DisplayOrder = 100
introGui.Parent = playerGui

local darkBg = Instance.new("Frame")
darkBg.Size = UDim2.new(1, 0, 1, 0)
darkBg.BackgroundColor3 = Color3.fromRGB(2, 4, 14)
darkBg.BackgroundTransparency = 1
darkBg.BorderSizePixel = 0
darkBg.Parent = introGui

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new(
	Color3.fromRGB(8, 12, 30),
	Color3.fromRGB(0, 0, 4)
)
bgGrad.Rotation = 90
bgGrad.Parent = darkBg

local stars = {}
for i = 1, 60 do
	local s = Instance.new("Frame")
	local size = math.random(1, 4)
	s.Size = UDim2.new(0, size, 0, size)
	s.Position = UDim2.new(math.random(), 0, math.random(), 0)
	s.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	s.BackgroundTransparency = 1
	s.BorderSizePixel = 0
	s.Parent = introGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = s

	stars[i] = {
		frame = s,
		speed = 0.005 + math.random() * 0.025,
		targetTrans = 0.05 + math.random() * 0.35,
	}
end

local moonContainer = Instance.new("Frame")
moonContainer.Size = UDim2.new(0, 140, 0, 140)
moonContainer.AnchorPoint = Vector2.new(0.5, 0.5)
moonContainer.Position = UDim2.new(0.78, 0, -0.3, 0)
moonContainer.BackgroundTransparency = 1
moonContainer.Parent = introGui

local moonGlow = Instance.new("Frame")
moonGlow.Size = UDim2.new(2.2, 0, 2.2, 0)
moonGlow.AnchorPoint = Vector2.new(0.5, 0.5)
moonGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
moonGlow.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
moonGlow.BackgroundTransparency = 1
moonGlow.BorderSizePixel = 0
moonGlow.Parent = moonContainer
Instance.new("UICorner", moonGlow).CornerRadius = UDim.new(1, 0)

local moonHalo = Instance.new("Frame")
moonHalo.Size = UDim2.new(1.4, 0, 1.4, 0)
moonHalo.AnchorPoint = Vector2.new(0.5, 0.5)
moonHalo.Position = UDim2.new(0.5, 0, 0.5, 0)
moonHalo.BackgroundColor3 = Color3.fromRGB(255, 255, 240)
moonHalo.BackgroundTransparency = 1
moonHalo.BorderSizePixel = 0
moonHalo.Parent = moonContainer
Instance.new("UICorner", moonHalo).CornerRadius = UDim.new(1, 0)

local moon = Instance.new("Frame")
moon.Size = UDim2.new(1, 0, 1, 0)
moon.BackgroundColor3 = Color3.fromRGB(240, 240, 230)
moon.BackgroundTransparency = 1
moon.BorderSizePixel = 0
moon.Parent = moonContainer
Instance.new("UICorner", moon).CornerRadius = UDim.new(1, 0)

local moonGrad = Instance.new("UIGradient")
moonGrad.Color = ColorSequence.new(
	Color3.fromRGB(255, 255, 240),
	Color3.fromRGB(150, 155, 170)
)
moonGrad.Rotation = 135
moonGrad.Parent = moon

local craterData = {
	{0.25, 0.22, 22},
	{0.58, 0.38, 12},
	{0.60, 0.68, 16},
	{0.32, 0.70, 9},
}

for _, cd in ipairs(craterData) do
	local c = Instance.new("Frame")
	c.Size = UDim2.new(0, cd[3], 0, cd[3])
	c.Position = UDim2.new(cd[1], 0, cd[2], 0)
	c.BackgroundColor3 = Color3.fromRGB(170, 170, 165)
	c.BackgroundTransparency = 1
	c.BorderSizePixel = 0
	c.Parent = moon
	Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)
end

local center = Instance.new("Frame")
center.AnchorPoint = Vector2.new(0.5, 0.5)
center.Position = UDim2.new(0.5, 0, 0.5, 0)
center.Size = UDim2.new(0, 600, 0, 240)
center.BackgroundTransparency = 1
center.Parent = introGui

local lineTop = Instance.new("Frame")
lineTop.AnchorPoint = Vector2.new(0.5, 0)
lineTop.Position = UDim2.new(0.5, 0, 0, 60)
lineTop.Size = UDim2.new(0, 0, 0, 2)
lineTop.BackgroundColor3 = accentColor
lineTop.BorderSizePixel = 0
lineTop.Parent = center

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 80)
title.Position = UDim2.new(0, 0, 0, 80)
title.BackgroundTransparency = 1
title.Text = "TokitoHub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 76
title.TextTransparency = 1
title.TextStrokeTransparency = 1
title.TextStrokeColor3 = accentColor
title.Parent = center

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 24)
subtitle.Position = UDim2.new(0, 0, 0, 170)
subtitle.BackgroundTransparency = 1
subtitle.Text = "by Tokito/Andres"
subtitle.TextColor3 = accentColor
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 18
subtitle.TextTransparency = 1
subtitle.Parent = center

local lineBot = Instance.new("Frame")
lineBot.AnchorPoint = Vector2.new(0.5, 1)
lineBot.Position = UDim2.new(0.5, 0, 1, -10)
lineBot.Size = UDim2.new(0, 0, 0, 2)
lineBot.BackgroundColor3 = accentColor
lineBot.BorderSizePixel = 0
lineBot.Parent = center

local shootStar = Instance.new("Frame")
shootStar.Size = UDim2.new(0, 100, 0, 2)
shootStar.AnchorPoint = Vector2.new(0.5, 0.5)
shootStar.Position = UDim2.new(-0.1, 0, 0.18, 0)
shootStar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shootStar.BackgroundTransparency = 1
shootStar.BorderSizePixel = 0
shootStar.Rotation = 20
shootStar.Parent = introGui

local shootGlow = Instance.new("UIStroke")
shootGlow.Color = Color3.fromRGB(255, 255, 240)
shootGlow.Thickness = 4
shootGlow.Transparency = 0.5
shootGlow.Parent = shootStar

local introActive = true
local driftConn = RunService.Heartbeat:Connect(function()
	if not introActive then
		return
	end

	for _, sd in ipairs(stars) do
		local pos = sd.frame.Position
		local newX = pos.X.Scale - sd.speed
		if newX < -0.02 then
			newX = 1.2
		end
		sd.frame.Position = UDim2.new(newX, 0, pos.Y.Scale, pos.Y.Offset)
	end
end)

TweenService:Create(darkBg, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
for _, sd in ipairs(stars) do
	task.delay(math.random() * 0.6, function()
		if sd.frame and sd.frame.Parent then
			TweenService:Create(sd.frame, TweenInfo.new(0.4 + math.random() * 0.4), {
				BackgroundTransparency = sd.targetTrans
			}):Play()
		end
	end)
end

task.wait(0.6)

TweenService:Create(moonContainer, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.78, 0, 0.24, 0)
}):Play()
TweenService:Create(moon, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
TweenService:Create(moonHalo, TweenInfo.new(1), {BackgroundTransparency = 0.55}):Play()
TweenService:Create(moonGlow, TweenInfo.new(1.2), {BackgroundTransparency = 0.78}):Play()

task.wait(1.2)

task.spawn(function()
	TweenService:Create(shootStar, TweenInfo.new(0.06), {BackgroundTransparency = 0.1}):Play()
	TweenService:Create(shootStar, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(1.1, 0, 0.42, 0)
	}):Play()
	task.wait(0.55)
	TweenService:Create(shootStar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
end)

TweenService:Create(lineTop, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 480, 0, 2)
}):Play()
TweenService:Create(lineBot, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 480, 0, 2)
}):Play()

task.wait(0.15)

TweenService:Create(title, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
	TextTransparency = 0,
	TextStrokeTransparency = 0.3
}):Play()

task.wait(0.55)

TweenService:Create(subtitle, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
task.wait(0.25)

for _ = 1, 3 do
	TweenService:Create(title, TweenInfo.new(0.07), {TextColor3 = accentColor}):Play()
	task.wait(0.07)
	TweenService:Create(title, TweenInfo.new(0.07), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	task.wait(0.07)
end

task.wait(0.15)

TweenService:Create(center, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
	Size = UDim2.new(0, 0, 0, 0)
}):Play()
TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
TweenService:Create(subtitle, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
TweenService:Create(lineTop, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
	Size = UDim2.new(0, 0, 0, 2)
}):Play()
TweenService:Create(lineBot, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
	Size = UDim2.new(0, 0, 0, 2)
}):Play()

TweenService:Create(darkBg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(moonContainer, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
	Position = UDim2.new(0.78, 0, 1.2, 0)
}):Play()
TweenService:Create(moon, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(moonHalo, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(moonGlow, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()

for _, sd in ipairs(stars) do
	TweenService:Create(sd.frame, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
end

local elapsed = os.clock() - introStart
local remaining = 6 - elapsed
if remaining > 0 then
	task.wait(remaining)
end

introActive = false
if driftConn then
	driftConn:Disconnect()
end
introGui:Destroy()

if onFinished then
	onFinished()
end

end

if shouldSkipIntro() then
	createMenu()
else
	playIntro(Color3.fromRGB(192, 192, 192), function()
		createMenu()
	end)
end
