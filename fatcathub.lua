local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")

-- [核心配置]
local UI_CONFIG = {
    MainSize = UDim2.new(0, 450, 0, 300),
    Trans = 0.85,
    AnimTime = 0.3, -- 动画持续时间，0.3秒最丝滑
}

-- 反馈通知
local function notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2,
        Icon = "rbxassetid://6033327349"
    })
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FatCatUI_V3"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- [通用拖动函数]
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- 悬浮按钮
local floatingBtn = Instance.new("ImageButton")
floatingBtn.Size = UDim2.new(0, 44, 0, 44)
floatingBtn.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.BackgroundTransparency = UI_CONFIG.Trans
floatingBtn.Image = "rbxassetid://3926305904"
floatingBtn.Parent = screenGui
Instance.new("UICorner", floatingBtn).CornerRadius = UDim.new(1, 0)
local btnStroke = Instance.new("UIStroke", floatingBtn)
btnStroke.Thickness = 2
makeDraggable(floatingBtn)

-- 主界面 (初始设为不可见且全透明，用于动画)
local menuFrame = Instance.new("Frame")
menuFrame.Size = UI_CONFIG.MainSize
menuFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
menuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menuFrame.BackgroundTransparency = 1
menuFrame.ClipsDescendants = true
menuFrame.Visible = false
menuFrame.Parent = screenGui
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 12)
local menuStroke = Instance.new("UIStroke", menuFrame)
menuStroke.Thickness = 2
makeDraggable(menuFrame)

-- 标题
local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(0, 100, 0, 38)
menuTitle.Position = UDim2.new(0, 15, 0, 0)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "胖猫hub"
menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.Font = Enum.Font.GothamSemibold
menuTitle.TextSize = 16
menuTitle.TextXAlignment = Enum.TextXAlignment.Left
menuTitle.Parent = menuFrame

-- 彩边循环动画
task.spawn(function()
    local colors = {Color3.fromRGB(100, 150, 255), Color3.fromRGB(255, 100, 150), Color3.fromRGB(255, 200, 100), Color3.fromRGB(100, 255, 150)}
    local i = 1
    while true do
        local nextCol = colors[i]
        TweenService:Create(btnStroke, TweenInfo.new(0.5), {Color = nextCol}):Play()
        TweenService:Create(menuStroke, TweenInfo.new(0.5), {Color = nextCol}):Play()
        i = i % 4 + 1
        task.wait(0.5)
    end
end)

-- 布局结构
local sideBar = Instance.new("Frame", menuFrame)
sideBar.Size = UDim2.new(0.33, 0, 1, -45)
sideBar.Position = UDim2.new(0, 0, 0, 40)
sideBar.BackgroundTransparency = 1
Instance.new("UIListLayout", sideBar).HorizontalAlignment = Enum.HorizontalAlignment.Center

local generalPage = Instance.new("ScrollingFrame", menuFrame)
generalPage.Size = UDim2.new(0.67, -10, 1, -45)
generalPage.Position = UDim2.new(0.33, 5, 0, 40)
generalPage.BackgroundTransparency = 1
generalPage.BorderSizePixel = 0
generalPage.ScrollBarThickness = 2
generalPage.CanvasSize = UDim2.new(0, 0, 0, 800)
Instance.new("UIListLayout", generalPage).Padding = UDim.new(0, 8)

local playerListPage = Instance.new("ScrollingFrame", menuFrame)
playerListPage.Size = UDim2.new(0.67, -10, 1, -45)
playerListPage.Position = UDim2.new(0.33, 5, 0, 40)
playerListPage.BackgroundTransparency = 1
playerListPage.BorderSizePixel = 0
playerListPage.ScrollBarThickness = 2
playerListPage.Visible = false
Instance.new("UIListLayout", playerListPage).Padding = UDim.new(0, 8)

-- [丝滑开关动画函数]
local function toggleMenu()
    if not menuFrame.Visible then
        menuFrame.Size = UDim2.new(0, 0, 0, 0)
        menuFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        menuFrame.BackgroundTransparency = 1
        menuFrame.Visible = true
        
        TweenService:Create(menuFrame, TweenInfo.new(UI_CONFIG.AnimTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UI_CONFIG.MainSize,
            Position = UDim2.new(0.5, -225, 0.5, -150),
            BackgroundTransparency = UI_CONFIG.Trans
        }):Play()
    else
        local hide = TweenService:Create(menuFrame, TweenInfo.new(UI_CONFIG.AnimTime, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        hide:Play()
        hide.Completed:Connect(function() menuFrame.Visible = false end)
    end
end

floatingBtn.MouseButton1Click:Connect(toggleMenu)

-- [创建函数]
local function createButton(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.85
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", btn).Transparency = 0.6
    
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.6}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.85}):Play()
        callback()
    end)
    return btn
end

-- [加载功能]
local selectedTarget = ""

-- 通用页功能
local tabs = {
    createButton("通用", sideBar, function() generalPage.Visible = true playerListPage.Visible = false end),
    createButton("玩家列表", sideBar, function() generalPage.Visible = false playerListPage.Visible = true end)
}

createButton("飞行", generalPage, function() notify("加载", "飞行脚本中...") loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))() end)

local ncActive = false
local ncConn
local ncBtn = createButton("穿墙", generalPage, function()
    ncActive = not ncActive
    ncBtn.BackgroundColor3 = ncActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("穿墙", ncActive and "开启成功" or "已关闭")
    if ncActive then
        ncConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        end)
    elseif ncConn then ncConn:Disconnect() end
end)

createButton("全亮/无雾", generalPage, function() 
    game.Lighting.Brightness, game.Lighting.ClockTime, game.Lighting.FogEnd = 2, 14, 9e9
    notify("环境", "视觉已增强")
end)

local tpActive = false
local tpBtn = createButton("点击传送", generalPage, function()
    tpActive = not tpActive
    tpBtn.BackgroundColor3 = tpActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("传送", tpActive and "模式开启" or "已关闭")
end)

local delActive = false
local delBtn = createButton("点击销毁物品", generalPage, function()
    delActive = not delActive
    delBtn.BackgroundColor3 = delActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("销毁", delActive and "开启，点击即可删除" or "已关闭")
end)

Mouse.Button1Down:Connect(function()
    if tpActive and LocalPlayer.Character then LocalPlayer.Character:MoveTo(Mouse.Hit.p) end
    if delActive and Mouse.Target then Mouse.Target:Destroy() end
end)

createButton("ESP 透视", generalPage, function() 
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then Instance.new("Highlight", p.Character).FillColor = Color3.fromRGB(255,0,0) end end 
    notify("ESP", "渲染完成")
end)

createButton("甩飞所有人", generalPage, function() notify("准备", "正在执行全局甩飞") loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))() end)

createButton("传送到锁定目标", generalPage, function()
    local t = Players:FindFirstChild(selectedTarget)
    if t and t.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame notify("传送", "已飞往 "..t.DisplayName) else notify("失败", "未锁定目标") end
end)

local loopFling = false
local fBtn = createButton("循环甩飞目标", generalPage, function()
    if selectedTarget == "" then notify("错误", "请先锁定目标") return end
    loopFling = not loopFling
    fBtn.BackgroundColor3 = loopFling and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("循环甩飞", loopFling and "启动" or "停止")
    task.spawn(function()
        while loopFling do
            local t = Players:FindFirstChild(selectedTarget)
            if t and t.Character and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(999999, 999999, 999999)
            end
            task.wait()
        end
    end)
end)

createButton("快速互动", generalPage, function() game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(p) p.HoldDuration = 0 end) notify("互动", "秒开开启") end)
createButton("无限跳跃", generalPage, function() UserInputService.JumpRequest:Connect(function() LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end) notify("跳跃", "无限跳开启") end)
createButton("重置角色", generalPage, function() if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end end)

-- [玩家列表动态加载]
local function updatePlayerList()
    for _, v in pairs(playerListPage:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    createButton("刷新玩家列表", playerListPage, function() updatePlayerList() notify("更新", "列表已刷新") end)
    for _, p in pairs(Players:GetPlayers()) do
        createButton(p.DisplayName.." (@"..p.Name..")", playerListPage, function() 
            selectedTarget = p.Name 
            notify("锁定成功", "目标: "..p.DisplayName)
        end)
    end
end

updatePlayerList()
notify("欢迎使用胖猫hub")
