local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Config = {
    FlyEnabled = false,
    NoclipEnabled = false
}

local noclipConnection = nil

local function startNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        if not Config.NoclipEnabled then return end
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function createUI()
    local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("fatcat脚本")
    
    local GeneralTab = UILibrary:Tab("功能", "18930406865")
    local GeneralSection = GeneralTab:section("功能", true)
    
    GeneralSection:Button("飞行", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))()
    end)
    
    local noclipBtn
    noclipBtn = GeneralSection:Toggle("穿墙", false, function(enabled)
        Config.NoclipEnabled = enabled
        if enabled then
            startNoclip()
        else
            stopNoclip()
        end
    end)
    
    GeneralSection:Button("甩飞所有人", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end)
    
    GeneralSection:Button("快速互动", function()
        game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
            prompt.HoldDuration = 0
        end)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "快速互动",
            Text = "已开启",
            Duration = 2
        })
    end)
end

local function checkAndRetry()
    local success, err = pcall(createUI)
    if not success then
        task.wait(1)
        pcall(createUI)
    end
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "脚本加载成功",
        Text = "欢迎使用fatcathub",
        Duration = 5
    })
end)

checkAndRetry()
print("脚本已加载")