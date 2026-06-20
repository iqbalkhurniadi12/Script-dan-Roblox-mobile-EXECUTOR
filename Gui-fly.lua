-- ============================================
-- FLY SCRIPT - ALTERNATIVE METHOD
-- Lebih stabil untuk server sendiri
-- ============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local flyEnabled = false
local flySpeed = 60
local rootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart

-- ============================================
-- FUNGSI FLY (Method 2: Posisi langsung)
-- ============================================

local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        -- Matikan gravitasi dan platform
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false
        humanoid.Sit = false
        
        -- Matikan collision agar tidak nabrak
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part:SetNetworkOwner(player)
            end
        end
        
        print("✅ Fly: ON")
    else
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
        
        -- Kembalikan collision
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        
        print("❌ Fly: OFF")
    end
end

-- ============================================
-- KONTROL GERAKAN (Pake Tween/CFrame)
-- ============================================

local function moveFly()
    if not flyEnabled or not rootPart then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    -- Arah gerakan
    local forward = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector
    local up = camera.CFrame.UpVector
    
    forward = Vector3.new(forward.X, 0, forward.Z).Unit
    right = Vector3.new(right.X, 0, right.Z).Unit
    
    local moveDirection = Vector3.new(0, 0, 0)
    local userInput = game:GetService("UserInputService")
    
    if userInput:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + forward
    end
    if userInput:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - forward
    end
    if userInput:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - right
    end
    if userInput:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + right
    end
    if userInput:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDirection = moveDirection - Vector3.new(0, 1, 0)
    end
    
    -- Terapkan gerakan
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * flySpeed
        rootPart.Velocity = moveDirection -- Pakai Velocity langsung
        -- Atau pake CFrame (uncomment kalo velocity gak jalan)
        -- rootPart.CFrame = rootPart.CFrame + moveDirection * 0.1
    else
        rootPart.Velocity = Vector3.new(0, 0, 0)
    end
    
    -- Rotasi mengikuti kamera
    rootPart.CFrame = CFrame.new(rootPart.Position, camera.CFrame.Position)
end

-- ============================================
-- LOOP UTAMA
-- ============================================

game:GetService("RunService").Heartbeat:Connect(moveFly)

-- ============================================
-- KEYBIND
-- ============================================

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
        updateButton()
    end
end)

-- ============================================
-- GUI
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 100)
frame.Position = UDim2.new(0.5, -80, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.15
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Tombol toggle
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 130, 0, 35)
toggleBtn.Position = UDim2.new(0.5, -65, 0, 15)
toggleBtn.Text = "🔴 FLY OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

-- Slider speed
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 60)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Kecepatan: 60"
speedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = frame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 80, 0, 25)
speedInput.Position = UDim2.new(0.5, -40, 0, 75)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedInput.Text = "60"
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.TextSize = 12
speedInput.Font = Enum.Font.Gotham
speedInput.ClearTextOnFocus = false
speedInput.Parent = frame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 8)
sliderCorner.Parent = speedInput

speedInput.FocusLost:Connect(function()
    local num = tonumber(speedInput.Text)
    if num then
        flySpeed = math.max(10, math.min(300, num))
        speedLabel.Text = "Kecepatan: " .. flySpeed
    else
        speedInput.Text = tostring(flySpeed)
    end
end)

function updateButton()
    if flyEnabled then
        toggleBtn.Text = "🟢 FLY ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        toggleBtn.Text = "🔴 FLY OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    toggleFly()
    updateButton()
end)

print("✅ Fly Script (Alternate) loaded!")
print("🔑 Press F to toggle fly")
