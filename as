local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local CoreGui=game:GetService("CoreGui")

local LocalPlayer=Players.LocalPlayer
local targetFolder=LocalPlayer:WaitForChild("PlayerGui")
local spmName="Internal_AP_System"

local COLORS = {
	bg = Color3.fromRGB(8, 18, 36),
	bg2 = Color3.fromRGB(12, 28, 54),
	bg3 = Color3.fromRGB(18, 42, 78),
	accent = Color3.fromRGB(60, 150, 255),
	accent2 = Color3.fromRGB(90, 180, 255),
	text = Color3.fromRGB(245, 248, 255),
	muted = Color3.fromRGB(180, 205, 235),
	stroke = Color3.fromRGB(40, 95, 165),
	gold = Color3.fromRGB(255, 210, 60)
}

local POS_FILE = "Internal_AP_System_pos.txt"

local function getDefaultPosition()
	return UDim2.new(0.5, -75, 0.5, -14)
end

local function savePosition(pos)
	if not writefile then
		return
	end

	local xs = tonumber(pos.X.Scale) or 0
	local xo = math.floor((tonumber(pos.X.Offset) or 0) + 0.5)
	local ys = tonumber(pos.Y.Scale) or 0
	local yo = math.floor((tonumber(pos.Y.Offset) or 0) + 0.5)

	pcall(function()
		writefile(
			POS_FILE,
			string.format("%.6f,%d,%.6f,%d", xs, xo, ys, yo)
		)
	end)
end

local function loadPosition()
	if not (readfile and isfile) then
		return getDefaultPosition()
	end

	local ok,data=pcall(function()
		if isfile(POS_FILE) then
			return readfile(POS_FILE)
		end

		return nil
	end)

	if not ok or type(data)~="string" or data=="" then
		return getDefaultPosition()
	end

	local nums={}

	for n in data:gmatch("[-+]?%d*%.?%d+") do
		local v=tonumber(n)

		if v then
			table.insert(nums,v)
		end
	end

	if #nums>=4 then
		return UDim2.new(
			nums[1],
			nums[2],
			nums[3],
			nums[4]
		)
	end

	return getDefaultPosition()
end

if targetFolder:FindFirstChild(spmName) then
	targetFolder[spmName]:Destroy()
end

local function tw(o,i,p)
	TweenService:Create(o,i,p):Play()
end

local function fireClick(button)
	if not button then
		return
	end

	if firesignal then
		pcall(function()
			firesignal(button.MouseButton1Click)
		end)

		pcall(function()
			firesignal(button.MouseButton1Down)
		end)

		pcall(function()
			firesignal(button.Activated)
		end)
	end
end

local function runAdminCommand(targetPlayer,commandName)
	local adminGui=targetFolder:FindFirstChild("AdminPanel")
	if not adminGui then
		return false
	end

	local adminPanel=adminGui:FindFirstChild("AdminPanel")
	if not adminPanel then
		return false
	end

	local contentScroll=adminPanel:FindFirstChild("Content")
	if not contentScroll then
		return false
	end

	local scrollingFrame=contentScroll:FindFirstChild("ScrollingFrame")
	if not scrollingFrame then
		return false
	end

	local cmdBtn=scrollingFrame:FindFirstChild(commandName)
	if not cmdBtn then
		return false
	end

	fireClick(cmdBtn)

	task.wait(0.05)

	local profilesScroll=adminPanel:FindFirstChild("Profiles")
	if not profilesScroll then
		return false
	end

	local profilesScrollingFrame=profilesScroll:FindFirstChild("ScrollingFrame")
	if not profilesScrollingFrame then
		return false
	end

	local playerBtn=profilesScrollingFrame:FindFirstChild(targetPlayer.Name)
	if not playerBtn then
		return false
	end

	fireClick(playerBtn)

	return true
end

local function runSingleCmd(targetPlayer,cmd)
	pcall(runAdminCommand,targetPlayer,cmd)
end

local cmdsToSpam={
	"rocket",
	"morph",
	"inverse",
	"control",
	"ragdoll",
	"balloon",
	"nightvision",
	"jumpscare",
	"jail",
	"tiny"
}

--------------------------------------------------
-- ADMIN PANEL REVERSA
--------------------------------------------------

local reverseEnabled=false

local reverseCommands={}

for _,cmd in ipairs(cmdsToSpam) do
	reverseCommands[cmd:lower()]=true
end

local reverseDebounce={}

local function normalizeText(text)
	if type(text)~="string" then
		return ""
	end

	text=text:gsub("^%s+","")
	text=text:gsub("%s+$","")

	return text
end

local function findPlayerByName(name)
	name=normalizeText(name):lower()

	if name=="" then
		return nil
	end

	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LocalPlayer then
			if p.Name:lower()==name then
				return p
			end

			if p.DisplayName:lower()==name then
				return p
			end
		end
	end

	-- Búsqueda parcial por si el texto mostrado trae algún formato adicional
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LocalPlayer then
			if name:find(p.Name:lower(),1,true) then
				return p
			end

			if name:find(p.DisplayName:lower(),1,true) then
				return p
			end
		end
	end

	return nil
end

local function reverseIncomingCommand(text)
	if not reverseEnabled then
		return
	end

	text=normalizeText(text)

	if text=="" then
		return
	end

	------------------------------------------------
	-- FORMATO:
	-- Tokito_2025Muichiro ran "jumpscare" on you! BOO!
	------------------------------------------------

	local playerName,commandName=text:match(
		'^(.-)%s+ran%s+"([^"]+)"%s+on%s+you!'
	)

	if not playerName or not commandName then
		return
	end

	playerName=normalizeText(playerName)
	commandName=normalizeText(commandName):lower()

	if playerName=="" or commandName=="" then
		return
	end

	-- Solo devuelve comandos permitidos
	if not reverseCommands[commandName] then
		return
	end

	local targetPlayer=findPlayerByName(playerName)

	if not targetPlayer then
		return
	end

	------------------------------------------------
	-- Evitar duplicados por un mismo mensaje
	------------------------------------------------

	local debounceKey=tostring(targetPlayer.UserId)..":"..commandName

	if reverseDebounce[debounceKey] then
		return
	end

	reverseDebounce[debounceKey]=true

	task.spawn(function()
		pcall(function()
			runAdminCommand(targetPlayer,commandName)
		end)

		task.wait(0.35)

		reverseDebounce[debounceKey]=nil
	end)
end

--------------------------------------------------
-- DETECTOR DE MENSAJES
--------------------------------------------------

local watchedObjects={}

local function watchTextObject(obj)
	if not obj then
		return
	end

	if watchedObjects[obj] then
		return
	end

	if not obj:IsA("TextLabel")
		and not obj:IsA("TextButton")
		and not obj:IsA("TextBox") then
		return
	end

	watchedObjects[obj]=true

	obj:GetPropertyChangedSignal("Text"):Connect(function()
		if obj and obj.Parent then
			reverseIncomingCommand(obj.Text)
		end
	end)

	if obj.Text and obj.Text~="" then
		reverseIncomingCommand(obj.Text)
	end
end

local function watchGuiTree(root)
	if not root then
		return
	end

	for _,obj in ipairs(root:GetDescendants()) do
		watchTextObject(obj)
	end

	root.DescendantAdded:Connect(function(obj)
		task.defer(function()
			if obj and obj.Parent then
				watchTextObject(obj)
			end
		end)
	end)
end

watchGuiTree(targetFolder)

pcall(function()
	watchGuiTree(CoreGui)
end)

--------------------------------------------------
-- OWNER / SPAM
--------------------------------------------------

local function spamPlayer(targetPlayer)
	task.spawn(function()
		for _,cmd in ipairs(cmdsToSpam) do
			pcall(runAdminCommand,targetPlayer,cmd)
			task.wait(0.15)
		end
	end)
end

local function getStealingInfo(p)
	local s=p:GetAttribute("Stealing")
	local i=p:GetAttribute("StealingIndex")

	if s and i then
		return true,i
	elseif s then
		return true,nil
	end

	return false,nil
end

local function getNearestOwner()
	local char=LocalPlayer.Character
	local hrp=char and char:FindFirstChild("HumanoidRootPart")

	if not hrp then
		return nil
	end

	local plots=Workspace:FindFirstChild("Plots")

	if not plots then
		return nil
	end

	local myPlot
	local lpName=LocalPlayer.Name:lower()
	local lpDisplay=LocalPlayer.DisplayName:lower()

	for _,p in pairs(plots:GetChildren()) do
		local sign=p:FindFirstChild("PlotSign")
		local lbl=sign and sign:FindFirstChild("TextLabel",true)

		if lbl then
			local txt=lbl.Text:lower()

			if txt:find(lpName,1,true)
				or txt:find(lpDisplay,1,true) then

				myPlot=p
				break
			end
		end
	end

	local nearestPlot
	local nearestDist=math.huge

	for _,p in pairs(plots:GetChildren()) do
		if p~=myPlot then
			local sign=p:FindFirstChild("PlotSign")
			local part=sign and sign:FindFirstChildWhichIsA(
				"BasePart",
				true
			)

			if part then
				local dist=(hrp.Position-part.Position).Magnitude

				if dist<nearestDist then
					nearestDist=dist
					nearestPlot=p
				end
			end
		end
	end

	if not nearestPlot then
		return nil
	end

	local sign=nearestPlot:FindFirstChild("PlotSign")
	local lbl=sign and sign:FindFirstChild("TextLabel",true)

	if not lbl then
		return nil
	end

	local txt=lbl.Text:lower()

	for _,p in pairs(Players:GetPlayers()) do
		if p~=LocalPlayer then
			if txt:find(p.Name:lower(),1,true)
				or txt:find(p.DisplayName:lower(),1,true) then

				return p
			end
		end
	end

	return nil
end

local function spamOwner()
	local target=getNearestOwner()

	if not target then
		return
	end

	task.spawn(function()
		pcall(runAdminCommand,target,"rocket")
		task.wait(0.1)

		pcall(runAdminCommand,target,"jail")
		task.wait(1)

		local ownerCmds={
			"balloon",
			"inverse",
			"control",
			"jumpscare",
			"morph",
			"nightvision",
			"ragdoll",
			"tiny"
		}

		for _,cmd in ipairs(ownerCmds) do
			pcall(runAdminCommand,target,cmd)
			task.wait(0.15)
		end
	end)
end

--------------------------------------------------
-- GUI
--------------------------------------------------

local sg=Instance.new("ScreenGui",targetFolder)
sg.Name=spmName
sg.ResetOnSpawn=false
sg.DisplayOrder=999

local main=Instance.new("Frame",sg)
main.Size=UDim2.new(0,150,0,28)
main.Position=loadPosition()
main.BackgroundColor3=COLORS.bg
main.BorderSizePixel=0
main.ClipsDescendants=true

Instance.new("UICorner",main).CornerRadius=UDim.new(0,8)

local mainStroke=Instance.new("UIStroke",main)
mainStroke.Color=COLORS.stroke
mainStroke.Thickness=1
mainStroke.Transparency=0.15

local mainGrad=Instance.new("UIGradient",main)
mainGrad.Color=ColorSequence.new({
	ColorSequenceKeypoint.new(0,COLORS.bg3),
	ColorSequenceKeypoint.new(1,COLORS.bg)
})
mainGrad.Rotation=90

--------------------------------------------------
-- HEADER
--------------------------------------------------

local header=Instance.new("TextButton",main)
header.Size=UDim2.new(1,0,0,28)
header.BackgroundColor3=COLORS.bg2
header.BorderSizePixel=0
header.Text=""
header.AutoButtonColor=false

Instance.new("UICorner",header).CornerRadius=UDim.new(0,8)

local headerStroke=Instance.new("UIStroke",header)
headerStroke.Color=COLORS.accent
headerStroke.Thickness=1
headerStroke.Transparency=0.35

local headerGrad=Instance.new("UIGradient",header)
headerGrad.Color=ColorSequence.new({
	ColorSequenceKeypoint.new(0,COLORS.accent),
	ColorSequenceKeypoint.new(1,COLORS.bg2)
})
headerGrad.Rotation=0

local title=Instance.new("TextLabel",header)
title.Size=UDim2.new(1,-20,1,0)
title.Position=UDim2.new(0,8,0,0)
title.BackgroundTransparency=1
title.Text="AP Spammer"
title.TextColor3=COLORS.text
title.TextSize=11
title.Font=Enum.Font.GothamBold
title.TextXAlignment=Enum.TextXAlignment.Left

local arrow=Instance.new("TextLabel",header)
arrow.Size=UDim2.new(0,16,1,0)
arrow.Position=UDim2.new(1,-16,0,0)
arrow.BackgroundTransparency=1
arrow.Text="▼"
arrow.TextColor3=COLORS.muted
arrow.TextSize=9
arrow.Font=Enum.Font.GothamBold

local ownerBtn=Instance.new("TextButton",header)
ownerBtn.Size=UDim2.new(0,26,0,18)
ownerBtn.Position=UDim2.new(1,-45,0.5,-9)
ownerBtn.BackgroundColor3=COLORS.accent
ownerBtn.Text="👑"
ownerBtn.TextSize=11
ownerBtn.Font=Enum.Font.GothamBold
ownerBtn.TextColor3=COLORS.text
ownerBtn.AutoButtonColor=false

Instance.new("UICorner",ownerBtn).CornerRadius=UDim.new(0,5)

local ownerStroke=Instance.new("UIStroke",ownerBtn)
ownerStroke.Color=COLORS.accent2
ownerStroke.Thickness=1
ownerStroke.Transparency=0.2

--------------------------------------------------
-- CONTAINER
--------------------------------------------------

local container=Instance.new("Frame",main)
container.Size=UDim2.new(1,0,0,0)
container.Position=UDim2.new(0,0,0,28)
container.BackgroundColor3=COLORS.bg
container.BorderSizePixel=0
container.ClipsDescendants=true

Instance.new("UICorner",container).CornerRadius=UDim.new(0,8)

local containerStroke=Instance.new("UIStroke",container)
containerStroke.Color=COLORS.stroke
containerStroke.Thickness=1
containerStroke.Transparency=0.25

--------------------------------------------------
-- ADMIN PANEL REVERSA OPTION
--------------------------------------------------

local OPTION_H=22

local reverseOption=Instance.new("TextButton",container)
reverseOption.Size=UDim2.new(1,-6,0,20)
reverseOption.Position=UDim2.new(0,3,0,1)
reverseOption.BackgroundColor3=COLORS.bg2
reverseOption.BorderSizePixel=0
reverseOption.Text=""
reverseOption.AutoButtonColor=false

Instance.new("UICorner",reverseOption).CornerRadius=UDim.new(0,5)

local reverseStroke=Instance.new("UIStroke",reverseOption)
reverseStroke.Color=COLORS.stroke
reverseStroke.Thickness=1
reverseStroke.Transparency=0.55

local reverseCheck=Instance.new("TextLabel",reverseOption)
reverseCheck.Size=UDim2.new(0,18,1,0)
reverseCheck.Position=UDim2.new(0,4,0,0)
reverseCheck.BackgroundTransparency=1
reverseCheck.Text=""
reverseCheck.TextColor3=COLORS.accent2
reverseCheck.TextSize=12
reverseCheck.Font=Enum.Font.GothamBold
reverseCheck.TextXAlignment=Enum.TextXAlignment.Center
reverseCheck.TextYAlignment=Enum.TextYAlignment.Center

local reverseText=Instance.new("TextLabel",reverseOption)
reverseText.Size=UDim2.new(1,-28,1,0)
reverseText.Position=UDim2.new(0,25,0,0)
reverseText.BackgroundTransparency=1
reverseText.Text="Admin Panel Reversa"
reverseText.TextColor3=COLORS.muted
reverseText.TextSize=9
reverseText.Font=Enum.Font.GothamBold
reverseText.TextXAlignment=Enum.TextXAlignment.Left

local function updateReverseUI()
	if reverseEnabled then
		reverseCheck.Text="✓"
		reverseText.TextColor3=COLORS.text
		reverseStroke.Color=COLORS.accent
		reverseOption.BackgroundColor3=COLORS.bg3
	else
		reverseCheck.Text=""
		reverseText.TextColor3=COLORS.muted
		reverseStroke.Color=COLORS.stroke
		reverseOption.BackgroundColor3=COLORS.bg2
	end
end

reverseOption.MouseButton1Click:Connect(function()
	reverseEnabled=not reverseEnabled
	updateReverseUI()
end)

updateReverseUI()

--------------------------------------------------
-- PLAYER LIST
--------------------------------------------------

local playerList=Instance.new("ScrollingFrame",container)
playerList.Size=UDim2.new(1,0,1,-OPTION_H)
playerList.Position=UDim2.new(0,0,0,OPTION_H)
playerList.BackgroundTransparency=1
playerList.BorderSizePixel=0
playerList.ScrollBarThickness=3
playerList.ScrollBarImageColor3=COLORS.accent

local UIList=Instance.new("UIListLayout",playerList)
UIList.Padding=UDim.new(0,2)

--------------------------------------------------
-- POSITION / DRAG
--------------------------------------------------

local minimized=true
local SHOW=3
local HEIGHT=36

local dragging=false
local dragInput=nil
local dragStart=nil
local startPos=nil
local dragMoved=false
local DRAG_THRESHOLD=8

local function clampMainToScreen()
	local cam=Workspace.CurrentCamera

	if not cam or not main or not main.Parent then
		return
	end

	local size=main.AbsoluteSize

	if size.X<=0 or size.Y<=0 then
		return
	end

	local pos=main.AbsolutePosition

	local maxX=math.max(0,cam.ViewportSize.X-size.X)
	local maxY=math.max(0,cam.ViewportSize.Y-size.Y)

	local x=math.clamp(pos.X,0,maxX)
	local y=math.clamp(pos.Y,0,maxY)

	if x~=pos.X or y~=pos.Y then
		main.Position=UDim2.new(0,x,0,y)
	end
end

header.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1
		or i.UserInputType==Enum.UserInputType.Touch then

		dragging=true
		dragMoved=false
		dragStart=i.Position
		startPos=main.Position
		dragInput=i

		i.Changed:Connect(function()
			if i.UserInputState==Enum.UserInputState.End then
				if dragging then
					dragging=false
					savePosition(main.Position)

					task.defer(function()
						clampMainToScreen()
					end)
				end
			end
		end)
	end
end)

header.InputChanged:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseMovement
		or i.UserInputType==Enum.UserInputType.Touch then

		dragInput=i
	end
end)

UserInputService.InputChanged:Connect(function(i)
	if dragging and i==dragInput and dragStart and startPos then
		local d=i.Position-dragStart

		if d.Magnitude>=DRAG_THRESHOLD then
			dragMoved=true
		end

		main.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+d.X,
			startPos.Y.Scale,
			startPos.Y.Offset+d.Y
		)

		savePosition(main.Position)
	end
end)

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

local function toggle()
	minimized=not minimized

	if minimized then
		arrow.Text="▼"

		container.Size=UDim2.new(
			1,
			0,
			0,
			0
		)

		main.Size=UDim2.new(
			0,
			150,
			0,
			28
		)
	else
		arrow.Text="▲"

		local h=math.min(
			#Players:GetPlayers()-1,
			SHOW
		)*HEIGHT

		container.Size=UDim2.new(
			1,
			0,
			0,
			OPTION_H+h
		)

		main.Size=UDim2.new(
			0,
			150,
			0,
			28+OPTION_H+h
		)
	end

	task.defer(function()
		clampMainToScreen()
	end)
end

header.MouseButton1Click:Connect(function()
	if dragMoved then
		return
	end

	toggle()
end)

ownerBtn.MouseButton1Click:Connect(spamOwner)

--------------------------------------------------
-- ICONS
--------------------------------------------------

local icons={
	{icon="🚀",cmd="rocket"},
	{icon="🏃",cmd="ragdoll"},
	{icon="🔒",cmd="jail"},
	{icon="🎈",cmd="balloon"}
}

local function flash(ic)
	ic.BackgroundTransparency=0
	ic.BackgroundColor3=COLORS.accent

	task.delay(2,function()
		if ic and ic.Parent then
			ic.BackgroundTransparency=1
		end
	end)
end

--------------------------------------------------
-- UPDATE PLAYER LIST
--------------------------------------------------

local function updatePlayerList()
	for _,v in pairs(playerList:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end

	local top={}
	local normal={}

	for _,p in pairs(Players:GetPlayers()) do
		if p~=LocalPlayer then
			if p:GetAttribute("Stealing") then
				table.insert(top,p)
			else
				table.insert(normal,p)
			end
		end
	end

	local list={}

	for _,p in ipairs(top) do
		table.insert(list,p)
	end

	for _,p in ipairs(normal) do
		table.insert(list,p)
	end

	for _,p in ipairs(list) do
		local stealing,index=getStealingInfo(p)

		local btn=Instance.new(
			"TextButton",
			playerList
		)

		btn.Size=UDim2.new(1,-8,0,34)
		btn.BackgroundColor3=COLORS.bg2
		btn.BorderSizePixel=0
		btn.Text=""
		btn.AutoButtonColor=false

		Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)

		local btnStroke=Instance.new("UIStroke",btn)
		btnStroke.Color=COLORS.stroke
		btnStroke.Thickness=1
		btnStroke.Transparency=0.45

		btn.MouseButton1Click:Connect(function()
			spamPlayer(p)
		end)

		------------------------------------------------
		-- AVATAR
		------------------------------------------------

		local avatar=Instance.new("ImageLabel",btn)
		avatar.Size=UDim2.new(0,24,0,24)
		avatar.Position=UDim2.new(0,5,0.5,-12)
		avatar.BackgroundColor3=COLORS.bg3
		avatar.Image=
			"rbxthumb://type=AvatarHeadShot&id="
			..p.UserId..
			"&w=48&h=48"

		Instance.new("UICorner",avatar).CornerRadius=UDim.new(1,0)

		local avatarStroke=Instance.new("UIStroke",avatar)
		avatarStroke.Color=COLORS.accent
		avatarStroke.Thickness=1
		avatarStroke.Transparency=0.35

		------------------------------------------------
		-- NAME
		------------------------------------------------

		local name=Instance.new("TextLabel",btn)
		name.Size=UDim2.new(1,-65,0,12)
		name.Position=UDim2.new(0,34,0,2)
		name.BackgroundTransparency=1
		name.Text=p.DisplayName
		name.TextColor3=COLORS.text
		name.TextSize=11
		name.Font=Enum.Font.GothamBold
		name.TextXAlignment=Enum.TextXAlignment.Left

		------------------------------------------------
		-- INDEX
		------------------------------------------------

		local sub=Instance.new("TextLabel",btn)
		sub.Size=UDim2.new(1,-65,0,10)
		sub.Position=UDim2.new(0,34,0,13)
		sub.BackgroundTransparency=1
		sub.Text=index and tostring(index) or ""
		sub.TextColor3=COLORS.gold
		sub.TextSize=9
		sub.Font=Enum.Font.GothamBold
		sub.TextXAlignment=Enum.TextXAlignment.Left

		------------------------------------------------
		-- COMMAND ICONS
		------------------------------------------------

		for i,v in ipairs(icons) do
			local ic=Instance.new("TextButton",btn)

			ic.Size=UDim2.new(0,18,0,10)

			ic.Position=UDim2.new(
				0,
				34+(i-1)*20,
				0,
				23
			)

			ic.BackgroundTransparency=1
			ic.Text=""

			local emoji=Instance.new("TextLabel",ic)
			emoji.Size=UDim2.new(1,0,1,0)
			emoji.BackgroundTransparency=1
			emoji.Text=v.icon
			emoji.TextSize=10
			emoji.Font=Enum.Font.GothamBold
			emoji.TextColor3=COLORS.text

			ic.MouseButton1Click:Connect(function()
				runSingleCmd(p,v.cmd)
				flash(ic)
			end)
		end
	end

	playerList.CanvasSize=UDim2.new(
		0,
		0,
		0,
		#list*HEIGHT
	)

	if not minimized then
		local h=math.min(#list,SHOW)*HEIGHT

		container.Size=UDim2.new(
			1,
			0,
			0,
			OPTION_H+h
		)

		main.Size=UDim2.new(
			0,
			150,
			0,
			28+OPTION_H+h
		)
	end

	task.defer(function()
		clampMainToScreen()
	end)
end

--------------------------------------------------
-- PLAYER EVENTS
--------------------------------------------------

Players.PlayerAdded:Connect(function(player)
	player.AttributeChanged:Connect(function()
		updatePlayerList()
	end)

	updatePlayerList()
end)

Players.PlayerRemoving:Connect(function()
	updatePlayerList()
end)

for _,p in pairs(Players:GetPlayers()) do
	if p~=LocalPlayer then
		p.AttributeChanged:Connect(function()
			updatePlayerList()
		end)
	end
end

--------------------------------------------------
-- INITIALIZE
--------------------------------------------------

updatePlayerList()

task.defer(function()
	clampMainToScreen()
end)
