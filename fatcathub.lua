local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FatCatUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local floatingBtn = Instance.new("ImageButton")
floatingBtn.Size = UDim2.new(0, 44, 0, 44)
floatingBtn.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.BackgroundTransparency = 0.85
floatingBtn.Image = "rbxassetid://3926305904"
floatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.ScaleType = Enum.ScaleType.Fit
floatingBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(100, 150, 255)
btnStroke.Thickness = 2
btnStroke.Transparency = 0.3
btnStroke.Parent = floatingBtn

spawn(function()
    local colors = {
        Color3.fromRGB(100, 150, 255),
        Color3.fromRGB(255, 100, 150),
        Color3.fromRGB(255, 200, 100),
        Color3.fromRGB(100, 255, 150),
    }
    local index = 1
    while true do
        btnStroke.Color = colors[index]
        index = index % 4 + 1
        task.wait(0.3)
    end
end)

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 220, 0, 400)
menuFrame.Position = UDim2.new(0.5, -110, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menuFrame.BackgroundTransparency = 0.85
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menuFrame

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(100, 150, 255)
menuStroke.Thickness = 2
menuStroke.Transparency = 0.2
menuStroke.Parent = menuFrame

spawn(function()
    local colors = {
        Color3.fromRGB(100, 150, 255),
        Color3.fromRGB(255, 100, 150),
        Color3.fromRGB(255, 200, 100),
        Color3.fromRGB(100, 255, 150),
    }
    local index = 1
    while true do
        menuStroke.Color = colors[index]
        index = index % 4 + 1
        task.wait(0.3)
    end
end)

local blur = Instance.new("BlurEffect")
blur.Size = 12
blur.Parent = menuFrame

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 38)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "fatcathub"
menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.Font = Enum.Font.GothamSemibold
menuTitle.TextSize = 16
menuTitle.Parent = menuFrame

local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, 0, 1, -38)
buttonContainer.Position = UDim2.new(0, 0, 0, 38)
buttonContainer.BackgroundTransparency = 1
buttonContainer.BorderSizePixel = 0
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
buttonContainer.ScrollBarThickness = 3
buttonContainer.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
buttonContainer.Parent = menuFrame

local uiList = Instance.new("UIListLayout")
uiList.Parent = buttonContainer
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 6)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.85
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = buttonContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 16)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        callback()
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = name,
                Text = "已执行",
                Duration = 1
            })
        end)
    end)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
        btnStroke.Transparency = 0.2
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
        btnStroke.Transparency = 0.5
    end)
    
    return btn
end

local function updateCanvas()
    local children = buttonContainer:GetChildren()
    local count = 0
    for _, child in pairs(children) do
        if child:IsA("TextButton") then
            count = count + 1
        end
    end
    local height = count * 38 + 16
    buttonContainer.CanvasSize = UDim2.new(0, 0, 0, height)
end

local function addButtons()
    createButton("光影", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/arzRCgwS"))()
    end)
    
    createButton("光影2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
    end)
    
    createButton("建筑工具", function()
        Hammer = Instance.new("HopperBin")
        Hammer.Name = "锤子"
        Hammer.BinType = 4
        Hammer.Parent = game.Players.LocalPlayer.Backpack
        Clone = Instance.new("HopperBin")
        Clone.Name = "克隆"
        Clone.BinType = 3
        Clone.Parent = game.Players.LocalPlayer.Backpack
        Grab = Instance.new("HopperBin")
        Grab.Name = "抓取"
        Grab.BinType = 2
    end)
    
    createButton("画质", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))()
    end)
    
    createButton("旋转", function()
        loadstring(game:HttpGet('https://pastebin.com/raw/r97d7dS0', true))()
    end)
    
    createButton("飞车", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/MHE1cbWF"))()
    end)
    
    createButton("工具挂", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/StandAwekening.lua"))()
    end)
    
    createButton("人物无敌", function()
        loadstring(game:HttpGet('https://pastebin.com/raw/H3RLCWWZ'))()
    end)
    
    createButton("飞行", function()
        loadstring(game:HttpGet('https://pastebin.com/raw/U27yQRxS'))()
    end)
    
    createButton("速度更改", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/Zuw5T7DP",true))()
    end)
    
    createButton("甩飞别人", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/GnvPVBEi"))()
    end)
    
    createButton("爬墙", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
    end)
    
    createButton("动作", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/Zj4NnKs6"))()
    end)
    
    createButton("电脑键盘", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
    end)
    
    createButton("铁拳", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt'))()
    end)
    
    createButton("无敌", function()
        loadstring(game:HttpGet('https://pastebin.com/raw/H3RLCWWZ'))()
    end)
    
    createButton("飞车", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/G3GnBCyC", true))()
    end)
    
    createButton("转圈", function()
        loadstring(game:HttpGet('https://pastebin.com/raw/r97d7dS0', true))()
    end)
    
    createButton("飞车2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/vb/main/%E9%A3%9E%E8%BD%A6.lua"))()
    end)
    
    createButton("吸取全部玩家", function()
        loadstring(game:HttpGet('https://pastebin.com/raw/hQSBGsw2'))()
    end)
    
    createButton("死亡笔记", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"))()
    end)
    
    createButton("甩人", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end)
    
    createButton("铁拳", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt'))()
    end)
    
    createButton("踏空", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
    end)
    
    createButton("无限跳", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))()
    end)
    
    createButton("移动速度", function()
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(0.9, 0, 0, 32)
        textbox.Position = UDim2.new(0.05, 0, 0, 0)
        textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        textbox.BackgroundTransparency = 0.85
        textbox.Text = "输入速度值"
        textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 13
        textbox.Parent = buttonContainer
        local textCorner = Instance.new("UICorner")
        textCorner.CornerRadius = UDim.new(0, 16)
        textCorner.Parent = textbox
        textbox.FocusLost:Connect(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(textbox.Text) or 16
        end)
    end)
    
    createButton("跳跃高度", function()
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(0.9, 0, 0, 32)
        textbox.Position = UDim2.new(0.05, 0, 0, 0)
        textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        textbox.BackgroundTransparency = 0.85
        textbox.Text = "输入跳跃高度"
        textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 13
        textbox.Parent = buttonContainer
        local textCorner = Instance.new("UICorner")
        textCorner.CornerRadius = UDim.new(0, 16)
        textCorner.Parent = textbox
        textbox.FocusLost:Connect(function()
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber(textbox.Text) or 50
        end)
    end)
    
    createButton("重力设置", function()
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(0.9, 0, 0, 32)
        textbox.Position = UDim2.new(0.05, 0, 0, 0)
        textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        textbox.BackgroundTransparency = 0.85
        textbox.Text = "输入重力值"
        textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 13
        textbox.Parent = buttonContainer
        local textCorner = Instance.new("UICorner")
        textCorner.CornerRadius = UDim.new(0, 16)
        textCorner.Parent = textbox
        textbox.FocusLost:Connect(function()
            game.Workspace.Gravity = tonumber(textbox.Text) or 196.2
        end)
    end)
    
    createButton("飞行", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/U27yQRxS"))()
    end)
    
    createButton("透视", function()
        local FillColor = Color3.fromRGB(175,25,255)
        local DepthMode = "AlwaysOnTop"
        local FillTransparency = 0.5
        local OutlineColor = Color3.fromRGB(255,255,255)
        local OutlineTransparency = 0
        local CoreGui = game:FindService("CoreGui")
        local Players = game:FindService("Players")
        local lp = Players.LocalPlayer
        local connections = {}
        local Storage = Instance.new("Folder")
        Storage.Parent = CoreGui
        Storage.Name = "Highlight_Storage"
        local function Highlight(plr)
            local Highlight = Instance.new("Highlight")
            Highlight.Name = plr.Name
            Highlight.FillColor = FillColor
            Highlight.DepthMode = DepthMode
            Highlight.FillTransparency = FillTransparency
            Highlight.OutlineColor = OutlineColor
            Highlight.OutlineTransparency = 0
            Highlight.Parent = Storage
            local plrchar = plr.Character
            if plrchar then
                Highlight.Adornee = plrchar
            end
            connections[plr] = plr.CharacterAdded:Connect(function(char)
                Highlight.Adornee = char
            end)
        end
        Players.PlayerAdded:Connect(Highlight)
        for i,v in next, Players:GetPlayers() do
            Highlight(v)
        end
        Players.PlayerRemoving:Connect(function(plr)
            local plrname = plr.Name
            if Storage[plrname] then
                Storage[plrname]:Destroy()
            end
            if connections[plr] then
                connections[plr]:Disconnect()
            end
        end)
    end)
    
    createButton("传送玩家", function()
        loadstring(game:HttpGet(("https://pastebin.com/raw/YNVbeqPy")))()
    end)
    
    createButton("fps显示", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/1201for/littlegui/main/FPS-Counter'))()
    end)
    
    createButton("玩家进入提示", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
    end)
    
    createButton("防空警报", function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://792323017"
        sound.Parent = game.Workspace
        sound:Play()
    end)
    
    createButton("义勇军进行曲", function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://1845918434"
        sound.Parent = game.Workspace
        sound:Play()
    end)
    
    createButton("小黑子1", function()
        loadstring(game:HttpGet(('https://gist.githubusercontent.com/blox-hub-roblox/021bad62bbc6a0adc4ba4e625f9ad7df/raw/c89af6e1acf587d09e4ce4bc7510e7100e0c0065/swordWarrior.lua'),true))()
    end)
    
    createButton("小黑子2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ToraIsMe/ToraIsMe/main/0SwordWarriors"))()
    end)
    
    createButton("自然灾害", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/5fKvum70"))()
    end)
    
    createButton("自然灾害2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/2dgeneralspam1/scripts-and-stuff/master/scripts/LoadstringUjHI6RQpz2o8", true))()
    end)
    
    createButton("钓鱼模拟器1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bebedi15/SRM-Scripts/main/Bebedi9960/SRMHub"))()
    end)
    
    createButton("钓鱼模拟器2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/ggghjn/main/%E4%B8%81%E4%B8%81%E9%92%93%E9%B1%BC%E6%A8%A1%E6%8B%9F%E5%99%A8.txt"))()
    end)
    
    createButton("寻宝模拟器1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/gghb/main/%E4%B8%81%E4%B8%81%E5%AF%BB%E5%AE%9D.txt"))()
    end)
    
    createButton("宠物模拟器X", function()
        loadstring(game:HttpGet'https://raw.githubusercontent.com/RunDTM/ZeeroxHub/main/Loader.lua')()
    end)
    
    createButton("蜂群模拟器", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/3A61hnGA", true))()
    end)
    
    createButton("Evade", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Evade/main.lua"))()
    end)
    
    createButton("后室", function()
        loadstring(game:HttpGet('https://pastebin.com/raw/Gsqd40fL'))()
    end)
    
    createButton("Synapse X", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/tWGxhNq0"))()
    end)
    
    createButton("彩虹朋友", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JNHHGaming/Rainbow-Friends/main/Rainbow%20Friends"))()
    end)
    
    createButton("HoHo", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI'))()
    end)
    
    createButton("tds查看兵", function()
        local Towers = game:GetService("Players").LocalPlayer.PlayerGui.Interface.Root.Inventory.View.Frame.Frame.Frame
        for _, v in pairs(Towers:GetDescendants()) do
            if v:IsA("ImageButton") then
                v.Visible = true
            end
        end
    end)
    
    createButton("doors", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoYunCN/EntitySpawner/main/doors(orionlib).lua"))()
    end)
    
    createButton("doors最强脚本", function()
        loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\112\97\115\116\101\98\105\110\46\99\111\109\47\114\97\119\47\54\53\84\119\84\56\106\97"))()
    end)
    
    createButton("doos2", function()
        loadstring(game:HttpGet("https://github.com/DocYogurt/Main/raw/main/Scripts/DF2RW.lua"))()
    end)
    
    createButton("门2.0", function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\89\83\108\111\110\47\82\65\87\45\46\46\97\45\115\99\114\105\112\116\47\109\97\105\110\47\37\69\57\37\57\57\37\56\56\68\79\79\82\83\50\46\48\77\79\79\78\37\69\54\37\66\55\37\66\55\37\69\54\37\66\55\37\56\54\34\41\41\40\41")()
    end)
    
    createButton("变怪", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ChronoAccelerator/Public-Scripts/main/Morphing/MorphScript.lua"))()
    end)
    
    createButton("吸铁石", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/xHxGDp51"))()
    end)
    
    createButton("神圣炸弹", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/u5B1UjGv"))()
    end)
    
    createButton("剪刀", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNeRD0/Doors-Hack/main/shears_done.lua"))()
    end)
    
    createButton("十字架", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/FCSyG6Th"))()
    end)
    
    createButton("破坏模拟器1", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/AquaModz/DestructionSIMModded/main/DestructionSimAqua.lua'))()
    end)
    
    createButton("最强战场1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LOLking123456/Strongest/main/Battlegrounds77"))()
    end)
    
    createButton("点击复制秘钥", function()
        setclipboard("BestTheStrongest5412Roblox")
    end)
    
    createButton("最强战场2", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/The-Strongest-Battlegrounds-saitama-to-gojo-MOBILE-SUPPORT-18533"))()
    end)
    
    createButton("KJ脚本", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Tariviste/Gojo/main/Source"))()
    end)
    
    createButton("点击复制秘钥", function()
        setclipboard("YieldingLeaks_3FuV7ie9k2rTJs4")
    end)
    
    createButton("骨折VI", function()
        loadstring(game:HttpGet('https://pastebin.com/raw/5rEAVmcC'))()
    end)
    
    createButton("皮脚本", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/Pi-script-Hebeitangxian.lua"))()
    end)
    
    createButton("自动杀鲨鱼", function()
        local CoreGui = game:GetService("StarterGui")
        CoreGui:SetCore("SendNotification", {
            Title = "fatcathub",
            Text = "（自动已开启）",
            Duration = 3,
        })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Sw1ndlerScripts/RobloxScripts/main/Misc%20Scripts/sharkbite2.lua",true))()
    end)
    
    createButton("内脏与黑火药", function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\34\104\116\116\112\115\58\47\47\102\114\101\101\110\111\116\101\46\98\105\122\47\114\97\119\47\109\117\122\110\104\101\114\104\114\117\34\41\44\116\114\117\101\41\41\40\41\10")()
    end)
    
    createButton("极速传奇1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TtmScripter/Legend-of-Speed-Auto-/main/GetPet"))()
    end)
    
    createButton("极速传奇2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/renlua/Roblox/main/%E6%9E%81%E9%80%9F%E4%BC%A0%E5%A5%87.lua"))()
    end)
    
    createButton("战斗勇士1", function()
        loadstring(game:HttpGet("https://paste.gg/p/anonymous/697fc3cad5f743508318cb7399e89432/files/b5923e52edab4e5c91e46b74563d0ae8/raw"))()
    end)
    
    createButton("杀手与警长秒杀", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Deni210/murdersvssherrifsduels/main/rubyhub", true))()
    end)
    
    createButton("请先加入Na1Xi群组", function()
        loadstring(game:GetObjects("rbxassetid://10040701935")[1].Source)()
    end)
    
    createButton("一路向西2", function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/Drifter0507/scripts/main/westbound"),true))()
    end)
    
    createButton("汽车经销商大亨会覆盖", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/IExpIoit/Script/main/Car%20Dealership%20Tycoon.lua"))()
    end)
    
    createButton("汽车经销商大亨2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/03sAlt/BlueLockSeason2/main/README.md"))()
    end)
    
    createButton("兵工厂1", function()
        loadstring(game:HttpGet("https://pastefy.app/2YdrWHxV/raw"))()
    end)
    
    createButton("伐木大亨1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoYunCN/Kavo-Ui/main/%E4%BC%90%E6%9C%A8%E5%A4%A7%E4%BA%A82.lua", true))()
    end)
    
    createButton("伐木大亨2会覆盖", function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/NOOBARMYSCRIPTER/NOOBARMYSCRIPTER/main/AXE%20LOOP%20SCRIPT"), true))()
    end)
    
    createButton("造船寻宝1", function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/urmomjklol69/GoldFarmBabft/main/GoldFarm.lua'),true))()
    end)
    
    createButton("造船寻宝2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/novakoolhub/Scripts/main/Scripts/NovBoat.lua"))()
    end)
    
    createButton("忍者传奇1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TtmScripter/-/main/AutoGetIDK(NinjaLegend)"))()
    end)
    
    createButton("忍者传奇2", function()
        loadstring(rawget(game:GetObjects("rbxassetid://3623753581"), 1).Source)("Pepsi Byte")loadstring(game:HttpGet("https://raw.githubusercontent.com/LOOF-sys/Roblox-Shit/main/SharkBite.lua",true))()
    end)
    
    createButton("俄亥俄州1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/nb/main/jm1051.lua"))()
    end)
    
    createButton("指令脚本", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/longshulol/long/main/longshu/Ohio"))()
    end)
    
    createButton("巴掌大战1", function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/ionlyusegithubformcmods/1-Line-Scripts/main/Slap%20Battles")))()
    end)
    
    createButton("巴掌模拟器作者龙叔", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/longshulol/long/main/longshu/bazhang"))()
    end)
    
    createButton("指令脚本", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/longshulol/long/main/longshu/bazhang"))()
    end)
    
    createButton("忍者传奇1", function()
        pcall(loadstring(game:HttpGet("https://pastebin.com/raw/2UjrXwTV")))
    end)
    
    createButton("餐厅大亨1", function()
        loadstring(game:HttpGet("https://pastefy.app/Ppqt0Gib/raw"))()
    end)
    
    createButton("监狱人生1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Denverrz/scripts/master/PRISONWARE_v1.3.txt"))()
    end)
    
    createButton("举重模拟器1", function()
        loadstring(game:HttpGet"https://raw.githubusercontent.com/thedragonslayer2/Key-System/main/Load.lua")()
    end)
    
    createButton("超级足球联赛1", function()
        loadstring(game:HttpGet"https://raw.githubusercontent.com/xtrey10x/xtrey10x-hub/main/neo")()
    end)
    
    createButton("法宝模拟器会覆盖", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeRobloxScripts/anime-fighting/main/simulator"))()
    end)
    
    createButton("法宝模拟器2", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/zhanghuihuihuil/Script/main/%E6%B3%95%E5%AE%9D%E6%A8%A1%E6%8B%9F%E5%99%A8%E6%B1%89%E5%8C%96'))()
    end)
    
    createButton("拳击模拟器1", function()
        loadstring(game:HttpGet("https://pastefy.app/T4O1SA3q/raw"))()
    end)
    
    createButton("拳击模拟器2", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Solx69/Shit-Boy-Hub-Main/main/Master.lua'))()
    end)
    
    createButton("伐木大亨1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/frencaliber/LuaWareLoader.lw/main/luawareloader.wtf",true))()
    end)
    
    createButton("国王遗产1", function()
        loadstring(game:HttpGet"https://raw.githubusercontent.com/xDepressionx/Free-Script/main/KingLegacy.lua")()
    end)
    
    createButton("国王遗产2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hajibeza/RIPPER-HUB/main/King%20Leagacy"))()
    end)
    
    createButton("狂野西部1", function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/KeoneGithub/KeoneGithub/main/WildWestLean"),true))()
    end)
    
    createButton("剑斗士模拟器1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bebedi15/DisticHub/main/Loader.lua"))()
    end)
    
    createButton("克隆大亨1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HELLLO1073/RobloxStuff/main/CT-Destroyer"))()
    end)
    
    createButton("驾驶帝国1", function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/zeuise0002/SSSWWW222/main/README.md'),true))()
    end)
    
    createButton("驾驶帝国2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/main/drivingempire", true))()
    end)
    
    createButton("压力1", function()
        loadstring(game:HttpGet("https://github.com/Drop56796/CreepyEyeHub/blob/main/obfuscate.lua?raw=true"))()
    end)
    
    createButton("压力2", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/iZuasZCc"))()
    end)
    
    createButton("动感星期五1", function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/XMAS-Event-or-Funky-Friday-Auto-Player-Mobile-6721"))()
    end)
    
    createButton("动感星期五2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/funky-friday-autoplay/main/main.lua",true))()
    end)
    
    createButton("动感星期五3", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MariyaFurmanova/Library/main/WarTycoon", true))()
    end)
    
    createButton("超级大力士1", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/hngamingroblox/scripts/main/strongman%20simulator'))()
    end)
    
    createButton("餐厅大亨1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/toosiwhip/snake-hub/main/restaurant-tycoon-2.lua"))()
    end)
    
    createButton("餐厅大亨2", function()
        loadstring(game:HttpGet("https://pastefy.app/Ppqt0Gib/raw"))()
    end)
    
    createButton("旗帜战争1", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Infinity2346/Tect-Menu/main/Flag%20Wars.txt'))()
    end)
    
    createButton("进击的僵尸1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Darkrai-X/main/Games/Zombie%20Attack", true))()
    end)
    
    createButton("短信模拟器1", function()
        loadstring(game:HttpGet(('https://pastebin.com/raw/9hxkxUZ5'),true))()
    end)
    
    createButton("刀刃球1", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/3345-c-a-t-s-u-s/-beta-/main/AutoParry.lua"))()
    end)
    
    createButton("刀刃球2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Neoncat765/Neon.C-Hub-X/main/UnknownVersion"))()
    end)
    
    createButton("破坏者谜团2", function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/Ethanoj1/EclipseMM2/master/Script"),true))()
    end)
    
    createButton("战争大亨1", function()
        loadstring(game:HttpGet'https://raw.githubusercontent.com/Macintosh1983/ChillHubMain/main/ChillHubOilWarfareTycoon.lua')()
    end)
    
    createButton("战争大亨2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nici002018/GNHub/master/GNHub.lua", true))()
    end)
    
    createButton("战争大亨3", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MariyaFurmanova/Library/main/WarTycoon", true))()
    end)
    
    createButton("极速会覆盖", function()
        loadstring(game:HttpGet('\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\98\111\121\115\99\112\47\98\101\116\97\47\109\97\105\110\47\37\69\57\37\56\48\37\57\70\37\69\53\37\66\65\37\65\54\37\69\55\37\56\50\37\66\56\37\69\56\37\66\53\37\66\55\46\108\117\97'))()
    end)
    
    createButton("开启卡宠", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/uR6azdQQ"))()
    end)
    
    createButton("自动", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/AyeCYbT6"))()
    end)
    
    createButton("力量传奇1", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/jynzl/main/main/Musclas%20Legenos.lua'))()
    end)
    
    createButton("力量传奇2", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/BoaHacker/ROBLOX/main/cheat', true))()
    end)
    
    createButton("力量传奇3", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/li/main/%E4%B8%81%E4%B8%81%E5%8A%9B%E9%87%8F.lua"))()
    end)
    
    createButton("力量传奇传送", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/li/main/%E4%B8%81%E4%B8%81%E5%8A%9B%E9%87%8F.lua"))()
    end)
    
    createButton("云脚本", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoYunCN/6666666666/main/%E4%BA%91%E8%84%9A%E6%9C%AC%E6%B5%8B%E8%AF%95%E7%89%88%E4%BA%91%E8%84%9A%E6%9C%AC%E6%B5%8B%E8%AF%95%E7%89%88Xiao%20Yun.lua"))()
    end)
    
    createButton("禁漫中心", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/anlushanjinchangantangwanle/main/jmjmjmjmjmjmjmjmjmjmjmjmjmjmjmjm.lua"))()
    end)
    
    createButton("皮脚本", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua"))()
    end)
    
    createButton("神光脚本", function()
        loadstring(game:HttpGet(utf8.char((function() return table.unpack({104,116,116,112,115,58,47,47,112,97,115,116,101,98,105,110,46,99,111,109,47,114,97,119,47,56,102,50,76,99,113,113,80})end)())))()
    end)
    
    createButton("青脚本", function()
        loadstring(game:HttpGet('https://rentry.co/ct293/raw'))()
    end)
    
    createButton("XK脚本中心", function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\66\73\78\106\105\97\111\98\122\120\54\47\66\73\78\106\105\97\111\47\109\97\105\110\47\88\75\46\84\88\84\34\41\41\40\41\10")()
    end)
    
    createButton("USA脚本卡密:USA AER", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/beta/main/USA.lua"))()
    end)
    
    createButton("脚本中心", function()
        loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\112\97\115\116\101\98\105\110\46\99\111\109\47\114\97\119\47\103\101\109\120\72\119\65\49"))()
    end)
    
    updateCanvas()
end

uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
addButtons()
updateCanvas()

local menuOpen = false

floatingBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    menuFrame.Visible = menuOpen
    if menuOpen then
        TweenService:Create(menuFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
    end
end)

local dragging = false
local dragStart = nil
local btnStartPos = nil

floatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        btnStartPos = floatingBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newX = btnStartPos.X.Scale + (delta.X / screenGui.AbsoluteSize.X)
        local newY = btnStartPos.Y.Scale + (delta.Y / screenGui.AbsoluteSize.Y)
        newX = math.clamp(newX, 0, 0.9)
        newY = math.clamp(newY, 0, 0.85)
        floatingBtn.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

local CoreGui = game:GetService("StarterGui")
CoreGui:SetCore("SendNotification", {
    Title = "fatcathub",
    Text = "耐心等待（反挂机已开启）",
    Duration = 5,
})
print("反挂机开启")
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)