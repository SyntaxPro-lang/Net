--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientNetwork = {}
local listeners = {
	Remotes = {},
	Functions = {},
}

local function getEvent(eventName: string)
	local object = ReplicatedStorage.Events.Remotes:FindFirstChild(eventName)
		or ReplicatedStorage.Events.Functions:FindFirstChild(eventName)
	return object
end

function ClientNetwork:Send(eventName: string, data: any)
	getEvent(eventName):FireServer(data)
end

function ClientNetwork:On(eventName: string, callback)
	if not listeners.Remotes[eventName] then
		local newListener = getEvent(eventName)
		newListener.OnClientEvent:Connect(function(data: any)
			callback(data)
		end)
		listeners.Remotes[eventName] = newListener
	end
end

-----------------------------------------[[
-- REMOTE FUNCTIONS
----------------------------------------]]

function ClientNetwork:OnClientInvoke(eventName: string, callback: (...any) -> ())
	print(eventName)
	if not listeners.Functions[eventName] then
		local newListener: RemoteFunction = getEvent(eventName)
		newListener.OnClientInvoke = callback
		listeners.Functions[eventName] = newListener
	end
end

function ClientNetwork:InvokeServer(eventName: string, ...: any)
	return getEvent(eventName):InvokeServer(...)
end

return ClientNetwork
