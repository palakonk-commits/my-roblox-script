local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- ตัวแปรหลัก
local normalSpeed = 16
local currentSpeed = normalSpeed
local speedEnabled = false
local noclipEnabled = false
local espEnabled = false
local aimbotEnabled = false
local aimbotFOV = 200
local aimbotSmooth = 8
local invisibleEnabled = false
local bringEnabled = false
local wallbangEnabled = false
local isCollapsed = false

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ThaiExploitPremium"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Intro overlay
local function playIntro()
    local introFrame = Instance.new("Frame")
    introFrame.Size = UDim2.fromScale(1, 1)
    introFrame.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
    introFrame.BorderSizePixel = 0
    introFrame.ZIndex = 100
    introFrame.Parent = screenGui

    local introGradient = Instance.new("UIGradient")
    introGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 32, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 12, 24))
    }
    introGradient.Rotation = 120
    introGradient.Parent = introFrame

    local introTitle = Instance.new("TextLabel")
    introTitle.Size = UDim2.new(1, 0, 0, 40)
    introTitle.Position = UDim2.new(0, 0, 0.4, -20)
    introTitle.BackgroundTransparency = 1
    introTitle.Text = "ยินดีต้อนรับสู่ Thai Exploit Premium"
    introTitle.TextColor3 = Color3.fromRGB(170, 230, 255)
    introTitle.TextTransparency = 1
    introTitle.TextSize = 22
    introTitle.Font = Enum.Font.GothamBold
    introTitle.ZIndex = 101
    introTitle.Parent = introFrame

    local introSubtitle = Instance.new("TextLabel")
    introSubtitle.Size = UDim2.new(1, 0, 0, 22)
    introSubtitle.Position = UDim2.new(0, 0, 0.4, 20)
    introSubtitle.BackgroundTransparency = 1
    introSubtitle.Text = "กำลังเตรียม UI และฟังก์ชัน..."
    introSubtitle.TextColor3 = Color3.fromRGB(180, 200, 220)
    introSubtitle.TextTransparency = 1
    introSubtitle.TextSize = 16
    introSubtitle.Font = Enum.Font.Gotham
    introSubtitle.ZIndex = 101
    introSubtitle.Parent = introFrame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 320, 0, 8)
    bar.Position = UDim2.new(0.5, -160, 0.55, -4)
    bar.BackgroundColor3 = Color3.fromRGB(35, 70, 120)
    bar.BackgroundTransparency = 0.5
    bar.BorderSizePixel = 0
    bar.ZIndex = 101
    bar.Parent = introFrame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    fill.BackgroundTransparency = 0.1
    fill.BorderSizePixel = 0
    fill.ZIndex = 102
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local function tween(obj, props, time)
        TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quint), props):Play()
    end

    tween(introTitle, {TextTransparency = 0}, 0.3)
    tween(introSubtitle, {TextTransparency = 0}, 0.35)
    tween(fill, {Size = UDim2.new(1, 0, 1, 0)}, 1.05)

    task.spawn(function()
        task.wait(1.2)
        tween(introTitle, {TextTransparency = 1}, 0.35)
        tween(introSubtitle, {TextTransparency = 1}, 0.35)
        tween(bar, {BackgroundTransparency = 1}, 0.35)
        tween(fill, {BackgroundTransparency = 1}, 0.35)
        tween(introFrame, {BackgroundTransparency = 1}, 0.45)
        task.wait(0.5)
        introFrame:Destroy()
    end)
end

playIntro()

-- Tween Helper (ประกาศหลัง intro เพราะใน intro ใช้ local tween ชั่วคราว)
local function tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quint), props):Play()
end

-- Main Frame ขนาดใหญ่แนวตั้ง (แก้ UI เพี้ยน)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0, 20, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

local border = Instance.new("UIStroke")
border.Thickness = 2
border.Parent = mainFrame
task.spawn(function()
    local h = 0
    while task.wait(0.03) do
        h = (h + 1) % 360
        border.Color = Color3.fromHSV(h / 360, 1, 1)
    end
end)

-- Header
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 60)
headerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = headerFrame

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0, 5)
logo.BackgroundTransparency = 1
logo.Text = "🇹🇭"
logo.TextSize = 35
logo.Font = Enum.Font.GothamBold
logo.Parent = headerFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 65, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Thai Exploit"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = headerFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0, 200, 0, 20)
subtitle.Position = UDim2.new(0, 65, 0, 35)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Premium v2.5 - 2026"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 180)
subtitle.TextSize = 11
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = headerFrame

-- Collapse / Close Buttons
local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 35, 0, 35)
collapseButton.Position = UDim2.new(1, -85, 0, 12.5)
collapseButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
collapseButton.Text = "◀"
collapseButton.TextColor3 = Color3.new(1,1,1)
collapseButton.TextSize = 18
collapseButton.Font = Enum.Font.GothamBold
collapseButton.Parent = headerFrame

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 8)
collapseCorner.Parent = collapseButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0, 12.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Content ScrollingFrame (แนวตั้ง เรียบร้อย)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -80)
contentFrame.Position = UDim2.new(0, 10, 0, 70)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 6
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 12)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentFrame

-- สร้างปุ่ม (แก้ให้เรียงแนวตั้งสวยงาม)
local function createButton(name, icon)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    frame.Parent = contentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1
    stroke.Parent = frame

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 50, 0, 50)
    iconLabel.Position = UDim2.new(0, 15, 0.5, -25)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 36
    iconLabel.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 200, 0, 30)
    textLabel.Position = UDim2.new(0, 75, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    textLabel.TextSize = 16
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 200, 0, 20)
    statusLabel.Position = UDim2.new(0, 75, 0, 38)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "ปิดอยู่"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = frame

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 60, 0, 34)
    switch.Position = UDim2.new(1, -80, 0.5, -17)
    switch.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    switch.Parent = frame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 26, 0, 26)
    knob.Position = UDim2.new(0, 4, 0.5, -13)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    knob.Parent = switch

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = frame

    local active = false
    local function toggle(state)
        active = state ~= nil and state or not active
        if active then
            tween(knob, {Position = UDim2.new(1, -30, 0.5, -13)}, 0.3)
            tween(switch, {BackgroundColor3 = Color3.fromRGB(0, 255, 150)}, 0.3)
            tween(stroke, {Color = Color3.fromRGB(0, 255, 150)}, 0.3)
            statusLabel.Text = "เปิดอยู่"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        else
            tween(knob, {Position = UDim2.new(0, 4, 0.5, -13)}, 0.3)
            tween(switch, {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}, 0.3)
            tween(stroke, {Color = Color3.fromRGB(60, 60, 80)}, 0.3)
            statusLabel.Text = "ปิดอยู่"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end

    button.MouseEnter:Connect(function() tween(frame, {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}, 0.2) end)
    button.MouseLeave:Connect(function() if not active then tween(frame, {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}, 0.2) end end)

    return {button = button, toggle = toggle, status = statusLabel}
end

local noclipBtn = createButton("Noclip", "🧱")
local espBtn = createButton("ESP", "👁️")
local aimbotBtn = createButton("Aimbot (Head Only)", "🎯")
local speedBtn = createButton("Speed", "⚡")
local invisibleBtn = createButton("ล่องหน (Invisible)", "👻")
local bringBtn = createButton("ดึงผู้เล่นมาหา (Bring)", "🧲")
local killAllBtn = createButton("Kill All", "💀")
local wallbangBtn = createButton("ยิงทะลุ (Wallbang)", "🔫")
local teleportBtn = createButton("Teleport", "🌀")

-- Info Labels (วางใต้ปุ่มทั้งหมด)
local infoSeparator = Instance.new("Frame")
infoSeparator.Size = UDim2.new(1, -40, 0, 2)
infoSeparator.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
infoSeparator.BorderSizePixel = 0
infoSeparator.Parent = contentFrame

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -40, 0, 30)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "🎯 เป้าหมาย: ไม่มี"
targetLabel.TextColor3 = Color3.fromRGB(200,200,220)
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = contentFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -40, 0, 30)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ ความเร็ว: 16"
speedLabel.TextColor3 = Color3.fromRGB(200,200,220)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = contentFrame

local playersLabel = Instance.new("TextLabel")
playersLabel.Size = UDim2.new(1, -40, 0, 30)
playersLabel.BackgroundTransparency = 1
playersLabel.Text = "👥 ผู้เล่น: " .. #Players:GetPlayers()
playersLabel.TextColor3 = Color3.fromRGB(200,200,220)
playersLabel.Font = Enum.Font.Gotham
playersLabel.Parent = contentFrame

task.spawn(function()
    while task.wait(2) do
        playersLabel.Text = "👥 ผู้เล่น: " .. #Players:GetPlayers()
    end
end)

-- Mini Icon
local miniIcon = Instance.new("Frame")
miniIcon.Size = UDim2.new(0, 60, 0, 60)
miniIcon.Position = UDim2.new(0, 20, 0.5, -30)
miniIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
miniIcon.Visible = false
miniIcon.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 15)
miniCorner.Parent = miniIcon

local miniBorder = Instance.new("UIStroke")
miniBorder.Thickness = 2
miniBorder.Parent = miniIcon

local miniLogo = Instance.new("TextLabel")
miniLogo.Size = UDim2.new(1,0,1,0)
miniLogo.BackgroundTransparency = 1
miniLogo.Text = "🇹🇭"
miniLogo.TextSize = 35
miniLogo.Font = Enum.Font.GothamBold
miniLogo.Parent = miniIcon

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(1,0,1,0)
miniBtn.BackgroundTransparency = 1
miniBtn.Parent = miniIcon

-- Collapse Logic
local function toggleCollapse()
    isCollapsed = not isCollapsed
    if isCollapsed then
        collapseButton.Text = "▶"
        tween(mainFrame, {Position = UDim2.new(0, -450, 0.5, -300)}, 0.4)
        task.wait(0.4)
        mainFrame.Visible = false
        miniIcon.Visible = true
    else
        collapseButton.Text = "◀"
        miniIcon.Visible = false
        mainFrame.Visible = true
        tween(mainFrame, {Position = UDim2.new(0, 20, 0.5, -300)}, 0.4)
    end
end

collapseButton.MouseButton1Click:Connect(toggleCollapse)
miniBtn.MouseButton1Click:Connect(toggleCollapse)
closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then toggleCollapse() end
end)

-- ฟังก์ชันต่าง ๆ (เหมือนเดิม)
local noclipConn
noclipBtn.button.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.toggle(noclipEnabled)
    if noclipEnabled then
        noclipConn = RunService.Heartbeat:Connect(function()
            if player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
    end
end)

local highlights = {}
local function updateESP()
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and not highlights[p] then
                local hl = Instance.new("Highlight")
                hl.FillColor = Color3.fromRGB(255,0,0)
                hl.OutlineColor = Color3.fromRGB(255,255,0)
                hl.FillTransparency = 0.5
                hl.Parent = p.Character
                highlights[p] = hl
            end
        end
    else
        for _, hl in pairs(highlights) do if hl then hl:Destroy() end end
        highlights = {}
    end
end
espBtn.button.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.toggle(espEnabled)
    updateESP()
end)
Players.PlayerAdded:Connect(function(p)
    if espEnabled then
        p.CharacterAdded:Connect(function()
            task.wait(0.5)
            updateESP()
        end)
    end
end)

local fovCircle = Drawing.new("Circle")
fovCircle.Radius = aimbotFOV
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(0,255,150)
fovCircle.Transparency = 0.6
fovCircle.Visible = false

local function getClosestHead()
    local closest = nil
    local shortest = aimbotFOV
    local mPos = Vector2.new(mouse.X, mouse.Y + 36)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local head = p.Character.Head
            local pos, visible = Camera:WorldToViewportPoint(head.Position)
            if visible then
                local dist = (Vector2.new(pos.X, pos.Y) - mPos).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

aimbotBtn.button.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotBtn.toggle(aimbotEnabled)
    fovCircle.Visible = aimbotEnabled
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
        local targetHead = getClosestHead()
        if targetHead then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHead.Position), 1 / aimbotSmooth)
            targetLabel.Text = "🎯 ล็อกหัว: " .. targetHead.Parent.Name
            targetLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        else
            targetLabel.Text = "🎯 เป้าหมาย: ไม่มี"
            targetLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)

speedBtn.button.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedBtn.toggle(speedEnabled)
    currentSpeed = speedEnabled and 100 or normalSpeed
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = currentSpeed
        speedLabel.Text = "⚡ ความเร็ว: " .. currentSpeed
    end
end)

invisibleBtn.button.MouseButton1Click:Connect(function()
    invisibleEnabled = not invisibleEnabled
    invisibleBtn.toggle(invisibleEnabled)
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = invisibleEnabled and 1 or 0
            end
        end
        if player.Character:FindFirstChild("Head") then
            local nameTag = player.Character.Head:FindFirstChildWhichIsA("BillboardGui")
            if nameTag then nameTag.Enabled = not invisibleEnabled end
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if invisibleEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then part.Transparency = 1 end
        end
        if char:FindFirstChild("Head") then
            local nameTag = char.Head:FindFirstChildWhichIsA("BillboardGui")
            if nameTag then nameTag.Enabled = false end
        end
    end
    if speedEnabled then
        char:WaitForChild("Humanoid").WalkSpeed = currentSpeed
    end
    if noclipEnabled then
        if noclipConn then noclipConn:Disconnect() end
        task.wait(0.2)
        noclipEnabled = true
        noclipBtn.toggle(true)
        noclipConn = RunService.Heartbeat:Connect(function()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    end
end)

bringBtn.button.MouseButton1Click:Connect(function()
    bringEnabled = not bringEnabled
    bringBtn.toggle(bringEnabled)
end)

RunService.Heartbeat:Connect(function()
    if bringEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = player.Character.HumanoidRootPart.Position
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = CFrame.new(myPos + Vector3.new(math.random(-5,5), 0, math.random(-5,5)))
            end
        end
    end
end)

killAllBtn.button.MouseButton1Click:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
    killAllBtn.status.Text = "ฆ่าทุกคนแล้ว!"
    task.wait(1.5)
    killAllBtn.status.Text = "ปิดอยู่"
    killAllBtn.status.TextColor3 = Color3.fromRGB(255, 100, 100)
end)

wallbangBtn.button.MouseButton1Click:Connect(function()
    wallbangEnabled = not wallbangEnabled
    wallbangBtn.toggle(wallbangEnabled)
end)

RunService.Heartbeat:Connect(function()
    if wallbangEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Material == Enum.Material.Concrete or obj.Material == Enum.Material.Brick or obj.Material == Enum.Material.Wood or obj.Material == Enum.Material.Metal) and obj.CanCollide then
                obj.CanCollide = false
            end
        end
    end
end)

-- Teleport Menu (เหมือนเดิม)
local tpMenu = Instance.new("Frame")
tpMenu.Size = UDim2.new(0, 250, 0, 300)
tpMenu.Position = UDim2.new(0.5, -125, 0.5, -150)
tpMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
tpMenu.Visible = false
tpMenu.Parent = screenGui

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 15)
tpCorner.Parent = tpMenu

local tpTitle = Instance.new("TextLabel")
tpTitle.Size = UDim2.new(1,0,0,40)
tpTitle.BackgroundColor3 = Color3.fromRGB(25,25,40)
tpTitle.Text = "🌀 เลือกผู้เล่น"
tpTitle.TextColor3 = Color3.fromRGB(0,255,150)
tpTitle.Font = Enum.Font.GothamBold
tpTitle.Parent = tpMenu

local tpScroll = Instance.new("ScrollingFrame")
tpScroll.Size = UDim2.new(1,-20,1,-60)
tpScroll.Position = UDim2.new(0,10,0,50)
tpScroll.BackgroundTransparency = 1
tpScroll.ScrollBarThickness = 6
tpScroll.Parent = tpMenu

local function refreshTP()
    for _, c in pairs(tpScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local y = 5
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            count = count + 1
            local dist = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and math.floor((player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) or 0
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-10,0,40)
            btn.Position = UDim2.new(0,5,0,y)
            btn.BackgroundColor3 = Color3.fromRGB(35,35,50)
            btn.Text = p.Name .. " (" .. dist .. "m)"
            btn.TextColor3 = Color3.fromRGB(200,200,220)
            btn.Font = Enum.Font.Gotham
            btn.Parent = tpScroll
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0,8)
            bc.Parent = btn
            btn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 3)
                end
            end)
            y = y + 45
        end
    end
    tpScroll.CanvasSize = UDim2.new(0,0,0,y)
    tpTitle.Text = "🌀 ผู้เล่น (" .. count .. ")"
end

teleportBtn.button.MouseButton1Click:Connect(function()
    tpMenu.Visible = not tpMenu.Visible
    teleportBtn.toggle(tpMenu.Visible)
    if tpMenu.Visible then refreshTP() end
end)

task.spawn(function()
    while task.wait(2) do
        if tpMenu.Visible then refreshTP() end
    end
end)

-- Notification
local function notify(text, dur)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0,300,0,60)
    n.Position = UDim2.new(0.5,-150,0,-70)
    n.BackgroundColor3 = Color3.fromRGB(30,30,45)
    n.Parent = screenGui
    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0,12)
    nc.Parent = n
    local ns = Instance.new("UIStroke")
    ns.Color = Color3.fromRGB(0,255,150)
    ns.Thickness = 2
    ns.Parent = n
    local nt = Instance.new("TextLabel")
    nt.Size = UDim2.new(1,-20,1,0)
    nt.Position = UDim2.new(0,10,0,0)
    nt.BackgroundTransparency = 1
    nt.Text = text
    nt.TextColor3 = Color3.new(1,1,1)
    nt.TextSize = 14
    nt.Font = Enum.Font.GothamBold
    nt.TextWrapped = true
    nt.Parent = n
    tween(n, {Position = UDim2.new(0.5,-150,0,20)}, 0.5)
    task.wait(dur or 3)
    tween(n, {Position = UDim2.new(0.5,-150,0,-70)}, 0.5)
    task.wait(0.5)
    n:Destroy()
end

notify("🇹🇭 Thai Exploit Premium v2.5 โหลดสำเร็จ!\nUI ใหม่สวยงาม เรียบร้อย\nกด F เพื่อพับ/กางเมนู", 6)

print("🇹🇭 Thai Exploit Premium v2.5 (Fixed UI) - โหลดสำเร็จ 100% (01 ม.ค. 2026)")
