--[[
╔══════════════════════════════════════════════════════════════════╗
║         DA HOOD  ·  GOD SCRIPT  ·  v5.0  (2026 Edition)        ║
║  Clean UI • Draggable • Mobile Friendly • Fixed Minimize        ║
║  Updated Locations • Updated Guns • Touch + Mouse Drag          ║
╚══════════════════════════════════════════════════════════════════╝
  KEYBINDS (PC):
    RightShift  → Toggle GUI
    Z           → NoClip
    X           → Fly
]]

-- ────────────────────────────────────────────────
-- SERVICES
-- ────────────────────────────────────────────────
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local Workspace        = game:GetService("Workspace")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Camera           = Workspace.CurrentCamera

local LP    = Players.LocalPlayer
local LPGui = LP:WaitForChild("PlayerGui")

-- ────────────────────────────────────────────────
-- CLEAN UP OLD GUIs
-- ────────────────────────────────────────────────
for _, n in ipairs({"DaHoodGUI_v3","DaHoodGUI_v4","DaHoodGUI_v5"}) do
    local old = LPGui:FindFirstChild(n) or CoreGui:FindFirstChild(n)
    if old then old:Destroy() end
end

-- ────────────────────────────────────────────────
-- THEME COLORS
-- ────────────────────────────────────────────────
local C = {
    BG        = Color3.fromRGB(10,  10,  18),
    TopBar    = Color3.fromRGB(15,  12,  26),
    Sidebar   = Color3.fromRGB(13,  10,  22),
    Content   = Color3.fromRGB(11,  9,   19),
    Card      = Color3.fromRGB(18,  14,  30),
    CardHov   = Color3.fromRGB(28,  18,  46),
    Accent    = Color3.fromRGB(160, 0,   220),
    AccentGlow= Color3.fromRGB(220, 0,   255),
    AccentSoft= Color3.fromRGB(120, 0,   180),
    TabActive = Color3.fromRGB(140, 0,   200),
    Border    = Color3.fromRGB(70,  0,   130),
    Text      = Color3.fromRGB(220, 180, 255),
    TextBright= Color3.fromRGB(255, 255, 255),
    TextDim   = Color3.fromRGB(130, 110, 150),
    Green     = Color3.fromRGB(50,  220, 80),
    Red       = Color3.fromRGB(220, 50,  50),
    ToggleOff = Color3.fromRGB(40,  20,  60),
}

-- ────────────────────────────────────────────────
-- STATE
-- ────────────────────────────────────────────────
local S = {
    GUIOpen      = true,
    Minimized    = false,
    CurrentPage  = "Main",
    -- player
    GodBlockOn   = false,
    GodArmor     = false,
    NoRecoilOn   = false,
    ReachOn      = false,
    HeadlessOn   = false,
    FlyOn        = false,
    FlySpeed     = 70,
    NoClipOn     = false,
    SpeedOn      = false,
    SpeedVal     = 32,
    FreeFistsOn  = false,
    FlingOn      = false,
    ViewOn       = false,
    -- visual
    ESPOn        = false,
    ChamsOn      = false,
    ESPObjects   = {},
    ChamsObjects = {},
    -- aimbot
    AimbotOn     = false,
    SilentAim    = false,
    AimbotPart   = "Head",
    AimbotFOV    = 180,
    AimbotSmooth = 0.18,
    TeamCheck    = false,
    WallCheck    = false,
    -- character
    WhiteCharOn     = false,
    FlingTouchOn    = false,
    SpamCallOn      = false,
    RotatingCrossOn = false,
    AntiVoidOn      = false,
    AutoArmorOn     = false,
    SpinbotOn       = false,
    SpinSpeed       = 500,
    PercentToBuy    = 80,
    -- title
    MyTitle        = "⭐ PLAYER",
    TitleVisible   = false,
    TitleBillboard = nil,
    -- connections
    FlyBV = nil, FlyBG = nil,
    FlingTouchConn = nil, SpamCallConn = nil,
    AntiVoidConn = nil, AutoArmorConn = nil,
    SpinbotConn = nil, godConn = nil,
    CrosshairGui = nil,
}

-- ────────────────────────────────────────────────
-- 2026 DA HOOD TELEPORT LOCATIONS
-- (Updated with accurate map positions)
-- ────────────────────────────────────────────────
local TELEPORTS = {
    { name = "🏦 Bank",              pos = Vector3.new(-30,   5,   20)  },
    { name = "🏥 Hospital",          pos = Vector3.new( 120,  5,  -40)  },
    { name = "🔒 Jail",              pos = Vector3.new(-150,  5,  -60)  },
    { name = "🏠 Spawn",             pos = Vector3.new(   0,  5,    0)  },
    { name = "👮 Police Station",    pos = Vector3.new( -80,  5, -100)  },
    { name = "🔫 Gun Store North",   pos = Vector3.new(  60,  5,  100)  },
    { name = "🔫 Gun Store South",   pos = Vector3.new(  80,  5, -120)  },
    { name = "🌮 Jeff's Taco Place", pos = Vector3.new(-120,  5,   60)  },
    { name = "💪 Hood Fitness",      pos = Vector3.new(  20,  5,  -20)  },
    { name = "⛪ Church",            pos = Vector3.new( -40,  5,  180)  },
    { name = "🎰 Casino",            pos = Vector3.new( 180,  5,  140)  },
    { name = "🏀 Basketball Court",  pos = Vector3.new( 150,  5,   40)  },
    { name = "🥊 Boxing Club",       pos = Vector3.new(  30,  5, -180)  },
    { name = "🍔 Burger Shop",       pos = Vector3.new(  10,  5,  -80)  },
    { name = "💍 Jewelry Store",     pos = Vector3.new( -60,  5,  -50)  },
    { name = "🛋️ Furniture Store",   pos = Vector3.new(  90,  5,   60)  },
    { name = "🎭 Club / Nightclub",  pos = Vector3.new(-100,  5,  120)  },
    { name = "🏗️ Construction Site", pos = Vector3.new( 200,  5,  -80)  },
    { name = "🔴 Red Spot",          pos = Vector3.new(   5,  5,   40)  },
    { name = "🏎️ Car Spawn",         pos = Vector3.new( -10,  5,   70)  },
}

-- ────────────────────────────────────────────────
-- 2026 DA HOOD BUY ITEMS
-- (Updated with all current guns & items)
-- ────────────────────────────────────────────────
local BUY_ITEMS = {
    -- Melee
    { "🔪 Knife",           "Knife"              },
    { "🥊 Bat",             "Bat"                },
    { "🗡️ Katana",          "Katana"             },
    -- Pistols
    { "🔫 Pistol",          "Pistol"             },
    { "🔫 Pistol Ammo",     "PistolAmmo"         },
    { "🔫 Revolver",        "Revolver"           },
    { "🔫 Revolver Ammo",   "RevolverAmmo"       },
    { "🔫 Deagle",          "Deagle"             },
    { "🔫 Deagle Ammo",     "DeagleAmmo"         },
    -- Rifles / ARs
    { "🔫 AK47",            "AK47"               },
    { "🔫 AK47 Ammo",       "AK47Ammo"           },
    { "🔫 Rifle",           "Rifle"              },
    { "🔫 Rifle Ammo",      "RifleAmmo"          },
    { "🔫 M4A1",            "M4A1"               },
    { "🔫 M4A1 Ammo",       "M4A1Ammo"           },
    -- Shotguns
    { "🔫 Tactical Shotgun","TacticalShotgun"    },
    { "🔫 TacShot Ammo",    "TacticalShotgunAmmo"},
    { "🔫 Double Barrel",   "DoubleBarrel"       },
    { "🔫 DB Ammo",         "DoubleBarrelAmmo"   },
    -- Heavy
    { "🔫 LMG",             "LMG"                },
    { "🔫 LMG Ammo",        "LMGAmmo"            },
    { "🔫 DrumGun",         "DrumGun"            },
    { "🔫 DrumGun Ammo",    "DrumGunAmmo"        },
    { "🚀 RPG",             "RPG"                },
    { "🚀 RPG Ammo",        "RPGAmmo"            },
    { "💣 Grenade",         "Grenade"            },
    -- Armor
    { "🛡️ Low Armor",       "LowArmor"           },
    { "🛡️ Mid Armor",       "MidArmor"           },
    { "🛡️ High Armor",      "HighArmor"          },
    { "🛡️ Fire Armor",      "FireArmor"          },
    { "🛡️ High Med Armor",  "HighMediumArmor"    },
    -- Food / Heal
    { "❤️ Med Kit",         "MedKit"             },
    { "🍎 Apple",           "Apple"              },
    { "🍔 Hamburger",       "Hamburger"          },
}

-- ─────────────────────────────────────────
-- NOTIFICATION SYSTEM
-- ─────────────────────────────────────────
local NotifHolder
local function EnsureNotifs()
    if NotifHolder and NotifHolder.Parent then return end
    local ng = Instance.new("ScreenGui")
    ng.Name = "GodNotifs_v5"; ng.ResetOnSpawn = false
    ng.IgnoreGuiInset = true; ng.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ng.Parent = LPGui
    NotifHolder = Instance.new("Frame", ng)
    NotifHolder.Size = UDim2.new(0, 270, 1, -20)
    NotifHolder.Position = UDim2.new(1, -280, 0, 10)
    NotifHolder.BackgroundTransparency = 1
    local ul = Instance.new("UIListLayout", NotifHolder)
    ul.VerticalAlignment = Enum.VerticalAlignment.Bottom
    ul.Padding = UDim.new(0, 6)
end

local function Notify(title, msg, t)
    EnsureNotifs()
    local f = Instance.new("Frame", NotifHolder)
    f.Size = UDim2.new(1, 0, 0, 58); f.BackgroundColor3 = Color3.fromRGB(12, 8, 24); f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local sk = Instance.new("UIStroke", f); sk.Color = C.AccentGlow; sk.Thickness = 1.2
    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(0, 3, 0.6, 0); bar.Position = UDim2.new(0, 5, 0.2, 0)
    bar.BackgroundColor3 = C.Accent; bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local tl = Instance.new("TextLabel", f)
    tl.Size = UDim2.new(1,-14,0,22); tl.Position = UDim2.new(0,13,0,6)
    tl.BackgroundTransparency = 1; tl.Text = title
    tl.TextColor3 = C.AccentGlow; tl.Font = Enum.Font.GothamBold; tl.TextSize = 12
    tl.TextXAlignment = Enum.TextXAlignment.Left
    local bl = Instance.new("TextLabel", f)
    bl.Size = UDim2.new(1,-14,0,20); bl.Position = UDim2.new(0,13,0,30)
    bl.BackgroundTransparency = 1; bl.Text = msg
    bl.TextColor3 = C.TextDim; bl.Font = Enum.Font.Gotham; bl.TextSize = 11
    bl.TextXAlignment = Enum.TextXAlignment.Left
    task.delay(t or 3, function()
        TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
        task.wait(0.35); if f.Parent then f:Destroy() end
    end)
end

-- ─────────────────────────────────────────
-- CORE FEATURES
-- ─────────────────────────────────────────

-- GOD BLOCK
local function StartGodBlock()
    if S.godConn then S.godConn:Disconnect() end
    S.godConn = RunService.Heartbeat:Connect(function()
        if not S.GodBlockOn then S.godConn:Disconnect(); return end
        local c = LP.Character; if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid"); if h then h.Health = h.MaxHealth end
    end)
end

-- REACH
local function SetReach(on)
    pcall(function()
        local char = LP.Character; if not char then return end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local h = tool:FindFirstChild("Handle")
                if h then h.Size = on and Vector3.new(20,1,20) or Vector3.new(1,1,1) end
            end
        end
    end)
end

-- FLY
local function StartFly()
    local char = LP.Character; if not char then return end
    local hrp  = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum  = char:FindFirstChildOfClass("Humanoid"); if hum then hum.PlatformStand = true end
    if S.FlyBV then S.FlyBV:Destroy() end
    if S.FlyBG then S.FlyBG:Destroy() end
    S.FlyBV = Instance.new("BodyVelocity"); S.FlyBV.Velocity = Vector3.new(0,0,0); S.FlyBV.MaxForce = Vector3.new(1e9,1e9,1e9); S.FlyBV.Parent = hrp
    S.FlyBG = Instance.new("BodyGyro"); S.FlyBG.MaxTorque = Vector3.new(1e9,1e9,1e9); S.FlyBG.P = 1e4; S.FlyBG.CFrame = hrp.CFrame; S.FlyBG.Parent = hrp
end
local function StopFly()
    if S.FlyBV then S.FlyBV:Destroy(); S.FlyBV = nil end
    if S.FlyBG then S.FlyBG:Destroy(); S.FlyBG = nil end
    local char = LP.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum.PlatformStand = false end
end

-- TELEPORT
local function TeleportTo(pos)
    local c = LP.Character; if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
end

-- FLING NEAREST
local function FlingNearest()
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not myHRP then return end
    local best, bestDist = nil, math.huge
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP then continue end
        local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
        local d = (myHRP.Position - hrp.Position).Magnitude
        if d < bestDist then bestDist = d; best = hrp end
    end
    if best then
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = (best.Position - myHRP.Position).Unit * 250 + Vector3.new(0, 120, 0)
        bv.MaxForce = Vector3.new(1e9,1e9,1e9); bv.Parent = best
        task.delay(0.2, function() pcall(function() bv:Destroy() end) end)
        Notify("FLING","Flung nearest player!", 2)
    end
end

-- WHITE CHARACTER
local function SetWhiteCharacter(on)
    pcall(function()
        local char = LP.Character; if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                if on then
                    part:SetAttribute("_origBrick", tostring(part.BrickColor))
                    part.BrickColor = BrickColor.new("White"); part.Material = Enum.Material.SmoothPlastic
                else
                    local orig = part:GetAttribute("_origBrick")
                    if orig then part.BrickColor = BrickColor.new(orig) end
                end
            end
        end
    end)
end

-- FLING TOUCH
local function StartFlingTouch()
    if S.FlingTouchConn then S.FlingTouchConn:Disconnect() end
    S.FlingTouchConn = RunService.Heartbeat:Connect(function()
        if not S.FlingTouchOn then S.FlingTouchConn:Disconnect(); return end
        local char = LP.Character; local myHRP = char and char:FindFirstChild("HumanoidRootPart"); if not myHRP then return end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl == LP then continue end
            local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
            if (myHRP.Position - hrp.Position).Magnitude < 6 then
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = (hrp.Position - myHRP.Position).Unit * 220 + Vector3.new(0, 120, 0)
                bv.MaxForce = Vector3.new(1e9,1e9,1e9); bv.Parent = hrp
                task.delay(0.15, function() pcall(function() bv:Destroy() end) end)
            end
        end
    end)
end

-- SPAM CALL
local function StartSpamCall()
    if S.SpamCallConn then S.SpamCallConn:Disconnect() end
    S.SpamCallConn = RunService.Heartbeat:Connect(function()
        if not S.SpamCallOn then S.SpamCallConn:Disconnect(); return end
        pcall(function()
            local remote = ReplicatedStorage:FindFirstChild("Remotes", true)
            if remote then
                local callRem = remote:FindFirstChild("Call") or remote:FindFirstChild("PhoneCall")
                if callRem then
                    for _, pl in ipairs(Players:GetPlayers()) do
                        if pl ~= LP then pcall(function() callRem:FireServer(pl) end) end
                    end
                end
            end
        end)
        task.wait(0.3)
    end)
end

-- ROTATING CROSSHAIR
local function StartCrosshair()
    if S.CrosshairGui then S.CrosshairGui:Destroy() end
    S.CrosshairGui = Instance.new("ScreenGui")
    S.CrosshairGui.Name = "RotatingCrosshair"; S.CrosshairGui.ResetOnSpawn = false
    S.CrosshairGui.IgnoreGuiInset = true; S.CrosshairGui.Parent = LPGui
    local lines, angle = {}, 0
    for i = 1, 4 do
        local ln = Instance.new("Frame", S.CrosshairGui)
        ln.BackgroundColor3 = Color3.fromRGB(255,60,255); ln.BorderSizePixel = 0
        ln.Size = UDim2.new(0,14,0,2); ln.AnchorPoint = Vector2.new(0.5,0.5)
        table.insert(lines, ln)
    end
    RunService.RenderStepped:Connect(function()
        if not S.RotatingCrossOn or not S.CrosshairGui or not S.CrosshairGui.Parent then return end
        angle = (angle + 2) % 360
        local cx, cy = Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2
        for i, ln in ipairs(lines) do
            local a = math.rad(angle + (i-1)*90)
            ln.Position = UDim2.new(0, cx + math.cos(a)*20, 0, cy + math.sin(a)*20)
            ln.Rotation = math.deg(a)
        end
    end)
end
local function StopCrosshair()
    if S.CrosshairGui then S.CrosshairGui:Destroy(); S.CrosshairGui = nil end
end

-- ANTI VOID
local function StartAntiVoid()
    if S.AntiVoidConn then S.AntiVoidConn:Disconnect() end
    S.AntiVoidConn = RunService.Heartbeat:Connect(function()
        if not S.AntiVoidOn then S.AntiVoidConn:Disconnect(); return end
        local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Position.Y < -80 then hrp.CFrame = CFrame.new(hrp.Position.X, 15, hrp.Position.Z) end
    end)
end

-- AUTO ARMOR
local function StartAutoArmor()
    if S.AutoArmorConn then S.AutoArmorConn:Disconnect() end
    S.AutoArmorConn = RunService.Heartbeat:Connect(function()
        if not S.AutoArmorOn then S.AutoArmorConn:Disconnect(); return end
        local char = LP.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if hum.Health < hum.MaxHealth * 0.5 then
            pcall(function()
                for _, tool in ipairs(LP.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:lower():find("armor") or tool.Name:lower():find("vest")) then
                        hum:EquipTool(tool); break
                    end
                end
            end)
        end
    end)
end

-- SPINBOT
local function StartSpinbot()
    if S.SpinbotConn then S.SpinbotConn:Disconnect() end
    S.SpinbotConn = RunService.RenderStepped:Connect(function()
        if not S.SpinbotOn then S.SpinbotConn:Disconnect(); return end
        local char = LP.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.SpinSpeed * 0.016), 0)
    end)
end

-- EQUIP ALL GUNS
local function EquipAllGuns()
    pcall(function()
        local char = LP.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        for _, tool in ipairs(LP.Backpack:GetChildren()) do
            if tool:IsA("Tool") then hum:EquipTool(tool); task.wait(0.05) end
        end
    end)
    Notify("EQUIP ALL","Equipped all tools from backpack",2)
end

-- BUY ITEM
local function TryBuy(itemName)
    local ok = false
    pcall(function()
        local buyRemote = ReplicatedStorage:FindFirstChild("BuyItem",true)
                       or ReplicatedStorage:FindFirstChild("Purchase",true)
                       or ReplicatedStorage:FindFirstChild("Buy",true)
                       or ReplicatedStorage:FindFirstChild("ShopBuy",true)
                       or ReplicatedStorage:FindFirstChild("ShopEvent",true)
        if buyRemote then buyRemote:FireServer(itemName); ok = true; return end
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                local t = (prompt.ActionText or ""):lower()
                local pn = (prompt.Parent and prompt.Parent.Name or ""):lower()
                if t:find(itemName:lower(),1,true) or pn:find(itemName:lower(),1,true) then
                    fireproximityprompt(prompt); ok = true; return
                end
            end
        end
    end)
    Notify("BUY", ok and "Buying: "..itemName or "⚠️ Be near the shop! → "..itemName, 2)
end

-- TITLE BILLBOARD
local function RemoveTitle()
    if S.TitleBillboard and S.TitleBillboard.Parent then S.TitleBillboard:Destroy() end
    S.TitleBillboard = nil
end
local function ApplyTitle()
    RemoveTitle(); if not S.TitleVisible then return end
    local char = LP.Character; if not char then return end
    local head = char:FindFirstChild("Head"); if not head then return end
    local bb = Instance.new("BillboardGui"); bb.Name="GodTitleBB"; bb.Adornee=head
    bb.Size=UDim2.new(0,200,0,36); bb.StudsOffset=Vector3.new(0,2.8,0)
    bb.AlwaysOnTop=true; bb.LightInfluence=0; bb.MaxDistance=120; bb.ResetOnSpawn=false; bb.Parent=CoreGui
    local bg = Instance.new("Frame",bb); bg.Size=UDim2.new(1,0,1,0); bg.BackgroundColor3=Color3.fromRGB(0,0,0); bg.BackgroundTransparency=0.35; bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(0,7)
    local sk = Instance.new("UIStroke",bg); sk.Color=C.AccentGlow; sk.Thickness=1.5
    local lbl = Instance.new("TextLabel",bg); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
    lbl.Text=S.MyTitle; lbl.TextColor3=C.AccentGlow; lbl.TextStrokeTransparency=0.3; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=14
    S.TitleBillboard = bb
end

-- AIMBOT TARGET
local AimbotTarget
local function GetTarget()
    local best, bestDist = nil, S.AimbotFOV
    local vc = Camera.ViewportSize; local sc = Vector2.new(vc.X/2,vc.Y/2)
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP then continue end
        if S.TeamCheck and pl.Team == LP.Team then continue end
        local char = pl.Character; if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then continue end
        local part = char:FindFirstChild(S.AimbotPart) or char:FindFirstChild("Head"); if not part then continue end
        if S.WallCheck then
            local orig = Camera.CFrame.Position
            local ray  = Ray.new(orig, (part.Position-orig).Unit*9000)
            local hit  = Workspace:FindPartOnRayWithIgnoreList(ray,{LP.Character})
            if hit and not char:IsAncestorOf(hit) then continue end
        end
        local vp, depth, inV = Camera:WorldToViewportPoint(part.Position)
        if not inV or depth < 0 then continue end
        local d = (Vector2.new(vp.X,vp.Y)-sc).Magnitude
        if d < bestDist then bestDist=d; best=pl end
    end
    return best
end

-- ESP
local function ClearESP()
    for _, t in pairs(S.ESPObjects) do for _, d in pairs(t) do pcall(function() d:Destroy() end) end end
    S.ESPObjects = {}
end
local function UpdateESP()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP then continue end
        if S.ESPOn and not S.ESPObjects[pl] then
            local box  = Drawing.new("Square"); box.Visible=false; box.Filled=false; box.Thickness=1.5; box.Color=C.AccentGlow
            local hp   = Drawing.new("Square"); hp.Visible=false; hp.Filled=true; hp.Color=C.Green
            local nm   = Drawing.new("Text");   nm.Visible=false; nm.Size=13; nm.Font=2; nm.Color=Color3.fromRGB(255,255,255); nm.Outline=true; nm.Center=true
            local dist = Drawing.new("Text");   dist.Visible=false; dist.Size=11; dist.Font=2; dist.Color=Color3.fromRGB(200,200,220); dist.Outline=true; dist.Center=true
            S.ESPObjects[pl] = {box=box,hp=hp,nm=nm,dist=dist}
        end
        local esp = S.ESPObjects[pl]; if not esp then continue end
        local char = pl.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not S.ESPOn or not hrp or not hum or hum.Health <= 0 then for _,d in pairs(esp) do d.Visible=false end; continue end
        local rp,depth,inV = Camera:WorldToViewportPoint(hrp.Position)
        local hp2,_,_ = Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,3,0))
        if not inV or depth < 0 then for _,d in pairs(esp) do d.Visible=false end; continue end
        local h = math.abs(hp2.Y-rp.Y)*2.5; local w = h*0.55
        esp.box.Size=Vector2.new(w,h); esp.box.Position=Vector2.new(rp.X-w/2,rp.Y-h/2); esp.box.Visible=true
        local r = hum.Health/hum.MaxHealth
        esp.hp.Size=Vector2.new(4,h*r); esp.hp.Position=Vector2.new(rp.X-w/2-7,rp.Y-h/2+h*(1-r))
        esp.hp.Color=Color3.fromRGB(math.floor(255*(1-r)),math.floor(255*r),50); esp.hp.Visible=true
        esp.nm.Text=pl.Name; esp.nm.Position=Vector2.new(rp.X,rp.Y-h/2-16); esp.nm.Visible=true
        local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local d2 = myHRP and math.floor((myHRP.Position-hrp.Position).Magnitude) or 0
        esp.dist.Text=d2.."m"; esp.dist.Position=Vector2.new(rp.X,rp.Y+h/2+2); esp.dist.Visible=true
    end
end

-- CHAMS
local function UpdateChams()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP then continue end
        local char = pl.Character
        if S.ChamsOn and char then
            if not S.ChamsObjects[pl] then
                local hl = Instance.new("SelectionBox"); hl.Adornee=char
                hl.Color3=Color3.fromRGB(180,0,255); hl.SurfaceColor3=Color3.fromRGB(180,0,255)
                hl.SurfaceTransparency=0.65; hl.LineThickness=0.03; hl.Parent=CoreGui
                S.ChamsObjects[pl] = hl
            end
        else
            if S.ChamsObjects[pl] then S.ChamsObjects[pl]:Destroy(); S.ChamsObjects[pl]=nil end
        end
    end
end

-- NOCLIP
RunService.Stepped:Connect(function()
    if not S.NoClipOn then return end
    local c = LP.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
    end
end)

-- FOV CIRCLE
local FOVCircle
pcall(function()
    FOVCircle = Drawing.new("Circle"); FOVCircle.Visible=false; FOVCircle.Thickness=1.5
    FOVCircle.Color=C.AccentGlow; FOVCircle.Filled=false; FOVCircle.NumSides=64
end)

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if S.AimbotOn then
        AimbotTarget = GetTarget()
        if AimbotTarget and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local char = AimbotTarget.Character
            local part = char and (char:FindFirstChild(S.AimbotPart) or char:FindFirstChild("Head"))
            if part then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, part.Position), S.AimbotSmooth) end
        else AimbotTarget = nil end
    end
    if FOVCircle then
        FOVCircle.Visible = S.AimbotOn
        if S.AimbotOn then
            FOVCircle.Radius = S.AimbotFOV
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            FOVCircle.Color = AimbotTarget and C.Red or C.AccentGlow
        end
    end
    UpdateESP(); UpdateChams()
    -- Fly
    if S.FlyOn and S.FlyBV then
        local char = LP.Character; if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
                S.FlyBV.Velocity = dir * S.FlySpeed
                S.FlyBG.CFrame   = Camera.CFrame
            end
        end
    end
    -- Speed
    if S.SpeedOn then
        local c = LP.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = S.SpeedVal end
    end
end)

-- Character respawn
LP.CharacterAdded:Connect(function()
    task.wait(1.5)
    ApplyTitle()
    if S.WhiteCharOn  then SetWhiteCharacter(true) end
    if S.AntiVoidOn   then StartAntiVoid() end
    if S.AutoArmorOn  then StartAutoArmor() end
    if S.SpinbotOn    then StartSpinbot() end
    if S.FlingTouchOn then StartFlingTouch() end
    if S.FlyOn        then StartFly() end
    if S.GodBlockOn   then StartGodBlock() end
end)

-- CHAT COMMANDS
LP.Chatted:Connect(function(msg)
    local lower = msg:lower(); local parts
    if lower:sub(1,6)=="csync " then parts = msg:sub(7):split(" ")
    elseif msg:sub(1,1)==":" then parts = msg:sub(2):split(" ")
    else return end
    local cmd = (parts[1] or ""):lower(); local args = {table.unpack(parts,2)}
    if cmd=="cfly" then S.FlyOn=not S.FlyOn; if S.FlyOn then StartFly() else StopFly() end; Notify("FLY",S.FlyOn and "ON" or "OFF",2)
    elseif cmd=="cspeed" then local v=tonumber(args[1]); if v then S.SpeedVal=v; S.SpeedOn=true; Notify("SPEED","→ "..v,2) end
    elseif cmd=="cgod" then S.GodBlockOn=not S.GodBlockOn; if S.GodBlockOn then StartGodBlock() end; Notify("GOD",S.GodBlockOn and "ON" or "OFF",2)
    elseif cmd=="cesp" then S.ESPOn=not S.ESPOn; if not S.ESPOn then ClearESP() end; Notify("ESP",S.ESPOn and "ON" or "OFF",2)
    elseif cmd=="caimbot" then S.AimbotOn=not S.AimbotOn; Notify("AIMBOT",S.AimbotOn and "ON" or "OFF",2)
    elseif cmd=="cnoclip" then S.NoClipOn=not S.NoClipOn; Notify("NOCLIP",S.NoClipOn and "ON" or "OFF",2)
    elseif cmd=="ctp" then
        local name = table.concat(args," ")
        for _, t in ipairs(TELEPORTS) do
            if t.name:lower():find(name:lower(),1,true) then TeleportTo(t.pos); Notify("TELEPORT","→ "..t.name,2); return end
        end
        Notify("TELEPORT","Not found: "..name,2)
    end
end)

-- KEYBINDS
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.Z then
        S.NoClipOn = not S.NoClipOn; Notify("NOCLIP", S.NoClipOn and "ON" or "OFF", 1.5)
    elseif inp.KeyCode == Enum.KeyCode.X then
        S.FlyOn = not S.FlyOn; if S.FlyOn then StartFly() else StopFly() end; Notify("FLY", S.FlyOn and "ON" or "OFF", 1.5)
    end
end)

-- ─────────────────────────────────────────
-- ██████████  G U I  BUILD  ██████████
-- ─────────────────────────────────────────

local SG = Instance.new("ScreenGui")
SG.Name = "DaHoodGUI_v5"; SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; SG.IgnoreGuiInset = true
SG.Parent = LPGui

-- ── WINDOW ──────────────────────────────
local WIN_W, WIN_H = 640, 460
local WIN_H_MIN    = 40  -- minimized height

local W = Instance.new("Frame", SG)
W.Name = "Window"
W.Size = UDim2.new(0, WIN_W, 0, WIN_H)
W.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
W.BackgroundColor3 = C.BG; W.BorderSizePixel = 0
W.ClipsDescendants = true
Instance.new("UICorner", W).CornerRadius = UDim.new(0, 12)
local WStroke = Instance.new("UIStroke", W); WStroke.Color = C.AccentSoft; WStroke.Thickness = 1.5

-- Subtle glow
local glow = Instance.new("Frame", SG)
glow.Size = UDim2.new(0, WIN_W+40, 0, WIN_H+40)
glow.Position = UDim2.new(0.5, -WIN_W/2-20, 0.5, -WIN_H/2-20)
glow.BackgroundColor3 = C.Accent; glow.BackgroundTransparency = 0.94; glow.BorderSizePixel = 0; glow.ZIndex = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 20)

-- ── TOP BAR ─────────────────────────────
local TOPBAR_H = 40
local TopBar = Instance.new("Frame", W)
TopBar.Name = "TopBar"; TopBar.Size = UDim2.new(1, 0, 0, TOPBAR_H)
TopBar.BackgroundColor3 = C.TopBar; TopBar.BorderSizePixel = 0
-- extend corners visually
local tbBot = Instance.new("Frame", TopBar)
tbBot.Size = UDim2.new(1,0,0.4,0); tbBot.Position = UDim2.new(0,0,0.6,0)
tbBot.BackgroundColor3 = C.TopBar; tbBot.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

-- Title label (center)
local TitleLbl = Instance.new("TextLabel", TopBar)
TitleLbl.Size = UDim2.new(0, 260, 1, 0); TitleLbl.Position = UDim2.new(0.5,-130,0,0)
TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "DA HOOD  ·  GOD SCRIPT  v5"
TitleLbl.TextColor3 = C.AccentGlow; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 13

-- User label (left)
local UserLbl = Instance.new("TextLabel", TopBar)
UserLbl.Size = UDim2.new(0, 180, 1, 0); UserLbl.Position = UDim2.new(0, 14, 0, 0)
UserLbl.BackgroundTransparency = 1; UserLbl.Text = "👤 " .. LP.Name
UserLbl.TextColor3 = C.TextDim; UserLbl.Font = Enum.Font.Gotham; UserLbl.TextSize = 12
UserLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Control buttons (right side)
local function MakeCtrl(lbl, xOff, bg)
    local b = Instance.new("TextButton", TopBar)
    b.Size = UDim2.new(0, 28, 0, 22); b.Position = UDim2.new(1, xOff, 0.5, -11)
    b.BackgroundColor3 = bg; b.BorderSizePixel = 0
    b.Text = lbl; b.TextColor3 = C.TextBright; b.Font = Enum.Font.GothamBold; b.TextSize = 15
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

local CloseBtn = MakeCtrl("×", -8,  Color3.fromRGB(120, 0, 50))
local MinBtn   = MakeCtrl("—", -42, Color3.fromRGB(50, 30, 80))

-- ── BODY (everything below topbar) ──────
local Body = Instance.new("Frame", W)
Body.Name = "Body"; Body.Size = UDim2.new(1, 0, 1, -TOPBAR_H); Body.Position = UDim2.new(0, 0, 0, TOPBAR_H)
Body.BackgroundTransparency = 1; Body.BorderSizePixel = 0; Body.ClipsDescendants = false

-- Sidebar
local SIDEBAR_W = 108
local Sidebar = Instance.new("Frame", Body)
Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
Sidebar.BackgroundColor3 = C.Sidebar; Sidebar.BorderSizePixel = 0
local sidePad = Instance.new("UIPadding", Sidebar)
sidePad.PaddingTop=UDim.new(0,10); sidePad.PaddingLeft=UDim.new(0,6); sidePad.PaddingRight=UDim.new(0,6); sidePad.PaddingBottom=UDim.new(0,6)
local sideList = Instance.new("UIListLayout", Sidebar); sideList.Padding = UDim.new(0,4)

-- Separator line
local SepLine = Instance.new("Frame", Body)
SepLine.Size = UDim2.new(0, 1, 1, 0); SepLine.Position = UDim2.new(0, SIDEBAR_W, 0, 0)
SepLine.BackgroundColor3 = C.Border; SepLine.BorderSizePixel = 0

-- Stats panel (right)
local STATS_W = 100
local StatsPanel = Instance.new("Frame", Body)
StatsPanel.Name = "StatsPanel"; StatsPanel.Size = UDim2.new(0, STATS_W, 1, 0); StatsPanel.Position = UDim2.new(1, -STATS_W, 0, 0)
StatsPanel.BackgroundColor3 = C.Sidebar; StatsPanel.BorderSizePixel = 0
local spPad = Instance.new("UIPadding", StatsPanel); spPad.PaddingTop=UDim.new(0,8); spPad.PaddingLeft=UDim.new(0,6); spPad.PaddingRight=UDim.new(0,6)

local SepLineR = Instance.new("Frame", Body)
SepLineR.Size = UDim2.new(0,1,1,0); SepLineR.Position = UDim2.new(1,-STATS_W,0,0)
SepLineR.BackgroundColor3 = C.Border; SepLineR.BorderSizePixel = 0

-- Content area
local ContentArea = Instance.new("Frame", Body)
ContentArea.Name = "Content"; ContentArea.Size = UDim2.new(1,-SIDEBAR_W-STATS_W,1,0); ContentArea.Position = UDim2.new(0,SIDEBAR_W,0,0)
ContentArea.BackgroundColor3 = C.Content; ContentArea.BorderSizePixel = 0

-- ── STATS PANEL CONTENTS ────────────────
local function StatRow(lbl, yp)
    local l = Instance.new("TextLabel", StatsPanel)
    l.Size=UDim2.new(1,0,0,18); l.Position=UDim2.new(0,0,0,yp)
    l.BackgroundTransparency=1; l.Text=lbl; l.TextColor3=C.TextDim; l.Font=Enum.Font.Gotham; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left
    return l
end
local StatHeader = Instance.new("TextLabel", StatsPanel)
StatHeader.Size=UDim2.new(1,0,0,20); StatHeader.Position=UDim2.new(0,0,0,0)
StatHeader.BackgroundTransparency=1; StatHeader.Text="◈ STATS"; StatHeader.TextColor3=C.Accent; StatHeader.Font=Enum.Font.GothamBold; StatHeader.TextSize=11; StatHeader.TextXAlignment=Enum.TextXAlignment.Left

local cashLbl   = StatRow("💰 $---",  24)
local bountyLbl = StatRow("💀 B:---", 44)
local crewLbl   = StatRow("👥 ---",   64)
local pingLbl   = StatRow("📶 --ms",  84)

-- set nearest target
local setNearBtn = Instance.new("TextButton", StatsPanel)
setNearBtn.Size=UDim2.new(1,0,0,28); setNearBtn.Position=UDim2.new(0,0,1,-62)
setNearBtn.BackgroundColor3=C.Accent; setNearBtn.BorderSizePixel=0
setNearBtn.Text="🎯 Target"; setNearBtn.TextColor3=C.TextBright; setNearBtn.Font=Enum.Font.GothamBold; setNearBtn.TextSize=11
Instance.new("UICorner",setNearBtn).CornerRadius=UDim.new(0,6)
setNearBtn.MouseButton1Click:Connect(function()
    S.AimbotOn=true; local t=GetTarget()
    Notify("TARGET", t and "Targeting: "..t.Name or "No target in FOV", 2)
end)

local killAuraBtn = Instance.new("TextButton", StatsPanel)
killAuraBtn.Size=UDim2.new(1,0,0,28); killAuraBtn.Position=UDim2.new(0,0,1,-30)
killAuraBtn.BackgroundColor3=C.Card; killAuraBtn.BorderSizePixel=0
killAuraBtn.Text="☠️ Fling All"; killAuraBtn.TextColor3=C.Text; killAuraBtn.Font=Enum.Font.GothamBold; killAuraBtn.TextSize=11
Instance.new("UICorner",killAuraBtn).CornerRadius=UDim.new(0,6)
killAuraBtn.MouseButton1Click:Connect(function()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl~=LP then
            local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv=Instance.new("BodyVelocity"); bv.Velocity=Vector3.new(0,300,0); bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.Parent=hrp
                task.delay(0.2,function() pcall(function() bv:Destroy() end) end)
            end
        end
    end
    Notify("FLING ALL","Launched all players!", 2)
end)

-- Live stats update
RunService.Heartbeat:Connect(function()
    pcall(function()
        local stats = LP:FindFirstChild("leaderstats") or LP:FindFirstChild("Stats")
        if stats then
            local cash   = stats:FindFirstChild("Cash") or stats:FindFirstChild("Money")
            local bounty = stats:FindFirstChild("Bounty") or stats:FindFirstChild("KOs")
            local crew   = stats:FindFirstChild("Crew") or stats:FindFirstChild("Gang")
            if cash   then cashLbl.Text   = "💰 $"..tostring(cash.Value) end
            if bounty then bountyLbl.Text = "💀 "..tostring(bounty.Value) end
            if crew   then crewLbl.Text   = "👥 "..tostring(crew.Value) end
        end
    end)
end)

-- ── TAB / PAGE SYSTEM ───────────────────
local Pages   = {}
local TabBtns = {}

local function NewPage(name)
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Name = name.."Page"; page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1; page.BorderSizePixel = 0
    page.ScrollBarThickness = 4; page.ScrollBarImageColor3 = C.Accent
    page.CanvasSize = UDim2.new(0,0,0,0); page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop=UDim.new(0,10); pad.PaddingLeft=UDim.new(0,10); pad.PaddingRight=UDim.new(0,12); pad.PaddingBottom=UDim.new(0,10)
    Pages[name] = page
    return page
end

local function NewGridPage(name)
    local page = NewPage(name)
    local grid = Instance.new("UIGridLayout", page)
    grid.CellSize = UDim2.new(0,108,0,38); grid.CellPadding = UDim2.new(0,7,0,7)
    grid.HorizontalAlignment = Enum.HorizontalAlignment.Left; grid.VerticalAlignment = Enum.VerticalAlignment.Top
    return page, grid
end

local function NewListPage(name)
    local page = NewPage(name)
    local list = Instance.new("UIListLayout", page); list.Padding = UDim.new(0,6)
    return page
end

-- Tab button
local function TabBtn(name, icon)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 36); b.BackgroundColor3 = C.Card; b.BorderSizePixel = 0
    b.Text = ""; b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    -- icon
    local iconL = Instance.new("TextLabel", b)
    iconL.Size=UDim2.new(0,24,1,0); iconL.Position=UDim2.new(0,6,0,0)
    iconL.BackgroundTransparency=1; iconL.Text=icon; iconL.TextSize=16; iconL.Font=Enum.Font.Gotham
    -- label
    local nameL = Instance.new("TextLabel", b)
    nameL.Size=UDim2.new(1,-34,1,0); nameL.Position=UDim2.new(0,32,0,0)
    nameL.BackgroundTransparency=1; nameL.Text=name; nameL.TextColor3=C.TextDim
    nameL.TextSize=10; nameL.Font=Enum.Font.GothamSemibold; nameL.TextXAlignment=Enum.TextXAlignment.Left
    nameL.TextWrapped=true

    -- active indicator bar
    local bar = Instance.new("Frame", b)
    bar.Size=UDim2.new(0,3,0.5,0); bar.Position=UDim2.new(0,0,0.25,0)
    bar.BackgroundColor3=C.Accent; bar.BorderSizePixel=0; bar.Visible=false
    Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)

    TabBtns[name] = {btn=b, nameL=nameL, iconL=iconL, bar=bar}

    b.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do p.Visible = (n==name) end
        for n, tb in pairs(TabBtns) do
            local active = (n==name)
            TweenService:Create(tb.btn, TweenInfo.new(0.15), {BackgroundColor3 = active and C.TabActive or C.Card}):Play()
            tb.nameL.TextColor3 = active and C.TextBright or C.TextDim
            tb.bar.Visible = active
        end
        S.CurrentPage = name
    end)
    return b
end

-- ── WIDGET BUILDERS ─────────────────────

-- Grid toggle button
local function GBtn(parent, label, isToggle, cb)
    local btn = Instance.new("TextButton", parent)
    btn.Text=label; btn.Font=Enum.Font.GothamBold; btn.TextSize=11
    btn.TextColor3=C.Text; btn.BackgroundColor3=C.Card; btn.BorderSizePixel=0
    btn.AutoButtonColor=false; btn.TextWrapped=true
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
    local sk=Instance.new("UIStroke",btn); sk.Color=C.Border; sk.Thickness=1; sk.Transparency=0.4

    local active=false
    local function setActive(v)
        active=v
        TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=v and C.Accent or C.Card, TextColor3=v and C.TextBright or C.Text}):Play()
        sk.Color=v and C.AccentGlow or C.Border
    end

    btn.MouseButton1Click:Connect(function()
        if isToggle then setActive(not active) else TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.Accent}):Play(); task.delay(0.2,function() TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=C.Card}):Play() end) end
        if cb then cb(active) end
    end)
    btn.MouseEnter:Connect(function() if not active then TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.CardHov}):Play() end end)
    btn.MouseLeave:Connect(function() if not active then TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.Card}):Play() end end)
    return btn, setActive
end

-- List row with toggle switch
local function ToggleRow(parent, label, cb)
    local row = Instance.new("Frame", parent)
    row.Size=UDim2.new(1,0,0,38); row.BackgroundColor3=C.Card; row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",row).Color=C.Border

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-60,1,0); lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.Text
    lbl.Font=Enum.Font.GothamSemibold; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left

    -- Toggle pill
    local pill=Instance.new("Frame",row)
    pill.Size=UDim2.new(0,44,0,22); pill.Position=UDim2.new(1,-54,0.5,-11)
    pill.BackgroundColor3=C.ToggleOff; pill.BorderSizePixel=0
    Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",pill)
    knob.Size=UDim2.new(0,16,0,16); knob.Position=UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3=C.TextDim; knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local active=false
    local hitBtn=Instance.new("TextButton",row); hitBtn.Size=UDim2.new(1,0,1,0); hitBtn.BackgroundTransparency=1; hitBtn.Text=""
    hitBtn.MouseButton1Click:Connect(function()
        active=not active
        TweenService:Create(pill,TweenInfo.new(0.18),{BackgroundColor3=active and C.Accent or C.ToggleOff}):Play()
        TweenService:Create(knob,TweenInfo.new(0.18),{Position=active and UDim2.new(0,25,0.5,-8) or UDim2.new(0,3,0.5,-8), BackgroundColor3=active and C.TextBright or C.TextDim}):Play()
        if cb then cb(active) end
    end)
    return row
end

-- List row action button
local function ActionRow(parent, label, cb)
    local btn=Instance.new("TextButton",parent)
    btn.Size=UDim2.new(1,0,0,38); btn.BackgroundColor3=C.Card; btn.BorderSizePixel=0
    btn.Text=label; btn.TextColor3=C.Text; btn.Font=Enum.Font.GothamSemibold; btn.TextSize=12
    btn.TextXAlignment=Enum.TextXAlignment.Left; btn.AutoButtonColor=false
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",btn).Color=C.Border
    local pad=Instance.new("UIPadding",btn); pad.PaddingLeft=UDim.new(0,12)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.Accent}):Play()
        task.delay(0.2,function() TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=C.Card}):Play() end)
        if cb then cb() end
    end)
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.CardHov}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.Card}):Play() end)
    return btn
end

-- Section label
local function SectionLabel(parent, txt)
    local l=Instance.new("TextLabel",parent)
    l.Size=UDim2.new(1,0,0,20); l.BackgroundTransparency=1
    l.Text=txt; l.TextColor3=C.Accent; l.Font=Enum.Font.GothamBold; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left
    return l
end

-- Slider row
local function SliderRow(parent, label, min, max, default, unit, cb)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,54); row.BackgroundColor3=C.Card; row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",row).Color=C.Border

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-10,0,22); lbl.Position=UDim2.new(0,12,0,4)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.Text; lbl.Font=Enum.Font.GothamSemibold; lbl.TextSize=11; lbl.TextXAlignment=Enum.TextXAlignment.Left

    local valLbl=Instance.new("TextLabel",row)
    valLbl.Size=UDim2.new(0,60,0,22); valLbl.Position=UDim2.new(1,-70,0,4)
    valLbl.BackgroundTransparency=1; valLbl.Text=tostring(default)..(unit or ""); valLbl.TextColor3=C.AccentGlow; valLbl.Font=Enum.Font.GothamBold; valLbl.TextSize=11; valLbl.TextXAlignment=Enum.TextXAlignment.Right

    local track=Instance.new("Frame",row)
    track.Size=UDim2.new(1,-24,0,6); track.Position=UDim2.new(0,12,0,34)
    track.BackgroundColor3=C.ToggleOff; track.BorderSizePixel=0
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

    local fill=Instance.new("Frame",track)
    fill.Size=UDim2.new((default-min)/(max-min),0,1,0); fill.BackgroundColor3=C.Accent; fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",track)
    knob.Size=UDim2.new(0,14,0,14); knob.AnchorPoint=Vector2.new(0.5,0.5)
    knob.Position=UDim2.new((default-min)/(max-min),0,0.5,0)
    knob.BackgroundColor3=C.TextBright; knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local dragging=false
    local function setVal(rx)
        rx=math.clamp(rx,0,1)
        local v=math.floor(min+(max-min)*rx)
        fill.Size=UDim2.new(rx,0,1,0); knob.Position=UDim2.new(rx,0,0.5,0)
        valLbl.Text=tostring(v)..(unit or "")
        if cb then cb(v) end
    end
    knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local ap=track.AbsolutePosition; local as=track.AbsoluteSize
            local pos=i.UserInputType==Enum.UserInputType.Touch and i.Position or i.Position
            setVal((pos.X-ap.X)/as.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
    track.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            local ap=track.AbsolutePosition; local as=track.AbsoluteSize; local pos=i.Position
            setVal((pos.X-ap.X)/as.X)
        end
    end)
    return row
end

-- ── PAGE 1: MAIN SCRIPTS ───────────────
local p1, _ = NewGridPage("Main")
TabBtn("Main","⚙️")

GBtn(p1,"GodBlock",true,function(v) S.GodBlockOn=v; if v then StartGodBlock() end; Notify("GODBLOCK",v and "ON" or "OFF",1.5) end)
GBtn(p1,"Reach",true,function(v) S.ReachOn=v; SetReach(v); Notify("REACH",v and "ON" or "OFF",1.5) end)
GBtn(p1,"NoRecoil",true,function(v) S.NoRecoilOn=v; pcall(function() if v then local cam=Workspace.Camera; cam.CameraType=Enum.CameraType.Custom end end); Notify("NORECOIL",v and "ON" or "OFF",1.5) end)
GBtn(p1,"GodArmor",true,function(v) S.GodArmor=v; pcall(function() local c=LP.Character; if c then local a=c:FindFirstChild("Armor") or c:FindFirstChild("ArmorValue"); if a then a.Value=v and 99 or 0 end end end); Notify("GOD ARMOR",v and "ON" or "OFF",1.5) end)
GBtn(p1,"Headless",true,function(v) S.HeadlessOn=v; pcall(function() local c=LP.Character; if not c then return end; local head=c:FindFirstChild("Head"); if not head then return end; for _,p in ipairs(head:GetDescendants()) do if p:IsA("BasePart") or p:IsA("SpecialMesh") or p:IsA("MeshPart") then p.Transparency=v and 1 or 0 end end end); Notify("HEADLESS",v and "ON" or "OFF",1.5) end)
GBtn(p1,"View",true,function(v) S.ViewOn=v; pcall(function() LP.CameraMaxZoomDistance=v and 128 or 12.5 end); Notify("VIEW",v and "Unlocked" or "Reset",1.5) end)
GBtn(p1,"Fling",false,function() FlingNearest() end)
GBtn(p1,"GoTo",false,function() local t=GetTarget(); if t then local h=t.Character and t.Character:FindFirstChild("HumanoidRootPart"); if h then TeleportTo(h.Position); Notify("GoTo","→ "..t.Name,2) end else Notify("GoTo","No target",2) end end)
GBtn(p1,"FreeFists",true,function(v) S.FreeFistsOn=v; Notify("FREEFISTS",v and "ON" or "OFF",1.5) end)
GBtn(p1,"FlyMode",true,function(v) S.FlyOn=v; if v then StartFly() else StopFly() end; Notify("FLY",v and "ON (W/A/S/D)" or "OFF",1.5) end)
GBtn(p1,"NoClip [Z]",true,function(v) S.NoClipOn=v; Notify("NOCLIP",v and "ON" or "OFF",1.5) end)
GBtn(p1,"FlySpeed –",false,function() S.FlySpeed=math.max(10,S.FlySpeed-10); Notify("FLY SPD","→ "..S.FlySpeed,1) end)
GBtn(p1,"Fly [X]",false,function() S.FlyOn=not S.FlyOn; if S.FlyOn then StartFly() else StopFly() end; Notify("FLY",S.FlyOn and "ON" or "OFF",1.5) end)
GBtn(p1,"FlySpeed +",false,function() S.FlySpeed=math.min(400,S.FlySpeed+10); Notify("FLY SPD","→ "..S.FlySpeed,1) end)
GBtn(p1,"SpeedHack",true,function(v) S.SpeedOn=v; if not v then local c=LP.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=16 end end; Notify("SPEED",v and "ON ("..S.SpeedVal..")" or "OFF",1.5) end)
GBtn(p1,"Speed +",false,function() S.SpeedVal=math.min(200,S.SpeedVal+5); Notify("SPEED","→ "..S.SpeedVal,1) end)

-- ── PAGE 2: SIDE SCRIPTS ───────────────
local p2 = NewListPage("Side")
TabBtn("Side","📜")

SectionLabel(p2,"─── SPEED ───")
SliderRow(p2,"Walk Speed",5,200,32,"",function(v) S.SpeedVal=v end)
ToggleRow(p2,"Speed Hack",function(v) S.SpeedOn=v; if not v then local c=LP.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=16 end end; Notify("SPEED",v and "ON" or "OFF",1.5) end)

SectionLabel(p2,"─── FLY ───")
SliderRow(p2,"Fly Speed",10,400,70,"",function(v) S.FlySpeed=v end)
ToggleRow(p2,"Fly Mode (W/A/S/D)",function(v) S.FlyOn=v; if v then StartFly() else StopFly() end; Notify("FLY",v and "ON" or "OFF",1.5) end)

SectionLabel(p2,"─── PLAYER ───")
ToggleRow(p2,"NoClip [Z key]",function(v) S.NoClipOn=v; Notify("NOCLIP",v and "ON" or "OFF",1.5) end)
ToggleRow(p2,"GodBlock (client)",function(v) S.GodBlockOn=v; if v then StartGodBlock() end; Notify("GODBLOCK",v and "ON" or "OFF",1.5) end)
ActionRow(p2,"🌀 Fling Nearest",function() FlingNearest() end)
ActionRow(p2,"🎯 GoTo Target",function() local t=GetTarget(); if t then local h=t.Character and t.Character:FindFirstChild("HumanoidRootPart"); if h then TeleportTo(h.Position); Notify("GoTo","→ "..t.Name,2) end else Notify("GoTo","No target",2) end end)
ActionRow(p2,"📦 Equip All Items",function() EquipAllGuns() end)

-- ── PAGE 3: AIMBOT ──────────────────────
local p3 = NewListPage("Aimbot")
TabBtn("Aimbot","🎯")

SectionLabel(p3,"─── AIMBOT ───")
ToggleRow(p3,"Aimbot (Hold RMB)",function(v) S.AimbotOn=v; Notify("AIMBOT",v and "ON" or "OFF",1.5) end)
ToggleRow(p3,"Silent Aim",function(v) S.SilentAim=v; Notify("SILENT AIM",v and "ON" or "OFF",1.5) end)
ToggleRow(p3,"Team Check",function(v) S.TeamCheck=v end)
ToggleRow(p3,"Wall Check",function(v) S.WallCheck=v end)
SectionLabel(p3,"─── FOV ───")
SliderRow(p3,"FOV Radius",10,400,180,"px",function(v) S.AimbotFOV=v end)
SliderRow(p3,"Smoothness",1,30,18,"",function(v) S.AimbotSmooth=v/100 end)
SectionLabel(p3,"─── TARGET PART ───")
for _, part in ipairs({"Head","HumanoidRootPart","UpperTorso","LowerTorso"}) do
    ActionRow(p3,"🔹 "..part,function() S.AimbotPart=part; Notify("AIMPART","→ "..part,1.5) end)
end

-- ── PAGE 4: ESP / VISUAL ───────────────
local p4 = NewListPage("Visual")
TabBtn("Visual","👁️")

SectionLabel(p4,"─── ESP ───")
ToggleRow(p4,"ESP (Boxes + HP + Name)",function(v) S.ESPOn=v; if not v then ClearESP() end; Notify("ESP",v and "ON" or "OFF",1.5) end)
ToggleRow(p4,"Chams (Selection Box)",function(v) S.ChamsOn=v; Notify("CHAMS",v and "ON" or "OFF",1.5) end)

SectionLabel(p4,"─── MISC VISUAL ───")
ToggleRow(p4,"Rotating Crosshair",function(v) S.RotatingCrossOn=v; if v then StartCrosshair() else StopCrosshair() end; Notify("CROSSHAIR",v and "ON" or "OFF",1.5) end)

-- ── PAGE 5: TELEPORTS ──────────────────
local p5 = NewListPage("Teleport")
TabBtn("Teleport","🌀")

SectionLabel(p5,"─── 2026 MAP LOCATIONS ───")
for _, t in ipairs(TELEPORTS) do
    ActionRow(p5, t.name, function()
        TeleportTo(t.pos)
        Notify("TELEPORT","→ "..t.name, 2)
    end)
end

ActionRow(p5,"📌 TP to Target Player", function()
    local target = GetTarget()
    if target then
        local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then TeleportTo(hrp.Position); Notify("TELEPORT","→ "..target.Name,2) end
    else Notify("TELEPORT","No target found",2) end
end)

-- ── PAGE 6: CHARACTER ──────────────────
local p6 = NewListPage("Character")
TabBtn("Character","🧍")

SectionLabel(p6,"─── APPEARANCE ───")
ToggleRow(p6,"Headless (Client)",function(v) S.HeadlessOn=v; pcall(function() local c=LP.Character; if not c then return end; local h=c:FindFirstChild("Head"); if not h then return end; for _,pt in ipairs(h:GetDescendants()) do if pt:IsA("BasePart") or pt:IsA("SpecialMesh") then pt.Transparency=v and 1 or 0 end end end); Notify("HEADLESS",v and "ON" or "OFF",1.5) end)
ToggleRow(p6,"White Character",function(v) S.WhiteCharOn=v; SetWhiteCharacter(v); Notify("WHITE CHAR",v and "ON" or "OFF",1.5) end)

SectionLabel(p6,"─── COMBAT MODS ───")
ToggleRow(p6,"Fling Touch (proximity)",function(v) S.FlingTouchOn=v; if v then StartFlingTouch() end; Notify("FLING TOUCH",v and "ON" or "OFF",1.5) end)
ToggleRow(p6,"Spam Call All",function(v) S.SpamCallOn=v; if v then StartSpamCall() end; Notify("SPAM CALL",v and "ON" or "OFF",1.5) end)
ToggleRow(p6,"Anti Void",function(v) S.AntiVoidOn=v; if v then StartAntiVoid() end; Notify("ANTI VOID",v and "ON" or "OFF",1.5) end)
ToggleRow(p6,"Auto Armor (<50% HP)",function(v) S.AutoArmorOn=v; if v then StartAutoArmor() end; Notify("AUTO ARMOR",v and "ON" or "OFF",1.5) end)

SectionLabel(p6,"─── SPINBOT ───")
ToggleRow(p6,"Spinbot",function(v) S.SpinbotOn=v; if v then StartSpinbot() end; Notify("SPINBOT",v and "ON" or "OFF",1.5) end)
SliderRow(p6,"Spin Speed",50,3000,500,"",function(v) S.SpinSpeed=v end)

SectionLabel(p6,"─── PERCENT TO BUY ───")
SliderRow(p6,"% to Buy",0,120,80,"%",function(v) S.PercentToBuy=v end)

ActionRow(p6,"📦 Equip All Guns",function() EquipAllGuns() end)

-- ── PAGE 7: BUY MENU ───────────────────
local p7 = NewListPage("Buy")
TabBtn("Buy","🛒")

-- Buy All
local buyAllBtn = Instance.new("TextButton", p7)
buyAllBtn.Size=UDim2.new(1,0,0,42); buyAllBtn.BackgroundColor3=Color3.fromRGB(20,60,12); buyAllBtn.BorderSizePixel=0
buyAllBtn.Text="🛒  BUY ALL ITEMS"; buyAllBtn.TextColor3=C.Green; buyAllBtn.Font=Enum.Font.GothamBold; buyAllBtn.TextSize=13
Instance.new("UICorner",buyAllBtn).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke",buyAllBtn).Color=Color3.fromRGB(40,160,40)
buyAllBtn.MouseButton1Click:Connect(function()
    for _, item in ipairs(BUY_ITEMS) do TryBuy(item[2]); task.wait(0.05) end
    Notify("BUY ALL","Attempted all items!",3)
end)
buyAllBtn.MouseEnter:Connect(function() TweenService:Create(buyAllBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(30,90,18)}):Play() end)
buyAllBtn.MouseLeave:Connect(function() TweenService:Create(buyAllBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(20,60,12)}):Play() end)

SectionLabel(p7,"─── ITEMS (be near shop) ───")
for _, item in ipairs(BUY_ITEMS) do
    local label, key = item[1], item[2]
    ActionRow(p7, label, function() TryBuy(key) end)
end

-- ── PAGE 8: TITLE ──────────────────────
local p8 = NewListPage("Title")
TabBtn("Title","⭐")

SectionLabel(p8,"─── CUSTOM TITLE ───")
ToggleRow(p8,"Show Title Above Head",function(v) S.TitleVisible=v; ApplyTitle(); Notify("TITLE",v and "ON" or "OFF",1.5) end)

-- Title input
local inputBG = Instance.new("Frame",p8)
inputBG.Size=UDim2.new(1,0,0,42); inputBG.BackgroundColor3=C.Card; inputBG.BorderSizePixel=0
Instance.new("UICorner",inputBG).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke",inputBG).Color=C.Border
local input = Instance.new("TextBox",inputBG)
input.Size=UDim2.new(1,-16,1,0); input.Position=UDim2.new(0,8,0,0)
input.BackgroundTransparency=1; input.Text="⭐ PLAYER"; input.PlaceholderText="Type your title..."
input.TextColor3=C.AccentGlow; input.Font=Enum.Font.GothamBold; input.TextSize=13
input.ClearTextOnFocus=false; input.MultiLine=false

ActionRow(p8,"✅ Set Title",function()
    local txt = input.Text
    if #txt > 0 and #txt <= 28 then
        S.MyTitle=txt; if S.TitleVisible then ApplyTitle() end
        Notify("TITLE","Set: "..txt,2)
    else Notify("TITLE","⚠️ 1-28 characters only",2) end
end)

SectionLabel(p8,"─── PRESETS ───")
for _, preset in ipairs({"⭐ GOD","💀 GHOST","👑 KING","🔥 FLAME","💎 ELITE","🎯 REAPER","🧊 FROZEN","⚡ ZEUS","🌊 WAVE","🔮 MYSTIC"}) do
    ActionRow(p8, preset, function() S.MyTitle=preset; input.Text=preset; if S.TitleVisible then ApplyTitle() end; Notify("TITLE","→ "..preset,1.5) end)
end

-- ── ACTIVATE FIRST TAB ─────────────────
for n, p in pairs(Pages) do p.Visible=(n=="Main") end
if TabBtns["Main"] then
    TabBtns["Main"].btn.BackgroundColor3 = C.TabActive
    TabBtns["Main"].nameL.TextColor3 = C.TextBright
    TabBtns["Main"].bar.Visible = true
end

-- ─────────────────────────────────────────
-- DRAGGING (Mouse + Touch both supported)
-- ─────────────────────────────────────────
local isDragging = false
local dragStartPos, windowStartPos

local function BeginDrag(inputPos)
    isDragging = true
    dragStartPos = inputPos
    windowStartPos = W.Position
end
local function UpdateDrag(inputPos)
    if not isDragging then return end
    local delta = inputPos - dragStartPos
    local nx = windowStartPos.X.Offset + delta.X
    local ny = windowStartPos.Y.Offset + delta.Y
    -- clamp to screen
    local vp = Camera.ViewportSize
    nx = math.clamp(nx, 0, vp.X - W.AbsoluteSize.X)
    ny = math.clamp(ny, 0, vp.Y - W.AbsoluteSize.Y)
    W.Position = UDim2.new(0, nx, 0, ny)
    glow.Position = UDim2.new(0, nx-20, 0, ny-20)
end
local function EndDrag()
    isDragging = false
end

-- Mouse drag via TopBar
TopBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        BeginDrag(Vector2.new(inp.Position.X, inp.Position.Y))
    end
end)
-- Touch drag via TopBar
TopBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch then
        BeginDrag(Vector2.new(inp.Position.X, inp.Position.Y))
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if isDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        UpdateDrag(Vector2.new(inp.Position.X, inp.Position.Y))
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        EndDrag()
    end
end)

-- ── MINIMIZE / CLOSE ────────────────────
local isMinimized = false

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetH = isMinimized and WIN_H_MIN or WIN_H
    Body.Visible = not isMinimized
    TweenService:Create(W, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, WIN_W, 0, targetH)
    }):Play()
    MinBtn.Text = isMinimized and "□" or "—"
end)

CloseBtn.MouseButton1Click:Connect(function()
    W.Visible = false; S.GUIOpen = false
    Notify("GUI","Closed. Press RightShift to reopen.",3)
end)

-- ── TOGGLE KEYBIND ──────────────────────
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        S.GUIOpen = not S.GUIOpen
        W.Visible = S.GUIOpen
        if S.GUIOpen then
            isMinimized = false; Body.Visible = true
            W.Size = UDim2.new(0, WIN_W, 0, 0)
            TweenService:Create(W, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, WIN_W, 0, WIN_H)
            }):Play()
        end
    end
end)

-- ── OPEN ANIMATION ──────────────────────
W.Size = UDim2.new(0, WIN_W, 0, 0)
TweenService:Create(W, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, WIN_W, 0, WIN_H)
}):Play()

-- ── STARTUP NOTIFICATIONS ───────────────
task.wait(0.5)
Notify("DA HOOD GOD SCRIPT v5","✅ Loaded! Press RightShift to toggle.",5)
task.wait(1.2)
Notify("KEYBINDS","Z = NoClip  |  X = Fly  |  RShift = Toggle",5)
task.wait(1.2)
Notify("COMMANDS","Chat: csync cgod | csync cfly | csync cspeed 50",5)
task.wait(1.2)
Notify("2026 UPDATE","20 locations • 35 buy items • Mobile touch drag",5)
