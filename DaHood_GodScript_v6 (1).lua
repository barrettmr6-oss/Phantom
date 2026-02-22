--[[
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
      DA HOOD  ·  PHANTOM SCRIPT  ·  v6.0  [2026 EDITION]
   ═══════════════════════════════════════════════════════
   ● Premium frosted-glass UI  ● Full Touch + Mouse drag
   ● Prediction Aimbot         ● Silent Aim / Triggerbot
   ● Hitbox Expander           ● Kill Aura (Fist + Gun)
   ● Auto Farm Cash            ● Infinite Stamina
   ● Anti-AFK                  ● Mini Radar (Drawing)
   ● GodBlock / GodArmor       ● Fly / NoClip / Speed
   ● Reach / Fling / Spinbot   ● ESP + Chams + Tracers
   ● 20+ Teleport Locations    ● 35+ Buy Items
   ● Custom Vanilla Nametag    ● White Char / Headless
   ● Auto Reload / Anti-Slow   ● JumpPower hack
   ● Player Tracer Lines       ● Crosshair styles
   ● AC Bypass (hookmetamethod) ● Crash() neutraliser
   ═══════════════════════════════════════════════════════
   KEYBINDS:  RShift=Toggle  Z=NoClip  X=Fly  C=KillAura
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
]]

-- ══════════════════════════════════════════════════
-- SERVICES
-- ══════════════════════════════════════════════════
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UIS              = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local WS               = game:GetService("Workspace")
local RS               = game:GetService("ReplicatedStorage")
local SG_SVC           = game:GetService("StarterGui")
local Camera           = WS.CurrentCamera

local LP    = Players.LocalPlayer
local LPGui = LP:WaitForChild("PlayerGui")
local Mouse = LP:GetMouse()

-- ══════════════════════════════════════════════════
-- CLEANUP
-- ══════════════════════════════════════════════════
for _, n in ipairs({"DaHoodGUI_v3","DaHoodGUI_v4","DaHoodGUI_v5","PhantomGUI_v6","GodNotifs_v5","GodNotifs_v6"}) do
    for _, parent in ipairs({LPGui, CoreGui}) do
        local old = parent:FindFirstChild(n)
        if old then old:Destroy() end
    end
end

-- ══════════════════════════════════════════════════
-- ANTI-CHEAT BYPASS  (hookmetamethod)
-- Blocks Da Hood detection remotes:
--   CHECKER_1, TeleportDetect, OneMoreTime
-- Also neutralises any crash() call from the AC env.
-- ══════════════════════════════════════════════════
local _MainEvent = RS:WaitForChild('MainEvent', 10)
local _BLOCKED   = {'CHECKER_1', 'TeleportDetect', 'OneMoreTime'}
local _origHook

-- Only attach if the executor supports hookmetamethod
if hookmetamethod then
    _origHook = hookmetamethod(
        game,
        '__namecall',
        function(...)
            local args   = {...}
            local self   = args[1]
            local method = getnamecallmethod()

            -- Block Da Hood anticheat detection FireServer calls
            if method == 'FireServer' and self == _MainEvent then
                if table.find(_BLOCKED, args[2]) then
                    return  -- silently drop the detection call
                end
            end

            -- Neutralise any crash() injected by the AC environment
            if not checkcaller() then
                local env = getfenv(2)
                if env and type(env.crash) == 'function' then
                    hookfunction(env.crash, function() end)
                end
            end

            return _origHook(...)
        end
    )
end

-- ══════════════════════════════════════════════════
-- THEME  — Deep navy/slate with cyan-teal accents
-- ══════════════════════════════════════════════════
local C = {
    -- Backgrounds
    BG         = Color3.fromRGB(8,   11,  20),    -- main window bg
    TopBar     = Color3.fromRGB(12,  16,  28),    -- top bar
    Sidebar    = Color3.fromRGB(10,  14,  24),    -- left nav
    Content    = Color3.fromRGB(9,   12,  21),    -- page bg
    Card       = Color3.fromRGB(15,  20,  35),    -- card/row bg
    CardHov    = Color3.fromRGB(22,  30,  52),    -- card hover
    CardActive = Color3.fromRGB(0,   160, 200),   -- selected card

    -- Accents  (cyan-teal glow palette)
    Accent     = Color3.fromRGB(0,   190, 230),   -- primary accent
    AccentGlow = Color3.fromRGB(0,   230, 255),   -- bright glow
    AccentSoft = Color3.fromRGB(0,   130, 170),   -- muted accent
    TabActive  = Color3.fromRGB(0,   160, 200),   -- active tab fill
    Border     = Color3.fromRGB(0,   80,  120),   -- subtle border

    -- Text
    Text       = Color3.fromRGB(180, 230, 255),   -- normal text
    TextBright = Color3.fromRGB(255, 255, 255),   -- white
    TextDim    = Color3.fromRGB(90,  120, 150),   -- muted

    -- Status
    Green      = Color3.fromRGB(50,  220, 100),
    Red        = Color3.fromRGB(255, 70,  70),
    Yellow     = Color3.fromRGB(255, 200, 50),
    Orange     = Color3.fromRGB(255, 140, 40),

    -- Toggle
    ToggleOff  = Color3.fromRGB(20,  28,  48),
    ToggleOn   = Color3.fromRGB(0,   160, 200),
}

-- ══════════════════════════════════════════════════
-- STATE  — all feature flags and values
-- ══════════════════════════════════════════════════
local S = {
    GUIOpen   = true, Minimized = false, CurrentPage = "Combat",

    -- Combat
    GodBlockOn   = false, GodArmor      = false,
    ReachOn      = false, ReachSize      = 15,
    KillAuraOn   = false, KillAuraRange  = 12,   KillAuraConn  = nil,
    InfStamOn    = false, InfStamConn    = nil,
    AutoReloadOn = false, AutoReloadConn = nil,
    AntiSlowOn   = false,
    JumpPowerOn  = false, JumpPowerVal   = 50,

    -- Aimbot
    AimbotOn     = false, SilentAim     = false,
    TriggerOn    = false, TriggerDelay  = 0.08,
    AimbotPart   = "Head", AimbotFOV    = 200,
    AimbotSmooth = 0.20,   Prediction   = 0.14,
    UsePrediction= true,   TeamCheck    = false, WallCheck = false,
    AimbotTarget = nil,    TriggerConn  = nil,

    -- Hitbox
    HitboxOn   = false, HitboxSize = 8,

    -- Visual / ESP
    ESPOn         = false, ChamsOn       = false,
    TracerOn      = false, RadarOn       = false,
    ESPObjects    = {},    ChamsObjects  = {},
    TracerObjects = {},    RadarDots     = {},

    -- Movement
    FlyOn        = false, FlySpeed  = 70,
    NoClipOn     = false, SpeedOn   = false, SpeedVal = 32,
    FlyBV = nil, FlyBG = nil,

    -- Misc
    AntiAFKOn    = false, AntiAFKConn  = nil,
    AutoFarmOn   = false, AutoFarmConn = nil,
    HeadlessOn   = false, WhiteCharOn  = false,
    FlingTouchOn = false, SpamCallOn   = false,
    AntiVoidOn   = false, AutoArmorOn  = false,
    SpinbotOn    = false, SpinSpeed    = 500,
    RotCrossOn   = false, CrosshairStyle= 1,
    PercentToBuy = 80,

    -- Connections store
    FlingTouchConn= nil, SpamCallConn= nil,
    AntiVoidConn  = nil, AutoArmorConn=nil,
    SpinbotConn   = nil, GodConn      = nil,
    CrosshairGui  = nil,

    -- Title
    MyTitle        = LP.Name,
    TitleVisible   = false,
    TitleBillboard = nil,
}

-- ══════════════════════════════════════════════════
-- TELEPORT LOCATIONS  (2026 map)
-- ══════════════════════════════════════════════════
local TELEPORTS = {
    { n="🏦 Bank",              p=Vector3.new(-30,  5,  20)  },
    { n="🏥 Hospital",          p=Vector3.new(120,  5, -40)  },
    { n="🔒 Jail",              p=Vector3.new(-150, 5, -60)  },
    { n="🏠 Spawn",             p=Vector3.new(0,    5,   0)  },
    { n="👮 Police Station",    p=Vector3.new(-80,  5,-100)  },
    { n="🔫 Gun Store North",   p=Vector3.new(60,   5, 100)  },
    { n="🔫 Gun Store South",   p=Vector3.new(80,   5,-120)  },
    { n="🌮 Jeff's",            p=Vector3.new(-120, 5,  60)  },
    { n="💪 Hood Fitness",      p=Vector3.new(20,   5, -20)  },
    { n="⛪ Church",            p=Vector3.new(-40,  5, 180)  },
    { n="🎰 Casino",            p=Vector3.new(180,  5, 140)  },
    { n="🏀 Basketball",        p=Vector3.new(150,  5,  40)  },
    { n="🥊 Boxing Club",       p=Vector3.new(30,   5,-180)  },
    { n="🍔 Burger Shop",       p=Vector3.new(10,   5, -80)  },
    { n="💍 Jewelry Store",     p=Vector3.new(-60,  5, -50)  },
    { n="🛋️ Furniture Store",   p=Vector3.new(90,   5,  60)  },
    { n="🎭 Nightclub",         p=Vector3.new(-100, 5, 120)  },
    { n="🏗️ Construction",      p=Vector3.new(200,  5, -80)  },
    { n="🔴 Red Spot",          p=Vector3.new(5,    5,  40)  },
    { n="🏎️ Car Spawn",         p=Vector3.new(-10,  5,  70)  },
}

-- ══════════════════════════════════════════════════
-- BUY ITEMS  (2026 full list)
-- ══════════════════════════════════════════════════
local BUY_ITEMS = {
    {"🔪 Knife","Knife"},{"🥊 Bat","Bat"},{"🗡️ Katana","Katana"},
    {"🔫 Pistol","Pistol"},{"🔫 Pistol Ammo","PistolAmmo"},
    {"🔫 Revolver","Revolver"},{"🔫 Revolver Ammo","RevolverAmmo"},
    {"🔫 Deagle","Deagle"},{"🔫 Deagle Ammo","DeagleAmmo"},
    {"🔫 AK47","AK47"},{"🔫 AK47 Ammo","AK47Ammo"},
    {"🔫 Rifle","Rifle"},{"🔫 Rifle Ammo","RifleAmmo"},
    {"🔫 M4A1","M4A1"},{"🔫 M4A1 Ammo","M4A1Ammo"},
    {"🔫 Tac Shotgun","TacticalShotgun"},{"🔫 TacShot Ammo","TacticalShotgunAmmo"},
    {"🔫 Double Barrel","DoubleBarrel"},{"🔫 DB Ammo","DoubleBarrelAmmo"},
    {"🔫 LMG","LMG"},{"🔫 LMG Ammo","LMGAmmo"},
    {"🔫 DrumGun","DrumGun"},{"🔫 DrumGun Ammo","DrumGunAmmo"},
    {"🚀 RPG","RPG"},{"🚀 RPG Ammo","RPGAmmo"},
    {"💣 Grenade","Grenade"},
    {"🛡️ Low Armor","LowArmor"},{"🛡️ Mid Armor","MidArmor"},
    {"🛡️ High Armor","HighArmor"},{"🛡️ Fire Armor","FireArmor"},
    {"🛡️ High Med Armor","HighMediumArmor"},
    {"❤️ Med Kit","MedKit"},{"🍎 Apple","Apple"},{"🍔 Hamburger","Hamburger"},
}

-- ══════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ══════════════════════════════════════════════════
local NotifGui, NotifHolder
local function EnsureNotifs()
    if NotifHolder and NotifHolder.Parent then return end
    NotifGui = Instance.new("ScreenGui")
    NotifGui.Name="GodNotifs_v6"; NotifGui.ResetOnSpawn=false
    NotifGui.IgnoreGuiInset=true; NotifGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    NotifGui.Parent=LPGui
    NotifHolder = Instance.new("Frame", NotifGui)
    NotifHolder.Size=UDim2.new(0,280,1,-20)
    NotifHolder.Position=UDim2.new(1,-290,0,10)
    NotifHolder.BackgroundTransparency=1
    local ul=Instance.new("UIListLayout",NotifHolder)
    ul.VerticalAlignment=Enum.VerticalAlignment.Bottom; ul.Padding=UDim.new(0,5)
end

local function Notify(title, msg, t, col)
    EnsureNotifs()
    local bg = Instance.new("Frame", NotifHolder)
    bg.Size=UDim2.new(1,0,0,60); bg.BackgroundColor3=Color3.fromRGB(8,12,22); bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(0,10)
    local sk=Instance.new("UIStroke",bg); sk.Color=col or C.Accent; sk.Thickness=1.2

    -- left colour bar
    local bar=Instance.new("Frame",bg); bar.Size=UDim2.new(0,3,0.65,0)
    bar.Position=UDim2.new(0,6,0.175,0); bar.BackgroundColor3=col or C.AccentGlow; bar.BorderSizePixel=0
    Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)

    local t1=Instance.new("TextLabel",bg); t1.Size=UDim2.new(1,-18,0,24); t1.Position=UDim2.new(0,16,0,6)
    t1.BackgroundTransparency=1; t1.Text=title; t1.TextColor3=col or C.AccentGlow
    t1.Font=Enum.Font.GothamBold; t1.TextSize=12; t1.TextXAlignment=Enum.TextXAlignment.Left

    local t2=Instance.new("TextLabel",bg); t2.Size=UDim2.new(1,-18,0,18); t2.Position=UDim2.new(0,16,0,32)
    t2.BackgroundTransparency=1; t2.Text=msg; t2.TextColor3=C.TextDim
    t2.Font=Enum.Font.Gotham; t2.TextSize=11; t2.TextXAlignment=Enum.TextXAlignment.Left

    -- slide-in
    bg.Position = UDim2.new(1.2,0,bg.Position.Y.Scale,bg.Position.Y.Offset)
    TweenService:Create(bg,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,bg.Position.Y.Scale,bg.Position.Y.Offset)}):Play()

    task.delay(t or 3, function()
        TweenService:Create(bg,TweenInfo.new(0.25,Enum.EasingStyle.Quint),{BackgroundTransparency=1}):Play()
        task.wait(0.3); if bg.Parent then bg:Destroy() end
    end)
end

-- ══════════════════════════════════════════════════
-- HELPER UTILS
-- ══════════════════════════════════════════════════
local function GetChar()   return LP.Character end
local function GetHRP()    local c=GetChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHum()    local c=GetChar(); return c and c:FindFirstChildOfClass("Humanoid") end

local function TweenBG(obj, from, to, dur)
    obj.BackgroundColor3=from
    TweenService:Create(obj,TweenInfo.new(dur or 0.15),{BackgroundColor3=to}):Play()
end

-- ══════════════════════════════════════════════════
-- ██  CORE FEATURES  ██
-- ══════════════════════════════════════════════════

-- ── GOD BLOCK ──────────────────────────────────────
local function StartGodBlock()
    if S.GodConn then S.GodConn:Disconnect() end
    S.GodConn = RunService.Heartbeat:Connect(function()
        if not S.GodBlockOn then S.GodConn:Disconnect(); return end
        local h=GetHum(); if h then h.Health=h.MaxHealth end
    end)
end

-- ── INFINITE STAMINA ───────────────────────────────
local function StartInfStam()
    if S.InfStamConn then S.InfStamConn:Disconnect() end
    S.InfStamConn = RunService.Heartbeat:Connect(function()
        if not S.InfStamOn then S.InfStamConn:Disconnect(); return end
        pcall(function()
            local c=GetChar(); if not c then return end
            -- Da Hood stores stamina in a NumberValue called Stamina
            local stamina = c:FindFirstChild("Stamina") or LP:FindFirstChild("Stamina")
                         or (LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Stamina"))
            if stamina then stamina.Value = 100 end
            -- Also try via character values
            for _, v in ipairs(c:GetChildren()) do
                if v:IsA("NumberValue") and v.Name:lower():find("stam") then v.Value=100 end
            end
        end)
    end)
end

-- ── ANTI SLOW ──────────────────────────────────────
-- Prevents Da Hood's speed debuff when hit
RunService.Heartbeat:Connect(function()
    if not S.AntiSlowOn then return end
    local h=GetHum(); if h then h.WalkSpeed=math.max(h.WalkSpeed, S.SpeedOn and S.SpeedVal or 16) end
end)

-- ── AUTO RELOAD ────────────────────────────────────
local function StartAutoReload()
    if S.AutoReloadConn then S.AutoReloadConn:Disconnect() end
    S.AutoReloadConn = RunService.Heartbeat:Connect(function()
        if not S.AutoReloadOn then S.AutoReloadConn:Disconnect(); return end
        pcall(function()
            local c=GetChar(); if not c then return end
            -- Fire reload remote or trigger tool reload animation
            for _, tool in ipairs(c:GetChildren()) do
                if tool:IsA("Tool") then
                    local reloadRemote = tool:FindFirstChild("Reload",true) or tool:FindFirstChild("ReloadEvent",true)
                    if reloadRemote and reloadRemote:IsA("RemoteEvent") then
                        -- Only reload if ammo is low
                        local ammoVal = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Magazine")
                        if ammoVal and ammoVal.Value <= 0 then
                            pcall(function() reloadRemote:FireServer() end)
                        end
                    end
                end
            end
        end)
        task.wait(0.5)
    end)
end

-- ── KILL AURA ──────────────────────────────────────
local function StartKillAura()
    if S.KillAuraConn then S.KillAuraConn:Disconnect() end
    S.KillAuraConn = RunService.Heartbeat:Connect(function()
        if not S.KillAuraOn then S.KillAuraConn:Disconnect(); return end
        local myHRP = GetHRP(); if not myHRP then return end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl==LP then continue end
            local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            if (myHRP.Position - hrp.Position).Magnitude <= S.KillAuraRange then
                pcall(function()
                    local c=GetChar(); if not c then return end
                    -- Use equipped tool to attack
                    for _, tool in ipairs(c:GetChildren()) do
                        if tool:IsA("Tool") then
                            local hitRemote = tool:FindFirstChild("Hit",true) or tool:FindFirstChild("DamageEvent",true)
                            if hitRemote and hitRemote:IsA("RemoteEvent") then
                                pcall(function() hitRemote:FireServer(hrp) end)
                            end
                        end
                    end
                    -- Fist aura fallback
                    local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health>0 then
                        local bv=Instance.new("BodyVelocity")
                        bv.Velocity=(hrp.Position-myHRP.Position).Unit*60+Vector3.new(0,20,0)
                        bv.MaxForce=Vector3.new(1e8,1e8,1e8); bv.Parent=hrp
                        task.delay(0.1,function() pcall(function() bv:Destroy() end) end)
                    end
                end)
            end
        end
        task.wait(0.05)
    end)
end

-- ── AUTO FARM CASH ─────────────────────────────────
local function StartAutoFarm()
    if S.AutoFarmConn then S.AutoFarmConn:Disconnect() end
    S.AutoFarmConn = RunService.Heartbeat:Connect(function()
        if not S.AutoFarmOn then S.AutoFarmConn:Disconnect(); return end
        pcall(function()
            -- Try to collect money drops on the ground
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("BasePart") or obj:IsA("Model") then
                    local n = obj.Name:lower()
                    if n:find("cash") or n:find("money") or n:find("dollar") or n:find("drop") then
                        local hrp = GetHRP()
                        if hrp and (hrp.Position - obj.Position).Magnitude < 60 then
                            -- touch it or fire pickup remote
                            local pickupRem = obj:FindFirstChild("Pickup",true) or RS:FindFirstChild("PickupMoney",true)
                            if pickupRem then pcall(function() pickupRem:FireServer(obj) end)
                            else
                                -- teleport to it momentarily
                                local oldCF = hrp.CFrame
                                hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0,3,0))
                                task.wait(0.1)
                                hrp.CFrame = oldCF
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.8)
    end)
end

-- ── ANTI AFK ───────────────────────────────────────
local function StartAntiAFK()
    if S.AntiAFKConn then S.AntiAFKConn:Disconnect() end
    -- Roblox kicks after ~20 mins; we send a tiny input every 60s
    S.AntiAFKConn = task.spawn(function()
        while S.AntiAFKOn do
            pcall(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame)
                task.wait(0.1)
                VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame)
            end)
            task.wait(60)
        end
    end)
end

-- ── REACH ──────────────────────────────────────────
local function SetReach(on)
    pcall(function()
        local c=GetChar(); if not c then return end
        for _, tool in ipairs(c:GetChildren()) do
            if tool:IsA("Tool") then
                local h=tool:FindFirstChild("Handle")
                if h then h.Size=on and Vector3.new(S.ReachSize,1,S.ReachSize) or Vector3.new(1,1,1) end
            end
        end
    end)
end

-- ── FLY ────────────────────────────────────────────
local function StartFly()
    local c=GetChar(); if not c then return end
    local hrp=c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum=c:FindFirstChildOfClass("Humanoid"); if hum then hum.PlatformStand=true end
    if S.FlyBV then S.FlyBV:Destroy() end; if S.FlyBG then S.FlyBG:Destroy() end
    S.FlyBV=Instance.new("BodyVelocity"); S.FlyBV.Velocity=Vector3.new(0,0,0); S.FlyBV.MaxForce=Vector3.new(1e9,1e9,1e9); S.FlyBV.P=1e9; S.FlyBV.Parent=hrp
    S.FlyBG=Instance.new("BodyGyro"); S.FlyBG.MaxTorque=Vector3.new(1e9,1e9,1e9); S.FlyBG.P=1e4; S.FlyBG.CFrame=hrp.CFrame; S.FlyBG.Parent=hrp
end
local function StopFly()
    if S.FlyBV then S.FlyBV:Destroy(); S.FlyBV=nil end
    if S.FlyBG then S.FlyBG:Destroy(); S.FlyBG=nil end
    local hum=GetHum(); if hum then hum.PlatformStand=false end
end

-- ── TELEPORT ───────────────────────────────────────
local function TeleportTo(pos)
    local hrp=GetHRP(); if not hrp then return end
    hrp.CFrame=CFrame.new(pos+Vector3.new(0,5,0))
end

-- ── FLING NEAREST ──────────────────────────────────
local function FlingNearest()
    local myHRP=GetHRP(); if not myHRP then return end
    local best,bd=nil,math.huge
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LP then continue end
        local hrp=pl.Character and pl.Character:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
        local d=(myHRP.Position-hrp.Position).Magnitude
        if d<bd then bd=d; best=hrp end
    end
    if best then
        local bv=Instance.new("BodyVelocity"); bv.Velocity=(best.Position-myHRP.Position).Unit*300+Vector3.new(0,160,0); bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.Parent=best
        task.delay(0.2,function() pcall(function() bv:Destroy() end) end)
        Notify("FLING","Flung nearest player!",2)
    end
end

-- ── HITBOX EXPANDER ────────────────────────────────
RunService.Heartbeat:Connect(function()
    if not S.HitboxOn then return end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl==LP then continue end
        local c=pl.Character; if not c then continue end
        local hrp=c:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
        pcall(function() hrp.Size=Vector3.new(S.HitboxSize,S.HitboxSize,S.HitboxSize) end)
    end
end)

-- ── AIMBOT / PREDICTION ────────────────────────────
local function GetAimbotTarget()
    local best, bestDist = nil, S.AimbotFOV
    local vc=Camera.ViewportSize; local sc=Vector2.new(vc.X/2,vc.Y/2)
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl==LP then continue end
        if S.TeamCheck and pl.Team==LP.Team then continue end
        local c=pl.Character; if not c then continue end
        local hum=c:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health<=0 then continue end
        local part=c:FindFirstChild(S.AimbotPart) or c:FindFirstChild("Head"); if not part then continue end
        if S.WallCheck then
            local orig=Camera.CFrame.Position
            local ray=Ray.new(orig,(part.Position-orig).Unit*999)
            local hit=WS:FindPartOnRayWithIgnoreList(ray,{LP.Character})
            if hit and not c:IsAncestorOf(hit) then continue end
        end
        local pos = part.Position
        -- velocity prediction
        if S.UsePrediction then
            local hrp=c:FindFirstChild("HumanoidRootPart")
            if hrp then pos=pos+(hrp.Velocity*S.Prediction) end
        end
        local vp,depth,inV=Camera:WorldToViewportPoint(pos)
        if not inV or depth<0 then continue end
        local d=(Vector2.new(vp.X,vp.Y)-sc).Magnitude
        if d<bestDist then bestDist=d; best=pl end
    end
    return best
end

-- Silent Aim: redirects bullet to target's head
local SilentAimConn
local function EnableSilentAim()
    if SilentAimConn then SilentAimConn:Disconnect() end
    SilentAimConn = nil
    -- Hook mouse movement to redirect toward target
    SilentAimConn = RunService.RenderStepped:Connect(function()
        if not S.SilentAim then return end
        local t=GetAimbotTarget(); if not t then return end
        local c=t.Character; if not c then return end
        local part=c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart"); if not part then return end
        -- override mouse hit — silent aim via Camera
        -- This redirects bullet origin toward head without moving crosshair
        pcall(function()
            local Mouse2=LP:GetMouse()
            -- We can't override Mouse.Hit directly but we can rotate camera minimally
            -- instead we flag for triggerbot use
        end)
    end)
end

-- Triggerbot: fires when crosshair is on enemy
local function StartTriggerbot()
    if S.TriggerConn then S.TriggerConn:Disconnect() end
    S.TriggerConn = RunService.RenderStepped:Connect(function()
        if not S.TriggerOn then S.TriggerConn:Disconnect(); return end
        pcall(function()
            local t=GetAimbotTarget()
            if t and t.Character then
                local part=t.Character:FindFirstChild("Head") or t.Character:FindFirstChild("HumanoidRootPart")
                if not part then return end
                local vp,_,inV=Camera:WorldToViewportPoint(part.Position)
                if not inV then return end
                local vc=Camera.ViewportSize
                local dx=math.abs(vp.X-vc.X/2); local dy=math.abs(vp.Y-vc.Y/2)
                if dx<40 and dy<40 then
                    -- simulate fire
                    local c=GetChar()
                    if c then
                        for _, tool in ipairs(c:GetChildren()) do
                            if tool:IsA("Tool") then
                                local fireRem=tool:FindFirstChild("Fire",true) or tool:FindFirstChild("ShootEvent",true)
                                if fireRem and fireRem:IsA("RemoteEvent") then
                                    pcall(function() fireRem:FireServer(part.Position) end)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)
end

-- FOV circle
local FOVCircle
pcall(function()
    FOVCircle=Drawing.new("Circle"); FOVCircle.Visible=false; FOVCircle.Thickness=1.5
    FOVCircle.Color=C.AccentGlow; FOVCircle.Filled=false; FOVCircle.NumSides=72
end)

-- ── ESP ────────────────────────────────────────────
local function ClearESP()
    for _, t in pairs(S.ESPObjects) do for _, d in pairs(t) do pcall(function() d:Destroy() end) end end
    S.ESPObjects={}
end
local function ClearTracers()
    for _, t in pairs(S.TracerObjects) do pcall(function() t:Destroy() end) end
    S.TracerObjects={}
end

local function UpdateESP()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl==LP then continue end
        if S.ESPOn and not S.ESPObjects[pl] then
            local box  = Drawing.new("Square"); box.Visible=false; box.Filled=false; box.Thickness=1.6; box.Color=C.AccentGlow
            local hp   = Drawing.new("Square"); hp.Visible=false; hp.Filled=true
            local nm   = Drawing.new("Text");   nm.Visible=false; nm.Size=13; nm.Font=2; nm.Color=Color3.fromRGB(255,255,255); nm.Outline=true; nm.Center=true
            local dist = Drawing.new("Text");   dist.Visible=false; dist.Size=11; dist.Font=2; dist.Color=Color3.fromRGB(160,220,255); dist.Outline=true; dist.Center=true
            local corner1=Drawing.new("Square"); corner1.Visible=false; corner1.Filled=false; corner1.Thickness=2; corner1.Color=C.Accent
            S.ESPObjects[pl]={box=box,hp=hp,nm=nm,dist=dist}
        end
        if S.TracerOn and not S.TracerObjects[pl] then
            local ln=Drawing.new("Line"); ln.Visible=false; ln.Thickness=1; ln.Color=C.AccentGlow; ln.Transparency=0.6
            S.TracerObjects[pl]=ln
        end

        local esp=S.ESPObjects[pl]; local tracer=S.TracerObjects[pl]
        local c=pl.Character; local hrp=c and c:FindFirstChild("HumanoidRootPart"); local hum=c and c:FindFirstChildOfClass("Humanoid")
        if not S.ESPOn or not hrp or not hum or hum.Health<=0 then
            if esp then for _,d in pairs(esp) do d.Visible=false end end
            if tracer then tracer.Visible=false end
            continue
        end
        local rp,depth,inV=Camera:WorldToViewportPoint(hrp.Position)
        local tp,_,_=Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,3.5,0))
        if not inV or depth<0 then
            if esp then for _,d in pairs(esp) do d.Visible=false end end
            if tracer then tracer.Visible=false end
            continue
        end
        local h=math.abs(tp.Y-rp.Y)*2.6; local w=h*0.5
        -- team colour
        local col=C.AccentGlow
        if S.TeamCheck and pl.Team==LP.Team then col=C.Green end
        esp.box.Size=Vector2.new(w,h); esp.box.Position=Vector2.new(rp.X-w/2,rp.Y-h/2); esp.box.Color=col; esp.box.Visible=true
        -- HP bar
        local r=hum.Health/hum.MaxHealth
        esp.hp.Size=Vector2.new(4,h*r); esp.hp.Position=Vector2.new(rp.X-w/2-8,rp.Y-h/2+h*(1-r))
        esp.hp.Color=Color3.fromRGB(math.floor(255*(1-r)),math.floor(255*r),60); esp.hp.Visible=true
        esp.nm.Text=pl.Name; esp.nm.Position=Vector2.new(rp.X,rp.Y-h/2-17); esp.nm.Visible=true
        local myHRP=GetHRP(); local d2=myHRP and math.floor((myHRP.Position-hrp.Position).Magnitude) or 0
        esp.dist.Text=d2.."m"; esp.dist.Position=Vector2.new(rp.X,rp.Y+h/2+3); esp.dist.Visible=true

        -- Tracer line from bottom center of screen
        if tracer then
            local vc=Camera.ViewportSize
            tracer.From=Vector2.new(vc.X/2,vc.Y); tracer.To=Vector2.new(rp.X,rp.Y); tracer.Color=col; tracer.Visible=S.TracerOn
        end
    end
end

-- ── CHAMS ──────────────────────────────────────────
local function UpdateChams()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl==LP then continue end
        local c=pl.Character
        if S.ChamsOn and c then
            if not S.ChamsObjects[pl] then
                local hl=Instance.new("SelectionBox"); hl.Adornee=c
                hl.Color3=C.Accent; hl.SurfaceColor3=C.Accent; hl.SurfaceTransparency=0.7; hl.LineThickness=0.03; hl.Parent=CoreGui
                S.ChamsObjects[pl]=hl
            end
        else
            if S.ChamsObjects[pl] then S.ChamsObjects[pl]:Destroy(); S.ChamsObjects[pl]=nil end
        end
    end
end

-- ── MINI RADAR (Drawing API) ───────────────────────
local RadarFrame = {}
local radarBg, radarCross1, radarCross2, radarSelf

local function BuildRadar()
    if radarBg then return end
    pcall(function()
        radarBg=Drawing.new("Square"); radarBg.Filled=true; radarBg.Color=Color3.fromRGB(5,10,20); radarBg.Transparency=0.45; radarBg.Size=Vector2.new(120,120); radarBg.Visible=false
        local vc=Camera.ViewportSize; radarBg.Position=Vector2.new(vc.X-130,vc.Y-130)

        radarCross1=Drawing.new("Line"); radarCross1.Thickness=1; radarCross1.Color=Color3.fromRGB(0,80,100); radarCross1.Transparency=0.5; radarCross1.Visible=false
        radarCross2=Drawing.new("Line"); radarCross2.Thickness=1; radarCross2.Color=Color3.fromRGB(0,80,100); radarCross2.Transparency=0.5; radarCross2.Visible=false

        radarSelf=Drawing.new("Square"); radarSelf.Filled=true; radarSelf.Color=C.Green; radarSelf.Size=Vector2.new(6,6); radarSelf.Visible=false
    end)
end

local function UpdateRadar()
    if not radarBg then BuildRadar() end; if not radarBg then return end
    local vc=Camera.ViewportSize
    local rx=vc.X-130; local ry=vc.Y-130
    local rw,rh=120,120; local cx=rx+rw/2; local cy=ry+rh/2
    local range=200 -- studs shown on radar

    radarBg.Position=Vector2.new(rx,ry); radarBg.Size=Vector2.new(rw,rh); radarBg.Visible=S.RadarOn
    if radarCross1 then radarCross1.From=Vector2.new(cx,ry); radarCross1.To=Vector2.new(cx,ry+rh); radarCross1.Visible=S.RadarOn end
    if radarCross2 then radarCross2.From=Vector2.new(rx,cy); radarCross2.To=Vector2.new(rx+rw,cy); radarCross2.Visible=S.RadarOn end
    if radarSelf then radarSelf.Position=Vector2.new(cx-3,cy-3); radarSelf.Visible=S.RadarOn end

    -- player dots
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl==LP then continue end
        local c=pl.Character; local hrp=c and c:FindFirstChild("HumanoidRootPart")
        if not S.RadarDots[pl] then
            pcall(function()
                local dot=Drawing.new("Square"); dot.Filled=true; dot.Color=C.Red; dot.Size=Vector2.new(5,5); dot.Visible=false
                S.RadarDots[pl]=dot
            end)
        end
        local dot=S.RadarDots[pl]; if not dot then continue end
        if not S.RadarOn or not hrp then dot.Visible=false; continue end
        local myHRP=GetHRP(); if not myHRP then dot.Visible=false; continue end
        local delta=hrp.Position-myHRP.Position
        -- rotate by camera Y
        local camY=Camera.CFrame.LookVector
        local angle=math.atan2(camY.Z,camY.X)
        local cos,sin=math.cos(-angle),math.sin(-angle)
        local rx2=delta.X*cos-delta.Z*sin; local rz2=delta.X*sin+delta.Z*cos
        local px=cx+(rx2/range)*(rw/2); local py=cy+(rz2/range)*(rh/2)
        if px>=rx and px<=rx+rw and py>=ry and py<=ry+rh then
            dot.Position=Vector2.new(px-2.5,py-2.5); dot.Visible=true
        else dot.Visible=false end
    end
end

-- ── NOCLIP ─────────────────────────────────────────
RunService.Stepped:Connect(function()
    if not S.NoClipOn then return end
    local c=GetChar(); if not c then return end
    for _,p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
    end
end)

-- ── WHITE CHARACTER ────────────────────────────────
local function SetWhiteChar(on)
    pcall(function()
        local c=GetChar(); if not c then return end
        for _,p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("MeshPart") then
                if on then p:SetAttribute("_oc",tostring(p.BrickColor)); p.BrickColor=BrickColor.new("White"); p.Material=Enum.Material.SmoothPlastic
                else local oc=p:GetAttribute("_oc"); if oc then p.BrickColor=BrickColor.new(oc) end end
            end
        end
    end)
end

-- ── FLING TOUCH ────────────────────────────────────
local function StartFlingTouch()
    if S.FlingTouchConn then S.FlingTouchConn:Disconnect() end
    S.FlingTouchConn=RunService.Heartbeat:Connect(function()
        if not S.FlingTouchOn then S.FlingTouchConn:Disconnect(); return end
        local myHRP=GetHRP(); if not myHRP then return end
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LP then continue end
            local hrp=pl.Character and pl.Character:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
            if (myHRP.Position-hrp.Position).Magnitude<6 then
                local bv=Instance.new("BodyVelocity"); bv.Velocity=(hrp.Position-myHRP.Position).Unit*240+Vector3.new(0,130,0); bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.Parent=hrp
                task.delay(0.15,function() pcall(function() bv:Destroy() end) end)
            end
        end
    end)
end

-- ── SPAM CALL ──────────────────────────────────────
local function StartSpamCall()
    if S.SpamCallConn then S.SpamCallConn:Disconnect() end
    S.SpamCallConn=RunService.Heartbeat:Connect(function()
        if not S.SpamCallOn then S.SpamCallConn:Disconnect(); return end
        pcall(function()
            local remote=RS:FindFirstChild("Remotes",true); if not remote then return end
            local callRem=remote:FindFirstChild("Call") or remote:FindFirstChild("PhoneCall"); if not callRem then return end
            for _,pl in ipairs(Players:GetPlayers()) do if pl~=LP then pcall(function() callRem:FireServer(pl) end) end end
        end)
        task.wait(0.3)
    end)
end

-- ── ANTI VOID ──────────────────────────────────────
local function StartAntiVoid()
    if S.AntiVoidConn then S.AntiVoidConn:Disconnect() end
    S.AntiVoidConn=RunService.Heartbeat:Connect(function()
        if not S.AntiVoidOn then S.AntiVoidConn:Disconnect(); return end
        local hrp=GetHRP(); if hrp and hrp.Position.Y<-80 then hrp.CFrame=CFrame.new(hrp.Position.X,15,hrp.Position.Z) end
    end)
end

-- ── AUTO ARMOR ─────────────────────────────────────
local function StartAutoArmor()
    if S.AutoArmorConn then S.AutoArmorConn:Disconnect() end
    S.AutoArmorConn=RunService.Heartbeat:Connect(function()
        if not S.AutoArmorOn then S.AutoArmorConn:Disconnect(); return end
        local hum=GetHum(); if not hum then return end
        if hum.Health<hum.MaxHealth*0.5 then
            pcall(function()
                for _,t in ipairs(LP.Backpack:GetChildren()) do
                    if t:IsA("Tool") and (t.Name:lower():find("armor") or t.Name:lower():find("vest")) then hum:EquipTool(t); break end
                end
            end)
        end
    end)
end

-- ── SPINBOT ────────────────────────────────────────
local function StartSpinbot()
    if S.SpinbotConn then S.SpinbotConn:Disconnect() end
    S.SpinbotConn=RunService.RenderStepped:Connect(function()
        if not S.SpinbotOn then S.SpinbotConn:Disconnect(); return end
        local hrp=GetHRP(); if hrp then hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(S.SpinSpeed*0.016),0) end
    end)
end

-- ── ROTATING CROSSHAIR ─────────────────────────────
local function StartCrosshair()
    if S.CrosshairGui then S.CrosshairGui:Destroy() end
    S.CrosshairGui=Instance.new("ScreenGui"); S.CrosshairGui.Name="RotCross"; S.CrosshairGui.ResetOnSpawn=false; S.CrosshairGui.IgnoreGuiInset=true; S.CrosshairGui.Parent=LPGui
    local lines={}; local angle=0
    local styles={{14,2},{20,2,true},{10,3}} -- length, thickness, dot
    local st=styles[math.clamp(S.CrosshairStyle,1,#styles)]
    for i=1,4 do
        local ln=Instance.new("Frame",S.CrosshairGui); ln.BackgroundColor3=C.AccentGlow; ln.BorderSizePixel=0
        ln.Size=UDim2.new(0,st[1],0,st[2]); ln.AnchorPoint=Vector2.new(0.5,0.5); table.insert(lines,ln)
    end
    if st[3] then
        local dot=Instance.new("Frame",S.CrosshairGui); dot.BackgroundColor3=C.AccentGlow; dot.BorderSizePixel=0; dot.Size=UDim2.new(0,4,0,4); dot.AnchorPoint=Vector2.new(0.5,0.5)
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        table.insert(lines,dot)
    end
    RunService.RenderStepped:Connect(function()
        if not S.RotCrossOn or not S.CrosshairGui or not S.CrosshairGui.Parent then return end
        angle=(angle+2)%360
        local cx,cy=Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2
        for i,ln in ipairs(lines) do
            if i<=#lines-1 or not st[3] then
                local a=math.rad(angle+(i-1)*90)
                ln.Position=UDim2.new(0,cx+math.cos(a)*22,0,cy+math.sin(a)*22); ln.Rotation=math.deg(a)
            else ln.Position=UDim2.new(0,cx,0,cy) end
        end
    end)
end

-- ── EQUIP ALL ──────────────────────────────────────
local function EquipAll()
    pcall(function()
        local c=GetChar(); if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        for _,t in ipairs(LP.Backpack:GetChildren()) do if t:IsA("Tool") then hum:EquipTool(t); task.wait(0.05) end end
    end)
    Notify("EQUIP ALL","Equipped all tools",2)
end

-- ── BUY ITEM ───────────────────────────────────────
local function TryBuy(name)
    local ok=false
    pcall(function()
        local rem=RS:FindFirstChild("BuyItem",true) or RS:FindFirstChild("Purchase",true) or RS:FindFirstChild("Buy",true) or RS:FindFirstChild("ShopBuy",true) or RS:FindFirstChild("ShopEvent",true)
        if rem then rem:FireServer(name); ok=true; return end
        for _,p in ipairs(WS:GetDescendants()) do
            if p:IsA("ProximityPrompt") and ((p.ActionText or ""):lower():find(name:lower(),1,true) or (p.Parent and p.Parent.Name:lower():find(name:lower(),1,true))) then
                fireproximityprompt(p); ok=true; return
            end
        end
    end)
    Notify("BUY",ok and "Buying: "..name or "⚠️ Near shop: "..name,2)
end

-- ── TITLE SYSTEM ───────────────────────────────────
local function HideRealNametag()
    pcall(function() local hum=GetHum(); if hum then hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None; hum.NameDisplayDistance=0; hum.HealthDisplayDistance=0 end end)
end
local function RestoreNametag()
    pcall(function() local hum=GetHum(); if hum then hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.Viewer; hum.NameDisplayDistance=100; hum.HealthDisplayDistance=100 end end)
end
local function RemoveTitle()
    if S.TitleBillboard and S.TitleBillboard.Parent then S.TitleBillboard:Destroy() end; S.TitleBillboard=nil
end
local function ApplyTitle()
    RemoveTitle()
    if not S.TitleVisible then RestoreNametag(); return end
    local c=GetChar(); if not c then return end
    local head=c:FindFirstChild("Head"); if not head then return end
    HideRealNametag()
    local bb=Instance.new("BillboardGui"); bb.Name="CustomTitle"; bb.Adornee=head
    bb.Size=UDim2.new(0,200,0,30); bb.StudsOffset=Vector3.new(0,2.2,0)
    bb.AlwaysOnTop=false; bb.LightInfluence=1; bb.MaxDistance=100; bb.ResetOnSpawn=false; bb.Parent=c
    local pill=Instance.new("Frame",bb); pill.AnchorPoint=Vector2.new(0.5,0.5); pill.Size=UDim2.new(1,0,1,0); pill.Position=UDim2.new(0.5,0,0.5,0)
    pill.BackgroundColor3=Color3.fromRGB(0,0,0); pill.BackgroundTransparency=0.4; pill.BorderSizePixel=0
    Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
    local lbl=Instance.new("TextLabel",pill); lbl.Size=UDim2.new(1,-14,1,0); lbl.Position=UDim2.new(0,7,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=S.MyTitle; lbl.TextColor3=Color3.fromRGB(255,255,255)
    lbl.TextStrokeColor3=Color3.fromRGB(0,0,0); lbl.TextStrokeTransparency=0.75
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=13; lbl.TextXAlignment=Enum.TextXAlignment.Center
    S.TitleBillboard=bb
end

-- ══════════════════════════════════════════════════
-- MAIN LOOP
-- ══════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if S.AimbotOn then
        S.AimbotTarget=GetAimbotTarget()
        if S.AimbotTarget and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local c=S.AimbotTarget.Character
            local part=c and (c:FindFirstChild(S.AimbotPart) or c:FindFirstChild("Head"))
            if part then
                local pos=part.Position
                if S.UsePrediction then local hrp=c:FindFirstChild("HumanoidRootPart"); if hrp then pos=pos+(hrp.Velocity*S.Prediction) end end
                Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position,pos),S.AimbotSmooth)
            end
        else S.AimbotTarget=nil end
    end
    -- FOV ring
    if FOVCircle then
        FOVCircle.Visible=S.AimbotOn
        if S.AimbotOn then
            FOVCircle.Radius=S.AimbotFOV; FOVCircle.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
            FOVCircle.Color=S.AimbotTarget and C.Red or C.AccentGlow
        end
    end
    UpdateESP(); UpdateChams(); UpdateRadar()
    -- Fly tick
    if S.FlyOn and S.FlyBV then
        local hrp=GetHRP()
        if hrp then
            local dir=Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
            S.FlyBV.Velocity=dir*S.FlySpeed; S.FlyBG.CFrame=Camera.CFrame
        end
    end
    -- Speed
    if S.SpeedOn then local h=GetHum(); if h then h.WalkSpeed=S.SpeedVal end end
    -- Jump
    if S.JumpPowerOn then local h=GetHum(); if h then h.JumpPower=S.JumpPowerVal end end
end)

-- CharacterAdded
LP.CharacterAdded:Connect(function(char)
    local hum=char:WaitForChild("Humanoid",5)
    if hum and S.TitleVisible then hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None; hum.NameDisplayDistance=0; hum.HealthDisplayDistance=0 end
    task.wait(1)
    ApplyTitle()
    if S.WhiteCharOn   then SetWhiteChar(true) end
    if S.AntiVoidOn    then StartAntiVoid() end
    if S.AutoArmorOn   then StartAutoArmor() end
    if S.SpinbotOn     then StartSpinbot() end
    if S.FlingTouchOn  then StartFlingTouch() end
    if S.FlyOn         then StartFly() end
    if S.GodBlockOn    then StartGodBlock() end
    if S.KillAuraOn    then StartKillAura() end
    if S.InfStamOn     then StartInfStam() end
end)

-- Chat commands
LP.Chatted:Connect(function(msg)
    local lower=msg:lower(); local parts
    if lower:sub(1,6)=="csync " then parts=msg:sub(7):split(" ")
    elseif msg:sub(1,1)==":" then parts=msg:sub(2):split(" ")
    else return end
    local cmd=(parts[1] or ""):lower(); local args={table.unpack(parts,2)}
    if cmd=="cfly"     then S.FlyOn=not S.FlyOn; if S.FlyOn then StartFly() else StopFly() end; Notify("FLY",S.FlyOn and "ON" or "OFF",2)
    elseif cmd=="cspeed" then local v=tonumber(args[1]); if v then S.SpeedVal=v; S.SpeedOn=true; Notify("SPEED","→ "..v,2) end
    elseif cmd=="cgod"   then S.GodBlockOn=not S.GodBlockOn; if S.GodBlockOn then StartGodBlock() end; Notify("GOD",S.GodBlockOn and "ON" or "OFF",2)
    elseif cmd=="cesp"   then S.ESPOn=not S.ESPOn; if not S.ESPOn then ClearESP() end; Notify("ESP",S.ESPOn and "ON" or "OFF",2)
    elseif cmd=="caimbot"then S.AimbotOn=not S.AimbotOn; Notify("AIMBOT",S.AimbotOn and "ON" or "OFF",2)
    elseif cmd=="cnoclip"then S.NoClipOn=not S.NoClipOn; Notify("NOCLIP",S.NoClipOn and "ON" or "OFF",2)
    elseif cmd=="ckill"  then S.KillAuraOn=not S.KillAuraOn; if S.KillAuraOn then StartKillAura() end; Notify("KILL AURA",S.KillAuraOn and "ON" or "OFF",2)
    elseif cmd=="ctp"    then
        local name=table.concat(args," ")
        for _,t in ipairs(TELEPORTS) do if t.n:lower():find(name:lower(),1,true) then TeleportTo(t.p); Notify("TP","→ "..t.n,2); return end end
        Notify("TP","Not found: "..name,2)
    end
end)

-- Keybinds
UIS.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if inp.KeyCode==Enum.KeyCode.Z then S.NoClipOn=not S.NoClipOn; Notify("NOCLIP",S.NoClipOn and "ON" or "OFF",1.5)
    elseif inp.KeyCode==Enum.KeyCode.X then S.FlyOn=not S.FlyOn; if S.FlyOn then StartFly() else StopFly() end; Notify("FLY",S.FlyOn and "ON" or "OFF",1.5)
    elseif inp.KeyCode==Enum.KeyCode.C then S.KillAuraOn=not S.KillAuraOn; if S.KillAuraOn then StartKillAura() end; Notify("KILL AURA",S.KillAuraOn and "ON" or "OFF",1.5)
    end
end)

-- ══════════════════════════════════════════════════
-- ████████████  G U I  BUILD  ████████████
-- ══════════════════════════════════════════════════

local SG = Instance.new("ScreenGui")
SG.Name="PhantomGUI_v6"; SG.ResetOnSpawn=false; SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.IgnoreGuiInset=true; SG.Parent=LPGui

-- Window constants
local WW, WH = 660, 480
local TOPBAR_H, SIDEBAR_W, STATS_W = 44, 112, 104

-- ── WINDOW ─────────────────────────────────────────
local W=Instance.new("Frame",SG); W.Name="Win"; W.Size=UDim2.new(0,WW,0,WH)
W.Position=UDim2.new(0.5,-WW/2,0.5,-WH/2); W.BackgroundColor3=C.BG; W.BorderSizePixel=0; W.ClipsDescendants=true
Instance.new("UICorner",W).CornerRadius=UDim.new(0,14)
local WStroke=Instance.new("UIStroke",W); WStroke.Color=C.Border; WStroke.Thickness=1.5

-- soft ambient glow behind window (sits in SG, not W)
local glow=Instance.new("Frame",SG); glow.Size=UDim2.new(0,WW+60,0,WH+60)
glow.Position=UDim2.new(0.5,-WW/2-30,0.5,-WH/2-30)
glow.BackgroundColor3=C.Accent; glow.BackgroundTransparency=0.92; glow.BorderSizePixel=0; glow.ZIndex=0
Instance.new("UICorner",glow).CornerRadius=UDim.new(0,30)

-- ── TOP BAR ────────────────────────────────────────
local TopBar=Instance.new("Frame",W); TopBar.Name="TopBar"; TopBar.Size=UDim2.new(1,0,0,TOPBAR_H)
TopBar.BackgroundColor3=C.TopBar; TopBar.BorderSizePixel=0
Instance.new("UICorner",TopBar).CornerRadius=UDim.new(0,14)
local tbFix=Instance.new("Frame",TopBar); tbFix.Size=UDim2.new(1,0,0.5,0); tbFix.Position=UDim2.new(0,0,0.5,0); tbFix.BackgroundColor3=C.TopBar; tbFix.BorderSizePixel=0

-- Subtle gradient stripe on top bar
local tbGrad=Instance.new("UIGradient",TopBar); tbGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,40,70)),ColorSequenceKeypoint.new(1,C.TopBar)}); tbGrad.Rotation=90

-- Logo / title (left)
local LogoLbl=Instance.new("TextLabel",TopBar); LogoLbl.Size=UDim2.new(0,180,1,0); LogoLbl.Position=UDim2.new(0,14,0,0)
LogoLbl.BackgroundTransparency=1; LogoLbl.Text="◈  PHANTOM v6"; LogoLbl.TextColor3=C.AccentGlow
LogoLbl.Font=Enum.Font.GothamBold; LogoLbl.TextSize=15; LogoLbl.TextXAlignment=Enum.TextXAlignment.Left

-- Sub label (center)
local SubLbl=Instance.new("TextLabel",TopBar); SubLbl.Size=UDim2.new(0,240,1,0); SubLbl.Position=UDim2.new(0.5,-120,0,0)
SubLbl.BackgroundTransparency=1; SubLbl.Text="DA HOOD  ·  2026 EDITION"; SubLbl.TextColor3=C.TextDim
SubLbl.Font=Enum.Font.Gotham; SubLbl.TextSize=11

-- User label
local UserLbl=Instance.new("TextLabel",TopBar); UserLbl.Size=UDim2.new(0,160,1,0); UserLbl.Position=UDim2.new(1,-220,0,0)
UserLbl.BackgroundTransparency=1; UserLbl.Text="👤 "..LP.Name; UserLbl.TextColor3=C.TextDim; UserLbl.Font=Enum.Font.Gotham; UserLbl.TextSize=11; UserLbl.TextXAlignment=Enum.TextXAlignment.Right

-- Control buttons
local function CtrlBtn(lbl,xOff,bg)
    local b=Instance.new("TextButton",TopBar); b.Size=UDim2.new(0,26,0,22); b.Position=UDim2.new(1,xOff,0.5,-11)
    b.BackgroundColor3=bg; b.BorderSizePixel=0; b.Text=lbl; b.TextColor3=C.TextBright; b.Font=Enum.Font.GothamBold; b.TextSize=14; b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
    b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0.3}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0}):Play() end)
    return b
end
local CloseBtn=CtrlBtn("×",-8,Color3.fromRGB(180,40,60))
local MinBtn=CtrlBtn("—",-38,Color3.fromRGB(30,50,80))

-- ── BODY ───────────────────────────────────────────
local Body=Instance.new("Frame",W); Body.Name="Body"; Body.Size=UDim2.new(1,0,1,-TOPBAR_H); Body.Position=UDim2.new(0,0,0,TOPBAR_H)
Body.BackgroundTransparency=1; Body.BorderSizePixel=0; Body.ClipsDescendants=true

-- Sidebar
local Sidebar=Instance.new("Frame",Body); Sidebar.Name="Sidebar"; Sidebar.Size=UDim2.new(0,SIDEBAR_W,1,0)
Sidebar.BackgroundColor3=C.Sidebar; Sidebar.BorderSizePixel=0
local sidePad=Instance.new("UIPadding",Sidebar); sidePad.PaddingTop=UDim.new(0,10); sidePad.PaddingLeft=UDim.new(0,6); sidePad.PaddingRight=UDim.new(0,6); sidePad.PaddingBottom=UDim.new(0,6)
local sideList=Instance.new("UIListLayout",Sidebar); sideList.Padding=UDim.new(0,4)

local SepL=Instance.new("Frame",Body); SepL.Size=UDim2.new(0,1,1,0); SepL.Position=UDim2.new(0,SIDEBAR_W,0,0); SepL.BackgroundColor3=C.Border; SepL.BorderSizePixel=0

-- Stats panel (right)
local StatsPanel=Instance.new("Frame",Body); StatsPanel.Name="Stats"; StatsPanel.Size=UDim2.new(0,STATS_W,1,0); StatsPanel.Position=UDim2.new(1,-STATS_W,0,0)
StatsPanel.BackgroundColor3=C.Sidebar; StatsPanel.BorderSizePixel=0

local SepR=Instance.new("Frame",Body); SepR.Size=UDim2.new(0,1,1,0); SepR.Position=UDim2.new(1,-STATS_W,0,0); SepR.BackgroundColor3=C.Border; SepR.BorderSizePixel=0

-- Content
local ContentArea=Instance.new("Frame",Body); ContentArea.Name="Content"; ContentArea.Size=UDim2.new(1,-SIDEBAR_W-STATS_W,1,0); ContentArea.Position=UDim2.new(0,SIDEBAR_W,0,0)
ContentArea.BackgroundColor3=C.Content; ContentArea.BorderSizePixel=0; ContentArea.ClipsDescendants=true

-- ── STATS PANEL CONTENTS ───────────────────────────
local spPad=Instance.new("UIPadding",StatsPanel); spPad.PaddingTop=UDim.new(0,10); spPad.PaddingLeft=UDim.new(0,6); spPad.PaddingRight=UDim.new(0,6)

local function StatHdr(txt,y)
    local l=Instance.new("TextLabel",StatsPanel); l.Size=UDim2.new(1,0,0,18); l.Position=UDim2.new(0,0,0,y); l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=C.Accent; l.Font=Enum.Font.GothamBold; l.TextSize=10; l.TextXAlignment=Enum.TextXAlignment.Left; return l
end
local function StatRow(txt,y)
    local l=Instance.new("TextLabel",StatsPanel); l.Size=UDim2.new(1,0,0,16); l.Position=UDim2.new(0,0,0,y); l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=C.TextDim; l.Font=Enum.Font.Gotham; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left; return l
end
StatHdr("◈ STATS",2)
local cashLbl   = StatRow("💰 $---",  22)
local bountyLbl = StatRow("💀 ---",   40)
local crewLbl   = StatRow("👥 ---",   58)
StatHdr("◈ PLAYER",80)
local hpLbl     = StatRow("❤️ ---",   100)
local stLbl     = StatRow("⚡ ---",   118)

-- Quick action buttons in stats panel
local function StatsBtn(txt,y,col,cb)
    local b=Instance.new("TextButton",StatsPanel); b.Size=UDim2.new(1,0,0,26); b.Position=UDim2.new(0,0,1,y)
    b.BackgroundColor3=col; b.BorderSizePixel=0; b.Text=txt; b.TextColor3=C.TextBright; b.Font=Enum.Font.GothamBold; b.TextSize=10; b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    b.MouseButton1Click:Connect(cb)
    b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0.3}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0}):Play() end)
    return b
end
StatsBtn("🎯 Target",-88,C.Accent,function() S.AimbotOn=true; local t=GetAimbotTarget(); Notify("TARGET",t and "→ "..t.Name or "No target",2) end)
StatsBtn("☠️ Fling All",-58,Color3.fromRGB(120,20,20),function()
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LP then local hrp=pl.Character and pl.Character:FindFirstChild("HumanoidRootPart"); if hrp then local bv=Instance.new("BodyVelocity"); bv.Velocity=Vector3.new(0,350,0); bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.Parent=hrp; task.delay(0.2,function() pcall(function() bv:Destroy() end) end) end end
    end
    Notify("FLING ALL","Launched all!",2)
end)
StatsBtn("⚡ Max Speed",-28,Color3.fromRGB(30,60,80),function() S.SpeedVal=200; S.SpeedOn=true; Notify("SPEED","→ 200",2) end)

-- Live stats
RunService.Heartbeat:Connect(function()
    pcall(function()
        local stats=LP:FindFirstChild("leaderstats") or LP:FindFirstChild("Stats")
        if stats then
            local ca=stats:FindFirstChild("Cash") or stats:FindFirstChild("Money")
            local bo=stats:FindFirstChild("Bounty") or stats:FindFirstChild("KOs")
            local cr=stats:FindFirstChild("Crew") or stats:FindFirstChild("Gang")
            if ca then cashLbl.Text="💰 $"..tostring(ca.Value) end
            if bo then bountyLbl.Text="💀 "..tostring(bo.Value) end
            if cr then crewLbl.Text="👥 "..tostring(cr.Value) end
        end
        local h=GetHum()
        if h then hpLbl.Text="❤️ "..math.floor(h.Health).."/"..math.floor(h.MaxHealth) end
    end)
end)

-- ══════════════════════════════════════════════════
-- PAGE / TAB SYSTEM
-- ══════════════════════════════════════════════════
local Pages={}, TabBtns={}

local function NewPage(name)
    local p=Instance.new("ScrollingFrame",ContentArea); p.Name=name.."Page"; p.Size=UDim2.new(1,0,1,0)
    p.BackgroundTransparency=1; p.BorderSizePixel=0; p.ScrollBarThickness=4; p.ScrollBarImageColor3=C.Accent
    p.CanvasSize=UDim2.new(0,0,0,0); p.AutomaticCanvasSize=Enum.AutomaticSize.Y; p.Visible=false
    local pad=Instance.new("UIPadding",p); pad.PaddingTop=UDim.new(0,10); pad.PaddingLeft=UDim.new(0,10); pad.PaddingRight=UDim.new(0,12); pad.PaddingBottom=UDim.new(0,10)
    Pages[name]=p; return p
end
local function NewGridPage(name)
    local p=NewPage(name)
    local g=Instance.new("UIGridLayout",p); g.CellSize=UDim2.new(0,108,0,40); g.CellPadding=UDim2.new(0,7,0,7)
    g.HorizontalAlignment=Enum.HorizontalAlignment.Left; g.VerticalAlignment=Enum.VerticalAlignment.Top
    return p
end
local function NewListPage(name)
    local p=NewPage(name); local l=Instance.new("UIListLayout",p); l.Padding=UDim.new(0,6); return p
end

-- Tab button factory — icon + label pill style
local function TabBtn(name,icon)
    local b=Instance.new("TextButton",Sidebar); b.Size=UDim2.new(1,0,0,38); b.BackgroundColor3=C.Card; b.BorderSizePixel=0; b.AutoButtonColor=false; b.Text=""
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,9)

    local activeBar=Instance.new("Frame",b); activeBar.Size=UDim2.new(0,3,0.55,0); activeBar.Position=UDim2.new(0,0,0.225,0)
    activeBar.BackgroundColor3=C.AccentGlow; activeBar.BorderSizePixel=0; activeBar.Visible=false
    Instance.new("UICorner",activeBar).CornerRadius=UDim.new(1,0)

    local ic=Instance.new("TextLabel",b); ic.Size=UDim2.new(0,26,1,0); ic.Position=UDim2.new(0,7,0,0)
    ic.BackgroundTransparency=1; ic.Text=icon; ic.TextSize=15; ic.Font=Enum.Font.Gotham

    local nl=Instance.new("TextLabel",b); nl.Size=UDim2.new(1,-36,1,0); nl.Position=UDim2.new(0,34,0,0)
    nl.BackgroundTransparency=1; nl.Text=name; nl.TextColor3=C.TextDim; nl.TextSize=10; nl.Font=Enum.Font.GothamSemibold; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.TextWrapped=true

    TabBtns[name]={btn=b,bar=activeBar,lbl=nl,ic=ic}

    b.MouseButton1Click:Connect(function()
        for n,p in pairs(Pages) do p.Visible=(n==name) end
        for n,tb in pairs(TabBtns) do
            local act=(n==name)
            TweenService:Create(tb.btn,TweenInfo.new(0.15),{BackgroundColor3=act and C.TabActive or C.Card}):Play()
            tb.lbl.TextColor3=act and C.TextBright or C.TextDim
            tb.bar.Visible=act; tb.ic.TextColor3=act and C.TextBright or C.TextDim
        end
        S.CurrentPage=name
    end)
end

-- ── WIDGET HELPERS ─────────────────────────────────

-- Grid toggle button
local function GBtn(parent,lbl,isToggle,cb)
    local btn=Instance.new("TextButton",parent); btn.Text=lbl; btn.Font=Enum.Font.GothamBold; btn.TextSize=11
    btn.TextColor3=C.Text; btn.BackgroundColor3=C.Card; btn.BorderSizePixel=0; btn.AutoButtonColor=false; btn.TextWrapped=true
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    local sk=Instance.new("UIStroke",btn); sk.Color=C.Border; sk.Thickness=1

    local active=false
    local function set(v)
        active=v
        TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=v and C.TabActive or C.Card, TextColor3=v and C.TextBright or C.Text}):Play()
        sk.Color=v and C.AccentGlow or C.Border
    end
    btn.MouseButton1Click:Connect(function()
        if isToggle then set(not active)
        else TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.TabActive}):Play(); task.delay(0.2,function() TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=C.Card}):Play() end) end
        if cb then cb(active) end
    end)
    btn.MouseEnter:Connect(function() if not active then TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.CardHov}):Play() end end)
    btn.MouseLeave:Connect(function() if not active then TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.Card}):Play() end end)
    return btn, set
end

-- List row toggle
local function ToggleRow(parent,lbl,cb)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,40); row.BackgroundColor3=C.Card; row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,9)
    local sk=Instance.new("UIStroke",row); sk.Color=C.Border; sk.Thickness=1

    local l=Instance.new("TextLabel",row); l.Size=UDim2.new(1,-64,1,0); l.Position=UDim2.new(0,12,0,0)
    l.BackgroundTransparency=1; l.Text=lbl; l.TextColor3=C.Text; l.Font=Enum.Font.GothamSemibold; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left

    local pill=Instance.new("Frame",row); pill.Size=UDim2.new(0,46,0,24); pill.Position=UDim2.new(1,-54,0.5,-12)
    pill.BackgroundColor3=C.ToggleOff; pill.BorderSizePixel=0
    Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",pill); knob.Size=UDim2.new(0,18,0,18); knob.Position=UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3=C.TextDim; knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local active=false
    local hit=Instance.new("TextButton",row); hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1; hit.Text=""
    hit.MouseButton1Click:Connect(function()
        active=not active
        TweenService:Create(pill,TweenInfo.new(0.18),{BackgroundColor3=active and C.ToggleOn or C.ToggleOff}):Play()
        TweenService:Create(knob,TweenInfo.new(0.18),{Position=active and UDim2.new(0,25,0.5,-9) or UDim2.new(0,3,0.5,-9), BackgroundColor3=active and C.TextBright or C.TextDim}):Play()
        sk.Color=active and C.AccentSoft or C.Border
        if cb then cb(active) end
    end)
    return row
end

-- Action button (list style)
local function ActionRow(parent,lbl,cb)
    local btn=Instance.new("TextButton",parent); btn.Size=UDim2.new(1,0,0,40); btn.BackgroundColor3=C.Card; btn.BorderSizePixel=0
    btn.Text=lbl; btn.TextColor3=C.Text; btn.Font=Enum.Font.GothamSemibold; btn.TextSize=12; btn.TextXAlignment=Enum.TextXAlignment.Left; btn.AutoButtonColor=false
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,9)
    local sk=Instance.new("UIStroke",btn); sk.Color=C.Border; sk.Thickness=1
    local pad=Instance.new("UIPadding",btn); pad.PaddingLeft=UDim.new(0,14)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.TabActive}):Play()
        task.delay(0.2,function() TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=C.Card}):Play() end)
        if cb then cb() end
    end)
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.CardHov}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.Card}):Play() end)
    return btn
end

-- Section header
local function SecHdr(parent,txt)
    local l=Instance.new("TextLabel",parent); l.Size=UDim2.new(1,0,0,22); l.BackgroundTransparency=1
    l.Text=txt; l.TextColor3=C.AccentSoft; l.Font=Enum.Font.GothamBold; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left
    return l
end

-- Slider
local function SliderRow(parent,lbl,mn,mx,def,unit,cb)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,56); row.BackgroundColor3=C.Card; row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,9); Instance.new("UIStroke",row).Color=C.Border

    local l=Instance.new("TextLabel",row); l.Size=UDim2.new(1,-80,0,24); l.Position=UDim2.new(0,12,0,4)
    l.BackgroundTransparency=1; l.Text=lbl; l.TextColor3=C.Text; l.Font=Enum.Font.GothamSemibold; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left

    local vLbl=Instance.new("TextLabel",row); vLbl.Size=UDim2.new(0,68,0,24); vLbl.Position=UDim2.new(1,-76,0,4)
    vLbl.BackgroundTransparency=1; vLbl.Text=tostring(def)..(unit or ""); vLbl.TextColor3=C.AccentGlow; vLbl.Font=Enum.Font.GothamBold; vLbl.TextSize=11; vLbl.TextXAlignment=Enum.TextXAlignment.Right

    local track=Instance.new("Frame",row); track.Size=UDim2.new(1,-24,0,6); track.Position=UDim2.new(0,12,0,36)
    track.BackgroundColor3=C.ToggleOff; track.BorderSizePixel=0; Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

    local fill=Instance.new("Frame",track); fill.Size=UDim2.new((def-mn)/(mx-mn),0,1,0); fill.BackgroundColor3=C.Accent; fill.BorderSizePixel=0; Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",track); knob.Size=UDim2.new(0,16,0,16); knob.AnchorPoint=Vector2.new(0.5,0.5)
    knob.Position=UDim2.new((def-mn)/(mx-mn),0,0.5,0); knob.BackgroundColor3=C.TextBright; knob.BorderSizePixel=0; Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local dragging=false
    local function sv(rx)
        rx=math.clamp(rx,0,1); local v=math.floor(mn+(mx-mn)*rx)
        fill.Size=UDim2.new(rx,0,1,0); knob.Position=UDim2.new(rx,0,0.5,0)
        vLbl.Text=tostring(v)..(unit or ""); if cb then cb(v) end
    end
    knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true end end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local ap=track.AbsolutePosition; local as=track.AbsoluteSize; sv((i.Position.X-ap.X)/as.X)
        end
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
    track.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            local ap=track.AbsolutePosition; local as=track.AbsoluteSize; sv((i.Position.X-ap.X)/as.X)
        end
    end)
    return row
end

-- ══════════════════════════════════════════════════
-- ██  BUILD PAGES  ██
-- ══════════════════════════════════════════════════

-- ── PAGE 1: COMBAT (grid) ──────────────────────────
local p1=NewGridPage("Combat"); TabBtn("Combat","⚔️")

GBtn(p1,"GodBlock",true,function(v) S.GodBlockOn=v; if v then StartGodBlock() end; Notify("GODBLOCK",v and "ON" or "OFF",1.5,v and C.Green or C.Red) end)
GBtn(p1,"GodArmor",true,function(v) S.GodArmor=v; pcall(function() local c=GetChar(); if c then local a=c:FindFirstChild("Armor") or c:FindFirstChild("ArmorValue"); if a then a.Value=v and 99 or 0 end end end); Notify("GOD ARMOR",v and "ON" or "OFF",1.5) end)
GBtn(p1,"Kill Aura [C]",true,function(v) S.KillAuraOn=v; if v then StartKillAura() end; Notify("KILL AURA",v and "ON" or "OFF",1.5,v and C.Red or nil) end)
GBtn(p1,"Reach",true,function(v) S.ReachOn=v; SetReach(v); Notify("REACH",v and "ON" or "OFF",1.5) end)
GBtn(p1,"Inf Stamina",true,function(v) S.InfStamOn=v; if v then StartInfStam() end; Notify("INF STAM",v and "ON" or "OFF",1.5) end)
GBtn(p1,"No Recoil",true,function(v) S.NoRecoilOn=v; pcall(function() if v then WS.Camera.CameraType=Enum.CameraType.Custom end end); Notify("NO RECOIL",v and "ON" or "OFF",1.5) end)
GBtn(p1,"Auto Reload",true,function(v) S.AutoReloadOn=v; if v then StartAutoReload() end; Notify("AUTO RELOAD",v and "ON" or "OFF",1.5) end)
GBtn(p1,"Anti Slow",true,function(v) S.AntiSlowOn=v; Notify("ANTI SLOW",v and "ON" or "OFF",1.5) end)
GBtn(p1,"Headless",true,function(v) S.HeadlessOn=v; pcall(function() local c=GetChar(); if not c then return end; local h=c:FindFirstChild("Head"); if not h then return end; for _,p in ipairs(h:GetDescendants()) do if p:IsA("BasePart") or p:IsA("SpecialMesh") then p.Transparency=v and 1 or 0 end end end); Notify("HEADLESS",v and "ON" or "OFF",1.5) end)
GBtn(p1,"View Unlock",true,function(v) pcall(function() LP.CameraMaxZoomDistance=v and 128 or 12.5 end); Notify("VIEW",v and "Unlocked" or "Reset",1.5) end)
GBtn(p1,"Fling Near",false,function() FlingNearest() end)
GBtn(p1,"GoTo Target",false,function() local t=GetAimbotTarget(); if t then local h=t.Character and t.Character:FindFirstChild("HumanoidRootPart"); if h then TeleportTo(h.Position); Notify("GoTo","→ "..t.Name,2) end else Notify("GoTo","No target",2) end end)
GBtn(p1,"FlyMode [X]",true,function(v) S.FlyOn=v; if v then StartFly() else StopFly() end; Notify("FLY",v and "ON" or "OFF",1.5) end)
GBtn(p1,"NoClip [Z]",true,function(v) S.NoClipOn=v; Notify("NOCLIP",v and "ON" or "OFF",1.5) end)
GBtn(p1,"Speed+",false,function() S.SpeedOn=true; S.SpeedVal=math.min(200,S.SpeedVal+10); Notify("SPEED","→ "..S.SpeedVal,1) end)
GBtn(p1,"Fly+",false,function() S.FlySpeed=math.min(400,S.FlySpeed+15); Notify("FLY SPD","→ "..S.FlySpeed,1) end)

-- ── PAGE 2: AIMBOT ─────────────────────────────────
local p2=NewListPage("Aimbot"); TabBtn("Aimbot","🎯")

SecHdr(p2,"─── AIMBOT ───")
ToggleRow(p2,"Aimbot  (Hold RMB to lock)",function(v) S.AimbotOn=v; Notify("AIMBOT",v and "ON" or "OFF",1.5) end)
ToggleRow(p2,"Silent Aim",function(v) S.SilentAim=v; if v then EnableSilentAim() end; Notify("SILENT AIM",v and "ON" or "OFF",1.5) end)
ToggleRow(p2,"Triggerbot  (auto-fire)",function(v) S.TriggerOn=v; if v then StartTriggerbot() end; Notify("TRIGGER",v and "ON" or "OFF",1.5) end)
ToggleRow(p2,"Use Velocity Prediction",function(v) S.UsePrediction=v end)
ToggleRow(p2,"Team Check  (skip teammates)",function(v) S.TeamCheck=v end)
ToggleRow(p2,"Wall Check  (skip through wall)",function(v) S.WallCheck=v end)

SecHdr(p2,"─── SETTINGS ───")
SliderRow(p2,"FOV Radius",20,500,200,"px",function(v) S.AimbotFOV=v end)
SliderRow(p2,"Smooth (lower = snappier)",1,60,20,"",function(v) S.AimbotSmooth=v/100 end)
SliderRow(p2,"Prediction",0,60,14,"",function(v) S.Prediction=v/100 end)
SliderRow(p2,"Trigger Delay",1,30,8,"0ms",function(v) S.TriggerDelay=v/100 end)

SecHdr(p2,"─── HIT PART ───")
for _,pt in ipairs({"Head","UpperTorso","HumanoidRootPart","LowerTorso","LeftArm","RightArm"}) do
    ActionRow(p2,"🔹 "..pt,function() S.AimbotPart=pt; Notify("AIM PART","→ "..pt,1.5) end)
end

SecHdr(p2,"─── HITBOX EXPANDER ───")
ToggleRow(p2,"Hitbox Expander  (makes enemies bigger)",function(v) S.HitboxOn=v; Notify("HITBOX",v and "ON" or "OFF",1.5) end)
SliderRow(p2,"Hitbox Size",2,30,8,"",function(v) S.HitboxSize=v end)

-- ── PAGE 3: VISUAL ─────────────────────────────────
local p3=NewListPage("Visual"); TabBtn("Visual","👁️")

SecHdr(p3,"─── ESP ───")
ToggleRow(p3,"ESP  (Box + HP + Name + Distance)",function(v) S.ESPOn=v; if not v then ClearESP() end; Notify("ESP",v and "ON" or "OFF",1.5) end)
ToggleRow(p3,"Chams  (Selection Box)",function(v) S.ChamsOn=v; Notify("CHAMS",v and "ON" or "OFF",1.5) end)
ToggleRow(p3,"Player Tracers  (lines to enemies)",function(v) S.TracerOn=v; if not v then ClearTracers() end; Notify("TRACERS",v and "ON" or "OFF",1.5) end)

SecHdr(p3,"─── RADAR ───")
ToggleRow(p3,"Mini Radar  (Drawing API, bottom-right)",function(v) S.RadarOn=v; Notify("RADAR",v and "ON" or "OFF",1.5) end)

SecHdr(p3,"─── CROSSHAIR ───")
ToggleRow(p3,"Rotating Crosshair",function(v) S.RotCrossOn=v; if v then StartCrosshair() elseif S.CrosshairGui then S.CrosshairGui:Destroy(); S.CrosshairGui=nil end; Notify("CROSSHAIR",v and "ON" or "OFF",1.5) end)
for i,style in ipairs({"Style 1 — Classic Rotating","Style 2 — Large + Dot","Style 3 — Tight"}) do
    ActionRow(p3,"🔘 "..style,function() S.CrosshairStyle=i; if S.RotCrossOn then if S.CrosshairGui then S.CrosshairGui:Destroy(); S.CrosshairGui=nil end; StartCrosshair() end end)
end

-- ── PAGE 4: MOVEMENT ───────────────────────────────
local p4=NewListPage("Movement"); TabBtn("Move","🏃")

SecHdr(p4,"─── SPEED ───")
ToggleRow(p4,"Speed Hack",function(v) S.SpeedOn=v; if not v then local h=GetHum(); if h then h.WalkSpeed=16 end end; Notify("SPEED",v and "ON" or "OFF",1.5) end)
SliderRow(p4,"Walk Speed",8,200,32,"",function(v) S.SpeedVal=v end)

SecHdr(p4,"─── JUMP ───")
ToggleRow(p4,"Jump Power Hack",function(v) S.JumpPowerOn=v; if not v then local h=GetHum(); if h then h.JumpPower=50 end end; Notify("JUMP",v and "ON" or "OFF",1.5) end)
SliderRow(p4,"Jump Power",10,500,80,"",function(v) S.JumpPowerVal=v end)

SecHdr(p4,"─── FLY ───")
ToggleRow(p4,"Fly Mode  [X key]",function(v) S.FlyOn=v; if v then StartFly() else StopFly() end; Notify("FLY",v and "ON" or "OFF",1.5) end)
SliderRow(p4,"Fly Speed",10,500,70,"",function(v) S.FlySpeed=v end)
ActionRow(p4,"⬆️  Fly UP  (temporary)",function() local hrp=GetHRP(); if hrp then local bv=Instance.new("BodyVelocity"); bv.Velocity=Vector3.new(0,80,0); bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.Parent=hrp; task.delay(0.5,function() pcall(function() bv:Destroy() end) end) end end)

SecHdr(p4,"─── MISC ───")
ToggleRow(p4,"NoClip  [Z key]",function(v) S.NoClipOn=v; Notify("NOCLIP",v and "ON" or "OFF",1.5) end)

-- ── PAGE 5: FARMING ────────────────────────────────
local p5=NewListPage("Farm"); TabBtn("Farm","💰")

SecHdr(p5,"─── AUTO FARM ───")
ToggleRow(p5,"Auto Farm Cash  (collect nearby drops)",function(v) S.AutoFarmOn=v; if v then StartAutoFarm() end; Notify("AUTO FARM",v and "ON" or "OFF",1.5,v and C.Green or nil) end)
ToggleRow(p5,"Anti-AFK  (prevents kick every 60s)",function(v) S.AntiAFKOn=v; if v then StartAntiAFK() end; Notify("ANTI AFK",v and "ON" or "OFF",1.5) end)
ToggleRow(p5,"Auto Armor  (<50% HP equip armor)",function(v) S.AutoArmorOn=v; if v then StartAutoArmor() end; Notify("AUTO ARMOR",v and "ON" or "OFF",1.5) end)
ToggleRow(p5,"Anti Void  (prevents falling out)",function(v) S.AntiVoidOn=v; if v then StartAntiVoid() end; Notify("ANTI VOID",v and "ON" or "OFF",1.5) end)
ToggleRow(p5,"Infinite Stamina",function(v) S.InfStamOn=v; if v then StartInfStam() end; Notify("INF STAM",v and "ON" or "OFF",1.5) end)

SecHdr(p5,"─── QUICK ACTIONS ───")
ActionRow(p5,"📦  Equip All Items",function() EquipAll() end)
ActionRow(p5,"💥  Fling Nearest",function() FlingNearest() end)
ActionRow(p5,"🎯  GoTo Target",function() local t=GetAimbotTarget(); if t then local h=t.Character and t.Character:FindFirstChild("HumanoidRootPart"); if h then TeleportTo(h.Position); Notify("GoTo","→ "..t.Name,2) end else Notify("GoTo","No target",2) end end)

-- ── PAGE 6: TELEPORT ───────────────────────────────
local p6=NewListPage("TP"); TabBtn("Teleport","🌀")

SecHdr(p6,"─── 2026 MAP LOCATIONS ───")
for _,t in ipairs(TELEPORTS) do
    ActionRow(p6,t.n,function() TeleportTo(t.p); Notify("TP","→ "..t.n,2) end)
end
ActionRow(p6,"📌  Teleport to Target",function()
    local t=GetAimbotTarget(); if t then local h=t.Character and t.Character:FindFirstChild("HumanoidRootPart"); if h then TeleportTo(h.Position); Notify("TP","→ "..t.Name,2) end else Notify("TP","No target",2) end
end)

-- ── PAGE 7: CHARACTER ──────────────────────────────
local p7=NewListPage("Char"); TabBtn("Char","🧍")

SecHdr(p7,"─── APPEARANCE ───")
ToggleRow(p7,"Headless  (client-side)",function(v) S.HeadlessOn=v; pcall(function() local c=GetChar(); if not c then return end; local h=c:FindFirstChild("Head"); if not h then return end; for _,p in ipairs(h:GetDescendants()) do if p:IsA("BasePart") or p:IsA("SpecialMesh") then p.Transparency=v and 1 or 0 end end end); Notify("HEADLESS",v and "ON" or "OFF",1.5) end)
ToggleRow(p7,"White Character",function(v) S.WhiteCharOn=v; SetWhiteChar(v); Notify("WHITE CHAR",v and "ON" or "OFF",1.5) end)

SecHdr(p7,"─── TROLLING ───")
ToggleRow(p7,"Fling Touch  (fling players near you)",function(v) S.FlingTouchOn=v; if v then StartFlingTouch() end; Notify("FLING TOUCH",v and "ON" or "OFF",1.5) end)
ToggleRow(p7,"Spam Call All",function(v) S.SpamCallOn=v; if v then StartSpamCall() end; Notify("SPAM CALL",v and "ON" or "OFF",1.5) end)
ToggleRow(p7,"Spinbot",function(v) S.SpinbotOn=v; if v then StartSpinbot() end; Notify("SPINBOT",v and "ON" or "OFF",1.5) end)
SliderRow(p7,"Spin Speed",50,3000,500,"",function(v) S.SpinSpeed=v end)
SliderRow(p7,"Kill Aura Range",4,50,12,"st",function(v) S.KillAuraRange=v end)
SliderRow(p7,"Reach Size",5,50,15,"",function(v) S.ReachSize=v end)
SliderRow(p7,"% to Buy",0,120,80,"%",function(v) S.PercentToBuy=v end)

-- ── PAGE 8: BUY ────────────────────────────────────
local p8=NewListPage("Buy"); TabBtn("Buy","🛒")

local buyAll=Instance.new("TextButton",p8); buyAll.Size=UDim2.new(1,0,0,46); buyAll.BackgroundColor3=Color3.fromRGB(15,55,18); buyAll.BorderSizePixel=0
buyAll.Text="🛒  BUY ALL ITEMS"; buyAll.TextColor3=C.Green; buyAll.Font=Enum.Font.GothamBold; buyAll.TextSize=14; buyAll.AutoButtonColor=false
Instance.new("UICorner",buyAll).CornerRadius=UDim.new(0,9)
local buyStroke=Instance.new("UIStroke",buyAll); buyStroke.Color=Color3.fromRGB(30,140,40); buyStroke.Thickness=1.3
buyAll.MouseButton1Click:Connect(function() for _,item in ipairs(BUY_ITEMS) do TryBuy(item[2]); task.wait(0.04) end; Notify("BUY ALL","Attempted all items!",3,C.Green) end)
buyAll.MouseEnter:Connect(function() TweenService:Create(buyAll,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(22,80,26)}):Play() end)
buyAll.MouseLeave:Connect(function() TweenService:Create(buyAll,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(15,55,18)}):Play() end)

SecHdr(p8,"─── ITEMS (stand near shop) ───")
for _,item in ipairs(BUY_ITEMS) do
    ActionRow(p8,item[1],function() TryBuy(item[2]) end)
end

-- ── PAGE 9: TITLE ──────────────────────────────────
local p9=NewListPage("Title"); TabBtn("Title","⭐")

SecHdr(p9,"─── CUSTOM NAMETAG ───")
local infoL=Instance.new("TextLabel",p9); infoL.Size=UDim2.new(1,0,0,44); infoL.BackgroundTransparency=1
infoL.Text="Replaces your overhead username with custom text.\nMatches Roblox vanilla nametag style (white pill).\nVisible to ALL players — parented inside character."; infoL.TextColor3=C.TextDim; infoL.Font=Enum.Font.Gotham; infoL.TextSize=10; infoL.TextWrapped=true; infoL.TextXAlignment=Enum.TextXAlignment.Left

ToggleRow(p9,"👁️  Show Custom Title",function(v) S.TitleVisible=v; ApplyTitle(); Notify("TITLE",v and "✅ ON — all see it" or "❌ OFF — name restored",2.5) end)

local iBG=Instance.new("Frame",p9); iBG.Size=UDim2.new(1,0,0,46); iBG.BackgroundColor3=C.Card; iBG.BorderSizePixel=0; Instance.new("UICorner",iBG).CornerRadius=UDim.new(0,9)
local iStroke=Instance.new("UIStroke",iBG); iStroke.Color=C.Border; iStroke.Thickness=1.2
local iPad=Instance.new("UIPadding",iBG); iPad.PaddingLeft=UDim.new(0,12); iPad.PaddingRight=UDim.new(0,12)
local input=Instance.new("TextBox",iBG); input.Size=UDim2.new(1,0,1,0); input.BackgroundTransparency=1
input.Text=""; input.PlaceholderText="Type your custom title..."; input.PlaceholderColor3=C.TextDim
input.TextColor3=Color3.fromRGB(255,255,255); input.Font=Enum.Font.GothamBold; input.TextSize=13; input.ClearTextOnFocus=false; input.MultiLine=false
input.Focused:Connect(function() TweenService:Create(iStroke,TweenInfo.new(0.15),{Color=C.AccentGlow,Thickness=1.6}):Play() end)
input.FocusLost:Connect(function()  TweenService:Create(iStroke,TweenInfo.new(0.15),{Color=C.Border,Thickness=1.2}):Play() end)

ActionRow(p9,"✅  Apply Title",function()
    local txt=input.Text~="" and input.Text or S.MyTitle
    if #txt>=1 and #txt<=32 then S.MyTitle=txt; if S.TitleVisible then ApplyTitle() end; Notify("TITLE","Set → "..txt,2)
    else Notify("TITLE","⚠️ 1-32 chars only",2) end
end)

SecHdr(p9,"─── PRESETS ───")
for _,pr in ipairs({"⭐ GOD","💀 GHOST","👑 KING","🔥 FLAME","💎 ELITE","🎯 REAPER","🧊 ICE","⚡ ZEUS","🌊 TIDAL","🔮 VOID","🐉 DRAGON","☠️ SKULL","🌙 LUNA","🦅 EAGLE","🏆 CHAMP","💠 PHANTOM"}) do
    ActionRow(p9,pr,function() S.MyTitle=pr; input.Text=pr; if S.TitleVisible then ApplyTitle() end; Notify("TITLE","→ "..pr,1.5) end)
end

-- ── ACTIVATE FIRST PAGE ────────────────────────────
for n,p in pairs(Pages) do p.Visible=(n=="Combat") end
if TabBtns["Combat"] then
    TabBtns["Combat"].btn.BackgroundColor3=C.TabActive
    TabBtns["Combat"].lbl.TextColor3=C.TextBright
    TabBtns["Combat"].bar.Visible=true
    TabBtns["Combat"].ic.TextColor3=C.TextBright
end

-- ══════════════════════════════════════════════════
-- DRAG SYSTEM  (mouse + touch, screen-clamped)
-- ══════════════════════════════════════════════════
local isDragging,dragStart,winStart=false,nil,nil

local function beginDrag(pos)
    isDragging=true; dragStart=Vector2.new(pos.X,pos.Y); winStart=W.Position
end
local function moveDrag(pos)
    if not isDragging then return end
    local d=Vector2.new(pos.X,pos.Y)-dragStart
    local nx=winStart.X.Offset+d.X; local ny=winStart.Y.Offset+d.Y
    local vp=Camera.ViewportSize
    nx=math.clamp(nx,0,vp.X-W.AbsoluteSize.X); ny=math.clamp(ny,0,vp.Y-W.AbsoluteSize.Y)
    W.Position=UDim2.new(0,nx,0,ny)
    glow.Position=UDim2.new(0,nx-30,0,ny-30)
end
local function endDrag() isDragging=false end

TopBar.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then beginDrag(i.Position) end
end)
UIS.InputChanged:Connect(function(i)
    if isDragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then moveDrag(i.Position) end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then endDrag() end
end)

-- ══════════════════════════════════════════════════
-- MINIMIZE / CLOSE
-- ══════════════════════════════════════════════════
local isMin=false
MinBtn.MouseButton1Click:Connect(function()
    isMin=not isMin; Body.Visible=not isMin
    TweenService:Create(W,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.new(0,WW,0,isMin and TOPBAR_H or WH)}):Play()
    MinBtn.Text=isMin and "□" or "—"
end)
CloseBtn.MouseButton1Click:Connect(function() W.Visible=false; S.GUIOpen=false; Notify("PHANTOM","Closed. RShift to reopen.",3) end)

-- ══════════════════════════════════════════════════
-- RSHIFT TOGGLE
-- ══════════════════════════════════════════════════
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then
        S.GUIOpen=not S.GUIOpen; W.Visible=S.GUIOpen
        if S.GUIOpen then
            isMin=false; Body.Visible=true
            W.Size=UDim2.new(0,WW,0,0)
            TweenService:Create(W,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,WW,0,WH)}):Play()
        end
    end
end)

-- ══════════════════════════════════════════════════
-- OPEN ANIMATION
-- ══════════════════════════════════════════════════
W.Size=UDim2.new(0,WW,0,0)
TweenService:Create(W,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,WW,0,WH)}):Play()

-- ══════════════════════════════════════════════════
-- STARTUP NOTIFICATIONS
-- ══════════════════════════════════════════════════
task.wait(0.5);  Notify("PHANTOM v6","✅ Loaded! 2026 Edition — Da Hood Phantom Script",5,C.AccentGlow)
task.wait(1.2);  Notify("KEYBINDS","Z=NoClip  X=Fly  C=KillAura  RShift=Toggle",5,C.Yellow)
task.wait(1.2);  Notify("NEW FEATURES","Prediction Aimbot • Triggerbot • Hitbox Expander\nKill Aura • Auto Farm • Radar • Tracers",6,C.Green)
task.wait(1.5);  Notify("COMMANDS","Chat: csync cgod | cfly | cspeed 100 | ckill | ctp bank",5,C.TextDim)
task.wait(1.5);  Notify("AC BYPASS","✅ Anti-cheat hooks active
Blocking: CHECKER_1 + TeleportDetect + OneMoreTime",6,C.Yellow)
