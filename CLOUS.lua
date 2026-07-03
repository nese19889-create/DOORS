-- Doors Mod Menu (С ПОДДЕРЖКОЙ ТЕЛЕФОНА)
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
local menuVisible = false

-- === СОЗДАНИЕ МЕНЮ ===
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 320, 0, 320)
menu.Position = UDim2.new(0.5, -160, 0.5, -160)
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

-- === ФУНКЦИИ ===

-- 1. Яркость
local function toggleBrightness()
    brightOn = not brightOn
    local lighting = game:GetService("Lighting")
    if brightOn then
        lighting.Brightness = 3
        lighting.Ambient = Color3.fromRGB(180, 180, 180)
    else
        lighting.Brightness = 1.5
        lighting.Ambient = Color3.fromRGB(80, 80, 80)
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
local function toggleHighlight()
    highlightOn = not highlightOn
    
    local function highlightObject(obj)
        if obj:IsA("BasePart") and not obj:FindFirstChild("Highlight") then
            local h = Instance.new("Highlight")
            h.Name = "Highlight"
            h.FillColor = Color3.fromRGB(0, 255, 200)
            h.FillTransparency = 0.5
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = obj
            h.Enabled = highlightOn
        end
    end
    
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:FindFirstAncestorOfClass("Tool") then
            local isPlayer = part:FindFirstAncestorOfClass("Model") and part:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")
            if not isPlayer then
                highlightObject(part)
            end
        end
    end
    
    for _, h in ipairs(workspace:GetDescendants()) do
        if h:IsA("Highlight") then
            h.Enabled = highlightOn
        end
    end
end

-- === КНОПКИ МЕНЮ ===
createButton("☀️ Яркость", 50, toggleBrightness)
createButton("🎥 Третий вид", 100, toggleThirdPerson)
createButton("🔦 Подсветка", 150, toggleHighlight)
createButton("❌ Закрыть", 200, function()
    menu.Visible = false
    menuVisible = false
    openButton.Visible = true
end)

-- === КНОПКА ОТКРЫТИЯ МЕНЮ (ДЛЯ ТЕЛЕФОНА) ===
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 70, 0, 70)
openButton.Position = UDim2.new(0.9, -85, 0.9, -85) -- правый нижний угол
openButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
openButton.Text = "⚙️"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextScaled = true
openButton.Font = Enum.Font.SourceSansBold
openButton.BorderSizePixel = 0
openButton.Visible = true
openButton.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0) -- полностью круглый
openCorner.Parent = openButton

-- Эффект наведения (для ПК)
openButton.MouseEnter:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
end)
openButton.MouseLeave:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
end)

-- Открытие меню по кнопке
openButton.MouseButton1Click:Connect(function()
    menu.Visible = true
    menuVisible = true
    openButton.Visible = false
end)

-- === ОТКРЫТИЕ ПО F (ДЛЯ ПК) ===
mouse.KeyDown:Connect(function(key)
    if key == "f" then
        if menu.Visible then
            menu.Visible = false
            menuVisible = false
            openButton.Visible = true
        else
            menu.Visible = true
            menuVisible = true
            openButton.Visible = false
        end
    end
end)

print("✅ Мод-меню загружен! Нажми F на ПК или кнопку ⚙️ на телефоне")
