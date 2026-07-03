--[[
    DOORS - Fullbright, JumpPower & ESP Book
    ВСТАВЛЯЙ В КЛИЕНТСКИЙ СКРИПТ (LocalScript) в StarterPlayerScripts
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- НАСТРОЙКИ
local FULLBRIGHT = true
local JUMP_POWER = 150       -- стандарт 50
local ESP_BOOK = true
local ESP_COLOR = Color3.fromRGB(255, 200, 50)

-- ===== FULLBRIGHT =====
if FULLBRIGHT then
    local Lighting = game:GetService("Lighting")
    Lighting.Brightness = 2
    Lighting.ClockTime = 12
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(255,255,255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
end

-- ===== JUMP =====
if JUMP_POWER then
    LocalPlayer.CharacterAdded:Connect(function(char)
        local hrp = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        hum.JumpPower = JUMP_POWER
    end)
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = JUMP_POWER end
    end
end

-- ===== ESP BOOK =====
if ESP_BOOK then
    local bookModel = nil
    local espHandle = nil

    local function findBook()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:lower():find("book") then
                local primary = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("Handle")
                if primary then
                    return obj, primary
                end
            end
        end
        return nil, nil
    end

    local function createESP(part)
        if espHandle then espHandle:Destroy() end

        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0, 80, 0, 30)
        bill.StudsOffset = Vector3.new(0, 2, 0)
        bill.AlwaysOnTop = true
        bill.MaxDistance = 300
        bill.Parent = part

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "📖 BOOK"
        label.TextColor3 = ESP_COLOR
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = bill

        espHandle = bill
    end

    local function updateESP()
        local book, primary = findBook()
        if book and primary and primary.Parent then
            if not espHandle or espHandle.Parent ~= primary then
                createESP(primary)
            end
            -- обновляем позицию (привязка уже к part)
        else
            if espHandle then
                espHandle:Destroy()
                espHandle = nil
            end
        end
    end

    -- проверка каждые 0.5 сек
    game:GetService("RunService").Heartbeat:Connect(function()
        if not bookModel or not bookModel.Parent then
            updateESP()
        end
    end)

    -- дополнительно при изменении workspace
    workspace.DescendantAdded:Connect(updateESP)
    workspace.DescendantRemoved:Connect(updateESP)
end

print("✅ DOORS скрипт загружен: Fullbright + Jump + ESP Book")
