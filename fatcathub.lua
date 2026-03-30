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

task.spawn(function()
    local colors = {
        Color3.fromRGB(100, 150, 255),
        Color3.fromRGB(255, 100, 150),
        Color3.fromRGB(255, 200, 100),
        Color3.fromRGB(100, 255, 150),
    }
    local index = 1
    while true do
        local targetColor = colors[index]
        btnStroke.Color = targetColor
        index = index % 4 + 1
        task.wait(0.3)
    end
end)

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 200, 0, 240)
menuFrame.Position = UDim2.new(0.5, -100, 0.5, -120)
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

task.spawn(function()
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
menuTitle.Text = "胖猫hub"
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
uiList.Padding = UDim.new(0, 8)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 38)
    btn.Position = UDim2.new(0.075, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.85
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = buttonContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 20)
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

local flyBtn = createButton("飞行", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pangmao114514/fatcathub/main/flysp.lua"))()
end)

local noclipEnabled = false
local noclipConn = nil
local noclipBtn = createButton("穿墙", function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipBtn.Text = "穿墙 (开)"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        noclipBtn.BackgroundTransparency = 0.7
        noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "穿墙"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        noclipBtn.BackgroundTransparency = 0.85
        if noclipConn then noclipConn:Disconnect() end
    end
end)

local flingBtn = createButton("甩飞所有人", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
end)

local quickBtn = createButton("快速互动", function()
    game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
        prompt.HoldDuration = 0
    end)
end)

local function updateCanvas()
    local count = 0
    for _, child in pairs(buttonContainer:GetChildren()) do
        if child:IsA("TextButton") then
            count = count + 1
        end
    end
    buttonContainer.CanvasSize = UDim2.new(0, 0, 0, count * 46 + 16)
end

uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
task.wait(0.1)
updateCanvas()

local menuOpen = false
floatingBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    menuFrame.Visible = menuOpen
end)

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    local newX = startPos.X.Scale + (delta.X / screenGui.AbsoluteSize.X)
    local newY = startPos.Y.Scale + (delta.Y / screenGui.AbsoluteSize.Y)
    floatingBtn.Position = UDim2.new(math.clamp(newX, 0, 0.95), 0, math.clamp(newY, 0, 0.95), 0)
end

floatingBtn.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        dragStart = input.Position
        startPos = floatingBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

floatingBtn.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if not noclipEnabled then
        noclipBtn.Text = "穿墙"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        noclipBtn.BackgroundTransparency = 0.85
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "脚本加载成功",
    Text = "欢迎使用胖猫hub",
    Duration = 5
})

print("脚本已加载")
