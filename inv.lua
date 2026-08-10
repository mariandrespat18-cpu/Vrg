--[====================================================]--
--   Supreme Hotbar & Organizer (Dark Neon Ultimate)
--   + Glassmorphism, Perfect Drag & Drop Swap, Auto-Center
--[====================================================]--

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

if CoreGui:FindFirstChild("SupremeInventorySystem") then
	CoreGui.SupremeInventorySystem:Destroy()
end

local configFileName = "SupremeInventoryConfig.json"
local orderFileName = "SupremeInventoryOrder.json"

local settings = {
	MaxSlots = 10,
	ButtonSize = 50,
	HotbarLocked = true,
	HotbarPosX = 0,
	HotbarOffsetX = 20,
	HotbarPosY = 1,
	HotbarOffsetY = -85
}

local function loadConfig()
	pcall(function()
		if readfile then
			local data = readfile(configFileName)
			local decoded = HttpService:JSONDecode(data)
			if type(decoded) == "table" then
				for k, v in pairs(decoded) do
					settings[k] = v
				end
			end
		end
	end)
end

local function saveConfig()
	pcall(function()
		if writefile then
			writefile(configFileName, HttpService:JSONEncode(settings))
		end
	end)
end

loadConfig()

local savedOrder = {}
local inventoryInitialized = false
local inventoryOrder = {}
local selectedForMove = nil

local function getAllTools()
	local tools = {}

	if player:FindFirstChild("Backpack") then
		for _, t in pairs(player.Backpack:GetChildren()) do
			if t:IsA("Tool") then
				table.insert(tools, t)
			end
		end
	end

	if player.Character then
		for _, t in pairs(player.Character:GetChildren()) do
			if t:IsA("Tool") then
				table.insert(tools, t)
			end
		end
	end

	return tools
end

local function toolKey(tool)
	return tostring(tool.Name) .. "|" .. tostring(tool.TextureId or "")
end

local function containsTool(list, tool)
	for _, v in ipairs(list) do
		if v == tool then
			return true
		end
	end
	return false
end

local function loadOrder()
	pcall(function()
		if readfile then
			local data = readfile(orderFileName)
			local decoded = HttpService:JSONDecode(data)
			if type(decoded) == "table" then
				savedOrder = decoded
			end
		end
	end)
end

local function saveOrder()
	pcall(function()
		if writefile then
			local orderData = {}
			for _, tool in ipairs(inventoryOrder) do
				if tool and tool:IsA("Tool") then
					table.insert(orderData, {
						Name = tool.Name,
						TextureId = tool.TextureId or ""
					})
				end
			end
			savedOrder = orderData
			writefile(orderFileName, HttpService:JSONEncode(orderData))
		end
	end)
end

local function rebuildInventoryOrderFromSaved(currentTools, entries)
	if type(entries) ~= "table" or #entries == 0 then
		return currentTools
	end

	local buckets = {}
	for _, tool in ipairs(currentTools) do
		local key = toolKey(tool)
		buckets[key] = buckets[key] or {}
		table.insert(buckets[key], tool)
	end

	local newOrder = {}
	local used = {}

	for _, entry in ipairs(entries) do
		if type(entry) == "table" and entry.Name then
			local key = tostring(entry.Name) .. "|" .. tostring(entry.TextureId or "")
			local bucket = buckets[key]
			if bucket and #bucket > 0 then
				local tool = table.remove(bucket, 1)
				table.insert(newOrder, tool)
				used[tool] = true
			end
		end
	end

	for _, tool in ipairs(currentTools) do
		if not used[tool] then
			table.insert(newOrder, tool)
		end
	end

	return newOrder
end

local function recoverPositionsFromFile()
	loadOrder()

	local currentTools = getAllTools()
	if #currentTools == 0 then
		return false
	end

	if type(savedOrder) ~= "table" or #savedOrder == 0 then
		return false
	end

	inventoryOrder = rebuildInventoryOrderFromSaved(currentTools, savedOrder)
	inventoryInitialized = true
	return true
end

loadOrder()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SupremeInventorySystem"
screenGui.Parent = CoreGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 36)
toggleBtn.Position = UDim2.new(0.5, -60, 0, 12)
toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
toggleBtn.BackgroundTransparency = 0.25
toggleBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
toggleBtn.Text = "📦 Inventario"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(0, 200, 255)
toggleStroke.Transparency = 0.3
toggleStroke.Thickness = 1.8
toggleStroke.Parent = toggleBtn

toggleBtn.MouseEnter:Connect(function()
	TweenService:Create(toggleBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(25, 35, 50) }):Play()
end)

toggleBtn.MouseLeave:Connect(function()
	TweenService:Create(toggleBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(15, 18, 25) }):Play()
end)

local organizerFrame = Instance.new("Frame")
organizerFrame.Size = UDim2.new(0, 340, 0, 360)
organizerFrame.Position = UDim2.new(0.5, -170, 0.5, -180)
organizerFrame.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
organizerFrame.BackgroundTransparency = 0.15
organizerFrame.Visible = false
organizerFrame.Active = true
organizerFrame.Parent = screenGui

local orgCorner = Instance.new("UICorner")
orgCorner.CornerRadius = UDim.new(0, 16)
orgCorner.Parent = organizerFrame

local orgStroke = Instance.new("UIStroke")
orgStroke.Color = Color3.fromRGB(0, 200, 255)
orgStroke.Transparency = 0.4
orgStroke.Thickness = 1.8
orgStroke.Parent = organizerFrame

local orgBlur = Instance.new("UIAspectRatioConstraint")
orgBlur.AspectRatio = 0.944
orgBlur.DominantAxis = Enum.DominantAxis.Height
orgBlur:Destroy()

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundTransparency = 1
topBar.Parent = organizerFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 16)
topCorner.Parent = topBar

local menuTitleLabel = Instance.new("TextLabel")
menuTitleLabel.Size = UDim2.new(1, -50, 1, 0)
menuTitleLabel.Position = UDim2.new(0, 15, 0, 0)
menuTitleLabel.BackgroundTransparency = 1
menuTitleLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
menuTitleLabel.Text = "Gestor de Inventario"
menuTitleLabel.Font = Enum.Font.GothamBold
menuTitleLabel.TextSize = 15
menuTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
menuTitleLabel.Parent = topBar

local configBtn = Instance.new("TextButton")
configBtn.Size = UDim2.new(0, 32, 0, 32)
configBtn.Position = UDim2.new(1, -40, 0, 5)
configBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
configBtn.BackgroundTransparency = 0.3
configBtn.Text = "⚙️"
configBtn.TextSize = 16
configBtn.Parent = topBar

local configBtnCorner = Instance.new("UICorner")
configBtnCorner.CornerRadius = UDim.new(0, 8)
configBtnCorner.Parent = configBtn

local draggingOrg, dragInputOrg, dragStartOrg, startPosOrg
topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingOrg = true
		dragStartOrg = input.Position
		startPosOrg = organizerFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingOrg = false
			end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInputOrg = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInputOrg and draggingOrg then
		local delta = input.Position - dragStartOrg
		organizerFrame.Position = UDim2.new(
			startPosOrg.X.Scale, startPosOrg.X.Offset + delta.X,
			startPosOrg.Y.Scale, startPosOrg.Y.Offset + delta.Y
		)
	end
end)

local orgSubTitle = Instance.new("TextLabel")
orgSubTitle.Size = UDim2.new(1, -20, 0, 20)
orgSubTitle.Position = UDim2.new(0, 10, 0, 42)
orgSubTitle.BackgroundTransparency = 1
orgSubTitle.TextColor3 = Color3.fromRGB(150, 170, 190)
orgSubTitle.Text = "Arrastra ítems libremente o cliclea para mover"
orgSubTitle.Font = Enum.Font.GothamMedium
orgSubTitle.TextSize = 11
orgSubTitle.Parent = organizerFrame

local gridFrame = Instance.new("ScrollingFrame")
gridFrame.Size = UDim2.new(1, -20, 1, -75)
gridFrame.Position = UDim2.new(0, 10, 0, 68)
gridFrame.BackgroundTransparency = 1
gridFrame.ScrollBarThickness = 5
gridFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
gridFrame.Parent = organizerFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 56, 0, 56)
gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
gridLayout.Parent = gridFrame

local configPanel = Instance.new("Frame")
configPanel.Size = UDim2.new(0, 200, 0, 200)
configPanel.Position = UDim2.new(0.5, -100, 0.5, -100)
configPanel.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
configPanel.BackgroundTransparency = 0.05
configPanel.ZIndex = 10
configPanel.Visible = false
configPanel.Parent = organizerFrame

local confCorner = Instance.new("UICorner")
confCorner.CornerRadius = UDim.new(0, 12)
confCorner.Parent = configPanel

local confStroke = Instance.new("UIStroke")
confStroke.Color = Color3.fromRGB(0, 200, 255)
confStroke.Transparency = 0.5
confStroke.Thickness = 1.5
confStroke.Parent = configPanel

local configLabel = Instance.new("TextLabel")
configLabel.Size = UDim2.new(1, 0, 0, 24)
configLabel.Position = UDim2.new(0, 0, 0, 8)
configLabel.BackgroundTransparency = 1
configLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
configLabel.Text = "Máximo de Slots (Hotbar):"
configLabel.Font = Enum.Font.GothamBold
configLabel.TextSize = 12
configLabel.ZIndex = 11
configLabel.Parent = configPanel

local slotInput = Instance.new("TextBox")
slotInput.Size = UDim2.new(0, 120, 0, 30)
slotInput.Position = UDim2.new(0.5, -60, 0, 32)
slotInput.BackgroundColor3 = Color3.fromRGB(25, 32, 48)
slotInput.TextColor3 = Color3.fromRGB(255, 255, 255)
slotInput.Text = tostring(settings.MaxSlots)
slotInput.Font = Enum.Font.GothamBold
slotInput.TextSize = 13
slotInput.ZIndex = 11
slotInput.Parent = configPanel

local inputCorner1 = Instance.new("UICorner")
inputCorner1.CornerRadius = UDim.new(0, 6)
inputCorner1.Parent = slotInput

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(1, 0, 0, 24)
sizeLabel.Position = UDim2.new(0, 0, 0, 68)
sizeLabel.BackgroundTransparency = 1
sizeLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
sizeLabel.Text = "Tamaño Ítems (Hotbar):"
sizeLabel.Font = Enum.Font.GothamBold
sizeLabel.TextSize = 12
sizeLabel.ZIndex = 11
sizeLabel.Parent = configPanel

local sizeInput = Instance.new("TextBox")
sizeInput.Size = UDim2.new(0, 120, 0, 30)
sizeInput.Position = UDim2.new(0.5, -60, 0, 92)
sizeInput.BackgroundColor3 = Color3.fromRGB(25, 32, 48)
sizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeInput.Text = tostring(settings.ButtonSize)
sizeInput.Font = Enum.Font.GothamBold
sizeInput.TextSize = 13
sizeInput.ZIndex = 11
sizeInput.Parent = configPanel

local inputCorner2 = Instance.new("UICorner")
inputCorner2.CornerRadius = UDim.new(0, 6)
inputCorner2.Parent = sizeInput

local saveLabel = Instance.new("TextLabel")
saveLabel.Size = UDim2.new(1, 0, 0, 24)
saveLabel.Position = UDim2.new(0, 0, 0, 132)
saveLabel.BackgroundTransparency = 1
saveLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
saveLabel.Text = "Guardar / Recuperar:"
saveLabel.Font = Enum.Font.GothamBold
saveLabel.TextSize = 12
saveLabel.ZIndex = 11
saveLabel.Parent = configPanel

local savePositionsBtn = Instance.new("TextButton")
savePositionsBtn.Size = UDim2.new(0, 120, 0, 28)
savePositionsBtn.Position = UDim2.new(0.5, -60, 0, 158)
savePositionsBtn.BackgroundColor3 = Color3.fromRGB(25, 32, 48)
savePositionsBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
savePositionsBtn.Text = "Save"
savePositionsBtn.Font = Enum.Font.GothamBold
savePositionsBtn.TextSize = 12
savePositionsBtn.ZIndex = 11
savePositionsBtn.Parent = configPanel

local saveBtnCorner = Instance.new("UICorner")
saveBtnCorner.CornerRadius = UDim.new(0, 6)
saveBtnCorner.Parent = savePositionsBtn

local loadPositionsBtn = Instance.new("TextButton")
loadPositionsBtn.Size = UDim2.new(0, 120, 0, 28)
loadPositionsBtn.Position = UDim2.new(0.5, -60, 0, 158)
loadPositionsBtn.BackgroundColor3 = Color3.fromRGB(25, 32, 48)
loadPositionsBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
loadPositionsBtn.Text = "Load"
loadPositionsBtn.Font = Enum.Font.GothamBold
loadPositionsBtn.TextSize = 12
loadPositionsBtn.ZIndex = 11
loadPositionsBtn.Parent = configPanel

local loadBtnCorner = Instance.new("UICorner")
loadBtnCorner.CornerRadius = UDim.new(0, 6)
loadBtnCorner.Parent = loadPositionsBtn

savePositionsBtn.Position = UDim2.new(0.5, -60, 0, 132)
loadPositionsBtn.Position = UDim2.new(0.5, -60, 0, 166)

toggleBtn.MouseButton1Click:Connect(function()
	if not organizerFrame.Visible then
		organizerFrame.Position = UDim2.new(0.5, -170, 0.5, -180)
	end
	organizerFrame.Visible = not organizerFrame.Visible
end)

configBtn.MouseButton1Click:Connect(function()
	configPanel.Visible = not configPanel.Visible
end)

local function saveCurrentPositions()
	if #inventoryOrder > 0 then
		saveOrder()
	end
	saveConfig()
end

savePositionsBtn.MouseButton1Click:Connect(function()
	saveCurrentPositions()
end)

loadPositionsBtn.MouseButton1Click:Connect(function()
	if recoverPositionsFromFile() then
		updateUIs()
	end
end)

local mainHotbar = Instance.new("Frame")
mainHotbar.Size = UDim2.new(1, -40, 0, settings.ButtonSize + 20)
mainHotbar.Position = UDim2.new(settings.HotbarPosX, settings.HotbarOffsetX, settings.HotbarPosY, settings.HotbarOffsetY)
mainHotbar.BackgroundTransparency = 1
mainHotbar.Parent = screenGui

local hotbarLockBtn = Instance.new("TextButton")
hotbarLockBtn.Size = UDim2.new(0, 32, 0, 32)
hotbarLockBtn.Position = UDim2.new(0.5, -16, 0, -38)
hotbarLockBtn.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
hotbarLockBtn.BackgroundTransparency = 0.2
hotbarLockBtn.Font = Enum.Font.GothamBold
hotbarLockBtn.TextSize = 14
hotbarLockBtn.Parent = mainHotbar

local hLockCorner = Instance.new("UICorner")
hLockCorner.CornerRadius = UDim.new(0, 8)
hLockCorner.Parent = hotbarLockBtn

local hLockStroke = Instance.new("UIStroke")
hLockStroke.Color = Color3.fromRGB(0, 200, 255)
hLockStroke.Transparency = 0.4
hLockStroke.Thickness = 1.5
hLockStroke.Parent = hotbarLockBtn

local function updateHotbarLockState()
	if settings.HotbarLocked then
		hotbarLockBtn.Text = "🔒"
	else
		hotbarLockBtn.Text = "🔓"
	end
end

updateHotbarLockState()

local hotbarListFrame = Instance.new("Frame")
hotbarListFrame.Size = UDim2.new(1, 0, 1, 0)
hotbarListFrame.BackgroundTransparency = 1
hotbarListFrame.Parent = mainHotbar

local hotbarList = Instance.new("UIListLayout")
hotbarList.FillDirection = Enum.FillDirection.Horizontal
hotbarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
hotbarList.Padding = UDim.new(0, 8)
hotbarList.Parent = hotbarListFrame

local isDraggingHotbar = false
local dragStartPos = nil
local hotbarStartPos = nil
local clickTime = 0

hotbarLockBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		clickTime = tick()
		if not settings.HotbarLocked then
			isDraggingHotbar = true
			dragStartPos = input.Position
			hotbarStartPos = mainHotbar.Position
		end
	end
end)

hotbarLockBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDraggingHotbar = false
		if tick() - clickTime < 0.2 then
			settings.HotbarLocked = not settings.HotbarLocked
			updateHotbarLockState()
			saveConfig()
		else
			if not settings.HotbarLocked then
				settings.HotbarPosX = mainHotbar.Position.X.Scale
				settings.HotbarOffsetX = mainHotbar.Position.X.Offset
				settings.HotbarPosY = mainHotbar.Position.Y.Scale
				settings.HotbarOffsetY = mainHotbar.Position.Y.Offset
				saveConfig()
			end
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if isDraggingHotbar and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStartPos
		mainHotbar.Position = UDim2.new(
			hotbarStartPos.X.Scale, hotbarStartPos.X.Offset + delta.X,
			hotbarStartPos.Y.Scale, hotbarStartPos.Y.Offset + delta.Y
		)
	end
end)

local draggingItemIndex = nil
local dragGhost = nil
local dragGhostConn = nil
local dragGhostTarget = nil
local dragGhostCurrent = nil

local draggingFromConfig = false
local dragPendingIndex = nil
local dragPendingSource = nil
local dragPendingButton = nil
local dragPendingTool = nil
local dragStartPosition = nil
local dragMoved = false
local configDragLocked = false
local organizerClickBlockUntil = 0
local DRAG_THRESHOLD = 8

local updateUIs
local refreshQueued = false

local slotButtons = {
	organizer = {},
	hotbar = {}
}

local function requestRefresh()
	if refreshQueued then
		return
	end
	refreshQueued = true
	task.delay(0.06, function()
		refreshQueued = false
		if screenGui and screenGui.Parent and updateUIs then
			updateUIs()
		end
	end)
end

local function clearDragGhost()
	if dragGhostConn then
		pcall(function()
			dragGhostConn:Disconnect()
		end)
		dragGhostConn = nil
	end

	if dragGhost then
		dragGhost:Destroy()
		dragGhost = nil
	end

	dragGhostTarget = nil
	dragGhostCurrent = nil
end

local function clearDragState()
	clearDragGhost()
	draggingItemIndex = nil
	draggingFromConfig = false
	dragPendingIndex = nil
	dragPendingSource = nil
	dragPendingButton = nil
	dragPendingTool = nil
	dragStartPosition = nil
	dragMoved = false
	configDragLocked = false
end

local function clearPendingState()
	draggingItemIndex = nil
	draggingFromConfig = false
	dragPendingIndex = nil
	dragPendingSource = nil
	dragPendingButton = nil
	dragPendingTool = nil
	dragStartPosition = nil
	dragMoved = false
	configDragLocked = false
end

local function beginGhost(btn, input, isOrganizer)
	if dragGhost then
		return
	end

	local size = isOrganizer and 56 or settings.ButtonSize

	dragGhost = Instance.new("ImageLabel")
	dragGhost.Size = UDim2.new(0, size, 0, size)
	dragGhost.Image = btn and btn.Image or ""
	dragGhost.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
	dragGhost.BackgroundTransparency = 0.2
	dragGhost.ZIndex = 50
	dragGhost.Parent = screenGui

	local gCorner = Instance.new("UICorner")
	gCorner.CornerRadius = UDim.new(0, 12)
	gCorner.Parent = dragGhost

	local gStroke = Instance.new("UIStroke")
	gStroke.Color = Color3.fromRGB(0, 200, 255)
	gStroke.Thickness = 2
	gStroke.Parent = dragGhost

	dragGhostCurrent = Vector2.new(
		input.Position.X - (size / 2),
		input.Position.Y - (size / 2)
	)
	dragGhostTarget = dragGhostCurrent
	dragGhost.Position = UDim2.new(0, dragGhostCurrent.X, 0, dragGhostCurrent.Y)

	dragGhostConn = RunService.RenderStepped:Connect(function()
		if not dragGhost or not dragGhostTarget or not dragGhostCurrent then
			return
		end

		dragGhostCurrent = dragGhostCurrent:Lerp(dragGhostTarget, 0.38)
		dragGhost.Position = UDim2.new(0, dragGhostCurrent.X, 0, dragGhostCurrent.Y)
	end)
end

local function getSlotHovered(mousePos, targetContainer)
	for _, btn in pairs(targetContainer:GetChildren()) do
		if btn:IsA("ImageButton") then
			local pos = btn.AbsolutePosition
			local size = btn.AbsoluteSize
			if mousePos.X >= pos.X and mousePos.X <= pos.X + size.X and
				mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y then
				return btn:GetAttribute("SlotIndex")
			end
		end
	end
	return nil
end

local function getHotbarSlotHovered(mousePos)
	return getSlotHovered(mousePos, hotbarListFrame)
end

local function getOrganizerSlotHovered(mousePos)
	return getSlotHovered(mousePos, gridFrame)
end

local function swapInventoryPositions(a, b)
	if not a or not b or a == b then
		return
	end

	local temp = inventoryOrder[a]
	inventoryOrder[a] = inventoryOrder[b]
	inventoryOrder[b] = temp

	selectedForMove = nil
	updateUIs()
end

UserInputService.InputChanged:Connect(function(input)
	if dragPendingIndex and dragStartPosition and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		if dragPendingSource == "hotbar" and settings.HotbarLocked then
			return
		end

		local delta = input.Position - dragStartPosition
		local dist = math.sqrt(delta.X * delta.X + delta.Y * delta.Y)

		if not dragMoved and dist >= DRAG_THRESHOLD then
			dragMoved = true
			draggingItemIndex = dragPendingIndex
			draggingFromConfig = (dragPendingSource == "organizer")
			configDragLocked = draggingFromConfig
			beginGhost(
				dragPendingButton,
				input,
				dragPendingSource == "organizer"
			)
		end

		if dragGhost then
			dragGhostTarget = Vector2.new(
				input.Position.X - (dragGhost.AbsoluteSize.X / 2),
				input.Position.Y - (dragGhost.AbsoluteSize.Y / 2)
			)
		end
	elseif dragGhost and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		dragGhostTarget = Vector2.new(input.Position.X - 28, input.Position.Y - 28)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	if dragGhost then
		local targetIndex = getSlotHovered(input.Position, gridFrame)
		if not targetIndex then
			targetIndex = getSlotHovered(input.Position, hotbarListFrame)
		end

		if targetIndex and targetIndex ~= draggingItemIndex then
			swapInventoryPositions(draggingItemIndex, targetIndex)
		end

		clearDragState()
		organizerClickBlockUntil = tick() + 0.15
		return
	end

	if dragPendingIndex then
		clearPendingState()
	end
end)

UserInputService.WindowFocusReleased:Connect(function()
	clearDragState()
end)

local function syncInventory()
	local currentTools = getAllTools()

	for i = #inventoryOrder, 1, -1 do
		if not inventoryOrder[i] or not inventoryOrder[i].Parent then
			table.remove(inventoryOrder, i)
		end
	end

	if not inventoryInitialized then
		if #currentTools == 0 then
			return false
		end

		if type(savedOrder) == "table" and #savedOrder > 0 then
			inventoryOrder = rebuildInventoryOrderFromSaved(currentTools, savedOrder)
		else
			inventoryOrder = currentTools
		end

		inventoryInitialized = true
		return true
	end

	for _, tool in ipairs(currentTools) do
		if not containsTool(inventoryOrder, tool) then
			table.insert(inventoryOrder, tool)
		end
	end

	return true
end

local function createSlotButton(tool, isOrganizer, index)
	local btn = Instance.new("ImageButton")

	local btnSize = isOrganizer and 56 or settings.ButtonSize
	btn.Size = UDim2.new(0, btnSize, 0, btnSize)
	btn.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
	btn.BackgroundTransparency = 0.35
	btn.Image = tool and tool.TextureId or ""
	btn:SetAttribute("SlotIndex", index)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1.8
	stroke.Transparency = 0.4
	stroke.Parent = btn

	if tool then
		local isEquipped = (tool.Parent == player.Character)
		stroke.Color = isEquipped and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(60, 80, 110)

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -6, 0.3, 0)
		nameLabel.Position = UDim2.new(0, 3, 0.68, 0)
		nameLabel.BackgroundTransparency = 0.4
		nameLabel.BackgroundColor3 = Color3.fromRGB(8, 10, 15)
		nameLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
		nameLabel.Text = tool.Name
		nameLabel.TextScaled = true
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.Parent = btn

		local labelCorner = Instance.new("UICorner")
		labelCorner.CornerRadius = UDim.new(0, 6)
		labelCorner.Parent = nameLabel

		if isOrganizer then
			if selectedForMove == index then
				stroke.Color = Color3.fromRGB(0, 200, 255)
			end

			btn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if configDragLocked then
						return
					end

					dragPendingIndex = index
					dragPendingSource = "organizer"
					dragPendingButton = btn
					dragPendingTool = tool
					dragStartPosition = input.Position
					dragMoved = false
				end
			end)

			btn.MouseButton1Click:Connect(function()
				if tick() < organizerClickBlockUntil then
					return
				end

				if dragMoved then
					return
				end

				if dragPendingSource ~= "organizer" or dragPendingIndex ~= index then
					return
				end

				if not selectedForMove then
					selectedForMove = index
				else
					if selectedForMove == index then
						selectedForMove = nil
					else
						swapInventoryPositions(selectedForMove, index)
					end
				end

				clearPendingState()
				updateUIs()
			end)
		else
			btn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if not settings.HotbarLocked then
						dragPendingIndex = index
						dragPendingSource = "hotbar"
						dragPendingButton = btn
						dragPendingTool = tool
						dragStartPosition = input.Position
						dragMoved = false
					end
				end
			end)

			btn.MouseButton1Click:Connect(function()
				if dragMoved then
					return
				end

				local hum = player.Character and player.Character:FindFirstChild("Humanoid")
				if hum then
					if isEquipped then
						hum:UnequipTools()
					else
						hum:EquipTool(tool)
					end
				end
			end)
		end
	else
		stroke.Color = Color3.fromRGB(35, 45, 65)

		if isOrganizer then
			btn.MouseButton1Click:Connect(function()
				if selectedForMove then
					swapInventoryPositions(selectedForMove, index)
				end
			end)
		end
	end

	return btn
end

function updateUIs()
	local ready = syncInventory()
	if not ready then
		return
	end

	local totalItems = #inventoryOrder
	local slotsToShowInOrganizer = math.max(settings.MaxSlots, totalItems)
	if slotsToShowInOrganizer < 15 then
		slotsToShowInOrganizer = 15
	end

	local rows = math.ceil(slotsToShowInOrganizer / 5)
	gridFrame.CanvasSize = UDim2.new(0, 0, 0, rows * 64)

	mainHotbar.Size = UDim2.new(1, -40, 0, settings.ButtonSize + 20)

	for _, child in pairs(hotbarListFrame:GetChildren()) do
		if child:IsA("ImageButton") then
			child:Destroy()
		end
	end

	for _, child in pairs(gridFrame:GetChildren()) do
		if child:IsA("ImageButton") then
			child:Destroy()
		end
	end

	slotButtons.organizer = {}
	slotButtons.hotbar = {}

	for i = 1, slotsToShowInOrganizer do
		local tool = inventoryOrder[i]

		local orgBtn = createSlotButton(tool, true, i)
		orgBtn.Parent = gridFrame
		slotButtons.organizer[i] = orgBtn

		if i <= settings.MaxSlots and tool then
			local hotbarBtn = createSlotButton(tool, false, i)
			hotbarBtn.Parent = hotbarListFrame
			slotButtons.hotbar[i] = hotbarBtn
		end
	end
end

slotInput.FocusLost:Connect(function()
	local num = tonumber(slotInput.Text)
	if num and num > 0 then
		settings.MaxSlots = math.floor(num)
		saveConfig()
		updateUIs()
	else
		slotInput.Text = tostring(settings.MaxSlots)
	end
	configPanel.Visible = false
end)

sizeInput.FocusLost:Connect(function()
	local num = tonumber(sizeInput.Text)
	if num and num >= 30 and num <= 90 then
		settings.ButtonSize = math.floor(num)
		saveConfig()
		updateUIs()
	else
		sizeInput.Text = tostring(settings.ButtonSize)
	end
	configPanel.Visible = false
end)

local charConnections = {}
local backpackConnections = {}

local function disconnectList(list)
	for i = #list, 1, -1 do
		local c = list[i]
		if c then
			pcall(function()
				c:Disconnect()
			end)
		end
		list[i] = nil
	end
end

local function bindCharacter(targetChar)
	disconnectList(charConnections)

	if not targetChar then
		return
	end

	local hum = targetChar:FindFirstChildOfClass("Humanoid")
	if hum then
		table.insert(charConnections, hum.Died:Connect(function()
			clearDragState()
			inventoryInitialized = false
			requestRefresh()
		end))
	end

	table.insert(charConnections, targetChar.ChildAdded:Connect(function()
		requestRefresh()
	end))

	table.insert(charConnections, targetChar.ChildRemoved:Connect(function()
		requestRefresh()
	end))

	inventoryInitialized = false
	requestRefresh()
end

local function bindBackpack()
	disconnectList(backpackConnections)

	local bp = player:WaitForChild("Backpack")
	table.insert(backpackConnections, bp.ChildAdded:Connect(function()
		requestRefresh()
	end))

	table.insert(backpackConnections, bp.ChildRemoved:Connect(function()
		requestRefresh()
	end))

	requestRefresh()
end

player.CharacterAdded:Connect(function(char)
	clearDragState()
	inventoryInitialized = false
	bindCharacter(char)
	bindBackpack()
	task.delay(0.15, function()
		requestRefresh()
	end)
end)

player.CharacterRemoving:Connect(function()
	clearDragState()
	inventoryInitialized = false
end)

bindCharacter(player.Character)
bindBackpack()

updateUIs()
