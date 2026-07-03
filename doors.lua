--[[
    НАЗВАНИЕ: Doors Ultimate Mod Menu
    ВЕРСИЯ: 1.0
    ОПИСАНИЕ: Мод-меню с функциями яркости, 3-го лица и подсветки предметов.
    УСТАНОВКА: Вставьте в свой клиентский скрипт (LocalScript) в StarterPlayerScripts.
    УПРАВЛЕНИЕ: Нажмите [F] для открытия/закрытия меню.
]]

-- Создаём основной ScreenGui
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "DoorsModMenu"
gui.Parent = player:WaitForChild("PlayerGui")

-- Стили (современный тёмный дизайн)
local theme = {
    bg = Color3.fromRGB(25, 25, 30),
    frame = Color3.fromRGB(40, 40, 50),
    text = Color3.fromRGB(255, 255, 255),
    accent = Color3.fromRGB(80, 180, 255),
    toggleOn = Color3.fromRGB(0, 200, 100),
    toggleOff = Color3.fromRGB(200, 50, 50),
    font = Enum.Font.SourceSansBold
}

-- Главное окно (изначально скрыто)
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 380, 0, 420)
menuFrame.Position = UDim2.new(0.5, -190, 0.5, -210)
menuFrame.BackgroundColor3 = theme.bg
menuFrame.BackgroundTransparency = 0.1
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Parent = gui

-- Углы закругления (через UIGradient, но проще сделать Corner)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = menuFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = theme.accent
title.BackgroundTransparency = 0.2
title.Text = "⟡ DOORS MOD MENU ⟡"
title.TextColor3 = theme.text
title.TextScaled = true
title.Font = theme.font
title.Parent = menuFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Скроллинг-контейнер для опций
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -80)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundColor3 = theme.frame
scroll.BackgroundTransparency = 0.3
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 380) -- под 5 опций
scroll.ScrollBarThickness = 4
scroll.Parent = menuFrame
local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scroll

-- Функция создания переключателя
local function createToggle(parent, yPos, labelText, defaultState, onChange)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.Position = UDim2.new(0, 5, 0, yPos)
    frame.BackgroundColor3 = theme.frame
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = theme.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = theme.font
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 60, 0, 30)
    toggle.Position = UDim2.new(0.85, -30, 0.5, -15)
    toggle.BackgroundColor3 = defaultState and theme.toggleOn or theme.toggleOff
    toggle.Text = defaultState and "ON" or "OFF"
    toggle.TextColor3 = theme.text
    toggle.TextScaled = true
    toggle.Font = theme.font
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 20)
    toggleCorner.Parent = toggle

    local state = defaultState
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and theme.toggleOn or theme.toggleOff
        toggle.Text = state and "ON" or "OFF"
        if onChange then onChange(state) end
    end)

    return { getState = function() return state end }
end

-- === ФУНКЦИОНАЛ ===

-- 1. ЯРКОСТЬ (изменяем Ambient + Brightness)
local function setBrightness(value)
    local lighting = game:GetService("Lighting")
    lighting.Brightness = value and 3 or 1.5
    lighting.Ambient = value and Color3.fromRGB(180, 180, 180) or Color3.fromRGB(80, 80, 80)
    -- Дополнительно: меняем цвет неба для эффекта
    if value then
        lighting.EnvironmentDiffuseScale = 1.2
        lighting.EnvironmentSpecularScale = 1.2
    else
        lighting.EnvironmentDiffuseScale = 0.8
        lighting.EnvironmentSpecularScale = 0.8
    end
end

-- 2. ВИД ОТ ТРЕТЬЕГО ЛИЦА (камера позади игрока)
local function setThirdPerson(enabled)
    local cam = game:GetService("Workspace").CurrentCamera
    if enabled then
        -- Сохраняем стандартный Zoom и смещаем камеру
        cam.CameraType = Enum.CameraType.Custom
        -- Каждое обновление камеры будем обрабатывать в степе
        if not _G.thirdPersonConnection then
            _G.thirdPersonConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if _G.thirdPersonEnabled then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local root = char.HumanoidRootPart
                        local lookVec = root.CFrame.LookVector
                        local pos = root.Position + lookVec * -8 + Vector3.new(0, 4, 0)
                        cam.CFrame = CFrame.new(pos, root.Position + Vector3.new(0, 1.5, 0))
                    end
                end
            end)
        end
        _G.thirdPersonEnabled = true
    else
        _G.thirdPersonEnabled = false
        if _G.thirdPersonConnection then
            _G.thirdPersonConnection:Disconnect()
            _G.thirdPersonConnection = nil
        end
        cam.CameraType = Enum.CameraType.Follow
    end
end

-- 3. ПОДСВЕТКА ПРЕДМЕТОВ ЧЕРЕЗ СТЕНЫ (Highlight)
local highlightFolder = Instance.new("Folder")
highlightFolder.Name = "ItemHighlights"
highlightFolder.Parent = workspace

local function setupHighlight(obj)
    if obj:IsA("BasePart") and obj:FindFirstChild("Highlight") then return end
    local h = Instance.new("Highlight")
    h.Name = "Highlight"
    h.FillColor = Color3.fromRGB(0, 255, 200)
    h.FillTransparency = 0.6
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.OutlineTransparency = 0.2
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
    h.Enabled = _G.highlightEnabled or false
end

-- Функция сканирования предметов (игнорируем стены, полы, мебель)
local function scanItems()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" and obj.Name ~= "Floor" and obj.Name ~= "Wall" then
            -- Проверяем, что объект не является частью игрока или мебелью
            local isPlayerPart = obj:FindFirstAncestorOfClass("Model") and obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")
            if not isPlayerPart then
                if not obj:FindFirstChild("Highlight") then
                    setupHighlight(obj)
                end
            end
        end
    end
end

local function setHighlights(enabled)
    _G.highlightEnabled = enabled
    -- Применяем ко всем существующим
    for _, obj in ipairs(workspace:GetDescendants()) do
        local h = obj:FindFirstChild("Highlight")
        if h then
            h.Enabled = enabled
        end
    end
    -- Если включили - сканируем новые предметы каждые 5 сек (можно и реже)
    if enabled then
        if not _G.highlightScanConnection then
            _G.highlightScanConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.highlightEnabled then
                    scanItems()
                end
            end)
        end
    else
        if _G.highlightScanConnection then
            _G.highlightScanConnection:Disconnect()
            _G.highlightScanConnection = nil
        end
    end
end

-- === СОЗДАНИЕ ОПЦИЙ В МЕНЮ ===
local y = 10
local toggles = {}

toggles[1] = createToggle(scroll, y, "☀️ Яркость (освещение)", false, function(state)
    setBrightness(state)
end)
y = y + 55

toggles[2] = createToggle(scroll, y, "🎥 Третий человек (камера)", false, function(state)
    setThirdPerson(state)
end)
y = y + 55

toggles[3] = createToggle(scroll, y, "🔦 Подсветка предметов", false, function(state)
    setHighlights(state)
end)
y = y + 55

-- (можно добавить ещё опций при желании)

-- === ОТКРЫТИЕ / ЗАКРЫТИЕ МЕНЮ ПО КЛАВИШЕ [F] ===
local menuOpen = false
mouse.KeyDown:Connect(function(key)
    if key == "f" then
        menuOpen = not menuOpen
        menuFrame.Visible = menuOpen
    end
end)

-- Первичное сканирование для подсветки (если включена по умолчанию - нет)
scanItems()

-- Небольшое сообщение в консоль
print("✅ Doors Mod Menu загружен! Нажми [F] для открытия.")
