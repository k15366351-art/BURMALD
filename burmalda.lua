-- ================================================
--   🥔 BURMALDA HACK v17.1
--   ESP + Highlight + Tracer + Aimbot + FOV + Configs + PlayerList
--   Toggle Menu: RightShift
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ================= CONFIG =================
local Config = {
    -- ESP
    ESPEnabled=true, ShowBox=true, BoxStyle="2D", ShowName=true, ShowHealth=true,
    ShowDistance=true, ShowTracer=false, ShowHighlight=true, ShowSkeleton=false,
    ShowTeam=false, TeamCheck=true, MaxDistance=1500,
    ESPColor=Color3.fromRGB(255,60,120), VisibleColor=Color3.fromRGB(0,255,100),
    HiddenColor=Color3.fromRGB(255,50,50), UseWallColors=true,
    NameColor=Color3.fromRGB(255,255,255), DistColor=Color3.fromRGB(220,220,220),
    TracerColor=Color3.fromRGB(255,60,120), TracerOrigin="Bottom",
    BoxThickness=2, BoxPadding=2, BoxFillTransparency=0.7,
    HealthMode="Both", HealthBarWidth=5, HealthBarSide="Left", ShowHealthText=true,
    HighlightFillColor=Color3.fromRGB(255,60,120), HighlightFillTransparency=0.6,
    HighlightOutlineColor=Color3.fromRGB(255,255,255), HighlightOutlineTransparency=0.3,
    SkeletonColor=Color3.fromRGB(255,255,255),

    -- AIMBOT
    AimbotEnabled=false, AimKey=Enum.UserInputType.MouseButton2, AimKeyString="MouseButton2",
    AimMode="Camera", AimPart="Head", FOV=150, SmoothnessX=0.25, SmoothnessY=0.25,
    ShowFOV=false, FOVColor=Color3.fromRGB(255,255,255), FOVTransparency=0.8,
    MaxAimDist=600, WallCheck=false, ToggleMode=false,
    Prediction=0, AutoShoot=false, ShowTarget=true, TargetColor=Color3.fromRGB(255,60,120),
    AimPriority="Distance", HitChance=100, HitboxExpand=0, StopOnKill=false,
    EnemyInventoryEnabled=true,

    -- MISC
    AntiAFK=true,
    WatermarkEnabled=true, WatermarkText="🥔 BURMALDA v17.1",
    OpenBtnPosition=UDim2.new(0,20,0.5,-25),
    AnimationsEnabled=true, Theme="Classic",
    CurrentConfig="default",
    WhitelistOnly=false,
}

-- Whitelist: список игроков которых подсвечивать (пусто = все)
local Whitelist = {}

local Themes = {
    Classic={name="🎨 Classic", bg=Color3.fromRGB(15,15,22), header=Color3.fromRGB(22,22,32), sidebar=Color3.fromRGB(18,18,26), content=Color3.fromRGB(24,24,34), contentHover=Color3.fromRGB(32,32,46), accent1=Color3.fromRGB(255,60,120), accent2=Color3.fromRGB(120,60,255), accent3=Color3.fromRGB(60,180,255), text=Color3.fromRGB(230,230,240), textDim=Color3.fromRGB(120,120,150), tabActive=Color3.fromRGB(30,30,44), tabInactive=Color3.fromRGB(22,22,32)},
    Cyberpunk={name="🌆 Cyberpunk", bg=Color3.fromRGB(10,5,20), header=Color3.fromRGB(20,10,35), sidebar=Color3.fromRGB(15,8,28), content=Color3.fromRGB(25,15,45), contentHover=Color3.fromRGB(38,22,65), accent1=Color3.fromRGB(255,230,0), accent2=Color3.fromRGB(255,0,200), accent3=Color3.fromRGB(0,230,255), text=Color3.fromRGB(255,255,200), textDim=Color3.fromRGB(180,150,220), tabActive=Color3.fromRGB(50,20,80), tabInactive=Color3.fromRGB(20,10,35)},
    GlassNeon={name="💎 Glass Neon", bg=Color3.fromRGB(10,15,30), header=Color3.fromRGB(15,25,45), sidebar=Color3.fromRGB(12,20,38), content=Color3.fromRGB(20,30,55), contentHover=Color3.fromRGB(30,45,80), accent1=Color3.fromRGB(0,255,255), accent2=Color3.fromRGB(120,100,255), accent3=Color3.fromRGB(255,100,200), text=Color3.fromRGB(230,245,255), textDim=Color3.fromRGB(130,170,220), tabActive=Color3.fromRGB(35,55,95), tabInactive=Color3.fromRGB(18,28,50)},
    Matrix={name="🟢 Matrix", bg=Color3.fromRGB(0,8,0), header=Color3.fromRGB(5,15,5), sidebar=Color3.fromRGB(0,12,0), content=Color3.fromRGB(5,20,5), contentHover=Color3.fromRGB(12,35,12), accent1=Color3.fromRGB(0,255,0), accent2=Color3.fromRGB(0,200,100), accent3=Color3.fromRGB(150,255,150), text=Color3.fromRGB(200,255,200), textDim=Color3.fromRGB(100,180,100), tabActive=Color3.fromRGB(10,40,10), tabInactive=Color3.fromRGB(5,20,5)},
    Inferno={name="🔥 Inferno", bg=Color3.fromRGB(15,5,0), header=Color3.fromRGB(30,10,0), sidebar=Color3.fromRGB(20,8,0), content=Color3.fromRGB(40,15,5), contentHover=Color3.fromRGB(62,28,12), accent1=Color3.fromRGB(255,100,0), accent2=Color3.fromRGB(255,200,0), accent3=Color3.fromRGB(255,60,30), text=Color3.fromRGB(255,230,200), textDim=Color3.fromRGB(220,160,120), tabActive=Color3.fromRGB(80,30,10), tabInactive=Color3.fromRGB(40,15,5)},
}

local function T() return Themes[Config.Theme] or Themes.Classic end

-- ================= CONFIG SYSTEM =================
local ConfigFolder = "BurmaldaConfigs"
local hasFS = (writefile and readfile and isfolder and makefolder and listfiles and isfile and delfile)

local function ensureFolder()
    if not hasFS then return false end
    if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
    return true
end

local function serializeValue(v)
    if typeof(v) == "Color3" then
        return string.format("Color3.fromRGB(%d,%d,%d)", math.floor(v.R*255), math.floor(v.G*255), math.floor(v.B*255))
    elseif typeof(v) == "UDim2" then
        return string.format("UDim2.new(%f,%d,%f,%d)", v.X.Scale, v.X.Offset, v.Y.Scale, v.Y.Offset)
    elseif typeof(v) == "EnumItem" then
        return string.format("Enum.%s.%s", v.EnumType.Name, v.Name)
    elseif type(v) == "string" then
        return string.format("%q", v)
    elseif type(v) == "boolean" or type(v) == "number" then
        return tostring(v)
    end
    return "nil"
end

local function saveConfig(name)
    if not ensureFolder() then return false, "Executor не поддерживает файлы" end
    local lines = {"return {"}
    for k, v in pairs(Config) do
        if k ~= "AimKey" then
            table.insert(lines, string.format("  [%q] = %s,", k, serializeValue(v)))
        end
    end
    table.insert(lines, "}")
    local ok, err = pcall(function()
        writefile(ConfigFolder .. "/" .. name .. ".lua", table.concat(lines, "\n"))
    end)
    return ok, err
end

local function loadConfig(name)
    if not ensureFolder() then return false, "Executor не поддерживает файлы" end
    if not isfile(ConfigFolder .. "/" .. name .. ".lua") then
        return false, "Конфиг не найден"
    end
    local ok, data = pcall(function() return readfile(ConfigFolder .. "/" .. name .. ".lua") end)
    if not ok then return false, "Ошибка чтения" end
    local fn, err = loadstring(data)
    if not fn then return false, "Ошибка парсинга" end
    local ok2, tbl = pcall(fn)
    if not ok2 or type(tbl) ~= "table" then return false, "Конфиг битый" end
    for k, v in pairs(tbl) do
        if Config[k] ~= nil then Config[k] = v end
    end
    Config.CurrentConfig = name
    return true
end

local function deleteConfig(name)
    if not hasFS then return false end
    local path = ConfigFolder .. "/" .. name .. ".lua"
    if isfile(path) then
        pcall(function() delfile(path) end)
        return true
    end
    return false
end

local function listConfigs()
    if not ensureFolder() then return {} end
    local out = {}
    local ok, files = pcall(listfiles, ConfigFolder)
    if not ok or not files then return out end
    for _, f in ipairs(files) do
        local n = f:match("([^/\\]+)%.lua$")
        if n then table.insert(out, n) end
    end
    return out
end

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BurmaldaHack"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "BurmaldaESP"
ESPGui.ResetOnSpawn = false
ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ESPGui.IgnoreGuiInset = false
ESPGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ================= NOTIFICATIONS =================
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 260, 0, 300)
NotifContainer.Position = UDim2.new(1, -280, 0, 50)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui
local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function notify(text, color)
    color = color or T().accent1
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3 = T().sidebar
    f.BackgroundTransparency = 0.1
    f.BorderSizePixel = 0
    f.Parent = NotifContainer
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", f)
    s.Color = color
    s.Thickness = 1
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    task.delay(3, function()
        TweenService:Create(f, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.35)
        f:Destroy()
    end)
end

-- ================= ESP FRAMES =================
local ESPFrames = {}
local Highlights = {}
local Skeletons = {}

local function createESPFrames(plr)
    if ESPFrames[plr] then return ESPFrames[plr] end
    local f = {}

    f.box = Instance.new("Frame")
    f.box.BackgroundTransparency = 1
    f.box.BorderSizePixel = 0
    f.box.Visible = false
    f.box.ZIndex = 2
    f.box.Parent = ESPGui
    f.boxStroke = Instance.new("UIStroke", f.box)
    f.boxStroke.Color = Config.ESPColor
    f.boxStroke.Thickness = Config.BoxThickness

    f.boxFill = Instance.new("Frame")
    f.boxFill.BackgroundColor3 = Config.ESPColor
    f.boxFill.BackgroundTransparency = Config.BoxFillTransparency
    f.boxFill.BorderSizePixel = 0
    f.boxFill.Visible = false
    f.boxFill.ZIndex = 1
    f.boxFill.Parent = ESPGui

    f.hpBg = Instance.new("Frame")
    f.hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    f.hpBg.BorderSizePixel = 0
    f.hpBg.Visible = false
    f.hpBg.ZIndex = 5
    f.hpBg.Parent = ESPGui
    Instance.new("UICorner", f.hpBg).CornerRadius = UDim.new(1, 0)

    f.hpFill = Instance.new("Frame")
    f.hpFill.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    f.hpFill.BorderSizePixel = 0
    f.hpFill.Visible = false
    f.hpFill.ZIndex = 10
    f.hpFill.Parent = ESPGui
    Instance.new("UICorner", f.hpFill).CornerRadius = UDim.new(1, 0)

    f.name = Instance.new("TextLabel")
    f.name.BackgroundTransparency = 1
    f.name.TextColor3 = Config.NameColor
    f.name.Font = Enum.Font.GothamBold
    f.name.TextSize = 14
    f.name.TextStrokeTransparency = 0
    f.name.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    f.name.Visible = false
    f.name.ZIndex = 20
    f.name.Parent = ESPGui

    f.team = Instance.new("TextLabel")
    f.team.BackgroundTransparency = 1
    f.team.TextColor3 = Color3.fromRGB(180,180,180)
    f.team.Font = Enum.Font.Gotham
    f.team.TextSize = 11
    f.team.TextStrokeTransparency = 0
    f.team.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    f.team.Visible = false
    f.team.ZIndex = 20
    f.team.Parent = ESPGui

    f.dist = Instance.new("TextLabel")
    f.dist.BackgroundTransparency = 1
    f.dist.TextColor3 = Config.DistColor
    f.dist.Font = Enum.Font.Gotham
    f.dist.TextSize = 12
    f.dist.TextStrokeTransparency = 0
    f.dist.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    f.dist.Visible = false
    f.dist.ZIndex = 20
    f.dist.Parent = ESPGui

    f.weapon = Instance.new("TextLabel")
    f.weapon.BackgroundTransparency = 1
    f.weapon.TextColor3 = Color3.fromRGB(255, 200, 60)
    f.weapon.Font = Enum.Font.GothamBold
    f.weapon.TextSize = 12
    f.weapon.TextStrokeTransparency = 0
    f.weapon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    f.weapon.Visible = false
    f.weapon.ZIndex = 20
    f.weapon.Parent = ESPGui

    f.tracer = Instance.new("Frame")
    f.tracer.BackgroundColor3 = Config.TracerColor
    f.tracer.BorderSizePixel = 0
    f.tracer.Visible = false
    f.tracer.ZIndex = 1
    f.tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    f.tracer.Parent = ESPGui

    ESPFrames[plr] = f
    return f
end

local function hideESP(plr)
    local f = ESPFrames[plr]
    if not f then return end
    f.box.Visible = false
    f.boxFill.Visible = false
    f.hpBg.Visible = false
    f.hpFill.Visible = false
    f.name.Visible = false
    f.team.Visible = false
    f.dist.Visible = false
    f.weapon.Visible = false
    f.tracer.Visible = false
    if Highlights[plr] then Highlights[plr].Enabled = false end
    if Skeletons[plr] then
        for _, line in ipairs(Skeletons[plr]) do line.Visible = false end
    end
end

local function updateHighlight(plr, char, visible)
    if not Config.ShowHighlight then
        if Highlights[plr] then Highlights[plr].Enabled = false end
        return
    end
    local h = Highlights[plr]
    if not h or h.Parent ~= char then
        if h then h:Destroy() end
        h = Instance.new("Highlight")
        h.Name = "BurmaldaHighlight"
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = char
        Highlights[plr] = h
    end
    h.Adornee = char
    h.FillColor = Config.HighlightFillColor
    h.FillTransparency = Config.HighlightFillTransparency
    h.OutlineColor = Config.HighlightOutlineColor
    h.OutlineTransparency = Config.HighlightOutlineTransparency
    h.Enabled = true
end

local function isTeammate(plr)
    if not Config.TeamCheck then return false end
    if not plr.Team or not LocalPlayer.Team then return false end
    return plr.Team == LocalPlayer.Team
end

local function inWhitelist(plr)
    if not Config.WhitelistOnly then return true end
    if #Whitelist == 0 then return true end
    for _, n in ipairs(Whitelist) do
        if n == plr.Name then return true end
    end
    return false
end

local function isVisible(targetChar)
    if not targetChar then return false end
    local cam = workspace.CurrentCamera
    if not cam then return false end
    local parts = {targetChar:FindFirstChild("Head"),
        targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso"),
        targetChar:FindFirstChild("HumanoidRootPart")}
    for _, part in ipairs(parts) do
        if part and part:IsA("BasePart") then
            local origin = cam.CFrame.Position
            local dir = (part.Position - origin)
            if dir.Magnitude > 0.1 then
                local rp = RaycastParams.new()
                rp.FilterType = Enum.RaycastFilterType.Exclude
                rp.FilterDescendantsInstances = {LocalPlayer.Character, targetChar}
                rp.IgnoreWater = true
                local result = workspace:Raycast(origin, dir, rp)
                if not result or (result.Instance and result.Instance:IsDescendantOf(targetChar)) then
                    return true
                end
            end
        end
    end
    return false
end

-- Skeleton
local SKELETON_PAIRS = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},
    {"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local SKELETON_PAIRS_R6 = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
    {"Torso","Left Leg"},{"Torso","Right Leg"},
}

local function getSkeletonPairs(char)
    if char:FindFirstChild("UpperTorso") then return SKELETON_PAIRS end
    return SKELETON_PAIRS_R6
end

local function drawSkeleton(plr, char, cam, color)
    if not Config.ShowSkeleton then
        if Skeletons[plr] then
            for _, line in ipairs(Skeletons[plr]) do line.Visible = false end
        end
        return
    end
    if not Skeletons[plr] then
        Skeletons[plr] = {}
        for i = 1, 20 do
            local line = Instance.new("Frame")
            line.BackgroundColor3 = Config.SkeletonColor
            line.BorderSizePixel = 0
            line.AnchorPoint = Vector2.new(0.5,0.5)
            line.ZIndex = 3
            line.Visible = false
            line.Parent = ESPGui
            Skeletons[plr][i] = line
        end
    end
    local idx = 1
    local pairs_ = getSkeletonPairs(char)
    for _, pair in ipairs(pairs_) do
        local a = char:FindFirstChild(pair[1])
        local b = char:FindFirstChild(pair[2])
        if a and b then
            local sa, oa = cam:WorldToViewportPoint(a.Position)
            local sb, ob = cam:WorldToViewportPoint(b.Position)
            if oa and ob and sa.Z > 0 and sb.Z > 0 then
                local line = Skeletons[plr][idx]
                if line then
                    local delta = Vector2.new(sb.X - sa.X, sb.Y - sa.Y)
                    local len = delta.Magnitude
                    local mid = Vector2.new((sa.X+sb.X)/2, (sa.Y+sb.Y)/2)
                    local angle = math.deg(math.atan2(delta.Y, delta.X))
                    line.Size = UDim2.new(0, len, 0, 1)
                    line.Position = UDim2.new(0, mid.X, 0, mid.Y)
                    line.Rotation = angle
                    line.BackgroundColor3 = color
                    line.Visible = true
                    idx = idx + 1
                end
            end
        end
    end
    for i = idx, #Skeletons[plr] do
        Skeletons[plr][i].Visible = false
    end
end

-- ================= ESP LOOP =================
RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not Config.ESPEnabled or isTeammate(plr) or not inWhitelist(plr) then
            hideESP(plr); continue
        end

        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not (char and hrp and head and hum and hum.Health > 0) then hideESP(plr); continue end
        local dist = (cam.CFrame.Position - hrp.Position).Magnitude
        if dist > Config.MaxDistance then hideESP(plr); continue end

        local f = createESPFrames(plr)
        local visible = Config.UseWallColors and isVisible(char) or true
        local color = visible and Config.VisibleColor or Config.HiddenColor
        if not Config.UseWallColors then color = Config.ESPColor end

        updateHighlight(plr, char, visible)

        local size = char:GetExtentsSize()
        local cf = hrp.CFrame
        local hx = size.X/2 + Config.BoxPadding
        local hy = size.Y/2 + Config.BoxPadding
        local hz = size.Z/2 + Config.BoxPadding
        local verts = {
            cf * Vector3.new(-hx, hy, -hz), cf * Vector3.new(hx, hy, -hz),
            cf * Vector3.new(hx, hy, hz), cf * Vector3.new(-hx, hy, hz),
            cf * Vector3.new(-hx, -hy, -hz), cf * Vector3.new(hx, -hy, -hz),
            cf * Vector3.new(hx, -hy, hz), cf * Vector3.new(-hx, -hy, hz),
        }
        local minX, minY = math.huge, math.huge
        local maxX, maxY = -math.huge, -math.huge
        local ok = true
        for _, v in ipairs(verts) do
            local sp, on = cam:WorldToViewportPoint(v)
            if not on or sp.Z <= 0 then ok = false; break end
            if sp.X < minX then minX = sp.X end
            if sp.Y < minY then minY = sp.Y end
            if sp.X > maxX then maxX = sp.X end
            if sp.Y > maxY then maxY = sp.Y end
        end

        if ok and maxX > minX and maxY > minY and (maxX-minX) < 800 then
            local boxW = maxX - minX
            local boxH = maxY - minY

            -- BOX
            if Config.ShowBox then
                if Config.BoxStyle == "Filled" then
                    f.box.Visible = false
                    f.boxFill.Size = UDim2.new(0, boxW, 0, boxH)
                    f.boxFill.Position = UDim2.new(0, minX, 0, minY)
                    f.boxFill.BackgroundColor3 = color
                    f.boxFill.BackgroundTransparency = Config.BoxFillTransparency
                    f.boxFill.Visible = true
                else
                    f.boxFill.Visible = false
                    f.box.Size = UDim2.new(0, boxW, 0, boxH)
                    f.box.Position = UDim2.new(0, minX, 0, minY)
                    f.box.Visible = true
                    f.boxStroke.Color = color
                    f.boxStroke.Thickness = Config.BoxThickness
                end
            else
                f.box.Visible = false
                f.boxFill.Visible = false
            end

            -- SKELETON
            drawSkeleton(plr, char, cam, visible and Config.SkeletonColor or Config.HiddenColor)

            -- HP BAR
            if Config.ShowHealth and (Config.HealthMode == "Bar" or Config.HealthMode == "Both") then
                local maxHP = hum.MaxHealth
                if not maxHP or maxHP <= 0 then maxHP = 100 end
                local curHP = math.clamp(hum.Health, 0, maxHP)
                local hpRatio = curHP / maxHP

                local barW = Config.HealthBarWidth
                local barX = (Config.HealthBarSide == "Left") and (minX - barW - 6) or (maxX + 6)
                local barY = minY
                local barH = boxH
                local fillH = math.max(1, barH * hpRatio)

                f.hpBg.Size = UDim2.new(0, barW, 0, barH)
                f.hpBg.Position = UDim2.new(0, barX, 0, barY)
                f.hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
                f.hpBg.BackgroundTransparency = 0.3
                f.hpBg.Visible = true

                f.hpFill.Size = UDim2.new(0, barW, 0, fillH)
                f.hpFill.Position = UDim2.new(0, barX, 0, barY + barH - fillH)

                if hpRatio > 0.6 then
                    f.hpFill.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
                elseif hpRatio > 0.3 then
                    f.hpFill.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
                else
                    f.hpFill.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
                end
                f.hpFill.BackgroundTransparency = 0
                f.hpFill.Visible = true
            else
                f.hpBg.Visible = false
                f.hpFill.Visible = false
            end

            -- NAME
            if Config.ShowName then
                local sp, on = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
                if on and sp.Z > 0 then
                    local txt = plr.Name
                    if Config.ShowHealthText and (Config.HealthMode == "Numbers" or Config.HealthMode == "Both") then
                        txt = txt .. " [" .. math.floor(hum.Health) .. "]"
                    end
                    f.name.Text = txt
                    f.name.Position = UDim2.new(0, sp.X - 100, 0, sp.Y - 10)
                    f.name.Size = UDim2.new(0, 200, 0, 20)
                    f.name.TextColor3 = visible and Config.NameColor or Config.HiddenColor
                    f.name.Visible = true
                else
                    f.name.Visible = false
                end
            else
                f.name.Visible = false
            end

            -- TEAM
            if Config.ShowTeam and plr.Team then
                local sp, on = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 2.3, 0))
                if on and sp.Z > 0 then
                    f.team.Text = "[" .. plr.Team.Name .. "]"
                    f.team.Position = UDim2.new(0, sp.X - 100, 0, sp.Y - 10)
                    f.team.Size = UDim2.new(0, 200, 0, 16)
                    f.team.Visible = true
                else
                    f.team.Visible = false
                end
            else
                f.team.Visible = false
            end

            -- DIST
            if Config.ShowDistance then
                local sp, on = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
                if on and sp.Z > 0 then
                    f.dist.Text = string.format("[%d m]", math.floor(dist))
                    f.dist.Position = UDim2.new(0, sp.X - 100, 0, sp.Y - 10)
                    f.dist.Size = UDim2.new(0, 200, 0, 20)
                    f.dist.TextColor3 = visible and Config.DistColor or Config.HiddenColor
                    f.dist.Visible = true
                else
                    f.dist.Visible = false
                end
            else
                f.dist.Visible = false
            end

            -- WEAPON
            if Config.EnemyInventoryEnabled then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local sp, on = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 4.5, 0))
                    if on and sp.Z > 0 then
                        f.weapon.Text = "🔫 " .. tool.Name
                        f.weapon.Position = UDim2.new(0, sp.X - 100, 0, sp.Y - 10)
                        f.weapon.Size = UDim2.new(0, 200, 0, 20)
                        f.weapon.Visible = true
                    else
                        f.weapon.Visible = false
                    end
                else
                    f.weapon.Visible = false
                end
            else
                f.weapon.Visible = false
            end

            -- TRACER
            if Config.ShowTracer then
                local origin
                if Config.TracerOrigin == "Bottom" then
                    origin = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                elseif Config.TracerOrigin == "Top" then
                    origin = Vector2.new(cam.ViewportSize.X / 2, 0)
                else
                    origin = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                end
                local target2 = Vector2.new((minX + maxX) / 2, maxY)
                local delta = target2 - origin
                local len = delta.Magnitude
                local mid = (origin + target2) / 2
                local angle = math.deg(math.atan2(delta.Y, delta.X))
                f.tracer.Size = UDim2.new(0, len, 0, 1)
                f.tracer.Position = UDim2.new(0, mid.X, 0, mid.Y)
                f.tracer.Rotation = angle
                f.tracer.BackgroundColor3 = visible and Config.TracerColor or Config.HiddenColor
                f.tracer.Visible = true
            else
                f.tracer.Visible = false
            end
        else
            hideESP(plr)
        end
    end
end)

-- ================= AIMBOT =================
local TargetDot

local function getAimPart(char)
    if not char then return nil end
    if Config.AimPart == "Head" then return char:FindFirstChild("Head")
    elseif Config.AimPart == "Torso" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    elseif Config.AimPart == "Random" then
        local parts = {}
        for _, n in ipairs({"Head","UpperTorso","Torso","HumanoidRootPart"}) do
            local p = char:FindFirstChild(n)
            if p then table.insert(parts, p) end
        end
        if #parts == 0 then return nil end
        return parts[math.random(1, #parts)]
    else
        local closest, closestDist = nil, math.huge
        local cam = workspace.CurrentCamera
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                local sp, on = cam:WorldToViewportPoint(part.Position)
                if on then
                    local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                    if d < closestDist then closestDist = d; closest = part end
                end
            end
        end
        return closest
    end
end

local function getTarget()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local best, bestScore = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or isTeammate(plr) or not inWhitelist(plr) then continue end
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not (hrp and hum and hum.Health > 0) then continue end
        if (cam.CFrame.Position - hrp.Position).Magnitude > Config.MaxAimDist then continue end
        if Config.WallCheck and not isVisible(char) then continue end
        local part = getAimPart(char)
        if not part then continue end
        local sp, on = cam:WorldToViewportPoint(part.Position)
        if not on or sp.Z <= 0 then continue end
        if (Vector2.new(sp.X, sp.Y) - center).Magnitude > Config.FOV then continue end
        local score = (cam.CFrame.Position - hrp.Position).Magnitude
        if Config.AimPriority == "Health" then
            score = hum.Health
        elseif Config.AimPriority == "Crosshair" then
            score = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        end
        if score < bestScore then
            bestScore = score
            best = {player = plr, part = part, char = char, hum = hum, screenPos = Vector2.new(sp.X, sp.Y)}
        end
    end
    return best
end

local function predictPosition(part)
    if Config.Prediction <= 0 then return part.Position end
    local velocity = part.AssemblyLinearVelocity
    return part.Position + velocity * (Config.Prediction / 100)
end

local aimHeld, aimToggled = false, false
local lastTarget = nil

local function isAimActive()
    if Config.ToggleMode then return aimToggled else return aimHeld end
end

local function matchesKey(input, key)
    if not key then return false end
    if typeof(key) == "EnumItem" then
        if key.EnumType == Enum.KeyCode then return input.KeyCode == key end
        if key.EnumType == Enum.UserInputType then return input.UserInputType == key end
    end
    return false
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if matchesKey(input, Config.AimKey) then
        if Config.ToggleMode then aimToggled = not aimToggled
        else aimHeld = true end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if matchesKey(input, Config.AimKey) then
        if not Config.ToggleMode then aimHeld = false end
    end
end)

RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam then return end
    if Config.AimbotEnabled and isAimActive() then
        local target = getTarget()
        if target and target.part then
            if Config.StopOnKill and lastTarget and lastTarget.hum and lastTarget.hum.Health <= 0 then
                aimHeld = false
                aimToggled = false
                lastTarget = nil
                return
            end
            lastTarget = target

            if Config.HitChance < 100 then
                if math.random(1, 100) > Config.HitChance then return end
            end

            local currentCF = cam.CFrame
            local aimPos = predictPosition(target.part)
            local desiredCF
            if Config.AimMode == "Mouse" then
                local sp = cam:WorldToViewportPoint(aimPos)
                local deltaX = sp.X - cam.ViewportSize.X/2
                local deltaY = sp.Y - cam.ViewportSize.Y/2
                local yaw = -deltaX * 0.005
                local pitch = -deltaY * 0.005
                desiredCF = currentCF * CFrame.Angles(pitch, yaw, 0)
            else
                desiredCF = CFrame.new(currentCF.Position, aimPos)
            end
            local ax = math.clamp(1 - Config.SmoothnessX, 0.02, 1)
            local ay = math.clamp(1 - Config.SmoothnessY, 0.02, 1)
            cam.CFrame = currentCF:Lerp(desiredCF, (ax + ay) / 2)

            if Config.AutoShoot then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then pcall(function() tool:Activate() end) end
            end
        end
    else
        lastTarget = nil
    end
end)

-- Target highlight
RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam then return end
    if not (Config.AimbotEnabled and Config.ShowTarget and isAimActive()) then
        if TargetDot then TargetDot.Visible = false end
        return
    end
    local t = getTarget()
    if not t then
        if TargetDot then TargetDot.Visible = false end
        return
    end
    if not TargetDot then
        TargetDot = Instance.new("Frame")
        TargetDot.Size = UDim2.new(0, 8, 0, 8)
        TargetDot.AnchorPoint = Vector2.new(0.5, 0.5)
        TargetDot.BackgroundColor3 = Config.TargetColor
        TargetDot.BorderSizePixel = 0
        TargetDot.ZIndex = 60
        TargetDot.Parent = ScreenGui
        Instance.new("UICorner", TargetDot).CornerRadius = UDim.new(1, 0)
    end
    local sp, on = cam:WorldToViewportPoint(t.part.Position)
    if on and sp.Z > 0 then
        TargetDot.Position = UDim2.new(0, sp.X, 0, sp.Y)
        TargetDot.BackgroundColor3 = Config.TargetColor
        TargetDot.Visible = true
    else
        TargetDot.Visible = false
    end
end)

-- ================= ANTI-AFK =================
task.spawn(function()
    while task.wait(60) do
        if Config.AntiAFK then
            local vu = game:GetService("VirtualUser")
            pcall(function() vu:CaptureController() end)
            pcall(function() vu:ClickButton2(Vector2.new()) end)
        end
    end
end)

-- ================= OPEN BTN =================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 54, 0, 54)
OpenBtn.Position = Config.OpenBtnPosition
OpenBtn.BackgroundColor3 = T().sidebar
OpenBtn.Text = "🥔"
OpenBtn.TextColor3 = T().accent1
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 26
OpenBtn.BorderSizePixel = 0
OpenBtn.AutoButtonColor = false
OpenBtn.Active = true
OpenBtn.ZIndex = 100
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = T().accent1
OpenStroke.Thickness = 2

-- ================= FOV CIRCLE =================
local FOVCircle = Instance.new("Frame")
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Visible = false
FOVCircle.ZIndex = 50
FOVCircle.Parent = ScreenGui
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)
local FOVStroke = Instance.new("UIStroke", FOVCircle)
FOVStroke.Color = Config.FOVColor
FOVStroke.Thickness = 1
FOVStroke.Transparency = Config.FOVTransparency

-- ================= WATERMARK =================
local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(0, 220, 0, 28)
Watermark.Position = UDim2.new(1, -240, 0, 10)
Watermark.BackgroundColor3 = T().sidebar
Watermark.BackgroundTransparency = 0.3
Watermark.Text = Config.WatermarkText
Watermark.TextColor3 = T().accent1
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 13
Watermark.BorderSizePixel = 0
Watermark.Visible = Config.WatermarkEnabled
Watermark.ZIndex = 100
Watermark.Parent = ScreenGui
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 8)
local WmStroke = Instance.new("UIStroke", Watermark)
WmStroke.Color = T().accent1
WmStroke.Thickness = 1
WmStroke.Transparency = 0.5

-- ================= MENU =================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 640, 0, 480)
Main.Position = UDim2.new(0.5, -320, 0.5, -240)
Main.BackgroundColor3 = T().bg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 24)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = T().accent1
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 56)
Header.BackgroundColor3 = T().header
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderAccent = Instance.new("Frame")
HeaderAccent.Size = UDim2.new(1, 0, 0, 3)
HeaderAccent.Position = UDim2.new(0, 0, 1, -3)
HeaderAccent.BorderSizePixel = 0
HeaderAccent.Parent = Header
local HG = Instance.new("UIGradient", HeaderAccent)
HG.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, T().accent1),
    ColorSequenceKeypoint.new(0.5, T().accent2), ColorSequenceKeypoint.new(1, T().accent3)})

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -260, 1, 0)
HeaderTitle.Position = UDim2.new(0, 46, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "🥔 BURMALDA HACK"
HeaderTitle.TextColor3 = T().text
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 17
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local HeaderSub = Instance.new("TextLabel")
HeaderSub.Size = UDim2.new(0, 220, 1, 0)
HeaderSub.Position = UDim2.new(1, -270, 0, 0)
HeaderSub.BackgroundTransparency = 1
HeaderSub.Text = "v17.1"
HeaderSub.TextColor3 = T().textDim
HeaderSub.Font = Enum.Font.Gotham
HeaderSub.TextSize = 12
HeaderSub.TextXAlignment = Enum.TextXAlignment.Right
HeaderSub.Parent = Header

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -78, 0, 13)
Minimize.BackgroundColor3 = T().tabActive
Minimize.Text = "—"
Minimize.TextColor3 = T().text
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 14
Minimize.BorderSizePixel = 0
Minimize.AutoButtonColor = false
Minimize.Parent = Header
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -42, 0, 13)
CloseBtn.BackgroundColor3 = T().tabActive
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = T().text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -56)
Sidebar.Position = UDim2.new(0, 0, 0, 56)
Sidebar.BackgroundColor3 = T().sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 6)
SidebarList.Parent = Sidebar
local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 12)
SidebarPad.PaddingLeft = UDim.new(0, 10)
SidebarPad.PaddingRight = UDim.new(0, 10)
SidebarPad.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -160, 1, -56)
ContentArea.Position = UDim2.new(0, 160, 0, 56)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = Main

local TabButtons = {}
local Pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -24, 1, -20)
    page.Position = UDim2.new(0, 12, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = T().accent1
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = ContentArea
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = page
    Pages[name] = page
    return page
end

local function switchTab(name)
    for n, data in pairs(TabButtons) do
        local active = (n == name)
        TweenService:Create(data.btn, TweenInfo.new(0.25), {
            BackgroundColor3 = active and T().tabActive or T().tabInactive}):Play()
        TweenService:Create(data.accent, TweenInfo.new(0.25), {
            Size = active and UDim2.new(0, 3, 1, -14) or UDim2.new(0, 3, 0, 0)}):Play()
        data.label.TextColor3 = active and T().text or T().textDim
        if Pages[n] then Pages[n].Visible = active end
    end
end

local function createTab(name, icon, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = T().tabInactive
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 0, 0)
    accent.Position = UDim2.new(0, 0, 0.5, 0)
    accent.BackgroundColor3 = T().accent1
    accent.BorderSizePixel = 0
    accent.Parent = btn
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -18, 1, 0)
    lbl.Position = UDim2.new(0, 18, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = icon.."  "..name
    lbl.TextColor3 = T().textDim
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn
    TabButtons[name] = {btn=btn, accent=accent, label=lbl}
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createSection(parent, text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 4, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.TextColor3 = T().textDim
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
end

local function createToggle(parent, text, default, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = T().content
    Btn.Text = ""
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 16, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = T().text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Btn
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 42, 0, 24)
    Indicator.Position = UDim2.new(1, -56, 0.5, -12)
    Indicator.BackgroundColor3 = default and T().accent1 or T().contentHover
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Btn
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Dot.Parent = Indicator
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Indicator, TweenInfo.new(0.25), {
            BackgroundColor3 = state and T().accent1 or T().contentHover}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}):Play()
        callback(state)
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 54)
    Frame.BackgroundColor3 = T().content
    Frame.BorderSizePixel = 0
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -100, 0, 22)
    Label.Position = UDim2.new(0, 16, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = T().text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    local ValueLbl = Instance.new("TextLabel")
    ValueLbl.Size = UDim2.new(0, 70, 0, 22)
    ValueLbl.Position = UDim2.new(1, -86, 0, 4)
    ValueLbl.BackgroundTransparency = 1
    ValueLbl.Text = tostring(default)
    ValueLbl.TextColor3 = T().accent1
    ValueLbl.Font = Enum.Font.GothamBold
    ValueLbl.TextSize = 13
    ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
    ValueLbl.Parent = Frame
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -32, 0, 8)
    BarBg.Position = UDim2.new(0, 16, 1, -18)
    BarBg.BackgroundColor3 = T().contentHover
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Frame
    Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)
    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    BarFill.BackgroundColor3 = T().accent1
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = BarBg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    local dragging = false
    local function setValue(alpha)
        alpha = math.clamp(alpha, 0, 1)
        local val = min + (max-min)*alpha
        BarFill.Size = UDim2.new(alpha, 0, 1, 0)
        Knob.Position = UDim2.new(alpha, -8, 0.5, -8)
        ValueLbl.Text = tostring(math.floor(val*100+0.5)/100)
        callback(val)
    end
    BarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setValue((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            setValue((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

local function createOption(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = T().content
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

local function createTextBox(parent, placeholder, default, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 38)
    box.BackgroundColor3 = T().content
    box.Text = default or ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.PlaceholderColor3 = T().textDim
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(1, 0)
    box.FocusLost:Connect(function() callback(box.Text) end)
    return box
end

function applyTheme()
    local t = T()
    Main.BackgroundColor3 = t.bg
    MainStroke.Color = t.accent1
    Header.BackgroundColor3 = t.header
    Sidebar.BackgroundColor3 = t.sidebar
    HG.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, t.accent1),
        ColorSequenceKeypoint.new(0.5, t.accent2), ColorSequenceKeypoint.new(1, t.accent3)})
    HeaderTitle.TextColor3 = t.text
    HeaderSub.TextColor3 = t.textDim
    OpenStroke.Color = t.accent1
    OpenBtn.TextColor3 = t.accent1
    OpenBtn.BackgroundColor3 = t.sidebar
    CloseBtn.TextColor3 = t.text
    Minimize.TextColor3 = t.text
    Watermark.BackgroundColor3 = t.sidebar
    Watermark.TextColor3 = t.accent1
    WmStroke.Color = t.accent1
    for name, data in pairs(TabButtons) do
        data.accent.BackgroundColor3 = t.accent1
        local active = Pages[name] and Pages[name].Visible
        data.btn.BackgroundColor3 = active and t.tabActive or t.tabInactive
        data.label.TextColor3 = active and t.text or t.textDim
    end
end

-- ================= ВКЛАДКИ =================
createTab("ESP", "👁", 1)
createTab("Aimbot", "🎯", 2)
createTab("Visuals", "✨", 3)
createTab("Colors", "🎨", 4)
createTab("Players", "👥", 5)
createTab("Settings", "⚙", 6)

local espPage = createPage("ESP")
local aimPage = createPage("Aimbot")
local visPage = createPage("Visuals")
local colPage = createPage("Colors")
local plrPage = createPage("Players")
local setPage = createPage("Settings")

-- ESP
createSection(espPage, "Основное")
createToggle(espPage, "ESP Включён", Config.ESPEnabled, function(v) Config.ESPEnabled = v end)
createToggle(espPage, "Проверка команды", Config.TeamCheck, function(v) Config.TeamCheck = v end)
createSection(espPage, "Отображение")
createToggle(espPage, "Боксы", Config.ShowBox, function(v) Config.ShowBox = v end)
createToggle(espPage, "Скелет", Config.ShowSkeleton, function(v) Config.ShowSkeleton = v end)
createToggle(espPage, "Имена", Config.ShowName, function(v) Config.ShowName = v end)
createToggle(espPage, "Команда", Config.ShowTeam, function(v) Config.ShowTeam = v end)
createToggle(espPage, "HP", Config.ShowHealth, function(v) Config.ShowHealth = v end)
createToggle(espPage, "Дистанция", Config.ShowDistance, function(v) Config.ShowDistance = v end)
createToggle(espPage, "Оружие врага", Config.EnemyInventoryEnabled, function(v) Config.EnemyInventoryEnabled = v end)
createSection(espPage, "Стиль боксов")
local boxStyles = {{name="2D", value="2D"}, {name="Filled", value="Filled"}}
local boxBtns = {}
for _, opt in ipairs(boxStyles) do
    local b = createOption(espPage, opt.name, function(btn)
        Config.BoxStyle = opt.value
        for v, btn2 in pairs(boxBtns) do
            TweenService:Create(btn2, TweenInfo.new(0.15), {
                BackgroundColor3 = (v == opt.value) and T().accent1 or T().content}):Play()
        end
    end)
    if opt.value == Config.BoxStyle then b.BackgroundColor3 = T().accent1 end
    boxBtns[opt.value] = b
end
createSlider(espPage, "Толщина обводки", 1, 5, Config.BoxThickness, function(v) Config.BoxThickness = v end)
createSlider(espPage, "Прозрачность заливки", 0, 1, Config.BoxFillTransparency, function(v) Config.BoxFillTransparency = v end)
createSection(espPage, "Wall Sense")
createToggle(espPage, "Умная подсветка", Config.UseWallColors, function(v) Config.UseWallColors = v end)
createSection(espPage, "HP-полоска")
local hpModes = {{name="🔢 Цифры", value="Numbers"}, {name="📊 Полоска", value="Bar"}, {name="🔢📊 Оба", value="Both"}}
local hpBtns = {}
for _, opt in ipairs(hpModes) do
    local b = createOption(espPage, opt.name, function(btn)
        Config.HealthMode = opt.value
        for v, btn2 in pairs(hpBtns) do
            TweenService:Create(btn2, TweenInfo.new(0.15), {
                BackgroundColor3 = (v == opt.value) and T().accent1 or T().content}):Play()
        end
    end)
    if opt.value == Config.HealthMode then b.BackgroundColor3 = T().accent1 end
    hpBtns[opt.value] = b
end
createSlider(espPage, "Толщина HP", 3, 15, Config.HealthBarWidth, function(v) Config.HealthBarWidth = v end)
createSlider(espPage, "Макс. дистанция", 50, 3000, Config.MaxDistance, function(v) Config.MaxDistance = v end)

-- AIMBOT
createSection(aimPage, "Основное")
createToggle(aimPage, "Aimbot Включён", Config.AimbotEnabled, function(v) Config.AimbotEnabled = v end)
createToggle(aimPage, "Показывать цель", Config.ShowTarget, function(v) Config.ShowTarget = v end)
createSection(aimPage, "Точность")
createSlider(aimPage, "FOV", 20, 600, Config.FOV, function(v) Config.FOV = v end)
createSlider(aimPage, "Smoothness X", 0, 0.95, Config.SmoothnessX, function(v) Config.SmoothnessX = v end)
createSlider(aimPage, "Smoothness Y", 0, 0.95, Config.SmoothnessY, function(v) Config.SmoothnessY = v end)
createSlider(aimPage, "Prediction", 0, 500, Config.Prediction, function(v) Config.Prediction = v end)
createSlider(aimPage, "Hit Chance %", 0, 100, Config.HitChance, function(v) Config.HitChance = v end)
createSlider(aimPage, "Max Aim Dist", 50, 2000, Config.MaxAimDist, function(v) Config.MaxAimDist = v end)
createSection(aimPage, "Режим")
local aimModes = {{name="🎥 Camera", value="Camera"}, {name="🖱 Mouse", value="Mouse"}}
local aimModeBtns = {}
for _, opt in ipairs(aimModes) do
    local b = createOption(aimPage, opt.name, function(btn)
        Config.AimMode = opt.value
        for v, btn2 in pairs(aimModeBtns) do
            TweenService:Create(btn2, TweenInfo.new(0.15), {
                BackgroundColor3 = (v == opt.value) and T().accent1 or T().content}):Play()
        end
    end)
    if opt.value == Config.AimMode then b.BackgroundColor3 = T().accent1 end
    aimModeBtns[opt.value] = b
end
createSection(aimPage, "Часть тела")
local aimOpts = {{name="🎯 Head", value="Head"}, {name="🎯 Torso", value="Torso"}, {name="🎯 Nearest", value="Nearest"}, {name="🎲 Random", value="Random"}}
local aimBtns = {}
for _, opt in ipairs(aimOpts) do
    local b = createOption(aimPage, opt.name, function(btn)
        Config.AimPart = opt.value
        for v, btn2 in pairs(aimBtns) do
            TweenService:Create(btn2, TweenInfo.new(0.15), {
                BackgroundColor3 = (v == opt.value) and T().accent1 or T().content}):Play()
        end
    end)
    if opt.value == Config.AimPart then b.BackgroundColor3 = T().accent1 end
    aimBtns[opt.value] = b
end
createSection(aimPage, "Приоритет")
local priorities = {{name="📏 Distance", value="Distance"}, {name="❤ Health", value="Health"}, {name="✛ Crosshair", value="Crosshair"}}
local prioBtns = {}
for _, opt in ipairs(priorities) do
    local b = createOption(aimPage, opt.name, function(btn)
        Config.AimPriority = opt.value
        for v, btn2 in pairs(prioBtns) do
            TweenService:Create(btn2, TweenInfo.new(0.15), {
                BackgroundColor3 = (v == opt.value) and T().accent1 or T().content}):Play()
        end
    end)
    if opt.value == Config.AimPriority then b.BackgroundColor3 = T().accent1 end
    prioBtns[opt.value] = b
end
createSection(aimPage, "Дополнительно")
createToggle(aimPage, "Wall Check", Config.WallCheck, function(v) Config.WallCheck = v end)
createToggle(aimPage, "Toggle режим", Config.ToggleMode, function(v) Config.ToggleMode = v end)
createToggle(aimPage, "Авто-выстрел", Config.AutoShoot, function(v) Config.AutoShoot = v end)
createToggle(aimPage, "Стоп после убийства", Config.StopOnKill, function(v) Config.StopOnKill = v end)
createSection(aimPage, "Клавиша активации")
local keyBtn = createOption(aimPage, "Текущая: " .. Config.AimKeyString .. " (нажми чтобы сменить)", function(btn)
    btn.Text = "Нажми любую клавишу..."
    local conn
    conn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.MouseButton2
        or input.UserInputType == Enum.UserInputType.MouseButton3 then
            Config.AimKey = input.UserInputType
            Config.AimKeyString = input.UserInputType.Name
        elseif input.KeyCode ~= Enum.KeyCode.Unknown then
            Config.AimKey = input.KeyCode
            Config.AimKeyString = input.KeyCode.Name
        else
            return
        end
        conn:Disconnect()
        btn.Text = "Текущая: " .. Config.AimKeyString .. " (нажми чтобы сменить)"
        notify("Клавиша изменена: " .. Config.AimKeyString, Color3.fromRGB(100,255,100))
    end)
end)

-- VISUALS
createSection(visPage, "Highlight")
createToggle(visPage, "Highlight ESP", Config.ShowHighlight, function(v) Config.ShowHighlight = v end)
createSlider(visPage, "Fill Transparency", 0, 1, Config.HighlightFillTransparency, function(v) Config.HighlightFillTransparency = v end)
createSlider(visPage, "Outline Transparency", 0, 1, Config.HighlightOutlineTransparency, function(v) Config.HighlightOutlineTransparency = v end)
createSection(visPage, "Tracer")
createToggle(visPage, "Линии до игроков", Config.ShowTracer, function(v) Config.ShowTracer = v end)
local tracerOpts = {{name="⬇ Снизу", value="Bottom"}, {name="⬆ Сверху", value="Top"}, {name="✛ Центр", value="Center"}}
local tracerBtns = {}
for _, opt in ipairs(tracerOpts) do
    local b = createOption(visPage, opt.name, function(btn)
        Config.TracerOrigin = opt.value
        for v, btn2 in pairs(tracerBtns) do
            TweenService:Create(btn2, TweenInfo.new(0.15), {
                BackgroundColor3 = (v == opt.value) and T().accent1 or T().content}):Play()
        end
    end)
    if opt.value == Config.TracerOrigin then b.BackgroundColor3 = T().accent1 end
    tracerBtns[opt.value] = b
end
createSection(visPage, "FOV Circle")
createToggle(visPage, "Показывать FOV", Config.ShowFOV, function(v) Config.ShowFOV = v; FOVCircle.Visible = v end)
createSlider(visPage, "FOV Transparency", 0, 1, Config.FOVTransparency, function(v) Config.FOVTransparency = v; FOVStroke.Transparency = v end)
createSection(visPage, "Watermark")
createToggle(visPage, "Показывать Watermark", Config.WatermarkEnabled, function(v) Config.WatermarkEnabled = v; Watermark.Visible = v end)
createSection(visPage, "Misc")
createToggle(visPage, "Anti-AFK", Config.AntiAFK, function(v) Config.AntiAFK = v end)

-- COLORS (все colorRow с исправленным синтаксисом)
local function colorRow(parent, label, getter, setter)
    createSection(parent, label)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = T().content
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -80, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = T().text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local swatch = Instance.new("Frame")
    swatch.Size = UDim2.new(0, 60, 0, 22)
    swatch.Position = UDim2.new(1, -70, 0.5, -11)
    swatch.BackgroundColor3 = getter()
    swatch.BorderSizePixel = 0
    swatch.Parent = row
    Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 6)

    local startC = getter()
    lbl.Text = string.format("RGB(%d,%d,%d)", math.floor(startC.R*255), math.floor(startC.G*255), math.floor(startC.B*255))

    for i, ch in ipairs({"R","G","B"}) do
        local c0 = getter()
        local val = ({c0.R, c0.G, c0.B})[i] * 255
        createSlider(parent, "  " .. ch, 0, 255, val, function(v)
            local c = getter()
            local comps = {c.R*255, c.G*255, c.B*255}
            comps[i] = v
            local newC = Color3.fromRGB(comps[1], comps[2], comps[3])
            setter(newC)
            swatch.BackgroundColor3 = newC
            lbl.Text = string.format("RGB(%d,%d,%d)", math.floor(comps[1]), math.floor(comps[2]), math.floor(comps[3]))
        end)
    end
end

colorRow(colPage, "ESP Color", function() return Config.ESPColor end, function(c) Config.ESPColor = c end)
colorRow(colPage, "Visible Color", function() return Config.VisibleColor end, function(c) Config.VisibleColor = c end)
colorRow(colPage, "Hidden Color", function() return Config.HiddenColor end, function(c) Config.HiddenColor = c end)
colorRow(colPage, "Name Color", function() return Config.NameColor end, function(c) Config.NameColor = c end)
colorRow(colPage, "Tracer Color", function() return Config.TracerColor end, function(c) Config.TracerColor = c end)
colorRow(colPage, "Highlight Fill", function() return Config.HighlightFillColor end, function(c) Config.HighlightFillColor = c end)
colorRow(colPage, "Highlight Outline", function() return Config.HighlightOutlineColor end, function(c) Config.HighlightOutlineColor = c end)
colorRow(colPage, "Skeleton", function() return Config.SkeletonColor end, function(c) Config.SkeletonColor = c end)
colorRow(colPage, "FOV Color", function() return Config.FOVColor end, function(c)
    Config.FOVColor = c
    FOVStroke.Color = c
end)
colorRow(colPage, "Target Color", function() return Config.TargetColor end, function(c) Config.TargetColor = c end)

-- PLAYERS
createSection(plrPage, "Whitelist")
createToggle(plrPage, "Только из списка", Config.WhitelistOnly, function(v) Config.WhitelistOnly = v end)
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(1, 0, 0, 300)
PlayerListFrame.BackgroundColor3 = T().content
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Parent = plrPage
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0, 12)
local plrScroll = Instance.new("ScrollingFrame", PlayerListFrame)
plrScroll.Size = UDim2.new(1, 0, 1, 0)
plrScroll.BackgroundTransparency = 1
plrScroll.BorderSizePixel = 0
plrScroll.ScrollBarThickness = 4
plrScroll.ScrollBarImageColor3 = T().accent1
plrScroll.CanvasSize = UDim2.new(0,0,0,0)
plrScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local plrLayout = Instance.new("UIListLayout", plrScroll)
plrLayout.Padding = UDim.new(0, 4)
local plrPad = Instance.new("UIPadding", plrScroll)
plrPad.PaddingTop = UDim.new(0, 8)
plrPad.PaddingLeft = UDim.new(0, 8)
plrPad.PaddingRight = UDim.new(0, 8)

local function inWL(name)
    for _, n in ipairs(Whitelist) do
        if n == name then return true end
    end
    return false
end

local function refreshPlayerList()
    for _, c in ipairs(plrScroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 34)
        b.BackgroundColor3 = inWL(plr.Name) and T().accent1 or T().contentHover
        b.Text = (inWL(plr.Name) and "✅ " or "⬜ ") .. plr.Name
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Font = Enum.Font.Gotham
        b.TextSize = 13
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Parent = plrScroll
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function()
            if inWL(plr.Name) then
                for i, n in ipairs(Whitelist) do
                    if n == plr.Name then table.remove(Whitelist, i); break end
                end
            else
                table.insert(Whitelist, plr.Name)
            end
            refreshPlayerList()
        end)
    end
end
refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(function() task.wait(0.1); refreshPlayerList() end)

-- SETTINGS / CONFIGS
createSection(setPage, "Тема")
local themeKeys = {}
for k in pairs(Themes) do table.insert(themeKeys, k) end
table.sort(themeKeys)
local themeBtns = {}
for _, k in ipairs(themeKeys) do
    local b = createOption(setPage, Themes[k].name, function(btn)
        Config.Theme = k
        for key, btn2 in pairs(themeBtns) do
            TweenService:Create(btn2, TweenInfo.new(0.2), {
                BackgroundColor3 = (key == k) and Themes[key].accent1 or T().content}):Play()
        end
        applyTheme()
    end)
    if k == Config.Theme then b.BackgroundColor3 = Themes[k].accent1 end
    themeBtns[k] = b
end

createSection(setPage, "Конфиги")
local ConfigStatusLbl = Instance.new("TextLabel")
ConfigStatusLbl.Size = UDim2.new(1, 0, 0, 24)
ConfigStatusLbl.BackgroundTransparency = 1
ConfigStatusLbl.Text = hasFS and ("Папка: " .. ConfigFolder) or "⚠ Executor не поддерживает файлы"
ConfigStatusLbl.TextColor3 = hasFS and T().textDim or Color3.fromRGB(255,120,120)
ConfigStatusLbl.Font = Enum.Font.Gotham
ConfigStatusLbl.TextSize = 11
ConfigStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
ConfigStatusLbl.Parent = setPage

local ConfigNameBox = createTextBox(setPage, "Имя конфига", "default", function(v)
    if v and v ~= "" then Config.CurrentConfig = v end
end)

local cfgRow = Instance.new("Frame")
cfgRow.Size = UDim2.new(1, 0, 0, 44)
cfgRow.BackgroundTransparency = 1
cfgRow.Parent = setPage
local cfgLayout = Instance.new("UIListLayout", cfgRow)
cfgLayout.FillDirection = Enum.FillDirection.Horizontal
cfgLayout.Padding = UDim.new(0, 6)
cfgLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function mkBtn(text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 140, 0, 38)
    b.BackgroundColor3 = color or T().content
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = cfgRow
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    return b
end

local SaveBtn = mkBtn("💾 Сохранить", T().accent1)
local LoadBtn = mkBtn("📂 Загрузить")
local DeleteBtn = mkBtn("🗑 Удалить", Color3.fromRGB(180,50,50))
local RefreshBtn = mkBtn("🔄 Обновить")

local ConfigList = Instance.new("Frame")
ConfigList.Size = UDim2.new(1, 0, 0, 160)
ConfigList.BackgroundColor3 = T().content
ConfigList.BorderSizePixel = 0
ConfigList.Parent = setPage
Instance.new("UICorner", ConfigList).CornerRadius = UDim.new(0, 12)
local listScroll = Instance.new("ScrollingFrame", ConfigList)
listScroll.Size = UDim2.new(1, 0, 1, 0)
listScroll.BackgroundTransparency = 1
listScroll.BorderSizePixel = 0
listScroll.ScrollBarThickness = 4
listScroll.ScrollBarImageColor3 = T().accent1
listScroll.CanvasSize = UDim2.new(0,0,0,0)
listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local lsLayout = Instance.new("UIListLayout", listScroll)
lsLayout.Padding = UDim.new(0, 4)
local lsPad = Instance.new("UIPadding", listScroll)
lsPad.PaddingTop = UDim.new(0, 8)
lsPad.PaddingLeft = UDim.new(0, 8)
lsPad.PaddingRight = UDim.new(0, 8)

local function refreshConfigList()
    for _, c in ipairs(listScroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local list = listConfigs()
    if #list == 0 then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 30)
        lbl.BackgroundTransparency = 1
        lbl.Text = hasFS and "— пусто —" or "— нет доступа к файлам —"
        lbl.TextColor3 = T().textDim
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.Parent = listScroll
        return
    end
    for _, name in ipairs(list) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 32)
        b.BackgroundColor3 = T().contentHover
        b.Text = (name == Config.CurrentConfig) and ("✅ " .. name) or ("📄 " .. name)
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Font = Enum.Font.Gotham
        b.TextSize = 13
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Parent = listScroll
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function()
            Config.CurrentConfig = name
            ConfigNameBox.Text = name
            refreshConfigList()
        end)
    end
end

SaveBtn.MouseButton1Click:Connect(function()
    local name = ConfigNameBox.Text
    if not name or name == "" then name = "default" end
    local ok, err = saveConfig(name)
    if ok then
        ConfigStatusLbl.Text = "✅ Сохранено: " .. name
        ConfigStatusLbl.TextColor3 = Color3.fromRGB(100,255,100)
        Config.CurrentConfig = name
        notify("Сохранено: " .. name, Color3.fromRGB(100,255,100))
        refreshConfigList()
    else
        ConfigStatusLbl.Text = "❌ " .. tostring(err)
        ConfigStatusLbl.TextColor3 = Color3.fromRGB(255,100,100)
        notify("Ошибка: " .. tostring(err), Color3.fromRGB(255,100,100))
    end
end)

LoadBtn.MouseButton1Click:Connect(function()
    local name = ConfigNameBox.Text
    if not name or name == "" then name = "default" end
    local ok, err = loadConfig(name)
    if ok then
        ConfigStatusLbl.Text = "✅ Загружено: " .. name
        ConfigStatusLbl.TextColor3 = Color3.fromRGB(100,255,100)
        applyTheme()
        notify("Загружено: " .. name, Color3.fromRGB(100,255,100))
        refreshConfigList()
    else
        ConfigStatusLbl.Text = "❌ " .. tostring(err)
        ConfigStatusLbl.TextColor3 = Color3.fromRGB(255,100,100)
        notify("Ошибка: " .. tostring(err), Color3.fromRGB(255,100,100))
    end
end)

DeleteBtn.MouseButton1Click:Connect(function()
    local name = ConfigNameBox.Text
    if deleteConfig(name) then
        ConfigStatusLbl.Text = "🗑 Удалён: " .. name
        ConfigStatusLbl.TextColor3 = Color3.fromRGB(255,200,100)
        notify("Удалён: " .. name, Color3.fromRGB(255,200,100))
        refreshConfigList()
    else
        ConfigStatusLbl.Text = "❌ Не найден: " .. name
        ConfigStatusLbl.TextColor3 = Color3.fromRGB(255,100,100)
    end
end)

RefreshBtn.MouseButton1Click:Connect(function()
    refreshConfigList()
    ConfigStatusLbl.Text = "🔄 Обновлено"
    ConfigStatusLbl.TextColor3 = T().textDim
end)

refreshConfigList()

-- ================= DRAG =================
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- ================= MENU OPEN/CLOSE =================
local function openMenu()
    Main.Visible = true
    OpenBtn.Visible = false
end
local function closeMenu()
    Main.Visible = false
    OpenBtn.Visible = true
end
CloseBtn.MouseButton1Click:Connect(closeMenu)
Minimize.MouseButton1Click:Connect(closeMenu)
OpenBtn.MouseButton1Click:Connect(openMenu)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Main.Visible then closeMenu() else openMenu() end
    end
end)

-- ================= FOV CIRCLE UPDATE =================
RunService.RenderStepped:Connect(function()
    if Config.ShowFOV then
        local d = Config.FOV * 2
        FOVCircle.Size = UDim2.new(0, d, 0, d)
        FOVCircle.Visible = true
        FOVStroke.Color = Config.FOVColor
    else
        FOVCircle.Visible = false
    end
end)

OpenBtn.Visible = false
switchTab("ESP")
openMenu()
notify("BURMALDA v17.1 загружен", Color3.fromRGB(100,255,100))
print("[BURMALDA v17.1] Loaded! ✅ Configs: " .. (hasFS and "ON" or "OFF"))
