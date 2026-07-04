-- =====================================================
-- ОБЪЕДИНЕННЫЙ СКРИПТ ESP + AIMBOT + МОБИЛЬНОЕ GUI
-- Для игры "Lost Front" (ТОЛЬКО для частных серверов!)
-- =====================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- =====================================================
-- 1. СОЗДАНИЕ GUI (МОБИЛЬНАЯ КНОПКА)
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Главная кнопка
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 80, 0, 80)
ToggleButton.Position = UDim2.new(0.85, -40, 0.85, -40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.BorderSizePixel = 0
ToggleButton.Image = "rbxassetid://" -- можно вставить иконку

-- Скругление
local Corner = Instance.new("UICorner", ToggleButton)
Corner.CornerRadius = UDim.new(1, 0)

-- Текст на кнопке
local Label = Instance.new("TextLabel", ToggleButton)
Label.Size = UDim2.new(1, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = "OFF"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextScaled = true
Label.Font = Enum.Font.GothamBold

-- =====================================================
-- 2. СОЗДАНИЕ ПРИЦЕЛА (КРУГА)
-- =====================================================
local Crosshair = Instance.new("ImageLabel")
Crosshair.Size = UDim2.new(0, 40, 0, 40)
Crosshair.Position = UDim2.new(0.5, -20, 0.5, -20)
Crosshair.BackgroundTransparency = 1
Crosshair.ZIndex = 20
Crosshair.Visible = false
Crosshair.Parent = ScreenGui

-- Рамка круга
local CircleFrame = Instance.new("Frame")
CircleFrame.Size = UDim2.new(1, 0, 1, 0)
CircleFrame.BackgroundTransparency = 1
CircleFrame.BorderSizePixel = 3
CircleFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
CircleFrame.Parent = Crosshair

-- Точка в центре
local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 4, 0, 4)
Dot.Position = UDim2.new(0.5, -2, 0.5, -2)
Dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Dot.BorderSizePixel = 0
Dot.Parent = Crosshair

-- =====================================================
-- 3. ПЕРЕМЕННЫЕ СОСТОЯНИЯ
-- =====================================================
local MenuOpen = false
local ESPObjects = {}
local AimbotConnection = nil
local ESPConnection = nil

-- =====================================================
-- 4. ФУНКЦИИ ESP
-- =====================================================
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
    
    -- Рамка вокруг игрока
    local Box = Instance.new("BoxHandleAdornment")
    Box.Size = Vector3.new(4, 6, 2)
    Box.Color3 = Color3.fromRGB(0, 255, 255)
    Box.Transparency = 0.4
    Box.AlwaysOnTop = true
    Box.ZIndex = 10
    Box.Adornee = character
    Box.Parent = folder
    
    -- Полоска здоровья
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 25)
    billboard.Adornee = character:FindFirstChild("Head")
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = folder
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bg.BorderSizePixel = 1
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
    
    -- Обновление здоровья
    local humanoid = character.Humanoid
    local connection
    connection = humanoid.HealthChanged:Connect(function(health)
        local maxHealth = humanoid.MaxHealth
        if maxHealth > 0 then
            local percent = math.max(0, health / maxHealth)
            hpFill.Size = UDim2.new(percent, 0, 1, 0)
            hpText.Text = math.floor(health) .. "/" .. math.floor(maxHealth) .. " HP"
            
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
        Humanoid = humanoid
    }
end

local function EnableESP()
    -- Создаём для всех игроков
    for _, player in pairs(Players:GetPlayers()) do
        CreateESPForPlayer(player)
    end
    
    -- Следим за новыми игроками
    Players.PlayerAdded:Connect(CreateESPForPlayer)
    
    -- Следим за появлением персонажа
    ESPConnection = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if MenuOpen then
                CreateESPForPlayer(player)
            end
        end)
    end)
end

-- =====================================================
-- 5. ФУНКЦИИ AIMBOT
-- =====================================================
local function EnableAimbot()
    AimbotConnection = RunService.RenderStepped:Connect(function()
        if not MenuOpen then return end
        
        local target = nil
        local shortestDist = math.huge
        local centerX = Camera.ViewportSize.X / 2
        local centerY = Camera.ViewportSize.Y / 2
        local aimRadius = 200 -- Радиус поиска цели
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local headPos = head.Position
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                
                if onScreen then
                    local dx = screenPos.X - centerX
                    local dy = screenPos.Y - centerY
                    local dist = math.sqrt(dx^2 + dy^2)
                    
                    -- Проверяем, жив ли игрок
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
                -- Наведение на голову
                local targetPos = head.Position
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                
                -- Меняем цвет прицела на зелёный
                CircleFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
                Dot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            end
        else
            -- Нет цели - красный прицел
            CircleFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
end

-- =====================================================
-- 6. ФУНКЦИИ ВКЛЮЧЕНИЯ/ОТКЛЮЧЕНИЯ
-- =====================================================
local function ToggleMods()
    MenuOpen = not MenuOpen
    
    if MenuOpen then
        -- Включаем
        Label.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        Crosshair.Visible = true
        
        -- Запускаем ESP
        ClearESP()
        EnableESP()
        
        -- Запускаем Aimbot
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
        EnableAimbot()
        
        print("[+] Моды включены")
    else
        -- Выключаем
        Label.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Crosshair.Visible = false
        
        -- Отключаем ESP
        ClearESP()
        if ESPConnection then
            ESPConnection:Disconnect()
            ESPConnection = nil
        end
        
        -- Отключаем Aimbot
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
        
        print("[-] Моды выключены")
    end
end

-- =====================================================
-- 7. ПОДКЛЮЧЕНИЕ КНОПКИ
-- =====================================================
ToggleButton.MouseButton1Click:Connect(ToggleMods)

-- Поддержка клавиши (для ПК)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        ToggleMods()
    end
end)

-- =====================================================
-- 8. ОЧИСТКА ПРИ ВЫХОДЕ
-- =====================================================
LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
    if not LocalPlayer.Parent then
        ClearESP()
        if AimbotConnection then AimbotConnection:Disconnect() end
        if ESPConnection then ESPConnection:Disconnect() end
    end
end)

print("[✓] Скрипт загружен. Нажмите кнопку на экране или Ctrl для активации.")
