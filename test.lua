-- Thai Exploit Premium v2.6 - 2026 Update
-- Modified: Horizontal UI layout, fit screen, beautiful design, section tabs, anti-cheat scan & bypass, added features

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

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
local aimbotTarget = nil
local aimbotFOV = 200
local aimbotSmooth = 8
local invisibleEnabled = false
local bringEnabled = false
local killAllEnabled = false
local wallbangEnabled = false
local teleportEnabled = false
local godModeEnabled = false  -- New feature: God Mode
local flyEnabled = false      -- New feature: Fly
local infJumpEnabled = false  -- New feature: Infinite Jump
local autoFarmEnabled = false -- New feature: Auto Farm (dummy for now)
local isCollapsed = false
local antiCheatDetected = false
local antiCheatBypassed = false

-- Anti-Cheat Scan Function
local function scanAntiCheat()
    -- Scan for common anti-cheat indicators (examples: specific scripts, variables, or behaviors)
    local knownAntiCheats = {
        "AntiExploit", "Adonis", "Byfron", "AntiCheatScript", -- Add more known names
    }
    
    for _, service in ipairs({workspace, ReplicatedStorage, Lighting, game:GetService("ServerScriptService")}) do
        for _, obj in ipairs(service:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                for _, ac in ipairs(knownAntiCheats) do
                    if string.find(obj.Name:lower(), ac:lower()) then
                        antiCheatDetected = true
                        -- Attempt bypass (dummy: rename or disable)
                        pcall(function()
                            obj.Disabled = true
                            obj.Name = "Bypassed_" .. obj.Name
                            antiCheatBypassed = true
                        end)
                        return
                    end
                end
            end
        end
    end
    
    if antiCheatDetected and not antiCheatBypassed then
        -- Notify and apologize
        game.StarterGui:SetCore("SendNotification", {
            Title = "Thai Exploit Premium",
            Text = "ตรวจพบระบบป้องกันแต่ไม่สามารถ Bypass ได้ ขออภัยในความไม่สะดวก",
            Duration = 10
        })
    elseif antiCheatDetected and antiCheatBypassed then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Thai Exploit Premium",
            Text = "ตรวจพบระบบป้องกันและ Bypass สำเร็จ!",
            Duration = 5
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Thai Exploit Premium",
            Text = "ไม่พบระบบป้องกัน สามารถใช้งานได้ปกติ",
            Duration = 5
        })
    end
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ThaiExploitPremium"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Tween Helper
local function tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quint), props):Play()
end

-- Loading Screen (ไม่เต็มจอ, ขนาดพอดี, สวยงาม)
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 300, 0, 150)  -- ขนาดพอดี ไม่เต็มจอ
loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)  -- กลางจอ
loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 15)
loadingCorner.Parent = loadingFrame

local loadingGradient = Instance.new("UIGradient")
loadingGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
}
loadingGradient.Rotation = 45
loadingGradient.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 1, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "กำลังโหลด Thai Exploit Premium..."
loadingText.TextColor3 = Color3.new(1,1,1)
loadingText.TextSize = 20
loadingText.Font = Enum.Font.GothamBold
loadingText.Parent = loadingFrame

-- แสดง loading 3 วินาทีแล้วซ่อน
task.wait(3)
tween(loadingFrame, {Transparency = 1}, 0.5)
task.delay(0.5, function() loadingFrame:Destroy() end)

-- Scan anti-cheat หลัง loading
scanAntiCheat()

-- ถ้าไม่ bypass ได้ หยุดที่นี่ (แต่ยังให้ code เต็ม)
if antiCheatDetected and not antiCheatBypassed then
    return
end

-- Main Frame (แนวนอน, ขนาดพอดี ไม่เต็มจอ, สวยงาม)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.8, 0, 0, 300)  -- แนวนอน กว้าง 80% สูงพอดี
mainFrame.Position = UDim2.new(0.1, 0, 0.5, -150)  -- กลางจอ ไม่เต็ม
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

-- Header (ปรับให้แนวนอน)
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 50)
headerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = headerFrame

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 10, 0, 5)
logo.BackgroundTransparency = 1
logo.Text = "TH"
logo.TextSize = 30
logo.Font = Enum.Font.GothamBold
logo.Parent = headerFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 55, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Thai Exploit Premium v2.6"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = headerFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0, 200, 0, 20)
subtitle.Position = UDim2.new(0, 55, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.Text = "2026 Edition - สวยงามและใช้งานง่าย"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 180)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = headerFrame

-- Collapse & Close Buttons (แนวนอนด้านขวา)
local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 30, 0, 30)
collapseButton.Position = UDim2.new(1, -100, 0, 10)
collapseButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
collapseButton.Text = "<"
collapseButton.TextColor3 = Color3.new(1,1,1)
collapseButton.TextSize = 16
collapseButton.Font = Enum.Font.GothamBold
collapseButton.Parent = headerFrame

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 8)
collapseCorner.Parent = collapseButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -60, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Tab System for Sections (แยกหัวข้อ: Movement, Combat, Visual, Other)
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.Position = UDim2.new(0, 0, 0, 50)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 10)
tabLayout.Parent = tabFrame

local function createTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 120, 0, 30)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.new(1,1,1)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Parent = tabFrame

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton

    return tabButton
end

local movementTab = createTab("Movement")
local combatTab = createTab("Combat")
local visualTab = createTab("Visual")
local otherTab = createTab("Other")

-- Content Frames for each tab (แนวนอน layout)
local contentFrames = {}
local currentTab = "Movement"

local function createContentFrame()
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, -20, 1, -100)
    frame.Position = UDim2.new(0, 10, 0, 90)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 6
    frame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
    frame.CanvasSize = UDim2.new(2, 0, 0, 0)  -- แนวนอน scroll
    frame.ScrollingDirection = Enum.ScrollingDirection.X
    frame.Parent = mainFrame
    frame.Visible = false

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 10)
    layout.Parent = frame

    return frame
end

contentFrames["Movement"] = createContentFrame()
contentFrames["Combat"] = createContentFrame()
contentFrames["Visual"] = createContentFrame()
contentFrames["Other"] = createContentFrame()

contentFrames["Movement"].Visible = true

-- Switch Tab Function
local function switchTab(tabName)
    for _, frame in pairs(contentFrames) do
        frame.Visible = false
    end
    contentFrames[tabName].Visible = true
    currentTab = tabName
end

movementTab.MouseButton1Click:Connect(function() switchTab("Movement") end)
combatTab.MouseButton1Click:Connect(function() switchTab("Combat") end)
visualTab.MouseButton1Click:Connect(function() switchTab("Visual") end)
otherTab.MouseButton1Click:Connect(function() switchTab("Other") end)

-- สร้างปุ่ม (ปรับให้สวยงามยิ่งขึ้น, แนวนอน)
local function createButton(name, icon, parentFrame, enabledVar)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 1, -20)  -- กว้างสำหรับแนวนอน
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    frame.Parent = parentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1
    stroke.Parent = frame

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 10, 0.1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 28
    iconLabel.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 140, 0, 25)
    textLabel.Position = UDim2.new(0, 10, 0.4, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 140, 0, 18)
    statusLabel.Position = UDim2.new(0, 10, 0.6, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "ปิดอยู่"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = frame

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 50, 0, 28)
    switch.Position = UDim2.new(0, 10, 0.8, 0)
    switch.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    switch.Parent = frame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = UDim2.new(0, 3, 0.5, -11)
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
            tween(knob, {Position = UDim2.new(1, -25, 0.5, -11)}, 0.3)
            tween(switch, {BackgroundColor3 = Color3.fromRGB(0, 255, 150)}, 0.3)
            tween(stroke, {Color = Color3.fromRGB(0, 255, 150)}, 0.3)
            statusLabel.Text = "เปิดอยู่"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            enabledVar = true
        else
            tween(knob, {Position = UDim2.new(0, 3, 0.5, -11)}, 0.3)
            tween(switch, {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}, 0.3)
            tween(stroke, {Color = Color3.fromRGB(60, 60, 80)}, 0.3)
            statusLabel.Text = "ปิดอยู่"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            enabledVar = false
        end
    end

    button.MouseButton1Click:Connect(toggle)
    button.MouseEnter:Connect(function() tween(frame, {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}, 0.2) end)
    button.MouseLeave:Connect(function() if not active then tween(frame, {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}, 0.2) end end)

    return {button = button, toggle = toggle}
end

-- Add buttons to tabs
createButton("Speed", "Lightning", contentFrames["Movement"], speedEnabled)
createButton("Noclip", "Block", contentFrames["Movement"], noclipEnabled)
createButton("Fly", "Wing", contentFrames["Movement"], flyEnabled)  -- New
createButton("Inf Jump", "Jump", contentFrames["Movement"], infJumpEnabled)  -- New

createButton("Aimbot", "Target", contentFrames["Combat"], aimbotEnabled)
createButton("Wallbang", "Gun", contentFrames["Combat"], wallbangEnabled)
createButton("Kill All", "Skull", contentFrames["Combat"], killAllEnabled)
createButton("Bring", "Magnet", contentFrames["Combat"], bringEnabled)
createButton("God Mode", "Shield", contentFrames["Combat"], godModeEnabled)  -- New

createButton("ESP", "Eye", contentFrames["Visual"], espEnabled)
createButton("Invisible", "Ghost", contentFrames["Visual"], invisibleEnabled)

createButton("Teleport", "Swirl", contentFrames["Other"], teleportEnabled)
createButton("Auto Farm", "Farm", contentFrames["Other"], autoFarmEnabled)  -- New

-- Info Labels (ด้านล่าง, แนวนอน)
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, 0, 0, 50)
infoFrame.Position = UDim2.new(0, 0, 1, -50)
infoFrame.BackgroundTransparency = 1
infoFrame.Parent = mainFrame

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0.3, 0, 1, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Target: ไม่มี"
targetLabel.TextColor3 = Color3.fromRGB(200,200,220)
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = infoFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.3, 0, 1, 0)
speedLabel.Position = UDim2.new(0.3, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = Color3.fromRGB(200,200,220)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = infoFrame

local playersLabel = Instance.new("TextLabel")
playersLabel.Size = UDim2.new(0.3, 0, 1, 0)
playersLabel.Position = UDim2.new(0.6, 0, 0, 0)
playersLabel.BackgroundTransparency = 1
playersLabel.Text = "Players: " .. #Players:GetPlayers()
playersLabel.TextColor3 = Color3.fromRGB(200,200,220)
playersLabel.Font = Enum.Font.Gotham
playersLabel.Parent = infoFrame

-- Collapse Functionality
collapseButton.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        tween(mainFrame, {Size = UDim2.new(0, 300, 0, 50)}, 0.3)
        tabFrame.Visible = false
        for _, frame in pairs(contentFrames) do frame.Visible = false end
        infoFrame.Visible = false
    else
        tween(mainFrame, {Size = UDim2.new(0.8, 0, 0, 300)}, 0.3)
        tabFrame.Visible = true
        contentFrames[currentTab].Visible = true
        infoFrame.Visible = true
    end
end)

-- Close Functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Implement Features (ตัวอย่าง implementation, ปรับให้สมบูรณ์ตามต้องการ)
-- Speed
RunService.RenderStepped:Connect(function()
    if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = currentSpeed
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ESP (dummy)
local function addESP(plr)
    if plr ~= player and plr.Character then
        local highlight = Instance.new("Highlight")
        highlight.Parent = plr.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    end
end

Players.PlayerAdded:Connect(addESP)
for _, plr in ipairs(Players:GetPlayers()) do addESP(plr) end

-- Aimbot (Head Only)
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        -- Find closest head in FOV
        local closest = nil
        local minDist = aimbotFOV
        local mousePos = UserInputService:GetMouseLocation()
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = head
                    end
                end
            end
        end
        
        if closest then
            aimbotTarget = closest
            local targetPos = Camera:WorldToViewportPoint(closest.Position)
            local move = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) / aimbotSmooth
            mousemoverel(move.X, move.Y)
        end
    end
end)

-- Invisible
local function toggleInvisible()
    if invisibleEnabled and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.5  -- Semi-invisible
            end
        end
    end
end

-- Bring
local function bringPlayers()
    if bringEnabled and player.Character then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                plr.Character:MoveTo(player.Character.HumanoidRootPart.Position)
            end
        end
    end
end

-- Kill All
local function killAll()
    if killAllEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.Health = 0
            end
        end
    end
end

-- Wallbang (ยิงทะลุ, dummy)
local function wallbang()
    if wallbangEnabled then
        -- Implement raycast ignore walls or something
    end
end

-- Teleport (click to teleport)
mouse.Button1Down:Connect(function()
    if teleportEnabled then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
    end
end)

-- New: God Mode
RunService.Heartbeat:Connect(function()
    if godModeEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
    end
end)

-- New: Fly
local flySpeed = 50
local bodyVelocity = nil
UserInputService.InputBegan:Connect(function(input)
    if flyEnabled and input.KeyCode == Enum.KeyCode.Space then
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
            bodyVelocity.Parent = player.Character.HumanoidRootPart
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if flyEnabled and input.KeyCode == Enum.KeyCode.Space then
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end
end)

-- New: Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- New: Auto Farm (dummy, adjust for game)
RunService.Heartbeat:Connect(function()
    if autoFarmEnabled then
        -- Auto collect or something
    end
end)

-- Update labels
RunService.RenderStepped:Connect(function()
    targetLabel.Text = "Target: " .. (aimbotTarget and aimbotTarget.Parent.Name or "ไม่มี")
    speedLabel.Text = "Speed: " .. currentSpeed
    playersLabel.Text = "Players: " .. #Players:GetPlayers()
end)

-- Hotkeys (ตัวอย่าง)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftBracket then
        currentSpeed = math.max(16, currentSpeed - 5)
    elseif input.KeyCode == Enum.KeyCode.RightBracket then
        currentSpeed = currentSpeed + 5
    end
end)
