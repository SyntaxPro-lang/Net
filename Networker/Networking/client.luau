--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientNetwork = {}
local listeners = {}

local function getRemote(eventName: string)
	local object = ReplicatedStorage.Events.Remotes:WaitForChild(eventName) or ReplicatedStorage.Events.Functions:WaitForChild(eventName)

	return object
end

function ClientNetwork:Send(eventName: string, data: any)
	getRemote(eventName):FireServer(data)
end

function ClientNetwork:On(eventName: string, callback)
	if not listeners[eventName] then
		local newListener = getRemote(eventName)
		newListener.OnClientEvent:Connect(function(data: any)
			callback(data)
		end)
		listeners[newListener] = newListener
	end
end

return ClientNetwork
