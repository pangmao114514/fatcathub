local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")

local function notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2,
        Icon = "rbxassetid://6033327349"
    })
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FatCat_Island_Final_Transparent"
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
island.Size = UDim2.new(0, 260, 0, 42)
island.Position = UDim2.new(0.5, -130, 0, 25)
island.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
island.BackgroundTransparency = 0.7
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
islandTitle.Size = UDim2.new(1, -60, 1, 0)
islandTitle.Position = UDim2.new(0, 30, 0, 0)
islandTitle.BackgroundTransparency = 1
islandTitle.Text = "胖猫hub"
islandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
islandTitle.Font = Enum.Font.GothamBold
islandTitle.TextSize = 16
islandTitle.TextXAlignment = Enum.TextXAlignment.Center

local menuFrame = Instance.new("CanvasGroup", screenGui)
menuFrame.Size = UDim2.new(0, 450, 0, 350)
menuFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
menuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menuFrame.BackgroundTransparency = 0.8
menuFrame.Visible = false
menuFrame.GroupTransparency = 1
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 15)
local menuStroke = Instance.new("UIStroke", menuFrame)
menuStroke.Thickness = 3
makeDraggable(menuFrame)

task.spawn(function()
    local h = 0
    while true do
        h = h + 1/300
        local col = Color3.fromHSV(h % 1, 0.8, 1)
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

local contentFrame = Instance.new("Frame", menuFrame)
contentFrame.Size = UDim2.new(0.7, -10, 1, -50)
contentFrame.Position = UDim2.new(0.3, 5, 0, 45)
contentFrame.BackgroundTransparency = 1

local generalPage = Instance.new("ScrollingFrame", contentFrame)
generalPage.Size = UDim2.new(1, 0, 1, 0)
generalPage.BackgroundTransparency = 1
generalPage.ScrollBarThickness = 0
generalPage.CanvasSize = UDim2.new(0, 0, 0, 1000)
Instance.new("UIListLayout", generalPage).Padding = UDim.new(0, 8)

local playerListPage = Instance.new("ScrollingFrame", contentFrame)
playerListPage.Size = UDim2.new(1, 0, 1, 0)
playerListPage.BackgroundTransparency = 1
playerListPage.Visible = false
playerListPage.ScrollBarThickness = 0
playerListPage.CanvasSize = UDim2.new(0, 0, 0, 1500)
local pListLayout = Instance.new("UIListLayout", playerListPage)
pListLayout.Padding = UDim.new(0, 8)
pListLayout.SortOrder = Enum.SortOrder.LayoutOrder

openBtn.MouseButton1Click:Connect(function()
    if not menuFrame.Visible then
        menuFrame.Visible = true
        TweenService:Create(menuFrame, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
    else
        local tw = TweenService:Create(menuFrame, TweenInfo.new(0.3), {GroupTransparency = 1})
        tw:Play()
        tw.Completed:Connect(function() menuFrame.Visible = false end)
    end
end)

local function createBtn(text, parent, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundTransparency = 0.9
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(callback)
    return b
end

createBtn("通用功能", sideBar, function() generalPage.Visible = true playerListPage.Visible = false end)
createBtn("玩家列表", sideBar, function() generalPage.Visible = false playerListPage.Visible = true end)

local ncOn = false
local ncLoop
local ncBtn = createBtn("穿墙模式", generalPage, function()
    ncOn = not ncOn
    ncBtn.BackgroundColor3 = ncOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    notify("反馈", ncOn and "穿墙开启成功" or "穿墙已关闭")
    if ncOn then
        ncLoop = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    else
        if ncLoop then ncLoop:Disconnect() end
    end
end)

local afkOn = false
local afkBtn = createBtn("反挂机系统", generalPage, function()
    afkOn = not afkOn
    afkBtn.BackgroundColor3 = afkOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    notify("反馈", afkOn and "反挂机开启成功" or "反挂机已关闭")
    if afkOn then
        LocalPlayer.Idled:Connect(function()
            if afkOn then game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end
        end)
    end
end)

createBtn("甩飞所有人", generalPage, function() notify("反馈", "甩飞开启成功") loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))() end)
createBtn("加载飞行", generalPage, function() notify("反馈", "飞行开启成功") loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))() end)
createBtn("无限跳跃", generalPage, function() UserInputService.JumpRequest:Connect(function() LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end) notify("反馈", "无限跳跃开启成功") end)
createBtn("ESP 玩家透视", generalPage, function() for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then local h = p.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", p.Character) h.FillColor = Color3.fromRGB(255, 0, 0) end end notify("反馈", "透视开启成功") end)
createBtn("全亮无雾", generalPage, function() game.Lighting.Brightness, game.Lighting.ClockTime, game.Lighting.FogEnd = 2, 14, 9e9 notify("反馈", "全亮开启成功") end)
createBtn("瞬间互动", generalPage, function() game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(p) p.HoldDuration = 0 end) notify("反馈", "瞬间互动开启成功") end)

local tpOn = false
local tpBtn = createBtn("点击传送", generalPage, function() tpOn = not tpOn tpBtn.BackgroundColor3 = tpOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255) notify("反馈", tpOn and "点击传送开启成功" or "点击传送已关闭") end)
local delOn = false
local delBtn = createBtn("点击销毁", generalPage, function() delOn = not delOn delBtn.BackgroundColor3 = delOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255) notify("反馈", delOn and "点击销毁开启成功" or "点击销毁已关闭") end)

Mouse.Button1Down:Connect(function()
    if tpOn and LocalPlayer.Character then LocalPlayer.Character:MoveTo(Mouse.Hit.p) end
    if delOn and Mouse.Target then Mouse.Target:Destroy() end
end)

createBtn("隐藏名字标签", generalPage, function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then for _, v in pairs(LocalPlayer.Character.Head:GetChildren()) do if v:IsA("BillboardGui") then v:Destroy() end end end notify("反馈", "隐藏名字开启成功") end)
createBtn("重置角色", generalPage, function() if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end notify("反馈", "重置角色成功") end)

local selP = ""
local loopFl = false

local function updatePlayers()
    for _, v in pairs(playerListPage:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") or v:IsA("Frame") then v:Destroy() end end
    
    local lab = Instance.new("TextLabel", playerListPage)
    lab.Size = UDim2.new(0.95, 0, 0, 30)
    lab.BackgroundTransparency = 1
    lab.Text = "锁定目标: " .. (selP ~= "" and selP or "未选择")
    lab.TextColor3 = Color3.fromRGB(255, 255, 100)
    lab.Font = Enum.Font.GothamBold
    lab.TextSize = 14
    lab.LayoutOrder = -10

    local lockTp = createBtn("快速传送至目标", playerListPage, function()
        local t = Players:FindFirstChild(selP)
        if t and t.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame notify("反馈", "传送成功") end
    end)
    lockTp.LayoutOrder = -9
    lockTp.BackgroundColor3 = Color3.fromRGB(100, 150, 255)

    local lockFlBtn = createBtn("高速甩飞目标", playerListPage, function()
        if selP == "" then return end
        loopFl = not loopFl
        lockFlBtn.BackgroundColor3 = loopFl and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 150, 255)
        notify("反馈", loopFl and "高速甩飞开启成功" or "高速甩飞已关闭")
        if loopFl then
            task.spawn(function()
                while loopFl do
                    local t = Players:FindFirstChild(selP)
                    if t and t.Character and LocalPlayer.Character then
                        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local thrp = t.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and thrp then
                            hrp.CFrame = thrp.CFrame
                            local bv = Instance.new("BodyVelocity", hrp)
                            bv.Velocity = Vector3.new(50000, 50000, 50000)
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            task.wait()
                            bv:Destroy()
                        end
                    end
                    task.wait()
                end
            end)
        end
    end)
    lockFlBtn.LayoutOrder = -8

    createBtn("刷新名单", playerListPage, function() updatePlayers() end).LayoutOrder = -7
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pB = createBtn(p.DisplayName, playerListPage, function() selP = p.Name lab.Text = "锁定目标: " .. p.DisplayName notify("反馈", "已锁定目标") end)
            pB.LayoutOrder = 1
        end
    end
end

updatePlayers()
notify("胖猫hub")
