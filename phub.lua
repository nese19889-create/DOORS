local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 100)
ToggleButton.Position = UDim2.new(0.9, -50, 0.92, -50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.AutoButtonColor = true

local Corner = Instance.new("UICorner", ToggleButton)
Corner.CornerRadius = UDim.new(1, 0)

local Shadow = Instance.new("ImageLabel", ToggleButton)
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316041047"
Shadow.ZIndex = 0
Shadow.ImageTransparency = 0.5

local Label = Instance.new("TextLabel", ToggleButton)
Label.Size = UDim2.new(1, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = "OFF"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextScaled = true
Label.Font = Enum.Font.GothamBold
Label.TextStrokeTransparency = 0.5
Label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Label.ZIndex = 2

local Glow = Instance.new("ImageLabel", ToggleButton)
Glow.Size = UDim2.new(1.2, 0, 1.2, 0)
Glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://2191902880"
Glow.ImageTransparency = 0.8
Glow.ZIndex = 1

local StatusGui = Instance.new("BillboardGui", ScreenGui)
StatusGui.Size = UDim2.new(0, 200, 0, 50)
StatusGui.Position = UDim2.new(0.5, -100, 0.3, 0)
StatusGui.StudsOffset = Vector3.new(0, 0, 0)
StatusGui.AlwaysOnTop = true
StatusGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local StatusFrame = Instance.new("Frame", StatusGui)
StatusFrame.Size = UDim2.new(1, 0, 1, 0)
StatusFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusFrame.BackgroundTransparency = 0.4
StatusFrame.BorderSizePixel = 2
StatusFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)

local StatusCorner = Instance.new("UICorner", StatusFrame)
StatusCorner.CornerRadius = UDim.new(0, 10)

local StatusLabel = Instance.new("TextLabel", StatusFrame)
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "MODS OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.GothamBold

StatusGui.Enabled = false

local Crosshair = Instance.new("ImageLabel")
Crosshair.Size = UDim2.new(0, 50, 0, 50)
Crosshair.Position = UDim2.new(0.5, -25, 0.5, -25)
Crosshair.BackgroundTransparency = 1
Crosshair.ZIndex = 20
Crosshair.Visible = false
Crosshair.Parent = ScreenGui

local CircleFrame = Instance.new("Frame")
CircleFrame.Size = UDim2.new(1, 0, 1, 0)
CircleFrame.BackgroundTransparency = 1
CircleFrame.BorderSizePixel = 3
CircleFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
CircleFrame.Parent = Crosshair

local CircleCorner = Instance.new("UICorner", CircleFrame)
CircleCorner.CornerRadius = UDim.new(1, 0)

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 6, 0, 6)
Dot.Position = UDim2.new(0.5, -3, 0.5, -3)
Dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Dot.BorderSizePixel = 0
Dot.Parent = Crosshair

local DotCorner = Instance.new("UICorner", Dot)
DotCorner.CornerRadius = UDim.new(1, 0)

local MenuOpen = false
local ESPObjects = {}
local AimbotConnection = nil
local ESPConnection = nil
local StatusConnection = nil

local function ClearESP()
    for player, data in pairs(ESPObjects) do
        if data.Connection then 
            data.Connection:Disconnect() 
        end
        if data.Folder then 
            data.Folder:Destroy() 
        end
    end
    ESPObjects = {}
end

local function CreateESPForPlayer(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then return end
    
    local folder = Instance.new("Folder")
    folder.Name = "ESP_Folder_" .. player.Name
    
    local Box = Instance.new("BoxHandleAdornment")
    Box.Size = Vector3.new(4.5, 6.5, 2.5)
    Box.Color3 = Color3.fromRGB(0, 200, 255)
    Box.Transparency = 0.3
    Box.AlwaysOnTop = true
    Box.ZIndex = 10
    Box.Adornee = character
    Box.Parent = folder
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 130, 0, 28)
    billboard.Adornee = character:FindFirstChild("Head")
    billboard.StudsOffset = Vector3.new(0, 2.8, 0)
    billboard.Parent = folder
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bg.BorderSizePixel = 2
    bg.BorderColor3 = Color3.fromRGB(255, 255, 255)
    bg.Parent = billboard
    
    local hpFill = Instance.new("Frame")
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = bg
    
    local hpText = Instance.new("TextLabel")
    hpText.Size = UDim2.new(1, 0, 1, 0)
    hpText.BackgroundTransparency = 1
    hpText.Text = "100 HP"
    hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
    hpText.TextScaled = true
    hpText.Font = Enum.Font.GothamBold
    hpText.Parent = billboard
    
    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Size = UDim2.new(0, 80, 0, 20)
    nameBillboard.Adornee = character:FindFirstChild("Head")
    nameBillboard.StudsOffset = Vector3.new(0, 3.8, 0)
    nameBillboard.Parent = folder
    
    local nameLabel = Instance.new("TextLabel", nameBillboard)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextStrokeTransparency = 0.3
    
    local humanoid = character.Humanoid
    local connection
    connection = humanoid.HealthChanged:Connect(function(health)
        local maxHealth = humanoid.MaxHealth
        if maxHealth > 0 then
            local percent = math.max(0, health / maxHealth)
            hpFill.Size = UDim2.new(percent, 0, 1, 0)
            hpText.Text = math.floor(health) .. "/" .. math.floor(maxHealth)
            
            if percent > 0.5 then
                hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif percent > 0.25 then
                hpFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            else
                hpFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    end)
    
    folder.Parent = workspace
    
    ESPObjects[player] = {
        Folder = folder,
        Connection = connection,
        HPFrame = hpFill,
        Text = hpText,
        Humanoid = humanoid,
        NameLabel = nameLabel
    }
end

local function EnableESP()
    for _, player in pairs(Players:GetPlayers()) do
        CreateESPForPlayer(player)
    end
    
    Players.PlayerAdded:Connect(CreateESPForPlayer)
    
    ESPConnection = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if MenuOpen then
                CreateESPForPlayer(player)
            end
        end)
    end)
end

local function EnableAimbot()
    AimbotConnection = RunService.RenderStepped:Connect(function()
        if not MenuOpen then return end
        
        local target = nil
        local shortestDist = math.huge
        local centerX = Camera.ViewportSize.X / 2
        local centerY = Camera.ViewportSize.Y / 2
        local aimRadius = 250
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local headPos = head.Position
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                
                if onScreen then
                    local dx = screenPos.X - centerX
                    local dy = screenPos.Y - centerY
                    local dist = math.sqrt(dx^2 + dy^2)
                    
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 and dist < aimRadius and dist < shortestDist then
                        shortestDist = dist
                        target = player
                    end
                end
            end
        end
        
        if target then
            local head = target.Character.Head
            if head then
                local targetPos = head.Position
                local newCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 0.3)
                
                CircleFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
                Dot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            end
        else
            CircleFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
end

local function ShowStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color
    StatusGui.Enabled = true
    
    if StatusConnection then
        StatusConnection:Disconnect()
        StatusConnection = nil
    end
    
    StatusConnection = task.wait(2)
    StatusGui.Enabled = false
end

local function ToggleMods()
    MenuOpen = not MenuOpen
    
    if MenuOpen then
        Label.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        Crosshair.Visible = true
        
        ClearESP()
        EnableESP()
        
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
        EnableAimbot()
        
        ShowStatus("MODS ON", Color3.fromRGB(0, 255, 0))
        
    else
        Label.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Crosshair.Visible = false
        
        ClearESP()
        if ESPConnection then
            ESPConnection:Disconnect()
            ESPConnection = nil
        end
        
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
        
        ShowStatus("MODS OFF", Color3.fromRGB(255, 0, 0))
    end
end

ToggleButton.MouseButton1Click:Connect(ToggleMods)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.F1 then
        ToggleMods()
    end
end)

LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
    if not LocalPlayer.Parent then
        ClearESP()
        if AimbotConnection then AimbotConnection:Disconnect() end
        if ESPConnection then ESPConnection:Disconnect() end
        if StatusConnection then StatusConnection:Disconnect() end
    end
end)

print("Script loaded! Press the button or Ctrl/F1 to toggle.")
