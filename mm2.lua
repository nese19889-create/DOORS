-- MM2 ESP + Modern GUI (Mobile Friendly)
-- Скрипт для Murder Mystery 2

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки
local Settings = {
    ShowSheriff = true,
    ShowMurderer = true,
    ShowInnocent = false,
    ESPColor = Color3.fromRGB(255, 255, 255)
}

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_ESP_GUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Сглаживание углов
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Title.BackgroundTransparency = 0.3
Title.Text = "MM2 ESP v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Создание кнопок-переключателей
local function CreateToggle(parent, text, yPos, default, settingKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 30)
    toggleBtn.Position = UDim2.new(0.85, 0, 0.5, -15)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleBtn
    
    local isOn = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        Settings[settingKey] = isOn
        toggleBtn.BackgroundColor3 = isOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
        toggleBtn.Text = isOn and "ON" or "OFF"
    end)
    
    return frame
end

-- Создание переключателей
CreateToggle(MainFrame, "👮 Sheriff ESP", 50, true, "ShowSheriff")
CreateToggle(MainFrame, "🔪 Murderer ESP", 100, true, "ShowMurderer")
CreateToggle(MainFrame, "👤 Innocent ESP", 150, false, "ShowInnocent")

-- Кнопка цвета
local ColorBtn = Instance.new("TextButton")
ColorBtn.Size = UDim2.new(0.8, 0, 0, 40)
ColorBtn.Position = UDim2.new(0.1, 0, 0, 200)
ColorBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ColorBtn.Text = "🎨 Сменить цвет ESP"
ColorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorBtn.TextScaled = true
ColorBtn.Font = Enum.Font.GothamBold
ColorBtn.Parent = MainFrame

local ColorCorner = Instance.new("UICorner")
ColorCorner.CornerRadius = UDim.new(0, 8)
ColorCorner.Parent = ColorBtn

local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 100, 255),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(255, 0, 255),
    Color3.fromRGB(0, 255, 255)
}
local colorIndex = 1

ColorBtn.MouseButton1Click:Connect(function()
    colorIndex = colorIndex % #colors + 1
    Settings.ESPColor = colors[colorIndex]
end)

-- Кнопка открытия GUI (плавающая для телефона)
local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(0.85, 0, 0.9, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
OpenButton.BackgroundTransparency = 0.2
OpenButton.Image = "rbxassetid://3926305904" -- Иконка глаза
OpenButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

-- Тень для кнопки
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1.1, 0, 1.1, 0)
Shadow.Position = UDim2.new(-0.05, 0, -0.05, 0)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5028857085"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.Parent = OpenButton

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Сделать кнопку перетаскиваемой на телефоне
local dragging = false
local dragStart, startPos

OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = OpenButton.Position
    end
end)

OpenButton.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        OpenButton.Position = UDim2.new(
            startPos.X.Scale + delta.X / OpenButton.AbsoluteSize.X * 0.5,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale + delta.Y / OpenButton.AbsoluteSize.Y * 0.5,
            startPos.Y.Offset + delta.Y
        )
    end
end)

OpenButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ESP система
local ESPObjects = {}

local function createESP(player)
    if ESPObjects[player] then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP_" .. player.Name
    esp.Size = UDim2.new(0, 60, 0, 30)
    esp.Adornee = player.Character and player.Character:FindFirstChild("Head")
    esp.AlwaysOnTop = true
    esp.StudsOffset = Vector3.new(0, 1.5, 0)
    esp.Parent = player.Character and player.Character:FindFirstChild("Head")
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 0.4
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = esp
    
    local border = Instance.new("UICorner")
    border.CornerRadius = UDim.new(0, 6)
    border.Parent = label
    
    ESPObjects[player] = {
        Gui = esp,
        Label = label
    }
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if not ESPObjects[player] then
                createESP(player)
            end
            
            local role = player:FindFirstChild("Role")
            local isSheriff = role and role.Value == "Sheriff"
            local isMurderer = role and role.Value == "Murderer"
            
            local show = false
            local color = Settings.ESPColor
            local text = player.Name
            
            if isSheriff and Settings.ShowSheriff then
                show = true
                color = Color3.fromRGB(0, 150, 255)
                text = "👮 " .. player.Name
            elseif isMurderer and Settings.ShowMurderer then
                show = true
                color = Color3.fromRGB(255, 0, 0)
                text = "🔪 " .. player.Name
            elseif Settings.ShowInnocent and not isSheriff and not isMurderer then
                show = true
                color = Color3.fromRGB(100, 255, 100)
                text = "👤 " .. player.Name
            end
            
            local esp = ESPObjects[player]
            if esp then
                esp.Gui.Enabled = show
                if show then
                    esp.Label.Text = text
                    esp.Label.TextColor3 = color
                end
            end
        end
    end
end

-- Очистка ESP при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player].Gui:Destroy()
        ESPObjects[player] = nil
    end
end)

-- Обновление при смене персонажа
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if ESPObjects[player] then
            ESPObjects[player].Gui:Destroy()
            ESPObjects[player] = nil
        end
    end)
end)

-- Главный цикл обновления
RunService.RenderStepped:Connect(updateESP)

-- Инициализация
task.wait(1)
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        createESP(player)
    end
end

print("✅ MM2 ESP загружен! Нажми на кнопку с глазом для открытия меню.")
