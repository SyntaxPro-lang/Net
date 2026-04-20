-- UPDATE ADD BUFFERING

local RunService = game:GetService("RunService")

local client = nil
local server = nil

if RunService:IsServer() then
    server = require(script.server)
else
    client = require(script.client)
end

return {
    server = server,
    client = client
}