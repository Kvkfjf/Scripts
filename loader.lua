--[[
    🧈 Butt3rL3aks Hub | Main Loader
    Made by kvkfjf
    Join our Discord: https://discord.gg/S7qUMBNq6f
]]

-- Services
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

-- Simple Notification Function
local function Notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5
    })
end

-- Anti AFK
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Available Scripts
local Scripts = {
    ["Counter Blox"] = "CounterBlox.lua",
    ["Reimagined Blox"] = "ReimaginedBlox.lua",
    ["Pet Simulator 99"] = "PetSimulator99.lua",
    ["Muscle Legends"] = "MuscleLegends.lua",
    ["Race Clicker"] = "RaceClicker.lua",
    ["Lifting Simulator"] = "LiftingSimulator.lua"
}

-- GitHub Repository Information
local GitHubInfo = {
    Owner = "Kvkfjf",
    Repo = "Scripts",
    Branch = "main"
}

-- Function to get raw GitHub content URL
local function GetGitHubUrl(filename)
    return string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/%s",
        GitHubInfo.Owner,
        GitHubInfo.Repo,
        GitHubInfo.Branch,
        filename
    )
end

-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🧈 Butt3rL3aks Hub | Loader", "Ocean")

-- Create Main Tab
local MainTab = Window:NewTab("Scripts")
local MainSection = MainTab:NewSection("Select Script")

-- Create Info Tab
local InfoTab = Window:NewTab("Info")
local InfoSection = InfoTab:NewSection("Information")

-- Add Script Buttons
for scriptName, scriptFile in pairs(Scripts) do
    MainSection:NewButton(scriptName, "Load " .. scriptName .. " script", function()
        -- Show loading notification
        Notify("Loading...", "Loading " .. scriptName .. "...", 3)
        
        -- Load script from GitHub
        local success, err = pcall(function()
            loadstring(game:HttpGet(GetGitHubUrl(scriptFile)))()
        end)
        
        if not success then
            Notify("Error", "Failed to load script: " .. tostring(err), 10)
            return false
        end
        
        Notify("Success!", scriptName .. " loaded successfully!", 5)
    end)
end

-- Add Information
InfoSection:NewLabel("Script by: kvkfjf")
InfoSection:NewLabel("The best discord:Butt3rL3aks ")
InfoSection:NewButton("Copy Discord", "Copies Discord invite to clipboard", function()
    setclipboard("discord.gg/S7qUMBNq6f")
end)
InfoSection:NewButton("GitHub Repository", "Opens GitHub repository", function()
    setclipboard("https://github.com/Kvkfjf/Scripts")
    Notify("GitHub", "Repository URL copied to clipboard!", 3)
end)

-- Welcome Message
Notify("Welcome!", "Welcome to Butt3rL3aks Hub!", 3)
