-- DOORS ULTRA Premium Menu + Mobile Support (FIXED)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ===== НАСТРОЙКИ =====
local settings = {
    Fullbright = true,
    FullbrightBrightness = 2,
    FullbrightTime = 12,
    JumpPower = 150,
    ESP = true,
    ESPColor = Color3.fromRGB(255, 200, 50),
    ESPDistance = 350,
    ESPTextSize = 40,
    MenuOpen = true
}

-- ===== ФИКС ГОЛОВЫ =====
local function fixHead()
    local char = LocalPlayer.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        head.LocalTransparencyModifier = 0
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("BasePart") or child:IsA("MeshPart") then
                child.Transparency = 0
                child.LocalTransparencyModifier = 0
            end
        end
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if (part:IsA("BasePart") or part:IsA("MeshPart")) and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 0
            part.LocalTransparencyModifier = 0
        end
    end
end

RunService.RenderStepped:Connect(fixHead)

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Head")
    task.wait(0.1)
    fixHead()
end)

workspace.CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function()
    task.wait(0.1)
    fixHead()
end)

-- ===== FULLBRIGHT =====
local Lighting = game:GetService("Lighting")

local function applyFullbright()
    if not settings.Fullbright then return end
    Lighting.Brightness = settings.FullbrightBrightness or 2
    Lighting.ClockTime = settings.FullbrightTime or 12
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.ExposureCompensation = 0.5
    Lighting.Technology = Enum.Technology.Compatibility
end

RunService.RenderStepped:Connect(function()
    if settings.Fullbright then applyFullbright() end
end)

Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
    if settings.Fullbright then applyFullbright() end
end)

-- ===== СОЗДАНИЕ GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DOORS_Premium"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false -- Важно для телефона!

-- ===== БОЛЬШАЯ МОБИЛЬНАЯ КНОПКА (ВСЕГДА ВИДИМА) =====
local mobileButton = Instance.new("TextButton")
mobileButton.Size = UDim2.new(0, 75, 0, 75)
mobileButton.Position = UDim2.new(0.03, 0, 0.85, 0)
mobileButton.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
mobileButton.BackgroundTransparency = 0.1
mobileButton.Text = "≡"
mobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mobileButton.TextScaled = true
mobileButton.Font = Enum.Font.GothamBold
mobileButton.TextSize = 40
mobileButton.BorderSizePixel = 0
mobileButton.Visible = true -- ВСЕГДА ВИДИМА!
mobileButton.Parent = screenGui

-- Скругление
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = mobileButton

-- Неоновая обводка
local btnGlow = Instance.new("Frame")
btnGlow.Size = UDim2.new(1, 8, 1, 8)
btnGlow.Position = UDim2.new(0, -4, 0, -4)
btnGlow.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
btnGlow.BackgroundTransparency = 0.4
btnGlow.BorderSizePixel = 0
local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(1, 0)
glowCorner.Parent = btnGlow
btnGlow.Parent = mobileButton

-- Тень
local btnShadow = Instance.new("Frame")
btnShadow.Size = UDim2.new(1, 0, 1, 0)
btnShadow.Position = UDim2.new(0, 0, 0, 5)
btnShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btnShadow.BackgroundTransparency = 0.3
btnShadow.BorderSizePixel = 0
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(1, 0)
shadowCorner.Parent = btnShadow
btnShadow.Parent = mobileButton
btnShadow.ZIndex = 0

-- Текст "MENU" под кнопкой
local menuLabel = Instance.new("TextLabel")
menuLabel.Size = UDim2.new(0, 75, 0, 20)
menuLabel.Position = UDim2.new(0.03, 0, 0.85, 75)
menuLabel.BackgroundTransparency = 1
menuLabel.Text = "MENU"
menuLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
menuLabel.TextScaled = true
menuLabel.Font = Enum.Font.GothamBold
menuLabel.TextStrokeTransparency = 0.3
menuLabel.Visible = true
menuLabel.Parent = screenGui

-- ===== ПУЛЬСАЦИЯ КНОПКИ =====
local btnTween = TweenService:Create(mobileButton, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    BackgroundTransparency = 0.05,
    Size = UDim2.new(0, 80, 0, 80)
})
btnTween:Play()

-- ===== ГЛАВНЫЙ КОНТЕЙНЕР =====
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 500)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = true -- Всегда открыто для теста
mainFrame.Parent = screenGui

-- Эффект стекла
local glassEffect = Instance.new("Frame")
glassEffect.Size = UDim2.new(1, 0, 1, 0)
glassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassEffect.BackgroundTransparency = 0.95
glassEffect.BorderSizePixel = 0
glassEffect.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = mainFrame

-- Неоновая обводка
local glowBorder = Instance.new("Frame")
glowBorder.Size = UDim2.new(1, 4, 1, 4)
glowBorder.Position = UDim2.new(0, -2, 0, -2)
glowBorder.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
glowBorder.BackgroundTransparency = 0.6
glowBorder.BorderSizePixel = 0
local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 22)
borderCorner.Parent = glowBorder
glowBorder.Parent = mainFrame

local glowTween = TweenService:Create(glowBorder, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.2})
glowTween:Play()

-- ===== ЗАГОЛОВОК =====
local titleGradient = Instance.new("Frame")
titleGradient.Size = UDim2.new(1, 0, 0, 60)
titleGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleGradient.BackgroundTransparency = 1
titleGradient.Parent = mainFrame

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
})
grad.Rotation = 45
grad.Parent = titleGradient

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "✦ DOORS PRO ✦"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.3
title.Parent = titleGradient

local line = Instance.new("Frame")
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 60)
line.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
line.BackgroundTransparency = 0.3
line.Parent = mainFrame

-- ===== ФУНКЦИЯ СОЗДАНИЯ МОДУЛЯ =====
local function createModule(parent, yPos, labelText, icon, getter, setter, settingsCallback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.Position = UDim2.new(0, 0, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local settingsFrame = Instance.new("Frame")
    settingsFrame.Size = UDim2.new(1, 0, 0, 0)
    settingsFrame.Position = UDim2.new(0, 0, 0, 50)
    settingsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    settingsFrame.BackgroundTransparency = 0.9
    settingsFrame.BorderSizePixel = 0
    settingsFrame.ClipsDescendants = true
    settingsFrame.Parent = container
    
    local settingsCorner = Instance.new("UICorner")
    settingsCorner.CornerRadius = UDim.new(0, 8)
    settingsCorner.Parent = settingsFrame
    
    local mainRow = Instance.new("Frame")
    mainRow.Size = UDim2.new(1, 0, 0, 50)
    mainRow.BackgroundTransparency = 1
    mainRow.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. labelText
    label.TextColor3 = Color3.fromRGB(230, 230, 250)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.GothamMedium
    label.Parent = mainRow

    -- Кнопка настроек
    local menuBtn = Instance.new("TextButton")
    menuBtn.Size = UDim2.new(0, 30, 0, 30)
    menuBtn.Position = UDim2.new(0.68, 0, 0.5, -15)
    menuBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    menuBtn.BackgroundTransparency = 0.5
    menuBtn.Text = ""
    menuBtn.BorderSizePixel = 0
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 6)
    menuCorner.Parent = menuBtn
    menuBtn.Parent = mainRow
    
    for i = 1, 3 do
        local stripe = Instance.new("Frame")
        stripe.Size = UDim2.new(0, 16, 0, 2)
        stripe.Position = UDim2.new(0.5, -8, 0, 6 + (i-1) * 7)
        stripe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        stripe.BackgroundTransparency = 0.3
        stripe.BorderSizePixel = 0
        local stripeCorner = Instance.new("UICorner")
        stripeCorner.CornerRadius = UDim.new(1, 0)
        stripeCorner.Parent = stripe
        stripe.Parent = menuBtn
    end
    
    local settingsOpen = false
    
    menuBtn.MouseButton1Click:Connect(function()
        settingsOpen = not settingsOpen
        local targetHeight = settingsOpen and 120 or 0
        TweenService:Create(settingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, 0, 0, targetHeight)
        }):Play()
        
        local stripes = {}
        for _, child in ipairs(menuBtn:GetChildren()) do
            if child:IsA("Frame") then table.insert(stripes, child) end
        end
        
        if settingsOpen then
            TweenService:Create(stripes[1], TweenInfo.new(0.3), {
                Position = UDim2.new(0.5, -8, 0, 14),
                Rotation = 45
            }):Play()
            TweenService:Create(stripes[2], TweenInfo.new(0.3), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(stripes[3], TweenInfo.new(0.3), {
                Position = UDim2.new(0.5, -8, 0, 14),
                Rotation = -45
            }):Play()
        else
            TweenService:Create(stripes[1], TweenInfo.new(0.3), {
                Position = UDim2.new(0.5, -8, 0, 6),
                Rotation = 0
            }):Play()
            TweenService:Create(stripes[2], TweenInfo.new(0.3), {
                BackgroundTransparency = 0.3
            }):Play()
            TweenService:Create(stripes[3], TweenInfo.new(0.3), {
                Position = UDim2.new(0.5, -8, 0, 20),
                Rotation = 0
            }):Play()
        end
        
        if settingsCallback then
            settingsCallback(settingsFrame, settingsOpen)
        end
    end)

    -- Переключатель
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 55, 0, 30)
    toggleBg.Position = UDim2.new(0.88, 0, 0.5, -15)
    toggleBg.BackgroundColor3 = getter() and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    toggleBg.BorderSizePixel = 0
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = toggleBg
    toggleBg.Parent = mainRow

    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 24, 0, 24)
    toggleCircle.Position = getter() and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    toggleCircle.Parent = toggleBg

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleBg

    toggleBtn.MouseButton1Click:Connect(function()
        local newVal = not getter()
        setter(newVal)
        
        local targetColor = newVal and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        local targetPos = newVal and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
        
        TweenService:Create(toggleBg, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = targetPos}):Play()
        
        if newVal and labelText == "Fullbright" then applyFullbright() end
    end)
    
    return container, settingsFrame
end

-- ===== НАСТРОЙКИ FULLBRIGHT =====
local function createFullbrightSettings(parent)
    local brightnessLabel = Instance.new("TextLabel")
    brightnessLabel.Size = UDim2.new(0.8, 0, 0.3, 0)
    brightnessLabel.Position = UDim2.new(0, 10, 0, 5)
    brightnessLabel.BackgroundTransparency = 1
    brightnessLabel.Text = "Brightness: " .. settings.FullbrightBrightness
    brightnessLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    brightnessLabel.TextXAlignment = Enum.TextXAlignment.Left
    brightnessLabel.TextScaled = true
    brightnessLabel.Font = Enum.Font.GothamLight
    brightnessLabel.Parent = parent
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.85, 0, 0, 4)
    sliderBg.Position = UDim2.new(0.07, 0, 0.4, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    sliderBg.BorderSizePixel = 0
    local slidCorner = Instance.new("UICorner")
    slidCorner.CornerRadius = UDim.new(0, 2)
    slidCorner.Parent = sliderBg
    sliderBg.Parent = parent
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((settings.FullbrightBrightness - 0.5) / 3.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
    fill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = fill
    fill.Parent = sliderBg
    
    local grab = Instance.new("TextButton")
    grab.Size = UDim2.new(0, 14, 0, 14)
    grab.Position = UDim2.new((settings.FullbrightBrightness - 0.5) / 3.5, -7, 0.5, -7)
    grab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    grab.Text = ""
    grab.BorderSizePixel = 0
    local grabCorner = Instance.new("UICorner")
    grabCorner.CornerRadius = UDim.new(1, 0)
    grabCorner.Parent = grab
    grab.Parent = sliderBg
    
    local dragging = false
    grab.MouseButton1Down:Connect(function() dragging = true end)
    grab.MouseButton1Up:Connect(function() dragging = false end)
    grab.MouseLeave:Connect(function() dragging = false end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local w = sliderBg.AbsoluteSize.X
            local val = math.clamp(pos / w * 4 + 0.5, 0.5, 4)
            settings.FullbrightBrightness = val
            fill.Size = UDim2.new((val - 0.5) / 3.5, 0, 1, 0)
            grab.Position = UDim2.new((val - 0.5) / 3.5, -7, 0.5, -7)
            brightnessLabel.Text = "Brightness: " .. string.format("%.1f", val)
            applyFullbright()
        end
    end)
end

-- ===== СОЗДАНИЕ МОДУЛЕЙ =====
createModule(mainFrame, 65, "Fullbright", "💡", 
    function() return settings.Fullbright end,
    function(v) settings.Fullbright = v if v then applyFullbright() end end,
    function(parent, open)
        if open then
            for _, child in ipairs(parent:GetChildren()) do child:Destroy() end
            createFullbrightSettings(parent)
        end
    end
)

createModule(mainFrame, 120, "ESP Book", "📖",
    function() return settings.ESP end,
    function(v) 
        settings.ESP = v 
        if not v and espHandle then espHandle:Destroy() espHandle = nil end
    end,
    function(parent, open)
        if open then
            for _, child in ipairs(parent:GetChildren()) do child:Destroy() end
            
            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(0.8, 0, 0.3, 0)
            distLabel.Position = UDim2.new(0, 10, 0, 5)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = "Distance: " .. settings.ESPDistance
            distLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
            distLabel.TextXAlignment = Enum.TextXAlignment.Left
            distLabel.TextScaled = true
            distLabel.Font = Enum.Font.GothamLight
            distLabel.Parent = parent
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(0.85, 0, 0, 4)
            sliderBg.Position = UDim2.new(0.07, 0, 0.4, 0)
            sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            sliderBg.BorderSizePixel = 0
            local slidCorner = Instance.new("UICorner")
            slidCorner.CornerRadius = UDim.new(0, 2)
            slidCorner.Parent = sliderBg
            sliderBg.Parent = parent
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((settings.ESPDistance - 50) / 450, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
            fill.BorderSizePixel = 0
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 2)
            fillCorner.Parent = fill
            fill.Parent = sliderBg
            
            local grab = Instance.new("TextButton")
            grab.Size = UDim2.new(0, 14, 0, 14)
            grab.Position = UDim2.new((settings.ESPDistance - 50) / 450, -7, 0.5, -7)
            grab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            grab.Text = ""
            grab.BorderSizePixel = 0
            local grabCorner = Instance.new("UICorner")
            grabCorner.CornerRadius = UDim.new(1, 0)
            grabCorner.Parent = grab
            grab.Parent = sliderBg
            
            local dragging = false
            grab.MouseButton1Down:Connect(function() dragging = true end)
            grab.MouseButton1Up:Connect(function() dragging = false end)
            grab.MouseLeave:Connect(function() dragging = false end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = input.Position.X - sliderBg.AbsolutePosition.X
                    local w = sliderBg.AbsoluteSize.X
                    local val = math.clamp(math.round(pos / w * 450 + 50), 50, 500)
                    settings.ESPDistance = val
                    fill.Size = UDim2.new((val - 50) / 450, 0, 1, 0)
                    grab.Position = UDim2.new((val - 50) / 450, -7, 0.5, -7)
                    distLabel.Text = "Distance: " .. val
                    if espHandle then espHandle:Destroy() espHandle = nil end
                end
            end)
        end
    end
)

-- ===== СЛАЙДЕР JUMP POWER =====
local function createSlider(parent, yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 65)
    container.Position = UDim2.new(0, 0, 0, yPos)
    container.BackgroundTransp
