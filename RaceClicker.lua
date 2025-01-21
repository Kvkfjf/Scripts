--[[
    🏃 Butt3rL3aks | Race Clicker
    Made by kvkfjf
    Join our Discord: https://discord.gg/S7qUMBNq6f
    
    Features:
    - Ultra Click (25x)
    - Fast Acceleration
    - Auto Race
    - Teleports
    - Code Redemption
]]

-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Create Window
local Window = Library.CreateLib("🧈 Butt3rL3aks V1 | Race Clicker", "Ocean")

-- Settings
getgenv().Settings = {
    AutoClick = false,
    UltraClick = false,
    AutoRebirth = false,
    AutoRace = false,
    FastAcceleration = false,
    AutoCollectRewards = false
}

-- Available Codes
local codes = {
    "Release", "Likes10k", "Likes20k", "Likes30k", "Likes40k", "Likes50k",
    "Winter", "NewYear2024", "Valentine", "Easter2024"
}

-- Create Tabs
local FarmingTab = Window:NewTab("Auto Farm")
local RaceTab = Window:NewTab("Race")
local TeleportTab = Window:NewTab("Teleports")
local MiscTab = Window:NewTab("Misc")
local CreditsTab = Window:NewTab("Credits")

-- Create Sections
local FarmingSection = FarmingTab:NewSection("Farming Options")
local RaceSection = RaceTab:NewSection("Race Options")
local TeleportSection = TeleportTab:NewSection("Checkpoint Teleports")
local MiscSection = MiscTab:NewSection("Misc Options")
local CreditsSection = CreditsTab:NewSection("Script Information")

-- Ultra Click Function
FarmingSection:NewToggle("🚀 Ultra Click (25x)", "Clicks 25 times per frame", function(state)
    getgenv().Settings.UltraClick = state
    while getgenv().Settings.UltraClick and task.wait() do
        for i = 1, 25 do
            ReplicatedStorage.Packages.Knit.Services.ClickService.RF.Click:InvokeServer()
        end
    end
end)

-- Auto Click Function
FarmingSection:NewToggle("⚡ Auto Click (10x)", "Clicks 10 times per frame", function(state)
    getgenv().Settings.AutoClick = state
    while getgenv().Settings.AutoClick and task.wait() do
        if Player.PlayerGui.ClicksUI.ClickHelper.Visible then
            for i = 1, 10 do
                ReplicatedStorage.Packages.Knit.Services.ClickService.RF.Click:InvokeServer()
            end
        end
    end
end)

-- Auto Rebirth
FarmingSection:NewToggle("🔄 Auto Rebirth", "Automatically rebirths when possible", function(state)
    getgenv().Settings.AutoRebirth = state
    while getgenv().Settings.AutoRebirth and task.wait(0.1) do
        ReplicatedStorage.Packages.Knit.Services.RebirthService.RF.Rebirth:InvokeServer()
    end
end)

-- Fast Acceleration
RaceSection:NewToggle("💨 Fast Acceleration", "Increases your speed dramatically", function(state)
    getgenv().Settings.FastAcceleration = state
    while getgenv().Settings.FastAcceleration and task.wait() do
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = Player.Character.HumanoidRootPart
            if hrp.Velocity.Magnitude < 500 then
                hrp.Velocity = hrp.Velocity + Vector3.new(-50, 0, 0)
            end
        end
    end
end)

-- Auto Race Function
RaceSection:NewToggle("🏃 Auto Race", "Automatically completes races", function(state)
    getgenv().Settings.AutoRace = state
    while getgenv().Settings.AutoRace and task.wait() do
        if Player.PlayerGui.TimerUI.RaceTimer.Visible then
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                hrp.CFrame = hrp.CFrame - Vector3.new(50000, 0, 0)
            end
        end
    end
end)

-- Teleport Function
local function TeleportToDistance(distance)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local currentPos = hrp.Position
        hrp.CFrame = CFrame.new(currentPos - Vector3.new(distance, 0, 0))
    end
end

-- Teleport Buttons
local checkpoints = {
    {Name = "5 Wins", Distance = 5},
    {Name = "10 Wins", Distance = 10},
    {Name = "25 Wins", Distance = 25},
    {Name = "50 Wins", Distance = 50},
    {Name = "100 Wins", Distance = 100},
    {Name = "250 Wins", Distance = 250},
    {Name = "500 Wins", Distance = 500},
    {Name = "1K Wins", Distance = 1000},
    {Name = "5K Wins", Distance = 5000},
    {Name = "10K Wins", Distance = 10000}
}

for _, checkpoint in ipairs(checkpoints) do
    TeleportSection:NewButton("🚩 " .. checkpoint.Name, "Teleport to " .. checkpoint.Name, function()
        TeleportToDistance(checkpoint.Distance)
    end)
end

-- Auto Collect Rewards
MiscSection:NewToggle("🎁 Auto Collect Rewards", "Automatically collects all rewards", function(state)
    getgenv().Settings.AutoCollectRewards = state
    while getgenv().Settings.AutoCollectRewards and task.wait(0.1) do
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "TouchInterest" and v.Parent then
                firetouchinterest(Player.Character.HumanoidRootPart, v.Parent, 0)
                task.wait()
                firetouchinterest(Player.Character.HumanoidRootPart, v.Parent, 1)
            end
        end
    end
end)

-- Redeem All Codes
MiscSection:NewButton("💎 Redeem All Codes", "Redeems all available codes", function()
    for _, code in ipairs(codes) do
        ReplicatedStorage.Packages.Knit.Services.CodeService.RF.Redeem:InvokeServer(code)
        task.wait(0.5)
    end
end)

-- Add Credits
CreditsSection:NewLabel("Created by: kvkfjf")
CreditsSection:NewLabel("Discord: discord.gg/S7qUMBNq6f")
CreditsSection:NewButton("Copy Discord Link", "Copies Discord link to clipboard", function()
    setclipboard("https://discord.gg/S7qUMBNq6f")
end)
CreditsSection:NewLabel("Thanks for using Butt3rL3aks!")
