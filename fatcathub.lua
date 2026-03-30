local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FatCatUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

local floatingBtn = Instance.new("ImageButton")
floatingBtn.Size = UDim2.new(0, 44, 0, 44)
floatingBtn.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.BackgroundTransparency = 0.85
floatingBtn.Image = "rbxassetid://3926305904"
floatingBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(100, 150, 255)
btnStroke.Thickness = 2
btnStroke.Parent = floatingBtn

task.spawn(function()
    local colors = {Color3.fromRGB(100, 150, 255), Color3.fromRGB(255, 100, 150), Color3.fromRGB(255, 200, 100), Color3.fromRGB(100, 255, 150)}
    local i = 1
    while true do
        btnStroke.Color = colors[i]
        i = i % 4 + 1
        task.wait(0.3)
    end
end)

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 450, 0, 300)
menuFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
menuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menuFrame.BackgroundTransparency = 0.85
menuFrame.Visible = false
menuFrame.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menuFrame

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(100, 150, 255)
menuStroke.Thickness = 2
menuStroke.Parent = menuFrame

task.spawn(function()
    local colors = {Color3.fromRGB(100, 150, 255), Color3.fromRGB(255, 100, 150), Color3.fromRGB(255, 200, 100), Color3.fromRGB(100, 255, 150)}
    local i = 1
    while true do
        menuStroke.Color = colors[i]
        i = i % 4 + 1
        task.wait(0.3)
    end
end)

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

local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0.33, 0, 1, -45)
sideBar.Position = UDim2.new(0, 0, 0, 40)
sideBar.BackgroundTransparency = 1
sideBar.Parent = menuFrame

local sideLayout = Instance.new("UIListLayout")
sideLayout.Parent = sideBar
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.Padding = UDim.new(0, 5)

local mainContent = Instance.new("ScrollingFrame")
mainContent.Size = UDim2.new(0.67, -10, 1, -45)
mainContent.Position = UDim2.new(0.33, 5, 0, 40)
mainContent.BackgroundTransparency = 1
mainContent.BorderSizePixel = 0
mainContent.ScrollBarThickness = 2
mainContent.CanvasSize = UDim2.new(0, 0, 0, 520)
mainContent.Visible = true
mainContent.Parent = menuFrame

local mainLayout = Instance.new("UIListLayout")
mainLayout.Parent = mainContent
mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
mainLayout.Padding = UDim.new(0, 8)

local speedPanel = Instance.new("Frame")
speedPanel.Size = UDim2.new(0, 200, 0, 100)
speedPanel.Position = UDim2.new(0.5, -100, 0.5, 50)
speedPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedPanel.BackgroundTransparency = 0.2
speedPanel.Visible = false
speedPanel.Parent = screenGui
local spCorner = Instance.new("UICorner")
spCorner.Parent = speedPanel
local spStroke = Instance.new("UIStroke")
spStroke.Color = Color3.fromRGB(255, 255, 255)
spStroke.Parent = speedPanel

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.8, 0, 0, 30)
speedInput.Position = UDim2.new(0.1, 0, 0.2, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.Text = "16"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Font = Enum.Font.Gotham
speedInput.Parent = speedPanel
Instance.new("UICorner").Parent = speedInput

local setSpeedBtn = Instance.new("TextButton")
setSpeedBtn.Size = UDim2.new(0.8, 0, 0, 30)
setSpeedBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
setSpeedBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
setSpeedBtn.Text = "确定速度"
setSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setSpeedBtn.Parent = speedPanel
Instance.new("UICorner").Parent = setSpeedBtn

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.85
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = sideBar
    local cp = Instance.new("UICorner")
    cp.CornerRadius = UDim.new(0, 8)
    cp.Parent = btn
end

local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.85
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = mainContent
    local cp = Instance.new("UICorner")
    cp.CornerRadius = UDim.new(0, 20)
    cp.Parent = btn
    local st = Instance.new("UIStroke")
    st.Color = Color3.fromRGB(255, 255, 255)
    st.Transparency = 0.5
    st.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createTab("通用")

createButton("飞行", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))()
end)

local ncActive = false
local ncConn = nil
local ncBtn = createButton("穿墙", function()
    ncActive = not ncActive
    if ncActive then
        ncBtn.Text = "穿墙 (开)"
        ncBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        ncConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    else
        ncBtn.Text = "穿墙"
        ncBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        if ncConn then ncConn:Disconnect() ncConn = nil end
    end
end)

createButton("甩飞所有人", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
end)

createButton("快速互动", function()
    game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(p)
        p.HoldDuration = 0
    end)
end)

createButton("无限跳跃", function()
    UserInputService.JumpRequest:Connect(function()
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end)
end)

createButton("全亮/移除雾", function()
    local l = game:GetService("Lighting")
    l.Brightness = 2
    l.ClockTime = 14
    l.FogEnd = 9e9
    l.GlobalShadows = false
end)

createButton("移动加速 (调数值)", function()
    speedPanel.Visible = not speedPanel.Visible
end)

setSpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(speedInput.Text)
    if val and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
        speedPanel.Visible = false
    end
end)

local tpActive = false
local tpBtn = createButton("点击传送", function()
    tpActive = not tpActive
    if tpActive then
        tpBtn.Text = "点击传送 (开)"
        tpBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    else
        tpBtn.Text = "点击传送"
        tpBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

LocalPlayer:GetMouse().Button1Down:Connect(function()
    if tpActive and LocalPlayer.Character then
        LocalPlayer.Character:MoveTo(LocalPlayer:GetMouse().Hit.p)
    end
end)

createButton("透视 (ESP)", function()
    local function addEsp(p)
        if p.Character then
            local h = Instance.new("Highlight")
            h.Parent = p.Character
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then addEsp(p) end
    end
end)

createButton("重置角色", function()
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end)

floatingBtn.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

local dragStart, startPos, dragging
floatingBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = i.Position startPos = floatingBtn.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        floatingBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "加载成功", Text = "欢迎使用胖猫hub", Duration = 5})
