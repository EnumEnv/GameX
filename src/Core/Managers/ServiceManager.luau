-- Manager Info --
local ServiceManager = {}
ServiceManager.__index = ServiceManager

-- Variables --
local TaskThreadManager = require(script.Parent.Parent.TaskThreadManager)

-- Tables --
local RegisteredServices = {}

-- Types --
export type SelfType = typeof(ServiceManager) & {
	_name: string,
	_module: ModuleScript,
}

export type XService = {
	Begin: () -> (),
	PlayerAdded: (Player) -> Player?,
	PlayerRemoving: (Player) -> Player?,
}

-- Module Functions --
function ServiceManager.new(name: string, module: ModuleScript): SelfType
	local self = {
		_name = name,
		_module = module,
	}

	return setmetatable(self, ServiceManager) :: any
end

function ServiceManager.Register(self: SelfType)
	assert(self["_name"], "Couldn't find self._name.")
	assert(self["_module"], "Couldn't find self._module.")

	RegisteredServices[self._name] = require(self._module)
end

function ServiceManager.Start(self: SelfType) end

function ServiceManager.GetService(self: SelfType, name: string): XService | nil
	if not RegisteredServices[name] then
		warn("Service of name:", name, "doesn't exist.")
		return
	end

	return RegisteredServices[name]
end

-- End --
return ServiceManager
