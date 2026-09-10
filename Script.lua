------ ==========================================
-- MAXU HUB PREMIUM - [ TSB MAIN ] (ULTIMATE V30 - SMART VOID DRAG)
-- ==========================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local connections = {}

-- Safe gethui
local targetParent
local success, result = pcall(function() return gethui and gethui() or nil end)
targetParent = (success and result) and result or game:GetService("CoreGui") or PlayerGui

for _, v in pairs(targetParent:GetChildren()) do
    if v.Name == "MaxuHubPremium" then v:Destroy() end
end

local MaxuHub = Instance.new("ScreenGui")
MaxuHub.Name = "MaxuHubPremium"
MaxuHub.ResetOnSpawn = false
MaxuHub.Parent = targetParent

-- Cleanup
table.insert(connections, MaxuHub.AncestryChanged:Connect(function(_, parent)
    if not parent then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
        for _, conn in ipairs(connections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        table.clear(connections)
    end
end))

-- ==========================================
-- DRAGGABLE HELPER (OPTIMIZED UI ONLY)
-- ==========================================
local activeDragTarget = nil
local dragStartPos = Vector2.zero
local frameStartPos = UDim2.new()

local function MakeDraggable(frame)
    table.insert(connections, frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeDragTarget = frame
            dragStartPos = input.Position
            frameStartPos = frame.Position
        end
    end))
end

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        activeDragTarget = nil
    end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
    if not activeDragTarget then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartPos
        activeDragTarget.Position = UDim2.new(
            frameStartPos.X.Scale,
            frameStartPos.X.Offset + delta.X,
            frameStartPos.Y.Scale,
            frameStartPos.Y.Offset + delta.Y
        )
    end
end))

-- ==========================================
-- GIAO DIỆN CHÍNH
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 420)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = MaxuHub
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
MakeDraggable(MainFrame)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 300, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Maxu Hub Premium [ TSB Main V30 ]"
TitleText.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleText.Font = Enum.Font.GothamMedium
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.TextSize = 16
CloseBtn.Parent = TopBar
table.insert(connections, CloseBtn.MouseButton1Click:Connect(function() MaxuHub:Destroy() end))

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TopBar

local MiniButton = Instance.new("ImageButton")
MiniButton.Size = UDim2.new(0, 50, 0, 50)
MiniButton.Position = UDim2.new(0, 25, 0, 90) 
MiniButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MiniButton.Image = "rbxassetid://13206924887"
MiniButton.Visible = false
MiniButton.Active = true
MiniButton.Parent = MaxuHub
Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(1, 0)
local MiniStroke = Instance.new("UIStroke", MiniButton)
MiniStroke.Color = Color3.fromRGB(0, 170, 255)
MiniStroke.Thickness = 3
MakeDraggable(MiniButton)

table.insert(connections, MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false MiniButton.Visible = true end))
table.insert(connections, MiniButton.MouseButton1Click:Connect(function() MainFrame.Visible = true MiniButton.Visible = false end))

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, 0, 1, -40)
Container.Position = UDim2.new(0, 0, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Container

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 64, 0, 64)
Logo.Position = UDim2.new(0.5, -32, 0, 12)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://13206924887"
Logo.Parent = Sidebar
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)

local TabBtn = Instance.new("TextButton")
TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
TabBtn.Position = UDim2.new(0.05, 0, 0, 90)
TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabBtn.Text = "  TSB Main"
TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabBtn.Font = Enum.Font.GothamMedium
TabBtn.TextSize = 14
TabBtn.TextXAlignment = Enum.TextXAlignment.Left
TabBtn.Parent = Sidebar
Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -170, 1, -10)
ContentFrame.Position = UDim2.new(0, 165, 0, 5)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 3
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.Parent = Container
local UIListLayout = Instance.new("UIListLayout", ContentFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- TẠO UI BUTTON
local function CreateHeader(text)
    local H = Instance.new("TextLabel")
    H.Size = UDim2.new(1, 0, 0, 30)
    H.BackgroundTransparency = 1
    H.Text = text
    H.TextColor3 = Color3.fromRGB(255, 255, 255)
    H.Font = Enum.Font.GothamBold
    H.TextSize = 16
    H.TextXAlignment = Enum.TextXAlignment.Left
    H.Parent = ContentFrame
end

local function CreateToggle(name, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -10, 0, 40)
    F.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    F.Parent = ContentFrame
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(0.7, 0, 1, 0)
    L.Position = UDim2.new(0, 15, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = Color3.fromRGB(220, 220, 220)
    L.Font = Enum.Font.Gotham
    L.TextSize = 14
    L.TextXAlignment = Enum.TextXAlignment.Left
    
    local B = Instance.new("TextButton", F)
    B.Size = UDim2.new(0, 40, 0, 20)
    B.Position = UDim2.new(1, -55, 0.5, -10)
    B.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    B.Text = ""
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local K = Instance.new("Frame", B)
    K.Size = UDim2.new(0, 16, 0, 16)
    K.Position = UDim2.new(0, 2, 0.5, -8)
    K.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", K).CornerRadius = UDim.new(1, 0)
    
    local state = false
    table.insert(connections, B.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        TweenService:Create(K, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)}):Play()
    end))
end

local activeSliderDrag = nil
table.insert(connections, UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        activeSliderDrag = nil
    end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
    if activeSliderDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local barBG, min, max, fill, valueLabel, callback = unpack(activeSliderDrag)
        local pos = math.clamp((input.Position.X - barBG.AbsolutePosition.X) / barBG.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local value = math.floor(min + ((max - min) * pos))
        valueLabel.Text = tostring(value)
        callback(value)
    end
end))

local function CreateSlider(name, min, max, default, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -10, 0, 50)
    F.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    F.Parent = ContentFrame
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local T = Instance.new("TextLabel", F)
    T.Size = UDim2.new(1, -20, 0, 20)
    T.Position = UDim2.new(0, 15, 0, 5)
    T.BackgroundTransparency = 1
    T.Text = name
    T.TextColor3 = Color3.fromRGB(220, 220, 220)
    T.Font = Enum.Font.Gotham
    T.TextSize = 14
    T.TextXAlignment = Enum.TextXAlignment.Left
    
    local V = Instance.new("TextLabel", F)
    V.Size = UDim2.new(0, 40, 0, 20)
    V.Position = UDim2.new(0, 15, 0, 25)
    V.BackgroundTransparency = 1
    V.Text = tostring(default)
    V.TextColor3 = Color3.fromRGB(150, 150, 150)
    V.Font = Enum.Font.Gotham
    V.TextSize = 12
    V.TextXAlignment = Enum.TextXAlignment.Left
    
    local B = Instance.new("TextButton", F)
    B.Size = UDim2.new(1, -75, 0, 4)
    B.Position = UDim2.new(0, 55, 0, 33)
    B.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    B.Text = ""
    B.BorderSizePixel = 0
    
    local Fill = Instance.new("Frame", B)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    
    local K = Instance.new("Frame", Fill)
    K.Size = UDim2.new(0, 12, 0, 12)
    K.Position = UDim2.new(1, -6, 0.5, -6)
    K.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Instance.new("UICorner", K).CornerRadius = UDim.new(1, 0)
    
    table.insert(connections, B.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            activeSliderDrag = {B, min, max, Fill, V, callback}
            local pos = math.clamp((input.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(min + ((max - min) * pos))
            V.Text = tostring(value)
            callback(value)
        end
    end))
end

-- ==========================================
-- CẤU HÌNH & BIẾN GLOBAL
-- ==========================================
local Config = {
    Target = nil,
    StickyTele = false,
    TeleDistance = 3, 
    CharAim = false,
    AutoSelect = false,
    AntiFling = false,
    WalkSpeed = 16,
    WalkSpeedToggle = false,
    AutoEscape = false,
    EscapeHP = 35,
    VoidDrag = false
}

-- BẮT SỰ KIỆN XÀI SKILL CỦA BẢN THÂN
local isCastingSkill = false
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.KeyCode == Enum.KeyCode.One or
       input.KeyCode == Enum.KeyCode.Two or
       input.KeyCode == Enum.KeyCode.Three or
       input.KeyCode == Enum.KeyCode.Four then
       
        isCastingSkill = true
        task.delay(1.5, function()
            isCastingSkill = false
        end)
    end
end))

CreateHeader("Combat Pro")
CreateToggle("Bay Dí Sát / Bay Cực Nhanh", function(state) Config.StickyTele = state end)
CreateToggle("Void Drag (CHỈ KHI DÙNG SKILL/M1)", function(state) Config.VoidDrag = state end)
CreateToggle("Tự động chọn Target mới", function(state) Config.AutoSelect = state end)
CreateSlider("Khoảng cách sau lưng", 1, 15, 3, function(val) Config.TeleDistance = val end)
CreateToggle("Aim Nhân Vật (Auto Face)", function(state) Config.CharAim = state end)
CreateToggle("Chống Fling (Anti-Fling)", function(state) Config.AntiFling = state end)
CreateToggle("Tự động tẩu thoát khi yếu máu", function(state) 
    Config.AutoEscape = state 
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Anchored = false
    end
end)
CreateSlider("Mốc % Máu Tẩu Thoát", 5, 90, 35, function(val) Config.EscapeHP = val end)

CreateHeader("Player Buffs")
CreateToggle("Bật WalkSpeed", function(state) Config.WalkSpeedToggle = state end)
CreateSlider("Tốc độ chạy", 1, 300, 16, function(val) Config.WalkSpeed = val end)

CreateHeader("Targeting")
local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, -10, 0, 25)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Target: CHƯA CHỌN"
TargetLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
TargetLabel.Font = Enum.Font.GothamBold
TargetLabel.TextSize = 14
TargetLabel.Parent = ContentFrame

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, -10, 0, 35)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
RefreshBtn.Text = "Làm mới danh sách Player"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 14
RefreshBtn.Parent = ContentFrame
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(1, -10, 0, 0)
PlayerListFrame.AutomaticSize = Enum.AutomaticSize.Y
PlayerListFrame.BackgroundTransparency = 1
PlayerListFrame.Parent = ContentFrame
local PlayerListLay = Instance.new("UIListLayout", PlayerListFrame)
PlayerListLay.Padding = UDim.new(0, 4)

local playerButtonConnections = {}

local function RefreshPlayers()
    for _, conn in ipairs(playerButtonConnections) do
        if conn and conn.Connected then conn:Disconnect() end
    end
    table.clear(playerButtonConnections)
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, 0, 0, 30)
            pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            pBtn.Text = p.Name
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.Font = Enum.Font.GothamMedium
            pBtn.TextSize = 13
            pBtn.Parent = PlayerListFrame
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
            
            local btnConn = pBtn.MouseButton1Click:Connect(function()
                if Config.Target == p then 
                    Config.Target = nil 
                    TargetLabel.Text = "Target: CHƯA CHỌN" 
                    TargetLabel.TextColor3 = Color3.fromRGB(255, 80, 80) 
                    pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                else 
                    Config.Target = p 
                    TargetLabel.Text = "Target: " .. p.Name 
                    TargetLabel.TextColor3 = Color3.fromRGB(80, 255, 80) 
                    for _, b in ipairs(PlayerListFrame:GetChildren()) do
                        if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(40, 40, 45) end
                    end
                    pBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255) 
                end
            end)
            table.insert(playerButtonConnections, btnConn)
            table.insert(connections, btnConn)
        end
    end
end
table.insert(connections, RefreshBtn.MouseButton1Click:Connect(RefreshPlayers))
RefreshPlayers()

local function FindNewTarget()
    local closestPlayer = nil
    local shortestDist = math.huge
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local tHum = p.Character:FindFirstChildOfClass("Humanoid")
            local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
            if tHum and tHum.Health > 0 and tHrp then
                local dist = (tHrp.Position - hrp.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closestPlayer = p
                end
            end
        end
    end
    return closestPlayer
end

table.insert(connections, RunService.Stepped:Connect(function()
    if Config.AntiFling then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and not hrp.Anchored then
                if hrp.AssemblyLinearVelocity.Magnitude > 300 or hrp.AssemblyAngularVelocity.Magnitude > 300 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end
end))
-- ==========================================
-- MAIN LOGIC LOOP 
-- ==========================================
local hasEscapedForLowHP = false
local escapeTargetPos = Vector3.new(-74.6, 84.0, 20352.1)

table.insert(connections, RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not hum or not hrp or hum.Health <= 0 then 
        if hrp then hrp.Anchored = false end
        hasEscapedForLowHP = false
        return 
    end
    
    if Config.WalkSpeedToggle and hum.WalkSpeed ~= Config.WalkSpeed then 
        hum.WalkSpeed = Config.WalkSpeed 
    end
    
    local hpPercent = (hum.Health / hum.MaxHealth) * 100
    
    -- Kích hoạt tẩu thoát khi yếu máu
    if Config.AutoEscape and hpPercent <= Config.EscapeHP then
        hasEscapedForLowHP = true
    end
    
    -- Xử lý vòng lặp tẩu thoát (Ghim chặt vị trí an toàn)
    if hasEscapedForLowHP then
        if hpPercent >= (Config.EscapeHP + 15) then
            hasEscapedForLowHP = false
            hrp.Anchored = false
        else
            -- Xóa các lực tác động có thể gây kẹt
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BodyMover") or v:IsA("LinearVelocity") or v:IsA("VectorForce") or v:IsA("AlignPosition") then
                    v:Destroy()
                end
            end
            -- Đưa vào trạng thái vô hiệu hóa vật lý và spam CFrame
            hrp.Anchored = true
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            char:PivotTo(CFrame.new(escapeTargetPos))
            return -- Dừng toàn bộ logic combat phía dưới khi đang bỏ trốn
        end
    end

    local targetInvalid = false
    if not Config.Target or not Config.Target.Character then
        targetInvalid = true
    else
        local targetHum = Config.Target.Character:FindFirstChildOfClass("Humanoid")
        if not targetHum or targetHum.Health <= 0 then targetInvalid = true end
    end
    
    if targetInvalid then
        if Config.AutoSelect then
            Config.Target = FindNewTarget()
            if Config.Target then
                TargetLabel.Text = "Target: " .. Config.Target.Name
                TargetLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
            else
                TargetLabel.Text = "Target: CHƯA CHỌN"
                TargetLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        else
            Config.Target = nil
            TargetLabel.Text = "Target: CHƯA CHỌN"
            TargetLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
        hum.AutoRotate = true -- Trả lại khả năng xoay mặt khi mất target
    end
    
    -- Logic Combat / Bám theo Target
    if Config.Target and Config.Target.Character and not hasEscapedForLowHP then
        local tHrp = Config.Target.Character:FindFirstChild("HumanoidRootPart")
        
        if tHrp then
            -- 1. LOGIC VỊ TRÍ (Position)
            if Config.VoidDrag and isCastingSkill then
                tHrp.CFrame = CFrame.new(tHrp.Position.X, -1000, tHrp.Position.Z)
                tHrp.AssemblyLinearVelocity = Vector3.zero
                
                local safeY = math.max(hrp.Position.Y, 15)
                hrp.CFrame = CFrame.new(tHrp.Position.X, safeY, tHrp.Position.Z)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                
            elseif Config.StickyTele then
                local targetBehindCFrame = tHrp.CFrame * CFrame.new(0, 0, Config.TeleDistance)
                hrp.CFrame = hrp.CFrame:Lerp(targetBehindCFrame, 0.4)
                
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
            
            -- 2. LOGIC AIM (Độc lập, hoạt động chung được với Tele)
            if Config.CharAim then
                hum.AutoRotate = false -- Tắt tự động xoay của Roblox để không bị lệch Aim
                local lookVector = Vector3.new(tHrp.Position.X, hrp.Position.Y, tHrp.Position.Z)
                hrp.CFrame = CFrame.lookAt(hrp.Position, lookVector)
            else
                hum.AutoRotate = true
            end
        end
    else
        if hum then hum.AutoRotate = true end
    end
end))

-- ==========================================
-- SCRIPT PHẦN 2 (BYPASS, ANTI-MOVES, INVISIBILITY, ETC)
-- ==========================================

local TeleportService = game:GetService("TeleportService")
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local _ReplicatedStorage = game:GetService("ReplicatedStorage")
local vim = game:GetService("VirtualInputManager")
local lp         = Players.LocalPlayer

local _moveList = {
        { 'Normal Punch',             10468665991,   20,   1, 'Normal Punch'             },
        { 'Consecutive Punches',      10466974800,   15,   2, 'Consecutive Punches'      },
        { 'Shove',                    10471336737,   10,   3, 'Shove'                    },
        { 'Uppercut',                 12510170988,   20,   4, 'Uppercut'                 },
        { 'Table Flip',               11365563255,   20,   2, 'Table Flip'               },
        { 'Serious Punch',            12983333733,   20,   3, 'Serious Punch'            },
        { 'Omni Directional Punch',   13927612951,   20,   4, 'Omni Directional Punch'   },
        { 'Lethal Whirlwind Stream',  12296882427,   20,   2, 'Lethal Whirlwind Stream'  },
        { 'Flowing Water',            12272894215,   17.5, 1, 'Flowing Water'            },
        { 'Hunters Grasp',            12307656616,   15,   3, "Hunter's Grasp"           },
        { 'Preys Peril',              12351854556,   17,   4, "Prey's Peril"             },
        { 'Water Stream Cutting Fist',12460977270,   8.45, 1, 'Water Stream Cutting Fist'},
        { 'The Final Hunt',           12463072679,   101,  2, 'The Final Hunt'           },
        { 'Rock Splitting Fist',      14057231976,   14,   3, 'Rock Splitting Fist'      },
        { 'Crushed Rock',             13630786846,   9.58, 4, 'Crushed Rock'             },
        { 'Machine Gun Blows',        12534735382,   15,   1, 'Machine Gun Blows'        },
        { 'Ignition Burst',           12502664044,   17.5, 2, 'Ignition Burst'           },
        { 'Blitz Shot',               12618271998,   25,   3, 'Blitz Shot'               },
        { 'Jet Dive',                 12684390285,   17.5, 4, 'Jet Dive'                 },
        { 'Thunder Kick',             14721837245,   15,   1, 'Thunder Kick'             },
        { 'Speedblitz Dropkick',      12832505612,   20,   2, 'Speedblitz Dropkick'      },
        { 'Flamewave Cannon',         13083332742,   25,   3, 'Flamewave Cannon'         },
        { 'Incinerate',               13146710762,   101,  4, 'Incinerate'               },
        { 'Flash Strike',             13309500827,   17.5, 1, 'Flash Strike'             },
        { 'Whirlwind Kick',           13294790250,   20,   2, 'Whirlwind Kick'           },
        { 'Scatter',                  13362587853,   21.25,3, 'Scatter'                  },
        { 'Explosive Shuriken',       13501296372,   17.5, 4, 'Explosive Shuriken'       },
        { 'Twinblade Rush',           13632347366,   20,   1, 'Twinblade Rush'           },
        { 'Straight On',              13643152947,   17,   2, 'Straight On'              },
        { 'Carnage',                  13723174078,   25,   3, 'Carnage'                  },
        { 'Fourfold Flashstrike',     13881335713,   25,   4, 'Fourfold Flashstrike'     },
        { 'Homerun',                  14004235777,   17.5, 1, 'Homerun'                  },

        { 'Grand Slam',               14299135500,   20,   3, 'Grand Slam'               },
        { 'Foul Ball',                14351441234,   23,   4, 'Foul Ball'                },
        { 'Savage Tornado',           14719290328,   17,   1, 'Savage Tornado'           },
        { 'Brutal Beatdown',          14701242661,   30,   2, 'Brutal Beatdown'          },
        { 'Strength Difference',      14900168720,   20,   3, 'Strength Difference'      },
        { 'Death Blow',               15128849047,   101,  4, 'Death Blow'               },
        { 'Quick Slice',              15290930205,   20,   1, 'Quick Slice'              },
        { 'Atmos Cleave',             15145462680,   22,   2, 'Atmos Cleave'             },
        { 'Pinpoint Cut',             15295895753,   17,   3, 'Pinpoint Cut'             },
        { 'Pinpoint Cut',             15295336270,   17,   3, 'Pinpoint Cut'             },
        { 'Split Second Counter',     15311685628,   17.5, 4, 'Split Second Counter'     },
        { 'Sunset',                   15520132233,   15,   1, 'Sunset'                   },
        { 'Solar Cleave',             15676072469,   15,   2, 'Solar Cleave'             },
        { 'Sunrise',                  16062410809,   20,   3, 'Sunrise'                  },
        { 'Atomic Slash',             16082123712,   101,  4, 'Atomic Slash'             },
        { 'Crushing Pull',            16139108718,   21,   1, 'Crushing Pull'            },
        { 'Windstorm Fury',           16515850153,   20,   2, 'Windstorm Fury'           },
        { 'Stone Coffin',             16431491215,   25,   3, 'Stone Coffin'             },
        { 'Expulsive Push',           16597322398,   19,   4, 'Expulsive Push'           },
        { 'Cosmic Strike',            16737255386,   30,   1, 'Cosmic Strike'            },
        { 'Psychic Ricochet',         17464644182,   15,   2, 'Psychic Ricochet'         },
        { 'Terrible Tornado',         17275150809,   101,  3, 'Terrible Tornado'         },
        { 'Sky Snatcher',             17860467628,   17,   4, 'Sky Snatcher'             },
        { 'Bullet Barrage',           17799224866,   20,   1, 'Bullet Barrage'           },
        { 'Vanishing Kick',           17838006839,   23,   2, 'Vanishing Kick'           },
        { 'Whirlwind Drop',           17857788598,   15,   3, 'Whirlwind Drop'           },
        { 'Head First',               18179181663,   20,   4, 'Head First'               },
        { 'Grand Fissure',            129651400898906, 18, 1, 'Grand Fissure'            },
        { 'Twin Fangs',               18896229321,   15,   2, 'Twin Fangs'               },
        { 'Earth Splitting Strike',   18897119503,   30,   3, 'Earth Splitting Strike'   },
        { 'Last Breath',              106755459092436, 101, 4, 'Last Breath'             },
        { 'Ravage',                   16945573694,   17.5, 1, 'Ravage'                   },
        { 'Swift Sweep',              16944265635,   15,   2, 'Swift Sweep'              },
        { 'Collateral Ruin',          17325254223,   22.5, 3, 'Collateral Ruin'          },
        { 'Spiraling Storm',          78521642007560, 22.5, 4, 'Spiraling Storm'         },
        { 'Stoic Bomb',               17141153099,   15,   1, 'Stoic Bomb'               },
        { '202020 Dropkick',          17354976067,   101,  2, '20-20-20 Dropkick'        },
        { 'Five Seasons',             18462892217,   100,  3, 'Five Seasons'             },
        { 'Unlimited Flex Works',     77727115892579, 0,   4, 'Unlimited Flex Works'     },
        { 'Permafrost',               100558589307006, 20, 1, 'Permafrost'               },
        { 'Frost Forge',              137561511768861, 15, 2, 'Frost Forge'              },
        { 'Freezing Path',            112620365240235, 25, 3, 'Freezing Path'            },
        { 'Judgement Chain',          75547590335774, 20,  4, 'Judgement Chain'          },
        { 'Weboom',                   113166426814229, 20, 1, 'Weboom'                   },
        { 'Trinity Tear',             77509627104305, 25,  2, 'Trinity Tear'             },
        { 'Plasma Cannon',            116753755471636, 20, 3, 'Plasma Cannon'            },
        { 'Double Trouble',           138443750790136, 20, 4, 'Double Trouble'           },
        { 'Doom Dive',                101588604872680, 23, 1, 'Doom Dive'               },
        { 'Crowd Buster',             105442749844047, 22, 2, 'Crowd Buster'             },
        { 'Hammer Heel',              109617620932970, 18, 3, 'Hammer Heel'              },
        { 'Binding Cloth',            125955606488863, 20, 4, 'Binding Cloth'            },
        { 'Hammer Heel',              135289891173395, 18, 3, 'Hammer Heel'              },
        { 'Machine Gun Blows',        12971270638,   15,   1, 'Machine Gun Blows'        },
        { 'Crushed Rock',             72451715583225, 9.58, 4, 'Crushed Rock'            },
        -- Block animations (usados só para detectar 3x block toggle)
        { 'Block',                    13380778193,   0,    0, 'Block'                    },
        { 'Block',                    13370310513,   0,    0, 'Block'                    },
        { 'Block',                    13935548552,   0,    0, 'Block'                    },

    }

local deathCounterActive     = true
deathCounterConns = {}
deathCounterDebounce = {}
hookedChars = {}
local _hookPlayerAntiMoves    -- forward-declared as upvalue to avoid local register overflow inside xpcall
local _watchEnemyAntiMoves    -- forward-declared as upvalue to avoid local register overflow inside xpcall
local _antiMovesCharConns     -- forward-declared as upvalue to avoid local register overflow inside xpcall
local _antiMovesRespawnConns  -- forward-declared as upvalue to avoid local register overflow inside xpcall
local isDeathCountered = false

local function _getAntiDCWaitBeforeKill()
    return 0
end

local function isDeathCounter(child)
    return child:IsA("Accessory") and child.Name == "Counter"
end
local deathCounterActive     = false
local _antiDCAnimConn = nil
local _antiDCCharConn = nil
local function _antiDCTp(cf)
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (char and root) then return end
    task.spawn(function()
        RunService.RenderStepped:Once(function()
            root.Velocity = Vector3.new()
            RunService.Heartbeat:Wait()
            root.Velocity = Vector3.new()
        end)
        RunService.Heartbeat:Once(function()
            root.CFrame = cf
        end)
    end)
end
local function _antiDCFixCam()
    local char = lp.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if char and hum and workspace.CurrentCamera then
        local cf = workspace.CurrentCamera.CFrame
        workspace.CurrentCamera:Destroy()
        local cam = Instance.new("Camera", workspace)
        cam.CameraType    = Enum.CameraType.Custom
        cam.CameraSubject = hum
        cam.CFrame        = cf
        lp.CameraMode     = Enum.CameraMode.Classic
        local head = char:FindFirstChild("Head")
        if head then head.Anchored = false end
    end
end
local function getDisplayName(player)
    local ok, displayName = pcall(function() return player.DisplayName end)
    if not ok or not displayName or displayName == "" then return player.Name end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.DisplayName == displayName then
            return player.Name
        end
    end
    return displayName
end
local function _hookAntiDCAnimator(humanoid)
    if _antiDCAnimConn then _antiDCAnimConn:Disconnect() _antiDCAnimConn = nil end
    if not humanoid then return end
    _antiDCAnimConn = humanoid.AnimationPlayed:Connect(function(track)
        if not track.Animation.AnimationId:match("11343250001") then return end
        isDeathCountered = true
        task.spawn(function()
            task.wait(0.2)
            local waitBeforeKill = _getAntiDCWaitBeforeKill()
            local stoppedCounterTrack = waitBeforeKill <= 0
            if waitBeforeKill <= 0 then
                pcall(function() track:Stop() end)
            end
            task.spawn(_antiDCFixCam)
            local char = lp.Character
            char:WaitForChild("AbsoluteImmortal", 1)
            local root = char:FindFirstChild("HumanoidRootPart")
            local savedCFrame = root.CFrame
            local attacker = nil
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= lp then
                    local tchar = player.Character
                    local troot = tchar and tchar:FindFirstChild("HumanoidRootPart")
                    local thum  = tchar and tchar:FindFirstChildOfClass("Humanoid")
                    if tchar and troot and thum then
                        for _, t in pairs(thum:GetPlayingAnimationTracks()) do
                            if t.Animation.AnimationId:match("11343318134")
                                and (root.Position - troot.Position).Magnitude <= 15 then
                                attacker = player
                            end
                        end
                    end
                end
            end
            local attackerHum  = nil
            local attackerName = nil
            if attacker then
                local ach = attacker.Character
                attackerHum  = ach and ach:FindFirstChildOfClass("Humanoid")
                attackerName = getDisplayName(attacker)
            else
                local _fakeModel = Instance.new("Model")
                local _fakeHum   = Instance.new("Humanoid", _fakeModel)
                _fakeHum.Health  = 100
                attackerHum  = _fakeHum
                attackerName = nil
                task.delay(waitBeforeKill + 2, function()
                    _fakeHum.Health = 0
                end)
            end
            if waitBeforeKill > 0 then
                task.wait(waitBeforeKill)
                char = lp.Character
                root = char and char:FindFirstChild("HumanoidRootPart")
                if not (char and root) then return end
            end
            local savedSubject = workspace.CurrentCamera and workspace.CurrentCamera.CameraSubject
            if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = nil end
            local myHum  = char:FindFirstChildOfClass("Humanoid")
            local voidCF = CFrame.new(0, -10000, 0) * CFrame.Angles(math.rad(90), 0, 0)
            local t0     = tick()
            repeat
                _antiDCTp(voidCF)
                if waitBeforeKill > 0 and not stoppedCounterTrack then
                    stoppedCounterTrack = true
                    pcall(function() track:Stop() end)
                end
                RunService.RenderStepped:Wait()
            until (attackerHum and attackerHum.Health <= 0)
                or (myHum and myHum.Health <= 0)
                or tick() >= t0 + 10
            if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = savedSubject end
            _antiDCTp(savedCFrame)
            task.wait(1)
            local cur = lp.Character
            if cur then
                local freeze   = cur:FindFirstChild("Freeze")
                local noRotate = cur:FindFirstChild("NoRotate")
                if freeze   then freeze:Destroy()   end
                if noRotate then noRotate:Destroy() end
            end
            task.spawn(_antiDCFixCam)
            isDeathCountered = false
        end)
    end)
end
local function _hookAntiDCChar(char)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        _hookAntiDCAnimator(humanoid)
    else
        task.spawn(function()
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then _hookAntiDCAnimator(hum) end
        end)
    end
end
_hookAntiDCChar(lp.Character)
_antiDCCharConn = lp.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    _hookAntiDCChar(char)
end)

local function watchCharForCounter(char, player)
    if not char or not player or player == lp then return end
    if hookedChars[char] then return end
    hookedChars[char] = true
    for _, child in pairs(char:GetChildren()) do
        if isDeathCounter(child) then
            if deathCounterActive and not deathCounterDebounce[player] then
                deathCounterDebounce[player] = true
            end
        end
    end
    local conn = char.ChildAdded:Connect(function(child)
        if not deathCounterActive then return end
        if not isDeathCounter(child) then return end
        if deathCounterDebounce[player] then return end
        deathCounterDebounce[player] = true
    end)
    table.insert(deathCounterConns, conn)
end
local function hookPlayerDC(player)
    if player == lp then return end
    if player.Character then
        task.spawn(watchCharForCounter, player.Character, player)
    end
    local conn = player.CharacterAdded:Connect(function(char)
        if not deathCounterActive then return end
        task.wait(0.1)
        watchCharForCounter(char, player)
    end)
    table.insert(deathCounterConns, conn)
end

for _, co in pairs(deathCounterConns) do pcall(co.Disconnect, co) end
for _, p in pairs(Players:GetPlayers()) do
    hookPlayerDC(p)
end
table.insert(deathCounterConns, Players.PlayerAdded:Connect(function(p)
    if deathCounterActive then hookPlayerDC(p) end
end))

_antiMovesCharConns    = {}
_antiMovesRespawnConns = {}
local antidebug = false
local _desyncCharConn = lp.CharacterAdded:Connect(function()
    getgenv().desync = nil
end)

isCountering = function(hum)
    if not hum then return false end
    local model = hum:FindFirstAncestorWhichIsA("Model")
    if model and model:FindFirstChild("Counter") then return true end
    for _, t in pairs(hum:GetPlayingAnimationTracks()) do
        local id = t.Animation.AnimationId
        if id:match("13726226905") or id:match("13726235415") then return true end
    end
    return false
end

_watchEnemyAntiMoves = function(player, char)
    if not char then return end
    if _antiMovesCharConns[player] then
        pcall(function() _antiMovesCharConns[player]:Disconnect() end)
        _antiMovesCharConns[player] = nil
    end
    repeat
        task.wait()
    until not char.Parent
        or (char:FindFirstChild("HumanoidRootPart")
            and char:FindFirstChildOfClass("Humanoid"))
    if not char.Parent then return end
    local enemyRoot = char:FindFirstChild("HumanoidRootPart")
    local enemyHum  = char:FindFirstChildOfClass("Humanoid")
    if not (enemyRoot and enemyHum) then return end
    local function isAnimPlaying(hum, id)
        local _d = tostring(id):match("%d+")
        for _, t in pairs(hum:GetPlayingAnimationTracks()) do
            if t.Animation.AnimationId:match(_d) then return t end
        end
        return nil
    end
    local conn = enemyHum.AnimationPlayed:Connect(function(track)
        local animId = track.Animation.AnimationId
        local myChar = lp.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not (myChar and myRoot) then return end
        task.spawn(function()
            if track.WeightTarget == 0 or track.Speed == 0 then return end
            local DESYNC_CF = CFrame.new(9e9, 9e9, 9e9)
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            local function safeDesyncLoop(condFn)
                pcall(function()
                    repeat
                        getgenv().desync = { CFrame = DESYNC_CF }
                        task.wait()
                        local c = lp.Character
                        local r = c and c:FindFirstChild("HumanoidRootPart")
                        local h = c and c:FindFirstChildOfClass("Humanoid")
                        if not (c and r and h) then return end
                        myRoot = r
                        myHum  = h
                    until condFn()
                end)
                getgenv().desync = nil
                if sethiddenproperty then
                    local _cr = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                    if _cr then pcall(function() sethiddenproperty(_cr, "PhysicsRepRootPart", nil) end) end
                end
            end
            local function isDeathCountering(hum)
                if not hum then return false end
                local model = hum:FindFirstAncestorWhichIsA("Model")
                return model and model:FindFirstChild("Counter") and true or false
            end
            local function makeHitboxPart(size)
                local p = Instance.new("Part", workspace)
                p.Anchored = true p.Size = size p.CanCollide = false p.Transparency = 1
                local touched = false
                local c1 = p.Touched:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = true end end)
                local c2 = p.TouchEnded:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = false end end)
                return p, function() return touched end, function()
                    pcall(function() p:Destroy() end) c1:Disconnect() c2:Disconnect()
                end
            end
            local function getMyPos()
                local _ip = getgenv().InvisPart30
                if getgenv().InvisActive and _ip then return _ip.Position end
                return myRoot.Position
            end
            if animId:match("12983333733")
                and char:GetAttribute("Ulted") ~= nil then
                task.delay(1, function()
                    if char:FindFirstChild("AbsoluteImmortal", true) and char:FindFirstChild("Freeze") then
                        task.wait(4.25)
                        local t = tick()
                        safeDesyncLoop(function()
                            return (getMyPos() - enemyRoot.Position).Magnitude > 150
                                or tick() >= t + 2
                                or not track.IsPlaying
                        end)
                    end
                end)
            end
            if animId:match("11365563255")
                and char:GetAttribute("Ulted") ~= nil then
                task.delay(1, function()
                    if char:FindFirstChild("AbsoluteImmortal", true) and char:FindFirstChild("Freeze") then
                        task.wait(3)
                        local startTickAntiMoves = tick()
                        safeDesyncLoop(function()
                            return tick() >= startTickAntiMoves + 2.5
                        end)
                    end
                end)
            end
            if animId:match("13927612951")
                and char:GetAttribute("Ulted") ~= nil then
                local startTickSaitama = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 150
                        or tick() >= startTickSaitama + 2.5
                end)
            end
            if animId:match("12342141464") then
                task.wait(3.5)
                local startTickTableFlip = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 125
                        or tick() >= startTickTableFlip + 1.25
                end)
            end
            if animId:match("12463072679") then
                local startTickOmni = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 25
                        or tick() >= startTickOmni + 0.75
                end)
            end
            if animId:match("13603396939") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - (enemyRoot.CFrame * CFrame.new(0,0,-1)).Position).Magnitude > 7.5
                        or isCountering(enemyHum)
                        or tick() >= t + 2.5
                end)
            end
            if animId:match("12460977270") then
                local p, isTouched, cleanup = makeHitboxPart(Vector3.new(12.5,5,12.5))
                local t = tick()
                repeat
                    p.CFrame = enemyRoot.CFrame * CFrame.new(0,0,-6.25)
                    if isTouched() and not isCountering(enemyHum) then
                        getgenv().desync = { CFrame = DESYNC_CF }
                    else getgenv().desync = nil end
                    RunService.RenderStepped:Wait()
                until tick() >= t + 1.85 or not track.IsPlaying
                getgenv().desync = nil cleanup()
            end
            if animId:match("14057231976") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 10
                        or tick() >= t + 0.5
                end)
                task.wait(0.5)
                local t2 = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 10
                        or isCountering(enemyHum)
                        or tick() >= t2 + 1.25
                end)
            end
            if animId:match("13630786846") then
                local p, isTouched, cleanup = makeHitboxPart(Vector3.new(25,10,75))
                local t = tick()
                repeat
                    p.CFrame = enemyRoot.CFrame * CFrame.new(0,0,-37.5)
                    if isTouched() and not isCountering(enemyHum) then
                        getgenv().desync = { CFrame = DESYNC_CF }
                    else getgenv().desync = nil end
                    RunService.RenderStepped:Wait()
                until tick() >= t + 1.5 or not track.IsPlaying
                getgenv().desync = nil cleanup()
            end
            if animId:match("72451715583225") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 15
                        or tick() >= t + 0.75
                end)
            end
            if animId:match("13813955149") then
                if (getMyPos() - enemyRoot.Position).Magnitude <= 25 then
                    getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                    task.wait(0.75)
                    getgenv().desync = nil
                end
                local trashConn = nil
                trashConn = workspace.Thrown.ChildAdded:Connect(function(p)
                    if p:IsA("MeshPart") and p.Name:lower() == "trash can" then
                        trashConn:Disconnect()
                        local t = tick()
                        safeDesyncLoop(function()
                            return (getMyPos() - p.Position).Magnitude > 25
                                or tick() >= t + 2
                        end)
                    end
                end)
            end
            if animId:match("15128849047") then
                local startTickGarou = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 100
                        or isAnimPlaying(enemyHum, "15123665491")
                        or tick() >= startTickGarou + 3
                end)
            end
            if animId:match("15391323441") then
                task.wait(5.5)
                local startTickFinalHunt = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 125
                        or tick() >= startTickFinalHunt + 1
                end)
            end
            if animId:match("16082123712") then
                task.wait(2.5)
                local startTickMetalBat = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 50
                        or tick() >= startTickMetalBat + 1.5
                end)
            end
            if animId:match("14719290328") then
                if (getMyPos() - enemyRoot.Position).Magnitude <= 50 then
                    getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                end
                task.wait(0.5)
                if track.IsPlaying then
                    local t = tick()
                    safeDesyncLoop(function()
                        return (getMyPos() - enemyRoot.Position).Magnitude > 50
                            or isDeathCountering(myHum)
                            or tick() >= t + 3.5
                            or not track.IsPlaying
                    end)
                end
            end
            if animId:match("15520132233") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 50
                        or isDeathCountering(myHum)
                        or tick() >= t + 3.3
                        or not track.IsPlaying
                end)
                repeat task.wait() until tick() >= t + 5.5
                local t2 = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 100
                        or isDeathCountering(myHum)
                        or tick() >= t2 + 1
                        or not track.IsPlaying
                end)
            end
            if animId:match("15676072469") then
                local p, isTouched, cleanup = makeHitboxPart(Vector3.new(50,10,150))
                local t = tick()
                repeat
                    p.CFrame = enemyRoot.CFrame * CFrame.new(0,0,-75)
                    if isTouched() and not isDeathCountering(myHum) then
                        getgenv().desync = { CFrame = DESYNC_CF }
                    else getgenv().desync = nil end
                    RunService.RenderStepped:Wait()
                until tick() >= t + 2 or not track.IsPlaying
                getgenv().desync = nil cleanup()
            end
            if animId:match("16057411888") then
                task.wait(4.25)
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 50
                        or tick() >= t + 2
                end)
            end
            if animId:match("18435535291") then
                task.wait(4.25)
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 100
                        or tick() >= t + 1.25
                end)
            end
            if animId:match("17857788598") then
                task.wait(0.65)
                if track.IsPlaying then
                    local part = Instance.new("Part", workspace)
                    part.Anchored = true part.Size = Vector3.new(35, 2048, 35)
                    part.CanCollide = false part.Transparency = 1
                    local touched = false
                    local c1 = part.Touched:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = true end end)
                    local c2 = part.TouchEnded:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = false end end)
                    local t = tick()
                    repeat
                        part.CFrame = enemyRoot.CFrame
                        if touched and not isAnimPlaying(enemyHum, "15128849047") then
                            getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                        else
                            getgenv().desync = nil
                        end
                        RunService.RenderStepped:Wait()
                    until tick() >= t + 0.85 or not track.IsPlaying
                    getgenv().desync = nil
                    c1:Disconnect() c2:Disconnect()
                    pcall(function() part:Destroy() end)
                end
            end
            if animId:match("129651400898906") then
                task.wait(0.5)
                local savedEnemyCF = enemyRoot.CFrame
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 75
                        or tick() >= t + 1.25
                        or not track.IsPlaying
                end)
                task.wait(1)
                local t2 = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - savedEnemyCF.Position).Magnitude > 75
                        or tick() >= t2 + 1.75
                end)
            end
            if animId:match("18896229321") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 15
                        or isCountering(enemyHum)
                        or tick() >= t + 3.5
                        or not track.IsPlaying
                end)
                task.wait(1)
                if track.IsPlaying then
                    if (getMyPos() - enemyRoot.Position).Magnitude <= 25 then
                        local t2 = tick()
                        safeDesyncLoop(function()
                            return (getMyPos() - enemyRoot.Position).Magnitude > 25
                                or tick() >= t2 + 2
                                or not track.IsPlaying
                        end)
                    end
                end
            end
            if animId:match("18897119503") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 50
                        or tick() >= t + 1.5
                end)
            end
            if (animId:match("106755459092436") or animId:match("75502010126640")) then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 50
                        or tick() >= t + 2
                end)
            end
            if animId:match("16515850153") then
                task.spawn(function()
                    if (getMyPos() - enemyRoot.Position).Magnitude <= 15 then
                        getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                    end
                    local _Dotted = workspace.Thrown:WaitForChild("Dotted", 1)
                    if _Dotted then
                        local _Dots = _Dotted:WaitForChild("Dots", 1)
                        if not _Dots then
                            getgenv().desync = nil
                            return
                        end
                        local t = tick()
                        if (getMyPos() - _Dots.Position).Magnitude > 20 then
                            getgenv().desync = nil
                        end
                        safeDesyncLoop(function()
                            return (getMyPos() - _Dots.Position).Magnitude > 20
                                or isDeathCountering(myHum)
                                or tick() >= t + 4.25
                        end)
                    else
                        getgenv().desync = nil
                    end
                end)
            end
            if animId:match("16431491215") then
                local t = tick()
                repeat task.wait()
                until (getMyPos() - (enemyRoot.CFrame * CFrame.new(0, 0, -25)).Position).Magnitude <= 25
                    or isAnimPlaying(enemyHum, "15128849047")
                    or tick() >= t + 0.75
                if not isAnimPlaying(enemyHum, "15128849047") then
                    safeDesyncLoop(function()
                        return (getMyPos() - (enemyRoot.CFrame * CFrame.new(0, 0, -20)).Position).Magnitude > 25
                            or isAnimPlaying(enemyHum, "15128849047")
                            or tick() >= t + 0.75
                    end)
                end
            end
            if animId:match("16597912086") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 15
                        or isCountering(enemyHum)
                        or tick() >= t + 0.75
                end)
            end
            if animId:match("17275150809") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 50
                        or tick() >= t + 1
                end)
            end
            if animId:match("17278415853")
                and char:GetAttribute("Character") == "Esper" then
                task.wait(11)
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 100
                        or tick() >= t + 6
                end)
            end
            if animId:match("16734584478") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 75
                        or tick() >= t + 5.75
                end)
            end
            if animId:match("13376869471") then
                local part = Instance.new("Part", workspace)
                part.Anchored = true part.Size = Vector3.new(10, 7.5, 60)
                part.CanCollide = false part.Transparency = 1
                local touched = false
                local c1 = part.Touched:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = true end end)
                local c2 = part.TouchEnded:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = false end end)
                local t = tick()
                repeat
                    part.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, -part.Size.Z / 2)
                    RunService.RenderStepped:Wait()
                until touched or tick() >= t + 3 or not track.IsPlaying
                if touched then
                    local t2 = tick()
                    safeDesyncLoop(function()
                        return not touched or tick() >= t2 + 1 or not track.IsPlaying
                    end)
                end
                c1:Disconnect() c2:Disconnect()
                pcall(function() part:Destroy() end)
            end
            if animId:match("13294790250") then
                task.wait(0.5)
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - (enemyRoot.CFrame * CFrame.new(0, 0, -2.5)).Position).Magnitude > 10
                        or isCountering(enemyHum)
                        or tick() >= t + 0.75
                end)
            end
            if animId:match("13632347366") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 75
                        or isDeathCountering(myHum)
                        or tick() >= t + 1.75
                        or not track.IsPlaying
                end)
            end
            if animId:match("13723174078") then
                task.wait(0.5)
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 50
                        or tick() >= t + 2
                        or not track.IsPlaying
                end)
            end
            if animId:match("13881335713") then
                task.wait(0.75)
                if track.IsPlaying then
                    local part = Instance.new("Part", workspace)
                    part.Anchored = true part.Size = Vector3.new(35, 5, 60)
                    part.CanCollide = false part.Transparency = 1
                    local touched = false
                    local c1 = part.Touched:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = true end end)
                    local c2 = part.TouchEnded:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = false end end)
                    local t = tick()
                    repeat
                        part.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, -part.Size.Z / 2)
                        RunService.RenderStepped:Wait()
                    until touched or tick() >= t + 3 or not track.IsPlaying
                    if touched then
                        local t2 = tick()
                        safeDesyncLoop(function()
                            return not touched or tick() >= t2 + 1 or not track.IsPlaying
                        end)
                    end
                    c1:Disconnect() c2:Disconnect()
                    pcall(function() part:Destroy() end)
                end
            end
            if animId:match("14721837245") then
                local t = tick()
                safeDesyncLoop(function()
                    return (getMyPos() - enemyRoot.Position).Magnitude > 25
                        or isAnimPlaying(enemyHum, "15128849047")
                        or tick() >= t + 1.5
                        or not track.IsPlaying
                end)
                if tick() >= t + 1.5 then
                    task.wait(1)
                    local t2 = tick()
                    safeDesyncLoop(function()
                        return (getMyPos() - enemyRoot.Position).Magnitude > 100
                            or tick() >= t2 + 1.5
                            or not track.IsPlaying
                    end)
                end
            end
            if animId:match("13083332742") then
                task.wait(1)
                local part = Instance.new("Part", workspace)
                part.Anchored = true part.Size = Vector3.new(12.5, 5, 1000)
                part.CanCollide = false part.Transparency = 1
                task.delay(0.25, function() part.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, -part.Size.Z / 2) end)
                local touched = false
                local c1 = part.Touched:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = true end end)
                local c2 = part.TouchEnded:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = false end end)
                local t = tick()
                repeat
                    if touched and not isDeathCountering(myHum) then
                        getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                    else getgenv().desync = nil end
                    RunService.RenderStepped:Wait()
                until tick() >= t + 4 or not track.IsPlaying
                getgenv().desync = nil
                c1:Disconnect() c2:Disconnect()
                pcall(function() part:Destroy() end)
            end
            if animId:match("13146710762") then
                task.wait(3.25)
                if track.IsPlaying then
                    local parts = {}
                    local offsets = {
                        CFrame.new(50, 0, -200) * CFrame.Angles(0, math.rad(-15), 0),
                        CFrame.new(-50, 0, -200) * CFrame.Angles(0, math.rad(15), 0),
                        CFrame.new(0, 0, -200),
                    }
                    local touched = false
                    local conns = {}
                    for _, off in ipairs(offsets) do
                        local p = Instance.new("Part", workspace)
                        p.Anchored = true p.Size = Vector3.new(100, 75, 400)
                        p.CanCollide = false p.Transparency = 1
                        p.CFrame = enemyRoot.CFrame * off
                        table.insert(parts, p)
                        table.insert(conns, p.Touched:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = true end end))
                        table.insert(conns, p.TouchEnded:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched = false end end))
                    end
                    local t = tick()
                    repeat
                        if touched and not isDeathCountering(myHum) then
                            getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                        else getgenv().desync = nil end
                        RunService.RenderStepped:Wait()
                    until tick() >= t + 6 or not track.IsPlaying
                    getgenv().desync = nil
                    for _, c in ipairs(conns) do c:Disconnect() end
                    for _, p in ipairs(parts) do pcall(function() p:Destroy() end) end
                end
            end
            if animId:match("11343318134") then
                task.wait(7.5)
                if not track.IsPlaying then return end
                local parts = {}
                local offsets = {
                    CFrame.new(60, 0, -250) * CFrame.Angles(0, math.rad(-15), 0),
                    CFrame.new(-60, 0, -250) * CFrame.Angles(0, math.rad(15), 0),
                    CFrame.new(0, 0, -250),
                }
                local touched = {false, false, false}
                local conns = {}
                for idx, off in ipairs(offsets) do
                    local p = Instance.new("Part", workspace)
                    p.Anchored = true p.Size = Vector3.new(125, 5, 500)
                    p.CanCollide = false p.Transparency = 1
                    table.insert(parts, p)
                    local i = idx
                    table.insert(conns, p.Touched:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched[i] = true end end))
                    table.insert(conns, p.TouchEnded:Connect(function(h) if h == myRoot or h == getgenv().InvisPart30 then touched[i] = false end end))
                end
                local t = tick()
                repeat
                    for idx, p in ipairs(parts) do
                        p.CFrame = enemyRoot.CFrame * offsets[idx]
                    end
                    if touched[1] or touched[2] or touched[3] then
                        getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                    else
                        getgenv().desync = nil
                    end
                    RunService.RenderStepped:Wait()
                until tick() >= t + 2.5 or not track.IsPlaying
                getgenv().desync = nil
                for _, c in ipairs(conns) do c:Disconnect() end
                for _, p in ipairs(parts) do pcall(function() p:Destroy() end) end
            end
        end)
    end)
    _antiMovesCharConns[player] = conn
end
_hookPlayerAntiMoves = function(player)
    if player == lp then return end
    if player.Character then
        task.spawn(_watchEnemyAntiMoves, player, player.Character)
    end
    local c = player.CharacterAdded:Connect(function(char)
        task.spawn(_watchEnemyAntiMoves, player, char)
    end)
    _antiMovesRespawnConns[player] = c
end
for _, p in pairs(Players:GetPlayers()) do
    task.spawn(_hookPlayerAntiMoves, p)
end
local _antiMovesPlayerConn = Players.PlayerAdded:Connect(function(p)
    if p == lp then return end
    task.spawn(function()
        local t = tick()
        repeat
            RunService.RenderStepped:Wait()
        until p:GetAttribute("PreloadDone") or tick() >= t + 30
        if p and p.Parent then
            if p.Character then
                task.spawn(_watchEnemyAntiMoves, p, p.Character)
            end
            local c = p.CharacterAdded:Connect(function(char)
                task.spawn(_watchEnemyAntiMoves, p, char)
            end)
            _antiMovesRespawnConns[p] = c
        end
    end)
end)
local _antiMovesPlayerRemovingConn = Players.PlayerRemoving:Connect(function(p)
    if _antiMovesCharConns[p] then
        pcall(function() _antiMovesCharConns[p]:Disconnect() end)
        _antiMovesCharConns[p] = nil
    end
    if _antiMovesRespawnConns[p] then
        pcall(function() _antiMovesRespawnConns[p]:Disconnect() end)
        _antiMovesRespawnConns[p] = nil
    end
end)

workspace.FallenPartsDestroyHeight = 0/0
local _voidProtConn = workspace:GetPropertyChangedSignal("FallenPartsDestroyHeight"):Connect(function()
    local h = workspace.FallenPartsDestroyHeight
    if h == h then
        workspace.FallenPartsDestroyHeight = 0/0
    end
end)
local _voidFloor = Instance.new("Part", workspace)
_voidFloor.CFrame       = CFrame.new(0, -10008, 0)
_voidFloor.Anchored     = true
_voidFloor.Size         = Vector3.new(2048, 10, 2048)
_voidFloor.Transparency = 0.5
_voidFloor.CanCollide   = true
_voidFloor.Name         = game:GetService("HttpService"):GenerateGUID()
local _voidSavedHealth   = 100
local _voidHealthConn    = nil
local _voidRenderConn    = nil
local _voidCharConn      = nil
local function _hookVoidProtChar(char)
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
    if not hum or not root then return end
    _voidSavedHealth = hum.Health
    if _voidHealthConn then _voidHealthConn:Disconnect() _voidHealthConn = nil end
    if _voidRenderConn then _voidRenderConn:Disconnect() _voidRenderConn = nil end
    _voidRenderConn = RunService.RenderStepped:Connect(function()
        local r = char:FindFirstChild("HumanoidRootPart")
        if r then
            _voidSavedHealth = hum.Health
            _voidFloor.CFrame = CFrame.new(r.Position.X, -10008, r.Position.Z)
        end
    end)
    _voidHealthConn = hum.HealthChanged:Connect(function(hp)
        local r = char:FindFirstChild("HumanoidRootPart")
        if hp <= 0 and r and r.CFrame.Y <= 0 then
            hum.Health = _voidSavedHealth
        end
    end)
end
_hookVoidProtChar(lp.Character)
_voidCharConn = lp.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    _hookVoidProtChar(char)
end)
local _movingExclusionConns = {}
local _movingExclusionOwned = setmetatable({}, { __mode = "k" })
local function _ensureMovingExclusion(char)
    if not char then return nil end
    local existing = char:FindFirstChild("MovingExclusion")
    if existing then return existing end
    local marker = Instance.new("Folder")
    marker.Name = "MovingExclusion"
    pcall(function() marker:SetAttribute("ZKAYOwned", true) end)
    marker.Parent = char
    _movingExclusionOwned[marker] = true
    return marker
end
local function _hookMovingExclusionChar(char)
    if not char then return end
    _ensureMovingExclusion(char)
    local conn = char.ChildRemoved:Connect(function(child)
        if child.Name == "MovingExclusion" then
            task.defer(_ensureMovingExclusion, char)
        end
    end)
    table.insert(_movingExclusionConns, conn)
end
_hookMovingExclusionChar(lp.Character)
table.insert(_movingExclusionConns, lp.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    _hookMovingExclusionChar(char)
end))
local invisBusy           = false
local cachedAnimTrack     = nil
local cachedAnimHumanoid  = nil
local lastRealCFrame      = nil
local _invisPartConns     = {}
local InvisibleModel    = Instance.new("Model", workspace)
local InvisibleHumanoid = Instance.new("Humanoid", InvisibleModel)
local InvisiblePart30   = Instance.new("Part", InvisibleModel)
InvisiblePart30.Name         = "HumanoidRootPart"
InvisiblePart30.CanCollide   = false
InvisiblePart30.Transparency = 1
InvisiblePart30.Anchored     = true
InvisiblePart30.Size         = Vector3.new(2, 2, 1)
getgenv().InvisHumanoid = InvisibleHumanoid
getgenv().InvisPart30   = InvisiblePart30
local InvisibilityActive = false

local function stopInvisibility()
    if not InvisibilityActive then return end
    InvisibilityActive = false
    getgenv().InvisActive = false
    invisBusy = false
    if cachedAnimTrack then
        pcall(function() if cachedAnimTrack.IsPlaying then cachedAnimTrack:Stop() end end)
        cachedAnimTrack = nil
    end
    cachedAnimHumanoid = nil
    local char = lp.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and lastRealCFrame then pcall(function() root.CFrame = lastRealCFrame end) end
        lastRealCFrame = nil
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then pcall(function() workspace.CurrentCamera.CameraSubject = humanoid end) end
        pcall(function() char:SetAttribute("NoHeadLerp", false) end)
        for _, _ic in pairs(_invisPartConns) do pcall(function() _ic:Disconnect() end) end
        _invisPartConns = {}
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end
local function softResetInvisibility()
    if cachedAnimTrack then
        pcall(function() if cachedAnimTrack.IsPlaying then cachedAnimTrack:Stop() end end)
        cachedAnimTrack = nil
    end
    cachedAnimHumanoid = nil
    lastRealCFrame     = nil
    invisBusy          = false
end
local function _hookInvisPart(part)
    if not part:IsA("BasePart") then return end
    if part.Name == "HumanoidRootPart" then return end
    if part.Transparency == 1 then return end
    if part.Name:lower():find("hitbox") then return end
    part.LocalTransparencyModifier = 0.5
    local conn = part:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
        if not InvisibilityActive then return end
        if part.LocalTransparencyModifier ~= 0.5 then
            part.LocalTransparencyModifier = 0.5
        end
    end)
    table.insert(_invisPartConns, conn)
end
local function _hookInvisChar(c)
    for _, part in pairs(c:GetDescendants()) do
        _hookInvisPart(part)
    end
    local _descConn = c.DescendantAdded:Connect(function(desc)
        if InvisibilityActive then _hookInvisPart(desc) end
    end)
    table.insert(_invisPartConns, _descConn)
end
local function startInvisibility()
    if InvisibilityActive then stopInvisibility() return end
    local char     = lp.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root     = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    InvisibilityActive = true
    getgenv().InvisActive = true
    invisBusy = false

    local c = lp.Character
    if c then _hookInvisChar(c) end
end

-- =================================================================
-- HỆ THỐNG TÀNG HÌNH (ĐÃ SỬA LỖI RUNTIME + CÓ NÚT ON/OFF)
-- =================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local _ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local InvisibilityActive = false -- Trạng thái mặc định
local invisBusy = false
local cachedAnimHumanoid = nil
local cachedAnimTrack = nil
local lastRealCFrame = nil

-- GIAO DIỆN NÚT ON/OFF ĐƠN GIẢN
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InvisToggleUI"
ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 140, 0, 35)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
ToggleBtn.Text = "TÀNG HÌNH: OFF"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 15
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

-- Dummy Humanoid & Part phục vụ tàng hình
local InvisibleHumanoid = Instance.new("Humanoid")
local InvisiblePart30 = Instance.new("Part")
InvisiblePart30.Anchored = true
InvisiblePart30.CanCollide = false
InvisiblePart30.Transparency = 1

-- Hàm chuyển đổi trạng thái Bật/Tắt
local function setInvisibilityState(state)
    InvisibilityActive = state
    if InvisibilityActive then
        ToggleBtn.Text = "TÀNG HÌNH: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(60, 255, 60)
    else
        ToggleBtn.Text = "TÀNG HÌNH: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
        
        -- Dọn dẹp Animation khi Tắt
        if cachedAnimTrack then
            pcall(function()
                cachedAnimTrack:Stop()
                cachedAnimTrack:Destroy()
            end)
            cachedAnimTrack = nil
        end
        cachedAnimHumanoid = nil
        
        -- Trả lại độ trong suốt mặc định cho nhân vật
        if lp.Character then
            for _, part in pairs(lp.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency == 0.5 then
                    part.Transparency = 0
                end
            end
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    setInvisibilityState(not InvisibilityActive)
end)

-- Gán hàm vào getgenv để có thể gọi từ Script/UI khác nếu muốn
getgenv().ToggleInvisibility = setInvisibilityState

-- VÒNG LẶP XỬ LÝ C FRAME TÀNG HÌNH
local _invisDesyncHeartbeatConn = RunService.Heartbeat:Connect(function()
    if isUlting or isUsingTF then getgenv().desync = nil end
    local hasDesync = getgenv().desync ~= nil
    
    -- Nếu không bật Tàng hình và không có Desync thì dừng xử lý
    if not InvisibilityActive and not hasDesync then return end
    if invisBusy then return end
    invisBusy = true

    local currentChar     = lp.Character
    local currentHumanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
    local currentRoot     = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
    
    if not currentChar or not currentHumanoid or not currentRoot then 
        invisBusy = false 
        return 
    end

    if currentHumanoid.Health <= 0 then
        if InvisibilityActive then
            setInvisibilityState(false)
        end
        invisBusy = false 
        return
    end

    local realCFrame   = currentRoot.CFrame
    local realVelocity = currentRoot.Velocity
    lastRealCFrame     = realCFrame
    local currentCamera = workspace.CurrentCamera
    local spoofCFrame = realCFrame

    if hasDesync and not lp.Character:FindFirstChild("AbsoluteImmortal") then
        spoofCFrame = (getgenv().desync and getgenv().desync.CFrame) or spoofCFrame
    end

    if spoofCFrame then
        if currentCamera and not (InvisibilityActive and not hasDesync) then
            currentChar:SetAttribute("NoHeadLerp", true)
            currentCamera.CameraSubject = InvisibleHumanoid
        end

        if is_fighting and fight_cframe then
            InvisiblePart30.CFrame = fight_cframe
        else
            InvisiblePart30.CFrame = realCFrame
        end
        currentRoot.CFrame = spoofCFrame
    end

    -- Ép Animation Tàng Hình
    local invisAnim = nil
    if InvisibilityActive then
        if cachedAnimHumanoid ~= currentHumanoid then
            if cachedAnimTrack then 
                pcall(function() 
                    if cachedAnimTrack.IsPlaying then cachedAnimTrack:Stop() end 
                    cachedAnimTrack:Destroy() 
                end)
                cachedAnimTrack = nil 
            end
            cachedAnimHumanoid = currentHumanoid
        end

        local animator = currentHumanoid:FindFirstChildOfClass("Animator")
        if animator then
            if not cachedAnimTrack or cachedAnimTrack.Parent == nil then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://71181015443030"
                cachedAnimTrack  = animator:LoadAnimation(anim)
                cachedAnimTrack.Priority = Enum.AnimationPriority.Action4
                
                cachedAnimTrack:Play()
                cachedAnimTrack:AdjustSpeed(0)
                cachedAnimTrack:AdjustWeight(2e9)
            end
            invisAnim = cachedAnimTrack
            invisAnim.TimePosition = 13.45
        end
    end

    RunService.RenderStepped:Wait()

    InvisibleHumanoid.CameraOffset = currentHumanoid.CameraOffset
    if currentCamera and currentCamera.CameraSubject == InvisibleHumanoid then
        currentChar:SetAttribute("NoHeadLerp", false)
        currentCamera.CameraSubject = currentHumanoid
    end

    if invisAnim and invisAnim.IsPlaying then 
        pcall(function() invisAnim:Stop() end) 
    end

    if spoofCFrame then
        if is_fighting and fight_cframe then
            currentRoot.CFrame = fight_cframe
        else
            if currentCamera and UIS.MouseBehavior == Enum.MouseBehavior.LockCenter
                and not hasDesync then
                local lv = currentCamera.CFrame.LookVector
                local flatLv = Vector3.new(lv.X, 0, lv.Z)
                if flatLv.Magnitude > 0.001 then
                    currentRoot.CFrame = CFrame.new(realCFrame.Position, realCFrame.Position + flatLv)
                else
                    currentRoot.CFrame = realCFrame
                end
            else
                currentRoot.CFrame = realCFrame
            end
        end
    end

    currentRoot.Velocity = realVelocity
    invisBusy = false
end)

-- HIỆU ỨNG TÀNG HÌNH & DESYNC VISUAL
task.spawn(function()
    local function _initDesyncEffects(char)
        repeat task.wait()
        until (lp.Character == char)
            and char:FindFirstChild('HumanoidRootPart')
            and char:FindFirstChildOfClass('Humanoid')
        if lp.Character ~= char then return end
        local root = char:FindFirstChild('HumanoidRootPart')

        -- Tạo Afterimage
        task.spawn(function()
            while task.wait() and (not lp.Character or lp.Character == char) do
                if getgenv().desync and not char:FindFirstChild('AbsoluteImmortal') then
                    local v901 = {}
                    local ok1, afterimage = pcall(function()
                        return _ReplicatedStorage.Resources.NinjaUlt.Afterimage_Despawn:Clone()
                    end)
                    local ok2, tpthing = pcall(function()
                        return _ReplicatedStorage.Resources.VanishingKick.tpthing:Clone()
                    end)
                    if ok1 and afterimage then
                        afterimage.Parent = root
                        v901[1] = afterimage
                        for _, pe in pairs(afterimage:GetChildren()) do
                            if pe:IsA('ParticleEmitter') then
                                pe.Enabled = true
                                pe.Rate = 100
                            end
                        end
                    end
                    -- Đã sửa lỗi cú pháp 'tpthing me' tại đây
                    if ok2 and tpthing then
                        tpthing.Parent = root
                        v901[2] = tpthing
                        tpthing.Enabled = true
                        tpthing.Rate = 100
                    end
                    repeat
                        if v901[1] and v901[1].Parent then
                            v901[1].CFrame = root.CFrame
                        end
                        RunService.RenderStepped:Wait()
                    until not getgenv().desync or char:FindFirstChild('AbsoluteImmortal')
                    for _, v in pairs(v901) do
                        pcall(function() v:Destroy() end)
                    end
                end
            end
        end)

        -- Làm mờ nhân vật (Transparency = 0.5) khi Bật Tàng hình
        task.spawn(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA('BasePart') and part ~= root and part.Transparency ~= 1
                    and not part.Name:lower():find('hitbox') then
                    task.spawn(function()
                        while task.wait() and (not lp.Character or lp.Character == char) do
                            if part and (InvisibilityActive or (getgenv().desync and not char:FindFirstChild('AbsoluteImmortal'))) then
                                part.Transparency = 0.5
                                repeat
                                    RunService.RenderStepped:Wait()
                                until not InvisibilityActive
                                    and (not getgenv().desync or char:FindFirstChild('AbsoluteImmortal'))
                                    or (lp.Character and lp.Character ~= char)
                                part.Transparency = 0
                            end
                        end
                    end)
                end
            end
        end)
    end

    if lp.Character then task.spawn(_initDesyncEffects, lp.Character) end
    lp.CharacterAdded:Connect(function(char) task.spawn(_initDesyncEffects, char) end)
end)
