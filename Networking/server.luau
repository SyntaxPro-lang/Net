--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(script.Parent.Registry)

local ServerNetwork = {}
local listeners = {
	Remotes = {},
	Functions = {},
}

local function getEvent(eventName: string)
	local object = ReplicatedStorage.Events.Remotes:FindFirstChild(eventName)
		or ReplicatedStorage.Events.Functions:FindFirstChild(eventName)

	return object
end

-- CALL ONCE IN SERVER
function ServerNetwork.Register()
	for _, remote in Registry.Remotes do
		if ReplicatedStorage.Events.Remotes:FindFirstChild(remote) then
			continue
		end
		local object = Instance.new("RemoteEvent")
		object.Parent = ReplicatedStorage.Events.Remotes
		object.Name = remote
	end
	for _, remoteFunction in Registry.Functions do
		if ReplicatedStorage.Events.Functions:FindFirstChild(remoteFunction) then
			continue
		end
		local object = Instance.new("RemoteFunction")
		object.Parent = ReplicatedStorage.Events.Functions
		object.Name = remoteFunction
	end
end

function ServerNetwork:On(eventName: string, callback: (A: any, B: any) -> ())
	if not listeners.Remotes[eventName] then
		local newListener = getEvent(eventName)

		newListener.OnServerEvent:Connect(function(player: Player, data: any)
			callback(player, data)
		end)
		listeners.Remotes[eventName] = newListener
	end
end

function ServerNetwork:Send(target: Player | Instance, eventName: string, data: any)
	local event = getEvent(eventName)
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

function ServerNetwork:OnServerInvoke(eventName: string, callback: (Player, ...any) -> ())
	if not listeners.Functions[eventName] then
		local newListener: RemoteFunction = getEvent(eventName)
		newListener.OnServerInvoke = callback
		listeners.Functions[eventName] = newListener
	end
end

function ServerNetwork:InvokeClient(target: Player, eventName: string, ...: any)
	return getEvent(eventName):InvokeClient(target, ...)
end

return ServerNetwork
