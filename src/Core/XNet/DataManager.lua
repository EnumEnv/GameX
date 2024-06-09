-- Module --
local DataManager = {}
local Remotes = {
	RemoteEvents = {},
	RemoteFunctions = {},
}
DataManager.__index = DataManager

-- Types --
export type SelfType = typeof(DataManager)
export type APIType = SelfType

-- Variables --
local RemoteTypes = script.Parent.RemoteTypes

local RemoteEvent = require(RemoteTypes.RemoteEvent)

-- Module Functions --
function DataManager.CreateRemoteEvent(name: string): RemoteEvent.SelfType
	assert(not Remotes.RemoteEvents[name], "RemoteEvent of name", name, "already exists.")

	local newRemote = RemoteEvent.CreateRemoteEvent(name)
	Remotes.RemoteEvents[name] = newRemote
	return newRemote
end

-- End --
return DataManager
