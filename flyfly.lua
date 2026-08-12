local g = game
local rs = g:GetService("ReplicatedStorage")
local plrs = g:GetService("Players")
local lp = plrs.LocalPlayer
local ws = g:GetService("Workspace")
local ss = g:GetService("ScriptService")
local lps = lp.PlayerScripts
local mt = getrawmetatable(g)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
local oldNewIndex = mt.__newindex
local oldWrap = coroutine.wrap
local oldGetGC = getgc
local oldGetfenv = getfenv
local oldSetfenv = setfenv
local oldSpawn = spawn
local oldDelay = delay

setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" then
        local selfStr = tostring(self)
        if selfStr:find("AntiCheat") or selfStr:find("Detection") or selfStr:find("Ban") or selfStr:find("Kick") or selfStr:find("Log") or selfStr:find("Report") or selfStr:find("Teleport") then
            return nil
        end
        if selfStr:find("ForceSelfDamage") then return nil end
        if type(args[1]) == "string" then
            args[1] = args[1] .. string.char(0x200b)
            return oldNamecall(self, args[1], unpack(args, 2))
        end
        if type(args[1]) == "table" and args[1].Position then
            args[1].Position = args[1].Position + Vector3.new(math.random(-1,1)*0.01, 0, math.random(-1,1)*0.01)
            return oldNamecall(self, unpack(args))
        end
    end
    if method == "Kick" or method == "Ban" or method == "Destroy" then return nil end
    return oldNamecall(self, ...)
end)

mt.__index = newcclosure(function(self, key)
    if key == "Character" and self == lp then
        local char = oldIndex(self, key)
        if char and char:FindFirstChild("HumanoidRootPart") then
            return char
        end
        return oldIndex(self, key)
    end
    if key == "HumanoidRootPart" and self:IsA("Model") then
        local hrp = oldIndex(self, key)
        if hrp and self == lp.Character then
            local fake = Instance.new("Part")
            fake.Name = "FakeHRP"
            fake.Position = hrp.Position + Vector3.new(0, 0.5, 0)
            fake.Size = Vector3.new(1,1,1)
            fake.Transparency = 1
            fake.Anchored = true
            fake.Parent = self
            return hrp
        end
        return oldIndex(self, key)
    end
    if key == "Parent" and self:IsA("BasePart") then return oldIndex(self, key) end
    return oldIndex(self, key)
end)

mt.__newindex = newcclosure(function(self, key, value)
    if key == "Parent" and self:IsA("BasePart") then
        local pos = self.Position
        if pos and (pos.Y > 1e6 or pos.Y < -1e6) then return end
    end
    if key == "Velocity" and self:IsA("BasePart") then
        if type(value) == "Vector3" and value.Magnitude > 500 then
            value = value.Unit * 500
        end
    end
    if key == "CFrame" and self:IsA("BasePart") then
        if value and value.Position and value.Position.Y > 1e6 then return end
    end
    return oldNewIndex(self, key, value)
end)

setreadonly(mt, true)

hookfunction(getgc, newcclosure(function(f)
    local out = {}
    for _, obj in ipairs(oldGetGC(f)) do
        if not (type(obj) == "function" and not isexecutorclosure(obj)) then
            table.insert(out, obj)
        end
    end
    return out
end))

hookfunction(coroutine.wrap, newcclosure(function(f)
    return function(...) return task.spawn(f, ...) end
end))

hookfunction(getfenv, newcclosure(function(...)
    local env = oldGetfenv(...)
    if env and env.script and env.script:FindFirstChild("Parent") and tostring(env.script.Parent):find("Server") then
        return nil
    end
    return env
end))

hookfunction(setfenv, newcclosure(function(f, env)
    if env and env.script and env.script:FindFirstChild("Parent") and tostring(env.script.Parent):find("Server") then
        return oldSetfenv(f, {})
    end
    return oldSetfenv(f, env)
end))

hookfunction(spawn, newcclosure(function(f)
    return task.spawn(f)
end))

hookfunction(delay, newcclosure(function(t, f)
    task.wait(t)
    task.spawn(f)
end))

local oldStepped = ws.ChildAdded
ws.ChildAdded = newcclosure(function(child)
    if child:IsA("Model") and child.Name == "AntiCheat" then
        child:Destroy()
        return
    end
    return oldStepped(child)
end)

local oldPlayerAdded = plrs.ChildAdded
plrs.ChildAdded = newcclosure(function(child)
    if child:IsA("Player") and child ~= lp then
        local s = Instance.new("Script")
        s.Source = "local function kill() end game:GetService('Players').LocalPlayer:Kick('')"
        s.Parent = child
        return
    end
    return oldPlayerAdded(child)
end)

local oldGetChildren = Instance.GetChildren
Instance.GetChildren = newcclosure(function(self)
    local t = oldGetChildren(self)
    if self == lp and t then
        for i, v in ipairs(t) do
            if v.Name == "Anticheat" or v.Name == "Detection" then
                table.remove(t, i)
            end
        end
    end
    return t
end)

local oldFindFirstChild = Instance.FindFirstChild
Instance.FindFirstChild = newcclosure(function(self, name, ...)
    if name == "AntiCheat" or name == "Detection" or name == "Ban" then
        return nil
    end
    return oldFindFirstChild(self, name, ...)
end)

local oldWaitForChild = Instance.WaitForChild
Instance.WaitForChild = newcclosure(function(self, name, ...)
    if name == "AntiCheat" or name == "Detection" or name == "Ban" then
        return nil
    end
    return oldWaitForChild(self, name, ...)
end)

local oldTeleport = game:GetService("TeleportService").Teleport
game:GetService("TeleportService").Teleport = newcclosure(function(...)
    return nil
end)

local oldGetChildren2 = g.GetChildren
g.GetChildren = newcclosure(function(self)
    local t = oldGetChildren2(self)
    if self == g then
        for i, v in ipairs(t) do
            if v.Name == "AntiCheat" or v.Name == "Admin" then
                table.remove(t, i)
            end
        end
    end
    return t
end)

for _, service in pairs(g:GetDescendants()) do
    if service:IsA("Script") or service:IsA("LocalScript") or service:IsA("ModuleScript") then
        if service.Name:find("Anti") or service.Name:find("Cheat") or service.Name:find("Detection") or service.Name:find("Ban") or service.Name:find("Kick") then
            service:Destroy()
        end
    end
end

local oldLoadstring = loadstring
loadstring = newcclosure(function(s, ...)
    if type(s) == "string" and (s:find("Anti") or s:find("Cheat") or s:find("Detection") or s:find("Ban")) then
        return function() end
    end
    return oldLoadstring(s, ...)
end)

local oldRequire = require
require = newcclosure(function(...)
    local args = {...}
    if type(args[1]) == "string" and args[1]:find("Anti") then
        return {}
    end
    return oldRequire(...)
end)

print("飞行加载完成")