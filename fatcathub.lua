local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")

local UI_CONFIG = {
    MainSize = UDim2.new(0, 450, 0, 320),
    IslandSize = UDim2.new(0, 260, 0, 42),
    Trans = 0.85,
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
screenGui.Name = "FatCat_Island_V9_Final_Fixed"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
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
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local island = Instance.new("Frame")
island.Size = UI_CONFIG.IslandSize
island.Position = UDim2.new(0.5, -130, 0, 25)
island.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
island.BackgroundTransparency = UI_CONFIG.Trans
island.Parent = screenGui
Instance.new("UICorner", island).CornerRadius = UDim.new(0, 21)
local islandStroke = Instance.new("UIStroke", island)
islandStroke.Thickness = 2
makeDraggable(island)

local openBtn = Instance.new("ImageButton", island)
openBtn.Size = UDim2.new(0, 32, 0, 32)
openBtn.Position = UDim2.new(0, 15, 0.5, -16)
openBtn.BackgroundTransparency = 1
openBtn.Image = "rbxassetid://6034822712"

local islandTitle = Instance.new("TextLabel", island)
islandTitle.Size = UDim2.new(0, 160, 1, 0)
islandTitle.Position = UDim2.new(0, 60, 0, 0)
islandTitle.BackgroundTransparency = 1
islandTitle.Text = "胖猫hub"
islandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
islandTitle.Font = Enum.Font.GothamBold
islandTitle.TextSize = 16
islandTitle.TextXAlignment = Enum.TextXAlignment.Left

local menuFrame = Instance.new("CanvasGroup", screenGui)
menuFrame.Size = UI_CONFIG.MainSize
menuFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
menuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menuFrame.BackgroundTransparency = UI_CONFIG.Trans
menuFrame.Visible = false
menuFrame.GroupTransparency = 1
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 15)
local menuStroke = Instance.new("UIStroke", menuFrame)
menuStroke.Thickness = 2
makeDraggable(menuFrame)

task.spawn(function()
    local i = 0
    while true do
        i = i + 0.01
        local col = Color3.fromHSV(i % 1, 0.7, 1)
        islandStroke.Color = col
        menuStroke.Color = col
        task.wait()
    end
end)

local sideBar = Instance.new("Frame", menuFrame)
sideBar.Size = UDim2.new(0.3, 0, 1, -50)
sideBar.Position = UDim2.new(0, 5, 0, 45)
sideBar.BackgroundTransparency = 1
Instance.new("UIListLayout", sideBar).HorizontalAlignment = Enum.HorizontalAlignment.Center

local generalPage = Instance.new("ScrollingFrame", menuFrame)
generalPage.Size = UDim2.new(0.68, -10, 1, -50)
generalPage.Position = UDim2.new(0.3, 5, 0, 45)
generalPage.BackgroundTransparency = 1
generalPage.BorderSizePixel = 0
generalPage.ScrollBarThickness = 0
generalPage.CanvasSize = UDim2.new(0, 0, 0, 1600)
Instance.new("UIListLayout", generalPage).Padding = UDim.new(0, 10)

local playerListPage = Instance.new("ScrollingFrame", menuFrame)
playerListPage.Size = UDim2.new(0.68, -10, 1, -50)
playerListPage.Position = UDim2.new(0.3, 5, 0, 45)
playerListPage.BackgroundTransparency = 1
playerListPage.BorderSizePixel = 0
playerListPage.ScrollBarThickness = 0
playerListPage.Visible = false
playerListPage.CanvasSize = UDim2.new(0, 0, 0, 2000)
local pListLayout = Instance.new("UIListLayout", playerListPage)
pListLayout.Padding = UDim.new(0, 8)
pListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function toggleMenu()
    if not menuFrame.Visible then
        menuFrame.Visible = true
        TweenService:Create(menuFrame, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
    else
        local tw = TweenService:Create(menuFrame, TweenInfo.new(0.3), {GroupTransparency = 1})
        tw:Play()
        tw.Completed:Connect(function() menuFrame.Visible = false end)
    end
end
openBtn.MouseButton1Click:Connect(toggleMenu)

local function createButton(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.92, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.92
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local selectedTarget = ""
local loopFling = false

local function superFling()
    local target = Players:FindFirstChild(selectedTarget)
    if not target or not target.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local thrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not thrp then return end
    local bV = Instance.new("BodyVelocity", hrp)
    bV.Velocity = Vector3.new(38000, 38000, 38000)
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    local bA = Instance.new("BodyAngularVelocity", hrp)
    bA.AngularVelocity = Vector3.new(38000, 38000, 38000)
    bA.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    task.spawn(function()
        while loopFling and target.Character and hrp.Parent do
            hrp.CFrame = thrp.CFrame
            RunService.Heartbeat:Wait()
        end
        bV:Destroy()
        bA:Destroy()
    end)
end

createButton("通用功能", sideBar, function() generalPage.Visible = true playerListPage.Visible = false end)
createButton("玩家列表", sideBar, function() generalPage.Visible = false playerListPage.Visible = true end)

createButton("甩飞所有人", generalPage, function() notify("甩飞", "功能已开启") loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))() end)

local ncActive = false
local ncConn
local ncBtn = createButton("穿墙模式", generalPage, function()
    ncActive = not ncActive
    ncBtn.BackgroundColor3 = ncActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    ncBtn.BackgroundTransparency = ncActive and 0.6 or 0.92
    notify("穿墙", ncActive and "穿墙已开启" or "穿墙已关闭")
    if ncActive then
        ncConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if ncConn then ncConn:Disconnect() end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

local afActive = false
local afBtn = createButton("反挂机系统", generalPage, function()
    afActive = not afActive
    afBtn.BackgroundColor3 = afActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    afBtn.BackgroundTransparency = afActive and 0.6 or 0.92
    notify("反挂机", afActive and "反挂机已开启" or "反挂机已关闭")
    if afActive then
        LocalPlayer.Idled:Connect(function()
            if afActive then 
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new()) 
            end
        end)
    end
end)

createButton("加载飞行", generalPage, function() notify("飞行", "飞行已开启") loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))() end)
createButton("无限跳跃", generalPage, function() UserInputService.JumpRequest:Connect(function() LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end) notify("跳跃", "无限跳跃已开启") end)
createButton("ESP透视", generalPage, function() for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then local h = p.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", p.Character) h.FillColor = Color3.fromRGB(255, 0, 0) end end notify("透视", "透视已开启") end)
createButton("全亮无雾", generalPage, function() game.Lighting.Brightness, game.Lighting.ClockTime, game.Lighting.FogEnd = 2, 14, 9e9 notify("全亮", "全亮已开启") end)
createButton("瞬间互动", generalPage, function() game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(p) p.HoldDuration = 0 end) notify("互动", "瞬间互动已开启") end)

local tpActive = false
local tpBtn = createButton("点击传送", generalPage, function() 
    tpActive = not tpActive 
    tpBtn.BackgroundColor3 = tpActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    tpBtn.BackgroundTransparency = tpActive and 0.6 or 0.92
    notify("传送", tpActive and "点击传送已开启" or "点击传送已关闭")
end)

local delActive = false
local delBtn = createButton("点击销毁", generalPage, function() 
    delActive = not delActive 
    delBtn.BackgroundColor3 = delActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    delBtn.BackgroundTransparency = delActive and 0.6 or 0.92
    notify("销毁", delActive and "点击销毁已开启" or "点击销毁已关闭")
end)

Mouse.Button1Down:Connect(function()
    if tpActive and LocalPlayer.Character then LocalPlayer.Character:MoveTo(Mouse.Hit.p) end
    if delActive and Mouse.Target then Mouse.Target:Destroy() end
end)

createButton("隐藏名字", generalPage, function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then for _, v in pairs(LocalPlayer.Character.Head:GetChildren()) do if v:IsA("BillboardGui") then v:Destroy() end end end notify("名字", "隐藏已执行") end)
createButton("重置角色", generalPage, function() if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end notify("重置", "已执行重置") end)

local function updatePlayerList()
    for _, v in pairs(playerListPage:GetChildren()) do if v:IsA("TextButton") or v:IsA("Frame") or v:IsA("TextLabel") then v:Destroy() end end
    
    local targetInfo = Instance.new("TextLabel", playerListPage)
    targetInfo.Size = UDim2.new(0.92, 0, 0, 30)
    targetInfo.BackgroundTransparency = 1
    targetInfo.Text = "当前选中: " .. (selectedTarget ~= "" and selectedTarget or "请点击玩家")
    targetInfo.TextColor3 = Color3.fromRGB(255, 255, 100)
    targetInfo.Font = Enum.Font.GothamBold
    targetInfo.TextSize = 14
    targetInfo.LayoutOrder = -10
    
    local lockTpBtn = createButton("锁定快速传送", playerListPage, function()
        local t = Players:FindFirstChild(selectedTarget)
        if t and t.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame end
        notify("传送", "已传送到目标")
    end)
    lockTpBtn.LayoutOrder = -9
    lockTpBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    
    local lockFBtn = createButton("锁定高速甩飞", playerListPage, function()
        if selectedTarget == "" then return end
        loopFling = not loopFling
        lockFBtn.BackgroundColor3 = loopFling and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 150, 255)
        notify("甩飞", loopFling and "锁定甩飞开启" or "锁定甩飞关闭")
        if loopFling then superFling() end
    end)
    lockFBtn.LayoutOrder = -8

    local divider = Instance.new("Frame", playerListPage)
    divider.Size = UDim2.new(0.9, 0, 0, 2)
    divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    divider.BackgroundTransparency = 0.5
    divider.LayoutOrder = -7

    createButton("刷新名单", playerListPage, function() updatePlayerList() notify("列表", "名单已刷新") end).LayoutOrder = -6
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = createButton(p.DisplayName, playerListPage, function() 
                selectedTarget = p.Name 
                targetInfo.Text = "当前选中: " .. p.DisplayName
                notify("锁定", "已选择 " .. p.DisplayName)
            end)
            pBtn.LayoutOrder = 1
        end
    end
end

updatePlayerList()
notify("胖猫hub")
