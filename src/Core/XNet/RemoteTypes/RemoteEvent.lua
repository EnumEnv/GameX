-- Module --
local RemoteEvent = {}
RemoteEvent.__index = RemoteEvent

-- Types --
export type SelfType = typeof(RemoteEvent) & {
	name: string,
	remote: RemoteEvent,
}
export type APIType = SelfType

-- Module Functions --
function RemoteEvent.CreateRemoteEvent(name: string): SelfType
	local self = {}
	local newRemote = Instance.new("RemoteEvent")

	self.name = name
	self.remote = newRemote

	setmetatable(self, RemoteEvent)
	return self :: any
end

function RemoteEvent.SendData(self: SelfType, ...)
	-- TODO: Convert and many other stuff
	self.remote:FireServer(...)
end

-- End --
return RemoteEvent
