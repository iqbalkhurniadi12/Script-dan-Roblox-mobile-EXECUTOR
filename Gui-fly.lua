-- ============================================
-- DELTA FLY SCRIPT - FULL VERSION
-- Support: Delta Mobile / PC
-- GitHub: https://github.com/username/Delta-Fly
-- ============================================

-- ============================================
-- KONFIGURASI
-- ============================================
local CONFIG = {
    defaultSpeed = 50,
    minSpeed = 10,
    maxSpeed = 200,
    toggleKey = Enum.KeyCode.F,
    guiTitle = "✈️ FLY MODE",
    guiWidth = 180,
    guiHeight = 220,
    guiColor = Color3.fromRGB(20, 20, 30),
    maxForce = Vector3.new(4000, 4000, 4000),
    maxTorque = Vector3.new(4000, 4000, 4000)
}

-- ============================================
-- FLY MANAGER
-- ============================================
local FlyManager = {}
FlyManager.__index = FlyManager

function FlyManager.new(player)
    local self = setmetatable({}, FlyManager)
    self.player = player
    self.character = player.Character or player.CharacterAdded:Wait()
    self.humanoid = self.character:WaitForChild("Humanoid")
    self.enabled = false
    self.speed = CONFIG.defaultSpeed
    self.bodyVelocity = nil
    self.bodyGyro = nil
    return self
end

function FlyManager:toggle()
    self.enabled = not self.enabled
    if self.enabled then
        self:enable()
    else
        self:disable()
    end
    return self.enabled
end

function FlyManager:enable()
    self.bodyVelocity = Instance.new("BodyVelocity")
    self.bodyVelocity.MaxForce = CONFIG.maxForce
    self.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    self.bodyVelocity.Parent = self.character.PrimaryPart
    
    self.bodyGyro = Instance.new("BodyGyro")
    self.bodyGyro.MaxTorque = CONFIG.maxTorque
    self.bodyGyro.CFrame = self.character.PrimaryPart.CFrame
    self.bodyGyro.Parent = self.character.PrimaryPart
    
    self.humanoid.PlatformStand = true
end

function FlyManager:disable()
    if self.bodyVelocity then
        self.bodyVelocity:Destroy()
        self.bodyVelocity = nil
    end
    if self.bodyGyro then
        self.bodyGyro:Destroy()
        self.bodyGyro = nil
    end
    self.humanoid.PlatformStand = false
end

function FlyManager:update(direction)
    if not self.enabled or not self.bodyVelocity then return end
    self.bodyVelocity.Velocity = direction * self.speed
end

function FlyManager:updateRotation(cframe)
    if not self.enabled or not self.bodyGyro then return end
    self.bodyGyro.CFrame = cframe
end

function FlyManager:setSpeed(newSpeed)
    self.speed = math.max(CONFIG.minSpeed, math.min(CONFIG.maxSpeed, newSpeed))
    return self.speed
end

-- ============================================
-- GUI MANAGER
-- ============================================
local GUIManager = {}
GUIManager.__index = GUIManager

function GUIManager.new(player, flyManager)
    local self = setmetatable({}, GUIManager)
    self.player = player
    self.flyManager = flyManager
    self.screenGui = nil
    self.frame = nil
    self.toggleBtn = nil
    self.speedLabel = nil
    return self
end

function GUIManager:create()
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Parent = self.player.PlayerGui
    self.screenGui.ResetOnSpawn = false
    
    self.frame = Instance.new("Frame")
    self.frame.Size = UDim2.new(0, CONFIG.guiWidth, 0, CONFIG.guiHeight)
    self.frame.Position = UDim2.new(0.5, -CONFIG.guiWidth/2, 0.5, -CONFIG.guiHeight/2)
    self.frame.BackgroundColor3 = CONFIG.guiColor
    self.frame.BackgroundTransparency = 0.15
    self.frame.BorderSizePixel = 0
    self.frame.ClipsDescendants = true
    self.frame.Parent = self.screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.frame
    
    self:createTitleBar()
    self:createToggleButton()
    self:createSpeedSlider()
    self:createCloseButton()
    self:setupDrag()
    
    return self
end

function GUIManager:createTitleBar()
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    titleBar.BackgroundTransparency = 0.2
    titleBar.Parent = self.frame
    self.titleBar = titleBar
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = CONFIG.guiTitle
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar
end

function GUIManager:createToggleButton()
    self.toggleBtn = Instance.new("TextButton")
    self.toggleBtn.Size = UDim2.new(0, 140, 0, 40)
    self.toggleBtn.Position = UDim2.new(0.5, -70, 0, 50)
    self.toggleBtn.Text = "🔴 FLY OFF"
    self.toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    self.toggleBtn.TextSize = 16
    self.toggleBtn.Font = Enum.Font.GothamBold
    self.toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    self.toggleBtn.Parent = self.frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = self.toggleBtn
    
    self.toggleBtn.MouseButton1Click:Connect(function()
        self:toggleFly()
    end)
end

function GUIManager:createSpeedSlider()
    self.speedLabel = Instance.new("TextLabel")
    self.speedLabel.Size = UDim2.new(1, 0, 0, 20)
    self.speedLabel.Position = UDim2.new(0, 0, 0, 105)
    self.speedLabel.BackgroundTransparency = 1
    self.speedLabel.Text = "Kecepatan: " .. self.flyManager.speed
    self.speedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    self.speedLabel.TextSize = 14
    self.speedLabel.Font = Enum.Font.Gotham
    self.speedLabel.Parent = self.frame
    
    self.speedInput = Instance.new("TextBox")
    self.speedInput.Size = UDim2.new(0, 140, 0, 30)
    self.speedInput.Position = UDim2.new(0.5, -70, 0, 130)
    self.speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    self.speedInput.Text = tostring(self.flyManager.speed)
    self.speedInput.TextColor3 = Color3.new(1, 1, 1)
    self.speedInput.TextSize = 14
    self.speedInput.Font = Enum.Font.Gotham
    self.speedInput.ClearTextOnFocus = false
    self.speedInput.Parent = self.frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = self.speedInput
    
    self.speedInput.FocusLost:Connect(function()
        local num = tonumber(self.speedInput.Text)
        if num then
            local newSpeed = self.flyManager:setSpeed(num)
            self.speedInput.Text = tostring(newSpeed)
            self.speedLabel.Text = "Kecepatan: " .. newSpeed
        else
            self.speedInput.Text = tostring(self.flyManager.speed)
        end
    end)
end

function GUIManager:createCloseButton()
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = self.titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        if self.flyManager.enabled then
            self.flyManager:toggle()
        end
        self.screenGui:Destroy()
    end)
end

function GUIManager:setupDrag()
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    self.titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function GUIManager:toggleFly()
    local status = self.flyManager:toggle()
    if status then
        self.toggleBtn.Text = "🟢 FLY ON"
        self.toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        self.toggleBtn.Text = "🔴 FLY OFF"
        self.toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end

-- ============================================
-- INPUT HANDLER
-- ============================================
local InputHandler = {}
InputHandler.__index = InputHandler

function InputHandler.new(flyManager, guiManager)
    local self = setmetatable({}, InputHandler)
    self.flyManager = flyManager
    self.guiManager = guiManager
    self.userInput = game:GetService("UserInputService")
    self.runService = game:GetService("RunService")
    return self
end

function InputHandler:start()
    self.userInput.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == CONFIG.toggleKey then
            self.guiManager:toggleFly()
        end
    end)
    
    self.runService.Heartbeat:Connect(function()
        if not self.flyManager.enabled then return end
        
        local direction = self:getMoveDirection()
        self.flyManager:update(direction)
        
        local camera = workspace.CurrentCamera
        if camera then
            self.flyManager:updateRotation(camera.CFrame)
        end
    end)
end

function InputHandler:getMoveDirection()
    local direction = Vector3.new(0, 0, 0)
    local camera = workspace.CurrentCamera
    if not camera then return direction end
    
    local forward = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector
    
    forward = Vector3.new(forward.X, 0, forward.Z).Unit
    right = Vector3.new(right.X, 0, right.Z).Unit
    
    if self.userInput:IsKeyDown(Enum.KeyCode.W) then
        direction = direction + forward
    end
    if self.userInput:IsKeyDown(Enum.KeyCode.S) then
        direction = direction - forward
    end
    if self.userInput:IsKeyDown(Enum.KeyCode.A) then
        direction = direction - right
    end
    if self.userInput:IsKeyDown(Enum.KeyCode.D) then
        direction = direction + right
    end
    if self.userInput:IsKeyDown(Enum.KeyCode.Space) then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if self.userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction = direction - Vector3.new(0, 1, 0)
    end
    
    return direction.Magnitude > 0 and direction.Unit or direction
end

-- ============================================
-- MAIN EXECUTION
-- ============================================
local function main()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character.PrimaryPart then
        character:WaitForChild("PrimaryPart")
    end
    
    local flyManager = FlyManager.new(player)
    local guiManager = GUIManager.new(player, flyManager)
    local inputHandler = InputHandler.new(flyManager, guiManager)
    
    guiManager:create()
    inputHandler:start()
    
    print("✅ Delta Fly Script loaded successfully!")
    print("🔑 Press F to toggle fly")
    print("📱 GUI available on screen")
end

-- Run
pcall(main)
