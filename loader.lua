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
    ["Race Clicker"] = "RaceClicker.lua"
}

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
        Notify("Loading...", "Loading script for " .. scriptName, 3)
        
        -- Load game script from local file
        local scriptPath = "ButterLeaks/Games/" .. scriptFile
        local success, err = pcall(function()
            loadstring(readfile(scriptPath))()
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
InfoSection:NewLabel("UI Library: Kavo UI")
InfoSection:NewButton("Copy Discord", "Copies Discord invite to clipboard", function()
    setclipboard("discord.gg/S7qUMBNq6f")
end)

-- Welcome Message
Notify("Welcome!", "Welcome to Butt3rL3aks Hub!", 3)
