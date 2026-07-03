-- Doors Mod Menu (С КНОПКОЙ ПРЫЖКА)
-- ВСТАВЛЯТЬ В LocalScript (StarterPlayerScripts или StarterGui)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "DoorsMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Переменные состояний
local brightOn = false
local thirdPersonOn = false
local highlightOn = false

-- === СОЗДАНИЕ МЕНЮ ===
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 320, 0, 370) -- Увеличил высоту для новой кнопки
menu.Position = UDim2.new(0.5, -160, 0.5, -185)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
menu.BackgroundTransparency = 0.1
menu.BorderSizePixel = 0
menu.Visible = false
menu.Active = true
menu.Draggable = true
menu.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
title.BackgroundTransparency = 0.3
title.Text = "DOORS MENU"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = menu

local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSans
    btn.BorderSizePixel = 0
    btn.Parent = menu
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- === КНОПКА ОТКРЫТИЯ МЕНЮ ===
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 70, 0, 70)
openButton.Position = UDim2.new(0.9, -85, 0.9, -85)
openButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
openButton.Text = "⚙️"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextScaled = true
openButton.Font = Enum.Font.SourceSansBold
openButton.BorderSizePixel = 0
openButton.Visible = true
openButton.Parent = gui
openButton.ZIndex = 10

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openButton

openButton.MouseEnter:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
end)
openButton.MouseLeave:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
end)

-- === КНОПКА ПРЫЖКА (ОТДЕЛЬНАЯ, ВСЕГДА НА ЭКРАНЕ) ===
local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0, 80, 0, 80)
jumpButton.Position = UDim2.new(0.1, 0, 0.85, 0) -- Левый нижний угол
jumpButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
jumpButton.Text = "🦘"
jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpButton.TextScaled = true
jumpButton.Font = Enum.Font.SourceSansBold
jumpButton.BorderSizePixel = 0
jumpButton.Visible = true
jumpButton.Parent = gui
jumpButton.ZIndex = 10

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(1, 0)
jumpCorner.Parent = jumpButton

-- Эффект наведения
jumpButton.MouseEnter:Connect(function()
    jumpButton.BackgroundColor3 = Color3.fromRGB(255, 220, 80)
    jumpButton.Size = UDim2.new(0, 85, 0, 85)
end)
jumpButton.MouseLeave:Connect(function()
    jumpButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    jumpButton.Size = UDim2.new(0, 80, 0, 80)
end)

-- Функция прыжка
local function jump()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        -- Проверяем, что персонаж на земле и может прыгнуть
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid.Jump = true
        end
    end
end

-- Нажатие на кнопку прыжка
jumpButton.MouseButton1Click:Connect(jump)

-- Дополнительно: прыжок по клавише Space (для ПК)
mouse.KeyDown:Connect(function(key)
    if key == " " then
        jump()
    end
end)

-- === ФУНКЦИИ ===

-- 1. Яркость
local function toggleBrightness()
    brightOn = not brightOn
    local lighting = game:GetService("Lighting")
    
    if brightOn then
        lighting.Brightness = 3
        lighting.Ambient = Color3.fromRGB(180, 180, 180)
        lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        lighting.EnvironmentDiffuseScale = 1
        lighting.EnvironmentSpecularScale = 1
    else
        lighting.Brightness = 1.5
        lighting.Ambient = Color3.fromRGB(80, 80, 80)
        lighting.OutdoorAmbient = Color3.fromRGB(80, 80, 80)
        lighting.EnvironmentDiffuseScale = 0.8
        lighting.EnvironmentSpecularScale = 0.8
    end
end

-- 2. Третий вид
local camConnection = nil
local function toggleThirdPerson()
    thirdPersonOn = not thirdPersonOn
    local cam = workspace.CurrentCamera
    
    if thirdPersonOn then
        cam.CameraType = Enum.CameraType.Scriptable
        if camConnection then camConnection:Disconnect() end
        camConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local pos = root.Position + root.CFrame.LookVector * -7 + Vector3.new(0, 4, 0)
                cam.CFrame = CFrame.new(pos, root.Position + Vector3.new(0, 1.5, 0))
            end
        end)
    else
        if camConnection then
            camConnection:Disconnect()
            camConnection = nil
        end
        cam.CameraType = Enum.CameraType.Custom
    end
end

-- 3. Подсветка предметов
local function isTargetItem(obj)
    if not obj then return false end
    
    local name = obj.Name:lower()
    
    local targetNames = {
        "coin", "coins", "монета", "монеты",
        "lighter", "зажигалка",
        "flashlight", "flash light", "фонарик", "фонарь",
        "lockpick", "lock pick", "отмычка",
        "alarm", "alarm clock", "будильник", "часы",
        "clock", "timer"
    }
    
    for _, target in ipairs(targetNames) do
        if name:find(target) then
            return true
        end
    end
    
    local parent = obj.Parent
    if parent then
        local parentName = parent.Name:lower()
        for _, target in ipairs(targetNames) do
            if parentName:find(target) then
                return true
            end
        end
    end
    
    if obj:IsA("Tool") or obj:FindFirstAncestorOfClass("Tool") then
        return true
    end
    
    return false
end

local function toggleHighlight()
    highlightOn = not highlightOn
    
    for _, h in ipairs(workspace:GetDescendants()) do
        if h:IsA("Highlight") then
            h:Destroy()
        end
    end
    
    if highlightOn then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local isPlayer = obj:FindFirstAncestorOfClass("Model") and obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")
                if not isPlayer then
                    if isTargetItem(obj) then
                        if obj:IsA("Model") then
                            for _, part in ipairs(obj:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    local h = Instance.new("Highlight")
                                    h.Name = "ItemHighlight"
                                    h.FillColor = Color3.fromRGB(0, 255, 200)
                                    h.FillTransparency = 0.3
                                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    h.OutlineTransparency = 0.2
                                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    h.Parent = part
                                end
                            end
                        elseif obj:IsA("BasePart") then
                            local h = Instance.new("Highlight")
                            h.Name = "ItemHighlight"
                            h.FillColor = Color3.fromRGB(0, 255, 200)
                            h.FillTransparency = 0.3
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            h.OutlineTransparency = 0.2
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            h.Parent = obj
                        end
                    end
                end
            end
        end
        
        if not _G.highlightConnection then
            _G.highlightConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if highlightOn then
                    if not _G.lastScan or tick() - _G.lastScan > 0.5 then
                        _G.lastScan = tick()
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if (obj:IsA("BasePart") or obj:IsA("Model")) and not obj:FindFirstChild("ItemHighlight") then
                                local isPlayer = obj:FindFirstAncestorOfClass("Model") and obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")
                                if not isPlayer and isTargetItem(obj) then
                                    if obj:IsA("Model") then
                                        for _, part in ipairs(obj:GetDescendants()) do
                                            if part:IsA("BasePart") and not part:FindFirstChild("ItemHighlight") then
                                                local h = Instance.new("Highlight")
                                                h.Name = "ItemHighlight"
                                                h.FillColor = Color3.fromRGB(0, 255, 200)
                                                h.FillTransparency = 0.3
                                                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                                                h.OutlineTransparency = 0.2
                                                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                                h.Parent = part
                                            end
                                        end
                                    elseif obj:IsA("BasePart") and not obj:FindFirstChild("ItemHighlight") then
                                        local h = Instance.new("Highlight")
                                        h.Name = "ItemHighlight"
                                        h.FillColor = Color3.fromRGB(0, 255, 200)
                                        h.FillTransparency = 0.3
                                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                                        h.OutlineTransparency = 0.2
                                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                        h.Parent = obj
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    else
        if _G.highlightConnection then
            _G.highlightConnection:Disconnect()
            _G.highlightConnection = nil
        end
        for _, h in ipairs(workspace:GetDescendants()) do
            if h:IsA("Highlight") then
                h:Destroy()
            end
        end
    end
end

-- === ФУНКЦИИ ОТКРЫТИЯ/ЗАКРЫТИЯ ===
local function closeMenu()
    menu.Visible = false
    openButton.Visible = true
end

local function openMenu()
    menu.Visible = true
    openButton.Visible = false
end

-- === КНОПКИ МЕНЮ ===
createButton("☀️ Яркость", 50, toggleBrightness)
createButton("🎥 Третий вид", 100, toggleThirdPerson)
createButton("🔦 Подсветка предметов", 150, toggleHighlight)
createButton("❌ Закрыть", 200, closeMenu)

-- === СОБЫТИЯ ===
openButton.MouseButton1Click:Connect(openMenu)

mouse.KeyDown:Connect(function(key)
    if key == "f" then
        if menu.Visible then
            closeMenu()
        else
            openMenu()
        end
    end
end)

-- Сохраняем яркость
game:GetService("RunService").Heartbeat:Connect(function()
    if brightOn then
        local lighting = game:GetService("Lighting")
        if lighting.Brightness < 2.5 then
            lighting.Brightness = 3
            lighting.Ambient = Color3.fromRGB(180, 180, 180)
            lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        end
    end
end)

print("✅ Мод-меню загружен! Добавлена кнопка прыжка 🦘")
