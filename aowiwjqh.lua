-- MM2 ULTRA MODERN WALL ESP + NEON GUI
-- Murder Mystery 2 | Mobile Optimized

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки
local Settings = {
    ShowSheriff = true,
    ShowMurderer = true,
    ShowInnocent = false,
    ShowDistance = true,
    ESPColor = Color3.fromRGB(255, 255, 255)
}

-- === СОЗДАНИЕ ГЛАВНОГО GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_ModernESP"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Главный контейнер с анимацией
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 520)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 25)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Стеклянный эффект (Glassmorphism)
local GlassBg = Instance.new("Frame")
GlassBg.Size = UDim2.new(1, 0, 1, 0)
GlassBg.Position = UDim2.new(0, 0, 0, 0)
GlassBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlassBg.BackgroundTransparency = 0.92
GlassBg.BorderSizePixel = 0
GlassBg.Parent = MainFrame

-- Размытие фона (Blur)
local Blur = Instance.new("BlurEffect")
Blur.Size = 15
Blur.Parent = MainFrame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 24)
Corner.Parent = MainFrame

-- Неоновая обводка (Glow Border)
local GlowBorder = Instance.new("Frame")
GlowBorder.Size = UDim2.new(1, 4, 1, 4)
GlowBorder.Position = UDim2.new(0, -2, 0, -2)
GlowBorder.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
GlowBorder.BackgroundTransparency = 0.6
GlowBorder.BorderSizePixel = 0
GlowBorder.Parent = MainFrame

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0, 26)
GlowCorner.Parent = GlowBorder

-- Анимированный градиентный заголовок
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 65)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(25, 20, 50)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 24)
HeaderCorner.Parent = Header

-- Градиент для заголовка
local Gradient = Instance.new("UIGradient")
Gradient.Rotation = 45
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 50, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 150, 255))
})
Gradient.Parent = Header

-- Логотип/иконка
local Icon = Instance.new("TextLabel")
Icon.Size = UDim2.new(0, 40, 0, 40)
Icon.Position = UDim2.new(0, 15, 0.5, -20)
Icon.BackgroundTransparency = 1
Icon.Text = "🎯"
Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
Icon.TextScaled = true
Icon.Font = Enum.Font.GothamBold
Icon.Parent = Header

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 65, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "WALL ESP PRO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

-- Подзаголовок
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0.7, 0, 0.4, 0)
SubTitle.Position = UDim2.new(0, 65, 0.6, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Murder Mystery 2"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 200)
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.Gotham
SubTitle.Parent = Header

-- Кнопка закрытия с анимацией
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 42, 0, 42)
CloseBtn.Position = UDim2.new(1, -52, 0.5, -21)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 400, 0, 520)
    end)
end)

-- Создание современных переключателей (Toggle Switch)
local function createModernToggle(parent, text, icon, yPos, default, settingKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -30, 0, 55)
    frame.Position = UDim2.new(0, 15, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
    frame.BackgroundTransparency = 0.4
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 14)
    frameCorner.Parent = frame
    
    -- Иконка
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 35, 0, 35)
    iconLabel.Position = UDim2.new(0, 12, 0.5, -17.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextScaled = true
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.Parent = frame
    
    -- Текст
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 55, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    -- Современный Toggle Switch
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 55, 0, 30)
    toggleBg.Position = UDim2.new(0.85, 0, 0.5, -15)
    toggleBg.BackgroundColor3 = default and Color3.fromRGB(80, 40, 200) or Color3.fromRGB(50, 50, 70)
    toggleBg.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg
    
    -- Круглый ползунок
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 24, 0, 24)
    toggleCircle.Position = default and UDim2.new(0, 27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.Parent = toggleBg
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    -- Тень для кружка
    local circleShadow = Instance.new("Frame")
    circleShadow.Size = UDim2.new(1.2, 0, 1.2, 0)
    circleShadow.Position = UDim2.new(-0.1, 0, -0.1, 0)
    circleShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    circleShadow.BackgroundTransparency = 0.3
    circleShadow.Parent = toggleCircle
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(1, 0)
    shadowCorner.Parent = circleShadow
    
    local isOn = default
    
    -- Клик по переключателю
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.Position = UDim2.new(0, 0, 0, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleBg
    
    toggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        Settings[settingKey] = isOn
        
        -- Анимация переключения
        local targetColor = isOn and Color3.fromRGB(80, 40, 200) or Color3.fromRGB(50, 50, 70)
        local targetPos = isOn and UDim2.new(0, 27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
        
        TweenService:Create(toggleBg, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = targetColor
        }):Play()
        
        TweenService:Create(toggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = targetPos
        }):Play()
    end)
    
    return frame
end

-- Создание переключателей
createModernToggle(MainFrame, "Sheriff ESP", "👮", 80, true, "ShowSheriff")
createModernToggle(MainFrame, "Murderer ESP", "🔪", 145, true, "ShowMurderer")
createModernToggle(MainFrame, "Innocent ESP", "👤", 210, false, "ShowInnocent")
createModernToggle(MainFrame, "Show Distance", "📏", 275, true, "ShowDistance")

-- Панель выбора цвета (современная)
local ColorPanel = Instance.new("Frame")
ColorPanel.Size = UDim2.new(1, -30, 0, 60)
ColorPanel.Position = UDim2.new(0, 15, 0, 345)
ColorPanel.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
ColorPanel.BackgroundTransparency = 0.4
ColorPanel.Parent = MainFrame

local ColorCorner = Instance.new("UICorner")
ColorCorner.CornerRadius = UDim.new(0, 14)
ColorCorner.Parent = ColorPanel

local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(0.4, 0, 1, 0)
ColorLabel.Position = UDim2.new(0, 15, 0, 0)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "🎨 Цвет ESP"
ColorLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
ColorLabel.TextScaled = true
ColorLabel.Font = Enum.Font.GothamBold
ColorLabel.Parent = ColorPanel

-- Палитра цветов (кружки)
local colors = {
    Color3.fromRGB(255, 50, 50),
    Color3.fromRGB(50, 255, 50),
    Color3.fromRGB(50, 150, 255),
    Color3.fromRGB(255, 255, 50),
    Color3.fromRGB(255, 50, 255),
    Color3.fromRGB(50, 255, 255),
    Color3.fromRGB(255, 150, 50)
}

local colorIndex = 1

for i, color in ipairs(colors) do
    local circle = Instance.new("TextButton")
    circle.Size = UDim2.new(0, 32, 0, 32)
    circle.Position = UDim2.new(0.4 + (i-1) * 0.085, 0, 0.5, -16)
    circle.BackgroundColor3 = color
    circle.BorderSizePixel = 0
    circle.Text = ""
    circle.Parent = ColorPanel
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    -- Обводка для выбранного цвета
    if i == 1 then
        local border = Instance.new("Frame")
        border.Size = UDim2.new(1.25, 0, 1.25, 0)
        border.Position = UDim2.new(-0.125, 0, -0.125, 0)
        border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        border.BackgroundTransparency = 0.5
        border.BorderSizePixel = 0
        border.Parent = circle
        
        local borderCorner = Instance.new("UICorner")
        borderCorner.CornerRadius = UDim.new(1, 0)
        borderCorner.Parent = border
    end
    
    circle.MouseButton1Click:Connect(function()
        colorIndex = i
        Settings.ESPColor = color
        
        -- Обновить обводку
        for _, child in pairs(ColorPanel:GetChildren()) do
            if child:IsA("TextButton") and child ~= circle then
                for _, grandchild in pairs(child:GetChildren()) do
                    if grandchild:IsA("Frame") then
                        grandchild:Destroy()
                    end
                end
            end
        end
        
        local border = Instance.new("Frame")
        border.Size = UDim2.new(1.25, 0, 1.25, 0)
        border.Position = UDim2.new(-0.125, 0, -0.125, 0)
        border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        border.BackgroundTransparency = 0.5
        border.BorderSizePixel = 0
        border.Parent = circle
        
        local borderCorner = Instance.new("UICorner")
        borderCorner.CornerRadius = UDim.new(1, 0)
        borderCorner.Parent = border
    end)
end

-- Кнопка сброса
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(1, -30, 0, 50)
ResetBtn.Position = UDim2.new(0, 15, 0, 420)
ResetBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
ResetBtn.BackgroundTransparency = 0.3
ResetBtn.Text = "🔄 Сбросить настройки"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextScaled = true
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.Parent = MainFrame

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 14)
ResetCorner.Parent = ResetBtn

ResetBtn.MouseButton1Click:Connect(function()
    Settings.ShowSheriff = true
    Settings.ShowMurderer = true
    Settings.ShowInnocent = false
    Settings.ShowDistance = true
    Settings.ESPColor = Color3.fromRGB(255, 255, 255)
    colorIndex = 1
    
    -- Перезагружаем интерфейс
    MainFrame.Visible = false
    task.wait(0.1)
    MainFrame.Visible = true
end)

-- === КНОПКА ОТКРЫТИЯ (СУПЕР СОВРЕМЕННАЯ) ===
local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.new(0, 70, 0, 70)
OpenButton.Position = UDim2.new(0.82, 0, 0.86, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(80, 40, 200)
OpenButton.BackgroundTransparency = 0.1
OpenButton.Image = "rbxassetid://3926305904"
OpenButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Parent = ScreenGui

-- Неоновое свечение кнопки
local NeonGlow = Instance.new("Frame")
NeonGlow.Size = UDim2.new(1.3, 0, 1.3, 0)
NeonGlow.Position = UDim2.new(-0.15, 0, -0.15, 0)
NeonGlow.BackgroundColor3 = Color3.fromRGB(120, 50, 255)
NeonGlow.BackgroundTransparency = 0.7
NeonGlow.BorderSizePixel = 0
NeonGlow.Parent = OpenButton

local NeonCorner = Instance.new("UICorner")
NeonCorner.CornerRadius = UDim.new(1, 0)
NeonCorner.Parent = NeonGlow

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

-- Анимация кнопки
local pulseTween
local function animateButton()
    pulseTween = TweenService:Create(OpenButton, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Size = UDim2.new(0, 72, 0, 72)
    })
    pulseTween:Play()
end
animateButton()

OpenButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            MainFrame.Visible = false
            MainFrame.Size = UDim2.new(0, 400, 0, 520)
        end)
    else
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 400, 0, 520)
        }):Play()
    end
end)

-- Перетаскивание кнопки
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

-- === WALL ESP СИСТЕМА ===
local ESPObjects = {}

local function createESP(player)
    if ESPObjects[player] then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "WallESP_" .. player.Name
    esp.Size = UDim2.new(0, 200, 0, 70)
    esp.Adornee = player.Character and player.Character:FindFirstChild("Head")
    esp.AlwaysOnTop = true
    esp.StudsOffset = Vector3.new(0, 3, 0)
    esp.Parent = player.Character and player.Character:FindFirstChild("Head")
    
    -- Стеклянный фон
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.4
    bg.Parent = esp
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 12)
    bgCorner.Parent = bg
    
    -- Неоновая обводка ESP
    local espGlow = Instance.new("Frame")
    espGlow.Size = UDim2.new(1.05, 0, 1.1, 0)
    espGlow.Position = UDim2.new(-0.025, 0, -0.05, 0)
    espGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    espGlow.BackgroundTransparency = 0.6
    espGlow.BorderSizePixel = 0
    espGlow.Parent = bg
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 14)
    glowCorner.Parent = espGlow
    
    -- Имя
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.45, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = esp
    
    -- Роль (крупно)
    local roleLabel = Instance.new("TextLabel")
    roleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    roleLabel.Position = UDim2.new(0, 0, 0.45, 0)
    roleLabel.BackgroundTransparency = 1
    roleLabel.Text = "❓"
    roleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    roleLabel.TextScaled = true
    roleLabel.Font = Enum.Font.GothamBold
    roleLabel.Parent = esp
    
    -- Дистанция
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0.6, 0, 0.25, 0)
    distLabel.Position = UDim2.new(0.2, 0, 0.7, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = ""
    distLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = esp
    
    -- Линия-индикатор
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 3, 0, 60)
    line.Position = UDim2.new(0.5, -1.5, 1, 5)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BackgroundTransparency = 0.3
    line.Parent = esp
    
    ESPObjects[player] = {
        Gui = esp,
        NameLabel = nameLabel,
        RoleLabel = roleLabel,
        DistLabel = distLabel,
        Line = line,
        Bg = bg,
        Glow = espGlow
    }
end

local function getRoleText(player)
    local role = player:FindFirstChild("Role")
    if not role then return "❓" end
    
    local roleValue = role.Value
    if roleValue == "Sheriff" then
        return "👮 ШЕРИФ"
    elseif roleValue == "Murderer" then
        return "🔪 УБИЙЦА"
    elseif roleValue == "Innocent" then
        return "👤 НЕВИНОВНЫЙ"
    else
        return "❓"
    end
end

local function updateESP()
    local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localPos then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local char = player.Character
        if not char then continue end
        
        local head = char:FindFirstChild("Head")
        if not head then continue end
        
        if not ESPObjects[player] then
            createESP(player)
        end
        
        local esp = ESPObjects[player]
        if not esp then continue end
        
        local role = player:FindFirstChild("Role")
        local isSheriff = role and role.Value == "Sheriff"
        local isMurderer = role and role.Value == "Murderer"
        
        local show = false
        local color = Settings.ESPColor
        local roleText = getRoleText(player)
        
        if isMurderer and Settings.ShowMurderer then
          
