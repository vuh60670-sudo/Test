-- Forsaken Plus Made by Naiko Scripts --
-- Copies of this script must contain the original credits and be open source --

if workspace.DistributedGameTime < 4 then
	task.wait(4 - workspace.DistributedGameTime)
end

if game.CoreGui:FindFirstChild("Plus") then
    return warn("Script already running")
elseif game.GameId == 6331902150 or game.GameId == 7464167604 or workspace:GetAttribute("ServerType") then
	Instance.new("BoolValue", game.CoreGui).Name = "Plus"
else
	return warn("Incorrect game")
end

game:GetService("Players").LocalPlayer.Idled:Connect(function()
	game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- General Variables --

Version = "1.94"
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
LocalCharacter = LocalPlayer.Character
LocalHumanoid = LocalCharacter and (LocalCharacter:FindFirstChildOfClass("Humanoid") or LocalCharacter:WaitForChild("Humanoid",2)) or nil
LocalHead = LocalCharacter and (LocalCharacter:FindFirstChild("Head") or LocalCharacter:WaitForChild("Head",2)) or nil
LocalRoot = LocalCharacter and ((LocalHumanoid and LocalHumanoid.RootPart) or LocalCharacter:FindFirstChild("HumanoidRootPart") or LocalCharacter:WaitForChild("HumanoidRootPart",2)) or nil
LocalAnimator = LocalHumanoid and (LocalHumanoid:FindFirstChildOfClass("Animator") or LocalHumanoid:WaitForChild("Animator",2)) or nil
SpeedMultipliers = LocalCharacter and (LocalCharacter:FindFirstChild("SpeedMultipliers")) or nil
ResistanceMultipliers = LocalCharacter and (LocalCharacter:FindFirstChild("ResistanceMultipliers")) or nil
FOVMultipliers = LocalCharacter and (LocalCharacter:FindFirstChild("FOVMultipliers")) or nil
CoreGui = game:GetService("CoreGui")
PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 20)
MainUI = PlayerGui:FindFirstChild("MainUI") or PlayerGui:WaitForChild("MainUI", 80)
PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 20)
PlusFolderSettings = Instance.new("Folder")
SideBar = MainUI:FindFirstChild("Sidebar") or MainUI:WaitForChild("Sidebar", 20)
Buttons = SideBar:FindFirstChild("Buttons") or SideBar:FindFirstChild("Middle") or SideBar:FindFirstChild("Stats",true) and SideBar:FindFirstChild("Stats",true).Parent or SideBar:WaitForChild("Buttons", 4) or SideBar:WaitForChild("Middle", 4)
MainButton = Buttons:FindFirstChild("Settings") or Buttons:FindFirstChild("Stats") or Buttons:WaitForChild("Settings", 4) or Buttons:FindFirstChild("Stats") or Buttons:WaitForChild("Stats", 4)
SidePlusButton = MainButton and MainButton:Clone()
PlusButton = SidePlusButton and SidePlusButton:FindFirstChild("Button") or nil
PulloutFramePlus = SidePlusButton and SidePlusButton:FindFirstChild("PulloutHolder") and SidePlusButton.PulloutHolder:FindFirstChild("PulloutFrame")
NewUIVersion = not PulloutFramePlus
SettingsMenu = MainUI:FindFirstChild("SettingsScreen") or MainUI:WaitForChild("SettingsScreen", 20)
TempUI = PlayerGui:FindFirstChild("TemporaryUI") or PlayerGui:WaitForChild("TemporaryUI",5)
PlusMenu = SettingsMenu and SettingsMenu:Clone()
PlayersFolder = workspace:FindFirstChild("Players")
KillersFolder = PlayersFolder and PlayersFolder:FindFirstChild("Killers")
SurvivorsFolder = PlayersFolder and PlayersFolder:FindFirstChild("Survivors")
RagdollsFolder = workspace:FindFirstChild("Ragdolls")
Hitboxes = workspace:FindFirstChild("Hitboxes")
MarketplaceService = game:GetService("MarketplaceService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
UserInputService = game:GetService("UserInputService")
TextChatService = game:GetService("TextChatService")
PhysicsService = game:GetService("PhysicsService")
TweenService = game:GetService("TweenService")
GroupService = game:GetService("GroupService")
HttpService = game:GetService("HttpService")
LogService = game:GetService("LogService")
RunService = game:GetService("RunService")
StarterGui = game:GetService("StarterGui")
Lighting = game:GetService("Lighting")
Debris = game:GetService("Debris")
AssetsFolder = ReplicatedStorage:FindFirstChild("Assets") or ReplicatedStorage:WaitForChild("Assets",3)
SkinsAssets = AssetsFolder and AssetsFolder:FindFirstChild("Skins")
SurvivorAssets = AssetsFolder and AssetsFolder:FindFirstChild("Survivors")
KillerAssets = AssetsFolder and AssetsFolder:FindFirstChild("Killers")
MinigamesFolder = ReplicatedStorage:FindFirstChild("Minigames",true)
FlowGame = MinigamesFolder and (MinigamesFolder:FindFirstChild("FlowGame",true) or MinigamesFolder:FindFirstChild("FlowBoard"))
LockBoard = MinigamesFolder and MinigamesFolder:FindFirstChild("LockBoard")
ConnectBoard = MinigamesFolder and MinigamesFolder:FindFirstChild("ConnectBoard")
StatusEffects = ReplicatedStorage:FindFirstChild("StatusEffects",true)
Network = ReplicatedStorage:FindFirstChild("Modules") and (ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Network",true) and ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Network",true):FindFirstChild("Network")) or ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Network",true) or nil
InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
GameMap = InGame and InGame:FindFirstChild("Map") or nil
RoundEvent = Instance.new("BindableEvent")
local BindableShouldStop = Instance.new("BindableEvent")
local UIScale = Instance.new("UIScale")
IsUnderground,IsFixingGenerator,WarnedAboutFilesCompatability = false,false,false
OverriddenAnimations,AllAnimations,Values = {},{["Default Roblox"] = {["Idle"] = "http://www.roblox.com/asset/?id=180435571",["Walk"] = "http://www.roblox.com/asset/?id=180426354",["Run"] = "http://www.roblox.com/asset/?id=180426354"}},{}
local ModulesOptions,LastTrack,NoliConfig,GetAnimationType,LastAnimOriginalUsed,UpdateAnim,CanPlayOverrideAnim,CurrentQTEAzure,TeleportSound,GetFunction
ColorPresets = {["White"] = Color3.fromRGB(255,255,255),["Teal"] = Color3.fromRGB(3,252,157),["Green"] = Color3.fromRGB(0,255,0),["Light Green"] = Color3.fromRGB(191, 255, 191),["Purple"] = Color3.fromRGB(158, 0, 179),["Red"] = Color3.fromRGB(255,0,0),["Blue"] = Color3.fromRGB(0,0,255),["Cyan"] = Color3.fromRGB(0,255,255),["Gold"] = Color3.fromRGB(255,215,0),["Orange"] = Color3.fromRGB(255,135,15)}
IgnoreKeybinds = {"W", "A", "S", "D"}
GameVersionForScript = "2026-20-10"
local FeatureLoadout; FeatureLoadout = {
    ["EnviromentFunctions"] = {
          ["TabAttributes"] = {
            ["DisplayTitle"] = "Script Made by Naiko Scripts | " .. tostring(Version),
            ["LayoutOrder"] = 666
        },
        ["hookmetamethod"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "hookmetamethod",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = true
        },
        ["getgc"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "getgc",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = true
        },
        ["require"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "require",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = true
        },
        ["files"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "files",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = true
        },
        ["OfficialGame"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "Official Game",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = game.GameId == 6331902150 or game.GameId == 7464167604 or game.GameId == 7919224306,
            ["Requirement"] = true
        },
        ["PrivateServer"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "Private Server",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = workspace:GetAttribute("ServerType") == "VIP",
            ["Requirement"] = true
        },
        ["PrivateServerOwner"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "Private Server",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = workspace:GetAttribute("ServerOwnerID") == LocalPlayer.UserId,
            ["Requirement"] = true
        },
        ["NServer"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "N Server",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = game.PlaceId == 83645629621104,
            ["Requirement"] = true
        },
        ["Computer"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "Computer",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = UserInputService.KeyboardEnabled,
            ["Requirement"] = true,
            ["OnLoop"] = function(self)
                self.Instance.Value = UserInputService.KeyboardEnabled
            end
        },
    },

    ["Automation"] = {
        ["TabAttributes"] = {
            ["DisplayTitle"] = "Automation",
            ["LayoutOrder"] = 1
        },
        ["AutoGeneratorPuzzle"] = {
            ["DisplayDescription"] = "Auto Completes Generator Puzzles",
            ["DisplayTitle"] = "Auto Generator(s)",
            ["LayoutOrder"] = 1,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["GenCheck"] = function(self)
                return not self.Solving or not LocalCharacter or not (GetValue("AutoGeneratorPuzzle"))
            end,
            ["GetDelay"] = function(self)
                local Cooldown = tonumber(GetValue("GeneratorCooldown")) or 2
                local CooldownInstance = GetValue("GeneratorCooldown",true)
                local IsNear = self:IsPlayersNear(32)
                local GenCD = (not IsNear and GetValue("SpeedUpCooldown") and Cooldown > 2 and CooldownInstance and CooldownInstance:GetAttribute("MinValue")) or Cooldown
                GenCD = math.max(tonumber(GenCD) or Cooldown,0.25)
                return self.RNG:NextNumber(GenCD - 0.1 * GenCD,GenCD + 0.1 * GenCD)
            end,
            ["GetStepDelay"] = function(self)
                local CooldownInstance = GetValue("GeneratorCooldown",true)
                local Step = CooldownInstance and CooldownInstance:GetAttribute("CurrentSpeed")
                return math.max(tonumber(Step) or 0.05,0.01)
            end,
            ["IsAlive"] = function(self,Key)
                return self.Sessions ~= nil and self.Sessions[Key] ~= nil
            end,
            ["BlockInputs"] = function(self)
                self.InputBlockCount = (self.InputBlockCount or 0) + 1
                if self.InputBlocked then
                    return
                end
                self.InputBlocked = true
                local ContextActionService = self.ContextActionService
                if not ContextActionService then
                    ContextActionService = game:GetService("ContextActionService")
                    self.ContextActionService = ContextActionService
                end
                ContextActionService:BindActionAtPriority("GeneratorBlock",function()
                    return Enum.ContextActionResult.Sink
                end,false,10000,Enum.UserInputType.MouseButton1,Enum.UserInputType.Touch)
            end,
            ["UnblockInputs"] = function(self,Force)
                if Force then
                    self.InputBlockCount = 0
                else
                    self.InputBlockCount = math.max((self.InputBlockCount or 1) - 1,0)
                end
                if self.InputBlockCount > 0 or not self.InputBlocked then
                    return
                end
                self.InputBlocked = false
                local ContextActionService = self.ContextActionService
                if not ContextActionService then
                    return
                end
                ContextActionService:UnbindAction("GeneratorBlock")
            end,
            ["BlockInputObject"] = function(self,Input)
                if not Input or Input.__Blocked then
                    return
                end
                Input.__Blocked = true
                if typeof(Input.__disableConsole) == "function" then
                    Input:__disableConsole()
                end
                local Connections = Input.__connections
                if typeof(Connections) == "table" then
                    for i,Connection in Connections do
                        if typeof(Connection) == "RBXScriptConnection" then
                            Connection:Disconnect()
                        end
                    end
                    table.clear(Connections)
                end
            end,
            ["GetGearsCount"] = function(self)
                if not self.GearsHandler then
                    local Module = ReplicatedStorage:FindFirstChild("GearsClientHandler", true)
                    if not Module then
                        return nil
                    end
                    self.GearsHandler = require(Module)
                end
                return self.GearsHandler:Get()
            end,
            ["SetLoadState"] = function(self,State)
                local PuzzleUI = PlayerGui:FindFirstChild("PuzzleUI")
                local Container = PuzzleUI and PuzzleUI:FindFirstChild("Container")
                local Holder = Container and Container:FindFirstChild("GridHolder")
                local Overlay = Holder and Holder:FindFirstChild("load")
                if not Overlay then
                    return
                end
                local Label = Overlay:FindFirstChild("TextButton")
                local Folder = Overlay:FindFirstChild("Folder")
                if State == "NeedsGears" then
                    if Label then
                        Label.Text = "Gears Needed"
                        Label.Position = UDim2.new(0.5,0,0.5,0)
                    end
                    for i,v in Folder:GetChildren() do
                        v.Visible = false
                    end
                else
                    if Label then
                        Label.Text = "Completing"
                        Label.Position = UDim2.new(0.5,0,0.6,0)
                    end
                    for i,v in Folder:GetChildren() do
                        v.Visible = true
                    end
                end
            end,
            ["LegacyLoop"] = function(self)
                if GetValue("require") then
                    return
                end
                if self.Solving or not GameMap then
                    return
                end
                if not LocalRoot or LocalRoot.Anchored == true then
                    return
                end
                for i,Object in GameMap:QueryDescendants("Model#Generator:has(#Main)") do
                    local Main = Object:FindFirstChild("Main")
                    if Main and (Main.Position - LocalRoot.Position).Magnitude < 6.7 then
                        local Remotes = Object:FindFirstChild("Remotes")
                        local Progress = Remotes and Object:FindFirstChild("Progress")
                        local RemoteEvent = Progress and Remotes:FindFirstChildOfClass("RemoteEvent")
                        if RemoteEvent and PlayerGui:FindFirstChild("PuzzleUI") then
                            task.spawn(function()
                                self.Solving = true
                                self:BlockInputs()
                                while PlayerGui:FindFirstChild("PuzzleUI") and not self:GenCheck() do
                                    local IsNear = self:IsPlayersNear(32)
                                    local GenCD = (not IsNear and GetValue("SpeedUpCooldown") and GetValue("GeneratorCooldown") > 2 and (GetValue("GeneratorCooldown",true):GetAttribute("MinValue"))) or GetValue("GeneratorCooldown")
                                    task.wait(self.RNG:NextNumber(GenCD - 0.1 * GenCD,GenCD + 0.1 * GenCD))
                                    if self:GenCheck() or not PlayerGui:FindFirstChild("PuzzleUI") then
                                        break
                                    end
                                    if not GetValue("require") then
                                        RemoteEvent:FireServer()
                                        PlaySound("puzzleDone",{["Parent"] = Object:FindFirstChild("Main")})
                                    end
                                end
                                self.Solving = false
                                self:UnblockInputs()
                            end)
                        end
                        break
                    end
                end
            end,
            ["FindSession"] = function(self,Name,SessionId)
                local Module = self.Controller:GetMinigame(Name)
                if not Module then
                    return nil
                end
                return Module:FromSessionId(SessionId)
            end,
            ["WaitSession"] = function(self,Name,SessionId,Timeout)
                local WaitUntil = os.clock() + (Timeout or 2)
                local Session = self:FindSession(Name,SessionId)
                while (not Session or not Session.__input) and os.clock() < WaitUntil do
                    task.wait(0.05)
                    Session = self:FindSession(Name,SessionId)
                end
                return Session
            end,
            ["BuildFlowSolution"] = function(self,Size,Pairs)
                if #Pairs == 0 then
                    return nil
                end
                local Rows,Cols = {},{}
                for Cell = 1,Size * Size do
                    Rows[Cell] = (Cell - 1) // Size + 1
                    Cols[Cell] = (Cell - 1) % Size + 1
                end
                local Dots = {}
                for i,Pair in Pairs do
                    Dots[Pair[1]] = true
                    Dots[Pair[2]] = true
                end
                local function FindPath(From,To,Blocked,WantPath)
                    local Queue = {From}
                    local Head = 1
                    local Seen = {[From] = true}
                    local Parent
                    local Depth
                    if WantPath then
                        Parent = {}
                    else
                        Depth = {[From] = 0}
                    end
                    while Head <= #Queue do
                        local Cell = Queue[Head]
                        Head = Head + 1
                        if Cell == To then
                            if not WantPath then
                                return Depth[Cell]
                            end
                            local Path = {}
                            local Current = To
                            while Current do
                                table.insert(Path,1,Current)
                                Current = Parent[Current]
                            end
                            for i,PathCell in Path do
                                Blocked[PathCell] = true
                            end
                            return Path
                        end
                        local Neighbors = {}
                        if Rows[Cell] > 1 then
                            table.insert(Neighbors,Cell - Size)
                        end
                        if Rows[Cell] < Size then
                            table.insert(Neighbors,Cell + Size)
                        end
                        if Cols[Cell] > 1 then
                            table.insert(Neighbors,Cell - 1)
                        end
                        if Cols[Cell] < Size then
                            table.insert(Neighbors,Cell + 1)
                        end
                        for i = #Neighbors,2,-1 do
                            local Swap = self.RNG:NextInteger(1,i)
                            Neighbors[i],Neighbors[Swap] = Neighbors[Swap],Neighbors[i]
                        end
                        for i,Next in Neighbors do
                            if not Seen[Next] and not Blocked[Next] and (not Dots[Next] or Next == To) then
                                Seen[Next] = true
                                if WantPath then
                                    Parent[Next] = Cell
                                else
                                    Depth[Next] = Depth[Cell] + 1
                                end
                                table.insert(Queue,Next)
                            end
                        end
                    end
                    return nil
                end
                local Order = {}
                for i = 1,#Pairs do
                    Order[i] = i
                end
                table.sort(Order,function(a,b)
                    local A = Pairs[a]
                    local B = Pairs[b]
                    return (math.abs(Rows[A[1]] - Rows[A[2]]) + math.abs(Cols[A[1]] - Cols[A[2]])) < (math.abs(Rows[B[1]] - Rows[B[2]]) + math.abs(Cols[B[1]] - Cols[B[2]]))
                end)
                for Try = 1,400 do
                    local Blocked = {}
                    local Solution = {}
                    local Solved = true
                    if Try <= 60 then
                        local Work = {}
                        for i,Index in Order do
                            Work[i] = Index
                        end
                        for i = #Work,2,-1 do
                            local Swap = self.RNG:NextInteger(1,i)
                            Work[i],Work[Swap] = Work[Swap],Work[i]
                        end
                        for i,Index in Work do
                            local Pair = Pairs[Index]
                            local Path = FindPath(Pair[1],Pair[2],Blocked,true)
                            if not Path then
                                Solved = false
                                break
                            end
                            Solution[Index] = Path
                        end
                    else
                        local Remaining = {}
                        for i = 1,#Pairs do
                            Remaining[i] = i
                        end
                        while #Remaining > 0 do
                            local BestDist
                            local Ties = {}
                            for k,Index in Remaining do
                                local Pair = Pairs[Index]
                                local Dist = FindPath(Pair[1],Pair[2],Blocked,false)
                                if Dist then
                                    if not BestDist or Dist < BestDist then
                                        BestDist = Dist
                                        Ties = {k}
                                    elseif Dist == BestDist then
                                        table.insert(Ties,k)
                                    end
                                end
                            end
                            if #Ties == 0 then
                                Solved = false
                                break
                            end
                            local Pick = Ties[self.RNG:NextInteger(1,#Ties)]
                            local Index = Remaining[Pick]
                            table.remove(Remaining,Pick)
                            local Pair = Pairs[Index]
                            local Path = FindPath(Pair[1],Pair[2],Blocked,true)
                            if not Path then
                                Solved = false
                                break
                            end
                            Solution[Index] = Path
                        end
                    end
                    if Solved then
                        return Solution
                    end
                end
                return nil
            end,
            ["BuildConnectSolution"] = function(self,Blobs)
                local Groups = {}
                for Blob,Color in Blobs do
                    if typeof(Blob) ~= "number" or typeof(Color) ~= "number" then
                        return nil
                    end
                    Groups[Color] = Groups[Color] or {}
                    table.insert(Groups[Color],Blob)
                end
                local Solution = {}
                local Total = 0
                for i,Group in Groups do
                    if #Group % 2 ~= 0 then
                        return nil
                    end
                    for i2 = 1,#Group,2 do
                        table.insert(Solution,{math.min(Group[i2],Group[i2 + 1]),math.max(Group[i2],Group[i2 + 1])})
                        Total = Total + 2
                    end
                end
                return Total > 0 and Solution or nil
            end,
            ["DrawFlow"] = function(self,Key,Input,Solution)
                local Board = Input.Board
                local Renderer = Input.Renderer
                local Sounds = self.SoundsModule
                if not Board or typeof(Board.Paths) ~= "table" then
                    return false
                end
                local Order = {}
                for i = 1,#Solution do
                    Order[i] = i
                end
                for i = #Order,2,-1 do
                    local Swap = self.RNG:NextInteger(1,i)
                    Order[i],Order[Swap] = Order[Swap],Order[i]
                end
                for i,Index in Order do
                    local Path = Solution[Index]
                    if Path and not Input.Ended then
                        Board.Paths[Index] = {}
                        if Sounds then
                            Sounds:Play("dragBegin")
                        end
                        for i2,Cell in Path do
                            if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                                return false
                            end
                            table.insert(Board.Paths[Index],Cell)
                            if typeof(Board.__rebuild) == "function" then
                                Board:__rebuild()
                            end
                            if Renderer and typeof(Renderer.Render) == "function" then
                                Renderer.Render(Renderer)
                            end
                            if Sounds then
                                if i2 >= #Path then
                                    Sounds:Play("lineConnect")
                                else
                                    Sounds:Play("lineDraw")
                                end
                            end
                            task.wait(self:GetStepDelay())
                        end
                        if Sounds then
                            Sounds:Play("dragEnd")
                        end
                        task.wait(0.15)
                    end
                end
                return true
            end,
            ["DrawConnect"] = function(self,Key,Input,Solution)
                local Board = Input.Board
                local Renderer = Input.Renderer
                local Sounds = self.SoundsModule
                if not Board or typeof(Board.Connect) ~= "function" then
                    return false
                end
                local Cooldown = tonumber(GetValue("GeneratorCooldown")) or 4
                local CooldownInstance = GetValue("GeneratorCooldown",true)
                local IsNear = self:IsPlayersNear(32)
                local GenCD = (not IsNear and GetValue("SpeedUpCooldown") and Cooldown > 2 and CooldownInstance and CooldownInstance:GetAttribute("MinValue")) or Cooldown
                GenCD = math.max(tonumber(GenCD) or Cooldown,0.25)
                local PairDelay = math.max(GenCD / math.max(#Solution,1),0.1)
                for i,Pair in Solution do
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return false
                    end
                    task.wait(PairDelay * 0.8)
                    if typeof(Board.GetLink) ~= "function" or not Board:GetLink(Pair[1]) then
                        if Sounds then
                            Sounds:Play("lineConnect")
                        end
                        Board:Connect(Pair[1],Pair[2])
                    end
                    if Renderer and typeof(Renderer.Render) == "function" then
                        Renderer.Render(Renderer)
                    end
                    task.wait(PairDelay * 0.2)
                end
                return true
            end,
            ["SolveFlow"] = function(self,Key,Index,SessionId,Properties)
                local Size = Properties:Get("GridSize")
                local Pairs = Properties:Get("Pairs")
                if typeof(Size) ~= "number" or typeof(Pairs) ~= "table" then
                    return
                end
                local Solution = self:BuildFlowSolution(Size,Pairs)
                local Round = 1
                while not Solution and Round < 3 do
                    Round = Round + 1
                    task.wait(0.25)
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    Solution = self:BuildFlowSolution(Size,Pairs)
                end
                if not Solution then
                    self.Controller:FireServer(Index,SessionId,"Leave")
                    return
                end
                for Attempt = 1,10 do
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    local Session = self:WaitSession("FlowClientMinigame",SessionId,4)
                    local Input = Session and Session.__input
                    self:BlockInputObject(Input)
                    local Board = Input and Input.Board
                    local CanDraw = Input and Board and Board.Size == Size and not Input.Ended and typeof(Board.Paths) == "table"
                    if CanDraw then
                        self:DrawFlow(Key,Input,Solution)
                        task.wait(0.2)
                        if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                            return
                        end
                        Session = self:FindSession("FlowClientMinigame",SessionId)
                        Input = Session and Session.__input
                        Board = Input and Input.Board
                        local Solved = Board and typeof(Board.IsSolved) == "function" and Board:IsSolved()
                        if Solved then
                            if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                                return
                            end
                            local Export
                            if typeof(Board.Export) == "function" then
                                Export = Board:Export()
                            end
                            self.Controller:FireServer(Index,SessionId,"Submit",Export or Solution)
                            task.wait(0.4)
                        end
                    else
                        self.Controller:FireServer(Index,SessionId,"Submit",Solution)
                        task.wait(0.4)
                    end
                    if Attempt == 10 and self:IsAlive(Key) then
                        self.Controller:FireServer(Index,SessionId,"Submit",Solution)
                        task.wait(0.4)
                    end
                end
            end,
            ["SolveConnect"] = function(self,Key,Index,SessionId,Properties)
                local Blobs = Properties:Get("Blobs")
                if typeof(Blobs) ~= "table" then
                    return
                end
                local Solution = self:BuildConnectSolution(Blobs)
                if not Solution then
                    return
                end
                for Attempt = 1,10 do
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    local Session = self:WaitSession("ConnectClientMinigame",SessionId,2)
                    local Input = Session and Session.__input
                    self:BlockInputObject(Input)
                    local Board = Input and Input.Board
                    if Input and Board and not Input.Ended and typeof(Board.Connect) == "function" then
                        self:DrawConnect(Key,Input,Solution)
                    end
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    Session = self:FindSession("ConnectClientMinigame",SessionId)
                    Input = Session and Session.__input
                    Board = Input and Input.Board
                    local Solved = Board and typeof(Board.IsSolved) == "function" and Board:IsSolved()
                    local Export
                    if Board and Solved and typeof(Board.Export) == "function" then
                        Export = Board:Export()
                    end
                    self.Controller:FireServer(Index,SessionId,"Submit",Export or Solution)
                    task.wait(0.4)
                end
            end,
            ["SolveLock"] = function(self,Key,Index,SessionId,Properties)
                local LockBoardModule = self.LockBoardModule
                if not LockBoardModule then
                    return
                end
                local Config = Properties:Get("Config")
                if typeof(Config) ~= "table" or typeof(Config.Seed) ~= "number" or typeof(Config.Speed) ~= "number" or typeof(Config.TargetSize) ~= "number" or typeof(Config.Hits) ~= "number" or typeof(Config.StartTime) ~= "number" then
                    return
                end
                local Session = self:WaitSession("LockClientMinigame",SessionId,2)
                local Input = Session and Session.__input
                self:BlockInputObject(Input)
                local OnPress
                local Callbacks = Input and Input.Callbacks
                if typeof(Callbacks) == "table" and typeof(Callbacks.OnPress) == "function" then
                    OnPress = Callbacks.OnPress
                end
                local Board = LockBoardModule.new(Config)
                local function ApplyState(State)
                    if typeof(State) == "table" and typeof(State.Presses) == "number" and State.Presses >= Board.State.Presses then
                        Board:Apply(State)
                    end
                end
                local Connection
                if typeof(Properties.Connect) == "function" then
                    Connection = Properties:Connect("State", ApplyState)
                end
                ApplyState(Properties:Get("State"))
                local PressedTarget
                local Attempts = 0
                local MaxAttempts = math.max(Config.Hits * 8,16)
                while self:IsAlive(Key) and Attempts < MaxAttempts do
                    ApplyState(Properties:Get("State"))
                    if GetValue("AutoGeneratorPuzzle") and not Board:IsBroken() then
                        local Now = workspace:GetServerTimeNow()
                        local Angle = Board:AngleAt(Now)
                        local State = Board.State
                        local Target = State.Target
                        local OnTarget = Board:IsOnTarget(Angle)
                        if not OnTarget then
                            PressedTarget = nil
                        elseif PressedTarget ~= Target then
                            PressedTarget = Target
                            Attempts += 1
                            local Diff = (Angle - Target) % 360
                            if Diff > 180 then
                                Diff = Diff - 360
                            end
                            local Tau = 0
                            if State.Direction ~= 0 and Config.Speed > 0 then
                                Tau = -Diff / (State.Direction * Config.Speed)
                            end
                            local HalfTol = 0
                            if Config.Speed > 0 then
                                HalfTol = (Config.TargetSize / 2) / Config.Speed
                            end
                            local PressAfter = Tau + self.RNG:NextNumber(-0.95,0.3) * HalfTol
                            if PressAfter < 0 or PressAfter > 1.4 then
                                PressAfter = 0
                            end
                            local PressesBefore = Board.State.Presses
                            if typeof(OnPress) == "function" then
                                if PressAfter > 0 and PressAfter < 1.5 then
                                    task.wait(PressAfter)
                                end
                                OnPress()
                            else
                                local PressTime = Now + PressAfter
                                if PressAfter > 0 and PressAfter < 1.5 then
                                    task.wait(PressAfter)
                                end
                                if Board:IsOnTarget(Board:AngleAt(PressTime)) then
                                    if Board:Press(PressTime) then
                                        self.Controller:FireServer(Index,SessionId,"Press",PressTime)
                                    end
                                end
                            end
                            local Timeout = os.clock() + 1
                            while os.clock() < Timeout and self:IsAlive(Key) do
                                local ServerState = Properties:Get("State")
                                if typeof(ServerState) == "table" and typeof(ServerState.Presses) == "number" and ServerState.Presses > PressesBefore then
                                    break
                                end
                                task.wait()
                            end
                            local ServerState = Properties:Get("State")
                            if typeof(ServerState) == "table" and typeof(ServerState.Presses) == "number" then
                                Board:Apply(ServerState)
                            end
                        end
                    end
                    task.wait()
                end
                if Connection and typeof(Connection.Disconnect) == "function" then
                    Connection:Disconnect()
                end
            end,
            ["SolveGear"] = function(self,Key,Index,SessionId,Properties)
                local Session = self:WaitSession("GearClientMinigame",SessionId,2)
                local Renderer = Session and Session.__renderer
                if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                    return
                end
                local Count = self:GetGearsCount()
                if Count and Count < 1 then
                    self:SetLoadState("NeedsGears")
                    return
                end
                local WaitUntil = os.clock() + 2
                while Renderer and os.clock() < WaitUntil do
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    if Renderer.__flying and not Renderer.__flight then
                        break
                    end
                    task.wait(0.05)
                end
                if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                    return
                end
                self:SetLoadState("Completing")
                self:BlockInputObject(Session and Session.__input)
                local Sounds = self.SoundsModule
                local Turns = math.max(tonumber(Properties:Get("Turns")) or 1,1) * 360
                if Renderer and typeof(Renderer.SetProgress) == "function" then
                    local Duration = math.clamp(Turns / 1080,1.2,3)
                    local ProgressValue = Instance.new("NumberValue")
                    if Renderer.UI then
                        ProgressValue.Parent = Renderer.UI
                    end
                    local LastProgress = 0
                    local Spun = 0
                    local LastTick = 0
                    local Connection = ProgressValue:GetPropertyChangedSignal("Value"):Connect(function()
                        local Current = ProgressValue.Value
                        local DeltaProgress = Current - LastProgress
                        LastProgress = Current
                        Renderer.SetProgress(Renderer,Current,DeltaProgress * Turns)
                        Spun = Spun + DeltaProgress * Turns
                        if Sounds and math.floor(Spun / 45) > math.floor(LastTick / 45) then
                            LastTick = Spun
                            Sounds:Play("tick")
                        end
                    end)
                    local Tween = TweenService:Create(ProgressValue,TweenInfo.new(Duration,Enum.EasingStyle.Linear),{Value = 1})
                    Tween:Play()
                    while Tween.PlaybackState == Enum.PlaybackState.Playing do
                        if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                            Tween:Cancel()
                            break
                        end
                        task.wait()
                    end
                    Connection:Disconnect()
                    ProgressValue:Destroy()
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    if typeof(Renderer.Spin) == "function" then
                        Renderer.Spin(Renderer)
                    end
                    if Sounds then
                        Sounds:Play("lineConnect")
                    end
                    self.Controller:FireServer(Index,SessionId,"Screwed")
                else
                    task.wait(self:GetDelay())
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    self.Controller:FireServer(Index,SessionId,"Screwed")
                end
            end,
            ["HandleSession"] = function(self,Index,SessionId,Properties)
                if typeof(Properties) ~= "table" then
                    return
                end
                if Properties:Get("FixerUserId") ~= LocalPlayer.UserId then
                    return
                end
                if self.Sessions == nil then
                    return
                end
                local Key = tostring(Index) .. "-" .. tostring(SessionId)
                if self.Sessions[Key] ~= nil then
                    return
                end
                self.Sessions[Key] = os.clock()
                task.spawn(function()
                    while self:IsAlive(Key) and not GetValue("AutoGeneratorPuzzle") do
                        task.wait(0.1)
                    end
                    if not self:IsAlive(Key) then
                        return
                    end
                    local Solver
                    local WaitUntil = os.clock() + 5
                    while not Solver and os.clock() < WaitUntil do
                        local Name
                        if typeof(self.Controller.GetMinigameIndex) == "function" then
                            for i,Value in {"FlowClientMinigame","ConnectClientMinigame","LockClientMinigame","GearClientMinigame"} do
                                if self.Controller:GetMinigameIndex(Value) == Index then
                                    Name = Value
                                    break
                                end
                            end
                        end
                        if Name == "FlowClientMinigame" then
                            Solver = self.SolveFlow
                        elseif Name == "ConnectClientMinigame" then
                            Solver = self.SolveConnect
                        elseif Name == "LockClientMinigame" then
                            Solver = self.SolveLock
                        elseif Name == "GearClientMinigame" then
                            Solver = self.SolveGear
                        end
                        if not Solver then
                            local Pairs = Properties:Get("Pairs")
                            local Blobs = Properties:Get("Blobs")
                            local Config = Properties:Get("Config")
                            local MaxGears = Properties:Get("MaxGears")
                            if typeof(Config) == "table" and typeof(Config.Seed) == "number" then
                                Solver = self.SolveLock
                            elseif typeof(Pairs) == "table" and #Pairs > 0 then
                                Solver = self.SolveFlow
                            elseif typeof(Blobs) == "table" and #Blobs > 0 then
                                Solver = self.SolveConnect
                            elseif typeof(MaxGears) == "number" and MaxGears > 0 then
                                Solver = self.SolveGear
                            end
                        end
                        if not Solver then
                            task.wait(0.05)
                        end
                    end
                    if not Solver or not self:IsAlive(Key) then
                        return
                    end
                    self.Solving = true
                    self:BlockInputs()
                    task.wait(0.35)
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        self.Solving = false
                        self:UnblockInputs()
                        return
                    end
                    Solver(self,Key,Index,SessionId,Properties)
                    self.Solving = false
                    self:UnblockInputs()
                end)
            end,
            ["Install"] = function(self)
                if self.Controller or self.Installing then
                    return false
                end
                if not GetValue("require") then
                    return false
                end
                self.Installing = true
                local ControllerInstance = ReplicatedStorage:FindFirstChild("MinigameController", true)
                if typeof(ControllerInstance) == "Instance" then
                    local Controller = require(ControllerInstance)
                    if typeof(Controller) == "table" and typeof(Controller.RegisterProperties) == "function" and typeof(Controller.UnregisterProperties) == "function" then
                        local LockBoardInstance = ReplicatedStorage:FindFirstChild("LockBoard", true)
                        self.LockBoardModule = LockBoardInstance and require(LockBoardInstance)
                        local SoundsInstance = ReplicatedStorage:FindFirstChild("Rendering", true)
                        SoundsInstance = SoundsInstance and SoundsInstance:FindFirstChild("Sounds")
                        if not (typeof(SoundsInstance) == "Instance" and SoundsInstance:IsA("ModuleScript")) then
                            SoundsInstance = ReplicatedStorage:FindFirstChild("Sounds", true)
                        end
                        if typeof(SoundsInstance) == "Instance" and SoundsInstance:IsA("ModuleScript") then
                            self.SoundsModule = require(SoundsInstance)
                        end
                        self.Sessions = {}
                        local OriginalRegister = Controller.RegisterProperties
                        Controller.RegisterProperties = function(ControllerSelf,Index,SessionId,Properties)
                            OriginalRegister(ControllerSelf,Index,SessionId,Properties)
                            self:HandleSession(Index,SessionId,Properties)
                        end
                        local OriginalUnregister = Controller.UnregisterProperties
                        Controller.UnregisterProperties = function(ControllerSelf,Index,SessionId)
                            if self.Sessions then
                                self.Sessions[tostring(Index) .. "-" .. tostring(SessionId)] = nil
                            end
                            return OriginalUnregister(ControllerSelf,Index,SessionId)
                        end
                        self.Controller = Controller
                        task.spawn(function()
                            task.wait(2)
                            for i,Name in {"FlowClientMinigame","ConnectClientMinigame","LockClientMinigame","GearClientMinigame"} do
                                if typeof(self.Controller.GetMinigame) == "function" then
                                    local Module = self.Controller:GetMinigame(Name)
                                    if Module and typeof(Module.FromSessionId) == "function" then
                                        for SessionId = 1,500 do
                                            if Module:FromSessionId(SessionId) then
                                                local Index
                                                if typeof(self.Controller.GetMinigameIndex) == "function" then
                                                    Index = self.Controller:GetMinigameIndex(Name)
                                                end
                                                if typeof(Index) ~= "number" and typeof(self.Controller.GetSession) == "function" then
                                                    for CheckIndex = 0,40 do
                                                        if self.Controller:GetSession(CheckIndex,SessionId) == Module then
                                                            Index = CheckIndex
                                                            break
                                                        end
                                                    end
                                                end
                                                if typeof(Index) == "number" then
                                                    local Session = Module:FromSessionId(SessionId)
                                                    local Network = Session and Session.Network
                                                    local Properties = Network and Network.Properties
                                                    if Properties then
                                                        self:HandleSession(Index,SessionId,Properties)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end
                self.Installing = false
                return self.Controller ~= nil
            end,
            ["ScriptFunction"] = function(self,Value)
                if Value then
                    task.spawn(function()
                        self:Install()
                    end)
                else
                    self:UnblockInputs(true)
                end
            end,
            ["Requirement"] = "require",
            ["IsPlayersNear"] = function(self,Distance)
                if LocalCharacter and LocalRoot then
                    for i,v in Players:GetPlayers() do
                        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character:FindFirstChild("HumanoidRootPart").Position-LocalRoot.Position).Magnitude < Distance  then
                            return true
                        end
                    end
                end
                return false
            end,
            ["RNG"] = Random.new(),
            ["OnLoop"] = function(self)
                if not GetValue("AutoGeneratorPuzzle") then
                    return
                end
                if self.Controller then
                    local Now = os.clock()
                    if self.Sessions then
                        for Key,At in self.Sessions do
                            if typeof(At) == "number" and Now - At > 600 then
                                self.Sessions[Key] = nil
                            end
                        end
                    end
                    local Active = self.Solving or (self.Sessions ~= nil and next(self.Sessions) ~= nil)
                    if not Active and self.InputBlocked then
                        self:UnblockInputs(true)
                    end
                    if Active then
                        self.OrphanPuzzleAt = nil
                        if Now - (self.ExtraUiAt or 0) > 2 then
                            self.ExtraUiAt = Now
                            local LastPuzzle
                            for i,Ui in PlayerGui:GetChildren() do
                                if Ui.Name == "PuzzleUI" then
                                    LastPuzzle = Ui
                                end
                            end
                            if LastPuzzle then
                                for i,Ui in PlayerGui:GetChildren() do
                                    if Ui.Name == "PuzzleUI" and Ui ~= LastPuzzle then
                                        Ui:Destroy()
                                    end
                                end
                            end
                        end
                    elseif PlayerGui:FindFirstChild("PuzzleUI") then
                        self.OrphanPuzzleAt = self.OrphanPuzzleAt or os.clock()
                        if os.clock() - self.OrphanPuzzleAt > 4 then
                            local AnyLive = true
                            if typeof(self.Controller.GetSession) == "function" then
                                AnyLive = false
                                for CheckIndex = 0,40 do
                                    for CheckId = 1,80 do
                                        if self.Controller:GetSession(CheckIndex,CheckId) then
                                            AnyLive = true
                                            break
                                        end
                                    end
                                    if AnyLive then
                                        break
                                    end
                                end
                            end
                            if AnyLive then
                                self.OrphanPuzzleAt = os.clock()
                            else
                                self.OrphanPuzzleAt = nil
                                for i,Orphan in PlayerGui:GetChildren() do
                                    if Orphan.Name == "PuzzleUI" then
                                        Orphan:Destroy()
                                    end
                                end
                            end
                        end
                    else
                        self.OrphanPuzzleAt = nil
                    end
                    return
                end
                if not self.Installing and os.clock() - (self.InstallAt or 0) >= 3 then
                    self.InstallAt = os.clock()
                    task.spawn(function()
                        self:Install()
                    end)
                end
                if self.UsesNewSystem == nil then
                    self.UsesNewSystem = ReplicatedStorage:FindFirstChild("MinigameController", true) ~= nil
                end
                if not self.UsesNewSystem then
                    self:LegacyLoop()
                end
            end,
            ["CustomSetup"] = function(self)
                task.spawn(function()
                    self:Install()
                end)
                local LoadUI = Instance.new("TextButton")
                local Folder = Instance.new("Folder")
                local Dot1 = Instance.new("TextLabel")
                local TextButton = Instance.new("TextLabel")

                LoadUI.Name = "load"
                LoadUI.BackgroundColor3 = Color3.new(0, 0, 0)
                LoadUI.BackgroundTransparency = 0.4
                LoadUI.BorderSizePixel = 0
                LoadUI.Active = true
                LoadUI.Interactable = true
                LoadUI.AutoButtonColor = false
                LoadUI.Size = UDim2.new(1, 0, 1, 0)
                LoadUI.ZIndex = 25
                LoadUI.Text = ""

                Folder.Parent = LoadUI

                Dot1.Name = "1"
                Dot1.Parent = Folder
                Dot1.AnchorPoint = Vector2.new(0.5, 0)
                Dot1.BackgroundColor3 = Color3.new(1, 1, 1)
                Dot1.BackgroundTransparency = 1
                Dot1.BorderSizePixel = 0
                Dot1.Position = UDim2.new(0.5, 0, -0.05, 0)
                Dot1.Size = UDim2.new(0.1, 0, 1, 0)
                Dot1.ZIndex = 4
                Dot1.Font = Enum.Font.Cartoon
                Dot1.Text = "."
                Dot1.TextColor3 = Color3.new(1, 1, 1)
                Dot1.TextSize = 50
                Dot1.TextScaled = true
                Dot1.TextStrokeTransparency = 0.9

                local Dot2 = Dot1:Clone()
                Dot2.Name = "2"
                Dot2.Parent = Folder

                local Dot3 = Dot1:Clone()
                Dot3.Name = "3"
                Dot3.Parent = Folder

                TextButton.Name = "TextButton"
                TextButton.Parent = LoadUI
                TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
                TextButton.BackgroundTransparency = 1
                TextButton.BorderSizePixel = 0
                TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
                TextButton.Position = UDim2.new(0.5, 0, 0.6, 0)
                TextButton.Selectable = false
                TextButton.Size = UDim2.new(0.4, 0, 0.4, 0)
                TextButton.ZIndex = 7
                TextButton.Font = Enum.Font.SciFi
                TextButton.Text = "Completing"
                TextButton.TextColor3 = Color3.new(1, 1, 1)
                TextButton.TextSize = 20
                TextButton.TextScaled = true
                TextButton.TextStrokeTransparency = 0.9

                PlayerGui.ChildAdded:Connect(function(Child)
                    if Child.Name == "PuzzleUI" then
                        local ClonedLoadUI = LoadUI:Clone()
                        ClonedLoadUI.Parent = Child.Container.GridHolder
                        local InstanceAuto = GetValue("AutoGeneratorPuzzle",true)
                        ClonedLoadUI.Visible = InstanceAuto.Value
                        local ValueConnection = InstanceAuto:GetPropertyChangedSignal("Value"):Connect(function()
                            ClonedLoadUI.Visible = InstanceAuto.Value
                        end)
                        task.spawn(function()
                            while task.wait() and ClonedLoadUI.Parent and Child.Parent do
                                if ClonedLoadUI.Visible then
                                    for i = 1, 3 do
                                        ClonedLoadUI.Folder[i].Rotation = math.cos(tick() + i * 10) * 360
                                    end
                                else
                                    wait(0.1)
                                end
                            end
                            ValueConnection:Disconnect()
                        end)
                    end
                end)
            end
        },
        ["GeneratorCooldown"] = {
            ["DisplayDescription"] = "The cooldown in seconds before completing a generator",
            ["DisplayTitle"] = "Cooldown Between Auto Completions",
            ["LayoutOrder"] = 2,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 4,
            ["Requirement"] = "AutoGeneratorPuzzle",
            ["ExtraData"] = {
                ["MaxValue"] = 8,
                ["MinValue"] = 1.5,
                ["Step"] = 0.25,
                ["CurrentSpeed"] = 0.4,
                ["CurrentGrid"] = 6
            },
            ["IsPlayersNear"] = function(self,Distance)
                if LocalCharacter and LocalRoot then
                    for i,v in Players:GetPlayers() do
                        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character:FindFirstChild("HumanoidRootPart").Position-LocalRoot.Position).Magnitude < Distance  then
                            return true
                        end
                    end
                end
                return false
            end,
            ["OnLoop"] = function(self)
                if os.clock() - (self.LastUpdate or 0) < 0.25 then
                    return
                end
                self.LastUpdate = os.clock()
                local IsNear = self:IsPlayersNear(32)
                local CurrentGrid = self.Instance:GetAttribute("CurrentGrid") or 6
                if not self.RNG then
                    self.RNG = Random.new()
                end
                local GenCD = (not IsNear and GetValue("SpeedUpCooldown") and self.Instance:GetAttribute("MinValue")) or self.RNG:NextNumber(GetValue("GeneratorCooldown") - 0.1 * GetValue("GeneratorCooldown"),GetValue("GeneratorCooldown") + 0.1 * GetValue("GeneratorCooldown"))
                self.Instance:SetAttribute("CurrentSpeed",(GenCD / math.pow(CurrentGrid,2)))
            end
        },
        ["SpeedUpCooldown"] = {
            ["DisplayDescription"] = "Make the cooldown low when nobody is near to look at you",
            ["DisplayTitle"] = "Speed Up When Nobodys Near",
            ["LayoutOrder"] = 3,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "AutoGeneratorPuzzle|GeneratorCooldown~1.5|GeneratorCooldown~1.75|GeneratorCooldown~2"
        },
        ["AutoPickup"] = {
            ["DisplayDescription"] = "Auto-Picks up <b>Items</b> near you",
            ["DisplayTitle"] = "Auto Pickup",
            ["LayoutOrder"] = 4,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["CustomSetup"] = function(self)
                if ReplicatedStorage:FindFirstChild("GearClientMinigame",true) then
                    self.DisplayDescription = "Auto-Picks up <b>Items</b> and <b>Gears</b> near you"
                end
                if InGame then
                    InGame.ChildAdded:Connect(function(Child)
                         if Child:IsA("Tool") then
                            Child:SetAttribute("JustDropped", true)
                            task.delay(1.5, function()
                                if Child then
                                    Child:SetAttribute("JustDropped", nil)
                                end
                            end)
                        end
                    end)
                end
            end
        },
        ["AutoEscape"] = {
            ["DisplayDescription"] = "Auto-Escapes <b>Nosferatu's</b> Hook",
            ["DisplayTitle"] = "Auto Escape",
            ["LayoutOrder"] = 5,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:Nosferatu"
        },
        ["EscapeCooldown"] = {
            ["DisplayDescription"] = "The cooldown in seconds before pressing a key",
            ["DisplayTitle"] = "Cooldown Between Auto Escape Presses",
            ["LayoutOrder"] = 6,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 0.5,
            ["Requirement"] = "Killer:Nosferatu|AutoEscape",
            ["ExtraData"] = {
                ["MaxValue"] = 1.2,
                ["MinValue"] = 0.2,
                ["Step"] = 0.1,
            },
            ["ScriptFunction"] = function(self, Value)
                if Value <= 0.3 then
                    GetValue("EscapeCooldown",true):SetAttribute("DisplayDescription",self["DisplayDescription"] .. " " .. RichTextGradientColor("(TOO FAST)",{Color3.fromRGB(251, 107, 43),Color3.fromRGB(251, 165, 43),Color3.fromRGB(251, 107, 43)}))
                else
                    GetValue("EscapeCooldown",true):SetAttribute("DisplayDescription",self["DisplayDescription"])
                end
            end,
            ["CustomSetup"] = function(self)
                TempUI.ChildAdded:Connect(function(UIElement)
                    if UIElement.Name:upper() == "QTE" and UIElement:FindFirstChildOfClass("UIAspectRatioConstraint") then
                        while UIElement and UIElement.Visible do
                            local Cooldown = GetValue("EscapeCooldown")
                            task.wait(Random.new():NextNumber(Cooldown - 0.2 * Cooldown,Cooldown + 0.2 * Cooldown))
                            if GetValue("AutoEscape") then
                                for i,v in KillersFolder:GetChildren() do
                                    if v.Name:lower() == "nosferatu" then
                                        local Player = Players:GetPlayerFromCharacter(v)
                                        if Player then
                                            Network:FindFirstChildOfClass("RemoteEvent"):FireServer(Player.Name.."NosHookQTE",{true})
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        },
        ["AutoDisarm"] = {
            ["DisplayDescription"] = "Auto-Disarms <b>Azure's</b> Traps Instantly",
            ["DisplayTitle"] = "Auto Disarm",
            ["LayoutOrder"] = 7,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:Azure|require",
            ["HookInstalled"] = false,
            ["ScriptFunction"] = function(self, Value)
                if not Value then
                    return
                end
                if typeof(CurrentQTEAzure) == "table" and typeof(CurrentQTEAzure.AddProgress) == "function" then
                    CurrentQTEAzure:AddProgress(100)
                end
                CurrentQTEAzure = nil
            end,
            ["CustomSetup"] = function(self)
                if typeof(hookfunction) ~= "function" or not GetValue("require") then
                    return
                end
                local Time = workspace.DistributedGameTime
                while not self.HookInstalled and Time < workspace.DistributedGameTime + 5 do
                    local Azure = KillerAssets and (KillerAssets:FindFirstChild("Azure") or KillerAssets:FindFirstChild("!Azure"))
                    local AzureQTE = Azure and Azure:FindFirstChild("cl_ConstructQTE", true)
                    if AzureQTE then
                        local Got, RequiredModule = pcall(require, AzureQTE)
                        if Got and typeof(RequiredModule) == "table" and typeof(RequiredModule.new) == "function" then
                            local OriginalNew
                            OriginalNew = hookfunction(RequiredModule.new, function(selfArg, ...)
                                local QTEAzure = OriginalNew(selfArg, ...)
                                task.delay(0.05, function()
                                    if typeof(QTEAzure) == "table" and typeof(QTEAzure.AddProgress) == "function" then
                                        if GetValue("AutoDisarm") then
                                            QTEAzure:AddProgress(100)
                                        else
                                            CurrentQTEAzure = QTEAzure
                                        end
                                    end
                                end)
                                return QTEAzure
                            end)
                            if typeof(OriginalNew) == "function" then
                                self.HookInstalled = true
                            end
                        end
                    end
                    if not self.HookInstalled then
                        task.wait(0.5)
                    end
                end
            end
        },

        -- =====================================================================
        -- hzayday Forshaken : Advanced Generator Automation & Smart Switcher
        -- =====================================================================
        ["AdvancedAutoRepair"] = {
            ["DisplayDescription"] = "Auto-teleports to real generators, opens & solves the puzzle, and instantly <b>aborts + switches</b> to a safe generator when a Killer approaches or you take damage. Fake/trap generators are blacklisted automatically.",
            ["DisplayTitle"] = '<stroke thickness="0.6">hzayday</stroke> Advanced Auto Repair',
            ["LayoutOrder"] = 30,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["State"] = {
                CurrentTarget  = nil,
                Blacklisted    = {},
                LastSwitch     = 0,
                EmergencyAbort = false,
                HealthConn     = nil,
                HitConn        = nil,
                LastHealth     = nil,
                Processing     = false,
                Enabled        = false,
                LastBlackClean = 0,
            },
            ["FakeAttributes"]   = { "Fake", "IsFake", "Trap", "Decoy", "IsTrap", "Broken", "Disabled", "FakeGenerator", "IsDecoy" },
            ["EssentialChildren"] = { "Main", "Remotes", "BarUI" },

            ["IsFakeGenerator"] = function(self, Generator)
                if not Generator or not Generator.Parent or not Generator:IsA("Model") then return true end
                for _, Attr in ipairs(self.FakeAttributes) do
                    local V = Generator:GetAttribute(Attr)
                    if V == true or (type(V) == "string" and V:lower() ~= "false" and V ~= "") then
                        return true
                    end
                end
                for _, ChildName in ipairs(self.EssentialChildren) do
                    if not Generator:FindFirstChild(ChildName, true) then return true end
                end
                local Remotes = Generator:FindFirstChild("Remotes")
                if not Remotes then return true end
                local Progress = Remotes:FindFirstChild("Progress")
                if not Progress or not Progress:FindFirstChildOfClass("RemoteEvent") then return true end
                local Main = Generator:FindFirstChild("Main")
                if not Main or not Main:IsA("BasePart") then return true end
                if Main.Size.Magnitude < 1 then return true end
                return false
            end,

            ["IsCompleted"] = function(self, Generator)
                if not Generator or not Generator.Parent then return true end
                local BarUI = Generator:FindFirstChild("BarUI", true)
                local Bar   = BarUI and BarUI:FindFirstChild("Bar")
                if not Bar then return false end
                return Bar.Size.X.Scale >= 0.99
            end,

            ["IsKillerNear"] = function(self, Radius)
                if not LocalRoot or not KillersFolder then return false, nil end
                local Closest, ClosestDist = nil, math.huge
                for _, Killer in ipairs(KillersFolder:GetChildren()) do
                    if Killer ~= LocalCharacter and Players:GetPlayerFromCharacter(Killer) then
                        local KR = Killer:FindFirstChild("HumanoidRootPart")
                        local KH = Killer:FindFirstChildOfClass("Humanoid")
                        if KR and KH and KH.Health > 0 then
                            local D = (KR.Position - LocalRoot.Position).Magnitude
                            if D <= Radius and D < ClosestDist then
                                Closest, ClosestDist = Killer, D
                            end
                        end
                    end
                end
                return Closest ~= nil, Closest
            end,

            ["FindSafePosition"] = function(self, DangerPos)
                if not LocalRoot then return nil end
                local Origin       = LocalRoot.Position
                local DangerOrigin = DangerPos and DangerPos.Position or Origin
                local Best, BestScore = nil, -math.huge
                local RP = RaycastParams.new()
                RP.FilterType = Enum.RaycastFilterType.Exclude
                RP.FilterDescendantsInstances = { LocalCharacter }
                if GameMap then
                    local Tried = 0
                    for _, Part in ipairs(GameMap:GetDescendants()) do
                        if Tried >= 80 then break end
                        if Part:IsA("BasePart") and Part.CanCollide and Part.Size.Y < 15 then
                            Tried += 1
                            local Top = Part.Position + Vector3.new(0, Part.Size.Y/2 + 3, 0)
                            local DangerDist = (Top - DangerOrigin).Magnitude
                            if DangerDist > 45 then
                                local Ray = workspace:Raycast(Top, Vector3.new(0, -30, 0), RP)
                                if Ray and Ray.Instance == Part then
                                    local MyDist = (Top - Origin).Magnitude
                                    local Score  = DangerDist - MyDist * 0.35
                                    if Score > BestScore then Best, BestScore = Top, Score end
                                end
                            end
                        end
                    end
                end
                return Best or (Origin + Vector3.new(60, 5, 60))
            end,

            ["TeleportTo"] = function(self, Position)
                if not LocalRoot or not Position or not LocalCharacter then return false end
                local StartPos = LocalRoot.Position
                local Speed    = tonumber(GetValue("AdvancedAutoRepairTeleportSpeed")) or 0.05
                local ok = pcall(function()
                    for i = 1, 6 do
                        if not LocalRoot or not LocalRoot.Parent then return end
                        LocalRoot.CFrame = CFrame.new(StartPos:Lerp(Position, i/6))
                        LocalRoot.Velocity = Vector3.zero
                        task.wait(Speed)
                    end
                end)
                return ok
            end,

            ["FireInteraction"] = function(self, Generator)
                if not Generator or not Generator.Parent then return false end
                local Prompt = Generator:FindFirstChildWhichIsA("ProximityPrompt", true)
                if Prompt and Prompt.Enabled then
                    pcall(function() fireproximityprompt(Prompt) end)
                    return true
                end
                local Remotes = Generator:FindFirstChild("Remotes")
                if Remotes then
                    for _, R in ipairs(Remotes:GetDescendants()) do
                        if R:IsA("RemoteEvent") and R.Name:lower():find("start") then
                            pcall(function() R:FireServer() end)
                            return true
                        end
                    end
                    local Progress = Remotes:FindFirstChild("Progress")
                    if Progress then
                        local RE = Progress:FindFirstChildOfClass("RemoteEvent")
                        if RE then pcall(function() RE:FireServer() end) return true end
                    end
                end
                return false
            end,

            ["AbortAndSwitch"] = function(self, Reason)
                self.State.EmergencyAbort = false
                self.State.LastSwitch     = os.clock()

                local AGP = FeatureLoadout["Automation"]["AutoGeneratorPuzzle"]
                if AGP and AGP.Solving then
                    AGP.Solving = false
                    if AGP.UnblockInputs then pcall(AGP.UnblockInputs, AGP, true) end
                end

                if PlayerGui then
                    local PuzzleUI = PlayerGui:FindFirstChild("PuzzleUI")
                    if PuzzleUI then
                        local Close = PuzzleUI:FindFirstChild("Close", true)
                        if Close and Close:IsA("TextButton") then
                            pcall(function() Close:Click() end)
                        end
                    end
                end

                local near, Killer = self:IsKillerNear(60)
                if near and LocalRoot then
                    local KR = Killer and Killer:FindFirstChild("HumanoidRootPart")
                    local Safe = self:FindSafePosition(KR)
                    if Safe then self:TeleportTo(Safe) end
                end

                self.State.CurrentTarget = nil
            end,

            ["ScoreGenerator"] = function(self, Gen, DangerPart)
                if not Gen or not Gen:FindFirstChild("Main") then return -math.huge end
                local Main    = Gen:FindFirstChild("Main")
                local MyD     = LocalRoot and (Main.Position - LocalRoot.Position).Magnitude or 999
                local DangerD = DangerPart and (Main.Position - DangerPart.Position).Magnitude or 999
                return DangerD * 0.7 - MyD * 0.3
            end,

            ["GetBestGenerator"] = function(self)
                if not GameMap or not LocalRoot then return nil end
                local Radius = tonumber(GetValue("AdvancedAutoRepairRange")) or 300
                local near, Killer = self:IsKillerNear(80)
                local KillerPart   = Killer and Killer:FindFirstChild("HumanoidRootPart")
                local Best, BestScore = nil, -math.huge
                for _, Gen in ipairs(GameMap:QueryDescendants("Model#Generator:has(#Main)")) do
                    if Gen:FindFirstChild("Main")
                        and not self.State.Blacklisted[Gen]
                        and not self:IsCompleted(Gen)
                        and not self:IsFakeGenerator(Gen)
                    then
                        local MyD = (Gen.Main.Position - LocalRoot.Position).Magnitude
                        if MyD <= Radius then
                            local S = self:ScoreGenerator(Gen, KillerPart)
                            if S > BestScore then Best, BestScore = Gen, S end
                        end
                    end
                end
                return Best
            end,

            ["SetupConnections"] = function(self)
                if self.State.HealthConn then pcall(function() self.State.HealthConn:Disconnect() end) end
                if self.State.HitConn    then pcall(function() self.State.HitConn:Disconnect()    end) end
                self.State.HealthConn, self.State.HitConn = nil, nil

                if LocalHumanoid then
                    self.State.LastHealth = LocalHumanoid.Health
                    self.State.HealthConn = LocalHumanoid.HealthChanged:Connect(function(NewHealth)
                        if not GetValue("AdvancedAutoRepair") then return end
                        if LocalHumanoid.Health <= 0 then return end
                        local Threshold = (tonumber(GetValue("AdvancedAutoRepairHealth")) or 90) / 100
                        local MaxHealth = LocalHumanoid.MaxHealth
                        if NewHealth < self.State.LastHealth and NewHealth <= MaxHealth * Threshold then
                            self.State.EmergencyAbort = true
                        end
                        self.State.LastHealth = NewHealth
                    end)
                end

                if LocalCharacter then
                    self.State.HitConn = LocalCharacter:GetAttributeChangedSignal("TimesHit"):Connect(function()
                        if GetValue("AdvancedAutoRepair") and LocalHumanoid and LocalHumanoid.Health > 0 then
                            self.State.EmergencyAbort = true
                        end
                    end)
                end
            end,

            ["ScriptFunction"] = function(self, Value)
                self.State.Enabled = Value
                if Value then
                    self:SetupConnections()
                else
                    if self.State.HealthConn then pcall(function() self.State.HealthConn:Disconnect() end) self.State.HealthConn = nil end
                    if self.State.HitConn    then pcall(function() self.State.HitConn:Disconnect()    end) self.State.HitConn    = nil end
                    self.State.CurrentTarget = nil
                    self.State.EmergencyAbort = false
                end
            end,

            ["CharacterAdded"] = function(self)
                if self.State.HealthConn then pcall(function() self.State.HealthConn:Disconnect() end) self.State.HealthConn = nil end
                if self.State.HitConn    then pcall(function() self.State.HitConn:Disconnect()    end) self.State.HitConn    = nil end
                self.State.CurrentTarget  = nil
                self.State.LastSwitch     = 0
                self.State.EmergencyAbort = false
                self.State.Blacklisted    = {}
                if GetValue("AdvancedAutoRepair") then
                    task.wait(0.5)
                    self:SetupConnections()
                end
            end,

            ["OnLoop"] = function(self)
                if not GetValue("AdvancedAutoRepair") then return end
                if not LocalCharacter or not LocalRoot or not LocalHumanoid then return end
                if LocalHumanoid.Health <= 0 then return end
                if not GameMap then return end
                if self.State.Processing then return end
                if os.clock() - (self.State.LastSwitch or 0) < 0.75 then return end

                if LocalCharacter.Parent and LocalCharacter.Parent.Name == "Killers" then return end

                if os.clock() - (self.State.LastBlackClean or 0) > 5 then
                    self.State.LastBlackClean = os.clock()
                    for Gen in pairs(self.State.Blacklisted) do
                        if not Gen or not Gen.Parent then
                            self.State.Blacklisted[Gen] = nil
                        end
                    end
                end

                if self.State.EmergencyAbort then
                    self:AbortAndSwitch("Damage")
                    return
                end

                local KR = tonumber(GetValue("AdvancedAutoRepairKillerRadius")) or 40
                if self:IsKillerNear(KR) and self.State.CurrentTarget then
                    self:AbortAndSwitch("Killer")
                    return
                end

                if self.State.CurrentTarget then
                    if not self.State.CurrentTarget.Parent then
                        self.State.CurrentTarget = nil
                    elseif self:IsCompleted(self.State.CurrentTarget) then
                        self.State.CurrentTarget = nil
                    elseif self:IsFakeGenerator(self.State.CurrentTarget) then
                        self.State.Blacklisted[self.State.CurrentTarget] = true
                        self.State.CurrentTarget = nil
                    else
                        return
                    end
                end

                self.State.Processing = true
                local Gen = self:GetBestGenerator()
                self.State.Processing = false
                if not Gen then return end

                self.State.CurrentTarget = Gen
                local Main = Gen:FindFirstChild("Main")
                if not Main then self.State.CurrentTarget = nil return end

                local TargetPos = Main.Position + Vector3.new(0, 3, 0)
                if (LocalRoot.Position - TargetPos).Magnitude > 6.5 then
                    self:TeleportTo(TargetPos)
                end
                task.wait(0.15)

                if self:IsKillerNear(KR) then
                    self:AbortAndSwitch("Killer")
                    return
                end

                self:FireInteraction(Gen)
                task.wait(0.1)
                self.State.LastSwitch = os.clock()
            end,

            ["CustomSetup"] = function(self)
                self.DisplayTitle = self.DisplayTitle:gsub("hzayday",
                    RichTextGradientColor("hzayday",
                        { Color3.fromRGB(0, 255, 200), Color3.fromRGB(0, 130, 255) }))
            end,
        },

        ["AdvancedAutoRepairKillerRadius"] = {
            ["DisplayDescription"] = "Distance (studs) that triggers an instant <b>safe switch</b> when a killer enters.",
            ["DisplayTitle"] = "Killer Detection Radius",
            ["LayoutOrder"] = 31,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 40,
            ["Requirement"] = "AdvancedAutoRepair",
            ["ExtraData"] = { ["MaxValue"] = 100, ["MinValue"] = 15, ["Step"] = 5 },
        },

        ["AdvancedAutoRepairHealth"] = {
            ["DisplayDescription"] = "If your health % falls to or below this value after taking damage, abort & switch.",
            ["DisplayTitle"] = "Health Threshold (%)",
            ["LayoutOrder"] = 32,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 90,
            ["Requirement"] = "AdvancedAutoRepair",
            ["ExtraData"] = { ["MaxValue"] = 100, ["MinValue"] = 10, ["Step"] = 5 },
        },

        ["AdvancedAutoRepairRange"] = {
            ["DisplayDescription"] = "Maximum search radius for generator targets.",
            ["DisplayTitle"] = "Max Search Radius",
            ["LayoutOrder"] = 33,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 300,
            ["Requirement"] = "AdvancedAutoRepair",
            ["ExtraData"] = { ["MaxValue"] = 1000, ["MinValue"] = 50, ["Step"] = 25 },
        },

        ["AdvancedAutoRepairTeleportSpeed"] = {
            ["DisplayDescription"] = "Delay per teleport step (smaller = smoother, larger = faster).",
            ["DisplayTitle"] = "Teleport Step Delay",
            ["LayoutOrder"] = 34,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 0.05,
            ["Requirement"] = "AdvancedAutoRepair",
            ["ExtraData"] = { ["MaxValue"] = 0.2, ["MinValue"] = 0.01, ["Step"] = 0.01 },
        },
    },

    ["Features"] = {
        ["TabAttributes"] = {
            ["DisplayTitle"] = "Features",
            ["LayoutOrder"] = 3
        },
        ["Invincible"] = {
            ["DisplayDescription"] = "Makes you invisible & god mode (you can still use abilities)",
            ["DisplayTitle"] = "Invincible",
            ["LayoutOrder"] = 1,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = true,
            ["ScriptFunction"] = function(self, Value)
                if workspace:GetAttribute("Invincible") == nil then
                    workspace:SetAttribute("Invincible", Value)
                    self.Instance.Value = Value
                    if Value then
                        GetValue("DisableToxicTrails",true).Value = true
                        GetValue("DisableFootprints",true).Value = true
                    end
                    task.delay(1.5, function()
                        workspace:SetAttribute("Invincible",nil)
                    end)
                    self:GoUnder(Value)
                else
                    self.Instance.Value = workspace:GetAttribute("Invincible")
                end
            end,
            ["IsHitboxNotNear"] = function(self,HitboxPart,Position)
                if HitboxPart and Position and LocalRoot then
                    local IsHitboxNotNearParams = OverlapParams.new()
                    IsHitboxNotNearParams.FilterType = Enum.RaycastFilterType.Include
                    IsHitboxNotNearParams.MaxParts = 1
                    IsHitboxNotNearParams.FilterDescendantsInstances = {HitboxPart}
                    local Result = workspace:GetPartBoundsInRadius(Position, 2.5, IsHitboxNotNearParams)
                    return #Result == 0
                else
                    ColoredPrint("HitboxPart/Position/HumanoidRootPart is nil while trying to check if near", "info", Color3.new(1,0.25,0))
                    return false
                end
            end,
            ["VelocityToPosition"] = function(self,target)
                local TimeLimit = workspace.DistributedGameTime + 7
                local OGCG = LocalRoot.CollisionGroup
                local AllParts = LocalCharacter:QueryDescendants("BasePart:not([CollisonGroup=Default])")
                for i,v in AllParts do
                    v.CollisionGroup = "None"
                end
                local Body = Instance.new("BodyVelocity")
                Body.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                Body.Velocity = Vector3.new(0, 0, 0)
                Body.Parent = LocalRoot
                while (LocalRoot.Position - target).Magnitude > 2 and not (workspace.DistributedGameTime >= TimeLimit) do
                    Body.Velocity = (target - LocalRoot.Position).Unit * 100
                    RunService.RenderStepped:Wait()
                end
                if workspace.DistributedGameTime >= TimeLimit then
                    warn("Failed to do in time")
                end
                Body:Destroy()
                for i,v in AllParts do
                    v.CollisionGroup = OGCG
                end
            end,
            ["GoUnder"] = function(self,Value)
                local Offset = 22
                if Value == nil then
                    IsUnderground = false
                    Value = GetValue("Invincible")
                end
                if Value and not SideBar:GetAttribute("WasVisible") and not IsUnderground then
                    IsUnderground = false
                    if not (LocalRoot and LocalHead and LocalHumanoid and MainUI.Enabled) then
                        repeat task.wait(0.25) until (LocalRoot and LocalHead and LocalHumanoid and MainUI.Enabled)
                    end
                    local MapName
                    if GameMap and GameMap:FindFirstChild("Config") and GetValue("require") then
                        local MapData = require(GameMap:FindFirstChild("Config"))
                        if MapData and MapData["DisplayName"] ~= nil then
                            MapName = MapData["DisplayName"]
                        end
                    end
                    local OldCFrame:CFrame = LocalRoot.CFrame
                    local UnderCFrame
                    if MapName == "Underground War" then
                        local SelfParams = OverlapParams.new()
                        SelfParams.FilterType = Enum.RaycastFilterType.Include
                        SelfParams.MaxParts = 1
                        SelfParams.FilterDescendantsInstances = {LocalRoot}
                        local BoxCheck = workspace:GetPartBoundsInBox(CFrame.new(-172,4444,-20,1,0,0,0,1,0,0,0,1),Vector3.new(230, 35, 300),SelfParams)
                        if #BoxCheck > 0 then
                            Offset = 50
                        end
                        local MapPart = GameMap:FindFirstChild("DirtSlabs",true) and GameMap:FindFirstChild("DirtSlabs",true):FindFirstChildWhichIsA("BasePart")
                        if MapPart then
                            UnderCFrame = CFrame.new(Vector3.new(OldCFrame.X + 0.5,MapPart.Position.Y - 7.5,OldCFrame.Z + 0.5))
                        else
                            UnderCFrame = OldCFrame * CFrame.new(0, -Offset, 0)
                        end
                    else
                        UnderCFrame = OldCFrame * CFrame.new(0, -Offset, 0)
                    end
                    LocalHumanoid.CameraOffset = Vector3.new(0, 12e12 ,0)
                    task.wait(0.1)
                    LocalRoot.CFrame = UnderCFrame
                    local Tries = 0
                    local TimerStop = workspace.DistributedGameTime + 3.5
                    repeat
                        Tries += 1
                        LocalRoot.Velocity = Vector3.zero
                        self:VelocityToPosition(UnderCFrame.Position)
                        LocalHead.Anchored = true
                        repeat task.wait() until self:IsHitboxNotNear(LocalCharacter:FindFirstChild("QueryHitbox"),OldCFrame.Position) or not LocalRoot or not LocalCharacter or TimerStop < workspace.DistributedGameTime
                        IsUnderground = true
                        task.wait()
                        LocalRoot.Velocity = Vector3.zero
                        LocalHead.Anchored = false
                        LocalRoot.CFrame = OldCFrame
                        RunService.Heartbeat:Wait()
                        LocalRoot.Velocity = Vector3.zero
                    until self:IsHitboxNotNear(LocalCharacter:FindFirstChild("QueryHitbox"),OldCFrame.Position) or Tries >= 3
                    if Tries >= 3 then
                        IsUnderground = false
                        workspace:SetAttribute("Invincible",nil)
                        GetValue("Invincible",true).Value = false
                        if GetValue("OfficialGame") then
                            StarterGui:SetCore("SendNotification",{
                                Title = "Fail",  Text = "Failed to become invincible, if this keeps happning please report this in the discord server",
                                Icon = "rbxasset://textures/DevConsole/Warning.png", Duration = 4.5
                            })
                        else
                            StarterGui:SetCore("SendNotification",{
                                Title = "Fail", Text = "Failed to become invincible, this feature is not supported here",
                                Icon = "rbxasset://textures/DevConsole/Warning.png", Duration = 4.5
                            })
                            GetValue("Invincible",true):SetAttribute("Requirement", true)
                        end
                        return ColoredPrint("Failed to go invincible! Tried 3 Times and still failed.", "info", Color3.new(1,0.25,0))
                    end
                else
                    IsUnderground = false
                end
            end,
            ["CharacterAdded"] = function(self)
                task.delay(1,self.GoUnder,self)
                if not LocalRoot then
                    repeat task.wait() until LocalRoot
                end
                LocalRoot:GetPropertyChangedSignal("Anchored"):Connect(function()
                    if not LocalRoot.Anchored then
                        task.delay(0.75,self.GoUnder,self)
                    end
                end)
            end,
        },
        ["DisableKillerWalls"] = {
            ["DisplayDescription"] = "Disables Thin Killer Walls",
            ["DisplayTitle"] = "Disable Killer Walls",
            ["LayoutOrder"] = 2,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["GetNearbyWalls"] = function(self, Selected)
                if not Selected or not GameMap then return {} end
                local Params = OverlapParams.new()
                Params.BruteForceAllSlow = true
                Params.IncludeInstances = {GameMap}
                local BoxSize = Selected.Size
                local Result = workspace:GetPartBoundsInBox(Selected.CFrame,Selected.Size,Params)
                local Walls = {}
                for i, v in Result do
                    if not(v == Selected or v.Parent.Name:find("Decoration") or v.CollisionGroup ~= "Killers" or v.Name:lower() == "inviisble") then
                        Walls[#Walls + 1] = v
                    end
                end
                return Walls
            end,
            ["GetNearbyDecoration"] = function(self, Selected)
                if not Selected or not GameMap or Selected.Name:lower() == "inviisble" then return {} end
                local Params = OverlapParams.new()
                Params.BruteForceAllSlow = true
                Params.IncludeInstances = GameMap:QueryDescendants("#KillerWallDetail,#KillerFrame")
                local Result = workspace:GetPartBoundsInBox(Selected.CFrame,Selected.Size,Params)
                local Decorations = {}
                for i, v in Result do
                    local MainDecoration = v:FindFirstAncestor("KillerWallDetail") or v:FindFirstAncestor("KillerFrame")
                    if MainDecoration and not table.find(Decorations, MainDecoration) then
                        table.insert(Decorations, MainDecoration)
                    end
                end
                return Decorations
            end,
            ["DefaultProperty"] = function(self,Object,Property)
                if not Object then return end
                if not Object:GetAttribute(Property) then
                    Object:SetAttribute(Property,Object[Property])
                end
            end,
            ["HandleDisableKillerWalls"] = function(self,MainValue,Tween)
                local function ColorBrightness(Color,Brightness)
                    local H, S, V = Color:ToHSV()
                    return Color3.fromHSV(H, S, math.clamp(V * Brightness, 0, 1))
                end
                if GameMap then
                    for i,v in GameMap:QueryDescendants("BasePart[CollisionGroup=Killers]") do
                        if math.min(v.Size.X,v.Size.Z) > 5 or (v.Size.Magnitude > 95 and #self:GetNearbyWalls(v) == 0) or v.Parent.Name:upper() == "GENERATOR" then continue end
                        self:DefaultProperty(v,"CanCollide")
                        self:DefaultProperty(v,"Color")
                        if not v:GetAttribute("WalkedThrough") then
                            v.CanTouch = true
                        end
                        local Value = not v:GetAttribute("WalkedThrough") and MainValue or false
                        local Color = Value and Color3.new(0,1,0) or v:GetAttribute("Color") or Color3.new(1,0,0)
                        local Mesh = v:FindFirstChildOfClass("SpecialMesh")
                        local NearbyDecorations = self:GetNearbyDecoration(v)
                        self:DefaultProperty(Mesh,"VertexColor")
                        local VertexColor = Value and Vector3.new(0,Mesh and Mesh.VertexColor.Magnitude or 255,0) or Mesh and Mesh:GetAttribute("VertexColor") or Vector3.new(255,0,0)
                        v.CanCollide = v:GetAttribute("CanCollide") ~= false and not Value or false
                        v.Color = Color
                        if Mesh then
                            Mesh.VertexColor = VertexColor
                        end
                        for i,SelectionBox:SelectionBox in v:QueryDescendants("> SelectionBox") do
                            self:DefaultProperty(SelectionBox,"Color3")
                            self:DefaultProperty(SelectionBox,"SurfaceColor3")
                            SelectionBox.Color3 = Value and Color or SelectionBox:GetAttribute("Color3")
                            SelectionBox.SurfaceColor3 = Value and Color or SelectionBox:GetAttribute("SurfaceColor3")
                        end
                        for i,v in NearbyDecorations do
                            for i,v2 in v:QueryDescendants("Texture") do
                                self:DefaultProperty(v2,"Color3")
                                v2.Color3 = Value and Color3.new(0,0,0) or v2:GetAttribute("Color3")
                            end
                            for i,v2 in v:QueryDescendants("ParticleEmitter") do
                                self:DefaultProperty(v2,"Color")
                                local H,S,V = v2.Color.Keypoints[1].Value:ToHSV()
                                v2.Color = (Value and ColorSequence.new(Color3.fromHSV(0.33, 1, V))) or v2:GetAttribute("Color")
                            end
                            if v:FindFirstChildOfClass("MeshPart") then
                                self:DefaultProperty(v:FindFirstChildOfClass("MeshPart"),"Color")
                                v:FindFirstChildOfClass("MeshPart").Color = Value and Color or v:FindFirstChildOfClass("MeshPart"):GetAttribute("Color")
                            end
                        end
                    end
                end
            end,
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then
                    if GetValue("PrivateServer") then
                        self.Instance:SetAttribute("DisplayDescription",self.Instance:GetAttribute("DisplayDescription"):gsub("%s?<b>.-</b>", ""))
                    end
                end
                self:HandleDisableKillerWalls(Value)
            end,
            ["CharacterAdded"] = function(self)
                LocalRoot.CanTouch = true
                LocalRoot.Touched:Connect(function(Hit)
                    if Hit and Hit.Parent and Hit.CollisionGroup == "Killers" and Hit:IsDescendantOf(GameMap) and Hit.Name:lower() ~= "inviisble" and Hit:GetAttribute("WalkedThrough") == nil and Hit.CanQuery and Hit.Parent.Name:upper() ~= "GENERATOR" and GetValue("DisableKillerWalls") then
                        Hit:SetAttribute("WalkedThrough","Ignore")
                        local NearbyWalls = self:GetNearbyWalls(Hit)
                        for i,v in NearbyWalls do
                            v:SetAttribute("WalkedThrough","Ignore")
                        end
                        task.delay(0.3,function()
                            if Hit and Hit.Parent then
                                Hit:SetAttribute("WalkedThrough",true)
                                for i,v in NearbyWalls do
                                    v:SetAttribute("WalkedThrough",true)
                                end
                                task.wait()
                                self:HandleDisableKillerWalls(GetValue("DisableKillerWalls"),true)
                            end
                        end)
                        task.delay(4.5,function()
                            if Hit and Hit.Parent then
                                Hit:SetAttribute("WalkedThrough",nil)
                                for i,v in NearbyWalls do
                                    v:SetAttribute("WalkedThrough",nil)
                                end
                                task.wait()
                                self:HandleDisableKillerWalls(GetValue("DisableKillerWalls"),true)
                            end
                        end)
                    end
                end)
            end,
            ["CustomSetup"] = function(self)
                InGame.ChildAdded:Connect(function(Child)
                    if Child.Name == "Map" then
                        task.delay(2,self.HandleDisableKillerWalls,self,GetValue("DisableKillerWalls"))
                    end
                end)
            end
        },
        ["DisableToxicTrails"] = {
            ["DisplayDescription"] = "Disables damaging trails for john doe",
            ["DisplayTitle"] = "Disable <b>John Doe's</b> Trails",
            ["LayoutOrder"] = 3,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:JohnDoe",
            ["ScriptFunction"] = function(self, Value)
                for i,v in InGame:GetChildren() do
                    if v:IsA("Folder") and (v.Name):find("JohnDoeTrail") then
                        for i,v2 in v:GetChildren() do
                            if v2:IsA("BasePart") then
                                v2.CanTouch = not Value
                            end
                        end
                    end
                end
            end,
            ["CustomSetup"] = function(self)
                if InGame then
                    InGame.ChildAdded:Connect(function(Child)
                        if Child:IsA("Folder") and (Child.Name):find("JohnDoeTrail") then
                            task.wait()
                            for i,v in Child:GetChildren() do
                                if v:IsA("BasePart") then
                                    v.CanTouch = not GetValue("DisableToxicTrails")
                                end
                            end
                            if not Child:GetAttribute("Checked") then
                                Child:SetAttribute("Checked", true)
                                Child.ChildAdded:Connect(function(v)
                                    if v:IsA("BasePart") then
                                        v.CanTouch = not GetValue("DisableToxicTrails")
                                    end
                                end)
                            end
                        end
                    end)
                end
            end
        },
        ["DisableFootprints"] = {
            ["DisplayDescription"] = "Disables footprints made by john doe",
            ["DisplayTitle"] = "Disable <b>John Doe's</b> Footprints",
            ["LayoutOrder"] = 4,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:JohnDoe",
            ["ScriptFunction"] = function(self, Value)
                for i,v in InGame:GetChildren() do
                    if v:IsA("Folder") and (v.Name):find("Shadows") then
                        for i,v2 in v:GetChildren() do
                            if v2:IsA("BasePart") then
                                v2.CanTouch = not Value
                            end
                        end
                        if not v:GetAttribute("Checked") then
                            v:SetAttribute("Checked", true)
                            v.ChildAdded:Connect(function(GrandChild)
                                if GrandChild:IsA("BasePart") then
                                    GrandChild.CanTouch = not GetValue("DisableFootprints")
                                end
                            end)
                        end
                    end
                end
            end,
            ["CustomSetup"] = function(self)
                if InGame then
                    InGame.ChildAdded:Connect(function(Child)
                        if Child:IsA("Folder") and (Child.Name):find("Shadows") then
                            task.wait()
                            for i,v in Child:GetChildren() do
                                if v:IsA("BasePart") then
                                    v.CanTouch = not GetValue("DisableFootprints")
                                end
                            end
                            if not Child:GetAttribute("Checked") then
                                Child:SetAttribute("Checked", true)
                                Child.ChildAdded:Connect(function(v)
                                    if v:IsA("BasePart") then
                                        v.CanTouch = not GetValue("DisableFootprints")
                                    end
                                end)
                            end
                        end
                    end)
                end
            end
        },
        ["SmallerSpikeCollisions"] = {
            ["DisplayDescription"] = "Makes spike collisions smaller for john doe's ability",
            ["DisplayTitle"] = "Smaller Spike Collisions",
            ["LayoutOrder"] = 5,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:JohnDoe",
            ["ScriptFunction"] = function(self, Value)
                for i,v in InGame:GetChildren() do
                    if v.Name == "SpikeCollision" then
                        v.Size = Value and Vector3.new(11,3.5,3.5) or Vector3.new(11, 5, 5)
                        v.Shape = Value and Enum.PartType.Cylinder or Enum.PartType.Block
                    end
                end
            end,
            ["CustomSetup"] = function(self)
                if InGame then
                    InGame.ChildAdded:Connect(function(Child)
                        if Child.Name == "SpikeCollision" then
                            task.delay(3.5,function()
                                Child.Size = GetValue("SmallerSpikeCollisions") and Vector3.new(11,3.5,3.5) or Vector3.new(11, 5, 5)
                                Child.Shape = GetValue("SmallerSpikeCollisions") and Enum.PartType.Cylinder or Enum.PartType.Block
                            end)
                        end
                    end)
                end
            end
        },
        ["EnableJumping"] = {
            ["DisplayDescription"] = "Enables Jumping for when its disabled",
            ["DisplayTitle"] = "Enable Jumping",
            ["LayoutOrder"] = 7,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["HandleAllowJumping"] = function(self,Value)
                if LocalHumanoid and not LocalHumanoid:GetAttribute("JumpingConnection") then
                    if Value then
                        if not LocalHumanoid:GetAttribute("JumpingConnection") then
                            LocalHumanoid:SetAttribute("JumpingConnection",LocalHumanoid.JumpPower)
                        else
                            return
                        end
                        local Connection;Connection = LocalHumanoid.StateChanged:Connect(function(old,new)
                            if LocalHumanoid.FloorMaterial == Enum.Material.Air then
                                return
                            end
                            if not LocalCharacter.Parent.Name:lower():find("spectat") and new == Enum.HumanoidStateType.Jumping or new == Enum.HumanoidStateType.Freefall and LocalHumanoid.JumpPower > 0 and (GetValue("EnableJumping") or false) and not LocalHumanoid:GetAttribute("CDJump") then
                                if not(GetValue("EnableJumping")) then
                                    Connection:Disconnect()
                                    LocalHumanoid.JumpPower = LocalHumanoid:GetAttribute("JumpingConnection") or 0
                                    LocalHumanoid:SetAttribute("JumpingConnection",nil)
                                    return
                                end
                                LocalHumanoid:GetPropertyChangedSignal("FloorMaterial"):Wait()
                                if LocalHumanoid.FloorMaterial == Enum.Material.Air then
                                    LocalHumanoid.JumpPower = 0
                                else
                                    return
                                end
                                LocalHumanoid:SetAttribute("CDJump",true)
                                task.wait(1.25)
                                if GetValue("EnableJumping") then
                                    LocalHumanoid.JumpPower = 47
                                else
                                    Connection:Disconnect()
                                    LocalHumanoid.JumpPower = LocalHumanoid:GetAttribute("JumpingConnection") or 0
                                    LocalHumanoid:SetAttribute("JumpingConnection",nil)
                                end
                                LocalHumanoid:SetAttribute("CDJump",nil)
                            end
                        end)
                    end
                    LocalHumanoid.JumpPower = Value and 47 or 0
                end
            end,
            ["ScriptFunction"] = function(self, Value)
                self:HandleAllowJumping(Value)
            end,
            ["CharacterAdded"] = function(self)
                task.delay(0.25,self.HandleAllowJumping,self,GetValue("EnableJumping"))
            end
        },
        ["StaminaPreset"] = {
            ["DisplayDescription"] = "Select a Stamina Preset",
            ["DisplayTitle"] = "Stamina Preset",
            ["LayoutOrder"] = 8,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Original",
            ["Requirement"] = "require",
            ["ExtraData"] = {
                ["Options"] = "Original|Realistic|Semi-Realistic|Infinite"
            },
            ["OnLoop"] = function()
                local StaminaPreset = GetValue("StaminaPreset")
                if StaminaPreset ~= "Original" and MainModule and MainModule.MaxStamina then
                    if StaminaPreset == "Infinite" then
                        rawset(MainModule, "Stamina", MainModule.MaxStamina)
                    else
                        local MaxStamina = MainModule.MaxStamina
                        if MainModule.Stamina < MaxStamina * 0.8 then
                            rawset(MainModule, "Stamina", math.min(MainModule.Stamina + MaxStamina * (StaminaPreset == "Semi-Realistic" and 0.005 or 0.0025), MaxStamina))
                        end
                    end
                end
            end,
            ["CharacterAdded"] = function(self)
                if TempUI then
                    task.spawn(function()
                        local AmountUI = (TempUI:FindFirstChild("PlayerInfo") or TempUI:WaitForChild("PlayerInfo")) and TempUI.PlayerInfo:FindFirstChild("Bars") and TempUI.PlayerInfo.Bars:FindFirstChild("Stamina") and TempUI.PlayerInfo.Bars.Stamina:FindFirstChild("Amount")
                        if AmountUI and MainModule then
                            local OriginalAmountUI = AmountUI
                            local InfiniteStaminaElement = OriginalAmountUI:Clone()
                            local CenterStaminaCounter = TempUI:FindFirstChild("CenterStaminaCounter")
                            local CenterDrainBar = TempUI:FindFirstChild("Drain")
                            if CenterStaminaCounter then
                                CenterStaminaCounter:SetAttribute("WasVisible", CenterStaminaCounter.Visible)
                                CenterStaminaCounter.Visible = GetValue("StaminaPreset") ~= "Infinite" and CenterStaminaCounter:GetAttribute("WasVisible")
                            end
                            if CenterDrainBar then
                                CenterDrainBar:SetAttribute("WasVisible", CenterDrainBar.Visible)
                                CenterDrainBar.Visible = GetValue("StaminaPreset") ~= "Infinite" and CenterDrainBar:GetAttribute("WasVisible")
                            end
                            InfiniteStaminaElement.Name = "InfiniteAmount"
                            InfiniteStaminaElement.Text = "∞"
                            InfiniteStaminaElement.Parent = OriginalAmountUI.Parent
                            InfiniteStaminaElement.Visible = GetValue("StaminaPreset") == "Infinite"
                            InfiniteStaminaElement.Size = UDim2.new(0.225,0,0.7,14)
                            OriginalAmountUI.Visible = GetValue("StaminaPreset") ~= "Infinite"
                            if not GetValue("StaminaPreset",true) then return end
                            local InfViewConnection;InfViewConnection = GetValue("StaminaPreset",true):GetPropertyChangedSignal("Value"):Connect(function()
                                if InfiniteStaminaElement and OriginalAmountUI then
                                    InfiniteStaminaElement.Visible = GetValue("StaminaPreset") == "Infinite"
                                    OriginalAmountUI.Visible = GetValue("StaminaPreset") ~= "Infinite"
                                    if CenterStaminaCounter then
                                        CenterStaminaCounter.Visible = GetValue("StaminaPreset") ~= "Infinite" and CenterStaminaCounter:GetAttribute("WasVisible")
                                    end
                                    if CenterDrainBar then
                                        CenterDrainBar.Visible = GetValue("StaminaPreset") ~= "Infinite" and CenterDrainBar:GetAttribute("WasVisible")
                                    end
                                else
                                    InfViewConnection:Disconnect()
                                end
                            end)
                            TempUI.Destroying:Once(function()
                                InfViewConnection:Disconnect()
                            end)
                        end
                    end)
                    for i,v in TempUI:QueryDescendants("#redFlash,#injuredVignette") do
                        v.Visible = not GetValue("HideInjury")
                    end
                end
            end
        },
        ["AntiSlowness"] = {
            ["DisplayDescription"] = "Removes all types of Slowness Effects",
            ["DisplayTitle"] = "Anti Slowness",
            ["LayoutOrder"] = 9,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Check"] = function(self,ValueInstance)
                if GetValue("AntiSlowness") then
                    if ValueInstance and ValueInstance.Name ~= "Sprinting" and ValueInstance.Name:lower() ~= "emoting" then
                        if ValueInstance.Name == "DirectionalMovement" or ValueInstance.Name == "FixingGenerator" or ValueInstance.Name:upper() == "ENRAGED" then
                            if ValueInstance.Value < 1 then
                                ValueInstance.Value = 1
                            end
                            ValueInstance:GetPropertyChangedSignal("Value"):Connect(function()
                                if ValueInstance.Value < 1 then
                                    ValueInstance.Value = 1
                                end
                            end)
                        elseif ValueInstance.Value > 0.03 and ValueInstance.Value < 1 then
                            ValueInstance:Destroy()
                        else
                            ValueInstance:GetPropertyChangedSignal("Value"):Connect(function()
                                if ValueInstance.Value > 0.03 and ValueInstance.Value < 1 then
                                    ValueInstance:Destroy()
                                end
                            end)
                        end
                    end
                end
            end,
            ["ScriptFunction"] = function(self,Value)
                if not Value or not SpeedMultipliers then
                    return
                end
                for i,Child in SpeedMultipliers:GetChildren() do
                    self:Check(Child)
                end
            end,
            ["CharacterAdded"] = function(self)
                if SpeedMultipliers ~= nil and SpeedMultipliers.Parent ~= nil and typeof(SpeedMultipliers) == "Instance" then
                    SpeedMultipliers.ChildAdded:Connect(function(Child)
                        if not Child:IsA("NumberValue") or Child.Name == "Sprinting" or Child.Name:lower() == "emoting" then
                            return
                        end
                        self:Check(Child)
                    end)
                end
            end
        },
        ["AnimationChanger"] = {
            ["DisplayDescription"] = "Select a character/skin to override the animations",
            ["DisplayTitle"] = "Animation Changer",
            ["LayoutOrder"] = 10,
            ["Savable"] = false,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Original",
            ["Requirement"] = "require",
            ["ExtraData"] = {
                ["StopOverride"] = false,
                ["Options"] = "Original|Jason|Jason IV|Slasher|Slasher IV|c00lkidd|c00lkidd IV|c0llabk1dd|John Doe|JohnDoe IV|Noli|Noli IV|1x1x1x1|1x1x1x1 IV|Nosferatu|Azure|Dusekkar|Civilian|Artful|Harken|Erlking|Herobrine|Medic|Sukuna|Retro|Gluttony|Gatito|Lovecore|Treachstone|Screamer|PH0NK1DD|Mafioso|Krystal|Pest|The Admin|Deceiver|VIP|Monster|Friend|The Pestilence|Celebration|P4rtyPwny|Content Creator|Narrator|Devesto|Alfred Drevis|Killer Kyle|Pursuer|TV TIME|c00lskeleton95|dragondudes3|Heaven Executioner|Timeless|Eye of The Abyss|White Pumpkin|Nerfed Demoman|Voidbound test|Sniper|Little Guy|Crouch|NPC Zombie|Default Roblox"
            },
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then return end
                if Value == "Original" or self.Instance:GetAttribute("StopOverride") then
                    GetValue("ChangeInLobby",true).Value = Value ~= "Original"
                    if LocalAnimator then
                        local AllTracks = LocalAnimator:GetPlayingAnimationTracks()
                        for i,v in AllTracks do
                            v:Stop(0)
                        end
                    end
                    if LastAnimOriginalUsed then
                        LastAnimOriginalUsed:Play(0)
                    end
                else
                    if LocalAnimator and CanPlayOverrideAnim(LocalCharacter) then
                        local AllTracks = LocalAnimator:GetPlayingAnimationTracks()
                        for i,v in AllTracks do
                            v:Stop(0)
                        end
                        UpdateAnim(LocalHumanoid)
                    end
                end
            end,
            ["CharacterAdded"] = function(self)
                local SupportedOverrides = {"idle","walk","run"}
                OverriddenAnimations = {}
                if not LocalAnimator then return end
                LastAnimOriginalUsed = LocalAnimator:GetPlayingAnimationTracks()[1]
                SpeedMultipliers.ChildAdded:Connect(function(Speed)
                    if Speed.Name == "Emoting" and CanPlayOverrideAnim(LocalCharacter) then
                        self.Instance:SetAttribute("StopOverride",true)
                        self:ScriptFunction(self.Instance.Value)
                    end
                end)
                SpeedMultipliers.ChildRemoved:Connect(function(Speed)
                    if Speed.Name == "Emoting" and self.Instance.Value ~= "Original" then
                        self.Instance:SetAttribute("StopOverride",false)
                        self:ScriptFunction(self.Instance.Value)
                    end
                end)
                LocalAnimator.AnimationPlayed:Connect(function(Track)
                    if CanPlayOverrideAnim(LocalCharacter) and MainModule then
                        local Override = Track.Animation:GetAttribute("Overriden")
                        LastAnimOriginalUsed = not Override and Track or LastAnimOriginalUsed
                        local AnimType,CharName = GetAnimationType(tonumber(Track.Animation.AnimationId:match("%d+")))
                        if not Override then
                            for i,v in SupportedOverrides do
                                if AnimType and AnimType:lower():find(v:lower()) then
                                    Track:Stop(0)
                                elseif not AnimType and Track.Looped then
                                    Track:Stop(0)
                                end
                            end
                        end
                        local FoundAction = false
                        for i,v in LocalAnimator:GetPlayingAnimationTracks() do
                            task.spawn(function()
                                local AnimType,Char,Name = GetAnimationType(v.Animation.AnimationId)
                                local IsSupported = false
                                for i,v in SupportedOverrides do
                                    if AnimType and AnimType:lower():find(v:lower()) then
                                        IsSupported = true
                                    end
                                end
                                if v.IsPlaying and not IsSupported and not v:GetAttribute("Ignored") then
                                    FoundAction = v
                                end
                            end)
                        end
                        if FoundAction and Override then
                            Track:Stop(0.2)
                            task.wait(not FoundAction.Looped and FoundAction.Length * 0.95 or 0)
                            if FoundAction.Looped then
                                FoundAction.Stopped:Wait()
                            end
                            FoundAction:SetAttribute("Ignored",true)
                            task.delay(0.2,function()
                                FoundAction:SetAttribute("Ignored",nil)
                            end)
                            UpdateAnim(LocalHumanoid)
                        end
                    end
                end)
                local MoreThanZero = 0
                LocalHumanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
                    if GetValue("AnimationChanger") ~= "Original" and MoreThanZero ~= (LocalHumanoid.MoveDirection.Magnitude == 0) then
                        MoreThanZero = (LocalHumanoid.MoveDirection.Magnitude == 0)
                        UpdateAnim(LocalHumanoid)
                    end
                end)
                task.delay(0.05,UpdateAnim,LocalHumanoid)
            end,
            ["CustomSetup"] = function(self)
                local function StartSprintDetection()
                    repeat task.wait(0.1) until MainModule["__sprintedEvent"]
                    MainModule["__sprintedEvent"].Event:Connect(function()
                        if GetValue("AnimationChanger") ~= "Original" then
                            UpdateAnim(LocalHumanoid)
                        end
                    end)
                    MainModule["__sprintedEvent"].Destroying:Once(function()
                        StartSprintDetection()
                    end)
                end
                if MainModule then
                    task.spawn(StartSprintDetection)
                end
            end
        },
        ["ChangeInLobby"] = {
            ["DisplayDescription"] = "If it should change the animation in the lobby too",
            ["DisplayTitle"] = "Change In Lobby",
            ["LayoutOrder"] = 12,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "AnimationChanger~Original",
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then return end
                if Value == true then
                    UpdateAnim(LocalHumanoid)
                else
                    if LocalAnimator then
                        local AllTracks = LocalAnimator:GetPlayingAnimationTracks()
                        for i,v in AllTracks do
                            v:Stop(0)
                        end
                        if LastAnimOriginalUsed then
                            LastAnimOriginalUsed:Play(0)
                        end
                        UpdateAnim(LocalHumanoid)
                    end
                end
            end
        },
        ["NoliControl"] = {
            ["DisplayDescription"] = "Allows you to have better control of Void Rush Ability",
            ["DisplayTitle"] = "Better Void Rush",
            ["LayoutOrder"] = 13,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:Noli|require",
            ["ScriptFunction"] = function(self, Value, Starting)
                if not Value and Starting then return end
                if NoliConfig then
                    for i, Entry in {
                        {Name = "InitialTurnDuration", Value = 0.005, Default = 1.5},
                        {Name = "TurnSpeed", Value = 10000, Default = 1},
                        {Name = "InitialTurnMult", Value = 1000, Default = 6.6},
                    } do
                        local CurrentValue, Key, Parent = TableValueFind(NoliConfig, function(i, v) return type(i) == "string" and i:find(Entry.Name) and not i:find(Entry.Name .. "OG") end)
                        if Key and Parent then
                            if Value then
                                if not Parent[Key .. "OG"] then
                                    Parent[Key .. "OG"] = Parent[Key]
                                end
                                Parent[Key] = Entry.Value
                            else
                                Parent[Key] = Parent[Key .. "OG"] or Entry.Default
                            end
                        end
                    end
                    if LocalCharacter and LocalCharacter.Parent.Name == "Killers" and not workspace:GetAttribute("NotifCD") then
                        StarterGui:SetCore("SendNotification", {
                            Title = "Information",
                            Text = "Changes only apply the time you become the killer",
                            Duration = 5
                        })
                        workspace:SetAttribute("NotifCD", true)
                        task.delay(10, function()
                            workspace:SetAttribute("NotifCD", nil)
                        end)
                    end
                elseif not NoliConfig and not Starting then
                    self.Instance:SetAttribute("Requirement",true)
                    StarterGui:SetCore("SendNotification", {
                        Title = "Information",
                        Text = `Failed to find Noli's Config Module{GetValue("OfficialGame") and ". Please Report This issue!" or ""}`,
                        Duration = GetValue("OfficialGame") and 12 or 7
                    })
                end
            end
        },
        ["ControllableDash"] = {
            ["DisplayDescription"] = "Allows you to control where the dash goes just like Void Rush Ability",
            ["DisplayTitle"] = "Make Coolkidd's Dash Controllable",
            ["LayoutOrder"] = 14,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["Requirement"] = "Killer:c00lkidd",
            ["DefaultInstanceValue"] = false,
            ["ExtraData"] = {
                ["Responsiveness"] = 100,
            },
            ["CharacterAdded"] = function(self)
                LocalRoot.ChildAdded:Connect(function(Child:LinearVelocity?)
                    if Child:IsA("LinearVelocity") and LocalHumanoid and LocalCharacter.Parent.Name:lower():find("killer") and LocalCharacter.Name:lower():find("lkid") then
                        local OriginalVelocity = Child.LineDirection
                        local OriginalVelocityMag = Child.LineDirection.Magnitude
                        for i,v in SpeedMultipliers:GetChildren() do
                            if v.Name == "HinderedMovement" and GetValue("ControllableDash") and v.Value == 0 then
                                v.Value = 0.005
                            end
                        end
                        local function UpdateVelocity(Start)
                            if GetValue("ControllableDash") and (LocalCharacter.Name:gsub("0","O"):lower():find("coolkid")) and LocalHumanoid.MoveDirection ~= Vector3.zero then
                                Child.LineDirection = Child.LineDirection:Lerp(LocalHumanoid.MoveDirection * OriginalVelocityMag,self.Instance:GetAttribute("Responsiveness")/1000)
                            elseif GetValue("ControllableDash") and (LocalCharacter.Name:gsub("0","O"):lower():find("coolkid")) and workspace.CurrentCamera then
                                local CameraDirection = Vector3.new(workspace.CurrentCamera.CFrame.LookVector.X, 0, workspace.CurrentCamera.CFrame.LookVector.Z)
                                Child.LineDirection = Child.LineDirection:Lerp(CameraDirection.Unit * OriginalVelocityMag,self.Instance:GetAttribute("Responsiveness")/1000)
                                if Child.LineVelocity > 0 or Start then
                                    LocalRoot.CFrame = LocalRoot.CFrame:Lerp(CFrame.lookAt(LocalRoot.Position, LocalRoot.Position + CameraDirection),Start and 1 or 0.05)
                                end
                            else
                                Child.LineDirection = OriginalVelocity
                            end
                        end
                        UpdateVelocity()
                        local Connection1;Connection1 = LocalHumanoid:GetPropertyChangedSignal("MoveDirection"):Connect(UpdateVelocity)
                        local Connection2;Connection2 = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(UpdateVelocity)
                        Child.Destroying:Once(function()
                            if Connection1 then
                                Connection1:Disconnect()
                                Connection1 = nil
                            end
                            if Connection2 then
                                Connection2:Disconnect()
                                Connection2 = nil
                            end
                        end)
                    end
                end)
            end
        },
        ["AutoBlock"] = {
            ["DisplayDescription"] = "Uses the block ability automatically when about to get hit (REQUIRES GOOD PING)",
            ["DisplayTitle"] = '<stroke thickness="0.7">Guest1337</stroke> Auto Block',
            ["LayoutOrder"] = 15,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Survivor:Guest1337|require",
            ["ScriptFunction"] = function(self, Value)
                local BlockAbilityUI = MainUI and MainUI:FindFirstChild("AbilityContainer") and MainUI:FindFirstChild("AbilityContainer"):FindFirstChild("Block")
                local AutoImage = BlockAbilityUI and BlockAbilityUI:FindFirstChild("AutoImage")
                if Value and AutoImage then
                    AutoImage.Visible = true
                elseif AutoImage then
                    AutoImage.Visible = false
                end
            end,
            ["HandleKiller"] = function(self,Killer)
                local BlockableAttacks = {"slash","enragedslash","stab","attack","punch","swing","golemslash"}
                local CustomHitboxes = {
                    ["golemslash"] = {
                        Size = Vector3.new(6, 2, 7),
                        Offset = CFrame.new(0,0,-5.5)
                    },
                }
                local FireSignal = GetFunction(firesignal,FireSignal)
                local SelfParams = OverlapParams.new()
                SelfParams.MaxParts = 1
                SelfParams.BruteForceAllSlow = true
                local UseActorAbility = Network and Network:FindFirstChildOfClass("RemoteEvent")
                local ShowHitboxesSetting = PlayerData and PlayerData:FindFirstChild("Settings") and PlayerData.Settings:FindFirstChild("ShowHitboxes",true)
                local Humanoid = Killer:FindFirstChildOfClass("Humanoid") or Killer:WaitForChild("Humanoid")
                local QueryHitbox = Killer:FindFirstChild("QueryHitbox") or Killer:WaitForChild("QueryHitbox")
                local KillerAnimator = Humanoid:FindFirstChildOfClass("Animator")
                if KillerAnimator then
                    KillerAnimator.AnimationPlayed:Connect(function(Track)
                        if GetValue("AutoBlock") and Players:GetPlayerFromCharacter(Killer) then
                            local AnimType,KillerName = GetAnimationType(Track.Animation.AnimationId)
                            if AnimType and type(AnimType) == type("") and table.find(BlockableAttacks,AnimType:lower()) and LocalCharacter and LocalCharacter:FindFirstChild("QueryHitbox") and LocalCharacter.Parent == SurvivorsFolder and MainUI:FindFirstChild("AbilityContainer") and MainUI:FindFirstChild("AbilityContainer"):FindFirstChild("Block") then
                                local CustomHitbox = CustomHitboxes[AnimType:lower()] or CustomHitboxes[Killer.Name:lower()]
                                for i = 1,12 do
                                    SelfParams.IncludeInstances = {LocalCharacter:FindFirstChild("QueryHitbox")}
                                    local Part = Instance.new("Part")
                                    Part.Name = "KillerDetectHitbox"
                                    Part.Color = BrickColor.new("Really black").Color
                                    Part.Size =  (CustomHitbox and CustomHitbox["Size"] or Vector3.new(5.2, 6, 5.65)) * 2.2
                                    Part.CFrame = QueryHitbox.CFrame * (CustomHitbox and CustomHitbox["Offset"] or CFrame.new(0,0,-3.5))
                                    Part.CanCollide = false
                                    Part.Anchored = true
                                    Part.CastShadow = false
                                    Part.Material = Enum.Material.ForceField
                                    Part.Transparency = ShowHitboxesSetting.Value and 0.1 or 1
                                    Part.Parent = Hitboxes
                                    Debris:AddItem(Part,0.4)
                                    local Hitbox = workspace:GetPartBoundsInBox(Part.CFrame,Part.Size,SelfParams)
                                    LogService:Info("HitboxCheck",Hitbox)
                                    if #Hitbox > 0 then
                                        if FireSignal and MainUI:FindFirstChild("AbilityContainer"):FindFirstChild("Block") then
                                            FireSignal(MainUI.AbilityContainer.Block.MouseButton1Down)
                                            FireSignal(MainUI.AbilityContainer.Block.MouseButton1Click)
                                            break
                                        end
                                        if GetValue("OfficialGame") then
                                            UseActorAbility:FireServer("UseActorAbility",{"Block"})
                                        else
                                            UseActorAbility:FireServer("UseActorAbility","Block")
                                            UseActorAbility:FireServer("UseActorAbility",{"Block"})
                                        end
                                        break
                                    end
                                    task.wait(0.02)
                                end
                            end
                        end
                    end)
                end
            end,
            ["SetupUI"] = function(AbilityContainer)
                if AbilityContainer.Name == "AbilityContainer" then
                    if AbilityContainer:FindFirstChild("Block") and not AbilityContainer:FindFirstChild("Block"):FindFirstChild("AutoImage") then
                        local AutoImage = Instance.new("ImageLabel")
                        AutoImage.Name = "AutoImage"
                        AutoImage.Interactable = false
                        AutoImage.Parent = AbilityContainer:FindFirstChild("Block")
                        AutoImage.Image = "rbxassetid://114159864966636"
                        AutoImage.BackgroundTransparency = 1
                        AutoImage.Size = UDim2.fromScale(0.8,0.8)
                        AutoImage.Position = UDim2.fromScale(0.5,0)
                        AutoImage.AnchorPoint = Vector2.new(0.5,0.4)
                        AutoImage.Visible = GetValue("AutoBlock") and LocalCharacter.Parent.Name:find("Survi")
                    end
                end
            end,
            ["CustomSetup"] = function(self)
                self.DisplayTitle = self.DisplayTitle:gsub("Guest1337",RichTextGradientColor("Guest1337",{Color3.fromRGB(16, 47, 185), Color3.fromRGB(146, 202, 93)}))
                if MainUI:FindFirstChild("AbilityContainer") then
                    self:SetupUI(MainUI:FindFirstChild("AbilityContainer"))
                end
                MainUI.ChildAdded:Connect(self.SetupUI)
                if KillersFolder then
                    KillersFolder.ChildAdded:Connect(function(Killer)
                        self:HandleKiller(Killer)
                    end)
                    for i,Killer in KillersFolder:GetChildren() do self:HandleKiller(Killer) end
                end
            end
        },
        ["AutoPunch"] = {
            ["DisplayDescription"] = "Uses the punch ability when you block successfully",
            ["DisplayTitle"] = '<stroke thickness="0.7">Guest1337</stroke> Auto Punch',
            ["LayoutOrder"] = 16,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Survivor:Guest1337",
            ["ExtraData"] = {
                ["Accuracy"] = 80
            },
            ["ScriptFunction"] = function(self, Value)
                local BlockAbilityUI = MainUI and MainUI:FindFirstChild("AbilityContainer") and MainUI:FindFirstChild("AbilityContainer"):FindFirstChild("Punch")
                local AutoImage = BlockAbilityUI and BlockAbilityUI:FindFirstChild("AutoImage")
                if Value and AutoImage and LocalCharacter.Name:lower():find("guest") then
                    AutoImage.Visible = true
                elseif AutoImage then
                    AutoImage.Visible = false
                end
            end,
            ["SetupUI"] = function(AbilityContainer)
                if AbilityContainer.Name == "AbilityContainer" then
                    if AbilityContainer:FindFirstChild("Punch") and not AbilityContainer:FindFirstChild("Punch"):FindFirstChild("AutoImage") then
                        local AutoImage = Instance.new("ImageLabel")
                        AutoImage.Name = "AutoImage"
                        AutoImage.Interactable = false
                        AutoImage.Parent = AbilityContainer:FindFirstChild("Punch")
                        AutoImage.Image = "rbxassetid://114159864966636"
                        AutoImage.BackgroundTransparency = 1
                        AutoImage.Size = UDim2.fromScale(0.8,0.8)
                        AutoImage.Position = UDim2.fromScale(0.5,0)
                        AutoImage.AnchorPoint = Vector2.new(0.5,0.4)
                        AutoImage.Visible = GetValue("AutoPunch") and LocalCharacter.Parent.Name:find("Survi") and LocalCharacter.Name:lower():find("guest")
                    end
                end
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
            ["CharacterAdded"] = function(self)
                local FireSignal = GetFunction(firesignal,FireSignal)
                local UseActorAbility = Network and Network:FindFirstChildOfClass("RemoteEvent")
                if not LocalHumanoid then return warn("no humanoid found") end
                LocalCharacter:GetAttributeChangedSignal("TimesHit"):Connect(function()
                    if GetValue("AutoPunch") and SpeedMultipliers:FindFirstChild("GuestBlocking") and LocalHumanoid:GetAttribute("Overheal") ~= nil and LocalHumanoid:GetAttribute("Overheal") >= 10 and (self:GetClosestKiller()) then
                        task.wait(0.08)
                        LocalCharacter:SetAttribute("DisableShiftLockMovement",true)
                        if FireSignal and MainUI:FindFirstChild("AbilityContainer"):FindFirstChild("Punch") then
                            FireSignal(MainUI.AbilityContainer.Punch.MouseButton1Down)
                            FireSignal(MainUI.AbilityContainer.Punch.MouseButton1Click)
                        else
                            if GetValue("OfficialGame") then
                                UseActorAbility:FireServer("UseActorAbility",{"Punch"})
                            else
                                UseActorAbility:FireServer("UseActorAbility","Punch")
                                UseActorAbility:FireServer("UseActorAbility",{"Punch"})
                            end
                        end
                        local Timeout = workspace.DistributedGameTime + 1.25
                        local CameraTarget
                        local SelectedVelocity
                        CameraTarget = RunService.RenderStepped:Connect(function()
                            local ClosestKiller,Dis = self:GetClosestKiller()
                            if not ClosestKiller or not ClosestKiller:FindFirstChild("HumanoidRootPart") then return end
                            local KillerRootPos = ClosestKiller:FindFirstChild("HumanoidRootPart").Position
                            local SelectedPosition = Vector3.new(KillerRootPos.X,LocalRoot.Position.Y,KillerRootPos.Z)
                            local TargetCFrame = CFrame.new(LocalRoot.Position, SelectedPosition)
                            LocalCharacter:SetPrimaryPartCFrame(TargetCFrame)
                            if not SelectedVelocity then
                                LocalRoot.Velocity = TargetCFrame.LookVector * 32
                                SelectedVelocity = LocalRoot.Velocity
                            else
                                SelectedVelocity = LocalRoot.Velocity:Lerp(SelectedVelocity or LocalRoot.Velocity,GetValue("AutoPunch",true):GetAttribute("Accuracy")/100)
                                LocalRoot.Velocity = SelectedVelocity
                            end
                        end)
                        repeat
                            task.wait(0.1)
                        until FOVMultipliers:FindFirstChild("HitRegistered") or not SpeedMultipliers:FindFirstChild("PunchAbility") or workspace.DistributedGameTime > Timeout
                        CameraTarget:Disconnect()
                        task.wait(0.2)
                        LocalCharacter:SetAttribute("DisableShiftLockMovement",false)
                    end
                end)
            end,
            ["CustomSetup"] = function(self)
                self.DisplayTitle = self.DisplayTitle:gsub("Guest1337",RichTextGradientColor("Guest1337",{Color3.fromRGB(16, 47, 185), Color3.fromRGB(146, 202, 93)}))
                if MainUI:FindFirstChild("AbilityContainer") then
                    self:SetupUI(MainUI:FindFirstChild("AbilityContainer"))
                end
                MainUI.ChildAdded:Connect(self.SetupUI)
            end
        },
        ["EnableOverride"] = {
            ["DisplayDescription"] = "Overrides the puzzle grid size of the generators",
            ["DisplayTitle"] = "Override Generator(s) Grid Size",
            ["LayoutOrder"] = 17,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "require",
            ["CustomSetup"] = function(self)
                if not (GetValue("require") and FlowGame and FlowGame.Name == "FlowGame") then
                    self.Requirement = true
                end
            end
        },
        ["GridSize"] = {
            ["DisplayDescription"] = "The Size to override for the Generator's Puzzle",
            ["DisplayTitle"] = "Generator(s) Grid Size",
            ["LayoutOrder"] = 18,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 6,
            ["Requirement"] = "require|EnableOverride",
            ["ExtraData"] = {
                ["MaxValue"] = 12,
                ["MinValue"] = 4,
                ["Step"] = 1,
            },
            ["HandlePuzzle"] = function(Data)
                PuzzleData = {}
                local function GetDirection(Row1,Col1,Row2,Col2)
                    if Row2 < Row1 then return "up" end
                    if Row2 > Row1 then return "down" end
                    if Col2 < Col1 then return "left" end
                    if Col2 > Col1 then return "right" end
                end
                local function GetPuzzleConnections(Last, New, Next)
                    local Connections = {}
                    if Last and New then
                        local Direction = GetDirection(New.row, New.col, Last.row, Last.col)
                        if Direction == "up" then Direction = "down"
                        elseif Direction == "down" then Direction = "up"
                        elseif Direction == "left" then Direction = "right"
                        elseif Direction == "right" then Direction = "left" end
                        if Direction ~= "" and Direction then Connections[Direction] = true end
                    end
                    if Next and New then
                        local Direction = GetDirection(New.row, New.col, Next.row, Next.col)
                        if Direction ~= "" and Direction then Connections[Direction] = true end
                    end
                    return Connections
                end
                local function NearbyDirection(Row1, Col1, Row2, Col2)
                    if Row2 == Row1 - 1 and Col2 == Col1 then return "up" end
                    if Row2 == Row1 + 1 and Col2 == Col1 then return "down" end
                    if Row2 == Row1 and Col2 == Col1 - 1 then return "left" end
                    if Row2 == Row1 and Col2 == Col1 + 1 then return "right" end
                    return false
                end
                local function GetPlaceKey(Point) return `{Point.row}-{Point.col}` end
                local function PathEndpoints(Path, endpoints)
                    if not Path or #Path == 0 then return Path end
                    local UniquePoint
                    for i, Point in endpoints or {} do
                        for i, v in Path do
                            if v.row == Point.row and v.col == Point.col then
                                UniquePoint = {row = Point.row,col = Point.col}
                                break
                            end
                        end
                        if UniquePoint then break end
                    end
                    if not UniquePoint then
                        local PointsInPath = {}
                        for i, Point in Path do
                            local TableKey = GetPlaceKey(Point)
                            PointsInPath[TableKey] = Point
                        end
                        for i, Point in Path do
                            local Nearby = 0
                            local Directions = {{Point.row - 1,Point.col}, {Point.row + 1,Point.col},{Point.row