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
MiniButton.Image = "rbxassetid://122750288988524"
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
