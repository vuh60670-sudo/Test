Local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Gửi thông báo khi load script
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Maxu Office Hub",
        Text = "Banana tuổi lồn, maru one top",
        Duration = 5
    })
end)

-- ================= 1. HIỆU ỨNG AURA XANH ================= --
local function applyHighlight(char)
    if not char then return end
    if char:FindFirstChild("MaxuAura") then char.MaxuAura:Destroy() end
    local hl = Instance.new("Highlight")
    hl.Name = "MaxuAura"
    hl.FillColor = Color3.fromRGB(0, 180, 150)
    hl.FillTransparency = 0.4
    hl.OutlineColor = Color3.fromRGB(50, 255, 200)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char
end
if LocalPlayer.Character then applyHighlight(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(applyHighlight)

-- ================= 2. KHỞI TẠO UI ================= --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MaxuOfficeHubFull"
ScreenGui.ResetOnSpawn = false
if pcall(function() ScreenGui.Parent = CoreGui end) then else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- AVATAR ICON (THU NHỎ)
local AvatarIcon = Instance.new("ImageButton", ScreenGui)
AvatarIcon.Size = UDim2.new(0, 50, 0, 50) 
AvatarIcon.Position = UDim2.new(0.5, -37, 0.05, 0)
AvatarIcon.Image = "rbxassetid://138691340576184"
AvatarIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarIcon.Visible = false
AvatarIcon.Active = true
AvatarIcon.Draggable = true
Instance.new("UICorner", AvatarIcon).CornerRadius = UDim.new(1, 0)
local AvaStroke = Instance.new("UIStroke", AvatarIcon)
AvaStroke.Thickness = 3

-- KHUNG CHÍNH
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(60, 60, 60)
Stroke.Thickness = 1

-- TOPBAR
local Topbar = Instance.new("Frame", MainFrame)
Topbar.Size = UDim2.new(1, 0, 0, 30)
Topbar.BackgroundTransparency = 1
local TitleLabel = Instance.new("TextLabel", Topbar)
TitleLabel.Size = UDim2.new(1, -60, 1, 0); TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1; TitleLabel.Text = "Banana tuổi lồn, maru one top"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200); TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextSize = 12; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
local MinBtn = Instance.new("TextButton", Topbar)
MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.BackgroundTransparency = 1; MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 12

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; AvatarIcon.Visible = true end)
AvatarIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true; AvatarIcon.Visible = false end)

-- SIDEBAR TRÁI
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -30); Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundTransparency = 1
local TabIndicator = Instance.new("Frame", Sidebar)
TabIndicator.Size = UDim2.new(0, 3, 0, 20); TabIndicator.Position = UDim2.new(0, 10, 0, 10)
TabIndicator.BackgroundColor3 = Color3.fromRGB(43, 196, 255)
Instance.new("UICorner", TabIndicator).CornerRadius = UDim.new(1, 0)
local MainTab = Instance.new("TextLabel", Sidebar)
MainTab.Size = UDim2.new(1, -20, 0, 30); MainTab.Position = UDim2.new(0, 20, 0, 5)
MainTab.BackgroundTransparency = 1; MainTab.Text = "Hub Features"
MainTab.TextColor3 = Color3.fromRGB(255, 255, 255); MainTab.Font = Enum.Font.GothamMedium
MainTab.TextSize = 13; MainTab.TextXAlignment = Enum.TextXAlignment.Left

-- KHUNG NỘI DUNG CHÍNH
local Content = Instance.new("ScrollingFrame", MainFrame)
Content.Size = UDim2.new(1, -140, 1, -40); Content.Position = UDim2.new(0, 140, 0, 35)
Content.BackgroundTransparency = 1; Content.BorderSizePixel = 0
Content.ScrollBarThickness = 6; Content.CanvasSize = UDim2.new(0, 0, 0, 700)

local UIList = Instance.new("UIListLayout", Content)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

-- Hàm tạo Menu Component
local function createToggle(name, desc, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50); frame.BackgroundTransparency = 1; frame.LayoutOrder = order
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.7, 0, 0.5, 0); lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local dsc = Instance.new("TextLabel", frame)
    dsc.Size = UDim2.new(0.7, 0, 0.5, 0); dsc.Position = UDim2.new(0, 0, 0.5, 0); dsc.BackgroundTransparency = 1
    dsc.Text = desc; dsc.TextColor3 = Color3.fromRGB(130, 130, 130)
    dsc.Font = Enum.Font.Gotham; dsc.TextSize = 11; dsc.TextXAlignment = Enum.TextXAlignment.Left
    local btnBg = Instance.new("TextButton", frame)
    btnBg.Size = UDim2.new(0, 40, 0, 20); btnBg.Position = UDim2.new(1, -50, 0.5, -10)
    btnBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60); btnBg.Text = ""
    Instance.new("UICorner", btnBg).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", btnBg)
    dot.Size = UDim2.new(0, 14, 0, 14); dot.Position = UDim2.new(0, 3, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    return frame, btnBg, dot
end

local function createSeparator(order)
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -20, 0, 1); sep.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sep.BorderSizePixel = 0; sep.LayoutOrder = order
    return sep
end

-- TẠO MENU CHỨC NĂNG
local _, AutoGoldBtn, AutoGoldDot = createToggle("Auto Farm Gold", "Tele qua mốc -> Chết -> Lặp", 1)
AutoGoldBtn.Parent.Parent = Content; createSeparator(2).Parent = Content

local _, AutoFarmBtn, AutoFarmDot = createToggle("Auto Farm Chest", "Bay đến mốc cuối -> Đợi tele -> Lặp", 3)
AutoFarmBtn.Parent.Parent = Content; createSeparator(4).Parent = Content

local _, FlyBtn, FlyDot = createToggle("Boat Fly Engine", "Chỉ bay khi ngồi ghế lái/xe người khác", 5)
FlyBtn.Parent.Parent = Content

local _, AutoFwdBtn, AutoFwdDot = createToggle("Auto Forward (Tự chạy)", "Tự động đẩy Tàu chạy thẳng", 6)
AutoFwdBtn.Parent.Parent = Content; createSeparator(7).Parent = Content

local _, AntiAfkBtn, AntiAfkDot = createToggle("Anti AFK", "Ngăn Roblox kick khi treo", 8)
AntiAfkBtn.Parent.Parent = Content; createSeparator(9).Parent = Content

-- THANH KÉO TỐC ĐỘ (GLOBAL SPEED)
local SpeedFrame = Instance.new("Frame", Content)
SpeedFrame.Size = UDim2.new(1, -20, 0, 50); SpeedFrame.BackgroundTransparency = 1; SpeedFrame.LayoutOrder = 10
local SPLabel = Instance.new("TextLabel", SpeedFrame)
SPLabel.Size = UDim2.new(0.4, 0, 0.5, 0); SPLabel.BackgroundTransparency = 1; SPLabel.Text = "Global Speed"
SPLabel.TextColor3 = Color3.fromRGB(255, 255, 255); SPLabel.Font = Enum.Font.GothamMedium; SPLabel.TextSize = 14; SPLabel.TextXAlignment = Enum.TextXAlignment.Left
local SpeedValue = Instance.new("TextLabel", SpeedFrame)
SpeedValue.Size = UDim2.new(0, 40, 1, 0); SpeedValue.Position = UDim2.new(0.4, 0, 0, 0); SpeedValue.BackgroundTransparency = 1
SpeedValue.Text = "200"; SpeedValue.TextColor3 = Color3.fromRGB(180, 180, 180); SpeedValue.Font = Enum.Font.Gotham; SpeedValue.TextSize = 12
local SliderBg = Instance.new("TextButton", SpeedFrame)
SliderBg.Size = UDim2.new(0.45, 0, 0, 4); SliderBg.Position = UDim2.new(0.55, 0, 0.5, -2)
SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60); SliderBg.Text = ""
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)
local SliderFill = Instance.new("Frame", SliderBg)
SliderFill.Size = UDim2.new(0.1, 0, 1, 0); SliderFill.BackgroundColor3 = Color3.fromRGB(43, 196, 255)
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
local SliderKnob = Instance.new("Frame", SliderFill)
SliderKnob.Size = UDim2.new(0, 12, 0, 12); SliderKnob.Position = UDim2.new(1, -6, 0.5, -6); SliderKnob.BackgroundColor3 = Color3.fromRGB(43, 196, 255)
Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

createSeparator(11).Parent = Content

-- THANH KÉO CHỈNH DELAY TELEPORT (TELEPORT DELAY SLIDER)
local DelayFrame = Instance.new("Frame", Content)
DelayFrame.Size = UDim2.new(1, -20, 0, 50); DelayFrame.BackgroundTransparency = 1; DelayFrame.LayoutOrder = 12
local DPLabel = Instance.new("TextLabel", DelayFrame)
DPLabel.Size = UDim2.new(0.4, 0, 0.5, 0); DPLabel.BackgroundTransparency = 1; DPLabel.Text = "Teleport Delay (Auto Gold)"
DPLabel.TextColor3 = Color3.fromRGB(255, 255, 255); DPLabel.Font = Enum.Font.GothamMedium; DPLabel.TextSize = 14; DPLabel.TextXAlignment = Enum.TextXAlignment.Left
local DelayValue = Instance.new("TextLabel", DelayFrame)
DelayValue.Size = UDim2.new(0, 40, 1, 0); DelayValue.Position = UDim2.new(0.4, 0, 0, 0); DelayValue.BackgroundTransparency = 1
DelayValue.Text = "0.5s"; DelayValue.TextColor3 = Color3.fromRGB(180, 180, 180); DelayValue.Font = Enum.Font.Gotham; DelayValue.TextSize = 12
local DelaySliderBg = Instance.new("TextButton", DelayFrame)
DelaySliderBg.Size = UDim2.new(0.45, 0, 0, 4); DelaySliderBg.Position = UDim2.new(0.55, 0, 0.5, -2)
DelaySliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60); DelaySliderBg.Text = ""
Instance.new("UICorner", DelaySliderBg).CornerRadius = UDim.new(1, 0)
local DelaySliderFill = Instance.new("Frame", DelaySliderBg)
DelaySliderFill.Size = UDim2.new(0.25, 0, 1, 0); DelaySliderFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
Instance.new("UICorner", DelaySliderFill).CornerRadius = UDim.new(1, 0)
local DelaySliderKnob = Instance.new("Frame", DelaySliderFill)
DelaySliderKnob.Size = UDim2.new(0, 12, 0, 12); DelaySliderKnob.Position = UDim2.new(1, -6, 0.5, -6); DelaySliderKnob.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
Instance.new("UICorner", DelaySliderKnob).CornerRadius = UDim.new(1, 0)

createSeparator(13).Parent = Content

-- THANH KÉO TỐC ĐỘ BAY CHEST (Giới hạn Max = 1000)
local ChestSpeedFrame = Instance.new("Frame", Content)
ChestSpeedFrame.Size = UDim2.new(1, -20, 0, 50); ChestSpeedFrame.BackgroundTransparency = 1; ChestSpeedFrame.LayoutOrder = 14
local CSPLabel = Instance.new("TextLabel", ChestSpeedFrame)
CSPLabel.Size = UDim2.new(0.4, 0, 0.5, 0); CSPLabel.BackgroundTransparency = 1; CSPLabel.Text = "Chest Fly Speed"
CSPLabel.TextColor3 = Color3.fromRGB(255, 255, 255); CSPLabel.Font = Enum.Font.GothamMedium; CSPLabel.TextSize = 14; CSPLabel.TextXAlignment = Enum.TextXAlignment.Left
local ChestSpeedValue = Instance.new("TextLabel", ChestSpeedFrame)
ChestSpeedValue.Size = UDim2.new(0, 40, 1, 0); ChestSpeedValue.Position = UDim2.new(0.4, 0, 0, 0); ChestSpeedValue.BackgroundTransparency = 1
ChestSpeedValue.Text = "150"; ChestSpeedValue.TextColor3 = Color3.fromRGB(180, 180, 180); ChestSpeedValue.Font = Enum.Font.Gotham; ChestSpeedValue.TextSize = 12
local CSliderBg = Instance.new("TextButton", ChestSpeedFrame)
CSliderBg.Size = UDim2.new(0.45, 0, 0, 4); CSliderBg.Position = UDim2.new(0.55, 0, 0.5, -2)
CSliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60); CSliderBg.Text = ""
Instance.new("UICorner", CSliderBg).CornerRadius = UDim.new(1, 0)
local CSliderFill = Instance.new("Frame", CSliderBg)
CSliderFill.Size = UDim2.new(0.15, 0, 1, 0); CSliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", CSliderFill).CornerRadius = UDim.new(1, 0)
local CSliderKnob = Instance.new("Frame", CSliderFill)
CSliderKnob.Size = UDim2.new(0, 12, 0, 12); CSliderKnob.Position = UDim2.new(1, -6, 0.5, -6); CSliderKnob.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", CSliderKnob).CornerRadius = UDim.new(1, 0)

local PGStatus = Instance.new("TextLabel", Content)
PGStatus.Size = UDim2.new(1, -20, 0, 30); PGStatus.LayoutOrder = 15; PGStatus.BackgroundTransparency = 1
PGStatus.Text = "Status: Idle"; PGStatus.TextColor3 = Color3.fromRGB(130, 130, 130)
PGStatus.Font = Enum.Font.Gotham; PGStatus.TextSize = 12; PGStatus.TextXAlignment = Enum.TextXAlignment.Left

-- ================= 3. FLOATING JOYSTICK ================= --
local joyBg = Instance.new("Frame", ScreenGui)
joyBg.Size = UDim2.new(0, 110, 0, 110); joyBg.Position = UDim2.new(0.04, 0, 0.55, 0)
joyBg.BackgroundColor3 = Color3.fromRGB(10, 10, 15); joyBg.BackgroundTransparency = 0.4
Instance.new("UICorner", joyBg).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", joyBg).Color = Color3.fromRGB(100, 100, 120)
local joyKnob = Instance.new("Frame", joyBg)
joyKnob.Size = UDim2.new(0, 45, 0, 45); joyKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
joyKnob.AnchorPoint = Vector2.new(0.5, 0.5); joyKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
Instance.new("UICorner", joyKnob).CornerRadius = UDim.new(1, 0)

local joyV = Vector2.zero; local currentTouchID = nil
joyBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then currentTouchID = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == currentTouchID then
        local pos = input.Position; local center = joyBg.AbsolutePosition + (joyBg.AbsoluteSize / 2)
        local delta = Vector2.new(pos.X, pos.Y) - center; local radius = joyBg.AbsoluteSize.X / 2
        if delta.Magnitude > radius then delta = delta.Unit * radius end
        joyKnob.Position = UDim2.new(0.5, delta.X, 0.5, delta.Y); joyV = delta / radius
    end
end)
UserInputService.InputEnded:Connect(function(input) if input == currentTouchID then currentTouchID = nil; joyV = Vector2.zero; joyKnob.Position = UDim2.new(0.5, 0, 0.5, 0) end end)

-- ================= 4. LOGIC HỆ THỐNG ================= --
local isAutoGold, isAutoFarming, isFlying, isAutoFwd, isAntiAfk = false, false, false, false, false
local currentSpeed = 200
local chestSpeed = 150 
local teleportDelay = 0.5 
local noclipLoop, bv, bg

local GoldWaypoints = {
    Vector3.new(-81.4, 96.2, 861.8), Vector3.new(-55.3, 78.3, 1490.3), Vector3.new(-117.7, 35.5, 2204.7),
    Vector3.new(-3.9, 94.4, 2981.0), Vector3.new(-45.4, 69.4, 5305.0), Vector3.new(-6.0, 77.8, 6005.7),
    Vector3.new(-27.8, 77.7, 7053.6), Vector3.new(-22.9, 67.1, 8368.5), Vector3.new(-44.7, -92.1, 8815.0)
}

local ChestWaypoints = {
    Vector3.new(26.9, 34.8, 351.0), Vector3.new(26.9, 34.8, 351.0), Vector3.new(23.4, 40.1, 395.5),
    Vector3.new(13.5, 63.3, 604.0), Vector3.new(-14.2, 69.9, 811.8), Vector3.new(-33.1, 56.7, 1005.4),
    Vector3.new(-52.5, 40.0, 1198.7), Vector3.new(-55.9, 41.1, 1392.9), Vector3.new(-55.0, 45.2, 1437.7),
    Vector3.new(-55.0, 45.2, 1437.7), Vector3.new(-54.1, 47.4, 1542.7), Vector3.new(-42.5, 45.2, 1692.2),
    Vector3.new(-33.5, 42.8, 1841.8), Vector3.new(-38.4, 40.2, 2006.7), Vector3.new(-41.8, 37.9, 2156.6),
    Vector3.new(-37.5, 36.8, 2276.5), Vector3.new(-31.5, 35.9, 2441.4), Vector3.new(-25.5, 40.0, 2606.2),
    Vector3.new(-26.3, 44.7, 2786.1), Vector3.new(-35.4, 49.0, 2950.8), Vector3.new(-44.2, 52.9, 3100.5),
    Vector3.new(-47.6, 57.6, 3280.4), Vector3.new(-42.8, 62.7, 3475.2), Vector3.new(-31.0, 66.6, 3624.6),
    Vector3.new(10.1, 71.3, 3799.5), Vector3.new(61.9, 70.5, 3938.2), Vector3.new(31.4, 63.2, 4080.6),
    Vector3.new(31.4, 63.2, 4080.6), Vector3.new(-16.2, 56.6, 4190.1), Vector3.new(-28.2, 54.0, 4233.4),
    Vector3.new(-54.1, 50.6, 4441.2), Vector3.new(-74.0, 54.0, 4544.2), Vector3.new(-74.0, 54.0, 4544.2),
    Vector3.new(-73.0, 60.8, 4694.0), Vector3.new(-58.2, 68.3, 4858.1), Vector3.new(-44.3, 70.6, 5037.5),
    Vector3.new(-41.6, 64.5, 5217.2), Vector3.new(-51.4, 63.3, 5396.9), Vector3.new(-56.8, 64.1, 5591.8),
    Vector3.new(-38.5, 56.8, 5755.4), Vector3.new(-23.6, 37.3, 5933.5), Vector3.new(-38.8, 21.1, 6081.8),
    Vector3.new(-38.8, 21.1, 6081.7), Vector3.new(-36.1, 25.5, 6186.6), Vector3.new(-30.3, 32.5, 6351.3),
    Vector3.new(-38.9, 40.8, 6545.9), Vector3.new(-50.1, 49.0, 6740.4), Vector3.new(-50.3, 53.4, 6845.3),
    Vector3.new(-48.9, 54.7, 6875.2), Vector3.new(-32.5, 60.9, 7054.4), Vector3.new(-18.3, 56.6, 7218.7),
    Vector3.new(-14.7, 49.2, 7383.5), Vector3.new(-6.2, 41.8, 7548.0), Vector3.new(3.0, 44.5, 7727.6),
    Vector3.new(13.1, 53.5, 7922.1), Vector3.new(4.3, 63.2, 8131.5), Vector3.new(-11.4, 69.4, 8325.6),
    Vector3.new(-7.1, 74.7, 8535.4), Vector3.new(-4.5, 78.0, 8670.4), Vector3.new(-4.6, 77.9, 8670.5),
    Vector3.new(-4.6, 77.9, 8670.6), Vector3.new(-33.4, -25.1, 8775.8), Vector3.new(-36.6, -35.3, 8786.3),
    Vector3.new(-35.7, -153.9, 8958.5), Vector3.new(-29.3, -241.8, 9132.0), Vector3.new(-25.6, -297.5, 9318.7),
    Vector3.new(-27.1, -314.4, 9376.2), Vector3.new(-27.1, -314.4, 9376.2), Vector3.new(-42.6, -324.3, 9417.3),
    Vector3.new(-42.6, -324.3, 9417.3), Vector3.new(-53.1, -334.9, 9459.8), Vector3.new(-53.1, -334.9, 9459.8),
    Vector3.new(-58.1, -342.0, 9488.5), Vector3.new(-58.1, -342.0, 9488.6), Vector3.new(-58.1, -342.0, 9488.6),
    Vector3.new(-58.1, -342.0, 9488.6), Vector3.new(-58.1, -346.7, 9488.4), Vector3.new(-58.1, -360.5, 9488.4),
    Vector3.new(-58.1, -360.4, 9488.4), Vector3.new(-58.1, -360.4, 9488.4)
}

local function updateAvatarStatus()
    -- Đã lược bỏ cập nhật text ON/OFF của AvatarIcon theo yêu cầu
end

local sliderDragging, delayDragging, chestSliderDragging = false, false, false

SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then sliderDragging = true end end)
SliderKnob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then sliderDragging = true end end)

DelaySliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then delayDragging = true end end)
DelaySliderKnob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then delayDragging = true end end)

CSliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then chestSliderDragging = true end end)
CSliderKnob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then chestSliderDragging = true end end)

UserInputService.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then 
        sliderDragging = false 
        delayDragging = false
        chestSliderDragging = false
    end 
end)

local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = hue + (dt * 0.3); if hue >= 1 then hue = 0 end; AvaStroke.Color = Color3.fromHSV(hue, 1, 1)
    
    if sliderDragging then
        local mousePos = UserInputService:GetMouseLocation().X
        local relative = math.clamp(mousePos - SliderBg.AbsolutePosition.X, 0, SliderBg.AbsoluteSize.X)
        local percent = relative / SliderBg.AbsoluteSize.X; SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        currentSpeed = math.floor(percent * 2000); if currentSpeed < 10 then currentSpeed = 10 end
        SpeedValue.Text = tostring(currentSpeed)
    end

    if delayDragging then
        local mousePos = UserInputService:GetMouseLocation().X
        local relative = math.clamp(mousePos - DelaySliderBg.AbsolutePosition.X, 0, DelaySliderBg.AbsoluteSize.X)
        local percent = relative / DelaySliderBg.AbsoluteSize.X; DelaySliderFill.Size = UDim2.new(percent, 0, 1, 0)
        teleportDelay = math.round((percent * 1.9 + 0.1) * 10) / 10 
        DelayValue.Text = tostring(teleportDelay) .. "s"
    end
    
    if chestSliderDragging then
        local mousePos = UserInputService:GetMouseLocation().X
        local relative = math.clamp(mousePos - CSliderBg.AbsolutePosition.X, 0, CSliderBg.AbsoluteSize.X)
        local percent = relative / CSliderBg.AbsoluteSize.X; CSliderFill.Size = UDim2.new(percent, 0, 1, 0)
        chestSpeed = math.floor(percent * 1000); if chestSpeed < 10 then chestSpeed = 10 end
        ChestSpeedValue.Text = tostring(chestSpeed)
    end
end)

local function animateToggle(bgUI, dotUI, state)
    if state then
        TweenService:Create(bgUI, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(43, 196, 255)}):Play()
        TweenService:Create(dotUI, TweenInfo.new(0.2), {Position = UDim2.new(1, -17, 0.5, -7), BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    else
        TweenService:Create(bgUI, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        TweenService:Create(dotUI, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end
    updateAvatarStatus()
end

local function ToggleNoclip(state)
    if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end
    if state then
        noclipLoop = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end
        end)
    end
end

-- Tween dùng riêng cho Auto Gold
local function tweenTo(hrp, targetPos)
    if not hrp then return end
    local timeVal = math.max(teleportDelay * 0.2, 0.15)
    local tween = TweenService:Create(hrp, TweenInfo.new(timeVal, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()
end

-- LOGIC AUTO GOLD
local function AutoGoldLoop()
    while isAutoGold do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
            local hrp = char.HumanoidRootPart
            for i = 1, 8 do
                if not isAutoGold then break end
                PGStatus.Text = "Status: Farm Gold ("..i.."/9)"
                tweenTo(hrp, GoldWaypoints[i])
                task.wait(teleportDelay)
            end
            if isAutoGold then
                PGStatus.Text = "Status: Claiming Reward..."
                tweenTo(hrp, GoldWaypoints[9])
                task.wait(2.0)
                
                PGStatus.Text = "Status: Resetting..."
                if char.Humanoid.Health > 0 then char.Humanoid.Health = 0 end
                repeat task.wait(0.5) until not isAutoGold or (LocalPlayer.Character and LocalPlayer.Character ~= char and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0)
                task.wait(2)
            end
        else
            task.wait(1)
        end
    end
end

-- LOGIC AUTO FARM CHEST (Đã fix nhả rương, chống rơi rớt hố)
local chestBv, chestBg
local function AutoFarmChestLoop()
    while isAutoFarming do
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp and hum and hum.Health > 0 then
            PGStatus.Text = "Status: Collecting Chests..."
            
            if not chestBv or chestBv.Parent ~= hrp then
                if chestBv then chestBv:Destroy() end
                if chestBg then chestBg:Destroy() end
                chestBv = Instance.new("BodyVelocity", hrp)
                chestBv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                chestBv.Velocity = Vector3.zero
                chestBg = Instance.new("BodyGyro", hrp)
                chestBg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                chestBg.P = 20000
                chestBg.D = 500
            end
            
            for i, pos in ipairs(ChestWaypoints) do
                if not isAutoFarming or not hrp.Parent or hum.Health <= 0 then break end
                
                local startTick = tick()
                while isAutoFarming and hrp.Parent and hum.Health > 0 do
                    local dist = (pos - hrp.Position).Magnitude
                    if dist <= 12 then break end 
                    
                    local dir = (pos - hrp.Position).Unit
                    local moveSpeed = math.min(chestSpeed, dist * 15)
                    
                    chestBv.Velocity = dir * moveSpeed 
                    chestBg.CFrame = CFrame.new(hrp.Position, pos)
                    
                    RunService.Heartbeat:Wait()
                    if tick() - startTick > 15 then break end 
                end
                
                -- KHI ĐẾN ĐIỂM CUỐI CÙNG (CHẠM RƯƠNG)
                if i == #ChestWaypoints and isAutoFarming and hrp.Parent and hum.Health > 0 then
                    PGStatus.Text = "Status: Reached End. Claiming Chest..."
                    
                    -- Dừng toàn bộ gia tốc ngay lập tức để không bị bay quá đà
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    
                    -- Hủy lực kéo lơ lửng để "thả ra"
                    if chestBv then chestBv:Destroy(); chestBv = nil end
                    if chestBg then chestBg:Destroy(); chestBg = nil end
                    
                    -- BƯỚC QUAN TRỌNG: Tạm tắt Noclip để nhân vật va chạm được với đất (Không bị rớt void)
                    ToggleNoclip(false)
                    
                    local waitStart = tick()
                    while isAutoFarming and hrp.Parent and hum.Health > 0 do
                        -- Chờ game xử lý nhận rương và Teleport nhân vật về khu vực ban đầu (Z < 1000)
                        if hrp.Position.Z < 1000 or (tick() - waitStart > 15) then
                            break
                        end
                        task.wait(0.5)
                    end
                    
                    -- Bật lại Noclip cho vòng lặp tiếp theo
                    if isAutoFarming then
                        ToggleNoclip(true)
                    end
                    task.wait(2) 
                end
            end
        else
            if chestBv then chestBv:Destroy(); chestBv = nil end
            if chestBg then chestBg:Destroy(); chestBg = nil end
            task.wait(1)
        end
    end
    -- Dọn dẹp nếu người dùng tắt nút
    if chestBv then chestBv:Destroy(); chestBv = nil end
    if chestBg then chestBg:Destroy(); chestBg = nil end
    ToggleNoclip(false)
end

AutoFarmBtn.MouseButton1Click:Connect(function()
    isAutoFarming = not isAutoFarming; animateToggle(AutoFarmBtn, AutoFarmDot, isAutoFarming)
    if isAutoFarming then ToggleNoclip(true); task.spawn(AutoFarmChestLoop) else PGStatus.Text = "Status: Idle"; if not isAutoGold then ToggleNoclip(false) end end
end)

LocalPlayer.Idled:Connect(function() if isAntiAfk then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)
AntiAfkBtn.MouseButton1Click:Connect(function() isAntiAfk = not isAntiAfk; animateToggle(AntiAfkBtn, AntiAfkDot, isAntiAfk) end)

local function getVehicleTarget()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.SeatPart then return hum.SeatPart.AssemblyRootPart or (hum.SeatPart.Parent and hum.SeatPart.Parent.PrimaryPart) or hum.SeatPart end
    return nil
end

FlyBtn.MouseButton1Click:Connect(function() isFlying = not isFlying; animateToggle(FlyBtn, FlyDot, isFlying) end)
AutoFwdBtn.MouseButton1Click:Connect(function() isAutoFwd = not isAutoFwd; animateToggle(AutoFwdBtn, AutoFwdDot, isAutoFwd) end)

RunService.RenderStepped:Connect(function()
    if isFlying then
        local target = getVehicleTarget()
        if target then
            if not bv or bv.Parent ~= target then
                if bv then bv:Destroy() end; if bg then bg:Destroy() end
                bv = Instance.new("BodyVelocity", target); bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bg = Instance.new("BodyGyro", target); bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9); bg.P = 20000; bg.D = 500
            end
            local cam = workspace.CurrentCamera; bg.CFrame = cam.CFrame
            local jx, jy = joyV.X, joyV.Y
            if math.abs(jx) < 0.15 then jx = 0 end; if math.abs(jy) < 0.15 then jy = 0 end
            local forwardInput = -jy
            if isAutoFwd and forwardInput == 0 then forwardInput = 1 end
            local moveDir = (cam.CFrame.RightVector * jx) + (cam.CFrame.LookVector * forwardInput)
            bv.Velocity = moveDir * currentSpeed
            if LocalPlayer.Character then for _, p in pairs(LocalPlayer.Character:GetChildren()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end end
        else
            if bv then bv:Destroy(); bv = nil end; if bg then bg:Destroy(); bg = nil end
        end
    else
        if bv then bv:Destroy(); bv = nil end; if bg then bg:Destroy(); bg = nil end
    end
end)
