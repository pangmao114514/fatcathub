local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==================== 配置 ====================
local Config = {
    FlySpeed = 50,
    FlyEnabled = false,
    NoclipEnabled = false
}

-- 飞行控制变量
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local currentSpeed = 0
local maxSpeed = 50

-- ==================== 键盘监听 ====================
local function updateControls()
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        ctrl.f = 1
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        ctrl.b = -1
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        ctrl.l = -1
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        ctrl.r = 1
    end
end

-- 每帧更新控制
RunService.RenderStepped:Connect(updateControls)

-- ==================== 飞行系统 (BodyVelocity + BodyGyro) ====================
local function startFly()
    if flyConnection then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- 获取飞行附着部位 (R6用Torso，R15用UpperTorso)
    local flyPart = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if not flyPart then return end
    
    -- 禁用原人物动画和状态
    character.Animate.Disabled = true
    
    -- 禁用所有 Humanoid 状态
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
    
    -- 创建 BodyGyro (保持姿态)
    bodyGyro = Instance.new("BodyGyro", flyPart)
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = flyPart.CFrame
    
    -- 创建 BodyVelocity (移动)
    bodyVelocity = Instance.new("BodyVelocity", flyPart)
    bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    currentSpeed = 0
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not Config.FlyEnabled then return end
        
        local camera = workspace.CurrentCamera
        local moveX = ctrl.l + ctrl.r
        local moveZ = ctrl.f + ctrl.b
        
        -- 速度计算
        if moveX ~= 0 or moveZ ~= 0 then
            currentSpeed = currentSpeed + 0.5 + (currentSpeed / maxSpeed)
            if currentSpeed > maxSpeed then
                currentSpeed = maxSpeed
            end
        elseif currentSpeed ~= 0 then
            currentSpeed = currentSpeed - 1
            if currentSpeed < 0 then
                currentSpeed = 0
            end
        end
        
        -- 移动向量计算
        if moveX ~= 0 or moveZ ~= 0 then
            local moveDir = (camera.CFrame.LookVector * moveZ) + (camera.CFrame.RightVector * moveX)
            bodyVelocity.velocity = moveDir * currentSpeed
            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif currentSpeed ~= 0 then
            local moveDir = (camera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) + (camera.CFrame.RightVector * (lastctrl.l + lastctrl.r))
            bodyVelocity.velocity = moveDir * currentSpeed
        else
            bodyVelocity.velocity = Vector3.new(0, 0, 0)
        end
        
        -- 保持身体朝向 (倾斜效果)
        bodyGyro.cframe = camera.CFrame * CFrame.Angles(-math.rad(moveZ * 50 * currentSpeed / maxSpeed), 0, 0)
    end)
end

local function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
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
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    currentSpeed = 0
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

-- ==================== UI 界面 (皮脚本风格) ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyNoclipUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 210, 0, 130)
mainFrame.Position = UDim2.new(0.5, -105, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "飞行 | 穿墙"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 14
title.Parent = titleBar

-- 飞行按钮
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 85, 0, 32)
flyBtn.Position = UDim2.new(0.5, -90, 0, 40)
flyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
flyBtn.Text = "飞行 OFF"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamSemibold
flyBtn.TextSize = 13
flyBtn.BorderSizePixel = 0
flyBtn.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyBtn

-- 穿墙按钮
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0, 85, 0, 32)
noclipBtn.Position = UDim2.new(0.5, 5, 0, 40)
noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
noclipBtn.Text = "穿墙 OFF"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.Font = Enum.Font.GothamSemibold
noclipBtn.TextSize = 13
noclipBtn.BorderSizePixel = 0
noclipBtn.Parent = mainFrame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 6)
noclipCorner.Parent = noclipBtn

-- 速度控制区域
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 180, 0, 18)
speedLabel.Position = UDim2.new(0.5, -90, 0, 80)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "飞行速度: " .. Config.FlySpeed
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 12
speedLabel.Parent = mainFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 30, 0, 24)
minusBtn.Position = UDim2.new(0.5, -70, 0, 102)
minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.BorderSizePixel = 0
minusBtn.Parent = mainFrame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 4)
minusCorner.Parent = minusBtn

local speedValue = Instance.new("TextLabel")
speedValue.Size = UDim2.new(0, 50, 0, 24)
speedValue.Position = UDim2.new(0.5, -25, 0, 102)
speedValue.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
speedValue.Text = tostring(Config.FlySpeed)
speedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
speedValue.Font = Enum.Font.GothamBold
speedValue.TextSize = 14
speedValue.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 4)
speedCorner.Parent = speedValue

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 30, 0, 24)
plusBtn.Position = UDim2.new(0.5, 40, 0, 102)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.BorderSizePixel = 0
plusBtn.Parent = mainFrame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 4)
plusCorner.Parent = plusBtn

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    if Config.FlyEnabled then
        Config.FlyEnabled = false
        stopFly()
    end
    if Config.NoclipEnabled then
        Config.NoclipEnabled = false
        stopNoclip()
    end
    screenGui:Destroy()
end)

-- 按钮功能
flyBtn.MouseButton1Click:Connect(function()
    Config.FlyEnabled = not Config.FlyEnabled
    if Config.FlyEnabled then
        flyBtn.Text = "飞行 ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        startFly()
    else
        flyBtn.Text = "飞行 OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        stopFly()
    end
end)

noclipBtn.MouseButton1Click:Connect(function()
    Config.NoclipEnabled = not Config.NoclipEnabled
    if Config.NoclipEnabled then
        noclipBtn.Text = "穿墙 ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        startNoclip()
    else
        noclipBtn.Text = "穿墙 OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        stopNoclip()
    end
end)

-- 速度控制
plusBtn.MouseButton1Click:Connect(function()
    Config.FlySpeed = math.min(Config.FlySpeed + 5, 200)
    speedLabel.Text = "飞行速度: " .. Config.FlySpeed
    speedValue.Text = tostring(Config.FlySpeed)
    maxSpeed = Config.FlySpeed
end)

minusBtn.MouseButton1Click:Connect(function()
    Config.FlySpeed = math.max(Config.FlySpeed - 5, 10)
    speedLabel.Text = "飞行速度: " .. Config.FlySpeed
    speedValue.Text = tostring(Config.FlySpeed)
    maxSpeed = Config.FlySpeed
end)

-- 重新加载角色时重置状态
LocalPlayer.CharacterAdded:Connect(function()
    if Config.FlyEnabled then
        Config.FlyEnabled = false
        flyBtn.Text = "飞行 OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    end
    if Config.NoclipEnabled then
        Config.NoclipEnabled = false
        noclipBtn.Text = "穿墙 OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    end
end)

-- 提示通知
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "脚本加载成功",
        Text = "飞行: WASD + 速度调节 | 穿墙独立开关",
        Duration = 5
    })
end)

print("飞行脚本已加载")