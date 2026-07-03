local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local w = sliderBg.AbsoluteSize.X
            local val = math.clamp(math.round(pos / w * 250 + 10), 20, 260)
            settings.JumpPower = val
            fill.Size = UDim2.new((val - 20) / 230, 0, 1, 0)
            grab.Position = UDim2.new((val - 20) / 230, -9, 0.5, -9)
            label.Text = "⚡ Jump: " .. val

            if LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum.JumpPower = val end
            end
        end
    end)
end

createSlider(mainFrame, 155)

-- ПЕРЕТАСКИВАНИЕ
local drag = false
local dragStart, framePos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        drag = true
        dragStart = input.Position
        framePos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        drag = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            framePos.X.Scale, 
            framePos.X.Offset + delta.X, 
            framePos.Y.Scale, 
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- ===== ESP =====
local espHandle = nil

local function findBook()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("book") then
            local primary = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("Handle")
            if primary then return obj, primary end
        end
    end
    return nil, nil
end

local function createESP(part)
    if espHandle then espHandle:Destroy() end
    if not settings.ESP then return end

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 80, 0, 30)
    bill.StudsOffset = Vector3.new(0, 2.5, 0)
    bill.AlwaysOnTop = true
    bill.MaxDistance = 300
    bill.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "📖 BOOK"
    label.TextColor3 = settings.ESPColor
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = bill

    espHandle = bill
end

local function updateESP()
    if not settings.ESP then
        if espHandle then espHandle:Destroy() espHandle = nil end
        return
    end
    local book, primary = findBook()
    if book and primary and primary.Parent then
        if not espHandle or espHandle.Parent ~= primary then
            createESP(primary)
        end
    else
        if espHandle then espHandle:Destroy() espHandle = nil end
    end
end

RunService.Heartbeat:Connect(updateESP)
workspace.DescendantAdded:Connect(updateESP)
workspace.DescendantRemoved:Connect(updateESP)

print("✅ DOORS Mobile PRO загружен!")
print("Скрипт запущен!")
wait(2)
print("Пробуем создать GUI...")
