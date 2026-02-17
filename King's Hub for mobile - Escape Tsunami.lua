local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function makeDraggable(frame)
    local dragging = false
    local dragStart
    local startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
end

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,110,0,50)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", frame)
makeDraggable(frame)

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0,20,0,20)
closeButton.Position = UDim2.new(0,90,0,0)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
closeButton.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeButton)

closeButton.MouseButton1Click:Connect(function()
    frame:Destroy()
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "king's Hub"
title.TextScaled = false
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

local unlockVIPButton = Instance.new("TextButton", frame)
unlockVIPButton.Size = UDim2.new(1,-20,0,15)
unlockVIPButton.Position = UDim2.new(0,10,0,25)
unlockVIPButton.Text = "UNLOCK VIP"
unlockVIPButton.TextScaled = false
unlockVIPButton.BackgroundColor3 = Color3.fromRGB(75,0,0)
unlockVIPButton.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", unlockVIPButton)

unlockVIPButton.MouseButton1Click:Connect(function()
    unlockVIPButton.Text = "VIP UNLOCKED"
	unlockVIPButton.BackgroundColor3 = Color3.fromRGB(0,75,0)
	local folder = workspace:FindFirstChild("DefaultMap_SharedInstances")

	if folder then
		local part = folder:FindFirstChild("VIPWalls")
		if part then
		part:Destroy()
		end
	end

end)
