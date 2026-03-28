local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ==================== 配置 ====================
local Config = {
    FlySpeed = 50,
    NoclipEnabled = false,
    FlyEnabled = false
}

-- ==================== 飞行系统 ====================
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

local function startFly()
    if flyConnection then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    -- 保存原重力设置
    local originalGravity = workspace.Gravity
    workspace.Gravity = 0
    
    -- 创建飞行控制部件
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
    bodyGyro.P = 10000
    bodyGyro.Parent = rootPart
    
    -- 禁用原人物重力影响
    humanoid.PlatformStand = true
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not Config.FlyEnabled then return end
        
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- WASD 控制方向
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        -- 应用速度
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * Config.FlySpeed
        end
        bodyVelocity.Velocity = moveDirection
        
        -- 保持身体朝向相机方向
        if moveDirection.Magnitude > 0.1 then
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + moveDirection)
        else
            bodyGyro.CFrame = camera.CFrame
        end
    end)
    
    -- 自动恢复原重力
    flyConnection:Wait()
    workspace.Gravity = originalGravity
end

local function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- ==================== 穿墙系统 ====================
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
    
    -- 恢复碰撞（可选，不恢复也可以）
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
screenGui.Name = "FlightNoclipUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 毛玻璃背景
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- 圆角 + 阴影效果
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadow = Instance.new("UIShadow")
shadow.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "✨ 简易工具 ✨"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 18
title.TextScaled = false
title.Parent = titleBar

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BackgroundTransparency = 0.8
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    -- 关闭功能
    if Config.FlyEnabled then
        Config.FlyEnabled = false
        stopFly()
    end
    if Config.NoclipEnabled then
        Config.NoclipEnabled = false
        stopNoclip()
    end
end)

-- 飞行按钮
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 120, 0, 45)
flyBtn.Position = UDim2.new(0.5, -130, 0, 70)
flyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
flyBtn.Text = "飞行 (OFF)"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamSemibold
flyBtn.TextSize = 16
flyBtn.BorderSizePixel = 0
flyBtn.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyBtn

-- 穿墙按钮
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0, 120, 0, 45)
noclipBtn.Position = UDim2.new(0.5, 10, 0, 70)
noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
noclipBtn.Text = "穿墙 (OFF)"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.Font = Enum.Font.GothamSemibold
noclipBtn.TextSize = 16
noclipBtn.BorderSizePixel = 0
noclipBtn.Parent = mainFrame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipBtn

-- 速度滑块
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 200, 0, 20)
speedLabel.Position = UDim2.new(0.5, -100, 0, 130)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "飞行速度: " .. Config.FlySpeed
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.Parent = mainFrame

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0, 200, 0, 4)
speedSlider.Position = UDim2.new(0.5, -100, 0, 155)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedSlider.BackgroundTransparency = 0.5
speedSlider.BorderSizePixel = 0
speedSlider.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 2)
sliderCorner.Parent = speedSlider

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(Config.FlySpeed / 200, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = speedSlider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 2)
fillCorner.Parent = sliderFill

-- 速度滑块拖拽逻辑
local dragging = false
local function updateSpeed(mouseX)
    local relativeX = math.clamp((mouseX - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X, 0, 1)
    local newSpeed = math.floor(relativeX * 200 + 10)
    newSpeed = math.clamp(newSpeed, 10, 200)
    Config.FlySpeed = newSpeed
    speedLabel.Text = "飞行速度: " .. Config.FlySpeed
    sliderFill.Size = UDim2.new(Config.FlySpeed / 200, 0, 1, 0)
end

speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        updateSpeed(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSpeed(input.Position.X)
    end
end)

-- 按钮动画效果
local function animateButton(btn, isHover)
    local targetSize = isHover and UDim2.new(0, 125, 0, 48) or UDim2.new(0, 120, 0, 45)
    local tween = TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = targetSize})
    tween:Play()
end

flyBtn.MouseEnter:Connect(function() animateButton(flyBtn, true) end)
flyBtn.MouseLeave:Connect(function() animateButton(flyBtn, false) end)
noclipBtn.MouseEnter:Connect(function() animateButton(noclipBtn, true) end)
noclipBtn.MouseLeave:Connect(function() animateButton(noclipBtn, false) end)

-- 飞行功能切换
flyBtn.MouseButton1Click:Connect(function()
    Config.FlyEnabled = not Config.FlyEnabled
    if Config.FlyEnabled then
        flyBtn.Text = "飞行 (ON)"
        flyBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        startFly()
    else
        flyBtn.Text = "飞行 (OFF)"
        flyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        stopFly()
    end
end)

-- 穿墙功能切换
noclipBtn.MouseButton1Click:Connect(function()
    Config.NoclipEnabled = not Config.NoclipEnabled
    if Config.NoclipEnabled then
        noclipBtn.Text = "穿墙 (ON)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        startNoclip()
    else
        noclipBtn.Text = "穿墙 (OFF)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        stopNoclip()
    end
end)

-- 提示通知
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "脚本加载成功",
        Text = "飞行 (WASD + 空格上升 + Ctrl下降) | 穿墙独立开关",
        Duration = 5
    })
end)

print("脚本已加载 | 飞行速度可调 | 穿墙独立开关")