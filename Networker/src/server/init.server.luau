local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networking = require(ReplicatedStorage.Networking)

Players.PlayerAdded:Connect(function(player)
	local cash = 0
	while true do
		cash += 100
		Networking.server:Send(nil, "CashUpdate", cash, false)
		task.wait(0.5)
	end
end)

Networking.server:On("Upgrade", function(player: Player, UpgradeName)
	print(player, UpgradeName)
end, false)
