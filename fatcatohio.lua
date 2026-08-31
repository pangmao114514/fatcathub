local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Signal = require(ReplicatedStorage.devv).load("Signal")
local oldFireServer = Signal.FireServer
local v3item = require(ReplicatedStorage.devv).load("v3item")
local inv = v3item.inventory
local GUID = require(ReplicatedStorage.devv).load("GUID")

local silentAimEnabled = false
local aimPart = "Head"
local aimPartSafe = "Head"
local fovRadius = 250
local wallCheck = false
local hitChance = 100
local currentTarget = nil
local hookedFunc = nil
local lastAimUpdate = 0
local aimUpdateInterval = 0.05
local showFOV = false
local triggerbotEnabled = false
local hitSoundEnabled = false
local bulletTracerEnabled = false
local speedHackEnabled = false
local speedValue = 16
local infJumpEnabled = false
local fullBrightEnabled = false
local espEnabled = false
local chamsEnabled = false
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local godModeEnabled = false
local antiAfkEnabled = false
local autoFarmEnabled = false
local autoRobBankEnabled = false
local autoATMEnabled = false
local hitboxEnabled = false
local hitboxSize = 2
local cameraFOV = 70
local skyTheme = "Default"
local currentSky = nil

local function updateSky(theme)
    skyTheme = theme
    local lighting = game:GetService("Lighting")
    if currentSky and currentSky.Parent then
        currentSky:Destroy()
    end
    for _, child in ipairs(lighting:GetChildren()) do
        if child:IsA("Sky") then
            child:Destroy()
        end
    end
    local sky = Instance.new("Sky")
    sky.Name = "SunLuaSky"
    if theme == "Sunset" or theme == "日落" then
        sky.SkyboxBk = "rbxassetid://11808530"
        sky.SkyboxDn = "rbxassetid://11808534"
        sky.SkyboxFt = "rbxassetid://11808536"
        sky.SkyboxLf = "rbxassetid://11808538"
        sky.SkyboxRt = "rbxassetid://11808540"
        sky.SkyboxUp = "rbxassetid://11808542"
        sky.SunTextureId = "rbxassetid://11808544"
        sky.MoonTextureId = "rbxassetid://11808546"
    elseif theme == "Nebula" or theme == "星云" then
        sky.SkyboxBk = "rbxassetid://159454299"
        sky.SkyboxDn = "rbxassetid://159454296"
        sky.SkyboxFt = "rbxassetid://159454293"
        sky.SkyboxLf = "rbxassetid://159454286"
        sky.SkyboxRt = "rbxassetid://159454300"
        sky.SkyboxUp = "rbxassetid://159454288"
        sky.SunTextureId = "rbxassetid://52757552"
        sky.MoonTextureId = "rbxassetid://52757546"
    else
        sky.SkyboxBk = "rbxassetid://6444884337"
        sky.SkyboxDn = "rbxassetid://6444884785"
        sky.SkyboxFt = "rbxassetid://6444884337"
        sky.SkyboxLf = "rbxassetid://6444884337"
        sky.SkyboxRt = "rbxassetid://6444884337"
        sky.SkyboxUp = "rbxassetid://6444884337"
    end
    sky.StarCount = 3000
    sky.Parent = lighting
    currentSky = sky
end

RunService.Heartbeat:Connect(function()
    if skyTheme ~= "Default" and skyTheme ~= "默认" then
        local lighting = game:GetService("Lighting")
        local found = false
        for _, child in ipairs(lighting:GetChildren()) do
            if child:IsA("Sky") and child.Name == "SunLuaSky" then
                found = true
                break
            end
        end
        if not found then
            pcall(function() updateSky(skyTheme) end)
        end
    end
end)
local adornColor = Color3.fromRGB(255, 255, 255)
local tracerColor = Color3.fromRGB(255, 50, 50)
local headAdornments = {}
local originalSizes = {}
local espDrawings = {}
local chamsObjects = {}
local frameSkip = 3
local frameCount = 0
local defaultWalkSpeed = 16
local teleportGunEnabled = false
local teleportGunTool = nil
local gunScaleEnabled = false
local gunScaleMultiplier = 10
local scaled = {}
local FlyingEnabled = false
local SpinningEnabled = false
local FlightSpeed = 50
local SpinSpeed = 5
local CurrentAO = nil
local CurrentLV = nil
local CurrentMoverAttachment = nil
local FlightConnection = nil
local Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local LastControl = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local infiniteJump = false
local jumpConnection = nil
local noclipConn2 = nil
local FBEX = false
local FBE = false
local NormalLighting = {}
local respawnToggle = false
local respawnConn = nil
local deathPos = nil
local flySwimEnabled = false
local flyParts = {}
local terrain = Workspace:FindFirstChildOfClass("Terrain")
local waterSettings = {WaterTransparency = 0.7, WaterReflectance = 0.2, WaterWaveSize = 0.5, WaterWaveSpeed = 0.5, WaterColor = Color3.fromRGB(0, 100, 200)}
local airSettings = {WaterTransparency = 1, WaterReflectance = 0, WaterWaveSize = 0, WaterWaveSpeed = 0, WaterColor = Color3.fromRGB(255,255,255)}
local decayTime = 0.8
local chatConfig = TextChatService:FindFirstChild("ChatWindowConfiguration")
local dartOn = false
dartTeleportTargets = false
local dartCachedHitId = nil
local dartCurrentTarget = nil
local dartHeartConnections = {}
local dartNinjaStarBuyThread = nil
local melee = require(ReplicatedStorage.devv).load("ClientReplicator")
local AutoKnockReset = false
local starBuyEnabled = false
local savedPosition = nil

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = fovRadius
fovCircle.Color = Color3.fromRGB(255, 50, 50)
fovCircle.Thickness = 1.5
fovCircle.Transparency = 0.8
fovCircle.Filled = false
fovCircle.NumSides = 64
fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

getgenv().TrailColors = {
    StartColor = Color3.fromRGB(200, 180, 255),
    EndColor = Color3.fromRGB(140, 100, 220),
    MiddleColor1 = Color3.fromRGB(180, 150, 240),
    MiddleColor2 = Color3.fromRGB(160, 130, 230)
}

local function createHitSound()
    if not hitSoundEnabled then return end
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://6534948092"
        sound.Volume = 1.5
        sound.PlaybackSpeed = 0.8 + math.random() * 0.4
        sound.Parent = SoundService
        sound:Play()
        task.wait(1)
        pcall(function() sound:Destroy() end)
    end)
end

local function createBulletTracer(fromPos, toPos)
    if not bulletTracerEnabled then return end
    task.spawn(function()
        local dir = toPos - fromPos
        local dist = dir.Magnitude
        if dist < 0.01 then return end
        local mid = fromPos + dir * 0.5

        local p1 = Instance.new("Part")
        p1.Size = Vector3.new(0.12, 0.12, dist)
        p1.CFrame = CFrame.lookAt(fromPos, toPos) * CFrame.new(0, 0, -dist / 2)
        p1.Anchored = true
        p1.CanCollide = false
        p1.Material = Enum.Material.Neon
        p1.Color = tracerColor
        p1.Transparency = 0.15

        local att0 = Instance.new("Attachment")
        att0.Position = Vector3.new(0, 0, -dist / 2)
        att0.Parent = p1
        local att1 = Instance.new("Attachment")
        att1.Position = Vector3.new(0, 0, dist / 2)
        att1.Parent = p1

        local beam = Instance.new("Beam")
        beam.Attachment0 = att0
        beam.Attachment1 = att1
        beam.Color = ColorSequence.new(tracerColor, Color3.new(1, 1, 1))
        beam.Width0 = 0.12
        beam.Width1 = 0.02
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.FaceCamera = true
        beam.Parent = p1

        local glow = Instance.new("PointLight")
        glow.Color = tracerColor
        glow.Brightness = 5
        glow.Range = 8
        glow.Parent = p1

        local particles = Instance.new("ParticleEmitter")
        particles.Size = NumberSequence.new(0.05, 0.15)
        particles.Transparency = NumberSequence.new(0.2, 0.8)
        particles.Lifetime = NumberRange.new(0.1, 0.3)
        particles.Rate = 0
        particles.Speed = NumberRange.new(2, 5)
        particles.SpreadAngle = Vector2.new(180, 180)
        particles.Color = ColorSequence.new(tracerColor)
        particles.Parent = att0
        particles:Emit(5)

        p1.Parent = Workspace

        for i = 1, 5 do
            task.wait(0.05)
            pcall(function()
                p1.Transparency = 0.15 + i * 0.17
                beam.Width0 = 0.12 - i * 0.02
                beam.Width1 = 0.02 - i * 0.004
                glow.Brightness = 5 - i
            end)
        end

        Debris:AddItem(p1, 0.3)
    end)
end

local function createTeleportGun()
    if teleportGunTool then
        pcall(function() teleportGunTool:Destroy() end)
        teleportGunTool = nil
    end
    teleportGunTool = Instance.new("Tool")
    teleportGunTool.Name = "TP Ray Gun"
    teleportGunTool.RequiresHandle = false
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.2, 0.2, 1)
    handle.Anchored = false
    handle.CanCollide = false
    handle.Material = Enum.Material.Neon
    handle.Color = Color3.fromRGB(255, 50, 50)
    handle.Transparency = 0.3
    handle.Parent = teleportGunTool
    teleportGunTool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        if not mouse then return end
        local camPos = Camera.CFrame.Position
        local rayDir = (mouse.Hit.Position - camPos).Unit * 5000
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        local result = Workspace:Raycast(camPos, rayDir, rayParams)
        if result then
            local hitPos = result.Position
            local myChar = LocalPlayer.Character
            if myChar then
                local hrp = myChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(hitPos + Vector3.new(0, 3, 0))
                end
            end
        end
    end)
    teleportGunTool.Parent = LocalPlayer:WaitForChild("Backpack")
end

local function removeTeleportGun()
    if teleportGunTool then
        pcall(function() teleportGunTool:Destroy() end)
        teleportGunTool = nil
    end
end

Signal.FireServer = function(event, ...)
    local args = {...}
    if event == "projectileHit" then
        local data = args[3]
        if args[2] == "player" and data and data.hitPlayerId then
            local playerId = data.hitPlayerId
            local player = Players:GetPlayerByUserId(playerId)
            if player and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                data.hitPart = head
                data.pos = head.Position
                data.hitSize = head.Size
                args[3] = data
                createHitSound()
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("Head") then
                    createBulletTracer(myChar.Head.Position, head.Position)
                end
            end
        end
    end
    return oldFireServer(event, unpack(args))
end

local function clearPlayer(player)
    local adorn = headAdornments[player]
    if adorn then
        pcall(function() adorn:Destroy() end)
        headAdornments[player] = nil
    end
    local original = originalSizes[player]
    if original then
        local character = player.Character
        if character then
            local hitboxFolder = character:FindFirstChild("Hitbox")
            if hitboxFolder then
                local headHitbox = hitboxFolder:FindFirstChild("Head_Hitbox")
                if headHitbox then
                    pcall(function() headHitbox.Size = original end)
                end
            end
        end
        originalSizes[player] = nil
    end
    if chamsObjects[player] then
        pcall(function() chamsObjects[player]:Destroy() end)
        chamsObjects[player] = nil
    end
end

local function updateHitboxes()
    frameCount = frameCount + 1
    if frameCount % frameSkip ~= 0 then return end
    local targetSize = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local character = player.Character
        if not character then clearPlayer(player) continue end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then clearPlayer(player) continue end
        local hitboxFolder = character:FindFirstChild("Hitbox")
        if not hitboxFolder then clearPlayer(player) continue end
        local headHitbox = hitboxFolder:FindFirstChild("Head_Hitbox")
        if not headHitbox then clearPlayer(player) continue end
        if not originalSizes[player] then originalSizes[player] = headHitbox.Size end
        if headHitbox.Size ~= targetSize then headHitbox.Size = targetSize end
        local adorn = headAdornments[player]
        if not adorn then
            adorn = Instance.new("BoxHandleAdornment")
            adorn.AlwaysOnTop = true
            adorn.ZIndex = 10
            adorn.Adornee = headHitbox
            adorn.Parent = headHitbox
            headAdornments[player] = adorn
        end
        if adorn.Size ~= targetSize then adorn.Size = targetSize end
        if adorn.Color3 ~= adornColor then adorn.Color3 = adornColor end
        if adorn.Transparency ~= 0.4 then adorn.Transparency = 0.4 end
    end
    for player, _ in pairs(headAdornments) do
        if not player:IsDescendantOf(Players) then clearPlayer(player) end
    end
end

local function getTeam(player)
    local states = player:FindFirstChild("PlayerStates")
    if states and states:FindFirstChild("Team") then
        return states.Team.Value
    end
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Team") then
        return leaderstats.Team.Value
    end
    return nil
end

local function isTeammate(player)
    local myTeam = getTeam(LocalPlayer)
    local theirTeam = getTeam(player)
    return myTeam ~= nil and myTeam == theirTeam
end

local function isInFOV(worldPos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
    if not onScreen then return false end
    local dx = screenPos.X - fovCircle.Position.X
    local dy = screenPos.Y - fovCircle.Position.Y
    return dx * dx + dy * dy <= fovRadius * fovRadius
end

local function findTarget()
    if not silentAimEnabled then
        currentTarget = nil
        return
    end
    local ap = aimPart or "Head"
    if ap == "头部" then ap = "Head" end
    if ap == "躯干" then ap = "Torso" end
    if ap == "随机" then ap = "Random" end
    local closestDist = math.huge
    local camCF = Camera.CFrame
    local camPos = camCF.Position
    local lookDir = camCF.LookVector
    local bestTarget = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local character = player.Character
        if not character then continue end
        local isTeam = false
        pcall(function() isTeam = isTeammate(player) end)
        if isTeam then continue end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        if character:FindFirstChild("ForceField") then continue end
        local targetPart
        if ap == "Random" or ap == "随机" then
            local parts = {"Head", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
            targetPart = character:FindFirstChild(parts[math.random(1, #parts)])
        else
            targetPart = character:FindFirstChild(ap)
        end
        if not targetPart then continue end
        local toTarget = targetPart.Position - camPos
        local dist = toTarget.Magnitude
        if dist > 1000 then continue end
        local angle = math.deg(math.acos(math.clamp(lookDir:Dot(toTarget.Unit), -1, 1)))
        if angle > fovRadius / 8 then continue end
        if wallCheck then
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            if Workspace:Raycast(camPos, toTarget, rayParams) then continue end
        end
        if dist < closestDist then
            bestTarget = targetPart
            closestDist = dist
        end
    end
    currentTarget = bestTarget
end

RunService.RenderStepped:Connect(function()
    if tick() - lastAimUpdate >= aimUpdateInterval then
        lastAimUpdate = tick()
        findTarget()
    end
end)

hookedFunc = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if checkcaller() then return hookedFunc(self, ...) end
    if self ~= Workspace then return hookedFunc(self, ...) end
    if method ~= "Raycast" and method ~= "FindPartOnRayWithIgnoreList" and method ~= "FindPartOnRay" then
        return hookedFunc(self, ...)
    end
    if not silentAimEnabled or not currentTarget then return hookedFunc(self, ...) end
    if math.random(1, 100) > hitChance then return hookedFunc(self, ...) end
    local args = {...}
    local origin, direction
    if method == "Raycast" then
        origin = args[1]
        direction = args[2]
    elseif method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" then
        local ray = args[1]
        if typeof(ray) == "Ray" then
            origin = ray.Origin
            direction = ray.Direction
        end
    end
    if not origin or not direction then return hookedFunc(self, ...) end
    local targetPos = currentTarget.Position
    local fakeDir = targetPos - origin
    if method == "Raycast" then
        return {Instance = currentTarget, Position = targetPos, Normal = fakeDir.Unit, Material = Enum.Material.Plastic, Distance = fakeDir.Magnitude}
    else
        return currentTarget, targetPos, fakeDir.Unit
    end
end)

RunService.RenderStepped:Connect(function()
    if triggerbotEnabled and silentAimEnabled and currentTarget then
        local targetChar = currentTarget.Parent
        if targetChar then
            local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
            if targetPlayer and not isTeammate(targetPlayer) then
                local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local inFov = isInFOV(currentTarget.Position)
                    if inFov then
                        if wallCheck then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, targetChar}
                            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                            if not Workspace:Raycast(Camera.CFrame.Position, currentTarget.Position - Camera.CFrame.Position, rayParams) then
                                mouse1click()
                            end
                        else
                            mouse1click()
                        end
                    end
                end
            end
        end
    end
end)

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            if espDrawings[player] then for _, d in pairs(espDrawings[player]) do d.Visible = false end end
            continue
        end
        local character = player.Character
        if not character or not espEnabled then
            if espDrawings[player] then for _, d in pairs(espDrawings[player]) do d.Visible = false end end
            continue
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp or humanoid.Health <= 0 then
            if espDrawings[player] then for _, d in pairs(espDrawings[player]) do d.Visible = false end end
            continue
        end
        if isTeammate(player) then
            if espDrawings[player] then for _, d in pairs(espDrawings[player]) do d.Visible = false end end
            continue
        end
        if not espDrawings[player] then
            local box = Drawing.new("Square")
            box.Thickness = 1.5
            box.Filled = false
            box.Transparency = 1
            local name = Drawing.new("Text")
            name.Size = 14
            name.Center = true
            name.Outline = true
            name.Color = Color3.fromRGB(255, 255, 255)
            local healthText = Drawing.new("Text")
            healthText.Size = 13
            healthText.Center = true
            healthText.Outline = true
            local distText = Drawing.new("Text")
            distText.Size = 12
            distText.Center = true
            distText.Outline = true
            distText.Color = Color3.fromRGB(200, 200, 200)
            local healthBar = Drawing.new("Line")
            healthBar.Thickness = 2
            espDrawings[player] = {Box = box, Name = name, HealthText = healthText, DistText = distText, HealthBar = healthBar}
        end
        local data = espDrawings[player]
        local head = character:FindFirstChild("Head")
        if head then
            local headPos, headOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local footPos, footOn = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            if headOn or footOn then
                local boxHeight = math.abs(headPos.Y - footPos.Y)
                local boxWidth = boxHeight * 0.55
                data.Box.Size = Vector2.new(boxWidth, boxHeight)
                data.Box.Position = Vector2.new(headPos.X - boxWidth / 2, headPos.Y)
                local hpPct = humanoid.Health / humanoid.MaxHealth
                data.Box.Color = Color3.fromRGB(255 - math.floor(hpPct * 255), math.floor(hpPct * 255), 0)
                data.Box.Visible = true
                data.Name.Position = Vector2.new(headPos.X, headPos.Y - 18)
                data.Name.Text = player.Name
                data.Name.Visible = true
                data.HealthText.Position = Vector2.new(headPos.X, footPos.Y + 2)
                data.HealthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                data.HealthText.Color = Color3.fromRGB(255 - math.floor(hpPct * 255), math.floor(hpPct * 255), 0)
                data.HealthText.Visible = true
                local distance = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)
                data.DistText.Position = Vector2.new(headPos.X, footPos.Y + 16)
                data.DistText.Text = distance .. "m"
                data.DistText.Visible = true
                local barX = headPos.X - boxWidth / 2 - 6
                data.HealthBar.From = Vector2.new(barX, footPos.Y)
                data.HealthBar.To = Vector2.new(barX, headPos.Y + (footPos.Y - headPos.Y) * (1 - hpPct))
                data.HealthBar.Color = Color3.fromRGB(255 - math.floor(hpPct * 255), math.floor(hpPct * 255), 0)
                data.HealthBar.Visible = true
            else
                for _, d in pairs(data) do d.Visible = false end
            end
        else
            for _, d in pairs(data) do d.Visible = false end
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

local function updateChams()
    if not chamsEnabled then
        for _, obj in pairs(chamsObjects) do
            pcall(function() obj:Destroy() end)
        end
        table.clear(chamsObjects)
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local character = player.Character
        if not character then
            if chamsObjects[player] then
                pcall(function() chamsObjects[player]:Destroy() end)
                chamsObjects[player] = nil
            end
            continue
        end
        if isTeammate(player) then
            if chamsObjects[player] then
                pcall(function() chamsObjects[player]:Destroy() end)
                chamsObjects[player] = nil
            end
            continue
        end
        if not chamsObjects[player] then
            local hl = Instance.new("Highlight")
            hl.FillTransparency = 0.7
            hl.OutlineTransparency = 0
            hl.OutlineColor = Color3.fromRGB(255, 0, 0)
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.Parent = character
            chamsObjects[player] = hl
        end
        local hl = chamsObjects[player]
        if hl and hl.Parent ~= character then
            hl.Parent = character
        end
        if hl then
            local t = tick()
            hl.FillColor = Color3.new(0.5 + 0.5 * math.sin(t * 3), 0.5 + 0.5 * math.sin(t * 3 + 2), 0.5 + 0.5 * math.sin(t * 3 + 4))
            hl.OutlineColor = hl.FillColor
        end
    end
end

RunService.Heartbeat:Connect(updateChams)

local function scaleModel(m)
    if not m or not m.Parent then return end
    local id = m:GetDebugId()
    if scaled[id] then return end
    scaled[id] = true
    pcall(function()
        if m:IsA("Model") or m:IsA("Tool") then
            if typeof(m.ScaleTo) == "function" then
                m:ScaleTo(gunScaleMultiplier)
            else
                for _, d in ipairs(m:GetDescendants()) do
                    if d:IsA("BasePart") then
                        d.Size = d.Size * gunScaleMultiplier
                    elseif d:IsA("SpecialMesh") or d:IsA("BlockMesh") then
                        d.Scale = d.Scale * gunScaleMultiplier
                    elseif d:IsA("Weld") or d:IsA("Motor6D") then
                        if d.C0 then
                            local p = d.C0.Position
                            local r = d.C0 - p
                            d.C0 = CFrame.new(p * gunScaleMultiplier) * r
                        end
                        if d.C1 then
                            local p = d.C1.Position
                            local r = d.C1 - p
                            d.C1 = CFrame.new(p * gunScaleMultiplier) * r
                        end
                    end
                end
            end
        elseif m:IsA("BasePart") then
            m.Size = m.Size * gunScaleMultiplier
        end
    end)
end

local function updateGunScale()
    if not gunScaleEnabled then return end
    pcall(function()
        local char = LocalPlayer.Character
        local bp = LocalPlayer:FindFirstChild("Backpack")
        local cam = Workspace:FindFirstChild("Camera")
        pcall(function()
            local sys = require(ReplicatedStorage:WaitForChild("devv")).load("v3item")
            local inv2 = sys.inventory
            if inv2 and inv2.items then
                for _, item in pairs(inv2.items) do
                    if typeof(item) == "Instance" then
                        scaleModel(item)
                        return
                    end
                    if type(item) ~= "table" then
                        continue
                    end
                    for _, f in ipairs({"tool","model","viewModel","viewmodel","instance","object","weapon","gun","equippedTool","equippedModel","handle","weaponModel","gunModel","visual"}) do
                        pcall(function()
                            if typeof(item[f]) == "Instance" then
                                scaleModel(item[f])
                            end
                        end)
                    end
                    pcall(function()
                        for _, v in pairs(item) do
                            if typeof(v) == "Instance" then
                                scaleModel(v)
                            end
                        end
                    end)
                end
            end
        end)
        if char then
            for _, c in ipairs(char:GetDescendants()) do
                if c:IsA("Tool") then
                    scaleModel(c)
                end
                if c:IsA("Model") then
                    local n = c.Name:lower()
                    if n:find("gun") or n:find("weapon") or n:find("rifle") or n:find("pistol") or n:find("ak") or n:find("ar") or n:find("shotgun") or n:find("sniper") or n:find("smg") or n:find("deagle") or n:find("rpg") then
                        scaleModel(c)
                    end
                end
            end
        end
        if bp then
            for _, c in ipairs(bp:GetDescendants()) do
                if c:IsA("Tool") then
                    scaleModel(c)
                end
            end
        end
        for _, c in ipairs(Workspace:GetDescendants()) do
            if c:IsA("Tool") then
                scaleModel(c)
            end
        end
        if cam then
            for _, c in ipairs(cam:GetDescendants()) do
                if c:IsA("Model") or c:IsA("Tool") then
                    scaleModel(c)
                end
                if c:IsA("BasePart") then
                    local id = c:GetDebugId()
                    if not scaled[id] then
                        pcall(function()
                            c.Size = c.Size * gunScaleMultiplier
                        end)
                        scaled[id] = true
                    end
                end
            end
        end
    end)
end

task.spawn(function()
    while true do
        updateGunScale()
        task.wait(3)
    end
end)

local flyBV = nil
local flyBG = nil

local function startFlying()
    if FlyingEnabled then return end
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    FlyingEnabled = true
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    hum.PlatformStand = true
    hum.AutoRotate = false
    flyBV = Instance.new("BodyVelocity")
    flyBV.Name = "SunFlyBV"
    flyBV.MaxForce = Vector3.new(1e7, 1e7, 1e7)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.Name = "SunFlyBG"
    flyBG.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
    flyBG.P = 1e5
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp
    FlightConnection = RunService.RenderStepped:Connect(function()
        if not FlyingEnabled or not flyBV or not flyBG then return end
        local cam = workspace.CurrentCamera
        local dir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
        if dir.Magnitude > 0 then
            flyBV.Velocity = dir.Unit * FlightSpeed
        else
            flyBV.Velocity = Vector3.new(0, 0, 0)
        end
        flyBG.CFrame = cam.CFrame
    end)
end

local function stopFlying()
    if not FlyingEnabled then return end
    FlyingEnabled = false
    if FlightConnection then FlightConnection:Disconnect() FlightConnection = nil end
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    local c = LocalPlayer.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = false
        hum.AutoRotate = true
    end
end

RunService.Heartbeat:Connect(function()
    if SpinningEnabled then
        local c = LocalPlayer.Character
        if c then
            local h = c:FindFirstChild("HumanoidRootPart")
            if h then
                pcall(function() h.CFrame = h.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0) end)
            end
        end
    end
end)

local function setupJump()
    if jumpConnection then jumpConnection:Disconnect() end
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if infiniteJump and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end

setupJump()
LocalPlayer.CharacterAdded:Connect(setupJump)
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if FlyingEnabled then
        stopFlying()
        task.wait(0.1)
        startFlying()
    end
end)

local function setupHighlight()
    if FBEX then return end
    FBEX = true
    NormalLighting = {Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient}
    local function watchProp(prop, target)
        Lighting:GetPropertyChangedSignal(prop):Connect(function()
            if Lighting[prop] ~= target and Lighting[prop] ~= NormalLighting[prop] then
                Lighting[prop] = target
                NormalLighting[prop] = target
            end
        end)
    end
    watchProp("Brightness", 1)
    watchProp("ClockTime", 12)
    watchProp("FogEnd", 786543)
    watchProp("GlobalShadows", false)
    watchProp("Ambient", Color3.fromRGB(178,178,178))
    for k, v in pairs({Brightness=1, ClockTime=12, FogEnd=786543, GlobalShadows=false, Ambient=Color3.fromRGB(178,178,178)}) do
        Lighting[k] = v
    end
end

local function onDied(character)
    if not respawnToggle then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then deathPos = hrp.Position end
end

local function onRespawn(character)
    if not respawnToggle then return end
    local hrp = character:WaitForChild("HumanoidRootPart", 10)
    if hrp and deathPos then
        hrp.CFrame = CFrame.new(deathPos)
        wait(1)
        if (hrp.Position - deathPos).Magnitude > 1 then
            hrp.CFrame = CFrame.new(deathPos)
        end
    end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Died:Connect(function() onDied(character) end) end
end

RunService.Heartbeat:Connect(function()
    updateHitboxes()
    if godModeEnabled then
        local myChar = LocalPlayer.Character
        if myChar then
            local humanoid = myChar:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 999999
                humanoid.Health = 999999
            end
        end
    end
    if noclipEnabled then
        local myChar = LocalPlayer.Character
        if myChar then
            for _, part in ipairs(myChar:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
    if speedHackEnabled then
        local myChar = LocalPlayer.Character
        if myChar then
            local humanoid = myChar:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = speedValue end
        end
    end
    pcall(function() Camera.FieldOfView = cameraFOV end)
    if antiAfkEnabled then
        pcall(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
    if AutoKnockReset then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            pcall(function()
                melee.Set(LocalPlayer, "knocked", false)
                melee.Replicate("knocked")
            end)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if flySwimEnabled and LocalPlayer.Character and terrain then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local head = LocalPlayer.Character:FindFirstChild("Head")
        if hrp and head then
            local headCF = head.CFrame
            local hrpCF = hrp.CFrame
            local size = hrp.Size + Vector3.new(0,0.1,0)
            terrain.WaterTransparency = airSettings.WaterTransparency
            terrain.WaterReflectance = airSettings.WaterReflectance
            terrain.WaterWaveSize = airSettings.WaterWaveSize
            terrain.WaterWaveSpeed = airSettings.WaterWaveSpeed
            terrain.WaterColor = airSettings.WaterColor
            terrain:FillBlock(headCF, size, Enum.Material.Water)
            terrain:FillBlock(hrpCF, size, Enum.Material.Water)
            table.insert(flyParts, {time=tick(), cf=headCF, size=size})
            table.insert(flyParts, {time=tick(), cf=hrpCF, size=size})
        end
    end
end)

task.spawn(function()
    while true do
        local now = tick()
        for i = #flyParts, 1, -1 do
            local p = flyParts[i]
            if now - p.time >= decayTime then
                terrain:FillBlock(p.cf, p.size, Enum.Material.Air)
                table.remove(flyParts, i)
            end
        end
        terrain.WaterTransparency = waterSettings.WaterTransparency
        terrain.WaterReflectance = waterSettings.WaterReflectance
        terrain.WaterWaveSize = waterSettings.WaterWaveSize
        terrain.WaterWaveSpeed = waterSettings.WaterWaveSpeed
        terrain.WaterColor = waterSettings.WaterColor
        task.wait(0.05)
    end
end)

local function dartCleanupConnections()
    for _, conn in ipairs(dartHeartConnections) do
        if conn then conn:Disconnect() end
    end
    dartHeartConnections = {}
end

local function dartEquipNinjaStar()
    local itm = inv.getItems and inv.getItems() or inv.items or {}
    for _, v in next, itm do
        if v.name == "Ninja Star" then
            Signal.FireServer("equip", v.guid)
            return v.guid
        end
    end
    return nil
end

local function dartInitThrow()
    local sg = dartEquipNinjaStar()
    if not sg then return end
    local c = LocalPlayer.Character
    if not c then return end
    local rh = c:FindFirstChild("RightHand")
    if not rh then return end
    local mp = rh.Position + Vector3.new(0, 0.5, 0)
    local tp = mp + Vector3.new(50, 0, 0)
    local vel = (tp - mp).Unit * 150
    local ok, r1, hid = pcall(function()
        return Signal.InvokeServer("throwSticky", GUID(), "Ninja Star", sg, vel, tp)
    end)
    if ok and r1 and hid then
        dartCachedHitId = hid
    end
end

local function dartHasShield(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    for _, desc in pairs(targetPlayer.Character:GetDescendants()) do
        if desc:IsA("ForceField") then
            return true
        end
    end
    return false
end

local function dartFindValidTarget()
    local closest = nil
    local minDist = math.huge
    local myChar = LocalPlayer.Character
    if not myChar then return nil end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if humanoid and head and hrp and humanoid.Health > 0 and not dartHasShield(player) then
                local dist = (hrp.Position - myHRP.Position).Magnitude
                if dist < minDist and dist <= 50 then
                    minDist = dist
                    closest = {player = player, head = head}
                end
            end
        end
    end
    return closest
end

local function dartRapidThrowAttack()
    if not dartOn or not dartCachedHitId then return end
    local targetData = dartFindValidTarget()
    if not targetData then return end
    local head = targetData.head
    local tp = head.Position
    local wcf = CFrame.new(tp, tp + Vector3.new(0, 1, 0))
    local rcf = CFrame.new(0, 0, 0)
    for i = 1, 15 do
        Signal.InvokeServer("hitSticky", dartCachedHitId, head, rcf, wcf)
    end
end

local function dartFindNextTeleportTarget()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 and not dartHasShield(player) then
                return player
            end
        end
    end
    return nil
end

local function dartFastTeleport()
    if not dartTeleportTargets or not dartOn then return end
    if not dartCurrentTarget then
        dartCurrentTarget = dartFindNextTeleportTarget()
        if not dartCurrentTarget then return end
    end
    if not dartCurrentTarget.Character then
        dartCurrentTarget = dartFindNextTeleportTarget()
        if not dartCurrentTarget then return end
    end
    local humanoid = dartCurrentTarget.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 or dartHasShield(dartCurrentTarget) then
        dartCurrentTarget = dartFindNextTeleportTarget()
        if not dartCurrentTarget then return end
    end
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then return end
    local targetHRP = dartCurrentTarget.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    char.PrimaryPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 1.5)
end

local starState = nil
local starX = 0
local starY = 0
local starZ = 0

local function starHasItem(name)
    local items = v3item.inventory.getItems
    if items then
        items = items()
        for _, it in pairs(items) do
            if it.name == name then
                return true
            end
        end
        return false
    end
    local item = v3item.inventory.getFromName(name)
    return item ~= nil
end

local function starGetGuid(name)
    local items = v3item.inventory.getItems
    if items then
        items = items()
        for _, it in pairs(items) do
            if it.name == name then
                return it.guid
            end
        end
        return nil
    end
    local item = v3item.inventory.getFromName(name)
    if item then
        return item.guid
    end
    return nil
end

local function starTpToSeller()
    local target = workspace.ItemsOnSale and workspace.ItemsOnSale["Fire Extinguisher"]
    if not target then
        return false
    end
    local cf = nil
    if target:IsA("Model") then
        cf = target:GetPivot()
    elseif target:IsA("BasePart") then
        cf = target.CFrame
    else
        return false
    end
    local char = LocalPlayer.Character
    if not char or not char.Parent then
        return false
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = cf + Vector3.new(0, 3, 0)
        return true
    end
    return false
end

local star_m = nil

local star_s78
local star_s7878
local star_s7891
local star_s9178
local star_s9191
local star_s787878
local star_s789178
local star_s91

star_s78 = function()
    if starHasItem("Ninja Star") then
        star_m = star_s91
        return
    end
    star_m = star_s7878
end

star_s7878 = function()
    if starHasItem("Ninja Star") then
        star_m = star_s91
        return
    end
    if starTpToSeller() then
        starX = os.clock()
        local saleFolder = Workspace:FindFirstChild("ItemsOnSale")
        if saleFolder then
            local fe = saleFolder:FindFirstChild("Fire Extinguisher")
            if fe then
                local feModel = fe:FindFirstChild("Fire Extinguisher") or fe:FindFirstChildOfClass("Model") or fe:FindFirstChildOfClass("BasePart")
                if feModel then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local cf = nil
                        if feModel:IsA("Model") then pcall(function() cf = feModel:GetPivot() end)
                        elseif feModel:IsA("BasePart") then cf = feModel.CFrame end
                        if cf then
                            hrp.CFrame = cf + Vector3.new(0, 3, 0)
                            task.wait(0.3)
                            local cd = feModel:FindFirstChildOfClass("ClickDetector")
                            if not cd then for _, d in ipairs(feModel:GetDescendants()) do if d:IsA("ClickDetector") then cd = d break end end end
                            if cd then pcall(function() fireclickdetector(cd) end) end
                            local pp = feModel:FindFirstChildOfClass("ProximityPrompt")
                            if not pp then for _, d in ipairs(feModel:GetDescendants()) do if d:IsA("ProximityPrompt") then pp = d break end end end
                            if pp then pcall(function() pp.HoldDuration = 0 end) pcall(function() fireproximityprompt(pp) end) end
                        end
                    end
                end
            end
        end
        star_m = star_s7891
    end
end

star_s7891 = function()
    if starHasItem("Fire Extinguisher") then
        star_m = star_s9178
        return
    end
    star_m = star_s7878
end

star_s9178 = function()
    local g = starGetGuid("Fire Extinguisher")
    if g then
        Signal.InvokeServer("craftingDisassemble", { [g] = 1 })
    end
    star_m = star_s9191
end

star_s9191 = function()
    Signal.InvokeServer("beginCraft", 'NinjaStarCraft')
    starY = os.clock()
    star_m = star_s787878
end

star_s787878 = function()
    if starHasItem("Ninja Star") then
        star_m = star_s91
        return
    end
    if os.clock() - starY > 25 then
        starZ = os.clock()
        star_m = star_s789178
    end
end

star_s789178 = function()
    if starHasItem("Ninja Star") then
        star_m = star_s91
        return
    end
    if os.clock() - starZ > 30 then
        star_m = star_s7878
        return
    end
    Signal.InvokeServer("claimCraft", 'NinjaStarCraft')
end

star_s91 = function()
    if not starHasItem("Ninja Star") then
        star_m = star_s78
    end
end

star_m = star_s78

RunService.Heartbeat:Connect(function()
    if starBuyEnabled and star_m then
        star_m()
    end
end)
local UseRedWhite = true

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>',
            math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

function redWhiteGradient(text)
    return gradient(text, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255))
end

function whiteRedGradient(text)
    return gradient(text, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 0, 0))
end

local FLOW_BORDER_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),
    ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF88AA")),
    ColorSequenceKeypoint.new(1, Color3.fromHex("FF3344"))
})

local SelectedLang
local langConfirmed = false

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/tnine-n9/n9/refs/heads/main/Wind3"))()

WindUI:Popup({
    Title = "胖猫Hub",
    IconThemed = true,
    Content = "请选择语言 / Select Language" .. gradient(" 胖猫Hub", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    Buttons = {
        { Title = "Chinese", Callback = function() SelectedLang = "zh" langConfirmed = true end, Variant = "Secondary" },
        { Title = "English", Icon = "arrow-right", Callback = function() SelectedLang = "en" langConfirmed = true end, Variant = "Primary" },
    },
    Background = "https://raw.githubusercontent.com/tnine-n9/n9/refs/heads/main/quality_restoration_20260522215233585.jpg",
    BackgroundImageTransparency = 0.35,
})

repeat task.wait(0.1) until langConfirmed

local L = {}

if SelectedLang == "zh" then
    L.General = "通用"
    L.Combat = "战斗"
    L.Visual = "视觉"
    L.Kill = "杀戮"
    L.Teleport = "传送"
    L.Buy = "购买"
    L.Money = "刷钱"
    L.SilentAim = "美国子弹"
    L.Hitbox = "Hitbox扩展"
    L.HitboxSize = "Hitbox大小"
    L.HitboxColor = "Hitbox颜色"
    L.FOV = "FOV大小"
    L.FOVShow = "显示FOV圈"
    L.AimPart = "瞄准部位"
    L.WallCheck = "墙壁检测"
    L.HitChance = "命中率"
    L.Triggerbot = "触发开火"
    L.HitSound = "击中音效"
    L.BulletTracer = "射击弹道"
    L.TracerColor = "弹道颜色"
    L.ESP = "透视"
    L.Chams = "彩虹透视"
    L.Fly = "飞行"
    L.FlySpeed = "飞行速度"
    L.Spin = "旋转"
    L.SpinSpeed = "旋转速度"
    L.Speed = "加速"
    L.Noclip = "穿墙"
    L.InfJump = "无限跳"
    L.GodMode = "上帝模式"
    L.AntiAfk = "防挂机"
    L.FullBright = "全亮"
    L.NightVision = "夜视"
    L.Respawn = "原地复活"
    L.AntiVoid = "防虚空"
    L.AntiStun = "防僵直"
    L.AntiSit = "防坐下"
    L.KnockReset = "防倒地"
    L.AutoHeal = "自动回血"
    L.RemoteLocker = "远程储物柜"
    L.RemoteBM = "远程黑市"
    L.FlySwim = "飞行(游泳式)"
    L.GunScale = "放大枪"
    L.GunScaleMult = "放大倍数"
    L.BladeAura = "飞镖光环"
    L.BladeAuraTP = "传送攻击"
    L.AutoBuyStar = "自动获取飞镖"
    L.TPSpawn = "出生点"
    L.TPBank = "银行"
    L.TPPolice = "警察局"
    L.TPGunShop = "枪店"
    L.TPHospital = "医院"
    L.TPStore = "商店"
    L.TPGas = "加油站"
    L.TPPark = "公园"
    L.TPGang = "黑帮区"
    L.TPMil = "军事基地"
    L.TPSewers = "下水道"
    L.TPRandom = "随机"
    L.TPUp = "向上"
    L.TPDown = "向下"
    L.TPPlayer = "传送到玩家"
    L.BuyFlame = "喷火枪"
    L.BuyRay = "射线枪"
    L.BuyAK = "AK47"
    L.BuyDeagle = "沙鹰"
    L.BuyUzi = "Uzi"
    L.BuyMoss = "Mossberg"
    L.BuyLock = "撬锁器"
    L.BuyArmor = "护甲"
    L.BuyStar = "飞镖"
    L.BuyItem = "选择物品"
    L.AutoFarm = "自动刷钱"
    L.AutoRob = "自动抢银行"
    L.AutoATM = "自动抢ATM"
    L.CameraFOV = "视角FOV"
    L.SkyTheme = "天空主题"
    L.SkyDefault = "默认"
    L.SkySunset = "日落"
    L.SkyNebula = "星云"
    L.Head = "头部"
    L.Torso = "躯干"
    L.Random = "随机"
else
    L.General = "General"
    L.Combat = "Combat"
    L.Visual = "Visual"
    L.Kill = "Kill"
    L.Teleport = "Teleport"
    L.Buy = "Buy"
    L.Money = "Money"
    L.SilentAim = "Silent Aim"
    L.Hitbox = "Hitbox Expander"
    L.HitboxSize = "Hitbox Size"
    L.HitboxColor = "Hitbox Color"
    L.FOV = "FOV Size"
    L.FOVShow = "Show FOV Circle"
    L.AimPart = "Aim Part"
    L.WallCheck = "Wall Check"
    L.HitChance = "Hit Chance"
    L.Triggerbot = "Triggerbot"
    L.HitSound = "Hit Sound"
    L.BulletTracer = "Bullet Tracer"
    L.TracerColor = "Tracer Color"
    L.ESP = "ESP"
    L.Chams = "Chams"
    L.Fly = "Fly"
    L.FlySpeed = "Fly Speed"
    L.Spin = "Spin"
    L.SpinSpeed = "Spin Speed"
    L.Speed = "Speed"
    L.Noclip = "Noclip"
    L.InfJump = "Infinite Jump"
    L.GodMode = "God Mode"
    L.AntiAfk = "Anti AFK"
    L.FullBright = "Full Bright"
    L.NightVision = "Night Vision"
    L.Respawn = "Respawn"
    L.AntiVoid = "Anti Void"
    L.AntiStun = "Anti Stun"
    L.AntiSit = "Anti Sit"
    L.KnockReset = "Anti Knock"
    L.AutoHeal = "Auto Heal"
    L.RemoteLocker = "Remote Locker"
    L.RemoteBM = "Remote Black Market"
    L.FlySwim = "Fly Swim"
    L.GunScale = "Gun Scale"
    L.GunScaleMult = "Scale Multiplier"
    L.BladeAura = "Blade Aura"
    L.BladeAuraTP = "Aura TP"
    L.AutoBuyStar = "Auto Buy Star"
    L.TPSpawn = "Spawn"
    L.TPBank = "Bank"
    L.TPPolice = "Police Station"
    L.TPGunShop = "Gun Shop"
    L.TPHospital = "Hospital"
    L.TPStore = "Store"
    L.TPGas = "Gas Station"
    L.TPPark = "Park"
    L.TPGang = "Gang Zone"
    L.TPMil = "Military Base"
    L.TPSewers = "Sewers"
    L.TPRandom = "Random"
    L.TPUp = "Up"
    L.TPDown = "Down"
    L.TPPlayer = "TP to Player"
    L.BuyFlame = "Flamethrower"
    L.BuyRay = "Ray Gun"
    L.BuyAK = "AK47"
    L.BuyDeagle = "Desert Eagle"
    L.BuyUzi = "Uzi"
    L.BuyMoss = "Mossberg"
    L.BuyLock = "Lockpick"
    L.BuyArmor = "Armor"
    L.BuyStar = "Ninja Star"
    L.BuyItem = "Select Item"
    L.AutoFarm = "Auto Farm"
    L.AutoRob = "Auto Rob Bank"
    L.AutoATM = "Auto Rob ATM"
    L.CameraFOV = "Camera FOV"
    L.SkyTheme = "Sky Theme"
    L.SkyDefault = "Default"
    L.SkySunset = "Sunset"
    L.SkyNebula = "Nebula"
    L.Head = "Head"
    L.Torso = "Torso"
    L.Random = "Random"
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local Window = WindUI:CreateWindow({
    Title = whiteRedGradient(""),
    IconThemed = true,
    Folder = "shell",
    Size = UDim2.fromOffset(491, 238),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    NewElements = true,
    User = { Enabled = true, Anonymous = false },
    SideBarWidth = 185,
    ScrollBarEnabled = true,
    Background = "https://raw.githubusercontent.com/tnine-n9/n9/refs/heads/main/quality_restoration_20260522215233585.jpg",
    BackgroundImageTransparency = 0.35,
})

Window:EditOpenButton({
    Title = whiteRedGradient("胖猫Hub"),
    CornerRadius = UDim.new(1, 2),
    StrokeThickness = 2,
    Color = FLOW_BORDER_GRADIENT,
    Draggable = true,
})

task.spawn(function()
    repeat task.wait(0.1) until Window.OpenButtonMain and Window.OpenButtonMain.Button
    local button = Window.OpenButtonMain.Button
    local stroke = button:FindFirstChildWhichIsA("UIStroke")
    if not stroke then return end
    repeat task.wait(0.05) until stroke:FindFirstChildWhichIsA("UIGradient")
    local grad = stroke:FindFirstChildWhichIsA("UIGradient")
    if not grad then return end
    game:GetService("RunService").Heartbeat:Connect(function()
        if not grad or not grad.Parent then return end
        local t = tick() * 60
        grad.Rotation = t % 360
    end)
end)

Window:SetToggleKey(Enum.KeyCode.RightShift)

pcall(function() WindUI:SetFont("rbxassetid://12187376739") end)

local function tpTo(pos)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function() hrp.CFrame = typeof(pos) == "CFrame" and pos or CFrame.new(pos) end)
    end
end

local function findItemInWorkspace(itemName)
    local searchName = itemName:lower()
    local saleFolder = Workspace:FindFirstChild("ItemsOnSale")
    if saleFolder then
        for _, itemFolder in ipairs(saleFolder:GetChildren()) do
            if itemFolder.Name:lower() == searchName or itemFolder.Name:lower():find(searchName, 1, true) then
                local itemModel = itemFolder:FindFirstChild(itemFolder.Name)
                if not itemModel then
                    for _, c in ipairs(itemFolder:GetChildren()) do
                        if c:IsA("Model") or c:IsA("BasePart") then
                            itemModel = c
                            break
                        end
                    end
                end
                if itemModel then return itemModel end
            end
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n == searchName or n:find(searchName, 1, true) then
            if obj:IsA("Model") or obj:IsA("BasePart") then
                if obj:FindFirstChildOfClass("ClickDetector") or obj:FindFirstChildOfClass("ProximityPrompt") then
                    return obj
                end
                for _, d in ipairs(obj:GetDescendants()) do
                    if d:IsA("ClickDetector") or d:IsA("ProximityPrompt") then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

local function buyItem(itemName)
    if buying then return end
    buying = true
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local savedPos = hrp.CFrame
        local itemObj = findItemInWorkspace(itemName)
        if itemObj then
            local cf = nil
            if itemObj:IsA("Model") then
                pcall(function() cf = itemObj:GetPivot() end)
            elseif itemObj:IsA("BasePart") then
                cf = itemObj.CFrame
            end
            if cf then
                hrp.CFrame = cf + Vector3.new(0, 3, 0)
                task.wait(0.3)
                for _, cd in ipairs(itemObj:GetDescendants()) do
                    if cd:IsA("ClickDetector") then
                        pcall(function() fireclickdetector(cd) end)
                    end
                end
                for _, pp in ipairs(itemObj:GetDescendants()) do
                    if pp:IsA("ProximityPrompt") then
                        pcall(function() pp.HoldDuration = 0 end)
                        pcall(function() fireproximityprompt(pp) end)
                    end
                end
                task.wait(3)
            end
        end
        hrp.CFrame = savedPos
    end)
    buying = false
end

local function interactAtPosition(position, itemName)
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local savedPos = hrp.CFrame
    hrp.CFrame = CFrame.new(position) + Vector3.new(0, 3, 0)
    task.wait(0.5)
    local foundPrompt = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local parent = obj.Parent
            if parent and (parent:IsA("MeshPart") or parent:IsA("Part") or parent:IsA("Model")) then
                local pp = parent:IsA("Model") and parent:GetPivot().Position or parent.Position
                if (pp - hrp.Position).Magnitude < 10 then
                    foundPrompt = obj
                    break
                end
            end
        end
    end
    if foundPrompt then
        pcall(function() foundPrompt.HoldDuration = 0 end)
        pcall(function() fireproximityprompt(foundPrompt) end)
    end
    task.wait(0.5)
    pcall(function() hrp.CFrame = savedPos end)
    return true
end

local tpPlayerNames = {}

local function refreshPlayerDropdown()
    table.clear(tpPlayerNames)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(tpPlayerNames, p.Name)
        end
    end
end
refreshPlayerDropdown()
Players.PlayerAdded:Connect(function() refreshPlayerDropdown() end)
Players.PlayerRemoving:Connect(function() refreshPlayerDropdown() end)

local TabGeneral = Window:Tab({
    Title = L.General,
    Icon = "settings",
})

TabGeneral:Toggle({
    Title = L.Fly,
    Callback = function(state)
        FlyingEnabled = state
        if FlyingEnabled then startFlying() else stopFlying() end
    end,
})

TabGeneral:Toggle({
    Title = L.Spin,
    Callback = function(state)
        SpinningEnabled = state
    end,
})

TabGeneral:Slider({
    Title = L.FlySpeed,
    Step = 1,
    Value = {
        Min = 1,
        Max = 200,
        Default = FlightSpeed,
    },
    Callback = function(val)
        FlightSpeed = val
    end,
})

TabGeneral:Slider({
    Title = L.SpinSpeed,
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = SpinSpeed,
    },
    Callback = function(val)
        SpinSpeed = val
    end,
})

TabGeneral:Toggle({
    Title = L.Speed,
    Callback = function(state)
        speedHackEnabled = state
    end,
})

TabGeneral:Slider({
    Title = L.Speed,
    Step = 1,
    Value = {
        Min = 16,
        Max = 500,
        Default = 16,
    },
    Callback = function(val)
        speedValue = val
    end,
})

TabGeneral:Toggle({
    Title = L.Noclip,
    Callback = function(state)
        noclipEnabled = state
    end,
})

TabGeneral:Toggle({
    Title = L.InfJump,
    Callback = function(state)
        infiniteJump = state
    end,
})

TabGeneral:Toggle({
    Title = L.FlySwim,
    Callback = function(state)
        flySwimEnabled = state
    end,
})

local TabCombat = Window:Tab({
    Title = L.Combat,
    Icon = "crosshair",
})

TabCombat:Toggle({
    Title = L.SilentAim,
    Callback = function(state)
        silentAimEnabled = state
    end,
})

TabCombat:Slider({
    Title = L.HitboxSize,
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 10,
    },
    Callback = function(val)
        hitboxSize = val
    end,
})

TabCombat:Colorpicker({
    Title = L.HitboxColor,
    Default = adornColor,
    Callback = function(color)
        adornColor = color
    end,
})

TabCombat:Slider({
    Title = L.FOV,
    Step = 1,
    Value = {
        Min = 50,
        Max = 1000,
        Default = 250,
    },
    Callback = function(val)
        fovRadius = val
        fovCircle.Radius = val
    end,
})

TabCombat:Toggle({
    Title = L.FOVShow,
    Callback = function(state)
        showFOV = state
        fovCircle.Visible = state
    end,
})

TabCombat:Dropdown({
    Title = L.AimPart,
    Values = {L.Head, "HumanoidRootPart", L.Torso, L.Random},
    Callback = function(val)
        aimPart = val
    end,
})

TabCombat:Toggle({
    Title = L.WallCheck,
    Callback = function(state)
        wallCheck = state
    end,
})

TabCombat:Slider({
    Title = L.HitChance,
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 100,
    },
    Callback = function(val)
        hitChance = val
    end,
})

TabCombat:Toggle({
    Title = L.Triggerbot,
    Callback = function(state)
        triggerbotEnabled = state
    end,
})

TabCombat:Toggle({
    Title = L.HitSound,
    Callback = function(state)
        hitSoundEnabled = state
    end,
})

TabCombat:Toggle({
    Title = L.BulletTracer,
    Callback = function(state)
        bulletTracerEnabled = state
    end,
})


TabCombat:Toggle({
    Title = L.GunScale,
    Default = false,
    Callback = function(state)
        gunScaleEnabled = state
        if not state then
            table.clear(scaled)
        end
    end,
})

TabCombat:Slider({
    Title = L.GunScaleMult,
    Step = 1,
    Value = {
        Min = 2,
        Max = 50,
        Default = 10,
    },
    Callback = function(val)
        gunScaleMultiplier = tonumber(val) or 10
        table.clear(scaled)
    end,
})
TabCombat:Colorpicker({
    Title = L.TracerColor,
    Default = tracerColor,
    Callback = function(color)
        tracerColor = color
    end,
})

local TabVisual = Window:Tab({
    Title = L.Visual,
    Icon = "eye",
})

TabVisual:Toggle({
    Title = L.ESP,
    Callback = function(state)
        espEnabled = state
    end,
})

TabVisual:Toggle({
    Title = L.Chams,
    Callback = function(state)
        chamsEnabled = state
    end,
})

TabVisual:Toggle({
    Title = L.FullBright,
    Callback = function(state)
        if state and not FBEX then
            setupHighlight()
        end
        FBE = state
    end,
})

TabVisual:Toggle({
    Title = L.NightVision,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.fromRGB(100, 100, 100)
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
        else
            Lighting.Ambient = Color3.fromRGB(70, 70, 70)
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
        end
    end,
})

TabVisual:Slider({
    Title = L.CameraFOV,
    Step = 1,
    Value = {
        Min = 1,
        Max = 140,
        Default = 70,
    },
    Callback = function(val)
        cameraFOV = val
    end,
})

TabVisual:Dropdown({
    Title = L.SkyTheme,
    Multi = false,
    AllowNone = false,
    Values = {L.SkyDefault, L.SkySunset, L.SkyNebula},
    Callback = function(val)
        skyTheme = val
        pcall(function() updateSky(val) end)
    end,
})

local TabKill = Window:Tab({
    Title = L.Kill,
    Icon = "swords",
})

TabKill:Toggle({
    Title = L.BladeAura,
    Callback = function(state)
        dartOn = state
        dartCleanupConnections()
        if dartOn then
            dartEquipNinjaStar()
            task.wait(0.1)
            dartInitThrow()
            dartConnections.Throw = RunService.RenderStepped:Connect(dartRapidThrowAttack)
        end
    end,
})

TabKill:Toggle({
    Title = L.BladeAuraTP,
    Callback = function(state)
        dartTeleportTargets = state
        if dartTeleportTargets then
            dartConnections.Teleport = RunService.RenderStepped:Connect(dartFastTeleport)
        end
    end,
})

TabKill:Toggle({
    Title = L.AutoBuyStar,
    Callback = function(state)
        starBuyEnabled = state
    end,
})

local killPlayerNames = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(killPlayerNames, p.Name)
    end
end

TabKill:Dropdown({
    Title = L.TPPlayer,
    Values = killPlayerNames,
    Callback = function(val)
        local target = Players:FindFirstChild(val)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end,
})

local function smartTP(keywords, fallbackPos)
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local searchName = type(keywords) == "table" and keywords or {keywords}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                for _, kw in ipairs(searchName) do
                    if n:find(kw:lower(), 1, true) then
                        hrp.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                        return
                    end
                end
            end
        end
        if fallbackPos then
            hrp.CFrame = typeof(fallbackPos) == "CFrame" and fallbackPos or CFrame.new(fallbackPos)
        end
    end)
end

local TabTeleport = Window:Tab({
    Title = L.Teleport,
    Icon = "map-pin",
})

TabTeleport:Button({
    Title = L.TPSpawn,
    Callback = function() smartTP({"Spawn","Respawn"}, CFrame.new(-607, 23, -280)) end,
})

TabTeleport:Button({
    Title = L.TPBank,
    Callback = function() smartTP({"Bank","Vault"}, CFrame.new(-441, 23, -286)) end,
})

TabTeleport:Button({
    Title = L.TPPolice,
    Callback = function() smartTP({"Police","Cop","Sheriff"}, CFrame.new(-266, 23, -99)) end,
})

TabTeleport:Button({
    Title = L.TPGunShop,
    Callback = function() smartTP({"Gun","Weapon","Shop"}, CFrame.new(-90, 23, -79)) end,
})

TabTeleport:Button({
    Title = L.TPHospital,
    Callback = function() smartTP({"Hospital","Medical"}, CFrame.new(113, 23, -478)) end,
})

TabTeleport:Button({
    Title = L.TPStore,
    Callback = function() smartTP({"Store","Market","Shop"}, CFrame.new(-67, 23, -592)) end,
})

TabTeleport:Button({
    Title = L.TPGas,
    Callback = function() smartTP({"Gas","Fuel","Petrol"}, CFrame.new(585, 23, -216)) end,
})

TabTeleport:Button({
    Title = L.TPPark,
    Callback = function() smartTP({"Park"}, CFrame.new(-139, 23, -1010)) end,
})

TabTeleport:Button({
    Title = L.TPGang,
    Callback = function() smartTP({"Gang","Criminal"}, CFrame.new(-802, 23, -313)) end,
})

TabTeleport:Button({
    Title = L.TPMil,
    Callback = function() smartTP({"Military","Army","Base"}, CFrame.new(769, 23, -418)) end,
})

TabTeleport:Button({
    Title = L.TPSewers,
    Callback = function() smartTP({"Sewer","Drain"}, CFrame.new(86, -26, -480)) end,
})

TabTeleport:Button({
    Title = L.TPRandom,
    Callback = function()
        findAndTP()
    end,
})

TabTeleport:Button({
    Title = L.TPUp,
    Callback = function()
        tpTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 50, 0))
    end,
})

TabTeleport:Button({
    Title = L.TPDown,
    Callback = function()
        tpTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, -50, 0))
    end,
})

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(tpPlayerNames, p.Name)
    end
end



TabTeleport:Dropdown({
    Title = L.TPPlayer,
    Values = tpPlayerNames,
    Callback = function(val)
        local target = Players:FindFirstChild(val)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end,
})

TabTeleport:Toggle({
    Title = "吸人",
    Callback = function(state)
        attract = state
        if attract then
            task.spawn(attractLoop)
        end
    end,
})


local buying = false

local TabBuy = Window:Tab({
    Title = L.Buy,
    Icon = "shopping-cart",
})

TabBuy:Button({
    Title = L.BuyFlame,
    Callback = function()
        task.spawn(function() buyItem("Flamethrower") end)
    end,
})

TabBuy:Button({
    Title = L.BuyRay,
    Callback = function()
        task.spawn(function() buyItem("Ray Gun") end)
    end,
})

TabBuy:Button({
    Title = L.BuyAK,
    Callback = function()
        task.spawn(function() buyItem("AK-47") end)
    end,
})

TabBuy:Button({
    Title = L.BuyDeagle,
    Callback = function()
        task.spawn(function() buyItem("Desert Eagle") end)
    end,
})

TabBuy:Button({
    Title = L.BuyUzi,
    Callback = function()
        task.spawn(function() buyItem("Uzi") end)
    end,
})

TabBuy:Button({
    Title = L.BuyMoss,
    Callback = function()
        task.spawn(function() buyItem("Mossberg 500") end)
    end,
})

TabBuy:Button({
    Title = L.BuyLock,
    Callback = function()
        task.spawn(function() buyItem("Lockpick") end)
    end,
})

TabBuy:Button({
    Title = L.BuyArmor,
    Callback = function()
        task.spawn(function() buyItem("Armor") end)
    end,
})

TabBuy:Button({
    Title = L.BuyStar,
    Callback = function()
        task.spawn(function() buyItem("Ninja Star") end)
    end,
})

TabBuy:Dropdown({
    Title = L.BuyItem,
    Values = {
        "Flamethrower", "Ray Gun", "AK-47", "Desert Eagle", "Uzi",
        "Mossberg 500", "Lockpick", "Armor", "Ninja Star",
        "Sword", "Bat", "Crowbar", "Pistol", "Shotgun",
        "RPG", "Grenade", "Medkit", "Donut", "Pizza",
        "Weights", "Key", "Taser"
    },
    Callback = function(val)
        buyItem(val)
    end,
})

local TabMoney = Window:Tab({
    Title = L.Money,
    Icon = "coins",
})

TabMoney:Toggle({
    Title = L.AutoFarm,
    Callback = function(state)
        autoFarmEnabled = state
        if autoFarmEnabled then
            task.spawn(function()
                while autoFarmEnabled do
                    local success, err = pcall(function()
                        if not autoFarmEnabled then return end
                        local char = LocalPlayer.Character
                        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                        for _, drop in ipairs(workspace:GetDescendants()) do
                            if not autoFarmEnabled then break end
                            if drop:IsA("BasePart") and drop.Name == "Cash" or drop.Name == "MoneyDrop" then
                                char.HumanoidRootPart.CFrame = CFrame.new(drop.Position)
                                task.wait(0.1)
                                firetouchinterest(char.HumanoidRootPart, drop, 0)
                                firetouchinterest(char.HumanoidRootPart, drop, 1)
                                task.wait(0.1)
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end,
})

TabMoney:Toggle({
    Title = L.AutoRob,
    Callback = function(state)
        autoRobBankEnabled = state
        if autoRobBankEnabled then
            task.spawn(function()
                while autoRobBankEnabled do
                    local success, err = pcall(function()
                        if not autoRobBankEnabled then return end
                        local char = LocalPlayer.Character
                        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                        for _, door in ipairs(workspace:GetDescendants()) do
                            if not autoRobBankEnabled then break end
                            if door:IsA("BasePart") and (door.Name == "BankDoor" or door.Name:find("Vault")) then
                                char.HumanoidRootPart.CFrame = CFrame.new(door.Position)
                                task.wait(0.5)
                                if door:FindFirstChild("ClickDetector") then
                                    fireclickdetector(door.ClickDetector)
                                end
                                if door:FindFirstChild("ProximityPrompt") then
                                    fireproximityprompt(door.ProximityPrompt)
                                end
                                task.wait(0.5)
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})

TabMoney:Toggle({
    Title = L.AutoATM,
    Callback = function(state)
        autoATMEnabled = state
        if autoATMEnabled then
            task.spawn(function()
                while autoATMEnabled do
                    local success, err = pcall(function()
                        if not autoATMEnabled then return end
                        local char = LocalPlayer.Character
                        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                        for _, atm in ipairs(workspace:GetDescendants()) do
                            if not autoATMEnabled then break end
                            if atm:IsA("BasePart") and atm.Name:find("ATM") then
                                char.HumanoidRootPart.CFrame = CFrame.new(atm.Position)
                                task.wait(0.3)
                                if atm:FindFirstChild("ClickDetector") then
                                    fireclickdetector(atm.ClickDetector)
                                end
                                if atm:FindFirstChild("ProximityPrompt") then
                                    fireproximityprompt(atm.ProximityPrompt)
                                end
                                task.wait(0.3)
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})


pcall(function() WindUI:SetFont("rbxassetid://12187376739") end)

local defaultFont
pcall(function() defaultFont = Font.new("rbxassetid://12187374765", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal) end)

local function fixTopbar()
    pcall(function()
        local topbar = Window.UIElements.Main.Main:WaitForChild("Topbar", 3)
        for _, child in ipairs(topbar:GetDescendants()) do
            pcall(function() if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then if defaultFont then child.FontFace = defaultFont end end end)
        end
        topbar.DescendantAdded:Connect(function(child)
            pcall(function() if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then if defaultFont then child.FontFace = defaultFont end end end)
        end)
    end)
end

local function fixOpenButton()
    task.spawn(function()
        repeat task.wait(0.1) until Window.OpenButtonMain and Window.OpenButtonMain.Button
        local btn = Window.OpenButtonMain.Button
        for _, child in ipairs(btn:GetDescendants()) do
            pcall(function() if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then if defaultFont then child.FontFace = defaultFont end end end)
        end
        btn.DescendantAdded:Connect(function(child)
            pcall(function() if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then if defaultFont then child.FontFace = defaultFont end end end)
        end)
    end)
end

fixTopbar()
fixOpenButton()

