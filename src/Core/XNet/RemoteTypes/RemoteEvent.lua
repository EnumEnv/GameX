-- Services --
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Module --
local RemoteEvent = {}
RemoteEvent.__index = RemoteEvent

-- Types --
export type SelfType = typeof(RemoteEvent) & {
	name: string,
	remote: RemoteEvent,
}
export type APIType = SelfType

-- Variables --
local DataTypes = script.Parent.Parent.DataTypes
local Encoding = script.Parent.Parent.Encoding

local Array = require(DataTypes.Array)
local String = require(DataTypes.String)
local B64 = require(Encoding.B64)
--local Boolean = require(DataTypes.Boolean)

local XNetInstances = ReplicatedStorage:FindFirstChild("XNetInstances") or Instance.new("Folder")
XNetInstances.Name = "XNetInstances"
XNetInstances.Parent = ReplicatedStorage

-- Module Functions --
function RemoteEvent.CreateRemoteEvent(name: string): SelfType
	local self = {}
	local newRemote = Instance.new("RemoteEvent")
	newRemote.Parent = XNetInstances
	newRemote.Name = B64.ToB64(name)

	self.name = name
	self.remote = newRemote

	setmetatable(self, RemoteEvent)
	return self :: any
end

function RemoteEvent.CreateRemoteEventFromClient(remoteInstance: RemoteEvent): SelfType
	local self = {}

	self.name = remoteInstance.Name
	self.remote = remoteInstance

	setmetatable(self, RemoteEvent)
	return self :: any
end

function RemoteEvent.ListenForData(self: SelfType, callback: () -> ())
	local isServer = RunService:IsServer()
	local toBind = if isServer then self.remote.OnServerEvent else self.remote.OnClientEvent

	toBind:Connect(function(data1, data2)
		local decodedData = {}
		local toDecode

		if isServer then
			decodedData[1] = data1
			toDecode = data2
		else
			toDecode = data1
		end

		toDecode = HttpService:JSONDecode(toDecode)

		for index, data in toDecode do
			local decodedDataInstance

			print(data)

			if typeof(data) == "string" then
				if string.sub(data, 1, 1) == ">" then
					print("starts with >")
					decodedDataInstance = string.sub(data, 2, #data)
				else
					decodedDataInstance = String.Deoptimize(data)
				end
			elseif typeof(data) == "number" then
				decodedDataInstance = data
			else
				decodedDataInstance = data
			end

			decodedData[index + 1] = decodedDataInstance
		end

		callback(table.unpack(decodedData))
	end)
end

function RemoteEvent.SendData(self: SelfType, ...)
	local data = table.pack(...)
	local optimizedData = Array.AutoOptimize(data)
	optimizedData = HttpService:JSONEncode(optimizedData)

	if RunService:IsClient() then
		self.remote:FireServer(optimizedData)
	else
		self.remote:FireClient(optimizedData)
	end
end

-- End --
return RemoteEvent
