local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local guiParent = LP:WaitForChild("PlayerGui")

if guiParent:FindFirstChild("NavMenu") then
    guiParent.NavMenu:Destroy()
end

local S = {
    Fly=false, Speed=false, Wall=false, ESP=false,
    Aimbot=false, AimbotFOV=200, AimbotSmooth=1,
    HorseSpeed=false, HorseSpeedVal=150,
    FlySpeed=80, WalkSpeed=80, FilterTeam=false,
    TeamByTeam=false, TeamByColor=true, TeamByNpc=true,
    InfJump=false, ClickTP=false
}

local C = {
    BG=Color3.fromRGB(18,20,27), Panel=Color3.fromRGB(27,30,40),
    Left=Color3.fromRGB(23,26,35), Off=Color3.fromRGB(48,53,67),
    On=Color3.fromRGB(40,155,105), Blue=Color3.fromRGB(65,115,220),
    White=Color3.fromRGB(240,242,248), Gray=Color3.fromRGB(155,162,180),
    Red=Color3.fromRGB(190,65,70)
}

local SG = Instance.new("ScreenGui")
SG.Name = "NavMenu"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.DisplayOrder = 99999
SG.Parent = guiParent

local fovCircle = Instance.new("Frame", SG)
fovCircle.BackgroundTransparency = 1
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.Size = UDim2.new(0, S.AimbotFOV * 2, 0, S.AimbotFOV * 2)
fovCircle.Visible = false
fovCircle.ZIndex = 1
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke", fovCircle)
fovStroke.Color = Color3.fromRGB(255, 80, 80)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.5

local function New(class, props, parent)
    local o = Instance.new(class)
    for k,v in pairs(props) do o[k] = v end
    o.Parent = parent or SG
    return o
end

local Main = New("Frame", { Size=UDim2.fromOffset(540,340), Position=UDim2.new(.5,-270,.5,-170), BackgroundColor3=C.BG, ClipsDescendants=true, BorderSizePixel=0 })
New("UICorner",{CornerRadius=UDim.new(0,12)},Main)
New("UIStroke",{Color=Color3.fromRGB(48,54,70),Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},Main)

local Header = New("Frame", { Size=UDim2.new(1,0,0,38), BackgroundColor3=C.Panel, BorderSizePixel=0 },Main)
New("UICorner",{CornerRadius=UDim.new(0,12)},Header)
local HeaderTitle = New("TextButton", { Size=UDim2.new(1,-200,1,0), Position=UDim2.fromOffset(13,0), BackgroundTransparency=1, Text="NAV MENU | 终极稳定", TextColor3=C.White, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, AutoButtonColor=false, BorderSizePixel=0 },Header)

local scale = 1
local function updateScale(v)
    scale = math.clamp(math.floor(v * 10 + 0.5) / 10, 0.6, 1.4)
    Main.Size = UDim2.fromOffset(540 * scale, 340 * scale)
end

local function HeaderBtn(text,x,color,cb)
    local b=New("TextButton",{ Size=UDim2.fromOffset(30,26), Position=UDim2.new(1,x,0,6), BackgroundColor3=color, Text=text, TextColor3=C.White, Font=Enum.Font.GothamBold, TextSize=13, AutoButtonColor=false, BorderSizePixel=0 },Header)
    New("UICorner",{CornerRadius=UDim.new(0,5)},b)
    b.MouseButton1Click:Connect(cb)
end

HeaderBtn("_",-132,C.Off,function()
    if Main.Size.Y.Offset == 38 then
        Main.Size = UDim2.fromOffset(540 * scale, 340 * scale)
    else
        Main.Size = UDim2.fromOffset(540 * scale, 38)
    end
end)
HeaderBtn("-", -96,C.Off,function() updateScale(scale - 0.1) end)
HeaderBtn("+", -60,C.Blue,function() updateScale(scale + 0.1) end)
HeaderBtn("X", -24,C.Red,function() SG:Destroy() end)

local Body=New("Frame",{ Size=UDim2.new(1,0,1,-38), Position=UDim2.fromOffset(0,38), BackgroundTransparency=1 },Main)
local Left=New("ScrollingFrame",{ Size=UDim2.new(0,135,1,-12), Position=UDim2.fromOffset(7,6), BackgroundColor3=C.Left, BorderSizePixel=0, ScrollBarThickness=2, CanvasSize=UDim2.new(0,0,0,500) },Body)
New("UICorner",{CornerRadius=UDim.new(0,8)},Left)

local Right=New("ScrollingFrame",{ Size=UDim2.new(1,-155,1,-12), Position=UDim2.fromOffset(148,6), BackgroundColor3=C.Panel, BorderSizePixel=0, ScrollBarThickness=2, CanvasSize=UDim2.new(0,0,0,500) },Body)
New("UICorner",{CornerRadius=UDim.new(0,8)},Right)

local Categories={}
local Pages={}
local currentY = 10

local function ClearParams()
    for _,v in ipairs(Right:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("Frame") then v:Destroy() end
    end
    currentY = 10
    Right.CanvasSize = UDim2.new(0, 0, 0, currentY)
end

local function AddCategory(name, order)
    local b = New("TextButton", {
        Size = UDim2.new(1, -10, 0, 37),
        Position = UDim2.fromOffset(5, 10 + (order * 42)),
        BackgroundColor3 = C.Off,
        Text = "   " .. name,
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = false,
        BorderSizePixel = 0
    }, Left)
    New("UICorner",{CornerRadius=UDim.new(0,6)},b)

    local ind = New("Frame",{ Size=UDim2.new(0,3,0,18), Position=UDim2.new(0,4,0.5,-9), BackgroundColor3=C.Blue, Visible=false },b)
    New("UICorner",{CornerRadius=UDim.new(1,0)},ind)

    Categories[name] = {Btn = b, Ind = ind}

    b.MouseButton1Click:Connect(function()
        for n, data in pairs(Categories) do
            if n == name then
                data.Btn.BackgroundColor3 = C.Blue
                data.Ind.Visible = true
            else
                data.Btn.BackgroundColor3 = C.Off
                data.Ind.Visible = false
            end
        end
        ClearParams()
        if Pages[name] then pcall(Pages[name]) end
    end)
end

local function Toggle(name, default, cb)
    local state = default
    local b = New("TextButton", {
        Size = UDim2.new(1, -16, 0, 37),
        Position = UDim2.fromOffset(8, currentY),
        BackgroundColor3 = state and C.On or C.Off,
        Text = name .. " : " .. (state and "开启" or "关闭"),
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        AutoButtonColor = false
    }, Right)
    New("UICorner",{CornerRadius=UDim.new(0,6)},b)
    currentY = currentY + 44
    Right.CanvasSize = UDim2.new(0, 0, 0, currentY)

    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and C.On or C.Off
        b.Text = name .. " : " .. (state and "开启" or "关闭")
        pcall(cb, state)
    end)
end

local function Slider(name, min, max, default, cb)
    local f = New("Frame", {
        Size = UDim2.new(1, -16, 0, 45),
        Position = UDim2.fromOffset(8, currentY),
        BackgroundTransparency = 1
    }, Right)
    currentY = currentY + 50
    Right.CanvasSize = UDim2.new(0, 0, 0, currentY)

    local label = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = name .. " : " .. default,
        TextColor3 = C.White,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, f)

    local bar = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.fromOffset(0, 25),
        BackgroundColor3 = C.Off,
        Text = "",
        BorderSizePixel = 0
    }, f)
    New("UICorner",{CornerRadius=UDim.new(1,0)},bar)

    local fill = New("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = C.Blue,
        BorderSizePixel = 0
    }, bar)
    New("UICorner",{CornerRadius=UDim.new(1,0)},fill)

    local dragging = false
    local function update(x)
        local p = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * p)
        fill.Size = UDim2.new(p, 0, 1, 0)
        label.Text = name .. " : " .. value
        pcall(cb, value)
    end
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; update(i.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
            update(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function Action(name, cb)
    local b = New("TextButton", {
        Size = UDim2.new(1, -16, 0, 37),
        Position = UDim2.fromOffset(8, currentY),
        BackgroundColor3 = C.Blue,
        Text = name,
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        AutoButtonColor = false
    }, Right)
    New("UICorner",{CornerRadius=UDim.new(0,6)},b)
    currentY = currentY + 44
    Right.CanvasSize = UDim2.new(0, 0, 0, currentY)
    b.MouseButton1Click:Connect(function() pcall(cb) end)
end

-- ==================== 队伍识别 ====================
local function getFaction(c)
    local char = c and (c.Parent and c or (c:IsA("Player") and c.Character))
    if not char then return nil end
    local a = char:GetAttribute("Team")
    if a ~= nil then return a end
    local v = char:FindFirstChild("Team") or char:FindFirstChild("Faction") or char:FindFirstChild("Side")
    if v and v:IsA("StringValue") then return v.Value end
    return nil
end

local function IsTeammate(p)
    if not S.FilterTeam then return false end
    local hasTeamInfo = false
    if S.TeamByTeam and LP.Team and p.Team then 
        hasTeamInfo = true
        if LP.Team ~= p.Team then return false end
    end
    if S.TeamByColor then
        local lc, pc = LP.TeamColor, p.TeamColor
        if lc and pc then 
            hasTeamInfo = true
            if lc ~= pc then return false end
        end
    end
    if S.TeamByNpc then
        local lf, pf = getFaction(LP.Character), getFaction(p.Character)
        if lf ~= nil and pf ~= nil then 
            hasTeamInfo = true
            if lf ~= pf then return false end
        end
    end
    return hasTeamInfo
end

-- ==================== 核心逻辑区 ====================
local hum, hrp, targetPart
local bv, bg, horseBv, tpConn

local function onChar(c)
    hum = c:WaitForChild("Humanoid", 5)
    hrp = c:WaitForChild("HumanoidRootPart", 5)
end
LP.CharacterAdded:Connect(onChar)
if LP.Character then task.spawn(function() onChar(LP.Character) end) end

UIS.JumpRequest:Connect(function()
    if S.InfJump and hum and hum.Health > 0 then
        if hum:GetState() ~= Enum.HumanoidStateType.Dead then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function setupTP()
    if tpConn then tpConn:Disconnect() tpConn = nil end
    if not S.ClickTP then return end
    tpConn = UIS.InputBegan:Connect(function(input, gp)
        if gp or not hrp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            task.delay(0.2, function()
                if input.UserInputState == Enum.UserInputState.End then return end
                local mp = input.Position
                local ray = Cam:ViewportPointToRay(mp.X, mp.Y)
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {LP.Character}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local result = workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
                if result then
                    hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
                end
            end)
        end
    end)
end

Pages["移动"] = function()
    Toggle("飞行", S.Fly, function(v) S.Fly = v end)
    Toggle("加速", S.Speed, function(v) S.Speed = v end)
    Toggle("穿墙", S.Wall, function(v) S.Wall = v end)
    Toggle("无限跳跃", S.InfJump, function(v) S.InfJump = v end)
    Toggle("点击传送", S.ClickTP, function(v) S.ClickTP = v; setupTP() end)
    Slider("飞行速度", 20, 1000, S.FlySpeed, function(v) S.FlySpeed = v end)
    Slider("行走速度", 16, 1000, S.WalkSpeed, function(v) S.WalkSpeed = v end)
end

Pages["战斗"] = function()
    Toggle("自瞄锁头", S.Aimbot, function(v) S.Aimbot = v; fovCircle.Visible = v end)
    Toggle("只锁敌人", S.FilterTeam, function(v) S.FilterTeam = v end)
    Slider("自瞄范围", 50, 1000, S.AimbotFOV, function(v) S.AimbotFOV = v; fovCircle.Size = UDim2.new(0, v * 2, 0, v * 2) end)
    Slider("平滑度", 1, 50, 30, function(v) S.AimbotSmooth = v / 100 end)
end

Pages["视觉"] = function()
    Toggle("人物高亮", S.ESP, function(v) S.ESP = v end)
end

Pages["服务器选择"] = function()
    Action("进入【犯规球场】", function()
        if not Categories["球场"] then AddCategory("球场", 5) end
        for n, d in pairs(Categories) do
            if n == "球场" then d.Btn.BackgroundColor3 = C.Blue; d.Ind.Visible = true
            else d.Btn.BackgroundColor3 = C.Off; d.Ind.Visible = false end
        end
        ClearParams()
        Toggle("球场透视", S.ESP, function(v) S.ESP = v end)
    end)
    Action("进入【奇异赛跑】", function()
        if not Categories["赛跑"] then AddCategory("赛跑", 6) end
        for n, d in pairs(Categories) do
            if n == "赛跑" then d.Btn.BackgroundColor3 = C.Blue; d.Ind.Visible = true
            else d.Btn.BackgroundColor3 = C.Off; d.Ind.Visible = false end
        end
        ClearParams()
        Toggle("赛跑透视", S.ESP, function(v) S.ESP = v end)
        Toggle("马匹加速", S.HorseSpeed, function(v) S.HorseSpeed = v end)
        Slider("推力", 50, 1000, S.HorseSpeedVal, function(v) S.HorseSpeedVal = v end)
    end)
end

AddCategory("移动", 1)
AddCategory("战斗", 2)
AddCategory("视觉", 3)
AddCategory("服务器选择", 4)

Categories["移动"].Btn.BackgroundColor3 = C.Blue
Categories["移动"].Ind.Visible = true
Pages["移动"]()

task.spawn(function()
    while task.wait(0.1) do
        if not SG.Parent then break end
        if S.Aimbot and hum and hrp and hum.Health > 0 then
            local shortest = S.AimbotFOV
            local ctr = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
            local best = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character.Parent and not IsTeammate(p) then
                    local tHead = p.Character:FindFirstChild("Head")
                    if tHead and tHead:IsA("BasePart") then
                        local sp = Cam:WorldToViewportPoint(tHead.Position)
                        if sp.Z > 0 then
                            local dst = (Vector2.new(sp.X, sp.Y) - ctr).Magnitude
                            if dst < shortest then shortest = dst; best = tHead end
                        end
                    end
                end
            end
            targetPart = best
        else
            targetPart = nil
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local char = p.Character
                local hl = char:FindFirstChild("NavESP")
                if S.ESP then
                    if not hl then
                        hl = Instance.new("Highlight", char)
                        hl.Name = "NavESP"
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    hl.FillColor = IsTeammate(p) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 70, 70)
                elseif hl then hl:Destroy() end
            end
        end
    end
end)

pcall(function()
    local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and self.Name == "ClientRunner" and S.Aimbot and targetPart and targetPart.Parent then
            local args = {...}
            if typeof(args[1]) == "CFrame" then
                args[1] = CFrame.lookAt(args[1].Position, targetPart.Position)
            end
            if typeof(args[2]) == "Vector3" then
                args[2] = targetPart.Position
            end
            return oldNamecall(self, args[1], args[2], args[3], args[4], args[5])
        end
        return oldNamecall(self, ...)
    end)
end)

RS.Heartbeat:Connect(function()
    if S.Wall and LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end
end)

RS:BindToRenderStep("ForceAimbot", Enum.RenderPriority.Camera.Value + 1, function(dt)
    if not hum or not hrp or hum.Health <= 0 then return end

    if S.Speed and not S.Fly then hum.WalkSpeed = S.WalkSpeed elseif not S.Fly then hum.WalkSpeed = 16 end

    if S.Fly then
        hum.PlatformStand = true
        if not bv or not bv.Parent then
            bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
            bg = Instance.new("BodyGyro", hrp)
            bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        end
        if hum.MoveDirection.Magnitude > 0 then bv.Velocity = Cam.CFrame.LookVector * S.FlySpeed
        else bv.Velocity = Vector3.zero end
        bg.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + Cam.CFrame.LookVector)
    else
        hum.PlatformStand = false
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
    end

    if S.Aimbot and targetPart and targetPart.Parent then
        local currentCF = Cam.CFrame
        if S.AimbotSmooth >= 0.99 then
            Cam.CFrame = CFrame.lookAt(currentCF.Position, targetPart.Position)
        else
            local targetCF = CFrame.lookAt(currentCF.Position, targetPart.Position)
            Cam.CFrame = currentCF:Lerp(targetCF, S.AimbotSmooth)
        end
    end
end)

local dragging = false
local dragStart, startPos
HeaderTitle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
