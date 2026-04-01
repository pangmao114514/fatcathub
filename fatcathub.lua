local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/WindUI.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Window = WindUI:CreateWindow({
    Title = "胖猫hub",
    Icon = "rbxassetid://6034822712",
    Author = "胖猫",
    Folder = "FatCatHub_Final"
})

Window:EditIsland({
    Title = "胖猫hub",
    Icon = "rbxassetid://6034822712"
})

local GeneralTab = Window:CreateTab("通用功能", "home")

local ncConn
GeneralTab:AddToggle({
    Title = "穿墙模式",
    Default = false,
    Callback = function(state)
        if state then
            ncConn = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
            WindUI:Notify({Title = "反馈", Content = "穿墙模式开启成功", Duration = 2})
        else
            if ncConn then ncConn:Disconnect() end
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = true end
                end
            end
            WindUI:Notify({Title = "反馈", Content = "穿墙模式已关闭", Duration = 2})
        end
    end
})

GeneralTab:AddToggle({
    Title = "反挂机系统",
    Default = false,
    Callback = function(state)
        if state then
            LocalPlayer.Idled:Connect(function()
                if state then
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                end
            end)
            WindUI:Notify({Title = "反馈", Content = "反挂机开启成功", Duration = 2})
        else
            WindUI:Notify({Title = "反馈", Content = "反挂机已关闭", Duration = 2})
        end
    end
})

GeneralTab:AddButton({
    Title = "甩飞所有人",
    Callback = function()
        WindUI:Notify({Title = "反馈", Content = "甩飞开启成功", Duration = 2})
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end
})

GeneralTab:AddButton({
    Title = "加载飞行",
    Callback = function()
        WindUI:Notify({Title = "反馈", Content = "飞行开启成功", Duration = 2})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))()
    end
})

GeneralTab:AddButton({
    Title = "无限跳跃",
    Callback = function()
        UserInputService.JumpRequest:Connect(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end)
        WindUI:Notify({Title = "反馈", Content = "无限跳跃开启成功", Duration = 2})
    end
})

GeneralTab:AddButton({
    Title = "ESP 玩家透视",
    Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", p.Character)
                h.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
        WindUI:Notify({Title = "反馈", Content = "透视开启成功", Duration = 2})
    end
})

GeneralTab:AddButton({
    Title = "全亮无雾",
    Callback = function()
        game.Lighting.Brightness, game.Lighting.ClockTime, game.Lighting.FogEnd = 2, 14, 9e9
        WindUI:Notify({Title = "反馈", Content = "全亮开启成功", Duration = 2})
    end
})

GeneralTab:AddButton({
    Title = "瞬间互动",
    Callback = function()
        game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(p) p.HoldDuration = 0 end)
        WindUI:Notify({Title = "反馈", Content = "瞬间互动开启成功", Duration = 2})
    end
})

local tpActive = false
GeneralTab:AddToggle({
    Title = "点击传送",
    Default = false,
    Callback = function(state)
        tpActive = state
        WindUI:Notify({Title = "反馈", Content = state and "点击传送开启成功" or "点击传送已关闭", Duration = 2})
    end
})

local delActive = false
GeneralTab:AddToggle({
    Title = "点击销毁",
    Default = false,
    Callback = function(state)
        delActive = state
        WindUI:Notify({Title = "反馈", Content = state and "点击销毁开启成功" or "点击销毁已关闭", Duration = 2})
    end
})

Mouse.Button1Down:Connect(function()
    if tpActive and LocalPlayer.Character then LocalPlayer.Character:MoveTo(Mouse.Hit.p) end
    if delActive and Mouse.Target then Mouse.Target:Destroy() end
end)

GeneralTab:AddButton({
    Title = "隐藏名字标签",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            for _, v in pairs(LocalPlayer.Character.Head:GetChildren()) do
                if v:IsA("BillboardGui") then v:Destroy() end
            end
        end
        WindUI:Notify({Title = "反馈", Content = "隐藏名字开启成功", Duration = 2})
    end
})

GeneralTab:AddButton({
    Title = "重置角色",
    Callback = function()
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
        WindUI:Notify({Title = "反馈", Content = "重置角色成功", Duration = 2})
    end
})

local PlayerTab = Window:CreateTab("玩家列表", "users")
local selectedPlayer = ""
local loopFling = false

local targetDisplay = PlayerTab:AddParagraph({
    Title = "锁定: 无",
    Content = "请在下方选择目标"
})

PlayerTab:AddButton({
    Title = "快速传送至目标",
    Callback = function()
        local t = Players:FindFirstChild(selectedPlayer)
        if t and t.Character then 
            LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame 
            WindUI:Notify({Title = "反馈", Content = "传送开启成功", Duration = 2})
        end
    end
})

PlayerTab:AddToggle({
    Title = "高速甩飞目标",
    Default = false,
    Callback = function(state)
        if selectedPlayer == "" then return end
        loopFling = state
        WindUI:Notify({Title = "反馈", Content = state and "高速甩飞开启成功" or "高速甩飞已关闭", Duration = 2})
        if state then
            task.spawn(function()
                while loopFling do
                    local t = Players:FindFirstChild(selectedPlayer)
                    if t and t.Character and LocalPlayer.Character then
                        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local thrp = t.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and thrp then
                            hrp.CFrame = thrp.CFrame
                            local bv = Instance.new("BodyVelocity", hrp)
                            bv.Velocity = Vector3.new(45000, 45000, 45000)
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            task.wait()
                            bv:Destroy()
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

PlayerTab:AddParagraph({Title = "--- 名单 ---", Content = ""})

local function refresh()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            PlayerTab:AddButton({
                Title = p.DisplayName,
                Callback = function()
                    selectedPlayer = p.Name
                    targetDisplay:Set({Title = "锁定: " .. p.DisplayName, Content = "已就绪"})
                    WindUI:Notify({Title = "反馈", Content = "目标锁定成功", Duration = 2})
                end
            })
        end
    end
end
refresh()

Window:SelectTab(GeneralTab)
