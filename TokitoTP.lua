local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

pcall(function()
	local old = game.CoreGui:FindFirstChild("TokitoTP")
	if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "TokitoTP"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0, 255, 0, 154)
main.Position = UDim2.new(0.35, 0, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Selectable = false
main.AnchorPoint = Vector2.new(0, 0)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke")
stroke.Parent = main
stroke.Thickness = 1
stroke.Transparency = 0.2
stroke.Color = Color3.fromRGB(120, 180, 255)

local grad = Instance.new("UIGradient")
grad.Parent = stroke
grad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 140))
})

task.spawn(function()
	while gui.Parent do
		local t = TweenService:Create(grad, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = 360})
		t:Play()
		t.Completed:Wait()
		grad.Rotation = 0
	end
end)

local top = Instance.new("Frame")
top.Parent = main
top.Size = UDim2.new(1, 0, 0, 34)
top.BackgroundTransparency = 1
top.Active = true
top.Selectable = false

local title = Instance.new("TextLabel")
title.Parent = top
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Tokito TP"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(238, 242, 255)

local minimize = Instance.new("TextButton")
minimize.Parent = top
minimize.Size = UDim2.new(0, 24, 0, 24)
minimize.Position = UDim2.new(1, -58, 0, 5)
minimize.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 8)

local toggleList = Instance.new("TextButton")
toggleList.Parent = top
toggleList.Size = UDim2.new(0, 24, 0, 24)
toggleList.Position = UDim2.new(1, -30, 0, 5)
toggleList.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
toggleList.Text = ">"
toggleList.Font = Enum.Font.GothamBold
toggleList.TextSize = 16
toggleList.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", toggleList).CornerRadius = UDim.new(0, 8)

local selectedLabel = Instance.new("TextLabel")
selectedLabel.Parent = main
selectedLabel.Size = UDim2.new(1, -20, 0, 18)
selectedLabel.Position = UDim2.new(0, 10, 0, 36)
selectedLabel.BackgroundTransparency = 1
selectedLabel.Text = "Seleccionado: Ninguno"
selectedLabel.Font = Enum.Font.Gotham
selectedLabel.TextSize = 12
selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
selectedLabel.TextColor3 = Color3.fromRGB(180, 190, 215)

local tpButton = Instance.new("TextButton")
tpButton.Parent = main
tpButton.Size = UDim2.new(1, -20, 0, 28)
tpButton.Position = UDim2.new(0, 10, 0, 58)
tpButton.BackgroundColor3 = Color3.fromRGB(33, 38, 55)
tpButton.Text = "TP"
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 14
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 10)

local infButton = Instance.new("TextButton")
infButton.Parent = main
infButton.Size = UDim2.new(1, -20, 0, 28)
infButton.Position = UDim2.new(0, 10, 0, 90)
infButton.BackgroundColor3 = Color3.fromRGB(33, 38, 55)
infButton.Text = "TP INFINITO: OFF"
infButton.Font = Enum.Font.GothamBold
infButton.TextSize = 13
infButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", infButton).CornerRadius = UDim.new(0, 10)

local noclipButton = Instance.new("TextButton")
noclipButton.Parent = main
noclipButton.Size = UDim2.new(0, 108, 0, 28)
noclipButton.Position = UDim2.new(0, 10, 0, 122)
noclipButton.BackgroundColor3 = Color3.fromRGB(33, 38, 55)
noclipButton.Text = "NOCLIP: OFF"
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextSize = 13
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", noclipButton).CornerRadius = UDim.new(0, 10)

local speedBox = Instance.new("TextBox")
speedBox.Parent = main
speedBox.Size = UDim2.new(0, 62, 0, 28)
speedBox.Position = UDim2.new(0, 124, 0, 122)
speedBox.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
speedBox.PlaceholderText = "Speed"
speedBox.Text = ""
speedBox.ClearTextOnFocus = false
speedBox.Font = Enum.Font.GothamBold
speedBox.TextSize = 13
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.PlaceholderColor3 = Color3.fromRGB(140, 145, 160)
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 10)

local speedApply = Instance.new("TextButton")
speedApply.Parent = main
speedApply.Size = UDim2.new(0, 36, 0, 28)
speedApply.Position = UDim2.new(1, -46, 0, 122)
speedApply.BackgroundColor3 = Color3.fromRGB(33, 38, 55)
speedApply.Text = "OK"
speedApply.Font = Enum.Font.GothamBold
speedApply.TextSize = 13
speedApply.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", speedApply).CornerRadius = UDim.new(0, 10)

local list = Instance.new("ScrollingFrame")
list.Parent = main
list.Size = UDim2.new(1, -20, 0, 0)
list.Position = UDim2.new(0, 10, 0, 158)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.Visible = false
list.CanvasSize = UDim2.new(0, 0, 0, 0)

local layout = Instance.new("UIListLayout")
layout.Parent = list
layout.Padding = UDim.new(0, 6)

local pad = Instance.new("UIPadding")
pad.Parent = list
pad.PaddingTop = UDim.new(0, 2)
pad.PaddingBottom = UDim.new(0, 2)

local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = UserInputService:GetMouseLocation()
		startPos = main.Position
	end
end)

top.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local mousePos = UserInputService:GetMouseLocation()
		local delta = mousePos - dragStart

		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

local minimized = false
local listOpen = false
local selectedPlayer = nil
local infTpEnabled = false
local noclipEnabled = false
local wantedSpeed = nil

local blockedUsers = {
	["Toki"] = true,
	["Tokito_2025Muichiro"] = true
}

local function char()
	return LocalPlayer.Character
end

local function humanoid()
	local c = char()
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function hrpOf(plr)
	local c = plr and plr.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function applySpeed()
	local h = humanoid()
	if h and wantedSpeed then
		h.WalkSpeed = wantedSpeed
	end
end

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.2)
	applySpeed()
end)

local function tpTo(plr)
	if not plr then return end

	if blockedUsers[plr.Name] then
		selectedLabel.Text = "No puedes hacerte tp a este usuario"

		local hum = humanoid()
		if hum then
			task.wait(1)
			hum.Health = 0
		end

		return
	end

	local c = char()
	local h = hrpOf(plr)
	if not c or not h then return end

	local my = c:FindFirstChild("HumanoidRootPart")
	if not my then return end

	my.CFrame = h.CFrame * CFrame.new(2, 0, 2)
end

local function clearButtons()
	for _, v in ipairs(list:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

local function refresh()
	clearButtons()

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local b = Instance.new("TextButton")
			b.Parent = list
			b.Size = UDim2.new(1, -2, 0, 30)
			b.BackgroundColor3 = selectedPlayer == plr and Color3.fromRGB(60, 80, 120) or Color3.fromRGB(24, 28, 40)
			b.Text = plr.Name
			b.Font = Enum.Font.GothamSemibold
			b.TextSize = 13
			b.TextColor3 = Color3.fromRGB(245, 247, 255)
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)

			local bs = Instance.new("UIStroke")
			bs.Parent = b
			bs.Thickness = 1
			bs.Transparency = 0.65
			bs.Color = Color3.fromRGB(110, 140, 255)

			b.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				selectedLabel.Text = "Seleccionado: " .. plr.Name
				refresh()
			end)
		end
	end

	task.wait()
	list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 4)
end

local function updateSize()
	if minimized then
		main:TweenSize(UDim2.new(0, 255, 0, 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.18, true)
		selectedLabel.Visible = false
		tpButton.Visible = false
		infButton.Visible = false
		noclipButton.Visible = false
		speedBox.Visible = false
		speedApply.Visible = false
		list.Visible = false
		toggleList.Visible = false
		minimize.Text = "+"
	elseif listOpen then
		main:TweenSize(UDim2.new(0, 255, 0, 332), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.18, true)
		selectedLabel.Visible = true
		tpButton.Visible = true
		infButton.Visible = true
		noclipButton.Visible = true
		speedBox.Visible = true
		speedApply.Visible = true
		list.Visible = true
		toggleList.Visible = true
		list:TweenSize(UDim2.new(1, -20, 0, 150), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.18, true)
		minimize.Text = "-"
	else
		main:TweenSize(UDim2.new(0, 255, 0, 154), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.18, true)
		selectedLabel.Visible = true
		tpButton.Visible = true
		infButton.Visible = true
		noclipButton.Visible = true
		speedBox.Visible = true
		speedApply.Visible = true
		list.Visible = false
		toggleList.Visible = true
		minimize.Text = "-"
	end
end

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		listOpen = false
	end
	updateSize()
end)

toggleList.MouseButton1Click:Connect(function()
	if minimized then return end
	listOpen = not listOpen
	if listOpen then
		refresh()
	end
	updateSize()
end)

tpButton.MouseButton1Click:Connect(function()
	if selectedPlayer then
		tpTo(selectedPlayer)
	end
end)

infButton.MouseButton1Click:Connect(function()
	infTpEnabled = not infTpEnabled
	infButton.Text = infTpEnabled and "TP INFINITO: ON" or "TP INFINITO: OFF"
end)

noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipButton.Text = noclipEnabled and "NOCLIP: ON" or "NOCLIP: OFF"
end)

local function setSpeedFromBox()
	local v = tonumber(speedBox.Text)
	if v then
		wantedSpeed = math.clamp(v, 0, 500)
		applySpeed()
	end
end

speedApply.MouseButton1Click:Connect(setSpeedFromBox)

speedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		setSpeedFromBox()
	end
end)

Players.PlayerAdded:Connect(function()
	if listOpen then
		refresh()
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	if selectedPlayer == plr then
		selectedPlayer = nil
		selectedLabel.Text = "Seleccionado: Ninguno"
	end
	if listOpen then
		refresh()
	end
end)

RunService.Heartbeat:Connect(function()
	if infTpEnabled and selectedPlayer then
		if blockedUsers[selectedPlayer.Name] then
			selectedLabel.Text = "No puedes hacerte tp a este usuario"
			infTpEnabled = false
			infButton.Text = "TP INFINITO: OFF"

			local hum = humanoid()
			if hum then
				task.wait(1)
				hum.Health = 0
			end
		else
			local c = char()
			local my = c and c:FindFirstChild("HumanoidRootPart")
			local h = hrpOf(selectedPlayer)

			if my and h then
				my.CFrame = h.CFrame * CFrame.new(2, 0, 2)
			end
		end
	end

	if noclipEnabled then
		local c = char()
		if c then
			for _, part in ipairs(c:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end

	applySpeed()
end)

refresh()
updateSize()
