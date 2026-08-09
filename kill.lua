local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local enabled = true
local auraEnabled = true
local hookEnabled = true

local oldKick = player.Kick
player.Kick = function(self, msg)
    if msg and msg:find("exploit") or msg:find("cheat") or msg:find("detect") then
        warn("Kick blocked: " .. msg)
        return false
    end
    return oldKick(self, msg)
end

local oldBan = player.Ban
if oldBan then
    player.Ban = function(self, msg)
        warn("Ban blocked: " .. tostring(msg))
        return false
    end
end

local function getWeapon()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Tool")
end

local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KillAuraGUI"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 120)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "⚡ 杀戮光环"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = frame

    local auraBtn = Instance.new("TextButton")
    auraBtn.Size = UDim2.new(0, 180, 0, 30)
    auraBtn.Position = UDim2.new(0, 10, 0, 30)
    auraBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    auraBtn.Text = "🔄 光环: 开启"
    auraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    auraBtn.Font = Enum.Font.GothamBold
    auraBtn.TextSize = 14
    auraBtn.Parent = frame

    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 5)
    corner2.Parent = auraBtn

    local hookBtn = Instance.new("TextButton")
    hookBtn.Size = UDim2.new(0, 180, 0, 30)
    hookBtn.Position = UDim2.new(0, 10, 0, 65)
    hookBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    hookBtn.Text = "🔧 Hook: 开启"
    hookBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hookBtn.Font = Enum.Font.GothamBold
    hookBtn.TextSize = 14
    hookBtn.Parent = frame

    local corner3 = Instance.new("UICorner")
    corner3.CornerRadius = UDim.new(0, 5)
    corner3.Parent = hookBtn

    auraBtn.MouseButton1Click:Connect(function()
        auraEnabled = not auraEnabled
        auraBtn.Text = auraEnabled and "🔄 光环: 开启" or "🔄 光环: 关闭"
        auraBtn.BackgroundColor3 = auraEnabled and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 100, 100)
    end)

    hookBtn.MouseButton1Click:Connect(function()
        hookEnabled = not hookEnabled
        hookBtn.Text = hookEnabled and "🔧 Hook: 开启" or "🔧 Hook: 关闭"
        hookBtn.BackgroundColor3 = hookEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
        if hookEnabled then
            hookAllRemotes()
        end
    end)

    local keybind = Instance.new("TextButton")
    keybind.Size = UDim2.new(0, 180, 0, 20)
    keybind.Position = UDim2.new(0, 10, 0, 100)
    keybind.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    keybind.Text = "⌨️ 按 G 切换"
    keybind.TextColor3 = Color3.fromRGB(200, 200, 200)
    keybind.BackgroundTransparency = 0.3
    keybind.Font = Enum.Font.Gotham
    keybind.TextSize = 12
    keybind.Parent = frame
    
    local corner4 = Instance.new("UICorner")
    corner4.CornerRadius = UDim.new(0, 5)
    corner4.Parent = keybind

    return {auraBtn, hookBtn}
end

local hookConnections = {}
local remoteHooks = {}
local function clearHooks()
    for _, conn in pairs(hookConnections) do
        pcall(function() conn:Disconnect() end)
    end
    hookConnections = {}
    for _, remote in pairs(remoteHooks) do
        pcall(function() 
            if remote.oldFire then remote.FireServer = remote.oldFire end
            if remote.oldInvoke then remote.InvokeServer = remote.oldInvoke end
        end)
    end
    remoteHooks = {}
end

local function hookAllRemotes()
    if not hookEnabled then return end
    clearHooks()
    
    for _, remote in pairs(game.ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local oldFire = remote.FireServer
            remoteHooks[remote] = {oldFire = oldFire}
            remote.FireServer = function(self, ...)
                if not hookEnabled then 
                    if oldFire then return oldFire(self, ...) end
                    return
                end
                local args = {...}
                local modified = false
                for i, arg in pairs(args) do
                    if type(arg) == "number" and arg > 0 and arg < 200 then
                        args[i] = 500
                        modified = true
                    end
                    if type(arg) == "table" then
                        for k, v in pairs(arg) do
                            if type(v) == "number" and v > 0 and v < 200 then
                                arg[k] = 500
                                modified = true
                            end
                            if type(k) == "string" and (k:lower() == "damage" or k:lower() == "dmg" or k:lower() == "range" or k:lower() == "radius") then
                                arg[k] = 500
                                modified = true
                            end
                        end
                    end
                end
                if oldFire then 
                    return oldFire(self, table.unpack(args)) 
                end
            end
            table.insert(hookConnections, remote)
        end
        if remote:IsA("RemoteFunction") then
            local oldInvoke = remote.InvokeServer
            remoteHooks[remote] = {oldInvoke = oldInvoke}
            remote.InvokeServer = function(self, ...)
                if not hookEnabled then 
                    if oldInvoke then return oldInvoke(self, ...) end
                    return
                end
                local args = {...}
                for i, arg in pairs(args) do
                    if type(arg) == "number" and arg > 0 and arg < 200 then
                        args[i] = 500
                    end
                    if type(arg) == "table" then
                        for k, v in pairs(arg) do
                            if type(v) == "number" and v > 0 and v < 200 then
                                arg[k] = 500
                            end
                            if type(k) == "string" and (k:lower() == "damage" or k:lower() == "dmg") then
                                arg[k] = 500
                            end
                        end
                    end
                end
                if oldInvoke then 
                    return oldInvoke(self, table.unpack(args)) 
                end
            end
            table.insert(hookConnections, remote)
        end
    end
    
    hookWeaponModules()
end

local function hookWeaponModules()
    if not hookEnabled then return end
    for _, module in pairs(game:GetDescendants()) do
        if module:IsA("ModuleScript") then
            local name = module.Name:lower()
            if name:match("weapon") or name:match("attack") or name:match("damage") or name:match("gun") or name:match("sword") then
                local oldRequire = getfenv().require
                if oldRequire then
                    getfenv().require = function(path)
                        local result = oldRequire(path)
                        if type(result) == "table" and result == module then
                            return setmetatable({}, {
                                __index = function(t, k)
                                    if type(k) == "string" and (k:lower() == "damage" or k:lower() == "dmg") then
                                        return 500
                                    end
                                    if type(k) == "string" and (k:lower() == "range" or k:lower() == "radius") then
                                        return 500
                                    end
                                    return rawget(t, k)
                                end,
                                __newindex = function(t, k, v)
                                    if type(k) == "string" and (k:lower() == "damage" or k:lower() == "dmg") then
                                        return
                                    end
                                    if type(k) == "string" and (k:lower() == "range" or k:lower() == "radius") then
                                        return
                                    end
                                    rawset(t, k, v)
                                end
                            })
                        end
                        return result
                    end
                end
            end
        end
    end
end

local auraConnection = nil
local function startAura()
    if auraConnection then 
        auraConnection:Disconnect() 
        auraConnection = nil
    end
    
    if not auraEnabled then return end
    
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    
    local lastAttackTime = 0
    local attackCount = 0
    local resetTime = tick()
    
    auraConnection = game:GetService("RunService").Stepped:Connect(function()
        if not auraEnabled then 
            if auraConnection then
                auraConnection:Disconnect()
                auraConnection = nil
            end
            return 
        end
        
        local currentWeapon = getWeapon()
        if not currentWeapon then return end
        
        if humanoid.Health <= 0 then return end
        
        local myPos = root.Position
        
        if tick() - resetTime > 1 then
            attackCount = 0
            resetTime = tick()
        end
        
        for _, target in pairs(game.Players:GetPlayers()) do
            if target ~= player then
                local tChar = target.Character
                if tChar then
                    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                    local tHumanoid = tChar:FindFirstChild("Humanoid")
                    if tRoot and tHumanoid and tHumanoid.Health > 0 then
                        local dist = (myPos - tRoot.Position).Magnitude
                        if dist <= 500 and attackCount < 10 then
                            attackCount = attackCount + 1
                            
                            pcall(function()
                                tHumanoid.Health = 0
                            end)
                            
                            local attackRemote = game.ReplicatedStorage:FindFirstChild("AttackRemote")
                            if attackRemote then
                                pcall(function()
                                    attackRemote:FireServer({
                                        target = target,
                                        damage = 500,
                                        range = 500,
                                        weapon = currentWeapon.Name,
                                        hitPos = tRoot.Position,
                                        timestamp = tick() + math.random(-50, 50)/1000,
                                        random = math.random(),
                                        mouseX = math.random(-100, 100),
                                        mouseY = math.random(-100, 100)
                                    })
                                end)
                            end
                            
                            local attackRemote2 = game.ReplicatedStorage:FindFirstChild("DamageRemote")
                            if attackRemote2 then
                                pcall(function()
                                    attackRemote2:FireServer({
                                        victim = target,
                                        dmg = 500,
                                        range = 500,
                                        weapon = currentWeapon.Name
                                    })
                                end)
                            end
                            
                            for _, remote in pairs(game.ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") then
                                    local name = remote.Name:lower()
                                    if name:match("attack") or name:match("damage") or name:match("hit") or name:match("kill") then
                                        pcall(function()
                                            remote:FireServer({
                                                target = target,
                                                damage = 500,
                                                range = 500,
                                                weapon = currentWeapon.Name,
                                                random = math.random()
                                            })
                                        end)
                                    end
                                end
                            end
                            
                            lastAttackTime = tick()
                        end
                    end
                end
            end
        end
    end)
end

local function spawnProtection()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health <= 0 then
                    task.wait(0.3)
                    if humanoid.Health <= 0 then
                        pcall(function()
                            local newChar = player.Character
                            if newChar and newChar ~= char then
                                local newHumanoid = newChar:FindFirstChild("Humanoid")
                                if newHumanoid then
                                    newHumanoid.Health = 100
                                end
                            end
                        end)
                    end
                end
            end)
        end
    end
end

local function antiDelete()
    local char = player.Character
    if char then
        char.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.05)
                pcall(function()
                    local newTool = child:Clone()
                    newTool.Parent = char
                end)
            end
        end)
    end
end

local function fakeStats()
    local stats = player:FindFirstChild("stats") or Instance.new("Folder")
    stats.Name = "stats"
    stats.Parent = player
    
    local ping = stats:FindFirstChild("Ping") or Instance.new("NumberValue")
    ping.Name = "Ping"
    ping.Parent = stats
    
    local fps = stats:FindFirstChild("FPS") or Instance.new("NumberValue")
    fps.Name = "FPS"
    fps.Parent = stats
    
    game:GetService("RunService").Heartbeat:Connect(function()
        ping.Value = math.random(30, 150)
        fps.Value = math.random(30, 60)
    end)
end

local function main()
    createGUI()
    fakeStats()
    spawnProtection()
    antiDelete()
    
    hookAllRemotes()
    startAura()
    
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        task.wait(0.5)
        spawnProtection()
        antiDelete()
        startAura()
    end)
    
    game:GetService("RunService").Stepped:Connect(function()
        if not hookEnabled then return end
        local weapon = getWeapon()
        if weapon then
            for _, child in pairs(weapon:GetDescendants()) do
                if child:IsA("NumberValue") then
                    local name = child.Name:lower()
                    if name:match("damage") or name:match("dmg") then
                        child.Value = 500
                    end
                    if name:match("range") or name:match("radius") then
                        child.Value = 500
                    end
                end
            end
        end
    end)
end

pcall(main)

script.Archivable = true
script.Disabled = false

local function autoRestore()
    if not script.Parent then
        task.wait(0.1)
        local newScript = script:Clone()
        local target = player:FindFirstChild("PlayerScripts") or game:GetService("StarterPlayer").StarterPlayerScripts
        if target then
            newScript.Parent = target
        end
    end
end

script.AncestryChanged:Connect(autoRestore)

game:GetService("RunService").Heartbeat:Connect(function()
    if not script.Parent then
        autoRestore()
    end
end)

game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child:IsA("ScreenGui") and child.Name == "KillAuraGUI" then
        task.wait(0.1)
        createGUI()
    end
end)