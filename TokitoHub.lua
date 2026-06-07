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

  
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = workspace.CurrentCamera or workspace:WaitForChild("Camera")

local antiRagdollEnabled = false
local characterConnection = nil
local currentCharacter = nil
local ragdollRemoteConnection = nil
local moveConnection = nil
local RAGDOLL_SPEED = 32

local playerModule = nil
local controls = nil

pcall(function()
playerModule = require(Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
controls = playerModule:GetControls()
end)

local function cleanupRagdoll()
if currentCharacter then
local root = currentCharacter:FindFirstChild("HumanoidRootPart")
if root then
local bodyPosition = root:FindFirstChild("RagdollAnchor")
if bodyPosition then
bodyPosition:Destroy()
end
end
end

if moveConnection then  
	moveConnection:Disconnect()  
	moveConnection = nil  
end

end

local function disconnectRemoteConnection()
if ragdollRemoteConnection then
ragdollRemoteConnection:Disconnect()
ragdollRemoteConnection = nil
end
end

local function setupAntiFlyRagdoll(char)
currentCharacter = char
cleanupRagdoll()
disconnectRemoteConnection()

local humanoid = char:WaitForChild("Humanoid")  
local root = char:WaitForChild("HumanoidRootPart")  
local head = char:WaitForChild("Head")  

local ragdollRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Ragdoll"):WaitForChild("Ragdoll")  

ragdollRemoteConnection = ragdollRemote.OnClientEvent:Connect(function(p1, p2)  
	if not antiRagdollEnabled then return end  

	if p1 == "Make" or p2 == "manualM" then  
		humanoid:ChangeState(Enum.HumanoidStateType.Freefall)  
		Camera.CameraSubject = head  
		root.CanCollide = false  

		if controls then  
			pcall(function() controls:Enable() end)  
		end  

		cleanupRagdoll()  

		local bodyPosition = Instance.new("BodyPosition")  
		bodyPosition.Name = "RagdollAnchor"  
		bodyPosition.MaxForce = Vector3.new(1e6, 1e6, 1e6)  
		bodyPosition.P = 5000  
		bodyPosition.D = 1000  
		bodyPosition.Position = root.Position  
		bodyPosition.Parent = root  

		moveConnection = RunService.RenderStepped:Connect(function()  
			if not antiRagdollEnabled or not bodyPosition or not bodyPosition.Parent then  
				if moveConnection then  
					moveConnection:Disconnect()  
					moveConnection = nil  
				end  
				return  
			end  

			local moveDir = humanoid.MoveDirection  
			if moveDir.Magnitude > 0 then  
				bodyPosition.Position = root.Position + moveDir.Unit * RAGDOLL_SPEED  
			else  
				bodyPosition.Position = root.Position  
			end  
		end)  
	end  

	if p1 == "Destroy" or p2 == "manualD" then  
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)  
		Camera.CameraSubject = humanoid  
		root.CanCollide = true  

		if controls then  
			pcall(function() controls:Enable() end)  
		end  

		cleanupRagdoll()  
	end  
end)

end
createToggle("Anti Ragdoll", function(state)
antiRagdollEnabled = state

if state then  
	if Players.LocalPlayer.Character then  
		setupAntiFlyRagdoll(Players.LocalPlayer.Character)  
	end  

	characterConnection = Players.LocalPlayer.CharacterAdded:Connect(function(char)  
		setupAntiFlyRagdoll(char)  
	end)  
else  
	cleanupRagdoll()  
	disconnectRemoteConnection()  

	if characterConnection then  
		characterConnection:Disconnect()  
		characterConnection = nil  
	end  
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

-- AUTO GRAB (BETA)
local autoGrabEnabled = false
local autoGrabBusy = false
local autoGrabLoop = nil

local function isMyPlot(plot)
if not plot then
return false
end

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

return state == "steal"  
	or state == "grab"  
	or action == "steal"  
	or action == "grab"

end

local function getNearestGrabPrompt()
local root = getRootPart()

if not root then  
	return nil  
end  

local nearestPrompt = nil  
local minDistance = 150  

local plots = Workspace:FindFirstChild("Plots")  

if not plots then  
	return nil  
end  

for _, plot in ipairs(plots:GetChildren()) do  
	if isMyPlot(plot) then  
		continue  
	end  

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
if autoGrabBusy or not prompt or not prompt.Parent then
return
end

autoGrabBusy = true  

firePromptConnections(prompt, "PromptButtonHoldBegan")  

task.wait(1.30)  

if prompt and prompt.Parent and prompt.Enabled then  
	firePromptConnections(prompt, "Triggered")  
end  

autoGrabBusy = false

end

createToggle("AutoGrab (Beta)", function(state)
autoGrabEnabled = state

if autoGrabLoop then  
	task.cancel(autoGrabLoop)  
	autoGrabLoop = nil  
end  

if state then  
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
end

end)
-- ESP BEST
local animalESPEnabled = false
local espObjects = espObjects or {}
local animalESPCache = animalESPCache or {}
local animalESPThreshold = 0
local Connections = Connections or {}

local bestAnimalPart = nil
local bestAnimalValue = 0

local currentBeam = nil
local currentAttachments = {}

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
currentAttachments = {  
	attachment0,  
	attachment1  
}

end

local function createESPForPart(part)
if bestAnimalPart and (
not bestAnimalPart.Parent
or not bestAnimalPart:IsDescendantOf(workspace)
) then
bestAnimalPart = nil
bestAnimalValue = 0

clearAllESP()  
end  

if not part or not part.Parent then  
	return  
end  

local animalOverhead = part:FindFirstChild("AnimalOverhead")  

if not animalOverhead or not animalOverhead:IsA("SurfaceGui") then  
	return  
end  

local generationLabel = animalOverhead:FindFirstChild("Generation")  
local displayNameLabel = animalOverhead:FindFirstChild("DisplayName")  

if not generationLabel or not displayNameLabel then  
	return  
end  

local generationText = generationLabel.Text or ""  
local animalName = displayNameLabel.Text or "Unknown"  

if generationText == "" or animalName == "" then  
	return  
end  

local firstValue = generationText:match("^%$([^%s]+)/s")  
	or generationText:match("^%$([^/]+)/s")  

if not firstValue then  
	return  
end  

local cleanText = firstValue:gsub(" ", "")  

local multiplier = 1  
local value = cleanText  

if cleanText:find("T") then  
	multiplier = 1000000000000  
	value = cleanText:gsub("T","")  

elseif cleanText:find("B") then  
	multiplier = 1000000000  
	value = cleanText:gsub("B","")  

elseif cleanText:find("M") then  
	multiplier = 1000000  
	value = cleanText:gsub("M","")  

elseif cleanText:find("K") then  
	multiplier = 1000  
	value = cleanText:gsub("K","")  
end  

local numValue = tonumber(value)  
local earningValue = numValue and (numValue * multiplier) or 0  

if earningValue < animalESPThreshold then  
	return  
end  

if earningValue < bestAnimalValue then  
	return  
end  

bestAnimalValue = earningValue  
bestAnimalPart = part  

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

end

local function rebuildBestAnimal(debris)
bestAnimalPart = nil
bestAnimalValue = 0
clearAllESP()

local bestPart = nil  
local bestValue = 0  

for _, newPart in pairs(debris:GetChildren()) do  
	if newPart.Name == "FastOverheadTemplate" and newPart:IsA("BasePart") then  
		local animalOverhead = newPart:FindFirstChild("AnimalOverhead")  

		if animalOverhead and animalOverhead:IsA("SurfaceGui") then  
			local generationLabel = animalOverhead:FindFirstChild("Generation")  
			local displayNameLabel = animalOverhead:FindFirstChild("DisplayName")  

			if generationLabel and displayNameLabel then  
				local generationText = generationLabel.Text or ""  
				local animalName = displayNameLabel.Text or "Unknown"  

				local firstValue = generationText:match("^%$([^%s]+)/s")  
					or generationText:match("^%$([^/]+)/s")  

				if firstValue and generationText ~= "" and animalName ~= "" then  
					local cleanText = firstValue:gsub(" ", "")  

					local multiplier = 1  
					local value = cleanText  

					if cleanText:find("T") then  
						multiplier = 1000000000000  
						value = cleanText:gsub("T","")  
					elseif cleanText:find("B") then  
						multiplier = 1000000000  
						value = cleanText:gsub("B","")  
					elseif cleanText:find("M") then  
						multiplier = 1000000  
						value = cleanText:gsub("M","")  
					elseif cleanText:find("K") then  
						multiplier = 1000  
						value = cleanText:gsub("K","")  
					end  

					local numValue = tonumber(value)  
					local earningValue = numValue and (numValue * multiplier) or 0  

					if earningValue >= animalESPThreshold and earningValue > bestValue then  
						bestValue = earningValue  
						bestPart = newPart  
					end  
				end  
			end  
		end  
	end  
end  

if bestPart then  
	createESPForPart(bestPart)  
end

end

local function startAnimalESP()
animalESPEnabled = true

bestAnimalPart = nil  
bestAnimalValue = 0  

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
			end  
		end)  
	end  
end

end

local function stopAnimalESP()
animalESPEnabled = false

clearAllESP()  
animalESPCache = {}  

bestAnimalPart = nil  
bestAnimalValue = 0  

if Connections.animalESPAdded then  
	Connections.animalESPAdded:Disconnect()  
	Connections.animalESPAdded = nil  
end  

if Connections.animalESPRemoved then  
	Connections.animalESPRemoved:Disconnect()  
	Connections.animalESPRemoved = nil  
end

end

createToggle("Esp Best", function(state)
if state then
startAnimalESP()
else
stopAnimalESP()
end
end)

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
-- ================= KICK BUTTON TOGGLE =================

local kickButtonEnabled = false
local kickGui = nil

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local function createKickButton()
	local gui = Instance.new("ScreenGui")
	gui.Name = "KickGui"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 60, 0, 60) -- pequeño
	button.Position = UDim2.new(1, -70, 0, 10) -- arriba derecha
	button.AnchorPoint = Vector2.new(0,0)
	button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	button.Text = "K"
	button.TextColor3 = Color3.fromRGB(255,255,255)
	button.TextScaled = true
	button.Parent = gui
	button.Active = true

	-- BOTÓN X
	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0, 18, 0, 18)
	close.Position = UDim2.new(1, -18, 0, 0)
	close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	close.Text = "X"
	close.TextColor3 = Color3.fromRGB(255,255,255)
	close.TextScaled = true
	close.Parent = button

	-- cerrar GUI
	close.MouseButton1Click:Connect(function()
		gui:Destroy()
		kickGui = nil
		kickButtonEnabled = false
	end)

	-- DRAG (móvil + PC)
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

			dragging = true
			dragStart = input.Position
			startPos = button.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	button.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart

			button.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	-- KICK
	button.MouseButton1Click:Connect(function()
		player:Kick("Has sido expulsado por el botón Kick")
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

	if kickGui then
		kickGui:Destroy()
		kickGui = nil
	end
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
-- ================= PLAYER ESP =================

local playerESPEnabled = false
local playerHighlights = {}
local playerNameLabels = {}
local characterConnections = {}

local function addGradient(obj)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
	})
	gradient.Parent = obj
end

local function clearPlayerESP()
	for _, highlight in pairs(playerHighlights) do
		if highlight then
			pcall(function()
				highlight:Destroy()
			end)
		end
	end

	playerHighlights = {}

	for _, label in pairs(playerNameLabels) do
		if label then
			pcall(function()
				label:Destroy()
			end)
		end
	end

	playerNameLabels = {}
end

local function removePlayerESP(otherPlayer)
	if playerHighlights[otherPlayer] then
		playerHighlights[otherPlayer]:Destroy()
		playerHighlights[otherPlayer] = nil
	end

	if playerNameLabels[otherPlayer] then
		playerNameLabels[otherPlayer]:Destroy()
		playerNameLabels[otherPlayer] = nil
	end
end

local function addESPToPlayer(otherPlayer)
	if not playerESPEnabled then return end
	if otherPlayer == player then return end
	if not otherPlayer.Character then return end

	removePlayerESP(otherPlayer)

	local highlight = Instance.new("Highlight")
	highlight.Name = "PlayerESP"
	highlight.Adornee = otherPlayer.Character
	highlight.FillColor = Color3.fromRGB(140,100,200)
	highlight.OutlineColor = Color3.fromRGB(255,255,255)
	highlight.Parent = otherPlayer.Character

	playerHighlights[otherPlayer] = highlight

	local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")

	if hrp then
		local billboard = Instance.new("BillboardGui")
		billboard.Adornee = hrp
		billboard.Size = UDim2.new(0,200,0,50)
		billboard.StudsOffset = Vector3.new(0,3,0)
		billboard.AlwaysOnTop = true
		billboard.Parent = hrp

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,0,1,0)
		label.BackgroundTransparency = 1
		label.Text = otherPlayer.DisplayName
		label.TextColor3 = Color3.new(1,1,1)
		label.TextStrokeTransparency = 0
		label.Font = Enum.Font.GothamBold
		label.TextSize = 16
		label.Parent = billboard

		addGradient(label)

		playerNameLabels[otherPlayer] = billboard
	end
end

local function startPlayerESP()
	playerESPEnabled = true

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then

			if plr.Character then
				addESPToPlayer(plr)
			end

			if not characterConnections[plr] then
				characterConnections[plr] =
					plr.CharacterAdded:Connect(function()
						task.wait(0.5)

						if playerESPEnabled then
							addESPToPlayer(plr)
						end
					end)
			end
		end
	end
end

local function stopPlayerESP()
	playerESPEnabled = false

	clearPlayerESP()

	for _, conn in pairs(characterConnections) do
		if conn then
			conn:Disconnect()
		end
	end

	characterConnections = {}
end

createToggle("Player ESP", function(state)
	if state then
		startPlayerESP()
	else
		stopPlayerESP()
	end
end)

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

-- Activar automáticamente al ejecutar el script
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
	shadow.Position = UDim2.new(0, 13, 0, 13)
	shadow.Image = "rbxassetid://6014261993"
	shadow.ImageTransparency = 0.78
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	shadow.ZIndex = 1

	local btn = Instance.new("TextButton")
	btn.Name = "DropButton"
	btn.Size = UDim2.new(0, 72, 0, 72)
	btn.Position = UDim2.new(0, 10, 0, 10)
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

local CoreGui = game:GetService("CoreGui")

pcall(function()
	if CoreGui:FindFirstChild("SofkaNotification") then
		CoreGui.SofkaNotification:Destroy()
	end
end)

local notifGui = Instance.new("ScreenGui")
notifGui.Name = "SofkaNotification"
notifGui.ResetOnSpawn = false
notifGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 95)
frame.Position = UDim2.new(0.5, -160, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(12, 16, 35)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = notifGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Parent = frame

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 30, 80)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 120, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 120, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 30, 80))
}
strokeGradient.Parent = stroke

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "TokitoHub"
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255))
}
titleGradient.Parent = title

local message = Instance.new("TextLabel")
message.Size = UDim2.new(1, -20, 0, 40)
message.Position = UDim2.new(0, 10, 0, 42)
message.BackgroundTransparency = 1
message.TextWrapped = true
message.Text = "⚡ Script creado por Tokito ⚡\nTokitoHub"
message.Font = Enum.Font.GothamBold
message.TextSize = 12
message.TextColor3 = Color3.new(1, 1, 1)
message.Parent = frame

local messageGradient = Instance.new("UIGradient")
messageGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255))
}
messageGradient.Parent = message

task.delay(6, function()
	local info = TweenInfo.new(0.5)

	TweenService:Create(frame, info, {BackgroundTransparency = 1}):Play()
	TweenService:Create(title, info, {TextTransparency = 1}):Play()
	TweenService:Create(message, info, {TextTransparency = 1}):Play()
	TweenService:Create(stroke, info, {Transparency = 1}):Play()

	task.wait(0.6)
	notifGui:Destroy()
	createMenu()
end)
