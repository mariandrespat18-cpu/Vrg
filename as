local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local LocalPlayer=Players.LocalPlayer
local targetFolder=LocalPlayer:WaitForChild("PlayerGui")
local spmName="Internal_AP_System"
if targetFolder:FindFirstChild(spmName) then
targetFolder[spmName]:Destroy()
end
local function tw(o,i,p)
TweenService:Create(o,i,p):Play()
end
local function fireClick(button)
if button then
if firesignal then
firesignal(button.MouseButton1Click)
firesignal(button.MouseButton1Down)
firesignal(button.Activated)
end
end
end
local function runAdminCommand(targetPlayer,commandName)
local adminGui=targetFolder:FindFirstChild("AdminPanel")
if not adminGui then return false end
local adminPanel=adminGui:FindFirstChild("AdminPanel")
if not adminPanel then return false end
local contentScroll=adminPanel:FindFirstChild("Content")
if not contentScroll then return false end
local scrollingFrame=contentScroll:FindFirstChild("ScrollingFrame")
if not scrollingFrame then return false end
local cmdBtn=scrollingFrame:FindFirstChild(commandName)
if not cmdBtn then return false end
fireClick(cmdBtn)
task.wait(0.05)
local profilesScroll=adminPanel:FindFirstChild("Profiles")
if not profilesScroll then return false end
local profilesScrollingFrame=profilesScroll:FindFirstChild("ScrollingFrame")
if not profilesScrollingFrame then return false end
local playerBtn=profilesScrollingFrame:FindFirstChild(targetPlayer.Name)
if not playerBtn then return false end
fireClick(playerBtn)
return true
end
local function runSingleCmd(targetPlayer,cmd)
pcall(runAdminCommand,targetPlayer,cmd)
end
local cmdsToSpam={"rocket","morph","inverse","ragdoll","balloon","nightvision","jumpscare","jail","tiny"}
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
if s and i then return true,i elseif s then return true,nil end
return false,nil
end
local function getNearestOwner()
local char=LocalPlayer.Character
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return nil end
local plots=Workspace:FindFirstChild("Plots")
if not plots then return nil end
local myPlot
local lpName=LocalPlayer.Name:lower()
local lpDisplay=LocalPlayer.DisplayName:lower()
for _,p in pairs(plots:GetChildren()) do
local sign=p:FindFirstChild("PlotSign")
local lbl=sign and sign:FindFirstChild("TextLabel",true)
if lbl and (lbl.Text:lower():find(lpName) or lbl.Text:lower():find(lpDisplay)) then
myPlot=p
break
end
end
local nearestPlot
local nearestDist=math.huge
for _,p in pairs(plots:GetChildren()) do
if p ~=myPlot then
local sign=p:FindFirstChild("PlotSign")
local part=sign and sign:FindFirstChildWhichIsA("BasePart",true)
if part then
local dist=(hrp.Position - part.Position).Magnitude
if dist < nearestDist then
nearestDist=dist
nearestPlot=p
end
end
end
end
if not nearestPlot then return nil end
local sign=nearestPlot:FindFirstChild("PlotSign")
local lbl=sign and sign:FindFirstChild("TextLabel",true)
if not lbl then return nil end
local txt=lbl.Text:lower()
for _,p in pairs(Players:GetPlayers()) do
if p ~=LocalPlayer then
if txt:find(p.Name:lower()) or txt:find(p.DisplayName:lower()) then
return p
end
end
end
return nil
end
local function spamOwner()
local target=getNearestOwner()
if not target then return end
task.spawn(function()
pcall(runAdminCommand,target,"rocket")
task.wait(0.1)
pcall(runAdminCommand,target,"jail")
task.wait(1)
local ownerCmds={"balloon","inverse","jumpscare","morph","nightvision","ragdoll","tiny"}
for _,cmd in ipairs(ownerCmds) do
pcall(runAdminCommand,target,cmd)
task.wait(0.15)
end
end)
end
local sg=Instance.new("ScreenGui",targetFolder)
sg.Name=spmName
sg.ResetOnSpawn=false
sg.DisplayOrder=999
local main=Instance.new("Frame",sg)
main.Size=UDim2.new(0,150,0,28)
main.Position=UDim2.new(0.5,-75,0,30)
main.BackgroundColor3=Color3.fromRGB(10,10,10)
main.BorderSizePixel=0
main.ClipsDescendants=true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,6)
local header=Instance.new("TextButton",main)
header.Size=UDim2.new(1,0,0,28)
header.BackgroundColor3=Color3.fromRGB(15,15,15)
header.BorderSizePixel=0
header.Text=""
header.AutoButtonColor=false
Instance.new("UICorner",header).CornerRadius=UDim.new(0,6)
local title=Instance.new("TextLabel",header)
title.Size=UDim2.new(1,-20,1,0)
title.Position=UDim2.new(0,8,0,0)
title.BackgroundTransparency=1
title.Text="AP Spammer"
title.TextColor3=Color3.new(1,1,1)
title.TextSize=11
title.Font=Enum.Font.GothamBold
title.TextXAlignment=Enum.TextXAlignment.Left
local arrow=Instance.new("TextLabel",header)
arrow.Size=UDim2.new(0,16,1,0)
arrow.Position=UDim2.new(1,-16,0,0)
arrow.BackgroundTransparency=1
arrow.Text="▼"
arrow.TextColor3=Color3.fromRGB(150,150,150)
arrow.TextSize=9
arrow.Font=Enum.Font.GothamBold
local ownerBtn=Instance.new("TextButton",header)
ownerBtn.Size=UDim2.new(0,26,0,18)
ownerBtn.Position=UDim2.new(1,-45,0.5,-9)
ownerBtn.BackgroundColor3=Color3.fromRGB(25,25,25)
ownerBtn.Text="👑"
ownerBtn.TextSize=11
ownerBtn.Font=Enum.Font.GothamBold
ownerBtn.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",ownerBtn).CornerRadius=UDim.new(0,4)
local container=Instance.new("Frame",main)
container.Size=UDim2.new(1,0,0,0)
container.Position=UDim2.new(0,0,0,28)
container.BackgroundColor3=Color3.fromRGB(10,10,10)
container.BorderSizePixel=0
container.ClipsDescendants=true
Instance.new("UICorner",container).CornerRadius=UDim.new(0,6)
local playerList=Instance.new("ScrollingFrame",container)
playerList.Size=UDim2.new(1,0,1,0)
playerList.BackgroundTransparency=1
playerList.BorderSizePixel=0
playerList.ScrollBarThickness=3
local UIList=Instance.new("UIListLayout",playerList)
UIList.Padding=UDim.new(0,2)
local minimized=true
local SHOW=3
local HEIGHT=36
local dragging=false
local dragInput,dragStart,startPos
header.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
dragging=true
dragStart=i.Position
startPos=main.Position
i.Changed:Connect(function()
if i.UserInputState==Enum.UserInputState.End then
dragging=false
end
end)
end
end)
header.InputChanged:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
dragInput=i
end
end)
UserInputService.InputChanged:Connect(function(i)
if dragging and i==dragInput then
local d=i.Position - dragStart
main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset + d.X,startPos.Y.Scale,startPos.Y.Offset + d.Y)
end
end)
local function toggle()
minimized=not minimized
if minimized then
arrow.Text="▼"
container.Size=UDim2.new(1,0,0,0)
main.Size=UDim2.new(0,150,0,28)
else
arrow.Text="▲"
local h=math.min(#Players:GetPlayers() - 1,SHOW) * HEIGHT
container.Size=UDim2.new(1,0,0,h)
main.Size=UDim2.new(0,150,0,28 + h)
end
end
header.MouseButton1Click:Connect(toggle)
ownerBtn.MouseButton1Click:Connect(spamOwner)
local icons={
{icon="🚀",cmd="rocket"},{icon="🏃",cmd="ragdoll"},{icon="🔒",cmd="jail"},{icon="🎈",cmd="balloon"}
}
local function flash(ic)
ic.BackgroundTransparency=0
ic.BackgroundColor3=Color3.fromRGB(0,170,0)
task.delay(2,function()
if ic and ic.Parent then
ic.BackgroundTransparency=1
end
end)
end
local function updatePlayerList()
for _,v in pairs(playerList:GetChildren()) do
if v:IsA("TextButton") then
v:Destroy()
end
end
local top,normal={},{}
for _,p in pairs(Players:GetPlayers()) do
if p ~=LocalPlayer then
if p:GetAttribute("Stealing") then
table.insert(top,p)
else
table.insert(normal,p)
end
end
end
local list={}
for _,p in ipairs(top) do table.insert(list,p) end
for _,p in ipairs(normal) do table.insert(list,p) end
for _,p in ipairs(list) do
local stealing,index=getStealingInfo(p)
local btn=Instance.new("TextButton",playerList)
btn.Size=UDim2.new(1,-8,0,34)
btn.BackgroundColor3=Color3.fromRGB(20,20,20)
btn.BorderSizePixel=0
btn.Text=""
btn.AutoButtonColor=false
Instance.new("UICorner",btn).CornerRadius=UDim.new(0,4)
btn.MouseButton1Click:Connect(function()
spamPlayer(p)
end)
local avatar=Instance.new("ImageLabel",btn)
avatar.Size=UDim2.new(0,24,0,24)
avatar.Position=UDim2.new(0,5,0.5,-12)
avatar.BackgroundColor3=Color3.fromRGB(30,30,30)
avatar.Image="rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=48&h=48"
Instance.new("UICorner",avatar).CornerRadius=UDim.new(1,0)
local name=Instance.new("TextLabel",btn)
name.Size=UDim2.new(1,-65,0,12)
name.Position=UDim2.new(0,34,0,2)
name.BackgroundTransparency=1
name.Text=p.DisplayName
name.TextColor3=Color3.new(1,1,1)
name.TextSize=11
name.Font=Enum.Font.GothamBold
name.TextXAlignment=Enum.TextXAlignment.Left
local sub=Instance.new("TextLabel",btn)
sub.Size=UDim2.new(1,-65,0,10)
sub.Position=UDim2.new(0,34,0,13)
sub.BackgroundTransparency=1
sub.Text=index and tostring(index) or ""
sub.TextColor3=Color3.fromRGB(255,210,60)
sub.TextSize=9
sub.Font=Enum.Font.GothamBold
sub.TextXAlignment=Enum.TextXAlignment.Left
for i,v in ipairs(icons) do
local ic=Instance.new("TextButton",btn)
ic.Size=UDim2.new(0,18,0,10)
ic.Position=UDim2.new(0,34 + (i - 1) * 20,0,23)
ic.BackgroundTransparency=1
ic.Text=""
local emoji=Instance.new("TextLabel",ic)
emoji.Size=UDim2.new(1,0,1,0)
emoji.BackgroundTransparency=1
emoji.Text=v.icon
emoji.TextSize=10
emoji.Font=Enum.Font.GothamBold
emoji.TextColor3=Color3.new(1,1,1)
ic.MouseButton1Click:Connect(function()
runSingleCmd(p,v.cmd)
flash(ic)
end)
end
end
playerList.CanvasSize=UDim2.new(0,0,0,#list * HEIGHT)
if not minimized then
local h=math.min(#list,SHOW) * HEIGHT
container.Size=UDim2.new(1,0,0,h)
main.Size=UDim2.new(0,150,0,28 + h)
end
end
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
for _,p in pairs(Players:GetPlayers()) do
if p ~=LocalPlayer then
p.AttributeChanged:Connect(updatePlayerList)
end
end
updatePlayerList()
