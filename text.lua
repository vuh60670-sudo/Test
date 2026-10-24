                local function PathEndpoints(Path, endpoints)
                    if not Path or #Path == 0 then
                        return Path
                    end
                    local UniquePoint
                    for i, Point in endpoints or {} do
                        for i, v in Path do
                            if v.row == Point.row and v.col == Point.col then
                                UniquePoint = {row = Point.row,col = Point.col}
                                break
                            end
                        end
                        if UniquePoint then
                            break
                        end
                    end
                    if not UniquePoint then
                        local PointsInPath = {}
                        for i, Point in Path do
                            local TableKey = GetPlaceKey(Point)
                            PointsInPath[TableKey] = Point
                        end
                        for i, Point in Path do
                            local Nearby = 0
                            -- ⬇️ FIXED LINE ⬇️
                            local Directions = {{Point.row - 1, Point.col}, {Point.row + 1, Point.col}, {Point.row, Point.col - 1}, {Point.row, Point.col + 1}}
                            -- ⬆️ FIXED LINE ⬆️
                            for i, Data in Directions do
                                local Row = Data[1]
                                local Col = Data[2]
                                local TableKey = `{Row}-{Col}`
                                if PointsInPath[TableKey] ~= nil then
                                    Nearby += 1
                                end
                            end
                            if Nearby == 1 then
                                UniquePoint = {row = Point.row,col = Point.col}
                                break
                            end
                        end
                    end
                    if not UniquePoint then
                        UniquePoint = {row = Path[1].row,col = Path[1].col}
                    end
                    local Remaining = {}
                    for i,Point in Path do
                        local TableKey = GetPlaceKey(Point)
                        local CurrentTableKey = {row = Point.row,col = Point.col}
                        Remaining[TableKey] = CurrentTableKey
                    end
                    local Ordered = {}
                    local CurrentTableKey = {row = UniquePoint.row,col = UniquePoint.col}
                    local ClonedTable = table.clone(CurrentTableKey)
                    setmetatable(ClonedTable, nil)
                    table.insert(Ordered, ClonedTable)
                    local TableKey = GetPlaceKey(CurrentTableKey)
                    Remaining[TableKey] = nil
                    while true do
                        local Size = 0
                        for i in Remaining do
                            Size += 1
                        end
                        if not (Size > 0) then
                            break
                        end
                        local foundNext = false
                        for key, Point in Remaining do
                            local Direction = NearbyDirection(CurrentTableKey.row,CurrentTableKey.col,Point.row,Point.col)
                            if Direction ~= "" and Direction then
                                local ClonedPoint = table.clone(Point)
                                setmetatable(ClonedPoint, nil)
                                table.insert(Ordered, ClonedPoint)
                                Remaining[key] = nil
                                CurrentTableKey = Point
                                foundNext = true
                                break
                            end
                        end
                        if not foundNext then
                            return Path
                        end
                    end
                    return Ordered
                end
                local function ActivatePuzzlePathfind(self, Puzzle, UI)
                    if not Puzzle or not Puzzle.Solution then
                        return nil
                    end
                    local TotalPaths = #Puzzle.Solution
                    local PuzzlePoints = {}
                    local CanIncrease = false
                    for i = 1,TotalPaths do
                        table.insert(PuzzlePoints, i)
                    end
                    for i = #PuzzlePoints-1, 2, -1 do
                        local RandomChoice = math.random(1,i)
                        local Temp = PuzzlePoints[i+1]
                        PuzzlePoints[i+1] = PuzzlePoints[RandomChoice+1]
                        PuzzlePoints[RandomChoice+1] = Temp
                    end
                    local IsActiveConnection
                    local function Restart()
                        if not GetValue("AutoGeneratorPuzzle") then return end
                        for i, Color in PuzzlePoints do
                            local Path = Puzzle.Solution[Color]
                            local endpoints = Puzzle.targetPairs[Color]
                            local CompletePath = PathEndpoints(Path, endpoints)
                            Puzzle.paths[Color] = {}
                            for i = 0, #CompletePath - 1 do
                                local Point = CompletePath[i + 1]
                                local ColorData = Puzzle.paths[Color]
                                local TableKey = {row = Point.row,col = Point.col}
                                table.insert(ColorData,TableKey)
                                local Last = CompletePath[i]
                                local Next = CompletePath[i + 2]
                                local PuzzleConnections = GetPuzzleConnections(Last, Point, Next)
                                Puzzle.gridConnections = Puzzle.gridConnections or {}
                                Puzzle.gridConnections[`{Point.row}-{Point.col}`] = PuzzleConnections
                                if not GetValue("AutoGeneratorPuzzle") then
                                    break
                                elseif not UI or not UI.Parent then
                                    IsActiveConnection:Disconnect()
                                    break
                                end
                                Puzzle:updateGui()
                                task.wait(GetValue("GeneratorCooldown",true):GetAttribute("CurrentSpeed"))
                                if not GetValue("AutoGeneratorPuzzle") then
                                    break
                                elseif not UI or not UI.Parent then
                                    IsActiveConnection:Disconnect()
                                    break
                                end
                            end
                            if not GetValue("AutoGeneratorPuzzle") then
                                break
                            elseif not UI or not UI.Parent then
                                IsActiveConnection:Disconnect()
                                break
                            end
                            Puzzle:checkForWin()
                        end
                    end
                    IsActiveConnection = GetValue("AutoGeneratorPuzzle",true):GetPropertyChangedSignal("Value"):Connect(Restart)
                    Restart()
                end
                ActivatePuzzlePathfind(PuzzleData,Data[1],Data[2])
            end,
            ["CustomSetup"] = function(self)
                if GetValue("require") and FlowGame and FlowGame.Name == "FlowGame" then
                    if FlowGame:FindFirstChild("Settings") then
                        local SettingsModule = require(FlowGame:FindFirstChild("Settings"))
                        self.DefaultInstanceValue = SettingsModule and SettingsModule.DefaultGridSize or self.DefaultInstanceValue
                    end
                    local FlowGameFunctions = require(FlowGame)
                    local Original = FlowGameFunctions.new
                    function FlowGameFunctions.new(...)
                        local Args = {...}
                        if type(Args[2]) == type(0) or not Args[2] then
                            Args[2] = GetValue("EnableOverride") and GetValue("GridSize") or Args[2]
                            GetValue("GeneratorCooldown",true):SetAttribute("CurrentGrid",Args[2])
                            local Result = {Original(table.unpack(Args))}
                            task.delay(0.35,self.HandlePuzzle,{Result[1],Args[1]})
                            return Result[1]
                        else
                            self.Requirement = true
                            return Original(table.unpack(Args))
                        end
                    end
                else
                    self.Requirement = true
                end
            end
        },
        ["AutoHatchet"] = {
            ["DisplayDescription"] = "Uses the hatchet ability when a killer is near you",
            ["DisplayTitle"] = '<stroke thickness="0.7">Jane Doe</stroke> Auto Hatchet',
            ["LayoutOrder"] = 19,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Survivor:JaneDoe",
            ["Levels"] = ReplicatedStorage:FindFirstChild("Resonance",true) and ReplicatedStorage:FindFirstChild("Resonance",true):FindFirstChild("ParticleHolder",true),
            ["AbilityNames"] = {"Hatchet","Axe"},
            ["ExtraData"] = {
                ["Accuracy"] = 80,
                ["Range"] = 13
            },
            ["ScriptFunction"] = function(self, Value)
                local BlockAbilityUI = MainUI and MainUI:FindFirstChild("AbilityContainer")
                if not BlockAbilityUI then return end
                for i,v in BlockAbilityUI:GetChildren() do
                    if table.find(self.AbilityNames,v.Name) then
                       BlockAbilityUI = v
                    end
                end
                local AutoImage = BlockAbilityUI and BlockAbilityUI:FindFirstChild("AutoImage")
                if Value and AutoImage and LocalCharacter.Name:lower():find("jane") then
                    AutoImage.Visible = true
                elseif AutoImage then
                    AutoImage.Visible = false
                end
            end,
            ["SetupUI"] = function(self,AbilityContainer)
                if AbilityContainer.Name == "AbilityContainer" then
                    local Found
                    for i,v in AbilityContainer:GetChildren() do
                        if table.find(self.AbilityNames,v.Name) then
                            Found = v
                        end
                    end
                    if Found and not Found:FindFirstChild("AutoImage") then
                        local AutoImage = Instance.new("ImageLabel")
                        AutoImage.Name = "AutoImage"
                        AutoImage.Interactable = false
                        AutoImage.Parent = Found
                        AutoImage.Image = "rbxassetid://114159864966636"
                        AutoImage.BackgroundTransparency = 1
                        AutoImage.Size = UDim2.fromScale(0.8,0.8)
                        AutoImage.Position = UDim2.fromScale(0.5,0)
                        AutoImage.AnchorPoint = Vector2.new(0.5,0.4)
                        AutoImage.Visible = GetValue("AutoHatchet") and LocalCharacter.Parent.Name:find("Survi") and LocalCharacter.Name:lower():find("jane")
                    end
                end
            end,
            ["GetCharacterLevel"] = function(self, Character)
                if not Character then return 0 end
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                local RootPart = Character:FindFirstChild("HumanoidRootPart") or Humanoid and Humanoid.RootPart
                if not RootPart or not self.Levels then return 0 end
                local Level = 0
                for i, Attachment in self.Levels:GetChildren() do
                    if Attachment:IsA("Attachment") then
                        local Number = tonumber(Attachment.Name:match("%d+"))
                        if Number and Number > Level then
                            local Matches = true
                            for i2, Effect in Attachment:GetChildren() do
                                if not RootPart:FindFirstChild(Effect.Name) then
                                    Matches = false
                                    break
                                end
                            end
                            if Matches then
                                Level = Number
                            end
                        end
                    end
                end
                return Level
            end,
            ["GetClosestKiller"] = function(self,Distance)
                Distance = Distance or 55
                local SelectedKiller
                for i,v in KillersFolder:GetChildren() do
                    if Players:GetPlayerFromCharacter(v) and LocalRoot and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 and (v:FindFirstChild("HumanoidRootPart").Position - LocalRoot.Position).Magnitude < Distance then
                        Distance = (v:FindFirstChild("HumanoidRootPart").Position - LocalRoot.Position).Magnitude
                        SelectedKiller = v
                    end
                end
                return SelectedKiller,Distance
            end,
            ["OnLoop"] = function(self)
                local FireSignal = GetFunction(firesignal,FireSignal)
                local UseActorAbility = Network and Network:FindFirstChildOfClass("RemoteEvent")
                local AbilityContainer = MainUI and MainUI:FindFirstChild("AbilityContainer")
                local Ability
                if not AbilityContainer then return end
                for i,v in AbilityContainer:GetChildren() do
                    if table.find(self.AbilityNames,v.Name) then
                        Ability = v
                    end
                end
                if not LocalHumanoid or not LocalCharacter or LocalCharacter:GetAttribute("DisableShiftLockMovement") or LocalCharacter:GetAttribute("DoingActionPower") or not Ability or not Ability:FindFirstChild("Clipping") or Ability:FindFirstChild("Clipping").Visible == false or Ability:FindFirstChild("Clipping").Size.Y.Scale ~= 1 then return end
                if GetValue("AutoHatchet") and (self:GetClosestKiller(GetValue("AutoHatchet",true):GetAttribute("Range"))) and self:GetCharacterLevel(self:GetClosestKiller()) >= GetValue("AutoHatchetLevel") and self:GetClosestKiller():FindFirstChild("HumanoidRootPart") and not self:GetClosestKiller():FindFirstChild("HumanoidRootPart"):FindFirstChild("InvincibleFX") then
                    LocalCharacter:SetAttribute("DoingActionPower",true)
                    if FireSignal and Ability then
                        FireSignal(Ability.MouseButton1Down)
                        FireSignal(Ability.MouseButton1Click)
                    else
                        if GetValue("OfficialGame") then
                            for i,v in self.AbilityNames do
                                UseActorAbility:FireServer("UseActorAbility",{v})
                            end
                        else
                            for i,v in self.AbilityNames do
                                UseActorAbility:FireServer("UseActorAbility",v)
                                UseActorAbility:FireServer("UseActorAbility",{v})
                            end
                        end
                    end
                    local CameraTarget
                    local SelectedVelocity
                    CameraTarget = RunService.RenderStepped:Connect(function()
                        local ClosestKiller,Dis = self:GetClosestKiller()
                        if not ClosestKiller or not ClosestKiller:FindFirstChild("HumanoidRootPart") then return end
                        local KillerRootPos = ClosestKiller:FindFirstChild("HumanoidRootPart").Position
                        local SelectedPosition = Vector3.new(KillerRootPos.X,LocalRoot.Position.Y,KillerRootPos.Z)
                        local TargetCFrame = CFrame.new(LocalRoot.Position, SelectedPosition)
                        LocalCharacter:SetPrimaryPartCFrame(TargetCFrame)
                        if not SelectedVelocity and LocalCharacter:GetAttribute("DisableShiftLockMovement") then
                            LocalRoot.Velocity = TargetCFrame.LookVector * 45
                            SelectedVelocity = LocalRoot.Velocity
                        elseif LocalCharacter:GetAttribute("DisableShiftLockMovement") then
                            SelectedVelocity = LocalRoot.Velocity:Lerp(SelectedVelocity or LocalRoot.Velocity,GetValue("AutoHatchet",true):GetAttribute("Accuracy")/100)
                            LocalRoot.Velocity = SelectedVelocity
                        end
                    end)
                    local Timeout = workspace.DistributedGameTime + 1
                    task.wait(0.6)
                    LocalCharacter:SetAttribute("DisableShiftLockMovement",true)
                    repeat
                        task.wait(0.05)
                    until FOVMultipliers:FindFirstChild("HitRegistered") or workspace.DistributedGameTime > Timeout
                    LocalRoot.Velocity = LocalRoot.Velocity * 0.15
                    CameraTarget:Disconnect()
                    task.wait(0.1)
                    LocalCharacter:SetAttribute("DisableShiftLockMovement",false)
                    task.wait(1.6)
                    LocalCharacter:SetAttribute("DoingActionPower",nil)
                end
            end,
            ["CustomSetup"] = function(self)
                self.DisplayTitle = self.DisplayTitle:gsub("Jane Doe",RichTextGradientColor("Jane Doe",{Color3.fromRGB(196, 171, 126),Color3.fromRGB(156, 107, 46),Color3.fromRGB(185, 96, 214)}))
                if MainUI:FindFirstChild("AbilityContainer") then
                    self:SetupUI(MainUI:FindFirstChild("AbilityContainer"))
                end
                MainUI.ChildAdded:Connect(function(Child)
                    self:SetupUI(Child)
                end)
            end
        },
        ["AutoHatchetLevel"] = {
            ["DisplayDescription"] = "The threshold that triggers auto hatchet",
            ["DisplayTitle"] = "Auto Hatchet Level Threshold",
            ["LayoutOrder"] = 20,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 2,
            ["Requirement"] = "Survivor:JaneDoe|AutoHatchet",
            ["ExtraData"] = {
                ["MaxValue"] = 3,
                ["MinValue"] = 0,
                ["Step"] = 1,
            },
            ["Levels"] = ReplicatedStorage:FindFirstChild("Resonance",true) and ReplicatedStorage:FindFirstChild("Resonance",true):FindFirstChild("ParticleHolder",true),
            ["CustomSetup"] = function(self)
                if self.Levels then
                    local AmountOfLevels = #self.Levels:QueryDescendants("Attachment")
                    self.Instance:SetAttribute("MaxValue",AmountOfLevels)
                    self.DefaultInstanceValue = AmountOfLevels - 1
                    self.Instance.Value = math.clamp(self.Instance.Value,0,AmountOfLevels)
                end
            end
        },
    },
    ["Visuals"] = {
        ["TabAttributes"] = {
            ["DisplayTitle"] = "Visuals",
            ["LayoutOrder"] = 6
        },
        ["DisableNoliNPC"] = {
            ["DisplayDescription"] = "Disables Noli's Distracting NPC",
            ["DisplayTitle"] = "Disable Noli's NPC",
            ["LayoutOrder"] = 1,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:Noli",
            ["HandleNoliNPC"] = function(self,Value)
                if Value then
                    for i,v in KillersFolder:GetChildren() do
                        if v.Name:lower() == "noli" and not Players:GetPlayerFromCharacter(v) then
                            v.Parent = Lighting
                            v:PivotTo(v:GetPivot() * CFrame.new(0,-100,0))
                        end
                    end
                    if workspace:FindFirstChild("Themes") then
                        for i,v in pairs(workspace.Themes:GetChildren()) do
                            if v.Name:find("FakeLayer") and v:IsA("Sound") then
                                v:Destroy()
                            end
                        end
                    end
                else
                    for i,v in Lighting:GetChildren() do
                        if v.Name:lower() == "noli" then
                            v.Parent = InGame
                            v:PivotTo(v:GetPivot() * CFrame.new(0,100,0))
                        end
                    end
                end
            end,
            ["ScriptFunction"] = function(self, Value)
                self:HandleNoliNPC(Value)
            end,
            ["CustomSetup"] = function(self)
                if KillersFolder then
                    KillersFolder.ChildAdded:Connect(function(Child)
                        task.wait(0.5)
                        self:HandleNoliNPC(GetValue("DisableNoliNPC"))
                    end)
                end
            end
        },
        ["Disable007n7NPC"] = {
            ["DisplayDescription"] = "Disables 007n7's Distracting NPC",
            ["DisplayTitle"] = "Disable 007n7's NPC",
            ["LayoutOrder"] = 2,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Survivor:007n7",
            ["Handle007n7NPC"] = function(self,Value)
                if Value then
                    for i,v in InGame:GetChildren() do
                        if v.Name:lower() == "007n7" and not Players:GetPlayerFromCharacter(v) then
                            v.Parent = Lighting
                            if v:FindFirstChild("HumanoidRootPart") then
                                v:FindFirstChild("HumanoidRootPart").ChildAdded:Connect(function(Child)
                                    if Child:IsA("Sound") and GetValue("Disable007n7NPC") then
                                        Child:Destroy()
                                    end
                                end)
                            end
                        end
                    end
                else
                    for i,v in Lighting:GetChildren() do
                        if v.Name:lower() == "007n7" then
                            v.Parent = InGame
                        end
                    end
                end
            end,
            ["ScriptFunction"] = function(self, Value)
                self:Handle007n7NPC(Value)
            end,
            ["CustomSetup"] = function(self)
                if InGame then
                    InGame.ChildAdded:Connect(function(Child)
                        task.wait(0.02)
                        self:Handle007n7NPC(GetValue("Disable007n7NPC"))
                    end)
                end
            end
        },
        ["DisplayCorrectTime"] = {
            ["DisplayDescription"] = "Prevent's Noli's fake timer and always shows the timer",
            ["DisplayTitle"] = "Always Display Correct Timer",
            ["LayoutOrder"] = 3,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["ScriptFunction"] = function(self,Value,Starting)
                if self.TimerUI and not Starting then
                    if Value then
                        self.TimerUI:SetAttribute("Self",true)
                    end
                    self.TimerUI.Text = Value and self:FormatSeconds(self.TimerValue:GetAttribute("TimeLeft")) or self.TimerUI:GetAttribute("Original") or ""
                end
            end,
            ["FormatSeconds"] = function(self,Number)
                if not Number or type(Number) ~= type(0) then return "0:00" end
                local Minutes = math.floor(Number%3600/60)
                local Seconds = math.floor(Number%60)
                return string.format("%d:%02d",Minutes,Seconds)
            end,
            ["CustomSetup"] = function(self)
                local TimerValue = ReplicatedStorage:FindFirstChild("RoundTimer")
                local TimerUI = PlayerGui:FindFirstChild("RoundTimer") and PlayerGui:FindFirstChild("RoundTimer"):FindFirstChild("Time",true)
                if not (TimerValue and TimerUI) then
                    self.Requirement = true
                    return
                end
                self.TimerUI = TimerUI
                self.TimerValue = TimerValue
                TimerUI:SetAttribute("Original",TimerUI.Text)
                TimerUI:GetPropertyChangedSignal("Text"):Connect(function()
                    if TimerUI:GetAttribute("Self") then
                        TimerUI:SetAttribute("Self",nil)
                    else
                        TimerUI:SetAttribute("Original",TimerUI.Text)
                    end
                    if GetValue("DisplayCorrectTime") then
                        TimerUI.Text = self:FormatSeconds(TimerValue:GetAttribute("TimeLeft"))
                    end
                end)
                TimerValue:GetAttributeChangedSignal("TimeLeft"):Connect(function()
                    if GetValue("DisplayCorrectTime") then
                        TimerUI:SetAttribute("Self",true)
                        TimerUI.Text = self:FormatSeconds(TimerValue:GetAttribute("TimeLeft"))
                    end
                end)
                if self.Instance.Value then
                    TimerUI:SetAttribute("Self",true)
                    TimerUI.Text = self:FormatSeconds(TimerValue:GetAttribute("TimeLeft"))
                end
            end
        },
        ["ESP"] = {
            ["DisplayDescription"] = "Track things in the game through walls",
            ["DisplayTitle"] = "ESP",
            ["LayoutOrder"] = 6,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["CheckHighlightDistance"] = function(self,Highlight,TargetRoot,Settings)
                local Camera = TargetRoot and workspace.CurrentCamera
                if not Camera or (Highlight:GetAttribute("Frozen") and not Settings.Instant) then return end
                local Distance = (Camera.CFrame.Position - TargetRoot.Position).Magnitude
                local MinDistance = Settings.MinDistance
                local ShouldHide = Distance < MinDistance or Distance > 1200
                if ShouldHide and Highlight.OutlineTransparency ~= 1 then
                    local Tween = TweenService:Create(Highlight,TweenInfo.new(Settings.Instant and 0 or 0.1),{FillTransparency = 1,OutlineTransparency = 1})
                    Tween.Parent = Highlight
                    Tween:Play()
                    Debris:AddItem(Tween,0.2)
                    return
                end
                if not ShouldHide and Distance >= MinDistance and Distance < 1200 then
                    local TransparencyAmount = math.clamp(1 - math.clamp((Distance - MinDistance) / math.max(Settings.MaxDistance - MinDistance, 0.001),0,1),0.45,1)
                    if math.abs(Highlight.FillTransparency - TransparencyAmount) > 0 then
                        local Tween = TweenService:Create(Highlight,TweenInfo.new(Settings.Instant and 0 or 0.1),{FillTransparency = math.clamp(TransparencyAmount + 0.05,0,1),OutlineTransparency = TransparencyAmount <= 0.95 and TransparencyAmount - 0.05 or TransparencyAmount})
                        Tween.Parent = Highlight
                        Tween:Play()
                        Debris:AddItem(Tween,0.2)
                    end
                end
            end,
            ["CheckTextDistance"] = function(self,Text,Image,TargetRoot,Settings)
                local Camera = TargetRoot and workspace.CurrentCamera
                if not Camera or (Text:GetAttribute("Frozen") and not Settings.Instant) then return end
                local Distance = (Camera.CFrame.Position - TargetRoot.Position).Magnitude
                local MinDistance = Settings.MinDistance
                if Distance > MinDistance and Distance < 1200 and Text.TextTransparency ~= 0 then
                    local Tween = TweenService:Create(Text,TweenInfo.new(Settings.Instant and 0 or 0.1),{TextTransparency = 0,TextStrokeTransparency = 0})
                    local Tween2 = TweenService:Create(Image,TweenInfo.new(Settings.Instant and 0 or 0.1),{ImageTransparency = 0})
                    Tween.Parent = TargetRoot
                    Tween2.Parent = TargetRoot
                    Tween:Play()
                    Tween2:Play()
                    Debris:AddItem(Tween,0.2)
                elseif Distance <= MinDistance or Distance >= 1200 and Text.TextTransparency ~= 1 then
                    local Tween = TweenService:Create(Text,TweenInfo.new(Settings.Instant and 0 or 0.1),{TextTransparency = 1,TextStrokeTransparency = 1})
                    local Tween2 = TweenService:Create(Image,TweenInfo.new(Settings.Instant and 0 or 0.1),{ImageTransparency = 1})
                    Tween.Parent = TargetRoot
                    Tween2.Parent = TargetRoot
                    Tween:Play()
                    Tween2:Play()
                    Debris:AddItem(Tween,0.2)
                end
            end,
            ["CreateDynamicHighlight"] = function(self,Enabled,ItemInstance,TargetRoot,Settings)
                Settings = type(Settings) == "table" and Settings or {["MaxDistance"] = 100,["MinDistance"] = 10,["Color"] = Color3.new(1,1,1)}
                local Highlight:Highlight? = ItemInstance:QueryDescendants("Highlight[$Dynamic]")
                local ExistingHighlights = ItemInstance:QueryDescendants("Highlight:not([$Dynamic])")
                if Enabled and GetValue("ESP") then
                    if not Highlight[1] then
                        Highlight = Instance.new("Highlight")
                        Highlight.Name = HttpService:GenerateGUID(false):sub(1,7)
                        Highlight.Archivable = false
                        local H, S, V = Settings.Color:ToHSV()
                        Highlight.FillColor = Color3.fromHSV(H, S, V * 0.8)
                        Highlight.OutlineColor = Color3.fromHSV(H, S, V * 1.1)
                        Highlight:SetAttribute("Dynamic",true)
                        Highlight.Parent = ItemInstance
                        Highlight.Adornee = ItemInstance
                        Highlight.FillTransparency = 1
                        Highlight.OutlineTransparency = 1
                        self:CheckHighlightDistance(Highlight, TargetRoot, Settings)
                        local Connection;Connection = workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
                            if Highlight and Highlight.Parent then
                                for i,v in Highlight:GetChildren() do v:Cancel() end
                                Highlight.FillTransparency = 0.95
                                Highlight.OutlineTransparency = 0.95
                            else
                                Connection:Disconnect()
                            end
                        end)
                        Highlight.Destroying:Once(function()
                            if Connection then Connection:Disconnect() end
                        end)
                        Highlight.Parent:GetPropertyChangedSignal("Parent"):Once(function()
                            Highlight:Destroy()
                        end)
                    else
                        Highlight = Highlight[1]
                        local H, S, V = Settings.Color:ToHSV()
                        Highlight.FillColor = Color3.fromHSV(H, S, V * 0.8)
                        Highlight.OutlineColor = Color3.fromHSV(H, S, V * 1.1)
                        self:CheckHighlightDistance(Highlight, TargetRoot, Settings)
                    end
                    for i,v in ExistingHighlights do v.Enabled = false end
                elseif Highlight[1] then
                    for i,v in ExistingHighlights do v.Enabled = true end
                    Highlight[1]:Destroy()
                end
            end,
            ["CreateText"] = function(self,Enabled,ItemInstance,TargetRoot,Settings)
                Settings = type(Settings) == "table" and Settings or {["MinDistance"] = 10,["Color"] = Color3.new(1,1,1)}
                local BillboardGui = ItemInstance:QueryDescendants("BillboardGui[$Dynamic]")
                if Enabled and GetValue("ShowText") and GetValue("ESP") then
                    if not BillboardGui[1] then
                        BillboardGui = Instance.new("BillboardGui")
                        local TextLabel = Instance.new("TextLabel")
                        local ImageLabel = Instance.new("ImageLabel")
                        local AspectRatio = Instance.new("UIAspectRatioConstraint")
                        BillboardGui.Name = HttpService:GenerateGUID(false):sub(1,7)
                        BillboardGui.Archivable = false
                        BillboardGui.Size = ItemInstance:IsA("Tool") and UDim2.new(1.5, 30, 0.75, 30) or UDim2.new(1.5,60,0.75,25)
                        BillboardGui["StudsOffset"] = Settings.Size or ItemInstance:IsA("Tool") and Vector3.new(0,3,0) or Vector3.new(0,4,0)
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.ResetOnSpawn = true
                        BillboardGui.Adornee = TargetRoot
                        BillboardGui:SetAttribute("Dynamic",true)
                        TextLabel.Text = Settings.Text or "Unknown"
                        local H, S, V = Settings.Color:ToHSV()
                        TextLabel.TextColor3 = Color3.fromHSV(H, S, V * 1.1)
                        TextLabel.AnchorPoint = Vector2.new(0.5,0.5)
                        TextLabel.Position = UDim2.fromScale(0.5,0.5)
                        TextLabel.Size = UDim2.fromScale(1,1)
                        TextLabel.TextScaled = true
                        TextLabel.BackgroundTransparency = 1
                        TextLabel.TextStrokeTransparency = 0
                        TextLabel.TextSize = 8
                        TextLabel.Parent = BillboardGui
                        ImageLabel.BackgroundTransparency = 1
                        ImageLabel.ImageColor3 = Settings.Color
                        ImageLabel.Position = UDim2.fromScale(0.5,0)
                        ImageLabel.Size = UDim2.fromScale(1,1)
                        ImageLabel.AnchorPoint = Vector2.new(0.5,0.65)
                        ImageLabel.Image = type(Settings.Image) == type(0) and "rbxassetid://" .. Settings.Image or Settings.Image or ""
                        ImageLabel.Parent = BillboardGui
                        AspectRatio.Parent = ImageLabel
                        BillboardGui:GetPropertyChangedSignal("Size"):Connect(function()
                            BillboardGui.Size = ItemInstance:IsA("Tool") and UDim2.new(1.5, 30, 0.75, 30) or UDim2.new(1.5,60,0.75,25)
                        end)
                        BillboardGui:GetPropertyChangedSignal("StudsOffset"):Connect(function()
                            BillboardGui["StudsOffset"] = Settings.Size or ItemInstance:IsA("Tool") and Vector3.new(0,3,0) or Vector3.new(0,4,0)
                        end)
                        BillboardGui.Parent = TargetRoot
                        self:CheckTextDistance(TextLabel,ImageLabel,TargetRoot,Settings)
                        local Connection;Connection = workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
                            if BillboardGui and BillboardGui.Parent then
                                for i,v in TextLabel:GetChildren() do v:Cancel() end
                                TextLabel.TextTransparency = 0.95
                                TextLabel.TextStrokeTransparency = 0.95
                            else
                                Connection:Disconnect()
                            end
                        end)
                        BillboardGui.Destroying:Once(function()
                            if Connection then Connection:Disconnect() end
                        end)
                        BillboardGui.Parent:GetPropertyChangedSignal("Parent"):Once(function()
                            BillboardGui:Destroy()
                        end)
                    else
                        BillboardGui = BillboardGui[1]
                        local H, S, V = Settings.Color:ToHSV()
                        local TextLabel = BillboardGui:FindFirstChild("TextLabel")
                        local Image = BillboardGui:FindFirstChild("ImageLabel")
                        TextLabel.TextColor3 = Color3.fromHSV(H, S, V * 1.1)
                        Image.ImageColor3 = Settings.Color
                        Image.Image = type(Settings.Image) == type(0) and "rbxassetid://" .. Settings.Image or Settings.Image or ""
                        self:CheckTextDistance(TextLabel,Image,TargetRoot,Settings)
                    end
                elseif BillboardGui[1] then
                    BillboardGui[1]:Destroy()
                end
            end,
            ["OnLoop"] = function(self)
                local fireprompt = fireproximityprompt or function(ProximityPrompt)
                    if ProximityPrompt then
                        ProximityPrompt:InputHoldBegin();ProximityPrompt:InputHoldEnd()
                    end
                end
                for i,v in PlayersFolder:QueryDescendants("#Killers > Instance,#Survivors > Instance") do
                    task.spawn(function()
                        local Player = v ~= LocalPlayer.Character and Players:GetPlayerFromCharacter(v)
                        if Player and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 and MainUI.Enabled == true then
                            local FolderName = v.Parent.Name
                            local FeatureValue, ColorValue, TargetRoot = GetValue(FolderName.."ESP"), ColorPresets[GetValue(FolderName.."Color")], v:FindFirstChild("HumanoidRootPart")
                            self:CreateDynamicHighlight(FeatureValue, v, TargetRoot, {MaxDistance = 100,MinDistance = 10,Color = ColorValue })
                            self:CreateText(FeatureValue, v, TargetRoot, {MinDistance = 25,Text = Player.Name,Color = ColorValue})
                        else
                            self:CreateDynamicHighlight(false, v)
                            self:CreateText(false, v)
                        end
                    end)
                end
                if InGame then
                    local ModelData = {
                        ["VineModel"] = {"Vine",ColorPresets["Purple"]},
                        ["GroundBulbModel"] = {"Bulb",ColorPresets["Purple"]},
                        ["SubspaceTripmine"] = {"Mine",ColorPresets["Orange"]},
                        ["PizzaDeliveryRig"] = {"NPC",ColorPresets["Orange"]},
                        ["TaphTripwire"] = {"Wire",ColorPresets["Light Green"]},
                        ["BuildermanDispenser"] = {"Dispenser",ColorPresets["Light Green"]},
                        ["BuildermanSentry"] = {"Sentry",ColorPresets["Red"]},
                        ["Document"] = {"Contract",ColorPresets["Red"]},
                        ["Gear"] = {"Gear",ColorPresets["White"]}
                    }
                    for i,v in InGame:QueryDescendants("#VineModel,Model#Gear:has(Highlight),#GroundBulbModel,#SubspaceTripmine,#BuildermanDispenser,#PizzaDeliveryRig:has(Humanoid),#BuildermanSentry,Model:has(BasePart#Wire)") do
                        task.spawn(function()
                            local FoundMatch
                            for i2,v2 in ModelData do
                                if v.Name:lower():find(i2:lower()) then
                                    FoundMatch = v2
                                    break
                                end
                            end
                            local FeatureValue, ColorValue, TargetRoot = GetValue("OtherESP"), FoundMatch and FoundMatch[2] or ColorPresets["White"], v:IsA("Model") and v.PrimaryPart or v:FindFirstChild("RootPart") or v:FindFirstChildWhichIsA("BasePart")
                            self:CreateDynamicHighlight(FeatureValue, v, TargetRoot, {MaxDistance = 100,MinDistance = 12,Color = ColorValue})
                            self:CreateText(FeatureValue, v, TargetRoot, {MinDistance = 25,Text = FoundMatch and FoundMatch[1] or v.Name, Color = FoundMatch and FoundMatch[2] or ColorValue})
                        end)
                    end
                    for i,v in workspace:GetChildren() do
                        if v:IsA("MeshPart") and v:FindFirstChild("Moving Outward Burst") then
                            local FeatureValue, ColorValue, TargetRoot = GetValue("OtherESP"), ModelData["Document"] and ModelData["Document"][2] or ColorPresets["White"], v
                            self:CreateDynamicHighlight(FeatureValue and not v:GetAttribute("Team") or v:GetAttribute("Team") ~= LocalCharacter.Parent.Name, v, TargetRoot, {MaxDistance = 100,MinDistance = 12,Color = ColorValue})
                            self:CreateText(FeatureValue, v, TargetRoot, {MinDistance = 25,Text = ModelData["Document"] and ModelData["Document"][1] or v.Name, Color = ColorValue})
                        end
                    end
                end
                if InGame and GameMap then
                    task.spawn(function()
                        local Tools = InGame:QueryDescendants("Tool:not(Flag)")
                        for i,v in Tools do
                            if v.Parent:IsA("Model") and v.Parent:FindFirstChildOfClass("Humanoid") then continue end
                            local FeatureValue, ColorValue, TargetRoot = GetValue("ItemsESP"), ColorPresets[GetValue("ItemsColor")], v:FindFirstChildWhichIsA("BasePart")
                            self:CreateDynamicHighlight(FeatureValue, v, TargetRoot, {MaxDistance = 100,MinDistance = 12,Color = ColorValue})
                            self:CreateText(FeatureValue, v, TargetRoot, {MinDistance = 25,Text = v:FindFirstChildWhichIsA("ProximityPrompt",true) and v:FindFirstChildWhichIsA("ProximityPrompt",true).ActionText or v.Name, Color = ColorValue})
                            if (not LocalCharacter:FindFirstChildOfClass("Tool") or LocalCharacter:FindFirstChildOfClass("Tool").Name ~= v.Name) and not (LocalPlayer:FindFirstChildOfClass("Backpack") and LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(v.Name)) and not v:GetAttribute("JustDropped") and GetValue("AutoPickup") then
                                local Param = OverlapParams.new()
                                Param.BruteForceAllSlow = true
                                Param.IncludeInstances = {v}
                                local Result = workspace:GetPartBoundsInRadius(LocalRoot.Position, 4.5, Param)
                                if LocalRoot and #Result > 0 and v:FindFirstChildWhichIsA("ProximityPrompt",true) then
                                    fireprompt(v:FindFirstChildWhichIsA("ProximityPrompt",true))
                                end
                            end
                        end
                    end)
                    for i,v in GameMap:QueryDescendants("Model#Gear:has(#Root)") do
                        if GetValue("AutoPickup") then
                            local Param = OverlapParams.new()
                            Param.BruteForceAllSlow = true
                            Param.IncludeInstances = {v}
                            local Result = workspace:GetPartBoundsInRadius(LocalRoot.Position, 4.5, Param)
                            if LocalRoot and #Result > 0 and v:FindFirstChildWhichIsA("ProximityPrompt",true) then
                                fireprompt(v:FindFirstChildWhichIsA("ProximityPrompt",true))
                            end
                        end
                    end
                    local GeneratorImages = {["ConnectServerMinigame"] = 99080479259815,["GearServerMinigame"] = 81454811776080,["FlowServerMinigame"] = 110241164394153,["LockServerMinigame"] = 108612249774904}
                    for i,v in GameMap:QueryDescendants("Model#Generator:has(#Main)") do
                        local ProgressValue = v:FindFirstChild("BarUI",true) and v:FindFirstChild("BarUI",true):FindFirstChild("Bar") and v:FindFirstChild("BarUI",true):FindFirstChild("Bar").Size.X.Scale
                        task.spawn(function()
                            if (GetValue("GeneratorsCheck")) == true and ProgressValue and ProgressValue >= 1 then
                                self:CreateDynamicHighlight(false, v)
                                self:CreateText(false, v)
                            elseif ProgressValue then
                                local FeatureValue, ColorValue, TargetRoot = GetValue("GeneratorsESP"), ColorPresets[GetValue("GeneratorsColor")], v:FindFirstChild("Main") or v:WaitForChild("Main")
                                self:CreateDynamicHighlight(FeatureValue, v, TargetRoot, { MaxDistance = 100,MinDistance = 12,Color = ColorValue})
                                self:CreateText(FeatureValue, v, TargetRoot, { MinDistance = 25,Text = v.Name,Color = ColorValue,Image = v:GetAttribute("Puzzle") and GetValue("GeneratorPuzzleIcon") and GeneratorImages[v:GetAttribute("Puzzle")] or nil})
                            end
                        end)
                    end
                end
            end
        },
        ["ShowText"] = {
            ["DisplayDescription"] = "Show text over the highlighted objects",
            ["DisplayTitle"] = "Show Text",
            ["LayoutOrder"] = 7,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = "ESP",
            ["ScriptFunction"] = function(self,Value,Starting)
                if not Value and GetValue("GeneratorPuzzleIcon",true) and not Starting then
                    GetValue("GeneratorPuzzleIcon",true).Value = false
                end
            end
        },
        ["KillersESP"] = {
            ["DisplayDescription"] = "Enables ESP for the killer(s)",
            ["DisplayTitle"] = "Killer(s) (ESP)",
            ["LayoutOrder"] = 9,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "ESP",
        },
        ["KillersColor"] = {
            ["DisplayDescription"] = "Select a Color for Killer(s) (ESP)",
            ["DisplayTitle"] = "Killer(s) Color",
            ["LayoutOrder"] = 10,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Red",
            ["Requirement"] = "ESP|KillersESP",
            ["ExtraData"] = { ["Options"] = "Red|Orange|Purple|Gold" },
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then task.wait() end
                local Name = "Killer(s)"
                local H, S, V = ColorPresets[Value]:ToHSV()
                local Color = ColorPresets[Value]
                local DarkerColor = Color3.fromHSV(H, S, V * 0.7)
                for i,v in FeatureLoadout["Visuals"] do
                    if v["DisplayTitle"]:find(Name,1,true) then
                        local ColoredName = RichTextGradientColor(Name,{Color,DarkerColor})
                        local FormattedName = Name:gsub("([%(%)])", "%%%1")
                        local ColoredText = v["DisplayTitle"]:gsub(FormattedName, ColoredName, 1)
                        if v["Instance"] then
                            v["Instance"]:SetAttribute("DisplayTitle",ColoredText)
                        else
                            v["DisplayTitle"] = ColoredText
                        end
                    end
                end
            end
        },
        ["SurvivorsESP"] = {
            ["DisplayDescription"] = "Enables ESP for the survivor(s)",
            ["DisplayTitle"] = "Survivor(s) (ESP)",
            ["LayoutOrder"] = 11,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "ESP",
        },
        ["SurvivorsColor"] = {
            ["DisplayDescription"] = "Select a Color for Survivor(s) (ESP)",
            ["DisplayTitle"] = "Survivor(s) Color",
            ["LayoutOrder"] = 12,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Green",
            ["Requirement"] = "ESP|SurvivorsESP",
            ["ExtraData"] = { ["Options"] = "Green|Orange|Purple|Gold" },
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then task.wait() end
                local Name = "Survivor(s)"
                local H, S, V = ColorPresets[Value]:ToHSV()
                local Color = ColorPresets[Value]
                local DarkerColor = Color3.fromHSV(H, S, V * 0.7)
                for i,v in FeatureLoadout["Visuals"] do
                    if v["DisplayTitle"]:find(Name,1,true) then
                        local ColoredName = RichTextGradientColor(Name,{Color,DarkerColor})
                        local FormattedName = Name:gsub("([%(%)])", "%%%1")
                        local ColoredText = v["DisplayTitle"]:gsub(FormattedName, ColoredName, 1)
                        if v["Instance"] then
                            v["Instance"]:SetAttribute("DisplayTitle",ColoredText)
                        else
                            v["DisplayTitle"] = ColoredText
                        end
                    end
                end
            end
        },
        ["GeneratorsESP"] = {
            ["DisplayDescription"] = "Enables ESP for the Generator(s)",
            ["DisplayTitle"] = "Generator(s) (ESP)",
            ["LayoutOrder"] = 13,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "ESP",
        },
        ["GeneratorsColor"] = {
            ["DisplayDescription"] = "Select a Color for Generator(s) (ESP)",
            ["DisplayTitle"] = "Generator(s) Color",
            ["LayoutOrder"] = 14,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Cyan",
            ["Requirement"] = "ESP|GeneratorsESP",
            ["ExtraData"] = { ["Options"] = "Cyan|Blue|Green|Orange|Purple|Gold" },
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then task.wait() end
                local Name = "Generator(s)"
                local H, S, V = ColorPresets[Value]:ToHSV()
                local Color = ColorPresets[Value]
                local DarkerColor = Color3.fromHSV(H, S, V * 0.7)
                local ExtraSelected = {GetValue("GridSize",true),GetValue("AutoGeneratorPuzzle",true),GetValue("EnableOverride",true)}
                for i,v in FeatureLoadout["Visuals"] do
                    if v["DisplayTitle"]:find(Name,1,true) then
                        local ColoredName = RichTextGradientColor(Name,{Color,DarkerColor})
                        local FormattedName = Name:gsub("([%(%)])", "%%%1")
                        local ColoredText = v["DisplayTitle"]:gsub(FormattedName, ColoredName, 1)
                        if v["Instance"] then
                            v["Instance"]:SetAttribute("DisplayTitle",ColoredText)
                        else
                            v["DisplayTitle"] = ColoredText
                        end
                    end
                end
                for i,v in ExtraSelected do
                    local ColoredName = RichTextGradientColor(Name,{Color,DarkerColor})
                    local FormattedName = Name:gsub("([%(%)])", "%%%1")
                    local CleanTitle = v:GetAttribute("DisplayTitle"):gsub("<[^>]->", "")
                    local ColoredText = CleanTitle:gsub(FormattedName, ColoredName, 1)
                    v:SetAttribute("DisplayTitle",ColoredText)
                end
            end
        },
        ["GeneratorsCheck"] = {
            ["DisplayDescription"] = "Hides Generator(s) That are Completed (ESP)",
            ["DisplayTitle"] = "Hide Completed Generator(s)",
            ["LayoutOrder"] = 15,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = "ESP|GeneratorsESP",
        },
        ["GeneratorPuzzleIcon"] = {
            ["DisplayDescription"] = "Shows Icons based on the Generator's Puzzle (ESP)",
            ["DisplayTitle"] = "Puzzle Icons Over Generator(s)",
            ["LayoutOrder"] = 16,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = ConnectBoard and "ESP|GeneratorsESP" or true,
            ["ScriptFunction"] = function(self, Value, Starting)
                 if Value and ConnectBoard and GetValue("ShowText",true) and not Starting then
                    GetValue("ShowText",true).Value = true
                end
            end
        },
        ["ItemsESP"] = {
            ["DisplayDescription"] = "Enables ESP for the Item(s)",
            ["DisplayTitle"] = "Item(s) (ESP)",
            ["LayoutOrder"] = 20,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "ESP",
        },
        ["ItemsColor"] = {
            ["DisplayDescription"] = "Select a Color for Item(s) (ESP)",
            ["DisplayTitle"] = "Item(s) Color",
            ["LayoutOrder"] = 22,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Gold",
            ["Requirement"] = "ESP|ItemsESP",
            ["ExtraData"] = { ["Options"] = "Gold|Cyan|Purple|White" },
            ["ScriptFunction"] = function(self, Value,Starting)
                if Starting then task.wait() end
                local Name = "Item(s)"
                local H, S, V = ColorPresets[Value]:ToHSV()
                local Color = ColorPresets[Value]
                local DarkerColor = Color3.fromHSV(H, S, V * 0.7)
                for i,v in FeatureLoadout["Visuals"] do
                    if v["DisplayTitle"]:find(Name,1,true) then
                        local ColoredName = RichTextGradientColor(Name,{Color,DarkerColor})
                        local FormattedName = Name:gsub("([%(%)])", "%%%1")
                        local ColoredText = v["DisplayTitle"]:gsub(FormattedName, ColoredName, 1)
                        if v["Instance"] then
                            v["Instance"]:SetAttribute("DisplayTitle",ColoredText)
                        else
                            v["DisplayTitle"] = ColoredText
                        end
                    end
                end
                if ReplicatedStorage:FindFirstChild("GearClientMinigame",true) then
                    GetValue("AutoPickup",true):SetAttribute("DisplayDescription",string.format("Auto-Picks up <b>%s</b> and <b>Gears</b> near you",RichTextGradientColor("Items",{Color,DarkerColor})))
                else
                    GetValue("AutoPickup",true):SetAttribute("DisplayDescription",string.format("Auto-Picks up <b>%s</b> near you",RichTextGradientColor("Items",{Color,DarkerColor})))
                end
            end
        },
        ["OtherESP"] = {
            ["DisplayDescription"] = "Enables ESP for Other Objects",
            ["DisplayTitle"] = "Other ESPs",
            ["LayoutOrder"] = 25,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "ESP",
        },
    },
    ["Miscellaneous"] = {
        ["TabAttributes"] = { ["DisplayTitle"] = "Miscellaneous", ["LayoutOrder"] = 10 },
        ["ExtendedFOV"] = {
            ["DisplayDescription"] = "A extended version of the FOV inside the normal settings",
            ["DisplayTitle"] = "Extended FOV",
            ["LayoutOrder"] = 1,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["FovSetting"] = PlayerData:FindFirstChild("FieldOfView",true) or PlayerData:FindFirstChild("FOV",true),
            ["DefaultInstanceValue"] = PlayerData:FindFirstChild("FieldOfView",true) and PlayerData:FindFirstChild("FieldOfView",true).Value or 70,
            ["ExtraData"] = { ["MaxValue"] = 120, ["MinValue"] = 10, ["Step"] = 5 },
            ["ScriptFunction"] = function(self, Value)
                if self.FovSetting then self.FovSetting.Value = Value end
            end,
            ["CustomSetup"] = function(self)
                if self.FovSetting and self.FovSetting:IsA("NumberValue") then
                    self.FovSetting:GetPropertyChangedSignal("Value"):Connect(function()
                        self.Instance.Value = self.FovSetting.Value
                    end)
                end
            end
        },
        ["ExtendedZoom"] = {
            ["DisplayDescription"] = "Extends the Maximum Zoom Distance for the camera",
            ["DisplayTitle"] = "Extended Zoom Distance",
            ["LayoutOrder"] = 2,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 10,
            ["ExtraData"] = { ["MaxValue"] = 100, ["MinValue"] = 0, ["Step"] = 5 },
            ["ScriptFunction"] = function(self, Value)
                LocalPlayer.CameraMaxZoomDistance = game:GetService("StarterPlayer").CameraMaxZoomDistance + (Value * 0.25)
            end
        },
        ["ShowChat"] = {
            ["DisplayDescription"] = "Shows the Full Chat while in the Round",
            ["DisplayTitle"] = "Show Chat",
            ["LayoutOrder"] = 3,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["ScriptFunction"] = function(self, Value)
                if not SideBar:GetAttribute("WasVisible") and TextChatService:FindFirstChildOfClass("ChatWindowConfiguration") then
                    TextChatService:FindFirstChildOfClass("ChatWindowConfiguration").Enabled = Value
                end
            end,
            ["CustomSetup"] = function(self)
                if TextChatService:FindFirstChildOfClass("ChatWindowConfiguration") then
                    TextChatService:FindFirstChildOfClass("ChatWindowConfiguration"):GetPropertyChangedSignal("Enabled"):Connect(function()
                        if GetValue("ShowChat") then
                            TextChatService:FindFirstChildOfClass("ChatWindowConfiguration").Enabled = true
                        end
                    end)
                end
            end
        },
        ["SpoofDevice"] = {
            ["DisplayDescription"] = "Spoofs the device in profiles",
            ["DisplayTitle"] = "Spoof Device",
            ["LayoutOrder"] = 4,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["ExtraData"] = { ["Options"] = "Original|PC|Mobile|Console|Nothing" },
            ["DefaultInstanceValue"] = "Original",
            ["ScriptFunction"] = function(self,Value,Starting)
                local InputDevices = {Keyboard = "PC", MouseButton1 = "PC", MouseButton2 = "PC", MouseMovement = "PC", Touch = "Mobile", Gamepad1 = "Console"}
                if Value == "Original" then
                    Value = InputDevices[UserInputService:GetLastInputType().Name] or "PC"
                elseif Value == "Nothing" and Starting then
                    return
                elseif Value == "Nothing" then
                    Value = nil
                end
                if GetValue("OfficialGame") then
                    Network:FindFirstChildOfClass("RemoteEvent"):FireServer("SetDevice",{Value})
                else
                    Network:FindFirstChildOfClass("RemoteEvent"):FireServer("SetDevice",{Value})
                    Network:FindFirstChildOfClass("RemoteEvent"):FireServer("SetDevice",Value)
                end
            end,
            ["CustomSetup"] = function(self)
                LocalPlayer:GetAttributeChangedSignal("Device"):Connect(function()
                    if GetValue("SpoofDevice") ~= "Original" and GetValue("SpoofDevice") ~= "Nothing" and LocalPlayer:GetAttribute("Device") ~= GetValue("SpoofDevice") then
                        self:ScriptFunction(GetValue("SpoofDevice"))
                    end
                end)
            end
        },
        ["ShowPrivacy"] = {
            ["DisplayDescription"] = "Shows everyones privacy info",
            ["DisplayTitle"] = "Shows Privacy Info",
            ["LayoutOrder"] = 5,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["HandlePrivacySettings"] = function(self,Player)
                if Player then
                    local Data = Player:FindFirstChild("PlayerData")
                    if Data then
                        local PrivacySettings = Data:FindFirstChild("Privacy",true)
                        if PrivacySettings then
                            for i,v in PrivacySettings:GetChildren() do
                                if not v:GetAttribute("OriginalValue") and v:IsA("BoolValue") then
                                    v:SetAttribute("OriginalValue", v.Value)
                                    v:GetPropertyChangedSignal("Value"):Connect(function()
                                        local ShowPrivacy = FeatureLoadout["Miscellaneous"]["ShowPrivacy"]["Instance"]
                                        if ShowPrivacy and ShowPrivacy.Value then v.Value = false
                                        else v.Value = v:GetAttribute("OriginalValue") end
                                    end)
                                    local ShowPrivacy = FeatureLoadout["Miscellaneous"]["ShowPrivacy"]["Instance"]
                                    if ShowPrivacy and ShowPrivacy.Value then v.Value = false
                                    else v.Value = v:GetAttribute("OriginalValue") end
                                elseif v:IsA("BoolValue") then
                                    local ShowPrivacy = FeatureLoadout["Miscellaneous"]["ShowPrivacy"]["Instance"]
                                    if ShowPrivacy and ShowPrivacy.Value then v.Value = false
                                    else v.Value = v:GetAttribute("OriginalValue") end
                                end
                            end
                        end
                    end
                end
            end,
            ["HandleCheckForMod"] = function(self,Player)
                if not Player then return end
                if game.CreatorType ~= Enum.CreatorType.Group then return end
                local Rank = Player:GetRoleInGroupAsync(game.CreatorId)
                if Rank and (Rank:lower():find("mod") or Rank:lower():find("admin")) and not workspace:GetAttribute("ModFound") then
                    workspace:SetAttribute("ModFound",true)
                    StarterGui:SetCore("SendNotification",{
                        Title = "WARNING", Text = "A Moderator is in your server all features are now disabled",
                        Icon = "rbxasset://textures/DevConsole/Warning.png", Duration = 10
                    })
                    FeatureLoadout["EnviromentFunctions"]["files"]["DefaultInstanceValue"] = true
                    for i,v in FeatureLoadout do
                        if i ~= "EnviromentFunctions" then
                            if i ~= "TabAttributes" then
                                for i2,v2 in v do
                                    if v2["Instance"] and i2 ~= "DisableAllFeatures" then
                                        v2["Instance"].Value = v2["DefaultInstanceValue"]
                                    end
                                end
                            end
                        end
                    end
                end
            end,
            ["ScriptFunction"] = function(self, Value)
                for i,v in Players:GetPlayers() do
                    if v ~= LocalPlayer then self:HandlePrivacySettings(v) end
                end
            end,
            ["CustomSetup"] = function(self)
                task.spawn(function()
                    for i,v in Players:GetPlayers() do
                        if v ~= LocalPlayer then
                            self:HandlePrivacySettings(v)
                            self:HandleCheckForMod(v)
                        end
                    end
                end)
                Players.PlayerAdded:Connect(function(Player)
                    self:HandleCheckForMod(Player)
                    task.delay(2,self.HandlePrivacySettings,self,Player)
                end)
            end
        },
        ["HideInjury"] = {
            ["DisplayDescription"] = "Hides the injured screen and effects used when you are low health",
            ["DisplayTitle"] = "Hide Injured UI/Effects",
            ["LayoutOrder"] = 6,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["ScriptFunction"] = function(self, Value)
                for i,v in TempUI and TempUI:QueryDescendants("#redFlash,#injuredVignette") or {} do
                    v.Visible = not Value
                end
                if Lighting:FindFirstChild("HealthDesaturation") then
                    Lighting:FindFirstChild("HealthDesaturation").Enabled = not Value
                end
            end,
            ["CustomSetup"] = function(self)
                Lighting.ChildAdded:Connect(function(Child)
                    if Child.Name == "HealthDesaturation" then Child.Enabled = not GetValue("HideInjury") end
                end)
                if Lighting:FindFirstChild("HealthDesaturation") then
                    Lighting.HealthDesaturation.Enabled = not GetValue("HideInjury")
                end
            end
        },
        ["DisableBlindness"] = {
            ["DisplayDescription"] = "Disables the blindness effect",
            ["DisplayTitle"] = "Disable Blindness",
            ["LayoutOrder"] = 7,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["ScriptFunction"] = function(self, Value)
                for i,v in Lighting:QueryDescendants("#BlindnessBlur BlurEffect") do v.Enabled = not Value end
            end,
            ["CustomSetup"] = function(self)
                Lighting.ChildAdded:Connect(function(Child)
                    if Child.Name == "BlindnessBlur" and Child:IsA("BlurEffect") then
                        Child.Enabled = not GetValue("DisableBlindness")
                    end
                end)
                if Lighting:FindFirstChild("BlindnessBlur") then
                    Lighting:FindFirstChild("BlindnessBlur").Enabled = not GetValue("DisableBlindness")
                end
            end
        },
        ["DeleteRagdolls"] = {
            ["DisplayDescription"] = "Deletes ALL Ragdolls regardless the type of ragdoll for performance",
            ["DisplayTitle"] = "Delete All Ragdolls",
            ["LayoutOrder"] = 8,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "PrivateServer",
            ["ScriptFunction"] = function(self, Value)
                if Value and RagdollsFolder then
                    RagdollsFolder:ClearAllChildren()
                elseif not RagdollsFolder then
                    self.Value = false
                    self.Instance:SetAttribute("Requirement",true)
                end
            end,
            ["CustomSetup"] = function(self)
                if RagdollsFolder then
                    RagdollsFolder.ChildAdded:Connect(function(Ragdoll)
                        if GetValue("DeleteRagdolls") and GetValue("PrivateServer") then
                            RagdollsFolder:ClearAllChildren()
                        else
                            for i,v in Ragdoll:QueryDescendants("Highlight[$Dynamic],BillboardGui[$Dynamic]") do v:Destroy() end
                        end
                    end)
                end
            end
        },
        ["PlayerSelectCrash"] = {
            ["DisplayDescription"] = "Select a player to crash",
            ["DisplayTitle"] = "Player to crash",
            ["LayoutOrder"] = 9,
            ["Savable"] = false,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "None",
            ["Requirement"] = "Effect:Nausea|PrivateServerOwner",
            ["UpdatePlayerCrashDrop"] = function(self)
                local OriginString = self.DefaultInstanceValue
                local CurrentPlayers = Players:GetPlayers()
                for i,v in CurrentPlayers do
                    if v ~= LocalPlayer then OriginString ..= "|" .. v.Name end
                end
                local PlayerCount = #CurrentPlayers
                if PlayerCount == 3 then OriginString ..= "|Both"
                elseif PlayerCount > 3 then OriginString ..= "|Everyone" end
                if GetValue("PlayerSelectCrash",true) then
                    GetValue("PlayerSelectCrash",true):SetAttribute("Options", OriginString)
                end
                if GetValue("PlayerSelectCrash") ~= self.DefaultInstanceValue and not Players:FindFirstChild(GetValue("PlayerSelectCrash")) then
                    self.Instance.Value = self.DefaultInstanceValue
                end
            end,
            ["ExtraData"] = { ["Options"] = "None" },
            ["CustomSetup"] = function(self)
                local function Upd() self:UpdatePlayerCrashDrop() end
                Players.PlayerAdded:Connect(Upd)
                Players.PlayerRemoving:Connect(Upd)
                task.delay(0.5,Upd)
            end
        },
        ["CrashTheTarget"] = {
            ["DisplayDescription"] = "Crashes the selected target (Host Exclusive)",
            ["DisplayTitle"] = "Crash Target",
            ["LayoutOrder"] = 9,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Effect:Nausea|PlayerSelectCrash~None|PrivateServerOwner",
            ["ScriptFunction"] = function(self, Value)
                if Value then
                    self.Instance.Value = false
                    local PlayerName = GetValue("PlayerSelectCrash")
                    if PlayerName == "Everyone" or PlayerName == "Both" then
                        for i,Player in Players:GetPlayers() do
                            if Player ~= LocalPlayer then
                                local Name = Player.Name
                                task.spawn(function()
                                    repeat
                                        if GetValue("OfficialGame") then
                                            Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus", Name, "Nausea", math.huge, 1})
                                        else
                                            Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus", Name, "Nausea", math.huge, 1})
                                            Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus", Name, "Nausea", math.huge, 1)
                                        end
                                        task.wait(1.5)
                                    until not Players:FindFirstChild(Name)
                                end)
                            end
                        end
                    else
                        task.spawn(function()
                            repeat
                                if GetValue("OfficialGame") then
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus", PlayerName, "Nausea", math.huge, 1})
                                else
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus", PlayerName, "Nausea", math.huge, 1})
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus", PlayerName, "Nausea", math.huge, 1)
                                end
                                task.wait(1.5)
                            until not Players:FindFirstChild(PlayerName)
                        end)
                    end
                end
            end
        },
        ["SkyGlitch"] = {
            ["DisplayDescription"] = "Gives sky glitching effect to everyone (Host Exclusive)",
            ["DisplayTitle"] = "Sky Glitch",
            ["LayoutOrder"] = 11,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Effect:Nausea|PrivateServerOwner",
            ["ScriptFunction"] = function(self, Value)
                if Value and not workspace:GetAttribute("EffectActive") then
                    workspace:SetAttribute("EffectActive",true)
                    self.Instance.Value = false
                    if PlayerData:FindFirstChild("EpilepsyMode",true) and PlayerData:FindFirstChild("EpilepsyMode",true).Value then
                        StarterGui:SetCore("SendNotification",{Title = "Warning",Text = "Disabled your Epilepsy Mode Temporarily for the effect to work",Duration = 5})
                        PlayerData:FindFirstChild("EpilepsyMode",true).Value = false
                        task.delay(10, function() PlayerData:FindFirstChild("EpilepsyMode",true).Value = true end)
                    end
                    if GetValue("OfficialGame") then
                        Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus","All","Nausea",-1e11,10})
                    else
                        Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus","All","Nausea",-1e11,10})
                        Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus","All","Nausea",-1e11,10)
                    end
                    task.delay(10, function()
                        workspace:SetAttribute("EffectActive",nil)
                        self.Instance.Value = false
                    end)
                elseif workspace:GetAttribute("EffectActive") then
                    self.Instance.Value = true
                end
            end
        },
        ["InstaKill"] = {
            ["DisplayDescription"] = "Allows you to instantly kill anyone (Host Exclusive)",
            ["DisplayTitle"] = "Instant Kill",
            ["LayoutOrder"] = 12,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = ReplicatedStorage:FindFirstChild("Weakness",true) and "PrivateServerOwner",
            ["ScriptFunction"] = function(self, Value)
                if workspace:GetAttribute("InstaKill") == nil then
                    workspace:SetAttribute("InstaKill", Value)
                    self.Instance.Value = Value
                    task.delay(1.5, function() workspace:SetAttribute("InstaKill",nil) end)
                    if Value then
                        repeat
                            if GetValue("OfficialGame") then
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",LocalPlayer.Name,"Weakness",-1e11,2})
                            else
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",LocalPlayer.Name,"Weakness",-1e11,2})
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus",LocalPlayer.Name,"Weakness",-1e11,2)
                            end
                            task.wait(1.25)
                        until not self.Instance.Value
                    end
                else
                    self.Instance.Value = workspace:GetAttribute("InstaKill")
                end
            end
        },
        ["DisableDamage"] = {
            ["DisplayDescription"] = "Disables dealing damage for everyone (Host Exclusive)",
            ["DisplayTitle"] = "Disable Damage",
            ["LayoutOrder"] = 13,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Effect:Strength|PrivateServerOwner",
            ["ScriptFunction"] = function(self, Value)
                if workspace:GetAttribute("DisableDamage") == nil then
                    workspace:SetAttribute("DisableDamage", Value)
                    self.Instance.Value = Value
                    task.delay(2.25, function() workspace:SetAttribute("DisableDamage",nil) end)
                    if Value then
                        repeat
                            for i,v in Players:GetPlayers() do
                                if v.UserId == LocalPlayer.UserId and GetValue("InstaKill") then continue end
                                if GetValue("OfficialGame") then
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",v.Name,"Strength",-1e11,2})
                                else
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",v.Name,"Strength",-1e11,2})
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus",v.Name,"Strength",-1e11,2)
                                end
                            end
                            task.wait(1.25)
                        until not self.Instance.Value
                    end
                else
                    self.Instance.Value = workspace:GetAttribute("DisableDamage")
                end
            end
        },
        ["DisableAbilityCooldown"] = {
            ["DisplayDescription"] = "Disables the ability cooldown only for you (Host Exclusive)",
            ["DisplayTitle"] = "Disable Ability Cooldown",
            ["LayoutOrder"] = 14,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Effect:Fatigue|PrivateServerOwner",
            ["ScriptFunction"] = function(self, Value)
                if workspace:GetAttribute("DisableAbilityCooldownSelf") == nil then
                    workspace:SetAttribute("DisableAbilityCooldownSelf", Value)
                    self.Instance.Value = Value
                    task.delay(1.5, function() workspace:SetAttribute("DisableAbilityCooldownSelf",nil) end)
                    if Value then
                        repeat
                            if GetValue("OfficialGame") then
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",LocalPlayer.Name,"Fatigue",-1e8,2})
                            else
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",LocalPlayer.Name,"Fatigue",-1e8,2})
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus",LocalPlayer.Name,"Fatigue",-1e8,2)
                            end
                            task.wait(1.25)
                        until not self.Instance.Value
                    end
                else
                    self.Instance.Value = workspace:GetAttribute("DisableAbilityCooldownSelf")
                end
            end
        },
        ["DisableAllFeatures"] = {
            ["DisplayDescription"] = "Disables all features when the script is outdated/not tested",
            ["DisplayTitle"] = "Disable Features When Outdated",
            ["LayoutOrder"] = 18,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "OfficialGame",
        },
        ["OfficialJoin"] = {
            ["DisplayDescription"] = "Makes you join the official forsaken game",
            ["DisplayTitle"] = "Join the official version",
            ["LayoutOrder"] = 19,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "OfficialGame~true",
            ["ScriptFunction"] = function(self, Value)
                if Value and not workspace:GetAttribute("LoadingTeleport") then
                    workspace:SetAttribute("LoadingTeleport",true)
                    if workspace:FindFirstChild("Sounds") then workspace.Sounds:ClearAllChildren() end
                    if workspace:FindFirstChild("Themes") then workspace.Themes:ClearAllChildren() end
                    TeleportSound.TimePosition = 0.4
                    TeleportSound.Volume = 4
                    TeleportSound.Playing = true
                    GetValue("Rejoin",true):SetAttribute("Requirement",true)
                    task.wait(0.5)
                    local FrequencyData = HttpService:JSONDecode(ReturnData("AccountType.txt", true))
                    local PlaceId = 83645629621104
                    if FrequencyData["New"] and FrequencyData["New"] < FrequencyData["Normal"] then
                        PlaceId = 18687417158
                    end
                    game:GetService("ExperienceService"):LaunchExperience({placeId = PlaceId})
                elseif workspace:GetAttribute("LoadingTeleport") then
                    self.Instance.Value = true
                end
            end
        },
        ["Rejoin"] = {
            ["DisplayDescription"] = "Makes you rejoin the exact same server",
            ["DisplayTitle"] = "Rejoin",
            ["LayoutOrder"] = 20,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["ScriptFunction"] = function(self, Value)
                if Value and not workspace:GetAttribute("LoadingTeleport") then
                    workspace:SetAttribute("LoadingTeleport",true)
                    if workspace:FindFirstChild("Sounds") then workspace.Sounds:ClearAllChildren() end
                    if workspace:FindFirstChild("Themes") then workspace.Themes:ClearAllChildren() end
                    TeleportSound.TimePosition = 0.4
                    TeleportSound.Volume = 4
                    TeleportSound.Playing = true
                    GetValue("OfficialJoin",true):SetAttribute("Requirement",true)
                    task.wait(0.25)
                    game:GetService("TeleportService").TeleportInitFailed:Once(function()
                        workspace:SetAttribute("LoadingTeleport",nil)
                        TeleportSound.Playing = false
                        warn("Failed to teleport, please try again. (Rejoin manually if it repeats)")
                        self.Instance.Value = false
                    end)
                    if workspace:GetAttribute("ServerType") == "VIP" then
                        game:GetService("TeleportService"):Teleport(game.PlaceId)
                    else
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId)
                    end
                elseif workspace:GetAttribute("LoadingTeleport") then
                    self.Instance.Value = true
                end
            end
        },
    }
}

-- UI Creation --
MainUI.DisplayOrder = 5
PlusFolderSettings.Name = "Plus"
PlusFolderSettings.Parent = PlayerData
SidePlusButton.Name = "Plus"
SidePlusButton.Parent = Buttons
SidePlusButton.LayoutOrder = MainButton.Name == "Settings" and MainButton.LayoutOrder - 1 or MainButton.LayoutOrder + 1
if NewUIVersion then
    PlusButton:FindFirstChild("Icon").ImageColor3 = Color3.fromRGB(0, 170, 127)
    PlusButton:FindFirstChild("Icon").Image = "rbxassetid://118860705115878"
    PlusButton:FindFirstChild("Text"):FindFirstChild("Name").Text = "Plus"
    PlusButton:FindFirstChild("Line").ImageColor3 = Color3.fromRGB(0, 170, 127)
    PlusButton:FindFirstChild("Highlight").ImageColor3 = Color3.fromRGB(0, 170, 127)
    PlusButton:FindFirstChild("Text"):FindFirstChild("Name").TextColor3 = Color3.fromRGB(0, 170, 127)
    PlusButton:FindFirstChild("Texture").ImageColor3 = Color3.fromRGB(0, 170, 127)
    for i,v in PlusButton:FindFirstChild("Text"):GetChildren() do if v:IsA("ImageLabel") then v.ImageColor3 = Color3.fromRGB(0, 17, 13) end end
    PlusButton:FindFirstChild("BG").ImageColor3 = Color3.fromRGB(0, 17, 13)
    PlusButton:FindFirstChild("Grunge").ImageColor3 = Color3.fromRGB(0, 37, 24)
    PlusButton:FindFirstChild("Grunge").ImageTransparency = 0.2
    PlusButton:FindFirstChild("GrungeMain").ImageTransparency = 1
    UIScale.Parent = PlusButton
else
    SidePlusButton.Button.ImageColor3 = Color3.fromRGB(0, 170, 127)
    SidePlusButton.Icon.ImageColor3 = Color3.fromRGB(0, 170, 127)
    SidePlusButton.Icon.Image = "rbxassetid://118860705115878"
    PulloutFramePlus.Title.TextColor3 = Color3.fromRGB(0, 170, 127)
    PulloutFramePlus.Position = UDim2.fromScale(0,0.5)
    PulloutFramePlus.ArtAsset.ImageColor3 = Color3.fromRGB(0, 170, 127)
    PulloutFramePlus.ArtAsset.ImageTransparency = 0
end
local Arrow = ReplicatedStorage:FindFirstChild("DropdownArrow",true):Clone()
Arrow.ImageColor3 = Color3.fromRGB(0, 170, 127)
Arrow.Parent = SidePlusButton
Arrow.Position = UDim2.fromScale(1.6,0.5)
Arrow.AnchorPoint = Vector2.new(0.5,0.5)
Arrow.Rotation = 90
Arrow.Size = UDim2.fromScale(0.67,0.67)
Arrow.Visible = false
Arrow.Active = false
PlusMenu.Name = "PlusScreen"
PlusMenu.Parent = MainUI
PlusMenu.Visible = false
PlusMenu.Size = UDim2.new(1,-20,0,0)
PlusMenu.SettingsContainer.ImageColor3 = Color3.fromRGB(0, 170, 127)
PlusMenu.SettingsContainer.BackgroundTransparency = 1
PlusMenu.SettingsContainer.Contents.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 127)
PlusMenu.SettingsContainer.Contents.Size = UDim2.fromScale(0.95,0.935)
PlusMenu.SettingsContainer.Contents.Position = UDim2.fromScale(0.5,0.035)
PlusMenu.ZIndex += 25
PlusMenu:GetPropertyChangedSignal("Visible"):Connect(function()
    PlusMenu.Visible = PlusMenu:GetAttribute("Visible") and true or false
end)
for i,v in PlusMenu.SettingsContainer:GetChildren() do if not (v:IsA("UIAspectRatioConstraint") or v.Name == "Contents") then v:Destroy() end end
for i,v in PlusMenu.SettingsContainer.Contents:QueryDescendants("Frame,ImageLabel") do v:Destroy() end

-- Functions --
function ColoredPrint(Text, Icon, Color)
    task.spawn(function()
        task.spawn(function()
            if not _G.Initialized and not _G.Initizalling then
                _G.Initizalling = true
                _G.PrintedData = {}
                local CoreGuiConnection
                local function Handle(child)
                    if child.Name == "DevConsoleMaster" then
                        CoreGuiConnection:Disconnect()
                        local DevConsoleMaster = child
                        local DevConsoleUI = DevConsoleMaster:FindFirstChild("DevConsoleUI",true) or DevConsoleMaster:WaitForChild("DevConsoleWindow",999999):WaitForChild("DevConsoleUI",999999)
                        local IconData = {
                            ["error"] = {"rbxasset://textures/DevConsole/Error.png","rbxassetid://97467062933153",Color3.fromRGB(215,90,74)},
                            ["information"] = {"rbxasset://textures/DevConsole/Info.png","rbxassetid://98895588220731",Color3.fromRGB(0,162,255)},
                            ["warning"] = {"rbxasset://textures/DevConsole/Warning.png","rbxassetid://129253285072281",Color3.fromRGB(255,218,68)},
                            ["plus"] = {"rbxassetid://127360009371476","rbxassetid://127360009371476",Color3.fromRGB(255,255,255)},
                            ["success"] = {"rbxassetid://75097763556603","rbxassetid://87889653826033",Color3.fromRGB(105,215,74)},
                        }
                        local function GetIcon(Icon)
                            if type(Icon) == "string" then
                                local iconLower = Icon:lower()
                                for i,v in pairs(IconData) do
                                    if string.lower(string.sub(i, 1, #iconLower)) == iconLower then return v end
                                end
                            end
                            return IconData["information"]
                        end
                        local function RunChecks(ins)
                            local Log = ins:FindFirstChild("ClientLog")
                            local function RunChecks2(ins2,Log)
                                local TextLabel = ins2:FindFirstChildWhichIsA("TextLabel")
                                local Image = ins2:FindFirstChildWhichIsA("ImageLabel")
                                if TextLabel then
                                    local function Update()
                                        local ID = string.sub(TextLabel.Text, -7, -1)
                                        if _G.PrintedData[ID] then
                                            local Data = _G.PrintedData[ID]
                                            local Icon = Data[1] or nil
                                            local Color = Data[2] or nil
                                            local ImageColored = false
                                            TextLabel.RichText = true
                                            if type(Icon) ~= type("") and typeof(Color) ~= typeof(Color3.new()) then
                                                Icon = GetIcon("info")[1] Color = Color3.new(1,1,1)
                                            elseif type(Icon) == type("") and typeof(Color) ~= typeof(Color3.new()) then
                                                Color = GetIcon(Icon)[3] Icon = GetIcon(Icon)[1]
                                            elseif type(Icon) ~= type("") and typeof(Color) == typeof(Color3.new()) then
                                                Icon = ""
                                            elseif type(Icon) == type("") and typeof(Color) == typeof(Color3.new()) then
                                                ImageColored = true Icon = GetIcon(Icon)[2]
                                            end
                                            local OriginalText = TextLabel.Text
                                            TextLabel.Text = string.format("<font color='#%s' size='15'>%s</font>",Color:ToHex(),string.gsub(OriginalText,ID,""))
                                            if Image then
                                                Image.Image = Icon
                                                if ImageColored then Image.ImageColor3 = Color end
                                            end
                                        else
                                            Image.ImageColor3 = Color3.new(1,1,1)
                                            Image.Image = TextLabel.TextColor3 == Color3.fromRGB(255,218,68) and GetIcon("warning")[1] or TextLabel.TextColor3 == Color3.fromRGB(215,90,74) and GetIcon("error")[1] or TextLabel.TextColor3 == Color3.fromRGB(0,162,255) and GetIcon("info")[1] or ""
                                        end
                                        TextLabel:GetPropertyChangedSignal("Text"):Once(Update)
                                    end
                                    Update()
                                end
                            end
                            if Log then
                                for i,ins2 in pairs(Log:GetChildren()) do RunChecks2(ins2, Log) end
                                Log.ChildAdded:Connect(function(ins2) RunChecks2(ins2, Log) end)
                            end
                            ins.ChildAdded:Connect(function(Log)
                                if Log.Name == "ClientLog" then
                                    for i,ins2 in pairs(Log:GetChildren()) do RunChecks2(ins2, Log) end
                                    Log.ChildAdded:Connect(function(ins2) RunChecks2(ins2, Log) end)
                                end
                            end)
                        end
                        if DevConsoleUI:FindFirstChild("MainView") then RunChecks(DevConsoleUI:FindFirstChild("MainView")) end
                        DevConsoleUI.ChildAdded:Connect(function(ins)
                            if ins.Name == "MainView" then RunChecks(ins) end
                        end)
                        _G.Initialized = true
                        _G.Initizalling = nil
                    end
                end
                CoreGuiConnection = game:GetService("CoreGui").ChildAdded:Connect(Handle)
                if game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster") then Handle(game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster")) end
            end
        end)
        local UniqueID = string.sub(game:GetService("HttpService"):GenerateGUID(false), 1, 7)
        game:GetService("LogService"):Output((type(Text) == "string" and Text or "") .. UniqueID)
        _G.PrintedData[UniqueID] = {Icon,Color}
    end)
end

function PlaySound(SoundName,Settings,KeepPlaying)
    local Sound = typeof(SoundName) == "string" and AssetsFolder.Sounds:FindFirstChild(SoundName,true) or (typeof(SoundName) == "Instance" and SoundName) or nil
    if Sound then
        task.spawn(function()
            Sound = Sound:Clone()
            Sound.Parent = workspace:FindFirstChild("Sounds") or workspace
            if type(Settings) == "table" then
                for i,v in Settings do Sound[i] = v end
            end
            if KeepPlaying then Sound.Playing = true else Sound:Play() end
            Debris:AddItem(Sound, Sound.TimeLength + 1)
            return Sound
        end)
    else
        warn("Failed to play sound: ".. tostring(SoundName))
    end
end

local function SetButtonState(Active)
    task.spawn(function()
        local u4 = {}
        u4.BG = {Active = {ImageColor3 = Color3.fromRGB(0, 170, 127)},Inactive = {ImageColor3 = Color3.fromRGB(0, 17, 13)}}
        u4.GrungeMain = {Active = {ImageColor3 = Color3.fromRGB(0, 37, 24)},Inactive = {ImageColor3 = Color3.fromRGB(80, 80, 80)}}
        u4.Grunge = {Active = {ImageTransparency = 0,ImageColor3 = Color3.fromRGB(0, 229, 171)},Inactive = {ImageTransparency = 0.2,ImageColor3 = Color3.fromRGB(0, 37, 24)}}
        u4.Highlight = {Active = {ImageColor3 = Color3.fromRGB(0, 37, 24)},Inactive = {ImageColor3 = Color3.fromRGB(0, 170, 127)}}
        u4.Icon = {Active = {ImageColor3 = Color3.fromRGB(0, 37, 24)},Inactive = {ImageColor3 = Color3.fromRGB(0, 170, 127)}}
        u4.Line = {Active = {ImageColor3 = Color3.fromRGB(0, 37, 24)},Inactive = {ImageColor3 = Color3.fromRGB(0, 170, 127)}}
        local TextLabelUI = PlusButton:FindFirstChild("Text")
        for i, Child in TextLabelUI and TextLabelUI:GetChildren() or {} do
            if Child:IsA("TextLabel") then
                TweenService:Create(Child, TweenInfo.new(0.25), {TextColor3 = Active and Color3.fromRGB(0, 37, 24) or Color3.fromRGB(0, 170, 127)}):Play()
            elseif Child:IsA("ImageLabel") then
                TweenService:Create(Child, TweenInfo.new(0.25), {ImageColor3 = Active and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(0, 17, 13)}):Play()
            end
        end
        local v28 = Active and "Active" or "Inactive"
        for v29, v30 in u4 do
            local v31 = PlusButton:FindFirstChild(v29)
            if v31 then TweenService:Create(v31, TweenInfo.new(0.25), v30[v28]):Play() end
        end
    end)
end

function GetValue(FeatureName,InstanceOnly)
    local FeatureInstance = Values[FeatureName]
    if not FeatureInstance then
        FeatureInstance = PlusFolderSettings:FindFirstChild(FeatureName,true)
        Values[FeatureName] = FeatureInstance
    end
    if InstanceOnly then return FeatureInstance end
    return FeatureInstance and FeatureInstance.Value
end

function GetFunction(Function1, Function2)
    return typeof(Function1) == "function" and Function1 or (typeof(Function2) == "function" and Function2) or nil
end

function RichTextGradientColor(Text:string,Colors)
    local Count = 0
    for Char in Text:gmatch(utf8.charpattern) do if Char ~= " " then Count += 1 end end
    if Count == 0 then return Text end
    local MaxIndex = math.max(1,Count-1)
    local Segments = #Colors-1
    local Result,Used = "",0
    for Char in Text:gmatch(utf8.charpattern) do
        if Char == " " then Result..=Char
        elseif Char:byte() >= 128 then
        else
            local T = Used/MaxIndex
            Used += 1
            local Segment = math.min(math.floor(T*Segments),Segments-1)
            Result..=('<font color="#%s">%s</font>'):format(Colors[Segment+1]:Lerp(Colors[Segment+2],T*Segments-Segment):ToHex(),Char)
        end
    end
    return Result
end

local function collidewith(gui1,gui2)
    local gui1_topLeft,gui1_bottomRight = gui1.AbsolutePosition, gui1.AbsolutePosition + gui1.AbsoluteSize
    local gui2_topLeft,gui2_bottomRight = gui2.AbsolutePosition, gui2.AbsolutePosition + gui2.AbsoluteSize
    return ((gui1_topLeft.x < gui2_bottomRight.x and gui1_bottomRight.x > gui2_topLeft.x) and (gui1_topLeft.y < gui2_bottomRight.y and gui1_bottomRight.y > gui2_topLeft.y))
end

function TableValueFind(Table, MatchFn, Seen)
    if type(Table) ~= "table" or type(MatchFn) ~= "function" then return nil end
    Seen = Seen or {}
    if Seen[Table] then return nil end
    Seen[Table] = true
    for Key, Value in Table do
        if MatchFn(Key, Value) then return Value, Key, Table
        elseif type(Value) == "table" then
            local FoundValue, FoundKey, FoundParent = TableValueFind(Value, MatchFn, Seen)
            if FoundKey ~= nil then return FoundValue, FoundKey, FoundParent end
        end
    end
    return nil
end

function CanPlayOverrideAnim(Character)
    return Character and Character.Parent and GetValue("AnimationChanger") ~= "Original" and not GetValue("AnimationChanger",true):GetAttribute("StopOverride") and ((GetValue("ChangeInLobby") and Character.Parent.Name == "Spectating") or Character.Parent.Name ~= "Spectating")
end

function GetAnimationType(ID)
    for i,v in AllAnimations do
        for animtype,animId in v do
            if type(animId) == "table" then
                for i2,v2 in animId do
                    if type(v2) == "string" and v2:find(tostring(ID)) then return animtype,i,i2 end
                end
            else
                if type(animId) == "string" and animId:find(tostring(ID)) then return animtype,i end
            end
        end
    end
end

local function AddOverridenAnimation(ID)
    if LocalCharacter and ID then
        if OverriddenAnimations[ID] then return table.unpack(OverriddenAnimations[ID]) end
        local OverrideFolder = LocalCharacter:FindFirstChild("OverrideAnimation") or Instance.new("Folder", LocalCharacter)
        OverrideFolder.Name = "OverrideAnimation"
        local AnimType,CharName = GetAnimationType(ID) or "Unknown"
        local Animation = Instance.new("Animation")
        Animation.Name = AnimType .. tostring(ID)
        Animation.AnimationId = tostring(ID):find("id") and tostring(ID) or "http://www.roblox.com/asset/?id=" .. tostring(ID)
        Animation.Parent = OverrideFolder
        Animation:SetAttribute("Overriden",true)
        if LocalAnimator then
            local Track = LocalAnimator:LoadAnimation(Animation)
            OverriddenAnimations[ID] = {Track,Animation}
            return Track,Animation
        end
    end
end

local SupportedOverrides = {"idle","walk","run"}
function UpdateAnim(Humanoid)
    local AnimSelected = GetValue("AnimationChanger")
    if not CanPlayOverrideAnim(LocalCharacter) then return end
    local AnimString
    local Type
    if MainModule["IsSprinting"] and Humanoid.MoveDirection ~= Vector3.zero then
        AnimString = AllAnimations[AnimSelected] and AllAnimations[AnimSelected]["Run"]
        Type = "Run"
    elseif Humanoid.MoveDirection ~= Vector3.zero then
        AnimString = AllAnimations[AnimSelected] and AllAnimations[AnimSelected]["Walk"]
        Type = "Walk"
    else
        AnimString = AllAnimations[AnimSelected] and AllAnimations[AnimSelected]["Idle"]
        Type = "Idle"
    end
    if AnimString then
        local FoundAction = false
        for i,v in Humanoid:GetPlayingAnimationTracks() do
            if v.Animation and v.Animation:GetAttribute("Overriden") then
                v:Stop(0.2) continue
            end
            if not v.IsPlaying then continue end
            local AnimType,Char,Name = GetAnimationType(v.Animation.AnimationId)
            local IsSupported = false
            for i,v in SupportedOverrides do
                if AnimType and AnimType:lower():find(v:lower()) then IsSupported = true end
            end
            if not IsSupported then FoundAction = v end
        end
        local OverrideTrack,Animation = AddOverridenAnimation(AnimString)
        if OverrideTrack and CanPlayOverrideAnim(LocalCharacter) then
            OverrideTrack:Play(not FoundAction and 0.1 or 0.3)
        end
    end
end

function DefaultData(Path, Option)
    if isfile("NaikoScript/ForsakenPlus/" .. Path) then
        ColoredPrint("Option already exists", "info", Color3.fromRGB(252, 210, 150))
    else
        writefile("NaikoScript/ForsakenPlus/" .. Path, Option)
        ColoredPrint("Set default data", "success", Color3.fromRGB(125, 230, 75))
    end
end

function ChangeData(Path, Option, WithFolder)
    if WithFolder == false then
        if isfile(Path) then writefile(Path,Option) end
    else
        if isfile("NaikoScript/ForsakenPlus/" .. Path) then writefile("NaikoScript/ForsakenPlus/" .. Path, Option) end
    end
end

function ReturnData(Path, WithFolder)
    if WithFolder == false then
        if isfile(Path) ~= false then return readfile(Path) end
    else
        if isfile("NaikoScript/ForsakenPlus/" .. Path) ~= false then return readfile("NaikoScript/ForsakenPlus/" .. Path) end
        return nil
    end
end

-- General Scripting --
if not (game.GameId == 6331902150 or game.GameId == 7464167604) then
    FeatureLoadout["Unofficial"] = {
        ["TabAttributes"] = {
            ["DisplayTitle"] = '<font color="rgb(255,166,0)">⚠ </font>' .. RichTextGradientColor(" SOME FEATURES MAY NOT WORK HERE ",{Color3.fromRGB(255, 166, 0), Color3.fromRGB(243, 227, 0)}) .. '<font color="rgb(243, 227, 0)">⚠ </font>',
            ["LayoutOrder"] = -1
        }
    }
    ColoredPrint("This is not the official game which means some of the features may not work as expected.", "warning", Color3.fromRGB(255, 166, 0))
end

FeatureLoadout["EnviromentFunctions"]["TabAttributes"]["DisplayTitle"] = string.format(
    "Script Made by %s | %s    ",
    RichTextGradientColor("Naiko Scripts",{Color3.fromRGB(0, 255, 128),Color3.fromRGB(0, 102, 255)}),
    RichTextGradientColor("V"..Version,{Color3.fromRGB(87, 160, 255),Color3.fromRGB(0, 132, 255)})
)

FeatureLoadout["Visuals"]["DisableNoliNPC"]["DisplayTitle"] = string.format("Disable %s NPC", RichTextGradientColor("Noli's",{Color3.fromRGB(130, 72, 255), Color3.fromRGB(77, 0, 185)}))
FeatureLoadout["Visuals"]["Disable007n7NPC"]["DisplayTitle"] = string.format("Disable %s NPC", RichTextGradientColor("007n7's",{Color3.fromRGB(117, 161, 255), Color3.fromRGB(13, 70, 175)}))
FeatureLoadout["Features"]["NoliControl"]["DisplayTitle"] = string.format("Better %s", RichTextGradientColor("Void Rush",{Color3.fromRGB(240, 90, 253), Color3.fromRGB(141, 0, 197)}))
FeatureLoadout["Features"]["ControllableDash"]["DisplayTitle"] = string.format("Make %s Dash Controllable", RichTextGradientColor("Coolkidd's",{Color3.fromRGB(255, 22, 22), Color3.fromRGB(175, 13, 13)}))
FeatureLoadout["Automation"]["AutoEscape"]["DisplayDescription"] = string.format("Auto-Escapes <b>%s</b> Hook",RichTextGradientColor("Nosferatu's",{Color3.fromRGB(192, 15, 24), Color3.fromRGB(108, 20, 9)}))
FeatureLoadout["Automation"]["AutoDisarm"]["DisplayDescription"] = string.format("Auto-Disarms <b>%s</b> Traps",RichTextGradientColor("Azure's",{Color3.fromRGB(130, 72, 255), Color3.fromRGB(49, 0, 228)}))

local ThreadBindable = Instance.new("BindableEvent")
local CharacterAddedBindable = Instance.new("BindableEvent")
task.spawn(function()
    while task.wait(0.1) do ThreadBindable:Fire() end
end)

InGame.ChildAdded:Connect(function(Child)
    if Child.Name == "Map" then GameMap = Child end
end)

if MainUI:FindFirstChild("ClassicSidebar") then MainUI:FindFirstChild("ClassicSidebar"):Destroy() end

local InputDeviceType = {Keyboard = "PC", MouseButton1 = "PC", MouseButton2 = "PC", MouseMovement = "PC", Touch = "Mobile", Gamepad1 = "Console"}
local Device = InputDeviceType[UserInputService:GetLastInputType().Name]
local getgc = GetFunction(getgc, get_gc)
local IsRequireSupported = false

task.spawn(function()
    local generaltest,result = pcall(function()
        return require(LocalPlayer:FindFirstChildOfClass("PlayerScripts"):FindFirstChild("PlayerModule"))
    end)
    local s,Err = pcall(function() LogService:Info("",result) end)
    local Success,Result
    if tostring(Err):find("cyclic") or s then
        if Device == "PC" then
            Success, Result = pcall(function()
                local Module = require(ReplicatedStorage:WaitForChild("Systems",4):WaitForChild("Character",4):WaitForChild("Game",4):WaitForChild("Sprinting",4))
                if Module and type(Module) == "table" and Module["StaminaChanged"] then
                    IsRequireSupported = true
                    return Module
                end
            end)
        else
            Success, Result = pcall(function()
                for i,Object in getgc(true) do
                    if type(Object) == "table" then
                        if rawget(Object, "Stamina") and rawget(Object, "StaminaChanged") then return Object end
                    end
                end
            end)
        end
    end
    if not (Success and type(Result) == "table") then
        FeatureLoadout["EnviromentFunctions"]["require"]["DefaultInstanceValue"] = false
    else
        IsRequireSupported = true
        MainModule = Result
    end
    local AnimationPreset = FeatureLoadout["Features"]["AnimationChanger"]
    if IsRequireSupported and KillerAssets and SurvivorAssets and SkinsAssets then
        local AllAssets = {}
        for i,v in KillerAssets:QueryDescendants("ModuleScript#Config") do table.insert(AllAssets,v) end
        for i,v in SurvivorAssets:QueryDescendants("ModuleScript#Config") do table.insert(AllAssets,v) end
        for i,v in SkinsAssets:QueryDescendants("ModuleScript#Config") do table.insert(AllAssets,v) end
        for i,ConfigModule in AllAssets do
            if ConfigModule.Parent:IsA("Model") then continue end
            local ConfigData = require(ConfigModule)
            local AnimationData = ConfigData and ConfigData.Animations
            if ConfigModule.Parent.Name == "Noli" and ConfigData and TableValueFind(ConfigData, function(Key, Value) return type(Key) == "string" and Key:find("InitialTurnMult") end) then
                NoliConfig = ConfigData
            end
            if ConfigModule.Parent.Name == "TwoTime" and AnimationData and TableValueFind(AnimationData, function(Key, Value) return type(Key) == "string" and Key:find("CrouchIdle") end) then
                AllAnimations["Crouch"] = {["Idle"] = AnimationData["CrouchIdle"],["Walk"] = AnimationData["CrouchWalk"],["Run"] = AnimationData["CrouchRun"]}
            end
            if ConfigModule.Parent.Name == "1x1x1x1" and AnimationData and TableValueFind(ConfigData, function(Key, Value) return type(Key) == "string" and Key:find("ZombieAnimations") end) then
                AllAnimations["NPC Zombie"] = TableValueFind(ConfigData, function(Key, Value) return type(Key) == "string" and Key:find("ZombieAnimations") end)
            end
            if not AnimationData or not ConfigData.DisplayName then continue end
            local ChosenName = ConfigData.DisplayName:find("Milestone") and string.format("%s %s",ConfigModule.Parent.Parent.Name,ConfigData.DisplayName:gsub("Milestone ","")) or ConfigData.DisplayName
            AnimationData["OriginalCharacter"] = ConfigModule.Parent
            AllAnimations[ChosenName] = AnimationData
        end
        for i,v in string.split(AnimationPreset["ExtraData"]["Options"], "|") do
            if v ~= "Original" then
                if not AllAnimations[v] or not AllAnimations[v]["Idle"] then
                    AnimationPreset["ExtraData"]["Options"] = AnimationPreset["ExtraData"]["Options"]:gsub("|" .. v, "",1)
                end
            end
        end
        if AnimationPreset["ExtraData"]["Options"]:gsub("|Default Roblox","") == "Original" then
            AnimationPreset["Requirement"] = true
        end
    else
        AnimationPreset["Requirement"] = true
    end
    if not NoliConfig then
        FeatureLoadout["Features"]["NoliControl"]["Requirement"] = true
    end
end)

local function ActionOnCharacter(Character)
    task.spawn(SetButtonState,false)
    LocalCharacter = Character
    LocalHumanoid = LocalCharacter and (LocalCharacter:FindFirstChildOfClass("Humanoid") or LocalCharacter:WaitForChild("Humanoid",2)) or nil
    LocalHead = LocalCharacter and (LocalCharacter:FindFirstChild("Head") or LocalCharacter:WaitForChild("Head",2)) or nil
    LocalRoot = LocalCharacter and ((LocalHumanoid and LocalHumanoid.RootPart) or LocalCharacter:FindFirstChild("HumanoidRootPart") or LocalCharacter:WaitForChild("HumanoidRootPart",2)) or nil
    LocalAnimator = LocalHumanoid and (LocalHumanoid:FindFirstChildOfClass("Animator") or LocalHumanoid:WaitForChild("Animator",2)) or nil
    SpeedMultipliers = LocalCharacter and (Character:FindFirstChild("SpeedMultipliers") or Character:WaitForChild("SpeedMultipliers",5)) or nil
    ResistanceMultipliers = LocalCharacter and (Character:FindFirstChild("ResistanceMultipliers") or Character:WaitForChild("ResistanceMultipliers",5)) or nil
    FOVMultipliers = LocalCharacter and (Character:FindFirstChild("FOVMultipliers") or Character:WaitForChild("FOVMultipliers",5)) or nil
    CharacterAddedBindable:Fire()
end

if not MainModule then
    ColoredPrint("Failed to load required modules, some features may be hidden.\n use a different executor that supports 'require' and 'getgc'", "warn", Color3.new(1,0.25,0))
    FeatureLoadout["EnviromentFunctions"]["getgc"]["DefaultInstanceValue"] = false
end

if FeatureLoadout["EnviromentFunctions"]["getgc"]["DefaultInstanceValue"] then
    task.spawn(function()
        if game.GameId ~= 6331902150 then
            task.wait(0.5)
            if IsRequireSupported then
                for i,v in getgc(true) do
                    if type(v) == type({}) then
                        if not rawget(v,"Idle") or not rawget(v,"Run") then if i%250 == 0 then task.wait() end continue end
                        local num = 0
                        for i,v in v do num += 1 end
                        if num > 3 then AllAnimations[HttpService:GenerateGUID(false):sub(1,5)] = v end
                    end
                end
            end
        end
    end)
end

local UserType = 1
if not (readfile and writefile and isfolder and isfile) then
    FeatureLoadout["EnviromentFunctions"]["files"]["DefaultInstanceValue"] = false
else
    if not isfolder("NaikoScript") and not isfolder("NaikoScript/ForsakenPlus") then
        makefolder("NaikoScript")
        makefolder("NaikoScript/ForsakenPlus")
        UserType = 1
    elseif isfolder("NaikoScript") and not isfolder("NaikoScript/ForsakenPlus") then
        UserType = 2
        makefolder("NaikoScript/ForsakenPlus")
    elseif isfolder("NaikoScript") and isfolder("NaikoScript/ForsakenPlus") then
        UserType = 3
    end
    DefaultData("Data.txt", "{}")
    DefaultData("AccountType.txt","{}")
    makefolder("NaikoScript/ForsakenPlus/Plugins")
end

if UserType < 3 then
    task.spawn(function()
        Arrow.Visible = true
        local MovingTween = TweenService:Create(Arrow, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Position = UDim2.fromScale(1.4, 0.5)})
        MovingTween:Play()
        SidePlusButton.Button.MouseEnter:Wait()
        local DisappearTween = TweenService:Create(Arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1.6, 0.5),Size = UDim2.fromScale(0.2, 0.2),ImageTransparency = 1})
        MovingTween:Pause()
        MovingTween:Cancel()
        DisappearTween:Play()
        DisappearTween.Completed:Wait()
        Arrow.Visible = false
    end)
end

if not hookmetamethod and not (getrawmetatable and setreadonly) or not getnamecallmethod then
    FeatureLoadout["EnviromentFunctions"]["hookmetamethod"]["DefaultInstanceValue"] = false
end

if GetValue("OfficialGame") then
    task.spawn(function()
        local FrequencyData = HttpService:JSONDecode(ReturnData("AccountType.txt", true))
        FrequencyData["Normal"] = FrequencyData["Normal"] or 0
        FrequencyData["New"] = FrequencyData["New"] or 0
        ChangeData("AccountType.txt",HttpService:JSONEncode(FrequencyData),true)
        if GetValue("PrivateServer") then return end
        for i,v in Players:GetPlayers() do if v:IsFriendsWithAsync(LocalPlayer.UserId) then return end end
        if UserType < 3 then
            task.wait(26)
            if PlayerGui:FindFirstChild("LoadingGui") then return end
            if game.PlaceId ~= 83645629621104 then FrequencyData["Normal"] = 3 else FrequencyData["New"] = 5 end
        else
            task.wait(18)
            if PlayerGui:FindFirstChild("LoadingGui") then return end
            if game.PlaceId ~= 83645629621104 then
                FrequencyData["Normal"] += 2
                FrequencyData["New"] -= 1
            else
                FrequencyData["New"] += 2
                FrequencyData["Normal"] -= 1
            end
        end
        ChangeData("AccountType.txt",HttpService:JSONEncode(FrequencyData),true)
    end)
end

LocalPlayer.CharacterAdded:Connect(ActionOnCharacter)
TeleportSound = Instance.new("Sound")
TeleportSound.Name = "TeleportSound"
TeleportSound.SoundId = "rbxassetid://130359426691991"
TeleportSound.Parent = CoreGui
TeleportSound.Volume = 0.001
TeleportSound:Play()

RoundEvent.Event:Connect(function(Data) IsUnderground = false end)

local Graf2 = workspace:FindFirstChild("Graf2",true)
if Graf2 and math.round(Graf2.Position.X) == -3600 and Graf2:FindFirstChildWhichIsA("ImageLabel",true) then
    Graf2.Position = Vector3.new(-3600, 19.25, 232.5)
    Graf2.Size = Vector3.new(4.25, 1.5, 0.13)
    Graf2.Rotation = Vector3.new(7, 90, 0)
    Graf2:FindFirstChildWhichIsA("ImageLabel",true).Image = "rbxassetid://86461599034861"
    Graf2:FindFirstChildWhichIsA("ImageLabel",true).ImageTransparency = 0.2
end

local BaseTweenInfo = TweenInfo.new(0.25)
local MenuData
if NewUIVersion then
    local suc,err
    if IsRequireSupported then
        suc,err = pcall(function()
            MenuData = require(ReplicatedStorage.Systems.Player:FindFirstChild("SidebarHandler",true))
        end)
    end
    if not suc or not MenuData then
        IsRequireSupported = false
        FeatureLoadout["EnviromentFunctions"]["require"]["DefaultInstanceValue"] = false
    end
    if NewUIVersion then
        local FallbackSignal = {}
        FallbackSignal.__index = FallbackSignal
        function FallbackSignal.new()
            local self = setmetatable({}, FallbackSignal)
            local Bindable = Instance.new("BindableEvent")
            self._bindable = Bindable
            self.Event = Bindable.Event
            function self:Fire(...) self._bindable:Fire(...) end
            function self:Connect(...) return self._bindable.Event:Connect(...) end
            return self
        end
        local FallbackTween = TweenInfo.new(0.25)
        local FallbackSizes = {
            Middle = {Enter = UDim2.fromScale(0.985, 0.25),Exit = UDim2.fromScale(0.95, 0.22)},
            Bottom = {Enter = UDim2.fromScale(0.645, 0.18),Exit = UDim2.fromScale(0.606, 0.149)}
        }
        local FallbackLook = {
            BG = {Active = {ImageColor3 = Color3.fromRGB(198, 198, 198)}, Inactive = {ImageColor3 = Color3.fromRGB(8, 8, 8)}},
            GrungeMain = {Active = {ImageColor3 = Color3.fromRGB(0, 0, 0)}, Inactive = {ImageColor3 = Color3.fromRGB(80, 80, 80)}},
            Grunge = {Active = {ImageColor3 = Color3.fromRGB(255, 255, 255)}, Inactive = {ImageColor3 = Color3.fromRGB(0, 0, 0)}},
            Highlight = {Active = {ImageColor3 = Color3.fromRGB(0, 0, 0)}, Inactive = {ImageColor3 = Color3.fromRGB(255, 255, 255)}},
            Icon = {Active = {ImageColor3 = Color3.fromRGB(0, 0, 0)}, Inactive = {ImageColor3 = Color3.fromRGB(255, 255, 255)}},
            Line = {Active = {ImageColor3 = Color3.fromRGB(0, 0, 0)}, Inactive = {ImageColor3 = Color3.fromRGB(255, 255, 255)}}
        }
        local FallbackButton = {}
        FallbackButton.__index = FallbackButton
        function FallbackButton.new(ButtonFrame, Section)
            local self = setmetatable({}, FallbackButton)
            self.Instance = ButtonFrame
            self.onClick = FallbackSignal.new()
            ButtonFrame.MouseEnter:Connect(function()
                local Sizes = FallbackSizes[Section]
                if Sizes then TweenService:Create(ButtonFrame, FallbackTween, {Size = Sizes.Enter}):Play() end
                PlaySound("hover")
            end)
            ButtonFrame.MouseLeave:Connect(function()
                local Sizes = FallbackSizes[Section]
                if Sizes then TweenService:Create(ButtonFrame, FallbackTween, {Size = Sizes.Exit}):Play() end
                PlaySound("hoverEnd")
            end)
            return self
        end
        function FallbackButton.LoadMenu(self, MenuTable)
            self.Menu = MenuTable
            self.Instance.Button.MouseButton1Click:Connect(function()
                self.onClick:Fire()
                self.Menu:ToggleMenu()
            end)
        end
        function FallbackButton.SetAppearanceState(self, State)
            local Text = self.Instance.Button:FindFirstChild("Text")
            for i, v in Text and Text:GetChildren() or {} do
                if v:IsA("TextLabel") then
                    TweenService:Create(v, FallbackTween, {TextColor3 = State and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)}):Play()
                elseif v:IsA("ImageLabel") then
                    TweenService:Create(v, FallbackTween, {ImageColor3 = State and Color3.fromRGB(224, 224, 224) or Color3.fromRGB(0, 0, 0)}):Play()
                end
            end
            local Key = State and "Active" or "Inactive"
            for i, v in FallbackLook do
                local Target = self.Instance.Button:FindFirstChild(i)
                if Target then TweenService:Create(Target, FallbackTween, v[Key]):Play() end
            end
        end
        MenuData = {
            SidebarMenus = {},
            SidebarButtons = {},
            PendingSidebarMenus = {},
            TogglingMenus = nil,
            MenusHidden = false,
            onTransitionState = FallbackSignal.new(),
            onMenuSwitched = FallbackSignal.new(),
            CashDisplay = MainUI:FindFirstChild("CashDisplay", true),
            Sidebar = SideBar
        }
        MenuData.__index = MenuData
        local function LoadFallbackButton(Name, MenuTable)
            local Stored = MenuData.SidebarButtons[Name]
            if not Stored then
                MenuData.PendingSidebarMenus[Name] = MenuTable
                return false
            end
            Stored.onClick:Connect(function() MenuData.onMenuSwitched:Fire(Name) end)
            local suc, err = pcall(function() Stored:LoadMenu(MenuTable) end)
            if not suc then
                warn(`Failed to load Sidebar Menu '{Name}' | Button: {err}`)
                return false
            end
            MenuTable.Button = Stored
            MenuData.PendingSidebarMenus[Name] = nil
            return true
        end
        local function CloseFallbackMenu(MenuEntry)
            MenuEntry.Toggled:Fire(false)
            local Blur = Lighting:FindFirstChild("ShopBlur")
            if Blur then
                TweenService:Create(Blur, FallbackTween, {Size = 0}):Play()
                Debris:AddItem(Blur, 0.25)
            end
            local Zoom = FOVMultipliers:FindFirstChild("ShopZoom")
            if Zoom and Zoom:IsA("ValueBase") then
                TweenService:Create(Zoom, FallbackTween, {Value = 1}):Play()
                Debris:AddItem(Zoom, 0.25)
            end
            if MenuEntry.MenuName == "Shop" or MenuEntry.MenuName == "UpdateLog" then
                MenuEntry.Menu.Visible = false
                MenuEntry.Menu:SetAttribute("Visible", false)
            else
                TweenService:Create(MenuEntry.Menu, FallbackTween, {Size = UDim2.new(1, -20, 0, 0)}):Play()
                task.delay(0.25, function()
                    MenuEntry.Menu.Visible = false
                    MenuEntry.Menu:SetAttribute("Visible", false)
                end)
            end
            if MenuEntry.Button and MenuEntry.MenuName ~= "Plus" then
                MenuEntry.Button:SetAppearanceState(false)
            end
        end
        local function OpenFallbackMenu(MenuEntry)
            MenuEntry.Toggled:Fire(true)
            MenuEntry.Menu.Visible = true
            MenuEntry.Menu:SetAttribute("Visible", true)
            TweenService:Create(MenuEntry.Menu, FallbackTween, {Size = UDim2.new(1, -20, 1, -20)}):Play()
            if MenuEntry.Button and MenuEntry.MenuName ~= "Plus" then
                MenuEntry.Button:SetAppearanceState(true)
            end
        end
        function MenuData.ToggleMenu(selfdata, OnlyOpen)
            local DataSideBar = selfdata._sidebar
            if DataSideBar.TogglingMenus then return
            elseif DataSideBar.MenusHidden and selfdata.SidebarButton then return
            elseif OnlyOpen and selfdata.Menu.Visible then return end
            DataSideBar.TogglingMenus = true
            SidePlusButton.Parent.Interactable = false
            task.delay(0.35, function() SidePlusButton.Parent.Interactable = true end)
            local VisibleUI = selfdata.Menu.Visible
            PlaySound("select")
            local SideBarMenu
            for i, v in DataSideBar.SidebarMenus do
                if v.Menu ~= selfdata.Menu or VisibleUI then
                    if v.Menu ~= selfdata.Menu and v.Menu.Visible then SideBarMenu = v end
                    if v.Menu.Visible then
                        CloseFallbackMenu(v)
                        SetButtonState(false)
                    end
                end
            end
            task.delay(0.3 + (SideBarMenu and 0.125 or 0), function() DataSideBar.TogglingMenus = nil end)
            if SideBarMenu then
                task.wait(0.125)
                if DataSideBar.MenusHidden then
                    DataSideBar.TogglingMenus = nil
                    return
                end
            end
            if not VisibleUI then
                OpenFallbackMenu(selfdata)
                SetButtonState(true)
            else
                SetButtonState(false)
            end
        end
        function MenuData.ToggleButtons(self, State)
            MenuData.onTransitionState:Fire(State)
            SetButtonState(false)
            for i, v in MenuData.SidebarMenus do
                CloseFallbackMenu(v)
                if v.Button then v.Button:SetAppearanceState(false) end
                task.delay(0.25, function()
                    v.Menu.Visible = false
                    v.Menu:SetAttribute("Visible", false)
                end)
            end
        end
        function MenuData.ToggleSidebarButtons(self, State)
            MenuData.MenusHidden = not State
            MenuData.Sidebar.Visible = State
            if State then return end
            self:ToggleButtons(State)
        end
        function MenuData.CreateSidebarMenu(self, MenuName, MenuScreen)
            local Metaverse = setmetatable({}, MenuData)
            Metaverse.Menu = MenuScreen:Clone()
            Metaverse.Toggled = FallbackSignal.new()
            Metaverse.Button = nil
            Metaverse.MenuName = MenuName
            Metaverse.Menu.Visible = false
            Metaverse.Menu.Size = UDim2.fromScale()
            Metaverse.Menu.Parent = MainUI
            for i, v in Metaverse.Menu:QueryDescendants("ScrollingFrame") do
                v:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    v.ScrollBarThickness = v.AbsoluteSize.X / 44
                end)
            end
            Metaverse._sidebar = self
            Metaverse.SidebarButton = SideBar:FindFirstChild(MenuName, true)
            MenuData.SidebarMenus[MenuName] = Metaverse
            LoadFallbackButton(MenuName, Metaverse)
            return Metaverse
        end
        for i, v in SideBar:GetChildren() do
            for i, v2 in v:GetChildren() do
                if v2:IsA("Frame") then
                    MenuData.SidebarButtons[v2.Name] = FallbackButton.new(v2, v.Name)
                    local Waiting = MenuData.PendingSidebarMenus[v2.Name]
                    if Waiting then LoadFallbackButton(v2.Name, Waiting) end
                end
            end
        end
    end
else
    MenuData = {
        SidebarMenus = {},
        Sidebars = {Sidebar = MainUI.Sidebar, Bottombar = MainUI.Sidebar:FindFirstChild("Bottombar") or nil}
    }
    MenuData.__index = MenuData
    function MenuData.CreateSidebarMenu(self, ButtonName, Menu, Bottom)
        local Data = setmetatable({}, MenuData)
        Data.Menu = Menu
        Data.Menu.Visible = false
        Data.Menu.Size = UDim2.fromScale()
        Data.Menu.Parent = MainUI
        Data.SidebarButton = Buttons:FindFirstChild(ButtonName)
        local BindableEvent = Instance.new("BindableEvent")
        BindableEvent.Parent = Data.Menu
        Data.Toggled = BindableEvent.Event
        Data.__toggleEvent = BindableEvent
        for i,v in pairs(Data.Menu:QueryDescendants("ScrollingFrame")) do
            v:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                v.ScrollBarThickness = v.AbsoluteSize.X / 44
            end)
        end
        self.SidebarMenus[ButtonName] = Data
        return Data
    end
    function MenuData.ToggleMenu(UIData, p24)
        if MenuData.TogglingMenus then return
        elseif MenuData.MenusHidden and UIData.SidebarButton then return
        elseif not (p24 and UIData.Menu.Visible) then
            MenuData.TogglingMenus = true
            PlaySound("select")
            local Visible = UIData.Menu.Visible
            SidePlusButton.Parent.Interactable = false
            task.delay(0.35, function() SidePlusButton.Parent.Interactable = true end)
            for i,Menu in pairs(MenuData.SidebarMenus) do
                if Menu.Menu ~= UIData.Menu or Visible then
                    if Menu.Menu.Visible then
                        Menu.__toggleEvent:Fire(false)
                        TweenService:Create(Menu.Menu, BaseTweenInfo, {Size = UDim2.new(1, -20, 0, 0)}):Play()
                        if Menu.SidebarButton then
                            if Menu.SidebarButton:FindFirstChild("Inverted") then TweenService:Create(Menu.SidebarButton.Inverted, BaseTweenInfo, {ImageTransparency = 1}):Play() end
                            if Menu.SidebarButton:FindFirstChild("InvertedIcon") then TweenService:Create(Menu.SidebarButton.InvertedIcon, BaseTweenInfo, {ImageTransparency = 1}):Play() end
                            if Menu.SidebarButton.PulloutHolder.PulloutFrame:FindFirstChild("Inverted") then
                                TweenService:Create(Menu.SidebarButton.PulloutHolder.PulloutFrame.Inverted, BaseTweenInfo, {ImageTransparency = 1}):Play()
                            end
                            if Menu.SidebarButton.PulloutHolder.PulloutFrame:FindFirstChild("Title") then
                                TweenService:Create(Menu.SidebarButton.PulloutHolder.PulloutFrame.Title, BaseTweenInfo, {
                                    TextColor3 = Menu.Menu.Name == "PlusScreen" and Color3.fromRGB(0, 170, 127) or Color3.new(1,1,1)
                                }):Play()
                            end
                        end
                        task.delay(0.25, function()
                            Menu.Menu:SetAttribute("Visible", false)
                            Menu.Menu.Visible = false
                        end)
                    end
                end
            end
            task.delay(0.3, function() MenuData.TogglingMenus = nil end)
            if MenuData.MenusHidden then return end
            if not Visible then
                UIData.__toggleEvent:Fire(true)
                UIData.Menu:SetAttribute("Visible", true)
                UIData.Menu.Visible = true
                TweenService:Create(UIData.Menu, BaseTweenInfo, {Size = UDim2.new(1, -20, 1, -20)}):Play()
                if UIData.SidebarButton then
                    if UIData.SidebarButton:FindFirstChild("Inverted") then TweenService:Create(UIData.SidebarButton.Inverted, BaseTweenInfo, {ImageTransparency = 0}):Play() end
                    if UIData.SidebarButton:FindFirstChild("InvertedIcon") then TweenService:Create(UIData.SidebarButton.InvertedIcon, BaseTweenInfo, {ImageTransparency = 0}):Play() end
                    if UIData.SidebarButton.PulloutHolder.PulloutFrame:FindFirstChild("Inverted") then
                        TweenService:Create(UIData.SidebarButton.PulloutHolder.PulloutFrame.Inverted, BaseTweenInfo, {ImageTransparency = 0}):Play()
                    end
                    if UIData.SidebarButton.PulloutHolder.PulloutFrame:FindFirstChild("Title") then
                        TweenService:Create(UIData.SidebarButton.PulloutHolder.PulloutFrame.Title, BaseTweenInfo, {TextColor3 = Color3.fromRGB(0, 170, 127)}):Play()
                    end
                end
            end
        end
    end
end

ModulesOptions = {
    ["Textbox"] = [=[
        local u1 = {}
        u1.__index = u1
        local PlaySound = ({...})[1]
        function u1.CreateSettingUI(_, u2, p3, u4)
            if not u2 then
                u2 = Instance.new("StringValue")
                u2.Name = "SettingValue"
            end
            local u7 = setmetatable({SettingValue = u2}, u1)
            u7.Value = u2.Value
            u7.Instance = p3 or game:GetService("ReplicatedStorage").Systems.Player.UI.Menus.Settings.Templates.Textbox.Textbox:Clone()
            u7.Instance.TextboxBackground.Textbox.Focused:Connect(function() PlaySound("click") end)
            u7.Instance.TextboxBackground.Textbox.FocusLost:Connect(function()
                if u2.Name == "SettingValue" or u2.Name == "Value" then
                    u7.Value = u7.Instance.TextboxBackground.Textbox.Text
                    u7:OnUpdate()
                    if u4 then u4(u7.Value) end
                else
                    u2.Value = u7.Instance.TextboxBackground.Textbox.Text
                end
                PlaySound("click")
            end)
            return u7
        end
        function u1.OnUpdate(p8) p8.Instance.TextboxBackground.Textbox.Text = p8.Value or "" end
        return u1
    ]=],
    ["String"] = [=[
        local u1 = {}
        u1.__index = u1
        local PlaySound = ({...})[1]
        function u1.CreateSettingUI(_, u3, p4, u5)
            if not u3 then
                u3 = Instance.new("StringValue")
                u3.Name = "SettingValue"
            end
            local u8 = setmetatable({SettingValue = u3}, u1)
            u8.Value = u3.Value
            u8.Instance = p4 or game:GetService("ReplicatedStorage").Systems.Player.UI.Menus.Settings.Templates.String.Dropdown:Clone()
            u8.DropdownVisible = false
            local UIListLayout = u8.Instance.DropdownFrame.Options:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout")
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = u8.Instance.DropdownFrame.Options
            u8.Instance.DropdownFrame.MouseButton1Click:Connect(function()
                PlaySound("click")
                local MainZIndex = u8.Instance.LayoutOrder
                u8.DropdownVisible = not u8.DropdownVisible
                u8.Instance.DropdownFrame.DropdownArrow.Rotation = u8.DropdownVisible and 180 or 0
                u8.Instance.DropdownFrame.Options.Visible = u8.DropdownVisible
                u8.Instance.ZIndex = 50000 - (MainZIndex * 2)
                local function Update()
                    local v10 = u3:GetAttribute("Options")
                    if v10 then v10 = string.split(u3:GetAttribute("Options"), "|") end
                    for i, v9 in pairs(u8.Instance.DropdownFrame.Options:GetChildren()) do
                        if v9:IsA("GuiObject") then v9:Destroy() end
                    end
                    for v11, u12 in pairs(v10 or {}) do
                        local v13 = game:GetService("ReplicatedStorage").Systems.Player.UI.Menus.Settings.Templates.String.DropdownOption:Clone()
                        v13.Name = u12
                        v13.LayoutOrder = v11
                        v13.Title.Text = v13.Name
                        v13.Parent = u8.Instance.DropdownFrame.Options
                        v13.MouseButton1Click:Connect(function()
                            if u3.Name == "SettingValue" or u3.Name == "Value" then
                                u8.Value = u12
                                u8:OnUpdate()
                                if u5 then u5(u8.Value) end
                            else
                                u3.Value = u12
                            end
                            PlaySound("switch0".. tostring(math.random(1,4)))
                        end)
                    end
                end
                Update()
                u3:GetAttributeChangedSignal("Options"):Connect(Update)
            end)
            return u8
        end
        function u1.OnUpdate(p14)
            p14.Instance.D
