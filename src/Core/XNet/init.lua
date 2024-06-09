-- Services --
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Init --
local RemoteFunction
if RunService:IsServer() then
	RemoteFunction = Instance.new("RemoteFunction")
	RemoteFunction.Name = "XNET_REPLICATOR"
	RemoteFunction.Parent = ReplicatedStorage
end

-- Module --
local XNet = {}

-- Variables --
local DataManager = require(script.DataManager)

-- Module Functions --
function XNet.GetRemoteEvent(name: string): DataManager.APIType
	if RunService:IsClient() then
		local recievedRemote
		
		ReplicatedStorage.XNET_Replicator.OnClientInvoke = function(remote)
			recievedRemote = remote
		end
		
		ReplicatedStorage.XNET_REPLICATOR:InvokeServer(name)

		repeat
			task.wait()
		until recievedRemote

		return recievedRemote
	end

	return DataManager.CreateRemoteEvent(name)
end

if RunService:IsServer() then
	RemoteFunction.OnServerInvoke = function(player, name)
		return XNet.GetRemoteEvent(name)
	end
end

function XNet.GetDataEnum(name: string, children: { string })
	return DataManager.CreateDataEnum(name, children)
end

-- End --
return XNet
