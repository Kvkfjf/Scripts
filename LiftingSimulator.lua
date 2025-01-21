--[[
    💪 Butt3rL3aks | Lifting Simulator
    Made by kvkfjf
    Join our Discord: https://discord.gg/S7qUMBNq6f
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("💪 Butt3rL3aks | Lifting Simulator", "Ocean")

-- Settings
getgenv().Settings = {
    AutoLift = false,
    AutoSell = false,
    AutoBuyWeights = false,
    AutoClaimRewards = false,
    AutoRebirth = false,
    WalkSpeed = 16,
    JumpPower = 50,
    NoClip = false,
    InfiniteJump = false,
    AutoCollectGems = false
}

-- Create Tabs
local FarmingTab = Window:NewTab("Farming")
local PlayerTab = Window:NewTab("Player")
local MiscTab = Window:NewTab("Misc")
local CreditsTab = Window:NewTab("Credits")

-- Create Sections
local FarmingSection = FarmingTab:NewSection("Auto Farm")
local PlayerSection = PlayerTab:NewSection("Player Mods")
local MiscSection = MiscTab:NewSection("Misc Features")
local CreditsSection = CreditsTab:NewSection("Script Information")

-- Functions
local function GetRemote(name)
    return ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild(name)
end

local function GetClosestGem()
    local closest = nil
    local maxDistance = 50
    local position = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if position then
        for _, gem in pairs(workspace:GetChildren()) do
            if gem:IsA("BasePart") and gem.Name == "Gem" then
                local distance = (gem.Position - position.Position).Magnitude
                if distance < maxDistance then
                    maxDistance = distance
                    closest = gem
                end
            end
        end
    end
    return closest
end

-- Farming Section
FarmingSection:NewToggle("Auto Lift", "Automatically lifts weights", function(state)
    getgenv().Settings.AutoLift = state
    
    while getgenv().Settings.AutoLift and task.wait() do
        local liftRemote = GetRemote("Lift")
        if liftRemote then
            liftRemote:FireServer()
        end
    end
end)

FarmingSection:NewToggle("Auto Sell", "Automatically sells strength", function(state)
    getgenv().Settings.AutoSell = state
    
    while getgenv().Settings.AutoSell and task.wait(0.5) do
        local sellRemote = GetRemote("SellStrength")
        if sellRemote then
            sellRemote:FireServer()
        end
    end
end)

FarmingSection:NewToggle("Auto Buy Weights", "Automatically buys best weights", function(state)
    getgenv().Settings.AutoBuyWeights = state
    
    while getgenv().Settings.AutoBuyWeights and task.wait(1) do
        local buyRemote = GetRemote("BuyWeight")
        if buyRemote then
            buyRemote:FireServer("BestWeight")
        end
    end
end)

FarmingSection:NewToggle("Auto Collect Gems", "Automatically collects nearby gems", function(state)
    getgenv().Settings.AutoCollectGems = state
    
    while getgenv().Settings.AutoCollectGems and task.wait() do
        local gem = GetClosestGem()
        if gem and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = gem.CFrame
            task.wait(0.1)
        end
    end
end)

FarmingSection:NewToggle("Auto Rebirth", "Automatically rebirths when possible", function(state)
    getgenv().Settings.AutoRebirth = state
    
    while getgenv().Settings.AutoRebirth and task.wait(1) do
        local rebirthRemote = GetRemote("Rebirth")
        if rebirthRemote then
            rebirthRemote:FireServer()
        end
    end
end)

-- Player Section
PlayerSection:NewSlider("Walk Speed", "Changes your walk speed", 500, 16, function(value)
    getgenv().Settings.WalkSpeed = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

PlayerSection:NewSlider("Jump Power", "Changes your jump power", 500, 50, function(value)
    getgenv().Settings.JumpPower = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

PlayerSection:NewToggle("Infinite Jump", "Allows you to jump infinitely", function(state)
    getgenv().Settings.InfiniteJump = state
end)

PlayerSection:NewToggle("NoClip", "Walk through walls", function(state)
    getgenv().Settings.NoClip = state
end)

-- Misc Section
MiscSection:NewButton("Unlock All Gamepasses", "Tries to unlock all gamepasses", function()
    local success, err = pcall(function()
        for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("BoolValue") and v.Name:lower():find("gamepass") then
                v.Value = true
            end
        end
    end)
end)

MiscSection:NewButton("Teleport to Sell", "Teleports to sell area", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") and v.Name:lower():find("sell") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                break
            end
        end
    end
end)

-- Credits
CreditsSection:NewLabel("Script by: kvkfjf")
CreditsSection:NewLabel("UI Library: Kavo UI")
CreditsSection:NewButton("Copy Discord", "Copies Discord invite to clipboard", function()
    setclipboard("discord.gg/S7qUMBNq6f")
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Infinite Jump
UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
    if getgenv().Settings.InfiniteJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if getgenv().Settings.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Character Added Handler
LocalPlayer.CharacterAdded:Connect(function(character)
    if getgenv().Settings.WalkSpeed ~= 16 then
        character:WaitForChild("Humanoid").WalkSpeed = getgenv().Settings.WalkSpeed
    end
    if getgenv().Settings.JumpPower ~= 50 then
        character:WaitForChild("Humanoid").JumpPower = getgenv().Settings.JumpPower
    end
end)

-- Initialize
print("💪 Butt3rL3aks | Lifting Simulator loaded successfully!")
