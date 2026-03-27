-- 最简 UI 测试：不用任何外部脚本，直接在游戏里创建一个界面
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
frame.BackgroundTransparency = 0.3

local text = Instance.new("TextLabel")
text.Parent = frame
text.Size = UDim2.new(1, 0, 1, 0)
text.Text = "UI 测试成功！\n如果你能看到这个窗口，说明 UI 可以正常显示"
text.TextColor3 = Color3.fromRGB(255, 255, 255)
text.TextScaled = true
text.BackgroundTransparency = 1