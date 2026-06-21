--[[
DELTA MOBILE ULTIMATE HUB - TOUCH OPTIMIZED
Full fitur + kontrol sentuh
Support: Delta Mobile / PC
--]]

repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- ─── DETEKSI RIG ───
local isR6 = humanoid.RigType == Enum.HumanoidRigType.R6
local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
local rigType = isR6 and "R6" or "R15"

-- ─── VARIABEL STATUS ───
local flyActive = false
local noclipActive = false
local espActive = false
local waterWalkActive = false
local autoFarmActive = false
local speedMultiplier = 1
local jumpMultiplier = 1
local flyBodyVel = nil
local flyBodyGyro = nil
local espObjects = {}
local waterWalkConn = nil
local farmConn = nil

-- ─── FUNGSI NOTIFIKASI ───
local function notify(text, duration)
    duration = duration or 3
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ DELTA HUB",
        Text = text,
        Duration = duration
    })
    print("[Delta] " .. text)
end

-- ─── BUAT TOUCH CONTROLS ───
local function createTouchControls()
    local sg = Instance.new("ScreenGui")
    sg.Parent = lp:WaitForChild("PlayerGui")
    sg.Name = "DeltaTouchHub"
    sg.ResetOnSpawn = false
    
    -- Background transparan untuk joystick
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.Parent = sg
    
    -- ─── JOYSTICK KIRI (GERAKAN) ───
    local leftJoystick = Instance.new("Frame")
    leftJoystick.Size = UDim2.new(0, 130, 0, 130)
    leftJoystick.Position = UDim2.new(0, 25, 1, -160)
    leftJoystick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    leftJoystick.BackgroundTransparency = 0.85
    leftJoystick.BorderSizePixel = 2
    leftJoystick.BorderColor3 = Color3.fromRGB(100, 200, 255)
    leftJoystick.Parent = sg
    
    local leftCorner = Instance.new("UICorner")
    leftCorner.CornerRadius = UDim.new(1, 0)
    leftCorner.Parent = leftJoystick
    
    local leftKnob = Instance.new("Frame")
    leftKnob.Size = UDim2.new(0, 45, 0, 45)
    leftKnob.Position = UDim2.new(0.5, -22.5, 0.5, -22.5)
    leftKnob.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    leftKnob.BackgroundTransparency = 0.4
    leftKnob.BorderSizePixel = 2
    leftKnob.BorderColor3 = Color3.fromRGB(255, 255, 255)
    leftKnob.Parent = leftJoystick
    
    local leftCorner2 = Instance.new("UICorner")
    leftCorner2.CornerRadius = UDim.new(1, 0)
    leftCorner2.Parent = leftKnob
    
    -- Label joystick
    local leftLabel = Instance.new("TextLabel")
    leftLabel.Size = UDim2.new(1, 0, 0, 20)
    leftLabel.Position = UDim2.new(0, 0, 1, 5)
    leftLabel.BackgroundTransparency = 1
    leftLabel.Text = "🔄 GERAK"
    leftLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    leftLabel.TextSize = 12
    leftLabel.Font = Enum.Font.GothamBold
    leftLabel.Parent = leftJoystick
    
    -- ─── JOYSTICK KANAN (KAMERA) ───
    local rightJoystick = Instance.new("Frame")
    rightJoystick.Size = UDim2.new(0, 110, 0, 110)
    rightJoystick.Position = UDim2.new(1, -135, 1, -160)
    rightJoystick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    rightJoystick.BackgroundTransparency = 0.85
    rightJoystick.BorderSizePixel = 2
    rightJoystick.BorderColor3 = Color3.fromRGB(255, 100, 100)
    rightJoystick.Parent = sg
    
    local rightCorner = Instance.new("UICorner")
    rightCorner.CornerRadius = UDim.new(1, 0)
    rightCorner.Parent = rightJoystick
    
    local rightKnob = Instance.new("Frame")
    rightKnob.Size = UDim2.new(0, 40, 0, 40)
    rightKnob.Position = UDim2.new(0.5, -20, 0.5, -20)
    rightKnob.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    rightKnob.BackgroundTransparency = 0.4
    rightKnob.BorderSizePixel = 2
    rightKnob.BorderColor3 = Color3.fromRGB(255, 255, 255)
    rightKnob.Parent = rightJoystick
    
    local rightCorner2 = Instance.new("UICorner")
    rightCorner2.CornerRadius = UDim.new(1, 0)
    rightCorner2.Parent = rightKnob
    
    local rightLabel = Instance.new("TextLabel")
    rightLabel.Size = UDim2.new(1, 0, 0, 20)
    rightLabel.Position = UDim2.new(0, 0, 1, 5)
    rightLabel.BackgroundTransparency = 1
    rightLabel.Text = "👁️ KAMERA"
    rightLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
    rightLabel.TextSize = 12
    rightLabel.Font = Enum.Font.GothamBold
    rightLabel.Parent = rightJoystick
    
    -- Data joystick
    local joyData = {
        left = {active = false, x = 0, y = 0, startX = 0, startY = 0},
        right = {active = false, x = 0, y = 0, startX = 0, startY = 0}
    }
    
    -- Event touch kiri
    leftJoystick.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            joyData.left.active = true
            joyData.left.startX = input.Position.X
            joyData.left.startY = input.Position.Y
        end
    end)
    
    leftJoystick.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and joyData.left.active then
            local pos = input.Position
            local center = leftJoystick.AbsolutePosition + Vector2.new(65, 65)
            local delta = pos - center
            local maxDist = 55
            local dist = delta.Magnitude
            
            if dist > maxDist then
                delta = delta / dist * maxDist
            end
            
            leftKnob.Position = UDim2.new(0.5, delta.X - 22.5, 0.5, delta.Y - 22.5)
            joyData.left.x = delta.X / maxDist
            joyData.left.y = delta.Y / maxDist
        end
    end)
    
    leftJoystick.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            joyData.left.active = false
            joyData.left.x = 0
            joyData.left.y = 0
            leftKnob.Position = UDim2.new(0.5, -22.5, 0.5, -22.5)
        end
    end)
    
    -- Event touch kanan
    rightJoystick.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            joyData.right.active = true
            joyData.right.startX = input.Position.X
            joyData.right.startY = input.Position.Y
        end
    end)
    
    rightJoystick.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and joyData.right.active then
            local pos = input.Position
            local center = rightJoystick.AbsolutePosition + Vector2.new(55, 55)
            local delta = pos - center
            local maxDist = 45
            local dist = delta.Magnitude
            
            if dist > maxDist then
                delta = delta / dist * maxDist
            end
            
            rightKnob.Position = UDim2.new(0.5, delta.X - 20, 0.5, delta.Y - 20)
            joyData.right.x = delta.X / maxDist
            joyData.right.y = delta.Y / maxDist
        end
    end)
    
    rightJoystick.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            joyData.right.active = false
            joyData.right.x = 0
            joyData.right.y = 0
            rightKnob.Position = UDim2.new(0.5, -20, 0.5, -20)
        end
    end)
    
    -- ─── TOMBOL ACTION ───
    local actionButtons = {}
    local buttonConfigs = {
        {name = "✈️ FLY", color = Color3.fromRGB(0, 200, 255), pos = UDim2.new(1, -80, 0, 50)},
        {name = "⚡ SPD", color = Color3.fromRGB(255, 200, 0), pos = UDim2.new(1, -80, 0, 115)},
        {name = "⬆️ JMP", color = Color3.fromRGB(0, 255, 100), pos = UDim2.new(1, -80, 0, 180)},
        {name = "🚪 NOC", color = Color3.fromRGB(255, 0, 200), pos = UDim2.new(1, -80, 0, 245)},
        {name = "👁️ ESP", color = Color3.fromRGB(200, 100, 255), pos = UDim2.new(1, -80, 0, 310)},
        {name = "💀 KILL", color = Color3.fromRGB(255, 0, 0), pos = UDim2.new(1, -80, 0, 375)}
    }
    
    for _, cfg in pairs(buttonConfigs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 55)
        btn.Position = cfg.pos
        btn.BackgroundColor3 = cfg.color
        btn.BackgroundTransparency = 0.25
        btn.Text = cfg.name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
        btn.Parent = sg
        btn.Name = cfg.name
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                btn.BackgroundTransparency = 0.1
                btn.Size = UDim2.new(0, 65, 0, 60)
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                btn.BackgroundTransparency = 0.25
                btn.Size = UDim2.new(0, 60, 0, 55)
            end
        end)
        
        table.insert(actionButtons, btn)
    end
    
    -- ─── TOMBOL SPEED VARIASI ───
    local speedBtns = {}
    local speedValues = {2, 5, 10, 20}
    for i, val in pairs(speedValues) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 45, 0, 40)
        btn.Position = UDim2.new(0, 10 + ((i-1) * 52), 0, 280)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        btn.BackgroundTransparency = 0.3
        btn.Text = "x" .. val
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(100, 100, 150)
        btn.Parent = sg
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            humanoid.WalkSpeed = 16 * val
            notify("⚡ Speed: x" .. val)
        end)
        
        table.insert(speedBtns, btn)
    end
    
    -- ─── TOMBOL JUMP VARIASI ───
    local jumpBtns = {}
    local jumpValues = {2, 5, 10}
    for i, val in pairs(jumpValues) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 45, 0, 40)
        btn.Position = UDim2.new(0, 10 + ((i-1) * 52), 0, 330)
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 80)
        btn.BackgroundTransparency = 0.3
        btn.Text = "J" .. val
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(0, 150, 120)
        btn.Parent = sg
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            humanoid.JumpPower = 50 * val
            notify("⬆️ Jump x" .. val)
        end)
        
        table.insert(jumpBtns, btn)
    end
    
    return sg, joyData, actionButtons
end

-- ─── BUAT TOUCH CONTROLS ───
local touchGui, joyData, actionButtons = createTouchControls()

-- ─── FUNGSI-FUNGSI FITUR ───

-- FLY
local function toggleFly()
    flyActive = not flyActive
    
    if flyActive then
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false
        
        flyBodyVel = Instance.new("BodyVelocity")
        flyBodyVel.MaxForce = Vector3.new(1, 1, 1) * 100000
        flyBodyVel.P = 100000
        flyBodyVel.Parent = root
        
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
        flyBodyGyro.P = 100000
        flyBodyGyro.Parent = root
        
        notify("✈️ Fly ON")
    else
        if flyBodyVel then flyBodyVel:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
        notify("✈️ Fly OFF")
    end
end

-- NOCLIP
local function toggleNoclip()
    noclipActive = not noclipActive
    notify("🚪 Noclip: " .. (noclipActive and "ON" or "OFF"))
end

-- ESP
local function toggleESP()
    espActive = not espActive
    
    if espActive then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Character then
                local hl = Instance.new("Highlight")
                hl.Parent = plr.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(0, 255, 255)
                hl.FillTransparency = 0.3
                hl.OutlineTransparency = 0
                table.insert(espObjects, hl)
            end
        end
        notify("👁️ ESP ON")
    else
        for _, hl in pairs(espObjects) do
            hl:Destroy()
        end
        espObjects = {}
        notify("👁️ ESP OFF")
    end
end

-- KILL ALL
local function killAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum then
                hum.Health = 0
            end
        end
    end
    notify("💀 Kill All executed!", 2)
end

-- AUTO FARM
local function toggleAutoFarm()
    autoFarmActive = not autoFarmActive
    
    if autoFarmActive then
        farmConn = RunService.Heartbeat:Connect(function()
            if not autoFarmActive then
                farmConn:Disconnect()
                return
            end
            
            local nearest = nil
            local minDist = math.huge
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= lp.Name then
                    local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                    if hrp then
                        local dist = (root.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearest = obj
                        end
                    end
                end
            end
            
            if nearest and minDist < 100 then
                local targetRoot = nearest:FindFirstChild("HumanoidRootPart") or nearest:FindFirstChild("Torso")
                if targetRoot then
                    root.CFrame = CFrame.new(root.Position, targetRoot.Position)
                    
                    -- Auto attack
                    VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.05)
                    VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end
            
            -- Auto heal
            if humanoid.Health < humanoid.MaxHealth * 0.3 then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        notify("🤖 Auto Farm ON")
    else
        if farmConn then farmConn:Disconnect() end
        notify("🤖 Auto Farm OFF")
    end
end

-- WATER WALK
local function toggleWaterWalk()
    waterWalkActive = not waterWalkActive
    
    if waterWalkActive then
        waterWalkConn = RunService.Heartbeat:Connect(function()
            if not waterWalkActive then
                waterWalkConn:Disconnect()
                return
            end
            if root and root.Position.Y < 0 then
                root.CFrame = root.CFrame + Vector3.new(0, 2, 0)
            end
        end)
        notify("🌊 Water Walk ON")
    else
        if waterWalkConn then waterWalkConn:Disconnect() end
        notify("🌊 Water Walk OFF")
    end
end

-- ─── HUBUNGI TOMBOL ───
for _, btn in pairs(actionButtons) do
    btn.MouseButton1Click:Connect(function()
        local name = btn.Name
        if name == "✈️ FLY" then
            toggleFly()
        elseif name == "⚡ SPD" then
            humanoid.WalkSpeed = 16 * 3
            notify("⚡ Speed: x3")
        elseif name == "⬆️ JMP" then
            humanoid.JumpPower = 50 * 3
            notify("⬆️ Jump x3")
        elseif name == "🚪 NOC" then
            toggleNoclip()
        elseif name == "👁️ ESP" then
            toggleESP()
        elseif name == "💀 KILL" then
            killAll()
        end
    end)
end

-- ─── LOOP UTAMA ───
RunService.Heartbeat:Connect(function()
    -- Gerakan dari joystick kiri
    if joyData.left.active then
        local x = joyData.left.x
        local y = joyData.left.y
        
        if math.abs(x) > 0.1 or math.abs(y) > 0.1 then
            local camera = workspace.CurrentCamera
            local forward = camera.CFrame.LookVector * Vector3.new(1, 0, 1)
            local right = camera.CFrame.RightVector * Vector3.new(1, 0, 1)
            
            local moveDir = (forward * -y + right * x).Unit
            root.CFrame = root.CFrame + moveDir * (humanoid.WalkSpeed / 12)
            
            if moveDir.Magnitude > 0.1 then
                root.CFrame = CFrame.lookAt(root.Position, root.Position + moveDir)
            end
        end
    end
    
    -- Fly dengan joystick
    if flyActive then
        local moveDir = Vector3.new(0, 0, 0)
        
        if joyData.left.active then
            local x = joyData.left.x
            local y = joyData.left.y
            local camera = workspace.CurrentCamera
            
            local forward = camera.CFrame.LookVector * Vector3.new(1, 0, 1)
            local right = camera.CFrame.RightVector * Vector3.new(1, 0, 1)
            
            moveDir = (forward * -y + right * x).Unit * 50
        end
        
        -- Kontrol naik/turun
        if UserInput:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 50, 0)
        end
        if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 50, 0)
        end
        
        if flyBodyVel then
            flyBodyVel.Velocity = moveDir
        end
        
        if flyBodyGyro then
            local camera = workspace.CurrentCamera
            if camera then
                flyBodyGyro.CFrame = camera.CFrame
            end
        end
    end
    
    -- Noclip
    if noclipActive then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ─── LOAD INFINITE YIELD ───
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    notify("🛠️ Admin commands loaded!")
end)

-- ─── NOTIFIKASI AWAL ───
notify("🔥 DELTA MOBILE ULTIMATE HUB", 4)
notify("📱 Touch controls aktif!", 3)
notify("🔄 Geser joystick kiri untuk jalan", 3)
notify("🎯 Tombol kanan atas untuk aksi", 3)

print("✅ DELTA MOBILE ULTIMATE HUB LOADED!")
print("📱 Rig Type:", rigType)
print("🔄 Touch controls ready!")
