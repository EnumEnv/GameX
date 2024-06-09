-- Services --
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

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
local Array = require(DataTypes.Array)
local String = require(DataTypes.String)
local Boolean = require(DataTypes.Boolean)

-- Module Functions --
function RemoteEvent.CreateRemoteEvent(name: string): SelfType
	local self = {}
	local newRemote = Instance.new("RemoteEvent")

	self.name = name
	self.remote = newRemote

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

			if typeof(data) == "string" then
				if string.sub(data, 1, 1) == ">" then
					decodedDataInstance = string.sub(data, 2, #data)
				else
					decodedDataInstance = String.Deoptimize(data)
				end
			elseif typeof(data) == "number" then
				decodedDataInstance = data
			else
				decodedDataInstance = data
			end

			decodedData[index+1] = decodedDataInstance
		end

		callback(table.unpack(decodedData))
	end)
end

function RemoteEvent.SendData(self: SelfType, ...)
	local data = table.pack(...)
	local optimizedData = Array.AutoOptimize(data)
	optimizedData = HttpService:JSONEncode(optimizedData)

	self.remote:FireServer(optimizedData)
end

-- End --
return RemoteEvent
