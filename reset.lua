local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not cursedResetRemote
                and typeof(self) == "Instance"
                and self:IsA("RemoteEvent")
                and self.Name:sub(1,3) == "RE/" then
                cursedResetRemote = self
            end
            return oldFire(self, ...)
        end))
    end
end)

local function findCursedResetRemote()
    if cursedResetRemote then return end
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
            cursedResetRemote = desc
            return
        end
    end
end

task.spawn(function()
    task.wait(2)
    findCursedResetRemote()
end)

local function cursedInstaReset()
    if not cursedResetRemote then
        findCursedResetRemote()
        if not cursedResetRemote then return end
    end

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid and humanoid.Health <= 0 then
        pcall(function()
            cursedResetRemote:FireServer(CURSED_RESET_GUID, LocalPlayer, "balloon")
        end)
        return
    end

    local resetDetected = false
    local conns = {}

    if humanoid then
        table.insert(conns, humanoid.Died:Connect(function()
            resetDetected = true
        end))

        table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then
                resetDetected = true
            end
        end))
    end

    if character then
        table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
            if not parent then
                resetDetected = true
            end
        end))
    end

    task.spawn(function()
        for _ = 1, 50 do
            if resetDetected then break end

            pcall(function()
                cursedResetRemote:FireServer(CURSED_RESET_GUID, LocalPlayer, "balloon")
            end)

            task.wait()
        end

        for _, conn in ipairs(conns) do
            pcall(function()
                conn:Disconnect()
            end)
        end
    end)
end

local resetPanel = Instance.new("ScreenGui")
resetPanel.Name = "InstaResetButton_Small"
resetPanel.ResetOnSpawn = false
resetPanel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
resetPanel.DisplayOrder = 20

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(resetPanel)
    end
end)

if not pcall(function()
    resetPanel.Parent = CoreGui
end) then
    resetPanel.Parent = LocalPlayer.PlayerGui
end

local btnFrame = Instance.new("Frame")
btnFrame.Parent = resetPanel
btnFrame.Size = UDim2.new(0,28,0,28)
btnFrame.Position = UDim2.new(1,-40,0.9,0)
btnFrame.BackgroundColor3 = Color3.fromRGB(0,130,255)
btnFrame.BorderSizePixel = 0

Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke", btnFrame)
stroke.Color = Color3.new(1,1,1)
stroke.Thickness = 1.5

local txt = Instance.new("TextLabel")
txt.Parent = btnFrame
txt.Size = UDim2.fromScale(1,1)
txt.BackgroundTransparency = 1
txt.Text = "R"
txt.Font = Enum.Font.GothamBold
txt.TextSize = 11
txt.TextColor3 = Color3.new(1,1,1)

local function setActive(state)
    btnFrame.BackgroundColor3 = state
        and Color3.fromRGB(0,90,180)
        or Color3.fromRGB(0,130,255)
end

local dragging = false
local moved = false
local dragStart
local startPos

btnFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        moved = false
        dragStart = input.Position
        startPos = btnFrame.Position
    end
end)

local function finish(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        if dragging then
            if not moved then
                setActive(true)
                cursedInstaReset()

                task.delay(0.3,function()
                    if btnFrame.Parent then
                        setActive(false)
                    end
                end)
            end

            dragging = false
            moved = false
        end
    end
end

btnFrame.InputEnded:Connect(finish)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            moved = true
        end

        if moved then
            btnFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(finish)
