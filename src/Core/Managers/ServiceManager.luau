--[=[
	-- OUTDATED DOCUMENTATION --

    The `ServiceManager` module is responsible for managing and orchestrating services within an application.
    It allows for the registration, starting, and retrieval of services. Services are tied to tasks managed
    by the `TaskThreadManager` module.

    Functions:
        - ServiceManager.new(name: string, module: ModuleScript): Creates a new service manager instance.
        - ServiceManager.Register(self: SelfType): Registers the service with the given name and module.
        - ServiceManager.Start(self: SelfType): Starts the registered service.
        - ServiceManager.GetService(name: string): Retrieves the registered service by name.

    Types:
        - SelfType: The type representing the service manager instance.
        - XService: The type representing a service with specific methods (Begin, PlayerAdded, PlayerRemoving).
]=]

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
}

export type XService = {
	Begin: () -> (),
	PlayerAdded: (Player) -> Player?,
	PlayerRemoving: (Player) -> Player?,
}

-- Module Functions --

--[=[
    Creates a new service manager instance.
    
    @param name string: The unique name for the service.
    @param module ModuleScript: The module script associated with the service.
    @return SelfType: A new instance of ServiceManager.
]=]
function ServiceManager.new(name: string): SelfType
	local self = {
		_name = name,
	}

	return setmetatable(self, ServiceManager) :: any
end

--[=[
    Registers the service with the given name and module.
    
    @param self SelfType: The service manager instance.
]=]
function ServiceManager.Register(self: SelfType)
	assert(self["_name"], "Couldn't find self._name.")

	RegisteredServices[self._name] = {}
end

--[=[
    Starts the registered service.
    
    @param self SelfType: The service manager instance.
]=]
function ServiceManager.Start(self: SelfType)
	assert(RegisteredServices[self._name], "Service of name", self._name, "isn't registered. Can't be started.")

	TaskThreadManager.CreateTask(self._name)
	TaskThreadManager.BindFunctionToTask(self._name, function()
		RegisteredServices[self._name]:Begin()
	end)
	TaskThreadManager.StartTask(self._name)
end

--[=[
	Returns a service that can be edited and used.
	@return XService
--]=]
function ServiceManager.GetUseableService(self: SelfType): XService
	return RegisteredServices[self._name]
end

--[=[
    Retrieves the registered service by name.
    
    @param name string: The unique name of the service.
    @return XService | nil: The registered service if found, otherwise nil.
]=]
function ServiceManager.GetService(name: string): XService | nil
	if not RegisteredServices[name] then
		warn("Service of name:", name, "doesn't exist.")
		return
	end

	return RegisteredServices[name]
end

-- End --
return ServiceManager
