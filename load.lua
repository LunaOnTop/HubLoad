local userKey = "https://pastebin.com/mC3sLRSA" 
local key = game:HttpGet(userKey, true)

plr = game.Players.LocalPlayer
if string.find(key,_G.Key) then
 
print("Whitelisted")

local Config = {
    WindowName = "LOLV",
	Color = Color3.fromRGB(65, 0, 255),
	Keybind = Enum.KeyCode.RightBracket
}

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/BracketV3.lua"))()
local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))

local Tab1 = Window:CreateTab("Main")
local Tab2 = Window:CreateTab("Teleportations")
local Tab3 = Window:CreateTab("UI Settings")

local Section1 = Tab1:CreateSection("Combat")
local Section2 = Tab1:CreateSection("Visuals")
local Section3 = Tab3:CreateSection("Menu")
local Section4 = Tab3:CreateSection("Background")
local Section5 = Tab2:CreateSection("Areas")
local Section6 = Tab1:CreateSection("Character")
local Section7 = Tab1:CreateSection("Misc")


local ESPSettings                       = { PlayerESP = { Enabled = false, TracersOn = false, BoxesOn = false, NamesOn = false, DistanceOn = false, HealthOn = false, ToolOn = false, FaceCamOn = false, Distance = 2000 }, ScrapESP = { Enabled = false, Distance = 2000, LegendaryOnly = true, RareOnly = true, GoodOnly = true, BadOnly = true }, SafeESP = { Enabled = false, Distance = 2000, BigOnly = true, SmallOnly = true }, RegisterESP = { Enabled = false, Distance = 2000 }, ESPColor = Color3.fromRGB(255, 255, 255), ToolColor = Color3.fromRGB(255, 255, 255)};
local ESPFramework                      = loadstring(game:HttpGet("https://raw.githubusercontent.com/NougatBitz/Femware-Leak/main/ESP.lua", true))()


-->> Silent Aim [Section 1 - Tab 1]
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RenderStepped = RunService.RenderStepped

local LocalPlayer = Players.LocalPlayer
local chr = LocalPlayer.Character
local hum = chr:WaitForChild("Humanoid")

local game = game;
local GetService = game.GetService;

local RunService = game:GetService("RunService")
local RenderStepped = RunService.RenderStepped

local Workspace = GetService(game, "Workspace");
local Players = GetService(game, "Players");
local ReplicatedStorage = GetService(game, "ReplicatedStorage");
local StarterGui = GetService(game, "StarterGui");

local resume = coroutine.resume 
local create = coroutine.create

local LogService = GetService(game, "LogService");
local HttpService = GetService(game, "HttpService");
local ScriptContext = GetService(game, "ScriptContext");

local UIS = game:GetService("UserInputService")

local Request = http_request or request or HttpPost or syn.request
local Player = Players.LocalPlayer;
local Character = Player.Character;
local Mouse = Player:GetMouse()
local Cam = workspace.CurrentCamera;

local WorldToScreen = Cam.WorldToScreenPoint
local WorldToViewportPoint = Cam.WorldToViewportPoint
local GetPartsObscuringTarget = Cam.GetPartsObscuringTarget

local SilentSettings = { Main = { Enabled = false, TeamCheck = false, VisibleCheck = false, TargetPart = "Head" }, FOVSettings = { Visible = false, Radius = 120 } };
local ValidTargetParts = {"Head", "Torso"};

local RequiredArgs = {
    ArgCountRequired = 3,
        Args = {
        "Instance", "Vector3", "Vector3", "RaycastParams"
    }
}

local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.NumSides = 100
fov_circle.Radius = 120
fov_circle.Filled = false
fov_circle.Visible = false
fov_circle.ZIndex = 999
fov_circle.Transparency = 1
fov_circle.Color = Color3.fromRGB(255, 255 ,255)

local function GetPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToScreen(Cam, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end
local function ValidateArguments(Args, RayMethod)
    local Matches = 0

    if #Args < RayMethod.ArgCountRequired then
        return false
    end

    for Pos, Argument in next, Args do
        if typeof(Argument) == RayMethod.Args[Pos] then
            Matches = Matches + 1
        end
    end

    return Matches >= RayMethod.ArgCountRequired
end
        
local function GetDirection(Origin, Position)
    return (Position - Origin).Unit * 1000
end
        
local function GetMousePosition()
    return Vector2.new(Mouse.X, Mouse.Y)
end
        
        local function GetClosestPlayer()
            if not SilentSettings.Main.TargetPart then return end

            local Closest
            local DistanceToMouse

            for _, v in next, game.GetChildren(Players) do
                if v == Player then continue end
                if SilentSettings.Main.TeamCheck and v.Team == Player.Team then continue end
        
                local Character = v.Character
                if not Character then continue end
        
                local HumanoidRootPart = game.FindFirstChild(Character, "HumanoidRootPart")
                local Humanoid = game.FindFirstChild(Character, "Humanoid")
        
                if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end
        
                local ScreenPosition, OnScreen = GetPositionOnScreen(HumanoidRootPart.Position)
        
                if not OnScreen then continue end
        
                local Distance = (GetMousePosition() - ScreenPosition).Magnitude
                if Distance <= (DistanceToMouse or (SilentSettings.Main.Enabled and SilentSettings.FOVSettings.Radius) or 2000) then
                    Closest = ((SilentSettings.Main.TargetPart == "Random" and Character[ValidTargetParts[math.random(1, #ValidTargetParts)]]) or Character[SilentSettings.Main.TargetPart])
                    DistanceToMouse = Distance
                end
            end
            return Closest
        end
        
                local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(...)
            local Method = getnamecallmethod()
            local Arguments = {...}
            local self = Arguments[1]
        
            if SilentSettings.Main.Enabled and self == workspace then
                if ValidateArguments(Arguments, RequiredArgs) then
                    local A_Origin = Arguments[2]
                    local HitPart = GetClosestPlayer()

                    if HitPart then
                        Arguments[3] = GetDirection(A_Origin, HitPart.Position)
    
                        return oldNamecall(unpack(Arguments))
                    end
                end
            end

            return oldNamecall(...)
    end)
        

resume(create(function()
game:GetService("RunService").RenderStepped:Connect(function()
        if SilentSettings.FOVSettings.Visible then 
            fov_circle.Position = GetMousePosition() + Vector2.new(0, 36)
        end
    end)
end))

local SilentAimLabel = Section1:CreateLabel("Silent Aim")

local SaylintTogle = Section1:CreateToggle("Enabled", nil, function(State)
    SilentSettings.Main.Enabled = State
end)

local FovToggle = Section1:CreateToggle("Show FOV", nil, function(State)
    SilentSettings.FOVSettings.Visible = State
    fov_circle.Visible = State
end)

local Slider1 = Section1:CreateSlider("Fov Radius", 0,1000,nil,true, function(Value)
    SilentSettings.FOVSettings.Radius = Value
    fov_circle.Radius = Value
end)

local Colorpicker1 = Section1:CreateColorpicker("Fov Color", function(V)
	fov_circle.Color = V
end)
-->> End Silent Aim

-->> esp
local Label1 = Section2:CreateLabel("ESP")
local Toggle2 = Section2:CreateToggle("Toggle Esp", ESPSettings.PlayerESP.Enabled, function(V)
    ESPSettings.PlayerESP.Enabled = V

    ESPFramework.Color = ESPSettings.ESPColor
    ESPFramework.ToolColor = ESPSettings.ToolColor
    ESPFramework.Tracers = ESPSettings.PlayerESP.TracersOn
    ESPFramework.Names = ESPSettings.PlayerESP.NamesOn
    ESPFramework.Health = ESPSettings.PlayerESP.HealthOn
    ESPFramework.Distance = ESPSettings.PlayerESP.DistanceOn
    ESPFramework.Tool = ESPSettings.PlayerESP.ToolOn
    ESPFramework.Boxes = ESPSettings.PlayerESP.BoxesOn
    ESPFramework.FaceCamera = ESPSettings.PlayerESP.FaceCamOn
    ESPFramework:Toggle(ESPSettings.PlayerESP.Enabled)
end, "PlayerESPsToggle")



local Toggle2 = Section2:CreateToggle("Boxes", ESPSettings.PlayerESP.BoxesOn, function(V)
    ESPSettings.PlayerESP.BoxesOn = V
    ESPFramework.Boxes = ESPSettings.PlayerESP.BoxesOn
end)

local Toggle2 = Section2:CreateToggle("Tracers", ESPSettings.PlayerESP.TracersOn, function(V)
    ESPSettings.PlayerESP.TracersOn = V
    ESPFramework.Tracers = ESPSettings.PlayerESP.TracersOn
end)

local Toggle2 = Section2:CreateToggle("Name", ESPSettings.PlayerESP.NamesOn, function(V)
    ESPSettings.PlayerESP.NamesOn = V
    ESPFramework.Names = ESPSettings.PlayerESP.NamesOn
end)

local Toggle2 = Section2:CreateToggle("Health", ESPSettings.PlayerESP.HealthOn, function(V)
    ESPSettings.PlayerESP.HealthOn = V
    ESPFramework.Health = ESPSettings.PlayerESP.HealthOn
end)

local Toggle2 = Section2:CreateToggle("Distance", ESPSettings.PlayerESP.DistanceOn, function(V)
    ESPSettings.PlayerESP.DistanceOn = V
    ESPFramework.Distance = ESPSettings.PlayerESP.DistanceOn
end)

-->> End esp


-->> Ui settings
local Toggle3 = Section3:CreateToggle("UI Toggle", nil, function(State)
	Window:Toggle(State)
end)
Toggle3:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""), function(Key)
	Config.Keybind = Enum.KeyCode[Key]
end)
Toggle3:SetState(true)

local Colorpicker3 = Section3:CreateColorpicker("UI Color", function(Color)
	Window:ChangeColor(Color)
end)
Colorpicker3:UpdateColor(Config.Color)

-- credits to jan for patterns
local Dropdown3 = Section4:CreateDropdown("Image", {"Default","Hearts","Abstract","Hexagon","Circles","Lace With Flowers","Floral"}, function(Name)
	if Name == "Default" then
		Window:SetBackground("2151741365")
	elseif Name == "Hearts" then
		Window:SetBackground("6073763717")
	elseif Name == "Abstract" then
		Window:SetBackground("6073743871")
	elseif Name == "Hexagon" then
		Window:SetBackground("6073628839")
	elseif Name == "Circles" then
		Window:SetBackground("6071579801")
	elseif Name == "Lace With Flowers" then
		Window:SetBackground("6071575925")
	elseif Name == "Floral" then
		Window:SetBackground("5553946656")
	end
end)
Dropdown3:SetOption("Default")




local Slider3 = Section4:CreateSlider("Transparency",0,1,nil,false, function(Value)
	Window:SetBackgroundTransparency(Value)
end)
Slider3:SetValue(0)

local Slider4 = Section4:CreateSlider("Tile Scale",0,1,nil,false, function(Value)
	Window:SetTileScale(Value)
end)
Slider4:SetValue(0.5)
-->> end ui settings

-->> Player
local SilentAimLabel = Section6:CreateLabel("Movement")
local Slider1 = Section6:CreateSlider("Walk Speed", 0,200,16,true, function(v)
	_G.WalkSpeed = v
end)

local Toggle111 = Section6:CreateToggle("Toggle WS", nil, function(State)
    if State == true then
        getgenv().WalkSpeedValue = _G.WalkSpeed; --set your desired walkspeed here
        local Player = game:service'Players'.LocalPlayer;
        Player.Character.Humanoid:GetPropertyChangedSignal'WalkSpeed':Connect(function()
        Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
        end)
        Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
        end 
        if State == false then
        getgenv().WalkSpeedValue = 16; --set your desired walkspeed here
        local Player = game:service'Players'.LocalPlayer;
        Player.Character.Humanoid:GetPropertyChangedSignal'WalkSpeed':Connect(function()
        Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
        end)
        Player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue;
    end
    end)

    Toggle111:CreateKeybind("5", function(Key)
        print(Key)
    end)

-------------
local Toggle2 = Section6:CreateToggle("Toggle JP", nil, function(State)
    if State == true then
        getgenv().JumpPowerValue = _G.JumpPower; --set your desired walkspeed here
        local Player = game:service'Players'.LocalPlayer;
        Player.Character.Humanoid:GetPropertyChangedSignal'WalkSpeed':Connect(function()
        Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
        end)
        Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
        end 
        if State == false then
        getgenv().JumpPowerValue = 50; --set your desired walkspeed here
        local Player = game:service'Players'.LocalPlayer;
        Player.Character.Humanoid:GetPropertyChangedSignal'JumpPower':Connect(function()
        Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
        end)
        Player.Character.Humanoid.JumpPower = getgenv().JumpPowerValue;
    end
    end)



local Slider1 = Section6:CreateSlider("Jump Power", 0,200,50,true, function(v)
	_G.JumpPower = v
end)


local Toggle2 = Section6:CreateToggle("Fly [X]", nil, function(State)
    local Flying = true
    local Flymode = "Camera"
    local MaxSpeed = 10 -- speed 
    local Down = {['w'] = false, ['a'] = false, ['s'] = false, ['d'] = false, ['q'] = false, ['e'] = false}
    local KD = game.Players.LocalPlayer:GetMouse().KeyDown
    local KU = game.Players.LocalPlayer:GetMouse().KeyUp
    KD:Connect(function(K)
        if K == "w" or K == "a" or K == "s" or K == "d" or K == "q" or K == "e" then 
            Down[K] = true 
            print(Down[K])
        end
    end)
    
    KU:Connect(function(K)
        if K == "w" or K == "a" or K == "s" or K == "d" or K == "q" or K == "e" then 
            Down[K] = false 
        elseif K == "x" then 
            Flying = not Flying 
            EnableFly()
        end
    end)
    
    if workspace:FindFirstChild("CenterOfGravitationalForce") then 
        Flying = false 
        workspace:FindFirstChild("CenterOfGravitationalForce"):Destroy()
    end
    
    local Flyanimation = Instance.new('Animation', game.Workspace)
    Flyanimation.AnimationId = 'rbxassetid://3541044388'
    local Idleanimation = Instance.new('Animation', game.Workspace)
    Idleanimation.AnimationId = 'rbxassetid://3541114300'
    local HeroIdle = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Idleanimation)
    local HeroFly = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Flyanimation)
    
    local Inc = 0.1
    
    function EnableFly()
        local Speed = 0.5
        local Part = Instance.new("Part")
        Part.Parent = workspace
        Part.Size = Vector3.new(5,5,5)
        Part.Transparency = 1
        Part.CanCollide = false 
        Part.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        Part.Anchored = true
        Part.Name = "CenterOfGravitationalForce"
        
        local Att1 = Instance.new("Attachment")
        Att1.Name = "Att1"
        Att1.Visible = false 
        Att1.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        
        local Att2 = Instance.new("Attachment")
        Att2.Name = "Att2"
        Att2.Visible = false 
        Att2.Parent = Part
        
        local AlignPos = Instance.new("AlignPosition")
        local AlignGyro = Instance.new("AlignOrientation")
        
        AlignPos.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        AlignPos.Attachment0 = Att1
        AlignPos.MaxForce = math.huge
        AlignPos.MaxVelocity = math.huge
        AlignPos.Mode = Enum.PositionAlignmentMode.TwoAttachment
        AlignPos.Attachment1 = Att2
        AlignPos.RigidityEnabled = false 
        
        AlignGyro.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        AlignGyro.Mode = Enum.OrientationAlignmentMode.OneAttachment
        AlignGyro.CFrame = workspace.CurrentCamera.CFrame
        AlignGyro.MaxTorque = math.huge
        AlignGyro.Attachment0 = Att1
        AlignGyro.RigidityEnabled = false
        
        repeat wait() 
            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
            if Down["w"] then 
                HeroFly:Play()
                HeroIdle:Stop()
                Part.CFrame = Part.CFrame + workspace.CurrentCamera.CFrame.lookVector * Speed
                Speed = Speed + Inc
            end
            if Down["s"] then 
                HeroFly:Play()
                HeroIdle:Stop()
                Part.CFrame = Part.CFrame - workspace.CurrentCamera.CFrame.lookVector * Speed
                Speed = Speed + Inc
            end
            if Down["q"] then 
                Part.CFrame = Part.CFrame * CFrame.new(0, Speed, 0)
            end 
            if Down["e"] then 
                Part.CFrame = Part.CFrame * CFrame.new(0, -Speed, 0)
            end
            if Speed > MaxSpeed then 
                Speed = MaxSpeed
            end
            if not Down["w"] and not Down["s"] then 
                HeroFly:Stop()
                HeroIdle:Play()
            end
            if Down["w"] then 
                AlignGyro.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad(Speed*4), 0 ,0)
            elseif Down["s"] then 
                AlignGyro.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad(Speed*4), 0 ,0)
            elseif Down["q"] then 
                AlignGyro.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad(Speed*7), 0 ,0)
            elseif Down["e"] then 
                AlignGyro.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad(Speed*7), 0 ,0)
            elseif Down["a"] then 
                AlignGyro.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(0, math.rad(Speed*50) ,0)
            elseif Down["d"] then 
                AlignGyro.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(0, -math.rad(Speed*50) ,0)
            else
                AlignGyro.CFrame = workspace.CurrentCamera.CFrame
            end
        until Flying == false
        game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
        AlignGyro:Destroy()
        AlignPos:Destroy()
        Part:Destroy()
        HeroIdle:Stop()
        HeroFly:Stop()
    end
    EnableFly()
end)



        local Toggle6 = Section6:CreateToggle("Noclip", nil, function(v) 
            _G.Noclip = v
            
            local function Noclip()
            if game.Players.LocalPlayer.Character ~= nil and _G.Noclip == true then
            for _, selfChar in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if selfChar:IsA("BasePart") and selfChar.CanCollide == true and selfChar.Name then
                        selfChar.CanCollide = false
                    end
                end
            end
        end     
    game:GetService('RunService').Stepped:Connect(Noclip)
end)

-->> END PLAYER

-->> MISC
local Button1 = Section7:CreateButton("⚠️Vision", function()	
    game.Players.LocalPlayer.Character["Left Arm"]:Destroy()
    game.Players.LocalPlayer.Character["Right Leg"]:Destroy()
    game.Players.LocalPlayer.Character["Left Leg"]:Destroy()
    game.Players.LocalPlayer.Character.Humanoid.HipHeight = 10
    for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("SpecialMesh") or v.Name == "SpecialMesh" then
            v:Destroy()
        end
    end
    end)



local Slider1 = Section7:CreateSlider("Full bright", 0,5,nil,false, function(v)
    game:GetService("Lighting").ExposureCompensation = v
end)
local Colorpicker2 = Section7:CreateColorpicker("Ambient Colour", function(v)
    game:GetService("Lighting").OutdoorAmbient = v
end)

local Toggle6 = Section7:CreateToggle("Delete Textures [more fps]", nil, function(v)
for _,v in pairs(workspace:GetDescendants()) do
    if v.ClassName == "Part" or v.ClassName == "SpawnLocation" or v.ClassName == "WedgePart" or v.ClassName == "Terrain" or v.ClassName == "MeshPart" then
        v.Material = "Plastic"
    end
end

for i, v in pairs(workspace:GetDescendants()) do
    if v.ClassName == "Decal" or v.ClassName == "Texture" then
        v:Destroy()
    end
end
end)




-->> TELEPORTS

local Button1 = Section5:CreateButton("Mountain", function()	    
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-157, 466, 951)
end)

local Button1 = Section5:CreateButton("Building", function()	    
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-655, 279, 122)
end)

local Button1 = Section5:CreateButton("Spawn", function()	    
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-393, 188, -51)
end)
else
plr:kick("Not whitelisted")
end
