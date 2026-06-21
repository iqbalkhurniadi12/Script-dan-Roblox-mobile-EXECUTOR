--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║           🃏 FIKZXX TROLL - 30 FITUR 🃏                    ║
    ║                                                              ║
    ║        Premium Troll Script for Mobile Roblox              ║
    ║                    Version 3.0.0                            ║
    ║                                                              ║
    ║              🔐 Password: FikzxTeam                         ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
    
    📌 FITUR:
    1.  Fly Mode
    2.  Speed Boost
    3.  Invisible
    4.  Walk on Water
    5.  No Clip
    6.  Super Jump
    7.  Freeze Player
    8.  Ragdoll
    9.  Dance All
    10. Spin Character
    11. Explode Nearby
    12. Clone Yourself
    13. Giant Mode
    14. Tiny Mode
    15. Floating Text
    16. Rainbow Color
    17. Fire Effect
    18. Smoke Effect
    19. Sparkle Trail
    20. Force Sit
    21. Force Dance
    22. Spam Chat
    23. Kill All
    24. Heal All
    25. Teleport All
    26. Gravity Flip
    27. Moon Walk
    28. Headless
    29. Invisible Arms
    30. Troll Sound
--]]

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")

-- ============================================================
-- PLAYER & VARIABLES
-- ============================================================
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local TrollState = {
    Fly = false,
    Speed = false,
    Invisible = false,
    WaterWalk = false,
    NoClip = false,
    SuperJump = false,
    Freeze = false,
    Ragdoll = false,
    Dance = false,
    Spin = false,
    Giant = false,
    Tiny = false,
    Rainbow = false,
    Fire = false,
    Smoke = false,
    Sparkle = false,
    GravityFlip = false,
    MoonWalk = false,
    Headless = false,
    InvisibleArms = false,
}

local TrollConnections = {}
local TrollObjects = {}
local gui = nil

-- ============================================================
-- PASSWORD SYSTEM
-- ============================================================
local PASSWORD = "FikzxTeam"

-- ============================================================
-- CREATE GUI
-- ============================================================
local function CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FikzxxTroll"
    screenGui.Parent = Player.PlayerGui
    screenGui.ResetOnSpawn = false
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 100)
    mainFrame.BorderSizePixel = 2
    mainFrame.ClipsDescendants = true
    mainFrame.Position = UDim2.new(0.5, -180, 0.25, -150)
    mainFrame.Size = UDim2.new(0, 360, 0, 300)
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = mainFrame
    title.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    title.BackgroundTransparency = 0.3
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Font = Enum.Font.GothamBold
    title.Text = "🃏 FIKZXX TROLL"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.TextSize = 20
    title.TextWrapped = true
    
    -- Password Input
    local passLabel = Instance.new("TextLabel")
    passLabel.Name = "PassLabel"
    passLabel.Parent = mainFrame
    passLabel.BackgroundTransparency = 1
    passLabel.Position = UDim2.new(0, 10, 0, 45)
    passLabel.Size = UDim2.new(0, 80, 0, 25)
    passLabel.Font = Enum.Font.Gotham
    passLabel.Text = "Password:"
    passLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    passLabel.TextSize = 14
    
    local passBox = Instance.new("TextBox")
    passBox.Name = "PassBox"
    passBox.Parent = mainFrame
    passBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    passBox.BorderColor3 = Color3.fromRGB(255, 0, 100)
    passBox.BorderSizePixel = 1
    passBox.Position = UDim2.new(0, 95, 0, 45)
    passBox.Size = UDim2.new(0, 150, 0, 25)
    passBox.Font = Enum.Font.Gotham
    passBox.PlaceholderText = "Enter Password"
    passBox.Text = ""
    passBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    passBox.TextSize = 14
    
    local passCorner = Instance.new("UICorner")
    passCorner.CornerRadius = UDim.new(0, 5)
    passCorner.Parent = passBox
    
    local unlockBtn = Instance.new("TextButton")
    unlockBtn.Name = "UnlockBtn"
    unlockBtn.Parent = mainFrame
    unlockBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    unlockBtn.BorderSizePixel = 0
    unlockBtn.Position = UDim2.new(0, 250, 0, 45)
    unlockBtn.Size = UDim2.new(0, 100, 0, 25)
    unlockBtn.Font = Enum.Font.GothamBold
    unlockBtn.Text = "UNLOCK"
    unlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    unlockBtn.TextScaled = true
    unlockBtn.TextSize = 12
    
    local unlockCorner = Instance.new("UICorner")
    unlockCorner.CornerRadius = UDim.new(0, 5)
    unlockCorner.Parent = unlockBtn
    
    -- Scroll Frame for buttons
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Parent = mainFrame
    scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    scrollFrame.BackgroundTransparency = 0.3
    scrollFrame.BorderSizePixel = 0
    scrollFrame.Position = UDim2.new(0, 5, 0, 80)
    scrollFrame.Size = UDim2.new(1, -10, 1, -90)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 100)
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 5)
    scrollCorner.Parent = scrollFrame
    
    -- UIListLayout for buttons
    local layout = Instance.new("UIListLayout")
    layout.Name = "Layout"
    layout.Parent = scrollFrame
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    
    -- Function to create toggle button
    local function CreateToggleButton(text, order)
        local btn = Instance.new("TextButton")
        btn.Name = "Btn_" .. text:gsub(" ", "_")
        btn.Parent = scrollFrame
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        btn.BorderColor3 = Color3.fromRGB(255, 0, 100)
        btn.BorderSizePixel = 1
        btn.Size = UDim2.new(0.95, 0, 0, 30)
        btn.Font = Enum.Font.GothamBold
        btn.Text = "🔒 " .. text
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextScaled = true
        btn.TextSize = 12
        btn.TextWrapped = true
        btn.LayoutOrder = order
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = btn
        
        return btn
    end
    
    -- Create 30 buttons
    local fiturs = {
        "Fly Mode", "Speed Boost", "Invisible", "Walk on Water",
        "No Clip", "Super Jump", "Freeze Player", "Ragdoll",
        "Dance All", "Spin Character", "Explode Nearby", "Clone Yourself",
        "Giant Mode", "Tiny Mode", "Floating Text", "Rainbow Color",
        "Fire Effect", "Smoke Effect", "Sparkle Trail", "Force Sit",
        "Force Dance", "Spam Chat", "Kill All", "Heal All",
        "Teleport All", "Gravity Flip", "Moon Walk", "Headless",
        "Invisible Arms", "Troll Sound"
    }
    
    local buttons = {}
    for i, name in ipairs(fiturs) do
        local btn = CreateToggleButton(name, i)
        buttons[name] = btn
        btn.MouseButton1Click:Connect(function()
            if not unlocked then return end
            ToggleFitur(name, btn)
        end)
    end
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Parent = mainFrame
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Position = UDim2.new(0.93, -20, 0, 5)
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.TextSize = 14
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        print("[Troll] GUI Closed")
    end)
    
    return {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        Title = title,
        PassBox = passBox,
        UnlockBtn = unlockBtn,
        ScrollFrame = scrollFrame,
        Buttons = buttons,
        CloseBtn = closeBtn,
    }
end

-- ============================================================
-- TROLL FITUR FUNCTIONS
-- ============================================================
local unlocked = false

function ToggleFitur(name, btn)
    local state = not btn:GetAttribute("Active")
    btn:SetAttribute("Active", state)
    
    if state then
        btn.Text = "✅ " .. name
        btn.BackgroundColor3 = Color3.fromRGB(60, 40, 45)
        btn.TextColor3 = Color3.fromRGB(255, 100, 150)
    else
        btn.Text = "🔒 " .. name
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    
    -- Execute fitur
    local fiturMap = {
        ["Fly Mode"] = function() ToggleFly() end,
        ["Speed Boost"] = function() ToggleSpeed() end,
        ["Invisible"] = function() ToggleInvisible() end,
        ["Walk on Water"] = function() ToggleWaterWalk() end,
        ["No Clip"] = function() ToggleNoClip() end,
        ["Super Jump"] = function() ToggleSuperJump() end,
        ["Freeze Player"] = function() ToggleFreeze() end,
        ["Ragdoll"] = function() ToggleRagdoll() end,
        ["Dance All"] = function() ToggleDance() end,
        ["Spin Character"] = function() ToggleSpin() end,
        ["Explode Nearby"] = function() ExplodeNearby() end,
        ["Clone Yourself"] = function() CloneYourself() end,
        ["Giant Mode"] = function() ToggleGiant() end,
        ["Tiny Mode"] = function() ToggleTiny() end,
        ["Floating Text"] = function() FloatingText() end,
        ["Rainbow Color"] = function() ToggleRainbow() end,
        ["Fire Effect"] = function() ToggleFire() end,
        ["Smoke Effect"] = function() ToggleSmoke() end,
        ["Sparkle Trail"] = function() ToggleSparkle() end,
        ["Force Sit"] = function() ForceSit() end,
        ["Force Dance"] = function() ForceDanceAll() end,
        ["Spam Chat"] = function() SpamChat() end,
        ["Kill All"] = function() KillAll() end,
        ["Heal All"] = function() HealAll() end,
        ["Teleport All"] = function() TeleportAll() end,
        ["Gravity Flip"] = function() ToggleGravityFlip() end,
        ["Moon Walk"] = function() ToggleMoonWalk() end,
        ["Headless"] = function() ToggleHeadless() end,
        ["Invisible Arms"] = function() ToggleInvisibleArms() end,
        ["Troll Sound"] = function() PlayTrollSound() end,
    }
    
    if fiturMap[name] then
        fiturMap[name]()
    end
end

-- ============================================================
-- IMPLEMENTASI FITUR (30 Fitur)
-- ============================================================

-- 1. Fly Mode
function ToggleFly()
    TrollState.Fly = not TrollState.Fly
    if TrollState.Fly then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1,1,1) * 100000
        bv.Parent = RootPart
        table.insert(TrollObjects, bv)
        
        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1,1,1) * 100000
        bg.Parent = RootPart
        table.insert(TrollObjects, bg)
        
        local conn = RunService.Heartbeat:Connect(function()
            if not TrollState.Fly then return end
            local cam = workspace.CurrentCamera
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then
                bv.Velocity = dir.Unit * 50
                bg.CFrame = CFrame.new(RootPart.Position, RootPart.Position + cam.CFrame.LookVector)
            else
                bv.Velocity = Vector3.new(0,0,0)
            end
        end)
        table.insert(TrollConnections, conn)
    else
        CleanupObjects()
        CleanupConnections()
    end
end

-- 2. Speed Boost
function ToggleSpeed()
    TrollState.Speed = not TrollState.Speed
    if TrollState.Speed then
        Humanoid.WalkSpeed = 100
    else
        Humanoid.WalkSpeed = 16
    end
end

-- 3. Invisible
function ToggleInvisible()
    TrollState.Invisible = not TrollState.Invisible
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = TrollState.Invisible and 1 or 0
        end
    end
end

-- 4. Walk on Water
function ToggleWaterWalk()
    TrollState.WaterWalk = not TrollState.WaterWalk
    if TrollState.WaterWalk then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
    else
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
    end
end

-- 5. No Clip
function ToggleNoClip()
    TrollState.NoClip = not TrollState.NoClip
    if TrollState.NoClip then
        local nc = Instance.new("NoCollisionConstraint")
        nc.Parent = RootPart
        table.insert(TrollObjects, nc)
    else
        CleanupObjects()
    end
end

-- 6. Super Jump
function ToggleSuperJump()
    TrollState.SuperJump = not TrollState.SuperJump
    Humanoid.JumpPower = TrollState.SuperJump and 150 or 50
end

-- 7. Freeze Player
function ToggleFreeze()
    TrollState.Freeze = not TrollState.Freeze
    if TrollState.Freeze then
        Humanoid.WalkSpeed = 0
        Humanoid.JumpPower = 0
    else
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    end
end

-- 8. Ragdoll
function ToggleRagdoll()
    TrollState.Ragdoll = not TrollState.Ragdoll
    if TrollState.Ragdoll then
        Humanoid:BreakJoints()
    end
end

-- 9. Dance All
function ToggleDance()
    TrollState.Dance = not TrollState.Dance
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum then
                if TrollState.Dance then
                    hum:LoadAnimation(Instance.new("Animation"))
                end
            end
        end
    end
end

-- 10. Spin Character
function ToggleSpin()
    TrollState.Spin = not TrollState.Spin
    if TrollState.Spin then
        local conn = RunService.Heartbeat:Connect(function()
            if not TrollState.Spin then return end
            RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, 0.1, 0)
        end)
        table.insert(TrollConnections, conn)
    else
        CleanupConnections()
    end
end

-- 11. Explode Nearby
function ExplodeNearby()
    local explosion = Instance.new("Explosion")
    explosion.BlastRadius = 30
    explosion.BlastPressure = 1000000
    explosion.Position = RootPart.Position
    explosion.Parent = workspace
end

-- 12. Clone Yourself
function CloneYourself()
    for i = 1, 3 do
        local clone = Character:Clone()
        clone.Parent = workspace
        clone:SetPrimaryPartCFrame(RootPart.CFrame + Vector3.new(math.random(-10,10), 0, math.random(-10,10)))
        clone.Name = "Clone_" .. i
    end
end

-- 13. Giant Mode
function ToggleGiant()
    TrollState.Giant = not TrollState.Giant
    local size = TrollState.Giant and 5 or 1
    RootPart.Size = RootPart.Size * size
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and part ~= RootPart then
            part.Size = part.Size * size
        end
    end
end

-- 14. Tiny Mode
function ToggleTiny()
    TrollState.Tiny = not TrollState.Tiny
    local size = TrollState.Tiny and 0.3 or 1
    RootPart.Size = RootPart.Size * size
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and part ~= RootPart then
            part.Size = part.Size * size
        end
    end
end

-- 15. Floating Text
function FloatingText()
    local text = Instance.new("BillboardGui")
    text.Parent = RootPart
    text.Size = UDim2.new(0, 200, 0, 50)
    text.Adornee = RootPart
    
    local label = Instance.new("TextLabel")
    label.Parent = text
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🃏 FIKZXX WAS HERE!"
    label.TextColor3 = Color3.fromRGB(255, 0, 100)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    
    table.insert(TrollObjects, text)
end

-- 16. Rainbow Color
function ToggleRainbow()
    TrollState.Rainbow = not TrollState.Rainbow
    if TrollState.Rainbow then
        local conn = RunService.Heartbeat:Connect(function()
            if not TrollState.Rainbow then return end
            local hue = tick() % 1
            local color = Color3.fromHSV(hue, 1, 1)
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = color
                end
            end
        end)
        table.insert(TrollConnections, conn)
    else
        CleanupConnections()
    end
end

-- 17. Fire Effect
function ToggleFire()
    TrollState.Fire = not TrollState.Fire
    if TrollState.Fire then
        local fire = Instance.new("Fire")
        fire.Parent = RootPart
        fire.Size = 10
        fire.Heat = 100
        table.insert(TrollObjects, fire)
    else
        CleanupObjects()
    end
end

-- 18. Smoke Effect
function ToggleSmoke()
    TrollState.Smoke = not TrollState.Smoke
    if TrollState.Smoke then
        local smoke = Instance.new("Smoke")
        smoke.Parent = RootPart
        smoke.Opacity = 0.5
        smoke.Size = 10
        table.insert(TrollObjects, smoke)
    else
        CleanupObjects()
    end
end

-- 19. Sparkle Trail
function ToggleSparkle()
    TrollState.Sparkle = not TrollState.Sparkle
    if TrollState.Sparkle then
        local trail = Instance.new("Trail")
        trail.Parent = RootPart
  
