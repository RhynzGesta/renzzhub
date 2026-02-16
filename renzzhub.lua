local UserInputService = game:GetService("UserInputService")
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
frame.Size = UDim2.new(0,220,0,300)
frame.Position = UDim2.new(0,0,0.5,-200)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", frame)
makeDraggable(frame)

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0,20,0,20)
closeButton.Position = UDim2.new(0,200,0,0)
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
title.Text = "RENZZHUB"
title.TextScaled = false
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

-- fly 

local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(1,-20,0,35)
flyButton.Position = UDim2.new(0,10,0,75)
flyButton.Text = "Fly: OFF"
flyButton.TextScaled = true
flyButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
flyButton.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", flyButton)

local flying = false
local speed = 50
local flyConnection

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
	flyButton.Text = flying and "Fly: ON" or "Fly: OFF"
    if flying then
		local hrp = character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = hrp
        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not flying then return end
            local moveDir = Vector3.new()
            local cam = workspace.CurrentCamera
            local keys = game:GetService("UserInputService")
            if keys:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if keys:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if keys:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if keys:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if keys:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if keys:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
            if moveDir.Magnitude > 0 then
                bv.Velocity = moveDir.Unit * speed
            else
                bv.Velocity = Vector3.new(0,0,0)
            end
            bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
        end)
    else
		if flyConnection then flyConnection:Disconnect() end
        if character:FindFirstChild("HumanoidRootPart") then
            for _,v in pairs({"BodyVelocity","BodyGyro"}) do
                local obj = character.HumanoidRootPart:FindFirstChild(v)
                if obj then obj:Destroy() end
            end
        end
    end
end)

-- fly speed

local flySpeedFast = false

local flySpeedButton = Instance.new("TextButton", frame)
flySpeedButton.Size = UDim2.new(1,-20,0,35)
flySpeedButton.Position = UDim2.new(0,10,0,35)
flySpeedButton.Text = "Slow"
flySpeedButton.TextScaled = true
flySpeedButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
flySpeedButton.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", flySpeedButton)

flySpeedButton.MouseButton1Click:Connect(function()
    flySpeedFast = not flySpeedFast
	flySpeedButton.Text = flySpeedFast and "Fast" or "Slow"
	if flySpeedFast then
	   speed =  500
    else
	   speed = 50
    end
end)

-- no clip

local NoClipButton = Instance.new("TextButton", frame)
NoClipButton.Size = UDim2.new(1,-20,0,35)
NoClipButton.Position = UDim2.new(0,10,0,115)
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextScaled = true
NoClipButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
NoClipButton.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", NoClipButton)

local noclip = false
local runService = game:GetService("RunService")

NoClipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoClipButton.Text = noclip and "NoClip: ON" or "NoClip: OFF"
end)

runService.Stepped:Connect(function()
    if noclip and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- jump boost

local jumpBoost = false
local humanoid

local jumpTitle = Instance.new("TextLabel", frame)
jumpTitle.Size = UDim2.new(1,0,0,30)
jumpTitle.Position = UDim2.new(0,0,0,150)
jumpTitle.Text = "JUMP BOOST"
jumpTitle.TextScaled = false
jumpTitle.BackgroundTransparency = 1
jumpTitle.TextColor3 = Color3.new(1,1,1)

local jumpBoostBox = Instance.new("TextBox", frame)
jumpBoostBox.Size = UDim2.new(1,-40,0,40)
jumpBoostBox.Position = UDim2.new(0,20,0,180)
jumpBoostBox.Text = "80"
jumpBoostBox.PlaceholderText = "Number"
jumpBoostBox.TextScaled = true
jumpBoostBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
jumpBoostBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", jumpBoostBox)

local jumpBoostButton = Instance.new("TextButton", frame)
jumpBoostButton.Size = UDim2.new(1,-20,0,35)
jumpBoostButton.Position = UDim2.new(0,10,0,235)
jumpBoostButton.Text = "Boost: OFF"
jumpBoostButton.TextScaled = true
jumpBoostButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
jumpBoostButton.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", jumpBoostButton)

local function setupCharacter(char)
	humanoid = char:WaitForChild("Humanoid")
	humanoid.UseJumpPower = true
	humanoid.JumpPower = 50
end

if player.Character then
	setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)

jumpBoostButton.MouseButton1Click:Connect(function()
	jumpBoost = not jumpBoost
	jumpBoostButton.Text = jumpBoost and "Boost: ON" or "Boost: OFF"

	if humanoid then
		if jumpBoost then
			humanoid.JumpPower = tonumber(jumpBoostBox.Text) or 100
		else
			humanoid.JumpPower = 50
		end
	end
end)

jumpBoostBox.FocusLost:Connect(function()
	if jumpBoost and humanoid then
		humanoid.JumpPower = tonumber(jumpBoostBox.Text) or 100
	end
end)