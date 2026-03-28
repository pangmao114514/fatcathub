local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ==================== 配置 ====================
local Config = {
    FlySpeed = 50,
    NoclipEnabled = false,
    FlyEnabled = false,
    MenuOpen = false  -- 菜单是否展开
}

-- ==================== 飞行系统 ====================
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

-- 手机移动控制变量
local touchMoveDirection = Vector3.new(0, 0, 0)
local touchJumping = false
local touchFalling = false

local function startFly()
    if flyConnection then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    local originalGravity = workspace.Gravity
    workspace.Gravity = 0
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
    bodyGyro.P = 10000
    bodyGyro.Parent = rootPart
    
    humanoid.PlatformStand = true
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not Config.FlyEnabled then return end
        
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- ===== 电脑端控制 (键盘) =====
        if UserInputService.KeyboardEnabled then
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
        end
        
        -- ===== 手机端控制 (触摸摇杆变量) =====
        if not UserInputService.KeyboardEnabled then
            -- 移动方向 (由摇杆设置)
            moveDirection = moveDirection + touchMoveDirection
            -- 上升/下降 (由跳跃按钮控制)
            if touchJumping then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if touchFalling then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * Config.FlySpeed
        end
        bodyVelocity.Velocity = moveDirection
        
        if moveDirection.Magnitude > 0.1 then
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + moveDirection)
        else
            bodyGyro.CFrame = camera.CFrame
        end
    end)
    
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
    
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ==================== UI 界面（悬浮球 + 可展开菜单）====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlightNoclipUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ===== 悬浮球按钮 =====
local floatingBtn = Instance.new("ImageButton")
floatingBtn.Name = "FloatingBtn"
floatingBtn.Size = UDim2.new(0, 50, 0, 50)
floatingBtn.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
floatingBtn.BackgroundTransparency = 0.2
floatingBtn.Image = "rbxassetid://3926305904"  -- 齿轮图标
floatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.ScaleType = Enum.ScaleType.Fit
floatingBtn.Parent = screenGui

-- 圆角
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

-- 阴影效果
local btnShadow = Instance.new("UIShadow")
btnShadow.Parent = floatingBtn

-- ===== 展开菜单（默认隐藏）=====
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 220, 0, 140)
menuFrame.Position = UDim2.new(0, 0, 0, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
menuFrame.BackgroundTransparency = 0.15
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = floatingBtn  -- 菜单作为悬浮球的子物体，跟随移动

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menuFrame

local menuShadow = Instance.new("UIShadow")
menuShadow.Parent = menuFrame

-- 标题
local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 35)
menuTitle.Position = UDim2.new(0, 0, 0, 0)
menuTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
menuTitle.BackgroundTransparency = 0.3
menuTitle.Text = "✨ 飞行 + 穿墙 ✨"
menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.Font = Enum.Font.GothamSemibold
menuTitle.TextSize = 14
menuTitle.BorderSizePixel = 0
menuTitle.Parent = menuFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = menuTitle

-- 飞行按钮
local flyMenuBtn = Instance.new("TextButton")
flyMenuBtn.Size = UDim2.new(0, 100, 0, 40)
flyMenuBtn.Position = UDim2.new(0.5, -105, 0, 45)
flyMenuBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
flyMenuBtn.Text = "✈️ 飞行 OFF"
flyMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyMenuBtn.Font = Enum.Font.GothamSemibold
flyMenuBtn.TextSize = 14
flyMenuBtn.BorderSizePixel = 0
flyMenuBtn.Parent = menuFrame

local flyMenuCorner = Instance.new("UICorner")
flyMenuCorner.CornerRadius = UDim.new(0, 8)
flyMenuCorner.Parent = flyMenuBtn

-- 穿墙按钮
local noclipMenuBtn = Instance.new("TextButton")
noclipMenuBtn.Size = UDim2.new(0, 100, 0, 40)
noclipMenuBtn.Position = UDim2.new(0.5, 5, 0, 45)
noclipMenuBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
noclipMenuBtn.Text = "🧱 穿墙 OFF"
noclipMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipMenuBtn.Font = Enum.Font.GothamSemibold
noclipMenuBtn.TextSize = 14
noclipMenuBtn.BorderSizePixel = 0
noclipMenuBtn.Parent = menuFrame

local noclipMenuCorner = Instance.new("UICorner")
noclipMenuCorner.CornerRadius = UDim.new(0, 8)
noclipMenuCorner.Parent = noclipMenuBtn

-- 速度滑块区域
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 180, 0, 20)
speedLabel.Position = UDim2.new(0.5, -90, 0, 95)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "飞行速度: " .. Config.FlySpeed
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 12
speedLabel.Parent = menuFrame

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0, 180, 0, 4)
speedSlider.Position = UDim2.new(0.5, -90, 0, 118)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedSlider.BackgroundTransparency = 0.5
speedSlider.BorderSizePixel = 0
speedSlider.Parent = menuFrame

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

-- ===== 悬浮球拖拽逻辑 =====
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

-- ===== 悬浮球点击展开/收起菜单 =====
floatingBtn.MouseButton1Click:Connect(function()
    Config.MenuOpen = not Config.MenuOpen
    menuFrame.Visible = Config.MenuOpen
    
    -- 动画效果
    if Config.MenuOpen then
        menuFrame.Position = UDim2.new(0, -230, 0, 0)
        TweenService:Create(menuFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, -10, 0, 0)}):Play()
    end
end)

-- ===== 飞行功能切换 =====
local function updateFlyUI()
    if Config.FlyEnabled then
        flyMenuBtn.Text = "✈️ 飞行 ON"
        flyMenuBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        floatingBtn.ImageColor3 = Color3.fromRGB(100, 200, 100)
    else
        flyMenuBtn.Text = "✈️ 飞行 OFF"
        flyMenuBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        if not Config.NoclipEnabled then
            floatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
end

flyMenuBtn.MouseButton1Click:Connect(function()
    Config.FlyEnabled = not Config.FlyEnabled
    if Config.FlyEnabled then
        startFly()
    else
        stopFly()
    end
    updateFlyUI()
end)

-- ===== 穿墙功能切换 =====
local function updateNoclipUI()
    if Config.NoclipEnabled then
        noclipMenuBtn.Text = "🧱 穿墙 ON"
        noclipMenuBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        floatingBtn.ImageColor3 = Color3.fromRGB(100, 200, 100)
    else
        noclipMenuBtn.Text = "🧱 穿墙 OFF"
        noclipMenuBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        if not Config.FlyEnabled then
            floatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
end

noclipMenuBtn.MouseButton1Click:Connect(function()
    Config.NoclipEnabled = not Config.NoclipEnabled
    if Config.NoclipEnabled then
        startNoclip()
    else
        stopNoclip()
    end
    updateNoclipUI()
end)

-- ===== 速度滑块逻辑 =====
local sliderDragging = false
local function updateSpeed(mouseX)
    local relativeX = math.clamp((mouseX - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X, 0, 1)
    local newSpeed = math.floor(relativeX * 190 + 10)
    Config.FlySpeed = newSpeed
    speedLabel.Text = "飞行速度: " .. Config.FlySpeed
    sliderFill.Size = UDim2.new(Config.FlySpeed / 200, 0, 1, 0)
end

speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        updateSpeed(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSpeed(input.Position.X)
    end
end)

-- ==================== 手机端触摸摇杆支持 ====================
if not UserInputService.KeyboardEnabled then
    -- 监听跳跃按钮（手机屏幕上的跳跃键）
    local jumpRequestConnection = UserInputService.JumpRequest:Connect(function()
        if Config.FlyEnabled then
            touchJumping = true
            task.wait(0.3)
            touchJumping = false
        end
    end)
    
    -- 监听下降（可以通过添加一个自定义按钮来实现，这里简化为触摸屏幕下半部分下降）
    local function onTouchBegan(input, processed)
        if processed then return end
        if not Config.FlyEnabled then return end
        local screenPos = input.Position.Y / screenGui.AbsoluteSize.Y
        if screenPos > 0.7 then
            touchFalling = true
            task.wait(0.3)
            touchFalling = false
        end
    end
    
    UserInputService.TouchBegan:Connect(onTouchBegan)
end

-- ===== 模拟手机摇杆（简单方向控制）=====
-- 在手机端，可以通过触摸屏幕左侧区域来移动方向
local touchStartPos = nil
local touchMoveVector = Vector2.new(0, 0)

local function onTouchMove(input)
    if not Config.FlyEnabled then return end
    if not touchStartPos then return end
    local delta = input.Position - touchStartPos
    local maxRadius = 80
    local strength = math.min(delta.Magnitude / maxRadius, 1)
    local angle = delta.Angle
    touchMoveVector = Vector2.new(math.cos(angle), math.sin(angle)) * strength
    
    -- 转换为3D移动方向（基于相机视角）
    local camera = workspace.CurrentCamera
    local forward = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector
    touchMoveDirection = (forward * touchMoveVector.Y + right * touchMoveVector.X).Unit
end

local function onTouchBegan(input)
    if not Config.FlyEnabled then return end
    -- 左侧屏幕区域作为摇杆区域
    if input.Position.X < screenGui.AbsoluteSize.X / 2 then
        touchStartPos = input.Position
        touchMoveDirection = Vector3.new(0, 0, 0)
    end
end

local function onTouchEnded(input)
    if input.Position.X < screenGui.AbsoluteSize.X / 2 then
        touchStartPos = nil
        touchMoveDirection = Vector3.new(0, 0, 0)
        touchMoveVector = Vector2.new(0, 0)
    end
end

if not UserInputService.KeyboardEnabled then
    UserInputService.TouchBegan:Connect(onTouchBegan)
    UserInputService.TouchMoved:Connect(onTouchMove)
    UserInputService.TouchEnded:Connect(onTouchEnded)
end

-- ==================== 初始化提示 ====================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "脚本加载成功",
        Text = "点击悬浮球展开菜单 | 飞行: 电脑WASD/手机摇杆+跳跃",
        Duration = 5
    })
end)

print("脚本已加载")