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
generalPage.CanvasSize = UDim2.new(0, 0, 0, 1400)
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
local flingRunning = false
local flingThread = nil
local flingBV = nil
local flingBAV = nil

local function stopFling()
    loopFling = false
    flingRunning = false
    if flingThread then
        task.cancel(flingThread)
        flingThread = nil
    end
    if flingBV then
        flingBV:Destroy()
        flingBV = nil
    end
    if flingBAV then
        flingBAV:Destroy()
        flingBAV = nil
    end
end

local function startFling()
    if flingRunning then
        stopFling()
        task.wait()
    end
    local target = Players:FindFirstChild(selectedTarget)
    if not target or not target.Character then 
        notify("提示", "目标玩家不存在或未生成角色")
        loopFling = false
        return 
    end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local thrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not thrp then 
        notify("提示", "找不到HumanoidRootPart")
        loopFling = false
        return 
    end
    
    flingBV = hrp:FindFirstChild("FlingBV")
    if not flingBV then
        flingBV = Instance.new("BodyVelocity")
        flingBV.Name = "FlingBV"
        flingBV.Parent = hrp
    end
    flingBV.Velocity = Vector3.new(4000, 4000, 4000)
    flingBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    
    flingBAV = hrp:FindFirstChild("FlingBAV")
    if not flingBAV then
        flingBAV = Instance.new("BodyAngularVelocity")
        flingBAV.Name = "FlingBAV"
        flingBAV.Parent = hrp
    end
    flingBAV.AngularVelocity = Vector3.new(4000, 4000, 4000)
    flingBAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)

    flingRunning = true
    flingThread = task.spawn(function()
        while loopFling and flingRunning and target and target.Character and hrp and hrp.Parent do
            local thrpCurrent = target.Character:FindFirstChild("HumanoidRootPart")
            if thrpCurrent then
                hrp.CFrame = thrpCurrent.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
            end
            task.wait()
        end
        if flingBV and flingBV.Parent then flingBV:Destroy() end
        if flingBAV and flingBAV.Parent then flingBAV:Destroy() end
        flingBV = nil
        flingBAV = nil
        flingRunning = false
    end)
end

local passiveFlingActive = false
local passiveFlingConn = nil
local passiveFlingBV = nil
local passiveFlingBAV = nil
local flingedPlayers = {}

local function stopPassiveFling()
    passiveFlingActive = false
    if passiveFlingConn then
        passiveFlingConn:Disconnect()
        passiveFlingConn = nil
    end
    if passiveFlingBV then
        passiveFlingBV:Destroy()
        passiveFlingBV = nil
    end
    if passiveFlingBAV then
        passiveFlingBAV:Destroy()
        passiveFlingBAV = nil
    end
    for k in pairs(flingedPlayers) do
        flingedPlayers[k] = nil
    end
end

local function startPassiveFling()
    if passiveFlingActive then
        stopPassiveFling()
        return
    end
    passiveFlingActive = true
    notify("反馈", "被动甩飞开启成功，触碰你的玩家将被甩飞")
    
    passiveFlingConn = RunService.Stepped:Connect(function()
        if not passiveFlingActive then return end
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= LocalPlayer then
                local otherChar = otherPlayer.Character
                if otherChar then
                    local otherHrp = otherChar:FindFirstChild("HumanoidRootPart")
                    if otherHrp and hrp.Position and otherHrp.Position then
                        local dist = (hrp.Position - otherHrp.Position).Magnitude
                        if dist < 5 then
                            if not flingedPlayers[otherPlayer] then
                                flingedPlayers[otherPlayer] = true
                                local bv = otherHrp:FindFirstChild("PassiveFlingBV")
                                if not bv then
                                    bv = Instance.new("BodyVelocity")
                                    bv.Name = "PassiveFlingBV"
                                    bv.Parent = otherHrp
                                end
                                bv.Velocity = Vector3.new(2000, 3000, 2000)
                                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                
                                local bav = otherHrp:FindFirstChild("PassiveFlingBAV")
                                if not bav then
                                    bav = Instance.new("BodyAngularVelocity")
                                    bav.Name = "PassiveFlingBAV"
                                    bav.Parent = otherHrp
                                end
                                bav.AngularVelocity = Vector3.new(2000, 2000, 2000)
                                bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                                
                                task.spawn(function()
                                    task.wait(0.5)
                                    if bv and bv.Parent then bv:Destroy() end
                                    if bav and bav.Parent then bav:Destroy() end
                                    flingedPlayers[otherPlayer] = nil
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
end

createButton("通用", sideBar, function() generalPage.Visible = true playerListPage.Visible = false end)
createButton("玩家列表", sideBar, function() generalPage.Visible = false playerListPage.Visible = true end)

local flyLoaded = false
createButton("飞行脚本", generalPage, function()
    if not flyLoaded then
        flyLoaded = true
        loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))()
        notify("反馈", "飞行开启成功")
    else
        notify("提示", "飞行已加载")
    end
end)

local ncActive = false
local ncConn
local ncBtn = createButton("穿墙", generalPage, function()
    ncActive = not ncActive
    ncBtn.BackgroundColor3 = ncActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("反馈", ncActive and "穿墙开启成功" or "穿墙已关闭")
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
    notify("反馈", tpActive and "点击传送开启成功" or "点击传送已关闭")
end)

local delActive = false
local delBtn = createButton("点击销毁物品", generalPage, function()
    delActive = not delActive
    delBtn.BackgroundColor3 = delActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("反馈", delActive and "点击销毁开启成功" or "点击销毁已关闭")
end)

local clickHandler = Mouse.Button1Down:Connect(function()
    if menuFrame.Visible then return end
    if tpActive and LocalPlayer.Character then 
        LocalPlayer.Character:MoveTo(Mouse.Hit.p) 
    end
    if delActive and Mouse.Target then 
        Mouse.Target:Destroy() 
    end
end)

createButton("ESP透视", generalPage, function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
    notify("反馈", "透视开启成功")
end)

local loopFlingBtn = createButton("强化循环甩飞", generalPage, function()
    if selectedTarget == "" then 
        notify("提示", "请先锁定玩家") 
        return 
    end
    loopFling = not loopFling
    if loopFling then 
        if antiFlingActive then
            notify("提示", "请先关闭防甩飞")
            loopFling = false
            return
        end
        startFling() 
        notify("反馈", "甩飞开启成功") 
    else 
        stopFling()
        notify("反馈", "甩飞已关闭") 
    end
end)

local antiFlingActive = false
local afConn
local afBtn = createButton("防甩飞", generalPage, function()
    if loopFling and flingRunning then
        notify("提示", "请先关闭循环甩飞")
        return
    end
    antiFlingActive = not antiFlingActive
    afBtn.BackgroundColor3 = antiFlingActive and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(255, 255, 255)
    notify("反馈", antiFlingActive and "防甩飞开启成功" or "防甩飞已关闭")
    if antiFlingActive then
        if passiveFlingActive then
            notify("提示", "防甩飞与被动甩飞不能同时开启")
            antiFlingActive = false
            afBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            return
        end
        afConn = RunService.PostSimulation:Connect(function()
            if LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then 
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    elseif afConn then 
        afConn:Disconnect() 
        afConn = nil
    end
end)

local passiveFlingBtn = createButton("被动甩飞", generalPage, function()
    if antiFlingActive then
        notify("提示", "请先关闭防甩飞")
        return
    end
    if passiveFlingActive then
        stopPassiveFling()
        passiveFlingBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        notify("反馈", "被动甩飞已关闭")
    else
        startPassiveFling()
        passiveFlingBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

createButton("秒速互动", generalPage, function()
    game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(p) p.HoldDuration = 0 end)
    notify("反馈", "秒速互动开启成功")
end)

createButton("无限跳跃", generalPage, function()
    UserInputService.JumpRequest:Connect(function() LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end)
    notify("反馈", "无限跳跃开启成功")
end)

createButton("全亮无雾", generalPage, function()
    game.Lighting.Brightness, game.Lighting.ClockTime, game.Lighting.FogEnd = 2, 14, 9e9
    notify("反馈", "全亮无雾开启成功")
end)

createButton("反挂机", generalPage, function()
    LocalPlayer.Idled:Connect(function() game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)
    notify("反馈", "反挂机开启成功")
end)

createButton("隐藏名字", generalPage, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        for _, v in pairs(LocalPlayer.Character.Head:GetChildren()) do
            if v:IsA("BillboardGui") then v:Destroy() end
        end
    end
    notify("反馈", "隐藏名字开启成功")
end)

createButton("传送至锁定玩家", generalPage, function()
    local t = Players:FindFirstChild(selectedTarget)
    if t and t.Character then 
        LocalPlayer.Character:MoveTo(t.Character.HumanoidRootPart.Position) 
        notify("反馈", "传送开启成功") 
    end
end)

createButton("重置角色", generalPage, function() if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() notify("反馈", "重置成功") end end)

local function updatePlayerList()
    for _, v in pairs(playerListPage:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    createButton("刷新玩家列表", playerListPage, function() updatePlayerList() end)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            createButton(p.DisplayName, playerListPage, function() 
                selectedTarget = p.Name 
                notify("反馈", "已锁定 " .. p.DisplayName)
            end)
        end
    end
end

local oldInstance; oldInstance = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if self == LocalPlayer and (method == "Kick" or method == "kick") then
        return nil
    end
    return oldInstance(self, ...)
end)

updatePlayerList()
notify("防踢已开启")
notify("胖猫hub", "欢迎使用")