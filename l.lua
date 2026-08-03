if getgenv().TokitoKeySystem then return end
getgenv().TokitoKeySystem = true

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

local KEY = "LARP-7xQ9-Vm2K-84pR-Zd6N"
local SCRIPT_URL = "https://raw.githubusercontent.com/mariandrespat18-cpu/Vrg/refs/heads/main/Test.lua"

local function make(className, props)
	local obj = Instance.new(className)
	for k, v in pairs(props or {}) do
		obj[k] = v
	end
	return obj
end

local gui = make("ScreenGui", {
	Name = "TokitoKeySystem",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = CoreGui
})

local shadow = make("Frame", {
	Parent = gui,
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.35,
	Size = UDim2.new(0, 430, 0, 250),
	Position = UDim2.new(0.5, -215, 0.5, -125),
	BorderSizePixel = 0
})
make("UICorner", { CornerRadius = UDim.new(0, 18), Parent = shadow })

local main = make("Frame", {
	Parent = gui,
	BackgroundColor3 = Color3.fromRGB(18, 10, 28),
	Size = UDim2.new(0, 430, 0, 250),
	Position = UDim2.new(0.5, -215, 0.5, -125),
	BorderSizePixel = 0
})
make("UICorner", { CornerRadius = UDim.new(0, 18), Parent = main })

make("UIStroke", {
	Parent = main,
	Color = Color3.fromRGB(180, 90, 255),
	Thickness = 1.5,
	Transparency = 0.15
})

make("UIGradient", {
	Parent = main,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 12, 44)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 8, 26)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 16, 60))
	}),
	Rotation = 25
})

local topBar = make("Frame", {
	Parent = main,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 54)
})

local title = make("TextLabel", {
	Parent = topBar,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 18, 0, 10),
	Size = UDim2.new(1, -80, 0, 22),
	Font = Enum.Font.GothamBold,
	Text = "Larp Key System",
	TextColor3 = Color3.fromRGB(240, 230, 255),
	TextSize = 22,
	TextXAlignment = Enum.TextXAlignment.Left
})

local subtitle = make("TextLabel", {
	Parent = topBar,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 18, 0, 31),
	Size = UDim2.new(1, -80, 0, 16),
	Font = Enum.Font.Gotham,
	Text = "Protected access with key",
	TextColor3 = Color3.fromRGB(180, 150, 210),
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left
})

local closeBtn = make("TextButton", {
	Parent = topBar,
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -40, 0, 9),
	Size = UDim2.new(0, 28, 0, 28),
	Font = Enum.Font.GothamBold,
	Text = "×",
	TextColor3 = Color3.fromRGB(225, 200, 255),
	TextSize = 26
})

local glow = make("Frame", {
	Parent = main,
	BackgroundColor3 = Color3.fromRGB(170, 70, 255),
	BackgroundTransparency = 0.86,
	Size = UDim2.new(0, 120, 0, 120),
	Position = UDim2.new(1, -80, 0, -34),
	BorderSizePixel = 0
})
make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = glow })

local boxFrame = make("Frame", {
	Parent = main,
	BackgroundColor3 = Color3.fromRGB(28, 18, 40),
	Position = UDim2.new(0, 18, 0, 78),
	Size = UDim2.new(1, -36, 0, 52),
	BorderSizePixel = 0
})
make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = boxFrame })
make("UIStroke", {
	Parent = boxFrame,
	Color = Color3.fromRGB(140, 70, 220),
	Thickness = 1,
	Transparency = 0.35
})

local box = make("TextBox", {
	Parent = boxFrame,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 0),
	Size = UDim2.new(1, -28, 1, 0),
	ClearTextOnFocus = false,
	Font = Enum.Font.GothamSemibold,
	PlaceholderText = "Enter Key...",
	Text = "",
	TextColor3 = Color3.fromRGB(245, 240, 255),
	PlaceholderColor3 = Color3.fromRGB(140, 120, 160),
	TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Left
})

local status = make("TextLabel", {
	Parent = main,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 18, 0, 138),
	Size = UDim2.new(1, -36, 0, 20),
	Font = Enum.Font.Gotham,
	Text = "Type the key and press Enter.",
	TextColor3 = Color3.fromRGB(190, 170, 220),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left
})

local enterBtn = make("TextButton", {
	Parent = main,
	BackgroundColor3 = Color3.fromRGB(155, 70, 255),
	Position = UDim2.new(0, 18, 1, -58),
	Size = UDim2.new(1, -36, 0, 38),
	Font = Enum.Font.GothamBold,
	Text = "Unlock",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 16,
	BorderSizePixel = 0
})
make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = enterBtn })

local btnStroke = make("UIStroke", {
	Parent = enterBtn,
	Color = Color3.fromRGB(255, 255, 255),
	Thickness = 1,
	Transparency = 0.75
})

local function tween(obj, info, props)
	TweenService:Create(obj, info, props):Play()
end

local function destroyGui()
	tween(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
	tween(shadow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
	task.wait(0.2)
	gui:Destroy()
end

local function runRemote()
	local ok, err = pcall(function()
		loadstring(game:HttpGet(SCRIPT_URL))()
	end)
	if not ok then
		warn("Error running the remote script:", err)
	end
end

local function checkKey()
	local entered = string.lower((box.Text or ""):gsub("%s+", ""))
	local valid = string.lower(KEY:gsub("%s+", ""))

	if entered == valid then
		status.Text = "Correct key."
		status.TextColor3 = Color3.fromRGB(130, 255, 170)
		runRemote()
		destroyGui()
	else
		status.Text = "Incorrect key."
		status.TextColor3 = Color3.fromRGB(255, 120, 140)
		tween(boxFrame, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, 14, 0, 80)
		})
		task.wait(0.08)
		tween(boxFrame, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, 18, 0, 78)
		})
	end
end

enterBtn.MouseButton1Click:Connect(checkKey)
box.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		checkKey()
	end
end)

closeBtn.MouseButton1Click:Connect(destroyGui)

enterBtn.MouseEnter:Connect(function()
	tween(enterBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = Color3.fromRGB(175, 95, 255)
	})
	tween(btnStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 0.45
	})
end)

enterBtn.MouseLeave:Connect(function()
	tween(enterBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = Color3.fromRGB(155, 70, 255)
	})
	tween(btnStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 0.75
	})
end)

closeBtn.MouseEnter:Connect(function()
	tween(closeBtn, TweenInfo.new(0.12), { TextColor3 = Color3.fromRGB(255, 160, 230) })
end)

closeBtn.MouseLeave:Connect(function()
	tween(closeBtn, TweenInfo.new(0.12), { TextColor3 = Color3.fromRGB(225, 200, 255) })
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Return then
		checkKey()
	end
end)

-- Drag move
do
	local dragging = false
	local dragStartPos
	local startGuiPos
	local dragInput

	local function update(input)
		local delta = input.Position - dragStartPos
		main.Position = UDim2.new(
			startGuiPos.X.Scale,
			startGuiPos.X.Offset + delta.X,
			startGuiPos.Y.Scale,
			startGuiPos.Y.Offset + delta.Y
		)
		shadow.Position = main.Position
	end

	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStartPos = input.Position
			startGuiPos = main.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	main.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			update(input)
		end
	end)
end
