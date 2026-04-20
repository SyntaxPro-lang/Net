--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerNetwork = {}
local listeners = {
	Remotes = {},
	Functions = {},
}

local function getEvent(eventName: string, unreliable: boolean?)
	local object = ReplicatedStorage.Events.Remotes:FindFirstChild(eventName) or ReplicatedStorage.Events.Functions:FindFirstChild(eventName)

	if object == nil then
		if unreliable then
			object = Instance.new("UnreliableRemoteEvent")
		elseif unreliable == false then
			object = Instance.new("RemoteEvent")
		else
			object = Instance.new("RemoteFunction")
			object.Parent = ReplicatedStorage.Events.Functions
			return object
		end
		object.Parent = ReplicatedStorage.Events.Remotes
		object.Name = eventName
	end

	return object
end

function ServerNetwork:On(eventName: string, callback, isReliable: boolean)
	if not listeners.Remotes[eventName] then
		local newListener: RemoteEvent = getEvent(eventName, isReliable)
		newListener.OnServerEvent:Connect(function(player: Player, data: any)
			callback(player, data)
		end)
		listeners.Remotes[newListener] = newListener
	end
end

function ServerNetwork:Send(target: Player | Instance, eventName: string, data: any, isReliable: boolean)
	local event = getEvent(eventName, isReliable)
	if target == nil then
		event:FireAllClients(data)
		return
	end
	if typeof(target) == "table" then
		for _, player in target do
			event:FireClient(player, data)
		end
		return
	else
		event:FireClient(target, data)
		return
	end
end

-----------------------------------------[[
-- REMOTE FUNCTIONS
----------------------------------------]]

function ServerNetwork:Invoke(target: Player, eventName: string, callback: (args: any) -> ())
	if not listeners.Functions[eventName] then
		local newListener: RemoteFunction = getEvent(eventName, nil)
		newListener.OnServerInvoke = callback()
		listeners.Functions[newListener] = newListener
	end
end

return ServerNetwork
