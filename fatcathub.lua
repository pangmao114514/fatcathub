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
    Folder = "FatCatHub_Final",
    Transparent = true,
    Blur = true
})

Window:EditIsland({
    Title = "胖猫hub",
    Icon = "rbxassetid://6034822712",
    TextAlign = "Center"
})

local function AddRainbow(obj)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
    task.spawn(function()
        local h = 0
        while true do
            h = h + 1/300
            stroke.Color = Color3.fromHSV(h % 1, 0.8, 1)
            task.wait()
        end
    end)
end

if Window.Instance then AddRainbow(Window.Instance) end

local MainTab = Window:CreateTab("通用功能", "home")

local ncConn
MainTab:AddToggle({
    Title = "穿墙模式",
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

MainTab:AddToggle({
    Title = "反挂机系统",
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

MainTab:AddButton({
    Title = "甩飞所有人",
    Callback = function()
        WindUI:Notify({Title = "反馈", Content = "甩飞开启成功", Duration = 2})
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end
})

MainTab:AddButton({
    Title = "加载飞行",
    Callback = function()
        WindUI:Notify({Title = "反馈", Content = "飞行开启成功", Duration = 2})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))()
    end
})

MainTab:AddButton({
    Title = "无限跳跃",
    Callback = function()
        UserInputService.JumpRequest:Connect(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end)
        WindUI:Notify({Title = "反馈", Content = "无限跳跃开启成功", Duration = 2})
    end
})

MainTab:AddButton({
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

MainTab:AddButton({
    Title = "全亮无雾",
    Callback = function()
        game.Lighting.Brightness, game.Lighting.ClockTime, game.Lighting.FogEnd = 2, 14, 9e9
        WindUI:Notify({Title = "反馈", Content = "全亮开启成功", Duration = 2})
    end
})

MainTab:AddButton({
    Title = "瞬间互动",
    Callback = function()
        game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(p) p.HoldDuration = 0 end)
        WindUI:Notify({Title = "反馈", Content = "瞬间互动开启成功", Duration = 2})
    end
})

local tpActive = false
MainTab:AddToggle({
    Title = "点击传送",
    Callback = function(state)
        tpActive = state
        WindUI:Notify({Title = "反馈", Content = state and "点击传送开启成功" or "点击传送已关闭", Duration = 2})
    end
})

local delActive = false
MainTab:AddToggle({
    Title = "点击销毁",
    Callback = function(state)
        delActive = state
        WindUI:Notify({Title = "反馈", Content = state and "点击销毁开启成功" or "点击销毁已关闭", Duration = 2})
    end
})

Mouse.Button1Down:Connect(function()
    if tpActive and LocalPlayer.Character then LocalPlayer.Character:MoveTo(Mouse.Hit.p) end
    if delActive and Mouse.Target then Mouse.Target:Destroy() end
end)

MainTab:AddButton({
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

MainTab:AddButton({
    Title = "重置角色",
    Callback = function()
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
        WindUI:Notify({Title = "反馈", Content = "重置角色开启成功", Duration = 2})
    end
})

local UserTab = Window:CreateTab("玩家列表", "users")
local selectedP = ""
local loopFl = false

local pLabel = UserTab:AddParagraph({
    Title = "锁定目标: 无",
    Content = "请在下方名单选择"
})

UserTab:AddButton({
    Title = "快速传送至目标",
    Callback = function()
        local t = Players:FindFirstChild(selectedP)
        if t and t.Character then 
            LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame 
            WindUI:Notify({Title = "反馈", Content = "传送开启成功", Duration = 2})
        end
    end
})

UserTab:AddToggle({
    Title = "高速甩飞目标",
    Callback = function(state)
        if selectedP == "" then return end
        loopFl = state
        WindUI:Notify({Title = "反馈", Content = state and "高速甩飞开启成功" or "高速甩飞已关闭", Duration = 2})
        if state then
            task.spawn(function()
                while loopFl do
                    local t = Players:FindFirstChild(selectedP)
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
    end
})

UserTab:AddParagraph({Title = "--- 玩家名单 ---", Content = ""})

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        UserTab:AddButton({
            Title = "锁定: " .. p.DisplayName,
            Callback = function()
                selectedP = p.Name
                pLabel:Set({Title = "锁定目标: " .. p.DisplayName, Content = "已就绪"})
                WindUI:Notify({Title = "反馈", Content = "目标锁定成功", Duration = 2})
            end
        })
    end
end

Window:SelectTab(MainTab)
