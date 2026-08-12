local Players, Run, Tween, UIS = game:GetService("Players"), game:GetService("RunService"), game:GetService("TweenService"), game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local lp, cam, pgui = Players.LocalPlayer, workspace.CurrentCamera, Players.LocalPlayer:WaitForChild("PlayerGui")
local isFlying, flySpeed, bv, bg, flyThread = false, 35, nil, nil, nil

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" then
        local selfStr = tostring(self)
        if selfStr:find("AntiCheat") or selfStr:find("Detection") or selfStr:find("Ban") or selfStr:find("Kick") or selfStr:find("Log") or selfStr:find("Report") then
            return nil
        end
        if selfStr:find("ForceSelfDamage") then return nil end
        if type(args[1]) == "string" then
            args[1] = args[1] .. string.char(0x200b)
            return oldNamecall(self, args[1], unpack(args, 2))
        end
    end
    if method == "Kick" or method == "Ban" then return nil end
    return oldNamecall(self, ...)
end)

local oldGetGC = getgc
hookfunction(getgc, newcclosure(function(f)
    local out = {}
    for _, obj in ipairs(oldGetGC(f)) do
        if not (type(obj) == "function" and not isexecutorclosure(obj)) then
            table.insert(out, obj)
        end
    end
    return out
end))

local oldWrap = coroutine.wrap
hookfunction(coroutine.wrap, newcclosure(function(f)
    return function(...) return task.spawn(f, ...) end
end))

setreadonly(mt, true)

if pgui:FindFirstChild("QR_V15") then pgui.QR_V15:Destroy() end

local function create(cls, props, parent)
    local obj = Instance.new(cls)
    for k, v in pairs(props) do obj[k] = v end
    if parent then obj.Parent = parent end
    if cls:find("Text") or cls == "Frame" then
        local corner = Instance.new("UICorner", obj)
        corner.CornerRadius = UDim.new(0, 8)
    end
    return obj
end

local sg = create("ScreenGui", {Name = "QR_V15", ResetOnSpawn = false}, pgui)
local main = create("Frame", {
    Size = UDim2.new(0, 240, 0, 200),
    Position = UDim2.new(0.5, -120, 0.4, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 25),
    BackgroundTransparency = 0.05,
    ClipsDescendants = true
}, sg)

local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))})
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(100, 150, 255)
stroke.Thickness = 2
stroke.Transparency = 0.5

local title = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 40),
    Text = "飞行脚本",
    TextColor3 = Color3.fromRGB(200, 220, 255),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    TextSize = 20
}, main)

local inp = create("TextBox", {
    Size = UDim2.new(0, 100, 0, 35),
    Position = UDim2.new(0, 20, 0, 50),
    Text = "35",
    BackgroundColor3 = Color3.fromRGB(35, 35, 50),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 18,
    PlaceholderText = "速度"
}, main)
Instance.new("UICorner", inp).CornerRadius = UDim.new(0, 6)

local speedSlider = create("Frame", {
    Size = UDim2.new(0, 80, 0, 6),
    Position = UDim2.new(0, 130, 0, 64),
    BackgroundColor3 = Color3.fromRGB(60, 60, 80)
}, main)
Instance.new("UICorner", speedSlider).CornerRadius = UDim.new(1, 0)
local fill = create("Frame", {
    Size = UDim2.new(0.5, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(100, 180, 255)
}, speedSlider)
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

local btn = create("TextButton", {
    Size = UDim2.new(0, 200, 0, 45),
    Position = UDim2.new(0, 20, 0, 95),
    Text = "启动飞行",
    BackgroundColor3 = Color3.fromRGB(40, 40, 70),
    TextColor3 = Color3.fromRGB(220, 220, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18
}, main)
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

local statusText = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 0, 150),
    Text = "空闲",
    TextColor3 = Color3.fromRGB(150, 150, 180),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 14
}, main)

local dragStart, dragPos
main.InputBegan:Connect(function(i)
    if i.UserInputType.Name:find("Button1") or i.UserInputType.Name == "Touch" then
        dragStart = i.Position
        dragPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if (i.UserInputType.Name == "MouseMovement" or i.UserInputType.Name == "Touch") and dragStart then
        local delta = i.Position - dragStart
        main.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset + delta.X, dragPos.Y.Scale, dragPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType.Name:find("Button1") or i.UserInputType.Name == "Touch" then dragStart = nil end
end)

local function updateSlider(val)
    val = math.clamp(val, 1, 120)
    fill.Size = UDim2.new(val/120, 0, 1, 0)
    inp.Text = tostring(math.floor(val))
    flySpeed = val
end

inp.FocusLost:Connect(function()
    local v = tonumber(inp.Text)
    if v then updateSlider(v) else inp.Text = tostring(flySpeed) end
end)

local sliderDrag
speedSlider.InputBegan:Connect(function(i)
    if i.UserInputType.Name:find("Button1") or i.UserInputType.Name == "Touch" then sliderDrag = true end
end)
UIS.InputChanged:Connect(function(i)
    if sliderDrag and (i.UserInputType.Name == "MouseMovement" or i.UserInputType.Name == "Touch") then
        local rel = i.Position.X - speedSlider.AbsolutePosition.X
        local w = speedSlider.AbsoluteSize.X
        updateSlider((rel/w)*120)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType.Name:find("Button1") or i.UserInputType.Name == "Touch" then sliderDrag = nil end
end)

local function stopFlying()
    isFlying = false
    if flyThread then coroutine.close(flyThread) flyThread = nil end
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    local char = lp.Character
    if char then
        local anim = char:FindFirstChild("Animate")
        if anim then anim.Parent = char end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
    btn.Text = "启动飞行"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    statusText.Text = "已停用"
end

btn.MouseButton1Click:Connect(function()
    if isFlying then stopFlying() return end
    flySpeed = tonumber(inp.Text) or 35
    flySpeed = math.clamp(flySpeed, 1, 120)
    updateSlider(flySpeed)
    isFlying = true
    btn.Text = "飞行中"
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    statusText.Text = "飞行脚本 · "..flySpeed.." 速"
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    local anim = char:FindFirstChild("Animate")
    if anim then anim.Parent = nil end
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Parent = hrp
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.P = 8000
    bg.Parent = hrp
    if flyThread then coroutine.close(flyThread) flyThread = nil end
    flyThread = coroutine.create(function()
        local ctrl
        while isFlying and char and char.Parent do
            if not ctrl or not ctrl.GetMoveVector then
                pcall(function() ctrl = require(lp.PlayerScripts:WaitForChild("PlayerModule")):GetControls() end)
            end
            if ctrl and ctrl.GetMoveVector then
                local mv = ctrl:GetMoveVector()
                local dir = (cam.CFrame.LookVector * -mv.Z) + (cam.CFrame.RightVector * mv.X)
                if bv and bg then
                    if mv.Magnitude > 0 then
                        bv.Velocity = dir.Unit * flySpeed
                        bg.CFrame = CFrame.new(Vector3.zero, dir)
                    else
                        bv.Velocity = Vector3.new(0, 0.1, 0)
                        bg.CFrame = CFrame.new(Vector3.zero, cam.CFrame.LookVector * Vector3.new(1,0,1))
                    end
                end
                if hum then hum:ChangeState(Enum.HumanoidStateType.Climbing) end
            end
            Run.RenderStepped:Wait()
        end
        if isFlying then stopFlying() end
    end)
    coroutine.resume(flyThread)
end)

local function topBtn(t, x, c, f)
    local b = create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, x, 0, 6),
        Text = t,
        BackgroundColor3 = c,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 16
    }, main)
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(f)
end

topBtn("×", -36, Color3.fromRGB(150, 50, 50), function()
    stopFlying()
    sg:Destroy()
end)
topBtn("−", -68, Color3.fromRGB(60, 60, 80), function()
    local collapsed = main.Size.Y.Offset < 140
    Tween:Create(main, TweenInfo.new(0.3), {Size = UDim2.new(0, 240, 0, collapsed and 200 or 45)}):Play()
    btn.Visible = collapsed
    inp.Visible = collapsed
    speedSlider.Visible = collapsed
    statusText.Visible = collapsed
end)

main.Size = UDim2.new(0, 0, 0, 0)
main:TweenSize(UDim2.new(0, 240, 0, 200), "Out", "Back", 0.6)

game:GetService("RunService").Stepped:Connect(function()
    if isFlying then
        local char = lp.Character
        if not char or not char.Parent then stopFlying() end
    end
end)