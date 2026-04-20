local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Simple = require(ReplicatedStorage.FormatNumber.Simple)
local Networking = require(ReplicatedStorage.Networking)

local LOCALPLAYER = Players.LocalPlayer
local PLAYERGUI = LOCALPLAYER.PlayerGui
local CashLabel = PLAYERGUI:WaitForChild("ScreenGui"):WaitForChild("TextLabel")

local originalCash = 0

Networking.client:On("CashUpdate", function(data)
    if originalCash < data then
        originalCash = data
    end
    CashLabel.Text = `${Simple.FormatCompact(data)}`
end)