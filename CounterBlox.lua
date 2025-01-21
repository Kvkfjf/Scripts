--[[
    🎯 Butt3rL3aks | Counter Blox
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
local Window = Library.CreateLib("🎯 Butt3rL3aks | Counter Blox", "Ocean")

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
    SilentAim = false
}

-- Create Tabs
local AimbotTab = Window:NewTab("Aimbot")
local VisualTab = Window:NewTab("Visuals")
local GunModsTab = Window:NewTab("Gun Mods")
local MiscTab = Window:NewTab("Misc")
local CreditsTab = Window:NewTab("Credits")

-- Create Sections
local AimbotSection = AimbotTab:NewSection("Aimbot Settings")
local VisualSection = VisualTab:NewSection("ESP Settings")
local GunSection = GunModsTab:NewSection("Gun Modifications")
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

-- Silent Aim
AimbotSection:NewToggle("Silent Aim", "Enables silent aim", function(state)
    getgenv().Settings.SilentAim = state
end)

-- Trigger Bot
AimbotSection:NewToggle("Trigger Bot", "Automatically shoots when aiming at enemy", function(state)
    getgenv().Settings.TriggerBot = state
end)

-- ESP Settings
VisualSection:NewToggle("Enable ESP", "Toggles ESP features", function(state)
    getgenv().Settings.ESPEnabled = state
    ESP:Toggle(state)
end)

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
end)

GunSection:NewToggle("Infinite Ammo", "Never run out of ammo", function(state)
    getgenv().Settings.InfiniteAmmo = state
end)

GunSection:NewToggle("Rainbow Gun", "Makes your gun rainbow colored", function(state)
    getgenv().Settings.RainbowGun = state
end)

-- Misc Features
MiscSection:NewToggle("Team Check", "Check if player is on your team", function(state)
    getgenv().Settings.TeamCheck = state
    ESP.TeamColor = state
end)

-- Credits
CreditsSection:NewLabel("Created by: kvkfjf")
CreditsSection:NewLabel("Discord: discord.gg/S7qUMBNq6f")
CreditsSection:NewButton("Copy Discord Link", "Copies Discord link to clipboard", function()
    setclipboard("https://discord.gg/S7qUMBNq6f")
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.Aimbot and UserInputService:IsKeyDown(getgenv().Settings.AimbotKey) then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            local HeadPos = Camera:WorldToScreenPoint(Target.Character.Head.Position)
            local MousePos = UserInputService:GetMouseLocation()
            local MoveMouseTo = (Vector2.new(HeadPos.X, HeadPos.Y) - MousePos) / getgenv().Settings.AimbotSmoothness
            mousemoverel(MoveMouseTo.X, MoveMouseTo.Y)
        end
    end
    
    if getgenv().Settings.NoRecoil then
        -- Implement no recoil logic
    end
    
    if getgenv().Settings.InfiniteAmmo then
        -- Implement infinite ammo logic
    end
    
    if getgenv().Settings.RainbowGun then
        -- Implement rainbow gun logic
    end
end)

-- Initial Notification
Library:Notify("Script Loaded!", "Butt3rL3aks Counter Blox script is ready!", 5)
