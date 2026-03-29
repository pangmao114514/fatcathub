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
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local floatingBtn = Instance.new("ImageButton")
floatingBtn.Size = UDim2.new(0, 55, 0, 55)
floatingBtn.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.BackgroundTransparency = 0.9
floatingBtn.Image = "rbxassetid://3926305904"
floatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.ScaleType = Enum.ScaleType.Fit
floatingBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

local floatingGlow = Instance.new("UIGradient")
floatingGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255))
})
floatingGlow.Rotation = 0
floatingGlow.Parent = floatingBtn

spawn(function()
    while true do
        for i = 0, 360, 2 do
            floatingGlow.Rotation = i
            task.wait(0.02)
        end
    end
end)

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 280, 0, 320)
menuFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
menuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menuFrame.BackgroundTransparency = 0.85
menuFrame.BorderSizePixel = 2
menuFrame.Visible = false
menuFrame.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 20)
menuCorner.Parent = menuFrame

local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 100, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 100)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(100, 255, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255))
})
borderGradient.Rotation = 0
borderGradient.Parent = menuFrame

spawn(function()
    while true do
        for i = 0, 360, 1 do
            borderGradient.Rotation = i
            task.wait(0.015)
        end
    end
end)

local blur = Instance.new("BlurEffect")
blur.Size = 10
blur.Parent = menuFrame

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 55)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "功 能 列 表"
menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.Font = Enum.Font.GothamSemibold
menuTitle.TextSize = 22
menuTitle.TextScaled = true
menuTitle.BorderSizePixel = 0
menuTitle.Parent = menuFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -55)
scrollingFrame.Position = UDim2.new(0, 0, 0, 55)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
scrollingFrame.Parent = menuFrame

local uiList = Instance.new("UIListLayout")
uiList.Parent = scrollingFrame
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 15)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.7, 0, 0, 50)
    btn.Position = UDim2.new(0.15, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.85
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 18
    btn.TextScaled = true
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = scrollingFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 25)
    btnCorner.Parent = btn
    
    local btnGlow = Instance.new("UIGradient")
    btnGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
    })
    btnGlow.Rotation = 45
    btnGlow.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        callback()
        local orgColor = btn.BackgroundColor3
        btn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        task.wait(0.1)
        btn.BackgroundColor3 = orgColor
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
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
    end)
    
    return btn
end

local flyBtn = createButton("飞 行", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))()
end)

local noclipBtn = createButton("穿 墙", function()
    Config.NoclipEnabled = not Config.NoclipEnabled
    if Config.NoclipEnabled then
        noclipBtn.Text = "穿 墙 (开)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        noclipBtn.BackgroundTransparency = 0.7
        startNoclip()
    else
        noclipBtn.Text = "穿 墙 (关)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        noclipBtn.BackgroundTransparency = 0.85
        stopNoclip()
    end
end)

local flingBtn = createButton("甩 飞 所 有 人", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
end)

local quickBtn = createButton("快 速 互 动", function()
    game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        prompt.HoldDuration = 0
    end)
end)

local function updateCanvas()
    local children = scrollingFrame:GetChildren()
    local count = 0
    for _, child in pairs(children) do
        if child:IsA("TextButton") then
            count = count + 1
        end
    end
    local height = count * 65 + 20
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, height)
end

uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
task.wait(0.1)
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

LocalPlayer.CharacterAdded:Connect(function()
    if Config.NoclipEnabled then
        Config.NoclipEnabled = false
        noclipBtn.Text = "穿 墙 (关)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        noclipBtn.BackgroundTransparency = 0.85
        stopNoclip()
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "脚本加载成功",
    Text = "欢迎使用fatcathub",
    Duration = 5
})

print("脚本已加载")