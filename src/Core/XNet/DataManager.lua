-- Module --
local DataManager = {}
local Remotes = {
	RemoteEvents = {},
	RemoteFunctions = {},
}
local DataEnums = {}
DataManager.__index = DataManager

-- Variables --
local RemoteTypes = script.Parent.RemoteTypes

local RemoteEvent = require(RemoteTypes.RemoteEvent)

-- Types --
export type SelfType = typeof(DataManager)
export type APIType = SelfType
export type RemoteEventType = RemoteEvent.APIType

-- Module Functions --
function DataManager.CreateDataEnum(name: string, children: { string })
	if DataEnums[name] then
		return DataEnums[name]
	end

	DataEnums[name] = {}

	for i, child in children do
		DataEnums[name][child] = i
	end

	return DataEnums[name]
end

function DataManager.ToDataEnum(enumName: string, child: string): number
	return DataEnums[enumName][child]
end

function DataManager.FromDataEnum(enumName: string, enumChild: number): string
	for childName, childIdentificator in DataEnums[enumName] do
		if enumChild == childIdentificator then
			return childName
		end
	end

	return ""
end

function DataManager.CreateRemoteEvent(name: string): RemoteEvent.SelfType
	if Remotes.RemoteEvents[name] then
		return Remotes.RemoteEvents[name]
	end

	local newRemote = RemoteEvent.CreateRemoteEvent(name)
	Remotes.RemoteEvents[name] = newRemote

	return newRemote
end

-- End --
return DataManager
