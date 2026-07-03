-- Doors Mod Menu (ТОЛЬКО ПРЕДМЕТЫ + ФИКС КНОПКИ)
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

-- 3. Подсветка ТОЛЬКО предметов
local function toggleHighlight()
    highlightOn = not highlightOn
    
    -- Очищаем старые подсветки
    for _, h in ipairs(workspace:GetDescendants()) do
        if h:IsA("Highlight") then
            h:Destroy()
        end
    end
    
    if highlightOn then
        -- Ищем ВСЕ предметы в игре
        local itemsToHighlight = {}
        
        for _, obj in ipairs(workspace:GetDescendants()) do
            local isItem = false
            
            if obj:IsA("Model") then
                local name = obj.Name:lower()
                if name:find("key") or 
                   name:find("battery") or 
                   name:find("lockpick") or 
                   name:find("vitamin") or 
                   name:find("bandage") or
                   name:find("medkit") or
                   name:find("flashlight") or
                   name:find("lighter") or
                   name:find("paper") or
                   name:find("book") or
                   name:find("chest") or
                   name:find("drawer") or
                   name:find("cabinet") or
                   name:find("shelf") or
                   name:find("item") or
                   name:find("pickup") or
                   name:find("tool") then
                    isItem = true
                end
                
                for _, part in ipairs(obj:GetDescendants()) do
                    if part:IsA("BasePart") and not part:FindFirstAncestorOfClass("Tool") then
                        if part.Name:lower():find("handle") or
                           part.Name:lower():find("head") or
                           part.Name:lower():find("body") then
                            isItem = true
                        end
                    end
                end
            end
            
            if obj:IsA("BasePart") and not obj:FindFirstAncestorOfClass("Tool") then
                local isPlayer = obj:FindFirstAncestorOfClass("Model") and obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")
                local name = obj.Name:lower()
                
                if not isPlayer and 
                   not name:find("wall") and 
                   not name:find("floor") and 
                   not name:find("ground") and
                   not name:find("roof") and
                   not name:find("ceiling") and
                   not name:find("door") and
                   not name:find("window") then
                    
                    local size = obj.Size
                    if size.X < 5 and size.Y < 5 and size.Z < 5 then
                        isItem = true
                    end
                end
            end
            
            if isItem then
                local target = obj
                if obj:IsA("Model") then
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("BasePart") then
                            local h = Instance.new("Highlight")
                            h.Name = "ItemHighlight"
                            h.FillColor = Color3.fromRGB(0, 255, 200)
                            h.FillTransparency = 0.4
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            h.OutlineTransparency = 0.3
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            h.Parent = part
                        end
                    end
                elseif obj:IsA("BasePart") then
                    local h = Instance.new("Highlight")
                    h.Name = "ItemHighlight"
                    h.FillColor = Color3.fromRGB(0, 255, 200)
                    h.FillTransparency = 0.4
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.OutlineTransparency = 0.3
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent = obj
                end
            end
        end
        
        if not _G.highlightConnection then
            _G.highlightConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if highlightOn then
                    if not _G.lastScan or tick() - _G.lastScan > 1 then
                        _G.lastScan = tick()
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and not obj:FindFirstChild("ItemHighlight") then
                                local isPlayer = obj:FindFirstAncestorOfClass("Model") and obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")
                                local name = obj.Name:lower()
                                
                                if not isPlayer and 
                                   not name:find("wall") and 
                                   not name:find("floor") and 
                                   not name:find("ground") and
                                   not name:find("roof") and
                                   not name:find("ceiling") and
                                   not name:find("door") and
                                   not name:find("window") then
                                    
                                    local size = obj.Size
                                    if size.X < 5 and size.Y < 5 and size.Z < 5 then
                                        local h = Instance.new("Highlight")
                                        h.Name = "ItemHighlight"
                                        h.FillColor = Color3.fromRGB(0, 255, 200)
                                        h.FillTransparency = 0.4
                                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                                        h.OutlineTransparency = 0.3
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

-- Функция закрытия меню (кнопка открытия НЕ пропадает)
local function closeMenu()
    menu.Visible = false
    menuVisible = false
    openButton.Visible = true -- ПОКАЗЫВАЕМ КНОПКУ ОТКРЫТИЯ
end

-- === КНОПКИ МЕНЮ ===
createButton("☀️ Яркость", 50, toggleBrightness)
createButton("🎥 Третий вид", 100, toggleThirdPerson)
createButton("🔦 Подсветка предметов", 150, toggleHighlight)
createButton("❌ Закрыть", 200, closeMenu) -- Используем новую функцию

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

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openButton

openButton.MouseEnter:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
end)
openButton.MouseLeave:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
end)

openButton.MouseButton1Click:Connect(function()
    menu.Visible = true
    menuVisible = true
    openButton.Visible = false -- Скрываем только при открытии меню
end)

-- === ОТКРЫТИЕ ПО F ===
mouse.KeyDown:Connect(function(key)
    if key == "f" then
        if menu.Visible then
            closeMenu() -- Используем ту же функцию
        else
            menu.Visible = true
            menuVisible = true
            openButton.Visible = false
        end
    end
end)

print("✅ Мод-меню загружен! Кнопка открытия не пропадает при закрытии")
