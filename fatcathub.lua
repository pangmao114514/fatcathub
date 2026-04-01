local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")

local UI_CONFIG = {
    MainSize = UDim2.new(0, 450, 0, 300),
    IslandSize = UDim2.new(0, 220, 0, 38),
    Trans = 0.85,
    AnimTime = 0.4,
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
screenGui.Name = "FatCat_Island_Ultra"
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
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(gui, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Position = targetPos}):Play()
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
island.Position = UDim2.new(0.5, -110, 0, 25)
island.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
island.BackgroundTransparency = UI_CONFIG.Trans
island.Parent = screenGui
Instance.new("UICorner", island).CornerRadius = UDim.new(0, 20)
local islandStroke = Instance.new("UIStroke", island)
islandStroke.Thickness = 2
islandStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
makeDraggable(island)

local openBtn = Instance.new("ImageButton", island)
openBtn.Size = UDim2.new(0, 28, 0, 28)
openBtn.Position = UDim2.new(0, 10, 0.5, -14)
openBtn.BackgroundTransparency = 1
openBtn.Image = "rbxassetid://6034822712"
openBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)

local islandTitle = Instance.new("TextLabel", island)
islandTitle.Size = UDim2.new(0.7, 0, 1, 0)
islandTitle.Position = UDim2.new(0.25, 0, 0, 0)
islandTitle.BackgroundTransparency = 1
islandTitle.Text = "胖猫hub"
islandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
islandTitle.Font = Enum.Font.GothamBold
islandTitle.TextSize = 15
islandTitle.TextXAlignment = Enum.TextXAlignment.Left

local menuFrame = Instance.new("CanvasGroup", screenGui)
menuFrame.Size = UI_CONFIG.MainSize
menuFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
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
generalPage.CanvasSize = UDim2.new(0, 0, 0, 1200)
Instance.new("UIListLayout", generalPage).Padding = UDim.new(0, 10)

local playerListPage = Instance.new("ScrollingFrame", menuFrame)
playerListPage.Size = UDim2.new(0.68, -10, 1, -50)
playerListPage.Position = UDim2.new(0.3, 5, 0, 45)
playerListPage.BackgroundTransparency = 1
playerListPage.BorderSizePixel = 0
playerListPage.ScrollBarThickness = 0
playerListPage.Visible = false
playerListPage.CanvasSize = UDim2.new(0, 0, 0, 1500)
Instance.new("UIListLayout", playerListPage).Padding = UDim.new(0, 10)

local function toggleMenu()
    if not menuFrame.Visible then
        menuFrame.Visible = true
        menuFrame.Size = UDim2.new(0, 300, 0, 200)
        menuFrame.GroupTransparency = 1
        TweenService:Create(menuFrame, TweenInfo.new(UI_CONFIG.AnimTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UI_CONFIG.MainSize,
            GroupTransparency = 0
        }):Play()
    else
        local tw = TweenService:Create(menuFrame, TweenInfo.new(UI_CONFIG.AnimTime, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 300, 0, 200),
            GroupTransparency = 1
        })
        tw:Play()
        tw.Completed:Connect(function() menuFrame.Visible = false end)
    end
end
openBtn.MouseButton1Click:Connect(toggleMenu)

local function createButton(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.92, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.92
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0.85, 0, 0, 34), BackgroundTransparency = 0.7}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0.92, 0, 0, 38), BackgroundTransparency = 0.92}):Play()
        callback()
    end)
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
    bV.Velocity = Vector3.new(20000, 20000, 20000)
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    local bA = Instance.new("BodyAngularVelocity", hrp)
    bA.AngularVelocity = Vector3.new(20000, 20000, 20000)
    bA.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    task.spawn(function()
        while loopFling and target.Character and hrp.Parent do
            hrp.CFrame = thrp.CFrame
            RunService.Stepped:Wait()
        end
        bV:Destroy()
        bA:Destroy()
    end)
end

createButton("通用功能", sideBar, function() generalPage.Visible = true playerListPage.Visible = false end)
createButton("玩家列表", sideBar, function() generalPage.Visible = false playerListPage.Visible = true end)

createButton("甩飞所有人", generalPage, function() notify("甩飞", "加载皮脚本逻辑...") loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))() end)

local ncActive = false
local ncConn
local ncBtn = createButton("穿墙模式", generalPage, function()
    ncActive = not ncActive
    ncBtn.BackgroundColor3 = ncActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("穿墙", ncActive and "状态: 开启" or "状态: 关闭")
    if ncActive then
        ncConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then 
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do 
                    if v:IsA("BasePart") then v.CanCollide = false end 
                end 
            end
        end)
    elseif ncConn then 
        ncConn:Disconnect() 
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do 
                if v:IsA("BasePart") then v.CanCollide = true end 
            end
        end
    end
end)

createButton("全亮模式", generalPage, function() game.Lighting.Brightness, game.Lighting.ClockTime, game.Lighting.FogEnd = 2, 14, 9e9 notify("环境", "已增强视觉") end)
createButton("瞬间互动", generalPage, function() game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(p) p.HoldDuration = 0 end) notify("互动", "已移除延迟") end)

local afActive = false
local afBtn = createButton("反挂机系统", generalPage, function()
    afActive = not afActive
    afBtn.BackgroundColor3 = afActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("反挂机", afActive and "系统已启动" or "系统已停止")
    if afActive then
        LocalPlayer.Idled:Connect(function() 
            if afActive then game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end
        end)
    end
end)

local function updatePlayerList()
    for _, v in pairs(playerListPage:GetChildren()) do if v:IsA("TextButton") or v:IsA("Frame") then v:Destroy() end end
    createButton("刷新名单", playerListPage, function() updatePlayerList() end)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            createButton(p.DisplayName, playerListPage, function() 
                selectedTarget = p.Name 
                notify("锁定目标", p.DisplayName)
            end)
        end
    end
    local line = Instance.new("Frame", playerListPage)
    line.Size = UDim2.new(0.9, 0, 0, 1)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BackgroundTransparency = 0.5
    
    createButton("锁定快速传送", playerListPage, function()
        local t = Players:FindFirstChild(selectedTarget)
        if t and t.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame end
    end)
    local fBtn = createButton("锁定高速甩飞", playerListPage, function()
        if selectedTarget == "" then notify("提示", "请选择玩家") return end
        loopFling = not loopFling
        fBtn.BackgroundColor3 = loopFling and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
        if loopFling then superFling() end
    end)
end

updatePlayerList()
notify("胖猫hub")
