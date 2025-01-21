--[[
    🐾 Butt3rL3aks | Pet Simulator 99
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
local Window = Library.CreateLib("🐾 Butt3rL3aks | Pet Simulator 99", "Ocean")

-- Settings
getgenv().Settings = {
    AutoFarm = false,
    AutoCollect = false,
    AutoHatch = false,
    AutoCraft = false,
    SelectedEgg = "Basic",
    HatchAmount = "Single", -- Single or Triple
    AutoEquipBest = false,
    FarmSelectedCoin = false,
    SelectedCoin = "Coins",
    AutoCollectLootbags = false
}

-- Create Tabs
local FarmingTab = Window:NewTab("Farming")
local EggsTab = Window:NewTab("Eggs")
local PetsTab = Window:NewTab("Pets")
local MiscTab = Window:NewTab("Misc")
local CreditsTab = Window:NewTab("Credits")

-- Create Sections
local FarmingSection = FarmingTab:NewSection("Auto Farm")
local EggsSection = EggsTab:NewSection("Auto Hatch")
local PetsSection = PetsTab:NewSection("Pet Management")
local MiscSection = MiscTab:NewSection("Misc Options")
local CreditsSection = CreditsTab:NewSection("Script Information")

-- Functions
local function GetCoins()
    local coins = {}
    for _, v in pairs(workspace.__THINGS.Coins:GetChildren()) do
        if v:IsA("Part") and v:FindFirstChild("Coin") then
            table.insert(coins, v)
        end
    end
    return coins
end

local function GetClosestCoin()
    local closest = nil
    local minDistance = math.huge
    
    for _, coin in pairs(GetCoins()) do
        if coin and coin:FindFirstChild("Coin") then
            local distance = (Character.HumanoidRootPart.Position - coin.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                closest = coin
            end
        end
    end
    return closest
end

-- Auto Farm
FarmingSection:NewToggle("🌟 Auto Farm", "Automatically farms coins", function(state)
    getgenv().Settings.AutoFarm = state
    while getgenv().Settings.AutoFarm and task.wait() do
        local coin = GetClosestCoin()
        if coin then
            -- Send pet to coin
            local args = {
                [1] = coin:GetAttribute("ID")
            }
            ReplicatedStorage.Network.Pets_AttackCoin:FireServer(unpack(args))
        end
    end
end)

-- Auto Collect
FarmingSection:NewToggle("💰 Auto Collect", "Automatically collects all items", function(state)
    getgenv().Settings.AutoCollect = state
    while getgenv().Settings.AutoCollect and task.wait() do
        for _, v in pairs(workspace.__THINGS.Orbs:GetChildren()) do
            v.CFrame = Character.HumanoidRootPart.CFrame
        end
        for _, v in pairs(workspace.__THINGS.Lootbags:GetChildren()) do
            v.CFrame = Character.HumanoidRootPart.CFrame
        end
    end
end)

-- Auto Hatch
local eggs = {
    "Basic", "Rare", "Epic", "Legendary", "Mythical"
}

local eggDropdown = EggsSection:NewDropdown("🥚 Select Egg", "Select which egg to hatch", eggs, function(currentOption)
    getgenv().Settings.SelectedEgg = currentOption
end)

EggsSection:NewToggle("🐣 Auto Hatch", "Automatically hatches eggs", function(state)
    getgenv().Settings.AutoHatch = state
    while getgenv().Settings.AutoHatch and task.wait(1) do
        local args = {
            [1] = getgenv().Settings.SelectedEgg,
            [2] = getgenv().Settings.HatchAmount
        }
        ReplicatedStorage.Network.Eggs_RequestPurchase:InvokeServer(unpack(args))
    end
end)

EggsSection:NewDropdown("🔢 Hatch Amount", "Select hatch amount", {"Single", "Triple"}, function(currentOption)
    getgenv().Settings.HatchAmount = currentOption
end)

-- Pet Management
PetsSection:NewToggle("⭐ Auto Equip Best", "Automatically equips best pets", function(state)
    getgenv().Settings.AutoEquipBest = state
    while getgenv().Settings.AutoEquipBest and task.wait(1) do
        ReplicatedStorage.Network.Pets_EquipBest:FireServer()
    end
end)

PetsSection:NewToggle("🔄 Auto Craft All", "Automatically crafts all pets", function(state)
    getgenv().Settings.AutoCraft = state
    while getgenv().Settings.AutoCraft and task.wait(1) do
        ReplicatedStorage.Network.Pets_CraftAll:FireServer()
    end
end)

-- Misc Features
MiscSection:NewButton("🎁 Claim All Rewards", "Claims all available rewards", function()
    ReplicatedStorage.Network.Rewards_ClaimAll:FireServer()
end)

MiscSection:NewToggle("🎒 Auto Collect Lootbags", "Automatically collects lootbags", function(state)
    getgenv().Settings.AutoCollectLootbags = state
    while getgenv().Settings.AutoCollectLootbags and task.wait() do
        for _, v in pairs(workspace.__THINGS.Lootbags:GetChildren()) do
            v.CFrame = Character.HumanoidRootPart.CFrame
        end
    end
end)

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
Library:Notify("Script Loaded!", "Butt3rL3aks Pet Simulator 99 script is ready!", 5)
