local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")

local UI_CONFIG = {
    MainSize = UDim2.new(0, 450, 0, 300),
    Trans = 0.85,
    AnimTime = 0.3,
}

local function notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2,
        Icon = "rbxassetid://6033327349"
    })
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FatCatUI_Final_V4"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

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
generalPage.CanvasSize = UDim2.new(0, 0, 0, 1100)
Instance.new("UIListLayout", generalPage).Padding = UDim.new(0, 8)

local playerListPage = Instance.new("ScrollingFrame", menuFrame)
playerListPage.Size = UDim2.new(0.67, -10, 1, -45)
playerListPage.Position = UDim2.new(0.33, 5, 0, 40)
playerListPage.BackgroundTransparency = 1
playerListPage.BorderSizePixel = 0
playerListPage.ScrollBarThickness = 2
playerListPage.Visible = false
Instance.new("UIListLayout", playerListPage).Padding = UDim.new(0, 8)

local function toggleMenu()
    if not menuFrame.Visible then
        menuFrame.Size = UDim2.new(0, 0, 0, 0)
        menuFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
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
    btn.MouseButton1Down:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.6}):Play() end)
    btn.MouseButton1Up:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.85}):Play() callback() end)
    return btn
end

local selectedTarget = ""
local loopFling = false

local function startFling()
    local target = Players:FindFirstChild(selectedTarget)
    if not target or not target.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local thrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not thrp then return end
    local bV = Instance.new("BodyVelocity", hrp)
    bV.Velocity = Vector3.new(4000, 4000, 4000)
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    local bA = Instance.new("BodyAngularVelocity", hrp)
    bA.AngularVelocity = Vector3.new(4000, 4000, 4000)
    bA.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    task.spawn(function()
        while loopFling and target.Character and hrp.Parent do
            hrp.CFrame = thrp.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
            task.wait()
        end
        bV:Destroy()
        bA:Destroy()
    end)
end

createButton("通用", sideBar, function() generalPage.Visible = true playerListPage.Visible = false end)
createButton("玩家列表", sideBar, function() generalPage.Visible = false playerListPage.Visible = true end)

createButton("飞行脚本", generalPage, function() notify("功能", "加载飞行") loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))() end)

local ncActive = false
local ncConn
local ncBtn = createButton("穿墙", generalPage, function()
    ncActive = not ncActive
    ncBtn.BackgroundColor3 = ncActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("穿墙", ncActive and "开启" or "关闭")
    if ncActive then
        ncConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        end)
    elseif ncConn then ncConn:Disconnect() end
end)

local tpActive = false
local tpBtn = createButton("点击传送", generalPage, function()
    tpActive = not tpActive
    tpBtn.BackgroundColor3 = tpActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("传送", tpActive and "模式开启" or "关闭")
end)

local delActive = false
local delBtn = createButton("点击销毁物品", generalPage, function()
    delActive = not delActive
    delBtn.BackgroundColor3 = delActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("销毁", delActive and "开启" or "关闭")
end)

Mouse.Button1Down:Connect(function()
    if tpActive and LocalPlayer.Character then LocalPlayer.Character:MoveTo(Mouse.Hit.p) end
    if delActive and Mouse.Target then Mouse.Target:Destroy() end
end)

createButton("ESP透视", generalPage, function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
    notify("ESP", "已开启")
end)

createButton("强化循环甩飞", generalPage, function()
    if selectedTarget == "" then notify("提示", "请先锁定玩家") return end
    loopFling = not loopFling
    if loopFling then startFling() end
end)

local antiFlingActive = false
local afConn
local afBtn = createButton("防甩飞", generalPage, function()
    antiFlingActive = not antiFlingActive
    afBtn.BackgroundColor3 = antiFlingActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("防甩飞", antiFlingActive and "开启" or "关闭")
    if antiFlingActive then
        afConn = RunService.PostSimulation:Connect(function()
            if LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then 
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    elseif afConn then afConn:Disconnect() end
end)

createButton("秒速互动", generalPage, function()
    game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(p) p.HoldDuration = 0 end)
    notify("互动", "秒开开启")
end)

createButton("无限跳跃", generalPage, function()
    UserInputService.JumpRequest:Connect(function() LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end)
    notify("跳跃", "已开启")
end)

createButton("全亮无雾", generalPage, function()
    game.Lighting.Brightness, game.Lighting.ClockTime, game.Lighting.FogEnd = 2, 14, 9e9
    notify("视觉", "优化完成")
end)

createButton("反挂机", generalPage, function()
    LocalPlayer.Idled:Connect(function() game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)
    notify("反挂机", "已激活")
end)

createButton("隐藏名字", generalPage, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        for _, v in pairs(LocalPlayer.Character.Head:GetChildren()) do
            if v:IsA("BillboardGui") then v:Destroy() end
        end
    end
    notify("名字", "已尝试隐藏")
end)

createButton("传送至锁定玩家", generalPage, function()
    local t = Players:FindFirstChild(selectedTarget)
    if t and t.Character then LocalPlayer.Character:MoveTo(t.Character.HumanoidRootPart.Position) end
end)

createButton("重置角色", generalPage, function() if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end end)

local function updatePlayerList()
    for _, v in pairs(playerListPage:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    createButton("刷新玩家列表", playerListPage, function() updatePlayerList() end)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            createButton(p.DisplayName, playerListPage, function() 
                selectedTarget = p.Name 
                notify("锁定", p.DisplayName)
            end)
        end
    end
end

updatePlayerList()
notify("胖猫hub")
