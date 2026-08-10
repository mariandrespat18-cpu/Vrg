if getgenv().TokitoHub then return end
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

    local WhitelistedUsers = {
        ["Toki"] = true,
        ["Tokito"] = true,
        ["DavidAlejandro78892"] = true,
        ["davidalejandro78892"] = true
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TokitoLaserGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local success, result = pcall(function() return gethui() or game:GetService("CoreGui") end)
    ScreenGui.Parent = success and result or game:GetService("CoreGui")

    -- ================= CARGAR POSICIÓN GUARDADA =================
    local defaultPos = UDim2.new(0.5, -80, 0.15, 0)
    local framePos = defaultPos

    pcall(function()
        if Config and Config["CapaAimbotPos"] then
            local p = Config["CapaAimbotPos"]
            if type(p) == "table" and #p >= 4 then
                framePos = UDim2.new(p[1], p[2], p[3], p[4])
            end
        end
    end)

    -- Marco Principal más compacto (Ancho: 160, Alto: 75)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 160, 0, 75)
    MainFrame.Position = framePos
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false -- Oculto por defecto hasta activar el Toggle
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Thickness = 2
    MainStroke.Color = Color3.fromRGB(0, 170, 255)
    MainStroke.Transparency = 0.2

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 125, 0, 25)
    Title.Position = UDim2.new(0, 8, 0, 4)
    Title.Text = "Capa laser aim"
    Title.TextColor3 = Color3.fromRGB(0, 220, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame

    -- Botón de Minimizar (—)
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

    -- Botón Toggle (Aimbot OFF/ON)
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

    -- Animación RGB Azul
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if AimbotEnabled then
                local timePos = tick() * 3
                local glow = math.abs(math.sin(timePos)) * 0.5 + 0.5
                MainStroke.Color = Color3.fromRGB(0, math.floor(150 * glow) + 100, 255)
                ToggleStroke.Color = Color3.fromRGB(0, math.floor(150 * glow) + 100, 255)
            else
                MainStroke.Color = Color3.fromRGB(0, 120, 200)
            end
        end)
    end)

    -- Sistema de Arrastre Táctil (Android) con Guardado de Posición
    local dragging, dragInput, dragStart, startPos

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()  
                if input.UserInputState == Enum.UserInputState.End then  
                    dragging = false  
                    pcall(function()
                        if Config then
                            Config["CapaAimbotPos"] = {MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset}
                            if saveConfig then saveConfig() end
                        end
                    end)
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

    -- Lógica de Minimizar
    MinimizeBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            MainFrame:TweenSize(UDim2.new(0, 160, 0, 30), "Out", "Quad", 0.2, true)
            ToggleBtn.Visible = false
            MinimizeBtn.Text = "+"
        else
            MainFrame:TweenSize(UDim2.new(0, 160, 0, 75), "Out", "Quad", 0.2, true)
            ToggleBtn.Visible = true
            MinimizeBtn.Text = "—"
        end
    end)

    -- Lógica del Botón Interno
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

    -- Búsqueda del Objetivo (360 Grados)
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not AimbotEnabled then return end

            local Target = nil  
            local ShortestDistance = math.huge  
              
            local MyCharacter = LocalPlayer.Character  
            local MyRoot = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")  

            for _, v in pairs(Players:GetPlayers()) do  
                if v ~= LocalPlayer and not WhitelistedUsers[v.Name] and not WhitelistedUsers[v.DisplayName] and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then  
                    local Hitbox = v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("HumanoidRootPart")  
                    if Hitbox and (v.Team ~= LocalPlayer.Team or v.Team == nil) then  
                        if MyRoot then  
                            local Distance = (Hitbox.Position - MyRoot.Position).Magnitude  
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

    -- Intercepción del Disparo (Wallbang) protegido
    pcall(function()
        local OldNamecall
        OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local Args = {...}
            local Method = getnamecallmethod()

            if AimbotEnabled and CurrentTarget and not checkcaller() then  
                if string.find(Method, "FindPartOnRay") then  
                    return CurrentTarget, CurrentTarget.Position, Vector3.new(0, 1, 0), Enum.Material.Plastic  
                elseif Method == "Raycast" then  
                    local Origin = Args[1]  
                    local Direction = (CurrentTarget.Position - Origin).Unit * 10000  
                      
                    local WallbangParams = RaycastParams.new()  
                    WallbangParams.FilterType = Enum.RaycastFilterType.Include  
                    WallbangParams.FilterDescendantsInstances = {CurrentTarget.Parent}  
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
    end)

    -- Integración con tu función global `createToggle`
    createToggle("Capa laser aim", function(state)
        MainFrame.Visible = state
        
        if not state then
            AimbotEnabled = false
            ToggleBtn.Text = "AIMBOT: OFF"
            ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
            ToggleStroke.Color = Color3.fromRGB(100, 100, 100)
            CurrentTarget = nil
        end
    end)
end


-- ========================================================
-- TOKITO PVP SCRIPT V3 (SOLO LASER) - CON MEMORIA Y ESTABLE
-- ========================================================

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")

    local LocalPlayer = Players.LocalPlayer
    Config = Config or {}

    -- ================= ANTI BEE (POR DEFECTO) =================
    local antiBeeEnabled = false
    local antiBeeConnections = {}
    local antiBeeData = {
        originalMoveFunction = nil,
        controlsProtected = false,
        badLightingNames = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true }
    }

    local function destroyBeeEffect(obj)
        pcall(function()
            if not obj or not obj.Parent then return end
            if antiBeeData.badLightingNames[obj.Name] then
                obj:Destroy()
            end
        end)
    end

    local function protectControls()
        if antiBeeData.controlsProtected then return end
        pcall(function()
            local PlayerModule = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
            if not PlayerModule then return end
            local Controls = require(PlayerModule):GetControls()
            if not Controls then return end
            if not antiBeeData.originalMoveFunction then
                antiBeeData.originalMoveFunction = Controls.moveFunction
            end
            local function protectedMove(self, moveVector, relativeToCamera)
                pcall(function()
                    if antiBeeData.originalMoveFunction then
                        antiBeeData.originalMoveFunction(self, moveVector, relativeToCamera)
                    end
                end)
            end
            Controls.moveFunction = protectedMove
            table.insert(antiBeeConnections, RunService.Heartbeat:Connect(function()
                pcall(function()
                    if not antiBeeEnabled then return end
                    if Controls.moveFunction ~= protectedMove then
                        Controls.moveFunction = protectedMove
                    end
                end)
            end))
            antiBeeData.controlsProtected = true
        end)
    end

    local function blockBuzzing()
        pcall(function()
            local beeScript = LocalPlayer.PlayerScripts:FindFirstChild("Bee", true)
            if beeScript then
                local buzzing = beeScript:FindFirstChild("Buzzing")
                if buzzing and buzzing:IsA("Sound") then
                    buzzing:Stop()
                    buzzing.Volume = 0
                end
            end
        end)
    end

    local function lockFOV()
        pcall(function()
            local cam = Workspace.CurrentCamera
            if cam then cam.FieldOfView = 70 end
        end)
    end

    local function enableAntiBee()
        if antiBeeEnabled then return end
        antiBeeEnabled = true
        pcall(function()
            for _, obj in ipairs(Lighting:GetDescendants()) do destroyBeeEffect(obj) end
        end)
        table.insert(antiBeeConnections, Lighting.DescendantAdded:Connect(function(obj)
            pcall(function()
                if antiBeeEnabled then destroyBeeEffect(obj) end
            end)
        end))
        protectControls()
        table.insert(antiBeeConnections, RunService.Heartbeat:Connect(function()
            pcall(function()
                if not antiBeeEnabled then return end
                blockBuzzing()
                lockFOV()
            end)
        end))
    end

    pcall(enableAntiBee)

    -- ================= HERRAMIENTA LASER =================
    local function getLaserTool()
        local success, result = pcall(function()
            local char = LocalPlayer.Character
            local backpack = LocalPlayer.Backpack
            if not char or not backpack then return nil end
            
            local function searchFolder(folder)
                for _, item in ipairs(folder:GetChildren()) do
                    if item:IsA("Tool") and string.find(string.lower(item.Name), "laser") then
                        return item
                    end
                end
                return nil
            end
            return searchFolder(char) or searchFolder(backpack)
        end)
        if success then return result end
        return nil
    end

    -- ================= INTERFAZ GRÁFICA CON TOGGLE Y POSICIÓN =================
    local tokitoGui = nil
    local tokitoConnections = {}

    local function createTokitoGui()
        pcall(function()
            if tokitoGui then tokitoGui:Destroy() end
        end)

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "TokitoPvPGUI"
        ScreenGui.ResetOnSpawn = false
        
        -- Asignación segura de UI (Evita el WaitForChild que rompía todo)
        local parentSuccess, coreGuiResult = pcall(function() return gethui() or game:GetService("CoreGui") end)
        ScreenGui.Parent = parentSuccess and coreGuiResult or game:GetService("CoreGui")
        
        tokitoGui = ScreenGui

        local uiWidth = 140
        local uiHeight = 85 

        -- Posición por defecto
        local defaultPos = UDim2.new(0.5, -(uiWidth/2), 0.5, -(uiHeight/2))
        local framePos = defaultPos
        
        pcall(function()
            if Config and Config["TokitoPos"] then
                local p = Config["TokitoPos"]
                if type(p) == "table" and #p >= 4 then
                    framePos = UDim2.new(p[1], p[2], p[3], p[4])
                end
            end
        end)

        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, uiWidth, 0, uiHeight)
        MainFrame.Position = framePos
        MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Parent = MainFrame
        UIStroke.Thickness = 2
        UIStroke.Color = Color3.fromRGB(0, 170, 255)

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = MainFrame

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.BackgroundTransparency = 1
        Title.Text = "Auto Laser"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.Parent = MainFrame

        local Line = Instance.new("Frame")
        Line.Size = UDim2.new(1, -20, 0, 1)
        Line.Position = UDim2.new(0, 10, 0, 30)
        Line.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        Line.BorderSizePixel = 0
        Line.Parent = MainFrame

        -- ================= LÓGICA DE ARRASTRE (Igual al Aimbot) =================
        local dragging, dragInput, dragStart, startPos
        MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position

                input.Changed:Connect(function()  
                    if input.UserInputState == Enum.UserInputState.End then  
                        if dragging then
                            dragging = false  
                            pcall(function()
                                if Config then
                                    Config["TokitoPos"] = {MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset}
                                    if saveConfig then saveConfig() end
                                end
                            end)
                        end
                    end  
                end)  
            end
        end)

        MainFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        table.insert(tokitoConnections, UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end))
        -- ========================================================================

        table.insert(tokitoConnections, RunService.RenderStepped:Connect(function()
            pcall(function()
                if not ScreenGui.Parent then return end
                local t = tick() * 2
                local blueShade = Color3.fromHSV(0.55 + (math.sin(t) * 0.05), 1, 1)
                UIStroke.Color = blueShade
                Line.BackgroundColor3 = blueShade
                Title.TextColor3 = blueShade
            end)
        end))

        -- Botón de Laser
        local laserBtn = Instance.new("TextButton")
        laserBtn.Size = UDim2.new(0.8, 0, 0, 35)
        laserBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
        laserBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
        laserBtn.TextColor3 = Color3.new(1, 1, 1)
        laserBtn.Font = Enum.Font.GothamSemibold
        laserBtn.TextSize = 13
        laserBtn.Text = "Activar Laser"
        laserBtn.Parent = MainFrame
        Instance.new("UICorner", laserBtn).CornerRadius = UDim.new(0, 6)

        -- LÓGICA DEL LÁSER
        local laserActive = false
        laserBtn.MouseButton1Click:Connect(function()
            pcall(function()
                laserActive = not laserActive
                
                if laserActive then
                    local tool = getLaserTool()
                    if not tool then
                        laserActive = false
                        return
                    end
                    
                    laserBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                    laserBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                    laserBtn.Text = "Laser Activo"
                    
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                    if hum then hum:EquipTool(tool) end
                    
                    task.spawn(function()
                        while laserActive do
                            local success = pcall(function()
                                if not tool or tool.Parent ~= LocalPlayer.Character then
                                    laserActive = false
                                    laserBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
                                    laserBtn.TextColor3 = Color3.new(1, 1, 1)
                                    laserBtn.Text = "Activar Laser"
                                    return
                                end
                                tool:Activate()
                            end)
                            if not success or not laserActive then break end
                            task.wait(0.02)
                        end
                    end)
                else
                    laserBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
                    laserBtn.TextColor3 = Color3.new(1, 1, 1)
                    laserBtn.Text = "Activar Laser"
                end
            end)
        end)
    end

    local function destroyTokitoGui()
        pcall(function()
            for _, conn in ipairs(tokitoConnections) do
                if conn then conn:Disconnect() end
            end
            tokitoConnections = {}
            if tokitoGui then
                tokitoGui:Destroy()
                tokitoGui = nil
            end
        end)
    end

    -- Integración con el sistema de Toggles
    if createToggle then
        createToggle("Auto Spam Laser (Se ocupa tener activo aimbot)", function(state)
            if state then
                createTokitoGui()
            else
                destroyTokitoGui()
            end
        end)
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
-- ================= ESP BEST + BRAINROT MANAGER =================

local ignoredAnimals = ignoredAnimals or setmetatable({}, { __mode = "k" }) -- [BasePart] = data
local firstBrainrotMenuOpen = true

local brainrotLauncherGui = nil
local brainrotMenuGui = nil
local brainrotMenuFrame = nil
local brainrotMenuBody = nil
local brainrotMenuMinBtn = nil
local brainrotMenuHiddenList = nil
local brainrotMenuBestName = nil
local brainrotMenuBestValue = nil
local brainrotMenuBestGen = nil
local brainrotMenuHiddenCount = nil

local brainrotMenuMinimized = false
local brainrotNoticeShown = false

local animalESPEnabled = false
local espObjects = espObjects or {}
local animalESPCache = animalESPCache or {}
local animalESPThreshold = 0
local Connections = Connections or {}

local bestAnimalPart = nil
local bestAnimalValue = 0
local bestAnimalName = "Unknown"
local bestAnimalGenerationText = ""

local currentBeam = nil
local currentAttachments = {}

local toggleBrainrotMenu

local function formatBrainrotValue(value)
	if not value or value <= 0 then
		return "$0/s"
	end

	if value >= 1000000000000 then
		return string.format("$%.2fT/s", value / 1000000000000)
	elseif value >= 1000000000 then
		return string.format("$%.2fB/s", value / 1000000000)
	elseif value >= 1000000 then
		return string.format("$%.2fM/s", value / 1000000)
	elseif value >= 1000 then
		return string.format("$%.2fK/s", value / 1000)
	end

	return string.format("$%d/s", math.floor(value))
end

local function parseAnimalData(part)
	if not part or not part.Parent then
		return nil
	end

	local animalOverhead = part:FindFirstChild("AnimalOverhead")
	if not animalOverhead or not animalOverhead:IsA("SurfaceGui") then
		return nil
	end

	local generationLabel = animalOverhead:FindFirstChild("Generation")
	local displayNameLabel = animalOverhead:FindFirstChild("DisplayName")

	if not generationLabel or not displayNameLabel then
		return nil
	end

	local generationText = generationLabel.Text or ""
	local animalName = displayNameLabel.Text or "Unknown"

	if generationText == "" or animalName == "" then
		return nil
	end

	local firstValue = generationText:match("^%$([^%s]+)/s") or generationText:match("^%$([^/]+)/s")
	if not firstValue then
		return nil
	end

	local cleanText = firstValue:gsub(" ", "")
	local multiplier = 1
	local value = cleanText

	if cleanText:find("T") then
		multiplier = 1000000000000
		value = cleanText:gsub("T", "")
	elseif cleanText:find("B") then
		multiplier = 1000000000
		value = cleanText:gsub("B", "")
	elseif cleanText:find("M") then
		multiplier = 1000000
		value = cleanText:gsub("M", "")
	elseif cleanText:find("K") then
		multiplier = 1000
		value = cleanText:gsub("K", "")
	end

	local numValue = tonumber(value)
	local earningValue = numValue and (numValue * multiplier) or 0

	return earningValue, animalName, generationText
end

local function clearAllESP()
	for _, obj in ipairs(espObjects) do
		if obj then
			pcall(function()
				obj:Destroy()
			end)
		end
	end

	espObjects = {}

	if currentBeam then
		pcall(function()
			currentBeam:Destroy()
		end)
		currentBeam = nil
	end

	for _, att in pairs(currentAttachments) do
		pcall(function()
			att:Destroy()
		end)
	end

	currentAttachments = {}
end

local function createBeam(part)
	if currentBeam then
		pcall(function()
			currentBeam:Destroy()
		end)
		currentBeam = nil
	end

	for _, att in pairs(currentAttachments) do
		pcall(function()
			att:Destroy()
		end)
	end

	currentAttachments = {}

	local character = game.Players.LocalPlayer.Character
	if not character then
		return
	end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local attachment0 = Instance.new("Attachment")
	attachment0.Parent = hrp

	local attachment1 = Instance.new("Attachment")
	attachment1.Parent = part

	local beam = Instance.new("Beam")
	beam.Attachment0 = attachment0
	beam.Attachment1 = attachment1
	beam.Width0 = 0.4
	beam.Width1 = 0.4
	beam.FaceCamera = true
	beam.LightEmission = 1
	beam.Brightness = 5
	beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 120))
	beam.Parent = hrp

	currentBeam = beam
	currentAttachments = { attachment0, attachment1 }
end

local function showBrainrotNotice()
	if brainrotNoticeShown then
		return
	end

	brainrotNoticeShown = true

	local CoreGui = game:GetService("CoreGui")
	pcall(function()
		local old = CoreGui:FindFirstChild("BrainrotNotice")
		if old then
			old:Destroy()
		end
	end)

	local notifGui = Instance.new("ScreenGui")
	notifGui.Name = "BrainrotNotice"
	notifGui.ResetOnSpawn = false
	notifGui.IgnoreGuiInset = true
	notifGui.Parent = CoreGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 360, 0, 90)
	frame.Position = UDim2.new(0.5, -180, 0.08, 0)
	frame.BackgroundColor3 = Color3.fromRGB(12, 16, 35)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = notifGui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(0, 170, 255)
	stroke.Transparency = 0.15
	stroke.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -16, 0, 24)
	title.Position = UDim2.new(0, 8, 0, 8)
	title.BackgroundTransparency = 1
	title.Text = "TokitoHub"
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 20
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Parent = frame

	local msg = Instance.new("TextLabel")
	msg.Size = UDim2.new(1, -16, 0, 38)
	msg.Position = UDim2.new(0, 8, 0, 36)
	msg.BackgroundTransparency = 1
	msg.TextWrapped = true
msg.Text = "Oculta el brainrot más valioso para que no lo marque. Al actualizar reinicia el ESP."
	msg.Font = Enum.Font.GothamBold
	msg.TextSize = 13
	msg.TextColor3 = Color3.fromRGB(230, 240, 255)
	msg.Parent = frame

	task.delay(7, function()
		pcall(function()
			notifGui:Destroy()
		end)
	end)
end

local function updateBrainrotMenu()
	if not brainrotMenuGui or not brainrotMenuGui.Parent then
		return
	end

	if brainrotMenuBestName then
		if bestAnimalPart and bestAnimalPart.Parent then
			brainrotMenuBestName.Text = "Actual: " .. tostring(bestAnimalName or "Unknown")
		else
			brainrotMenuBestName.Text = "Actual: Ninguno"
		end
	end

	if brainrotMenuBestValue then
		if bestAnimalPart and bestAnimalPart.Parent then
			brainrotMenuBestValue.Text = "Valor: " .. formatBrainrotValue(bestAnimalValue)
		else
			brainrotMenuBestValue.Text = "Valor: $0/s"
		end
	end

	if brainrotMenuBestGen then
		if bestAnimalPart and bestAnimalPart.Parent then
			brainrotMenuBestGen.Text = tostring(bestAnimalGenerationText or "")
		else
			brainrotMenuBestGen.Text = "Sin brainrot detectado"
		end
	end

	if brainrotMenuHiddenCount then
		local count = 0
		for _ in pairs(ignoredAnimals) do
			count += 1
		end
		brainrotMenuHiddenCount.Text = "Ocultados: " .. count
	end

	if brainrotMenuHiddenList then
		for _, child in ipairs(brainrotMenuHiddenList:GetChildren()) do
			if child:IsA("Frame") and child.Name == "HiddenEntry" then
				child:Destroy()
			end
		end

		local entries = {}
		for hiddenPart, data in pairs(ignoredAnimals) do
			if hiddenPart and data then
				table.insert(entries, {
					part = hiddenPart,
					name = data.name or "Unknown",
					value = data.value or 0,
					gen = data.generation or ""
				})
			end
		end

		table.sort(entries, function(a, b)
			return (a.value or 0) > (b.value or 0)
		end)

		for _, item in ipairs(entries) do
			local row = Instance.new("Frame")
			row.Name = "HiddenEntry"
			row.Size = UDim2.new(1, -4, 0, 34)
			row.BackgroundColor3 = Color3.fromRGB(20, 30, 48)
			row.BorderSizePixel = 0
			row.Parent = brainrotMenuHiddenList
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -60, 1, 0)
			label.Position = UDim2.new(0, 8, 0, 0)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Text = item.name .. "  |  " .. formatBrainrotValue(item.value)
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.Font = Enum.Font.GothamBold
			label.TextSize = 11
			label.Parent = row

			local unhide = Instance.new("TextButton")
			unhide.Size = UDim2.new(0, 44, 0, 22)
			unhide.Position = UDim2.new(1, -50, 0.5, -11)
			unhide.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
			unhide.Text = "Ver"
			unhide.TextColor3 = Color3.fromRGB(255, 255, 255)
			unhide.Font = Enum.Font.GothamBold
			unhide.TextSize = 11
			unhide.BorderSizePixel = 0
			unhide.Parent = row
			Instance.new("UICorner", unhide).CornerRadius = UDim.new(0, 6)

			unhide.MouseButton1Click:Connect(function()
				if item.part then
					ignoredAnimals[item.part] = nil
				end
				local debris = workspace:FindFirstChild("Debris")
				if debris then
					rebuildBestAnimal(debris)
				end
				updateBrainrotMenu()
			end)
		end
	end
end

local function hideCurrentBestBrainrot()
	if not bestAnimalPart or not bestAnimalPart.Parent then
		return
	end

	ignoredAnimals[bestAnimalPart] = {
		name = bestAnimalName or "Unknown",
		value = bestAnimalValue or 0,
		generation = bestAnimalGenerationText or ""
	}

	local debris = workspace:FindFirstChild("Debris")
	if debris then
		rebuildBestAnimal(debris)
	end

	updateBrainrotMenu()
end

local function showAllBrainrots()
	table.clear(ignoredAnimals)

	local debris = workspace:FindFirstChild("Debris")
	if debris then
		rebuildBestAnimal(debris)
	end

	updateBrainrotMenu()
end

local function setBrainrotMenuMinimized(state)
	brainrotMenuMinimized = state

	if brainrotMenuBody then
		brainrotMenuBody.Visible = not state
	end

	if brainrotMenuFrame then
		brainrotMenuFrame.Size = state and UDim2.new(0, 280, 0, 34) or UDim2.new(0, 280, 0, 250)
	end

	if brainrotMenuMinBtn then
		brainrotMenuMinBtn.Text = state and "+" or "—"
	end
end

local function createBrainrotLauncher()
	if brainrotLauncherGui then
		return
	end

	brainrotLauncherGui = Instance.new("TextButton")
	brainrotLauncherGui.Name = "BrainrotLauncher"
	brainrotLauncherGui.Size = UDim2.new(0, 40, 0, 40)
	brainrotLauncherGui.Position = UDim2.new(0, 16, 0, 260)
	brainrotLauncherGui.BackgroundColor3 = Color3.fromRGB(14, 20, 34)
	brainrotLauncherGui.BorderSizePixel = 0
	brainrotLauncherGui.Text = "BR"
	brainrotLauncherGui.TextColor3 = Color3.fromRGB(255, 255, 255)
	brainrotLauncherGui.Font = Enum.Font.GothamBlack
	brainrotLauncherGui.TextSize = 14
	brainrotLauncherGui.Parent = gui
	brainrotLauncherGui.Active = true
	Instance.new("UICorner", brainrotLauncherGui).CornerRadius = UDim.new(1, 0)

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Transparency = 0.1
	stroke.Color = Color3.fromRGB(0, 170, 255)
	stroke.Parent = brainrotLauncherGui

	local scale = Instance.new("UIScale")
	scale.Scale = 1
	scale.Parent = brainrotLauncherGui

	brainrotLauncherGui.MouseEnter:Connect(function()
		TweenService:Create(scale, TweenInfo.new(0.12), { Scale = 1.08 }):Play()
	end)

	brainrotLauncherGui.MouseLeave:Connect(function()
		TweenService:Create(scale, TweenInfo.new(0.12), { Scale = 1 }):Play()
	end)

	brainrotLauncherGui.MouseButton1Click:Connect(function()
		toggleBrainrotMenu()
	end)

	local dragging = false
	local dragStart
	local startPos
	local dragInput

	brainrotLauncherGui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = brainrotLauncherGui.Position
		end
	end)

	brainrotLauncherGui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			brainrotLauncherGui.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	brainrotLauncherGui.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

local function createBrainrotMenu()
	if brainrotMenuGui then
		brainrotMenuGui.Visible = true
		updateBrainrotMenu()
		return
	end

	brainrotMenuGui = Instance.new("Frame")
	brainrotMenuGui.Name = "BrainrotMenu"
	brainrotMenuGui.Size = UDim2.new(0, 280, 0, 250)
	brainrotMenuGui.Position = UDim2.new(0.5, -140, 0.28, 0)
	brainrotMenuGui.BackgroundColor3 = Color3.fromRGB(12, 18, 31)
	brainrotMenuGui.BorderSizePixel = 0
	brainrotMenuGui.Parent = gui
	brainrotMenuGui.Active = true
	Instance.new("UICorner", brainrotMenuGui).CornerRadius = UDim.new(0, 12)

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Transparency = 0.1
	stroke.Color = Color3.fromRGB(0, 170, 255)
	stroke.Parent = brainrotMenuGui

	local topbar = Instance.new("Frame")
	topbar.Name = "Topbar"
	topbar.Size = UDim2.new(1, 0, 0, 30)
	topbar.BackgroundColor3 = Color3.fromRGB(18, 28, 45)
	topbar.BorderSizePixel = 0
	topbar.Parent = brainrotMenuGui
	Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 12)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -70, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "Brainrot Manager"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 13
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = topbar

	brainrotMenuMinBtn = Instance.new("TextButton")
	brainrotMenuMinBtn.Size = UDim2.new(0, 22, 0, 18)
	brainrotMenuMinBtn.Position = UDim2.new(1, -46, 0, 6)
	brainrotMenuMinBtn.BackgroundColor3 = Color3.fromRGB(28, 46, 78)
	brainrotMenuMinBtn.Text = "—"
	brainrotMenuMinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	brainrotMenuMinBtn.Font = Enum.Font.GothamBold
	brainrotMenuMinBtn.TextSize = 16
	brainrotMenuMinBtn.BorderSizePixel = 0
	brainrotMenuMinBtn.Parent = topbar
	Instance.new("UICorner", brainrotMenuMinBtn).CornerRadius = UDim.new(0, 6)

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 22, 0, 18)
	closeBtn.Position = UDim2.new(1, -22, 0, 6)
	closeBtn.BackgroundColor3 = Color3.fromRGB(40, 28, 55)
	closeBtn.Text = "X"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 12
	closeBtn.BorderSizePixel = 0
	closeBtn.Parent = topbar
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

	brainrotMenuBody = Instance.new("Frame")
	brainrotMenuBody.Name = "Body"
	brainrotMenuBody.Size = UDim2.new(1, -10, 1, -36)
	brainrotMenuBody.Position = UDim2.new(0, 5, 0, 33)
	brainrotMenuBody.BackgroundTransparency = 1
	brainrotMenuBody.Parent = brainrotMenuGui

	local bestName = Instance.new("TextLabel")
	brainrotMenuBestName = bestName
	bestName.Size = UDim2.new(1, 0, 0, 18)
	bestName.Position = UDim2.new(0, 0, 0, 0)
	bestName.BackgroundTransparency = 1
	bestName.TextXAlignment = Enum.TextXAlignment.Left
	bestName.TextColor3 = Color3.fromRGB(255, 255, 255)
	bestName.Font = Enum.Font.GothamBold
	bestName.TextSize = 12
	bestName.Parent = brainrotMenuBody

	local bestValue = Instance.new("TextLabel")
	brainrotMenuBestValue = bestValue
	bestValue.Size = UDim2.new(1, 0, 0, 18)
	bestValue.Position = UDim2.new(0, 0, 0, 18)
	bestValue.BackgroundTransparency = 1
	bestValue.TextXAlignment = Enum.TextXAlignment.Left
	bestValue.TextColor3 = Color3.fromRGB(0, 255, 120)
	bestValue.Font = Enum.Font.GothamBold
	bestValue.TextSize = 12
	bestValue.Parent = brainrotMenuBody

	local bestGen = Instance.new("TextLabel")
	brainrotMenuBestGen = bestGen
	bestGen.Size = UDim2.new(1, 0, 0, 18)
	bestGen.Position = UDim2.new(0, 0, 0, 36)
	bestGen.BackgroundTransparency = 1
	bestGen.TextXAlignment = Enum.TextXAlignment.Left
	bestGen.TextColor3 = Color3.fromRGB(180, 200, 255)
	bestGen.Font = Enum.Font.Gotham
	bestGen.TextSize = 11
	bestGen.TextWrapped = true
	bestGen.Parent = brainrotMenuBody

	local hiddenCount = Instance.new("TextLabel")
	brainrotMenuHiddenCount = hiddenCount
	hiddenCount.Size = UDim2.new(1, 0, 0, 18)
	hiddenCount.Position = UDim2.new(0, 0, 0, 56)
	hiddenCount.BackgroundTransparency = 1
	hiddenCount.TextXAlignment = Enum.TextXAlignment.Left
	hiddenCount.TextColor3 = Color3.fromRGB(255, 255, 255)
	hiddenCount.Font = Enum.Font.GothamBold
	hiddenCount.TextSize = 11
	hiddenCount.Parent = brainrotMenuBody

	local hideBtn = Instance.new("TextButton")
	hideBtn.Size = UDim2.new(0.49, -3, 0, 28)
	hideBtn.Position = UDim2.new(0, 0, 0, 78)
	hideBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	hideBtn.Text = "Ocultar actual"
	hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	hideBtn.Font = Enum.Font.GothamBold
	hideBtn.TextSize = 11
	hideBtn.BorderSizePixel = 0
	hideBtn.Parent = brainrotMenuBody
	Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 8)

	local showAllBtn = Instance.new("TextButton")
	showAllBtn.Size = UDim2.new(0.49, -3, 0, 28)
	showAllBtn.Position = UDim2.new(0.51, 0, 0, 78)
	showAllBtn.BackgroundColor3 = Color3.fromRGB(26, 40, 66)
	showAllBtn.Text = "Mostrar todos"
	showAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	showAllBtn.Font = Enum.Font.GothamBold
	showAllBtn.TextSize = 11
	showAllBtn.BorderSizePixel = 0
	showAllBtn.Parent = brainrotMenuBody
	Instance.new("UICorner", showAllBtn).CornerRadius = UDim.new(0, 8)

	local refreshBtn = Instance.new("TextButton")
	refreshBtn.Size = UDim2.new(1, 0, 0, 24)
	refreshBtn.Position = UDim2.new(0, 0, 0, 110)
	refreshBtn.BackgroundColor3 = Color3.fromRGB(24, 34, 52)
	refreshBtn.Text = "Actualizar"
	refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	refreshBtn.Font = Enum.Font.GothamBold
	refreshBtn.TextSize = 11
	refreshBtn.BorderSizePixel = 0
	refreshBtn.Parent = brainrotMenuBody
	Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 8)

	brainrotMenuHiddenList = Instance.new("ScrollingFrame")
	brainrotMenuHiddenList.Name = "HiddenList"
	brainrotMenuHiddenList.Size = UDim2.new(1, 0, 1, -142)
	brainrotMenuHiddenList.Position = UDim2.new(0, 0, 0, 138)
	brainrotMenuHiddenList.BackgroundTransparency = 1
	brainrotMenuHiddenList.BorderSizePixel = 0
	brainrotMenuHiddenList.ScrollBarThickness = 4
	brainrotMenuHiddenList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	brainrotMenuHiddenList.CanvasSize = UDim2.new(0, 0, 0, 0)
	brainrotMenuHiddenList.Parent = brainrotMenuBody

	local listPadding = Instance.new("UIPadding")
	listPadding.PaddingTop = UDim.new(0, 2)
	listPadding.PaddingBottom = UDim.new(0, 2)
	listPadding.Parent = brainrotMenuHiddenList

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 4)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = brainrotMenuHiddenList

	hideBtn.MouseButton1Click:Connect(function()
		hideCurrentBestBrainrot()
	end)

	showAllBtn.MouseButton1Click:Connect(function()
		showAllBrainrots()
	end)

	refreshBtn.MouseButton1Click:Connect(function()
		local debris = workspace:FindFirstChild("Debris")
		if debris then
			rebuildBestAnimal(debris)
		end
		updateBrainrotMenu()
	end)

	brainrotMenuMinBtn.MouseButton1Click:Connect(function()
		setBrainrotMenuMinimized(not brainrotMenuMinimized)
	end)

	closeBtn.MouseButton1Click:Connect(function()
		brainrotMenuGui.Visible = false
	end)

	local dragging = false
	local dragStart
	local startPos
	local dragInput

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = brainrotMenuGui.Position
		end
	end)

	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			brainrotMenuGui.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	topbar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	createBrainrotLauncher()
	updateBrainrotMenu()
end

toggleBrainrotMenu = function()
	if not brainrotNoticeShown then
		showBrainrotNotice()
	end

	if not brainrotMenuGui then
		createBrainrotMenu()
		brainrotMenuGui.Visible = true
		updateBrainrotMenu()
		return
	end

	if not brainrotMenuGui.Visible then
		brainrotMenuGui.Visible = true
		updateBrainrotMenu()
		return
	end

	if brainrotMenuMinimized then
		setBrainrotMenuMinimized(false)
	else
		brainrotMenuGui.Visible = false
	end
end

local function clearBrainrotMenuStateIfNeeded()
	if brainrotMenuGui and not brainrotMenuGui.Parent then
		brainrotMenuGui = nil
		brainrotMenuFrame = nil
		brainrotMenuBody = nil
		brainrotMenuMinBtn = nil
		brainrotMenuHiddenList = nil
		brainrotMenuBestName = nil
		brainrotMenuBestValue = nil
		brainrotMenuBestGen = nil
		brainrotMenuHiddenCount = nil
		brainrotLauncherGui = nil
	end
end

local function createESPForPart(part)
	if bestAnimalPart and (not bestAnimalPart.Parent or not bestAnimalPart:IsDescendantOf(workspace)) then
		bestAnimalPart = nil
		bestAnimalValue = 0
		bestAnimalName = "Unknown"
		bestAnimalGenerationText = ""
		clearAllESP()
	end

	if not part or not part.Parent then
		return
	end

	local earningValue, animalName, generationText = parseAnimalData(part)
	if not earningValue then
		return
	end

	if ignoredAnimals[part] then
		return
	end

	if earningValue < animalESPThreshold then
		return
	end

	if earningValue < bestAnimalValue then
		return
	end

	bestAnimalValue = earningValue
	bestAnimalPart = part
	bestAnimalName = animalName
	bestAnimalGenerationText = generationText

	clearAllESP()

	if animalESPCache[part] then
		pcall(function()
			animalESPCache[part]:Destroy()
		end)
		animalESPCache[part] = nil
	end

	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Name = "AnimalESP"
	billboardGui.Adornee = part
	billboardGui.Size = UDim2.new(0, 260, 0, 70)
	billboardGui.StudsOffset = Vector3.new(0, -3, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = part

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0, 30)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = animalName
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextStrokeTransparency = 0
	nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 24
	nameLabel.Parent = billboardGui

	local genLabel = Instance.new("TextLabel")
	genLabel.Size = UDim2.new(1, 0, 0, 30)
	genLabel.Position = UDim2.new(0, 0, 0, 30)
	genLabel.BackgroundTransparency = 1
	genLabel.Text = generationText
	genLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
	genLabel.TextStrokeTransparency = 0
	genLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	genLabel.Font = Enum.Font.GothamBold
	genLabel.TextSize = 22
	genLabel.Parent = billboardGui

	animalESPCache[part] = billboardGui
	table.insert(espObjects, billboardGui)

	createBeam(part)
	updateBrainrotMenu()
end

local function rebuildBestAnimal(debris)
	bestAnimalPart = nil
	bestAnimalValue = 0
	bestAnimalName = "Unknown"
	bestAnimalGenerationText = ""
	clearAllESP()

	local bestPart = nil
	local bestValue = 0
	local bestName = "Unknown"
	local bestGen = ""

	for _, newPart in pairs(debris:GetChildren()) do
		if newPart.Name == "FastOverheadTemplate" and newPart:IsA("BasePart") then
			local earningValue, animalName, generationText = parseAnimalData(newPart)

			if earningValue and not ignoredAnimals[newPart] then
				if earningValue >= animalESPThreshold and earningValue > bestValue then
					bestValue = earningValue
					bestPart = newPart
					bestName = animalName
					bestGen = generationText
				end
			end
		end
	end

	if bestPart then
		bestAnimalPart = bestPart
		bestAnimalValue = bestValue
		bestAnimalName = bestName
		bestAnimalGenerationText = bestGen
		createESPForPart(bestPart)
	else
		updateBrainrotMenu()
	end
end

local function startAnimalESP()
	animalESPEnabled = true
	bestAnimalPart = nil
	bestAnimalValue = 0
	bestAnimalName = "Unknown"
	bestAnimalGenerationText = ""

	local debris = workspace:FindFirstChild("Debris")
	if debris then
		rebuildBestAnimal(debris)

		if not Connections.animalESPAdded then
			Connections.animalESPAdded = debris.ChildAdded:Connect(function(part)
				if not animalESPEnabled then
					return
				end

				if part.Name == "FastOverheadTemplate" and part:IsA("BasePart") then
					task.wait(0.05)
					createESPForPart(part)
				end
			end)
		end

		if not Connections.animalESPRemoved then
			Connections.animalESPRemoved = debris.ChildRemoved:Connect(function(part)
				if animalESPCache[part] then
					pcall(function()
						animalESPCache[part]:Destroy()
					end)
					animalESPCache[part] = nil
				end

				if part == bestAnimalPart then
					rebuildBestAnimal(debris)
				else
					updateBrainrotMenu()
				end
			end)
		end
	end

	createBrainrotLauncher()
	updateBrainrotMenu()
end

local function stopAnimalESP()
	animalESPEnabled = false

	clearAllESP()
	animalESPCache = {}

	bestAnimalPart = nil
	bestAnimalValue = 0
	bestAnimalName = "Unknown"
	bestAnimalGenerationText = ""

	if Connections.animalESPAdded then
		Connections.animalESPAdded:Disconnect()
		Connections.animalESPAdded = nil
	end

	if Connections.animalESPRemoved then
		Connections.animalESPRemoved:Disconnect()
		Connections.animalESPRemoved = nil
	end

	updateBrainrotMenu()
end

createToggle("Esp Best", function(state)
	if state then
		startAnimalESP()
	else
		stopAnimalESP()
	end
end)

-- ================= END ESP BEST + BRAINROT MANAGER =================

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
-- ============================================================
--           TOKITO FPS BOOST :3 - MÓDULO DE TOGGLE FIXED
-- ============================================================

local TokitoFpsBoost = {
    Enabled = false,
    Connections = {},
    OriginalSettings = {},
    SavedObjects = {},
    GCLoop = nil
}

local Services = {
    Workspace = game:GetService("Workspace"),
    Lighting = game:GetService("Lighting")
}

local function SetFpsBoost(state)
    TokitoFpsBoost.Enabled = state

    if state then
        -- 1. Guardar y optimizar Lighting (Sin 'Technology' por seguridad de ejecución)
        pcall(function()
            TokitoFpsBoost.OriginalSettings.GlobalShadows = Services.Lighting.GlobalShadows
            TokitoFpsBoost.OriginalSettings.FogEnd = Services.Lighting.FogEnd
            
            Services.Lighting.GlobalShadows = false
            Services.Lighting.FogEnd = 9e9
        end)

        -- 2. Modificar partes progresivamente para evitar congelamiento de pantalla (Crash)
        task.spawn(function()
            local descendants = Services.Workspace:GetDescendants()
            for i, obj in ipairs(descendants) do
                if not TokitoFpsBoost.Enabled then break end -- Detener si se desactiva en medio del proceso
                
                pcall(function()
                    if obj:IsA("BasePart") and not TokitoFpsBoost.SavedObjects[obj] then
                        TokitoFpsBoost.SavedObjects[obj] = {
                            Material = obj.Material,
                            CastShadow = obj.CastShadow
                        }
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.CastShadow = false
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                        if obj.Enabled then
                            TokitoFpsBoost.SavedObjects[obj] = { Enabled = true }
                            obj.Enabled = false
                        end
                    end
                end)
                
                -- Ceder el hilo cada 500 objetos para mantener los FPS estables durante la carga
                if i % 500 == 0 then 
                    task.wait() 
                end
            end
        end)

        -- 3. Optimizar nuevos elementos en tiempo real
        local conn = Services.Workspace.DescendantAdded:Connect(function(obj)
            if not TokitoFpsBoost.Enabled then return end
            task.defer(function()
                pcall(function()
                    if obj:IsA("BasePart") then
                        obj.CastShadow = false
                        obj.Material = Enum.Material.SmoothPlastic
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                        obj.Enabled = false
                    end
                end)
            end)
        end)
        table.insert(TokitoFpsBoost.Connections, conn)

        -- 4. Colector de basura periódico seguro
        if TokitoFpsBoost.GCLoop then task.cancel(TokitoFpsBoost.GCLoop) end
        TokitoFpsBoost.GCLoop = task.spawn(function()
            while TokitoFpsBoost.Enabled do
                task.wait(60)
                pcall(function() collectgarbage("collect") end)
            end
        end)

    else
        -- RESTAURAR ESTADO ORIGINAL AL DESACTIVAR
        pcall(function()
            if TokitoFpsBoost.OriginalSettings.GlobalShadows ~= nil then
                Services.Lighting.GlobalShadows = TokitoFpsBoost.OriginalSettings.GlobalShadows
                Services.Lighting.FogEnd = TokitoFpsBoost.OriginalSettings.FogEnd
            end
        end)

        -- Restaurar objetos progresivamente
        task.spawn(function()
            local count = 0
            for obj, data in pairs(TokitoFpsBoost.SavedObjects) do
                count = count + 1
                if obj and obj.Parent then
                    pcall(function()
                        if data.Material then obj.Material = data.Material end
                        if data.CastShadow ~= nil then obj.CastShadow = data.CastShadow end
                        if data.Enabled ~= nil then obj.Enabled = data.Enabled end
                    end)
                end
                
                if count % 500 == 0 then task.wait() end
            end
            table.clear(TokitoFpsBoost.SavedObjects)
        end)

        -- Desconectar eventos activos
        for _, conn in ipairs(TokitoFpsBoost.Connections) do
            if typeof(conn) == "RBXScriptConnection" and conn.Connected then
                conn:Disconnect()
            end
        end
        table.clear(TokitoFpsBoost.Connections)
        
        -- Detener hilo de limpieza de RAM
        if TokitoFpsBoost.GCLoop then 
            task.cancel(TokitoFpsBoost.GCLoop)
            TokitoFpsBoost.GCLoop = nil
        end
    end
end

-- ============================================================
-- INTEGRACIÓN SEGURA EN EL MENÚ
-- ============================================================

pcall(function()
    createToggle("Tokito Fps Boost :3", function(state)
        -- Encapsulamos la ejecución para que, en caso extremo, el menú nunca se rompa
        local ok, err = pcall(function()
            SetFpsBoost(state)
        end)
        if not ok then
            warn("[Tokito Hub Safe Error]: Fps Boost falló internamente ->", tostring(err))
        end
    end)
end)

-- ============================================================
-- FPS BOOST V2
-- ============================================================
do
	local WorkspaceService = game:GetService("Workspace")
	local LightingService = game:GetService("Lighting")

	-- Protecciones para evitar errores si estas variables no existen en tu hub
	local _Config = type(Config) == "table" and Config or {}
	local _saveConfig = type(saveConfig) == "function" and saveConfig or function() end
	local _setToggle = type(setToggle) == "function" and setToggle or function() end

	local function IsProtected(obj)
		if not obj then return false end
		local name = obj.Name:lower()
		if name:find("laser") or name:find("door") or name:find("gate") or name:find("shield") or name:find("barrier") or name:find("fence") or name:find("forcefield") or name:find("wall") or name:find("protect") then
			return true
		end
		
		local parent = obj.Parent
		while parent and parent ~= WorkspaceService do
			local pName = parent.Name:lower()
			if pName:find("laser") or pName:find("door") or pName:find("gate") or pName:find("shield") or pName:find("barrier") or pName:find("fence") or pName:find("forcefield") or pName:find("wall") or pName:find("protect") then
				return true
			end
			parent = parent.Parent
		end
		return false
	end

	local fpsBoostV2Connection = nil

	local function setFPSBoostV2(enabled) 
		_Config.FPSBoostV2 = enabled
		_saveConfig()
		_setToggle("Fps Boost V2", enabled)

		if fpsBoostV2Connection then
			pcall(function() fpsBoostV2Connection:Disconnect() end)
			fpsBoostV2Connection = nil
		end

		if enabled then
			pcall(function()
				LightingService.GlobalShadows = false
				LightingService.Brightness = 2
				LightingService.FogEnd = 9e9
				LightingService.FogStart = 0
				LightingService.EnvironmentDiffuseScale = 0
				LightingService.EnvironmentSpecularScale = 0
			end)

			for _, v in pairs(LightingService:GetChildren()) do
				if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then 
					pcall(function() v.Enabled = false end) 
				elseif v:IsA("Atmosphere") then 
					pcall(function() v:Destroy() end) 
				end
			end

			-- Se envuelve en task.spawn para evitar que el hub se congele mientras optimiza el mapa
			task.spawn(function()
				for _, obj in ipairs(WorkspaceService:GetDescendants()) do
					if not _Config.FPSBoostV2 then break end -- Detiene el proceso si el usuario lo desactiva rápidamente
					
					if not IsProtected(obj) then
						if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then 
							pcall(function() obj.Enabled = false end) 
						end
						if obj:IsA("BasePart") then 
							pcall(function() 
								obj.Material = Enum.Material.Plastic
								obj.CastShadow = false 
							end) 
						end
						if obj:IsA("SurfaceAppearance") or obj:IsA("Texture") or obj:IsA("Decal") then 
							pcall(function() obj:Destroy() end) 
						end
					end
				end
			end)

			fpsBoostV2Connection = WorkspaceService.DescendantAdded:Connect(function(obj)
				if not _Config.FPSBoostV2 then return end
				if not IsProtected(obj) then
					if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") then 
						pcall(function() obj.Enabled = false end) 
					end
					if obj:IsA("BasePart") then 
						pcall(function() 
							obj.Material = Enum.Material.Plastic
							obj.CastShadow = false 
						end) 
					end
				end
			end)
		end
	end

	-- TOGGLE
	if type(createToggle) == "function" then
		createToggle("Fps Boost V2", function(state)
			setFPSBoostV2(state)
		end)
	else
		warn("[HUB] La función createToggle no está definida.")
	end
end
-- ============================================================
-- END FPS BOOST V2
-- ============================================================

-- ================= FPS BOOSTER =================

local fpsBoostEnabled = false
local fpsConnections = {}

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local function setFPSBoost(state)

	local Terrain = workspace:FindFirstChildOfClass("Terrain")

	-- TERRAIN
	if Terrain then
		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 0
	end

	-- LIGHTING + PERFORMANCE
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	settings().Rendering.QualityLevel = 1

	-- WORLD CLEAN
	for _, v in pairs(game:GetDescendants()) do
		pcall(function()
			if v:IsA("BasePart") then
				v.Material = Enum.Material.Plastic
				v.Reflectance = 0

			elseif v:IsA("Decal") then
				v.Transparency = 1

			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Lifetime = NumberRange.new(0)

			elseif v:IsA("Explosion") then
				v.BlastPressure = 0
				v.BlastRadius = 0
			end
		end)
	end

	-- EFFECTS CLEAN
	for _, v in pairs(Lighting:GetDescendants()) do
		if v:IsA("BlurEffect")
		or v:IsA("SunRaysEffect")
		or v:IsA("ColorCorrectionEffect")
		or v:IsA("BloomEffect")
		or v:IsA("DepthOfFieldEffect") then
			pcall(function()
				v.Enabled = false
			end)
		end
	end

	-- REMOVE NEW EFFECTS
	table.insert(fpsConnections,
		workspace.DescendantAdded:Connect(function(child)
			if not fpsBoostEnabled then return end

			task.spawn(function()
				pcall(function()
					if child:IsA("ForceField")
					or child:IsA("Sparkles")
					or child:IsA("Smoke")
					or child:IsA("Fire") then
						RunService.Heartbeat:Wait()
						child:Destroy()
					end
				end)
			end)
		end)
	)
end

local function enableFPSBoost()
	if fpsBoostEnabled then return end
	fpsBoostEnabled = true
	setFPSBoost(true)
end

local function disableFPSBoost()
	if not fpsBoostEnabled then return end
	fpsBoostEnabled = false

	for _, c in ipairs(fpsConnections) do
		pcall(function()
			c:Disconnect()
		end)
	end

	table.clear(fpsConnections)
end

-- TOGGLE
createToggle("FPS Booster", function(state)
	if state then
		enableFPSBoost()
	else
		disableFPSBoost()
	end
end)

-- ================= END FPS BOOSTER =================
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
-- ================= PREMIUM KICK PANEL =================

local kickButtonEnabled = false
local kickGui = nil

-- Calculamos el centro exacto basado en el tamaño del panel (140x65)
local defaultPosition = UDim2.new(0.5, -70, 0.5, -32.5) 
local lastPosition = defaultPosition 

-- Sistema de guardado persistente entre sesiones (si el ejecutor soporta writefile/readfile)
local saveFileName = "KickButton_LastPos.json"
local HttpService = game:GetService("HttpService")

pcall(function()
	if readfile and isfile and isfile(saveFileName) then
		local data = HttpService:JSONDecode(readfile(saveFileName))
		if data and data.XScale and data.XOffset and data.YScale and data.YOffset then
			lastPosition = UDim2.new(data.XScale, data.XOffset, data.YScale, data.YOffset)
		end
	end
end)

local function savePosition(pos)
	lastPosition = pos
	pcall(function()
		if writefile then
			local data = {
				XScale = pos.X.Scale,
				XOffset = pos.X.Offset,
				YScale = pos.Y.Scale,
				YOffset = pos.Y.Offset
			}
			writefile(saveFileName, HttpService:JSONEncode(data))
		end
	end)
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Variable global interna para limpiar la conexión de arrastre
local inputChangedConnection = nil

local function createKickButton()
	-- 1. GUI Principal
	local gui = Instance.new("ScreenGui")
	gui.Name = "KickGui"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	-- 2. Marco Principal (Fondo Base)
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 140, 0, 65)
	mainFrame.Position = lastPosition -- Carga el estado de la última posición (persistente o reseteada)
	mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mainFrame.Active = true
	mainFrame.ClipsDescendants = false
	mainFrame.Parent = gui

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 10)
	frameCorner.Parent = mainFrame

	-- Fondo Degradado Premium
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 45))
	}
	gradient.Rotation = 90
	gradient.Parent = mainFrame

	-- UIStroke con Efecto de Brillo Cian
	local frameStroke = Instance.new("UIStroke")
	frameStroke.Color = Color3.fromRGB(0, 170, 255)
	frameStroke.Thickness = 1.5
	frameStroke.Transparency = 0.2
	frameStroke.Parent = mainFrame

	-- Sombra Difuminada (Glow) usando ImageLabel
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	shadow.Size = UDim2.new(1, 30, 1, 30)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.4
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.ZIndex = mainFrame.ZIndex - 1
	shadow.Parent = mainFrame

	-- 3. Título con Icono Integrado
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -35, 0, 30)
	title.Position = UDim2.new(0, 12, 0, 2)
	title.BackgroundTransparency = 1
	title.Text = "⚡ KICK BOTON"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = mainFrame

	-- 4. Botón X (Cerrar)
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 22, 0, 22)
	closeBtn.Position = UDim2.new(1, -26, 0, 6)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 13
	closeBtn.Parent = mainFrame

	-- 5. Botón de Acción (Expulsar)
	local kickBtn = Instance.new("TextButton")
	kickBtn.Size = UDim2.new(1, -24, 0, 26)
	kickBtn.Position = UDim2.new(0, 12, 0, 28)
	kickBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	kickBtn.Text = "⚡ Kick"
	kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	kickBtn.TextStrokeTransparency = 0
	kickBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	kickBtn.Font = Enum.Font.GothamBold
	kickBtn.TextSize = 13
	kickBtn.Parent = mainFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = kickBtn

	local btnGradient = Instance.new("UIGradient")
	btnGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 220))
	}
	btnGradient.Rotation = 90
	btnGradient.Parent = kickBtn

	-- ==========================================
	-- ANIMACIONES Y EFECTOS VISUALES (TWEEN)
	-- ==========================================
	
	mainFrame.Size = UDim2.new(0, 0, 0, 0)
	mainFrame.BackgroundTransparency = 1
	shadow.ImageTransparency = 1
	frameStroke.Enabled = false
	title.TextTransparency = 1
	closeBtn.TextTransparency = 1
	kickBtn.BackgroundTransparency = 1
	kickBtn.TextTransparency = 1

	local openTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	TweenService:Create(mainFrame, openTweenInfo, {Size = UDim2.new(0, 140, 0, 65), BackgroundTransparency = 0}):Play()
	
	task.spawn(function()
		task.wait(0.15)
		frameStroke.Enabled = true
		local fadeInInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(shadow, fadeInInfo, {ImageTransparency = 0.4}):Play()
		TweenService:Create(title, fadeInInfo, {TextTransparency = 0}):Play()
		TweenService:Create(closeBtn, fadeInInfo, {TextTransparency = 0}):Play()
		TweenService:Create(kickBtn, fadeInInfo, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
	end)

	local function closeGui()
		if inputChangedConnection then
			inputChangedConnection:Disconnect()
			inputChangedConnection = nil
		end
		
		local closeTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		TweenService:Create(mainFrame, closeTweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
		TweenService:Create(shadow, closeTweenInfo, {ImageTransparency = 1}):Play()
		TweenService:Create(title, closeTweenInfo, {TextTransparency = 1}):Play()
		TweenService:Create(closeBtn, closeTweenInfo, {TextTransparency = 1}):Play()
		TweenService:Create(kickBtn, closeTweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
		
		task.wait(0.2)
		gui:Destroy()
		kickGui = nil
		kickButtonEnabled = false
	end

	closeBtn.MouseButton1Click:Connect(closeGui)

	kickBtn.MouseEnter:Connect(function()
		TweenService:Create(btnGradient, TweenInfo.new(0.2), {Offset = Vector2.new(0, -0.15)}):Play()
		TweenService:Create(kickBtn, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, 34), Position = UDim2.new(0, 10, 0, 37)}):Play()
	end)
	kickBtn.MouseLeave:Connect(function()
		TweenService:Create(btnGradient, TweenInfo.new(0.2), {Offset = Vector2.new(0, 0)}):Play()
		TweenService:Create(kickBtn, TweenInfo.new(0.2), {Size = UDim2.new(1, -24, 0, 32), Position = UDim2.new(0, 12, 0, 38)}):Play()
	end)

	closeBtn.MouseEnter:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 75, 75)}):Play()
	end)
	closeBtn.MouseLeave:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(140, 140, 140)}):Play()
	end)

	kickBtn.MouseButton1Click:Connect(function()
		player:Kick("Has sido kickeado por el botón de Kick.")
	end)

	-- ==========================================
	-- SISTEMA DE ARRASTRE OPTIMIZADO SIN FUGAS
	-- ==========================================
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	mainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					savePosition(mainFrame.Position) -- Guarda la posición de forma persistente al soltar
				end
			end)
		end
	end)

	mainFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	if inputChangedConnection then
		inputChangedConnection:Disconnect()
	end

	inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	return gui
end

local function enableKickButton()
	if kickButtonEnabled then return end
	kickButtonEnabled = true
	kickGui = createKickButton()
end

local function disableKickButton()
	if not kickButtonEnabled then return end
	kickButtonEnabled = false

	if inputChangedConnection then
		inputChangedConnection:Disconnect()
		inputChangedConnection = nil
	end

	if kickGui then  
		kickGui:Destroy()  
		kickGui = nil  
	end
	
	-- Al desactivar por el Toggle, reseteamos la posición guardada al centro para la próxima vez que se active
	savePosition(defaultPosition)
end

-- TOGGLE
createToggle("Kick Boton", function(state)
	if state then
		enableKickButton()
	else
		disableKickButton()
	end
end)

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
