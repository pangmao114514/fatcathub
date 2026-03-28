local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local Config = {
    FlySpeed = 5,
    FlyEnabled = false,
    NoclipEnabled = false
}

local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local currentSpeed = 0
local maxSpeed = 5
local flyingActive = false
local bodyGyro = nil
local bodyVelocity = nil

local function updateControls()
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then ctrl.f = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then ctrl.b = -1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then ctrl.l = -1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then ctrl.r = 1 end
end
RunService.RenderStepped:Connect(updateControls)

local function startFly()
    if flyingActive then return end
    flyingActive = true
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local flyPart = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if not flyPart then return end
    
    character.Animate.Disabled = true
    for i, v in next, humanoid:GetPlayingAnimationTracks() do v:AdjustSpeed(0) end
    
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
    humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    humanoid.PlatformStand = true
    
    bodyGyro = Instance.new("BodyGyro", flyPart)
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = flyPart.CFrame
    
    bodyVelocity = Instance.new("BodyVelocity", flyPart)
    bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    currentSpeed = 0
    
    spawn(function()
        while flyingActive do
            RunService.RenderStepped:Wait()
            local moveX = ctrl.l + ctrl.r
            local moveZ = ctrl.f + ctrl.b
            
            if moveX ~= 0 or moveZ ~= 0 then
                currentSpeed = currentSpeed + 0.5 + (currentSpeed / maxSpeed)
                if currentSpeed > maxSpeed then currentSpeed = maxSpeed end
            elseif currentSpeed ~= 0 then
                currentSpeed = currentSpeed - 1
                if currentSpeed < 0 then currentSpeed = 0 end
            end
            
            if moveX ~= 0 or moveZ ~= 0 then
                local camera = workspace.CurrentCamera
                local moveDir = (camera.CFrame.LookVector * moveZ) + (camera.CFrame.RightVector * moveX)
                bodyVelocity.velocity = moveDir * currentSpeed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif currentSpeed ~= 0 then
                local camera = workspace.CurrentCamera
                local moveDir = (camera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) + (camera.CFrame.RightVector * (lastctrl.l + lastctrl.r))
                bodyVelocity.velocity = moveDir * currentSpeed
            else
                bodyVelocity.velocity = Vector3.new(0, 0, 0)
            end
            
            if bodyGyro then
                local camera = workspace.CurrentCamera
                bodyGyro.cframe = camera.CFrame * CFrame.Angles(-math.rad(moveZ * 50 * currentSpeed / maxSpeed), 0, 0)
            end
        end
    end)
    
    for i = 1, Config.FlySpeed do
        spawn(function()
            local hb = RunService.Heartbeat
            local chr = LocalPlayer.Character
            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
            while flyingActive and hb:Wait() and chr and hum and hum.Parent do
                if hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection)
                end
            end
        end)
    end
end

local function stopFly()
    if not flyingActive then return end
    flyingActive = false
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            humanoid.PlatformStand = false
        end
        character.Animate.Disabled = false
    end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    currentSpeed = 0
end

local noclipConnection = nil

local function startNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        if not Config.NoclipEnabled then return end
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ==================== UI 界面 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyNoclipUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

local floatingBtn = Instance.new("ImageButton")
floatingBtn.Size = UDim2.new(0, 45, 0, 45)
floatingBtn.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
floatingBtn.BackgroundTransparency = 0.2
floatingBtn.Image = "rbxassetid://3926305904"
floatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.ScaleType = Enum.ScaleType.Fit
floatingBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 200, 0, 170)
menuFrame.Position = UDim2.new(0, 0, 0, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
menuFrame.BackgroundTransparency = 0.15
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = floatingBtn

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menuFrame

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 32)
menuTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
menuTitle.BackgroundTransparency = 0.3
menuTitle.Text = "飞行 | 穿墙 | 甩飞"
menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.Font = Enum.Font.GothamSemibold
menuTitle.TextSize = 13
menuTitle.BorderSizePixel = 0
menuTitle.Parent = menuFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = menuTitle

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 90, 0, 30)
flyBtn.Position = UDim2.new(0.5, -95, 0, 42)
flyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
flyBtn.Text = "飞行 OFF"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamSemibold
flyBtn.TextSize = 12
flyBtn.BorderSizePixel = 0
flyBtn.Parent = menuFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 5)
flyCorner.Parent = flyBtn

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0, 90, 0, 30)
noclipBtn.Position = UDim2.new(0.5, 5, 0, 42)
noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
noclipBtn.Text = "穿墙 OFF"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.Font = Enum.Font.GothamSemibold
noclipBtn.TextSize = 12
noclipBtn.BorderSizePixel = 0
noclipBtn.Parent = menuFrame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 5)
noclipCorner.Parent = noclipBtn

local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(0, 100, 0, 32)
flingBtn.Position = UDim2.new(0.5, -50, 0, 82)
flingBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
flingBtn.Text = "甩飞所有人"
flingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flingBtn.Font = Enum.Font.GothamSemibold
flingBtn.TextSize = 12
flingBtn.BorderSizePixel = 0
flingBtn.Parent = menuFrame

local flingCorner = Instance.new("UICorner")
flingCorner.CornerRadius = UDim.new(0, 5)
flingCorner.Parent = flingBtn

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 180, 0, 16)
speedLabel.Position = UDim2.new(0.5, -90, 0, 122)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "飞行速度: " .. Config.FlySpeed
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 11
speedLabel.Parent = menuFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 28, 0, 22)
minusBtn.Position = UDim2.new(0.5, -70, 0, 142)
minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 16
minusBtn.BorderSizePixel = 0
minusBtn.Parent = menuFrame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 4)
minusCorner.Parent = minusBtn

local speedValue = Instance.new("TextLabel")
speedValue.Size = UDim2.new(0, 45, 0, 22)
speedValue.Position = UDim2.new(0.5, -22, 0, 142)
speedValue.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
speedValue.Text = tostring(Config.FlySpeed)
speedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
speedValue.Font = Enum.Font.GothamBold
speedValue.TextSize = 13
speedValue.Parent = menuFrame

local speedValueCorner = Instance.new("UICorner")
speedValueCorner.CornerRadius = UDim.new(0, 4)
speedValueCorner.Parent = speedValue

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 28, 0, 22)
plusBtn.Position = UDim2.new(0.5, 42, 0, 142)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 16
plusBtn.BorderSizePixel = 0
plusBtn.Parent = menuFrame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 4)
plusCorner.Parent = plusBtn

local dragging = false
local dragStartPos = nil
local dragStartMousePos = nil

floatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = floatingBtn.Position
        dragStartMousePos = input.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartMousePos
        local newX = dragStartPos.X.Scale + (delta.X / screenGui.AbsoluteSize.X)
        local newY = dragStartPos.Y.Scale + (delta.Y / screenGui.AbsoluteSize.Y)
        newX = math.clamp(newX, 0, 0.9)
        newY = math.clamp(newY, 0, 0.85)
        floatingBtn.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

local menuOpen = false

floatingBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    menuFrame.Visible = menuOpen
    if menuOpen then
        menuFrame.Position = UDim2.new(0, -210, 0, 0)
        TweenService:Create(menuFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, -10, 0, 0)}):Play()
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    Config.FlyEnabled = not Config.FlyEnabled
    if Config.FlyEnabled then
        flyBtn.Text = "飞行 ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        floatingBtn.ImageColor3 = Color3.fromRGB(100, 200, 100)
        startFly()
    else
        flyBtn.Text = "飞行 OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        if not Config.NoclipEnabled then
            floatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
        stopFly()
    end
end)

noclipBtn.MouseButton1Click:Connect(function()
    Config.NoclipEnabled = not Config.NoclipEnabled
    if Config.NoclipEnabled then
        noclipBtn.Text = "穿墙 ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        floatingBtn.ImageColor3 = Color3.fromRGB(100, 200, 100)
        startNoclip()
    else
        noclipBtn.Text = "穿墙 OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        if not Config.FlyEnabled then
            floatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
        stopNoclip()
    end
end)

flingBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
end)

plusBtn.MouseButton1Click:Connect(function()
    Config.FlySpeed = math.min(Config.FlySpeed + 1, 200)
    speedLabel.Text = "飞行速度: " .. Config.FlySpeed
    speedValue.Text = tostring(Config.FlySpeed)
    maxSpeed = Config.FlySpeed
end)

minusBtn.MouseButton1Click:Connect(function()
    Config.FlySpeed = math.max(Config.FlySpeed - 1, 1)
    speedLabel.Text = "飞行速度: " .. Config.FlySpeed
    speedValue.Text = tostring(Config.FlySpeed)
    maxSpeed = Config.FlySpeed
end)

LocalPlayer.CharacterAdded:Connect(function()
    if Config.FlyEnabled then
        Config.FlyEnabled = false
        flyBtn.Text = "飞行 OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        flyingActive = false
    end
    if Config.NoclipEnabled then
        Config.NoclipEnabled = false
        noclipBtn.Text = "穿墙 OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    end
    floatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "脚本加载成功",
    Text = "欢迎使用fatcathub",
    Duration = 5
})

print("脚本已加载")