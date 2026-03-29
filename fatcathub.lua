local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
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

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FatCatUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

local floatingBtn = Instance.new("ImageButton")
floatingBtn.Size = UDim2.new(0, 48, 0, 48)
floatingBtn.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
floatingBtn.BackgroundTransparency = 0
floatingBtn.Image = "rbxassetid://3926305904"
floatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.ScaleType = Enum.ScaleType.Fit
floatingBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 220, 0, 320)
menuFrame.Position = UDim2.new(0, 0, 0, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menuFrame.BackgroundTransparency = 0.15
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = floatingBtn

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 16)
menuCorner.Parent = menuFrame

local blur = Instance.new("BlurEffect")
blur.Size = 8
blur.Parent = menuFrame

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 44)
menuTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.BackgroundTransparency = 0.2
menuTitle.Text = "功能列表"
menuTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
menuTitle.Font = Enum.Font.GothamSemibold
menuTitle.TextSize = 18
menuTitle.BorderSizePixel = 0
menuTitle.Parent = menuFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = menuTitle

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -44)
scrollingFrame.Position = UDim2.new(0, 0, 0, 44)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
scrollingFrame.Parent = menuFrame

local uiList = Instance.new("UIListLayout")
uiList.Parent = scrollingFrame
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 8)

local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 48)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.25
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 15
    btn.BorderSizePixel = 0
    btn.Parent = scrollingFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

local flyBtn = createButton("飞行", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))()
end)

local noclipBtn = createButton("穿墙", function()
    Config.NoclipEnabled = not Config.NoclipEnabled
    if Config.NoclipEnabled then
        noclipBtn.Text = "穿墙 (ON)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        noclipBtn.BackgroundTransparency = 0.2
        startNoclip()
    else
        noclipBtn.Text = "穿墙 (OFF)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        noclipBtn.BackgroundTransparency = 0.25
        stopNoclip()
    end
end)

local flingBtn = createButton("甩飞所有人", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
end)

local quickBtn = createButton("快速互动", function()
    game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        prompt.HoldDuration = 0
    end)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "快速互动",
            Text = "已开启",
            Duration = 2
        })
    end)
end)

local function updateCanvas()
    local count = #scrollingFrame:GetChildren() - 1
    local height = count * 56 + 16
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, height)
end

uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
task.wait(0.1)
updateCanvas()

local dragging = false
local dragStartPos = nil
local dragStartMousePos = nil

floatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = floatingBtn.Position
        dragStartMousePos = input.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartMousePos
        local newX = dragStartPos.X.Scale + (delta.X / screenGui.AbsoluteSize.X)
        local newY = dragStartPos.Y.Scale + (delta.Y / screenGui.AbsoluteSize.Y)
        newX = math.clamp(newX, 0, 0.9)
        newY = math.clamp(newY, 0, 0.85)
        floatingBtn.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

local menuOpen = false

floatingBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    menuFrame.Visible = menuOpen
    if menuOpen then
        menuFrame.Position = UDim2.new(0, -230, 0, 0)
        TweenService:Create(menuFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, -10, 0, 0)}):Play()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if Config.NoclipEnabled then
        Config.NoclipEnabled = false
        noclipBtn.Text = "穿墙 (OFF)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        noclipBtn.BackgroundTransparency = 0.25
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "脚本加载成功",
    Text = "欢迎使用fatcathub",
    Duration = 5
})

print("脚本已加载")