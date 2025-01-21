--[[
    🎯 Butt3rL3aks | Counter Blox Reimagined
    Made by kvkfjf
    Join our Discord: https://discord.gg/S7qUMBNq6f
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Load ESP Library
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🎯 Butt3rL3aks | Counter Blox Reimagined", "Ocean")

-- Settings
getgenv().Settings = {
    Aimbot = false,
    AimbotKey = Enum.KeyCode.E,
    AimbotSmoothness = 1,
    AimbotFOV = 200,
    ESPEnabled = false,
    BoxESP = false,
    NameESP = false,
    HealthESP = false,
    TracerESP = false,
    TeamCheck = true,
    RainbowGun = false,
    NoRecoil = false,
    InfiniteAmmo = false,
    TriggerBot = false,
    SilentAim = false,
    RapidFire = false,
    NoSpread = false,
    WallBang = false,
    AutoShoot = false,
    BunnyHop = false,
    SpeedHack = false
}

-- Create Tabs
local AimbotTab = Window:NewTab("Aimbot")
local VisualTab = Window:NewTab("Visuals")
local GunModsTab = Window:NewTab("Gun Mods")
local PlayerTab = Window:NewTab("Player")
local MiscTab = Window:NewTab("Misc")
local CreditsTab = Window:NewTab("Credits")

-- Create Sections
local AimbotSection = AimbotTab:NewSection("Aimbot Settings")
local VisualSection = VisualTab:NewSection("ESP Settings")
local GunSection = GunModsTab:NewSection("Gun Modifications")
local PlayerSection = PlayerTab:NewSection("Player Modifications")
local MiscSection = MiscTab:NewSection("Misc Features")
local CreditsSection = CreditsTab:NewSection("Script Information")

-- ESP Configuration
ESP:Toggle(true)
ESP.TeamColor = true
ESP.Names = false
ESP.Boxes = false
ESP.Tracers = false
ESP.Health = false

-- Aimbot Functions
local function GetClosestPlayer()
    local MaxDistance = getgenv().Settings.AimbotFOV
    local Target = nil
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            if getgenv().Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local ScreenPoint = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
            local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
            
            if VectorDistance < MaxDistance then
                MaxDistance = VectorDistance
                Target = v
            end
        end
    end
    
    return Target
end

-- Aimbot Toggle
AimbotSection:NewToggle("Enable Aimbot", "Toggles aimbot on/off", function(state)
    getgenv().Settings.Aimbot = state
end)

-- Silent Aim Toggle
AimbotSection:NewToggle("Silent Aim", "Toggles silent aim on/off", function(state)
    getgenv().Settings.SilentAim = state
end)

-- Trigger Bot Toggle
AimbotSection:NewToggle("Trigger Bot", "Automatically shoots when aiming at enemy", function(state)
    getgenv().Settings.TriggerBot = state
end)

-- Aimbot Key Bind
AimbotSection:NewKeybind("Aimbot Key", "Key to activate aimbot", Enum.KeyCode.E, function(key)
    getgenv().Settings.AimbotKey = key
end)

-- Aimbot FOV
AimbotSection:NewSlider("Aimbot FOV", "Adjust aimbot field of view", 500, 10, function(value)
    getgenv().Settings.AimbotFOV = value
end)

-- Aimbot Smoothness
AimbotSection:NewSlider("Smoothness", "Adjust aimbot smoothness", 10, 1, function(value)
    getgenv().Settings.AimbotSmoothness = value
end)

-- Visual Settings
VisualSection:NewToggle("Box ESP", "Shows boxes around players", function(state)
    getgenv().Settings.BoxESP = state
    ESP.Boxes = state
end)

VisualSection:NewToggle("Name ESP", "Shows player names", function(state)
    getgenv().Settings.NameESP = state
    ESP.Names = state
end)

VisualSection:NewToggle("Health ESP", "Shows player health", function(state)
    getgenv().Settings.HealthESP = state
    ESP.Health = state
end)

VisualSection:NewToggle("Tracer ESP", "Shows lines to players", function(state)
    getgenv().Settings.TracerESP = state
    ESP.Tracers = state
end)

-- Gun Modifications
GunSection:NewToggle("No Recoil", "Removes weapon recoil", function(state)
    getgenv().Settings.NoRecoil = state
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    
    if state then
        mt.__index = newcclosure(function(self, k)
            if k == "Recoil" or k == "RecoilMax" then
                return 0
            end
            return oldIndex(self, k)
        end)
    else
        mt.__index = oldIndex
    end
    
    setreadonly(mt, true)
end)

GunSection:NewToggle("No Spread", "Removes weapon spread", function(state)
    getgenv().Settings.NoSpread = state
    -- Implementation specific to Reimagined Blox
end)

GunSection:NewToggle("Rapid Fire", "Increases fire rate", function(state)
    getgenv().Settings.RapidFire = state
    -- Implementation specific to Reimagined Blox
end)

GunSection:NewToggle("Wall Bang", "Shoot through walls", function(state)
    getgenv().Settings.WallBang = state
    -- Implementation specific to Reimagined Blox
end)

GunSection:NewToggle("Infinite Ammo", "Never run out of ammo", function(state)
    getgenv().Settings.InfiniteAmmo = state
    -- Implementation specific to Reimagined Blox
end)

-- Player Modifications
PlayerSection:NewToggle("Bunny Hop", "Auto jump when moving", function(state)
    getgenv().Settings.BunnyHop = state
    
    if state then
        RunService.Heartbeat:Connect(function()
            if getgenv().Settings.BunnyHop and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end
end)

PlayerSection:NewToggle("Speed Hack", "Increase movement speed", function(state)
    getgenv().Settings.SpeedHack = state
    
    if state then
        RunService.RenderStepped:Connect(function()
            if getgenv().Settings.SpeedHack and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 32
                end
            end
        end)
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end)

-- Misc Features
MiscSection:NewToggle("Team Check", "Check if player is on your team", function(state)
    getgenv().Settings.TeamCheck = state
    ESP.TeamColor = state
end)

MiscSection:NewToggle("Auto Shoot", "Automatically shoot when target acquired", function(state)
    getgenv().Settings.AutoShoot = state
end)

-- Credits
CreditsSection:NewLabel("Script by: kvkfjf")
CreditsSection:NewLabel("UI Library: Kavo UI")
CreditsSection:NewLabel("ESP Library: Kiriot22")
CreditsSection:NewButton("Copy Discord", "Copies Discord invite to clipboard", function()
    setclipboard("discord.gg/S7qUMBNq6f")
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.Aimbot and UserInputService:IsKeyDown(getgenv().Settings.AimbotKey) then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local TargetPos = Target.Character.Head.Position
            local ScreenPos = Camera:WorldToScreenPoint(TargetPos)
            local MousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
            local NewPos = Vector2.new(
                MousePos.X + (ScreenPos.X - MousePos.X) / getgenv().Settings.AimbotSmoothness,
                MousePos.Y + (ScreenPos.Y - MousePos.Y) / getgenv().Settings.AimbotSmoothness
            )
            mousemoverel(
                (ScreenPos.X - MousePos.X) / getgenv().Settings.AimbotSmoothness,
                (ScreenPos.Y - MousePos.Y) / getgenv().Settings.AimbotSmoothness
            )
        end
    end
end)

-- Initialize
ESP:Toggle(true)
print("🎯 Butt3rL3aks | Counter Blox Reimagined loaded successfully!")
