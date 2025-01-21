--[[
    🏋️ Butt3rL3aks | Muscle Legends
    Made by kvkfjf
    Join our Discord: https://discord.gg/S7qUMBNq6f
]]

-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Create Window
local Window = Library.CreateLib("🏋️ Butt3rL3aks | Muscle Legends", "Ocean")

-- Settings
getgenv().Settings = {
    AutoTrain = false,
    AutoRebirth = false,
    AutoEquipBestWeights = false,
    AutoCollectChests = false,
    AutoPunch = false,
    FarmBosses = false
}

-- Create Tabs
local FarmingTab = Window:NewTab("Auto Farm")
local TeleportTab = Window:NewTab("Teleports")
local MiscTab = Window:NewTab("Misc")
local CreditsTab = Window:NewTab("Credits")

-- Create Sections
local TrainingSection = FarmingTab:NewSection("Training")
local BossSection = FarmingTab:NewSection("Boss Farm")
local TeleportSection = TeleportTab:NewSection("Locations")
local MiscSection = MiscTab:NewSection("Misc Options")
local CreditsSection = CreditsTab:NewSection("Script Information")

-- Auto Train Function
TrainingSection:NewToggle("🏋️ Auto Train", "Automatically trains your strength", function(state)
    getgenv().Settings.AutoTrain = state
    while getgenv().Settings.AutoTrain and task.wait() do
        local args = {
            [1] = "rep"
        }
        ReplicatedStorage.Events.Train:FireServer(unpack(args))
    end
end)

-- Auto Rebirth Function
TrainingSection:NewToggle("🔄 Auto Rebirth", "Automatically rebirths when possible", function(state)
    getgenv().Settings.AutoRebirth = state
    while getgenv().Settings.AutoRebirth and task.wait(1) do
        ReplicatedStorage.Events.Rebirth:FireServer()
    end
end)

-- Auto Equip Best Weights
TrainingSection:NewToggle("💪 Auto Equip Best", "Automatically equips best weights", function(state)
    getgenv().Settings.AutoEquipBestWeights = state
    while getgenv().Settings.AutoEquipBestWeights and task.wait(1) do
        ReplicatedStorage.Events.EquipBest:FireServer()
    end
end)

-- Auto Punch Function
TrainingSection:NewToggle("👊 Auto Punch", "Automatically punches", function(state)
    getgenv().Settings.AutoPunch = state
    while getgenv().Settings.AutoPunch and task.wait() do
        ReplicatedStorage.Events.Punch:FireServer()
    end
end)

-- Auto Collect Chests
MiscSection:NewToggle("📦 Auto Collect Chests", "Automatically collects chests", function(state)
    getgenv().Settings.AutoCollectChests = state
    while getgenv().Settings.AutoCollectChests and task.wait(1) do
        for _, v in pairs(workspace.Chests:GetChildren()) do
            if v:FindFirstChild("TouchInterest") then
                firetouchinterest(Player.Character.HumanoidRootPart, v, 0)
                task.wait()
                firetouchinterest(Player.Character.HumanoidRootPart, v, 1)
            end
        end
    end
end)

-- Boss Farm
BossSection:NewToggle("👊 Farm All Bosses", "Automatically farms all bosses", function(state)
    getgenv().Settings.FarmBosses = state
    while getgenv().Settings.FarmBosses and task.wait() do
        for _, boss in pairs(workspace.BossFolder:GetChildren()) do
            if boss:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                ReplicatedStorage.Events.Punch:FireServer()
            end
        end
    end
end)

-- Teleport Locations
local locations = {
    ["🏃 Spawn"] = CFrame.new(0, 10, 0),
    ["💪 Muscle Island"] = CFrame.new(4000, 10, 0),
    ["🏋️ Strength Zone"] = CFrame.new(-2000, 10, 0),
    ["👊 Fighting Area"] = CFrame.new(0, 10, 2000),
    ["🏆 Legend Arena"] = CFrame.new(2000, 10, 2000)
}

for name, cframe in pairs(locations) do
    TeleportSection:NewButton(name, "Teleport to " .. name, function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = cframe
        end
    end)
end

-- Add Credits
CreditsSection:NewLabel("Created by: kvkfjf")
CreditsSection:NewLabel("Discord: discord.gg/S7qUMBNq6f")
CreditsSection:NewButton("Copy Discord Link", "Copies Discord link to clipboard", function()
    setclipboard("https://discord.gg/S7qUMBNq6f")
end)
CreditsSection:NewLabel("Thanks for using Butt3rL3aks!")

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Initial Notification
Library:Notify("Script Loaded!", "Butt3rL3aks Muscle Legends script is ready!", 5)
