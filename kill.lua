local player = game.Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillAuraMain"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 320)
frame.Position = UDim2.new(0.5, -125, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.Position = UDim2.new(0, 0, 0, 0)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316044577"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(8, 8, 8, 8)
shadow.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 5)
title.Text = "⚡ 杀戮光环控制台"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 25)
statusText.Position = UDim2.new(0, 0, 0, 45)
statusText.Text = "状态: ✅ 已加载"
statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 14
statusText.Parent = frame

local btnAura = Instance.new("TextButton")
btnAura.Size = UDim2.new(0, 220, 0, 40)
btnAura.Position = UDim2.new(0.5, -110, 0, 80)
btnAura.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
btnAura.Text = "🔴 杀戮光环: 关闭"
btnAura.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAura.Font = Enum.Font.GothamBold
btnAura.TextSize = 16
btnAura.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btnAura

local btnHook = Instance.new("TextButton")
btnHook.Size = UDim2.new(0, 220, 0, 40)
btnHook.Position = UDim2.new(0.5, -110, 0, 130)
btnHook.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
btnHook.Text = "✅ Hook修改: 开启"
btnHook.TextColor3 = Color3.fromRGB(255, 255, 255)
btnHook.Font = Enum.Font.GothamBold
btnHook.TextSize = 16
btnHook.Parent = frame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 8)
btnCorner2.Parent = btnHook

local btnRange = Instance.new("TextButton")
btnRange.Size = UDim2.new(0, 100, 0, 35)
btnRange.Position = UDim2.new(0.5, -110, 0, 180)
btnRange.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btnRange.Text = "🔽 范围-"
btnRange.TextColor3 = Color3.fromRGB(255, 255, 255)
btnRange.Font = Enum.Font.GothamBold
btnRange.TextSize = 14
btnRange.Parent = frame

local btnCorner3 = Instance.new("UICorner")
btnCorner3.CornerRadius = UDim.new(0, 8)
btnCorner3.Parent = btnRange

local rangeDisplay = Instance.new("TextLabel")
rangeDisplay.Size = UDim2.new(0, 60, 0, 35)
rangeDisplay.Position = UDim2.new(0.5, -30, 0, 180)
rangeDisplay.Text = "500"
rangeDisplay.TextColor3 = Color3.fromRGB(255, 255, 100)
rangeDisplay.BackgroundTransparency = 1
rangeDisplay.Font = Enum.Font.GothamBold
rangeDisplay.TextSize = 18
rangeDisplay.Parent = frame

local btnRangeUp = Instance.new("TextButton")
btnRangeUp.Size = UDim2.new(0, 100, 0, 35)
btnRangeUp.Position = UDim2.new(0.5, 10, 0, 180)
btnRangeUp.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btnRangeUp.Text = "🔽 范围+"
btnRangeUp.TextColor3 = Color3.fromRGB(255, 255, 255)
btnRangeUp.Font = Enum.Font.GothamBold
btnRangeUp.TextSize = 14
btnRangeUp.Parent = frame

local btnCorner4 = Instance.new("UICorner")
btnCorner4.CornerRadius = UDim.new(0, 8)
btnCorner4.Parent = btnRangeUp

local btnDamage = Instance.new("TextButton")
btnDamage.Size = UDim2.new(0, 100, 0, 35)
btnDamage.Position = UDim2.new(0.5, -110, 0, 225)
btnDamage.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btnDamage.Text = "💔 伤害-"
btnDamage.TextColor3 = Color3.fromRGB(255, 255, 255)
btnDamage.Font = Enum.Font.GothamBold
btnDamage.TextSize = 14
btnDamage.Parent = frame

local btnCorner5 = Instance.new("UICorner")
btnCorner5.CornerRadius = UDim.new(0, 8)
btnCorner5.Parent = btnDamage

local damageDisplay = Instance.new("TextLabel")
damageDisplay.Size = UDim2.new(0, 60, 0, 35)
damageDisplay.Position = UDim2.new(0.5, -30, 0, 225)
damageDisplay.Text = "500"
damageDisplay.TextColor3 = Color3.fromRGB(255, 100, 100)
damageDisplay.BackgroundTransparency = 1
damageDisplay.Font = Enum.Font.GothamBold
damageDisplay.TextSize = 18
damageDisplay.Parent = frame

local btnDamageUp = Instance.new("TextButton")
btnDamageUp.Size = UDim2.new(0, 100, 0, 35)
btnDamageUp.Position = UDim2.new(0.5, 10, 0, 225)
btnDamageUp.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btnDamageUp.Text = "💔 伤害+"
btnDamageUp.TextColor3 = Color3.fromRGB(255, 255, 255)
btnDamageUp.Font = Enum.Font.GothamBold
btnDamageUp.TextSize = 14
btnDamageUp.Parent = frame

local btnCorner6 = Instance.new("UICorner")
btnCorner6.CornerRadius = UDim.new(0, 8)
btnCorner6.Parent = btnDamageUp

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 270)
statusLabel.Text = "📌 按 G 切换 | 拖拽移动"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = frame

local drag = {dragging = false, start = nil, offset = nil}
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag.dragging = true
        drag.start = input.Position
        drag.offset = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag.dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if drag.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - drag.start
        frame.Position = UDim2.new(drag.offset.X.Scale, drag.offset.X.Offset + delta.X, drag.offset.Y.Scale, drag.offset.Y.Offset + delta.Y)
    end
end)

local auraEnabled = false
local hookEnabled = true
local currentRange = 500
local currentDamage = 500
local auraConnection = nil
local hookActive = false

local function getWeapon()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Tool")
end

local function clearHooks()
    if auraConnection then
        auraConnection:Disconnect()
        auraConnection = nil
    end
end

local function hookAllRemotes()
    if not hookEnabled then 
        hookActive = false
        return 
    end
    
    hookActive = true
    for _, remote in pairs(game.ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local oldFire = remote.FireServer
            remote.FireServer = function(self, ...)
                if not hookEnabled then 
                    if oldFire then return oldFire(self, ...) end
                    return
                end
                local args = {...}
                for i, arg in pairs(args) do
                    if type(arg) == "number" and arg > 0 and arg < 200 then
                        args[i] = currentDamage
                    end
                    if type(arg) == "table" then
                        for k, v in pairs(arg) do
                            if type(v) == "number" and v > 0 and v < 200 then
                                arg[k] = currentDamage
                            end
                            if type(k) == "string" and (k:lower() == "damage" or k:lower() == "dmg") then
                                arg[k] = currentDamage
                            end
                            if type(k) == "string" and (k:lower() == "range" or k:lower() == "radius") then
                                arg[k] = currentRange
                            end
                        end
                    end
                end
                if oldFire then 
                    return oldFire(self, table.unpack(args)) 
                end
            end
        end
    end
end

local function startAura()
    clearHooks()
    if not auraEnabled then return end
    
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    
    auraConnection = game:GetService("RunService").Stepped:Connect(function()
        if not auraEnabled then 
            clearHooks()
            return 
        end
        
        local weapon = getWeapon()
        if not weapon then return end
        
        if humanoid.Health <= 0 then return end
        
        local myPos = root.Position
        
        for _, target in pairs(game.Players:GetPlayers()) do
            if target ~= player then
                local tChar = target.Character
                if tChar then
                    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                    local tHumanoid = tChar:FindFirstChild("Humanoid")
                    if tRoot and tHumanoid and tHumanoid.Health > 0 then
                        local dist = (myPos - tRoot.Position).Magnitude
                        if dist <= currentRange then
                            pcall(function()
                                tHumanoid.Health = 0
                            end)
                            
                            local attackRemote = game.ReplicatedStorage:FindFirstChild("AttackRemote")
                            if attackRemote then
                                pcall(function()
                                    attackRemote:FireServer({
                                        target = target,
                                        damage = currentDamage,
                                        range = currentRange,
                                        weapon = weapon.Name,
                                        hitPos = tRoot.Position,
                                        timestamp = tick() + math.random(-50, 50)/1000,
                                        random = math.random()
                                    })
                                end)
                            end
                            
                            for _, remote in pairs(game.ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") then
                                    local name = remote.Name:lower()
                                    if name:match("attack") or name:match("damage") or name:match("hit") then
                                        pcall(function()
                                            remote:FireServer({
                                                target = target,
                                                damage = currentDamage,
                                                range = currentRange,
                                                weapon = weapon.Name
                                            })
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function antiKick()
    local oldKick = player.Kick
    player.Kick = function(self, msg)
        warn("Kick blocked: " .. tostring(msg))
        return false
    end
end

local function main()
    antiKick()
    hookAllRemotes()
    
    btnAura.MouseButton1Click:Connect(function()
        auraEnabled = not auraEnabled
        btnAura.Text = auraEnabled and "🔴 杀戮光环: 开启" or "🔴 杀戮光环: 关闭"
        btnAura.BackgroundColor3 = auraEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        statusText.Text = auraEnabled and "状态: ⚔️ 杀戮中..." or "状态: ✅ 已加载"
        statusText.TextColor3 = auraEnabled and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(100, 255, 100)
        
        if auraEnabled then
            startAura()
        else
            clearHooks()
        end
    end)
    
    btnHook.MouseButton1Click:Connect(function()
        hookEnabled = not hookEnabled
        btnHook.Text = hookEnabled and "✅ Hook修改: 开启" or "❌ Hook修改: 关闭"
        btnHook.BackgroundColor3 = hookEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        if hookEnabled then
            hookAllRemotes()
        end
    end)
    
    btnRange.MouseButton1Click:Connect(function()
        currentRange = math.max(50, currentRange - 50)
        rangeDisplay.Text = tostring(currentRange)
    end)
    
    btnRangeUp.MouseButton1Click:Connect(function()
        currentRange = math.min(2000, currentRange + 50)
        rangeDisplay.Text = tostring(currentRange)
    end)
    
    btnDamage.MouseButton1Click:Connect(function()
        currentDamage = math.max(50, currentDamage - 50)
        damageDisplay.Text = tostring(currentDamage)
    end)
    
    btnDamageUp.MouseButton1Click:Connect(function()
        currentDamage = math.min(9999, currentDamage + 50)
        damageDisplay.Text = tostring(currentDamage)
    end)
    
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.G then
            frame.Visible = not frame.Visible
        end
    end)
    
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if auraEnabled then
            startAura()
        end
    end)
end

pcall(main)

script.Archivable = true
script.Disabled = false

script.AncestryChanged:Connect(function()
    if not script.Parent then
        task.wait(0.1)
        local new = script:Clone()
        new.Parent = player:FindFirstChild("PlayerScripts") or game:GetService("StarterPlayer").StarterPlayerScripts
    end
end)