-- Manager Info --
local ControllerManager = {}
ControllerManager.__index = ControllerManager

-- Variables --
local TaskThreadManager = require(script.Parent.Parent.TaskThreadManager)

-- Tables --
local RegisteredControllers = {}

-- Types --
export type SelfType = typeof(ControllerManager) & {
	_name: string,
}

export type XController = {
	Begin: () -> (),
	LocalCharacterAdded: (Character: Model?) -> Model,
}

-- Module Functions --

--[=[
    Creates a new controller manager instance.
    
    @param name string: The unique name for the controller.
    @param module ModuleScript: The module script associated with the controller.
    @return SelfType: A new instance of ControllerManager.
]=]
function ControllerManager.new(name: string): SelfType
	local self = {
		_name = name,
	}

	return setmetatable(self, ControllerManager) :: any
end

--[=[
    Registers the controller.
    @return void    
--]=]
function ControllerManager.Register(self: SelfType)
	assert(self["_name"], "Couldn't find self._name.")

	RegisteredControllers[self._name] = {}
end

--[=[
    Starts the controller.

    @return self SelfType -- The ControllerManager Instance
--]=]
function ControllerManager.Start(self: SelfType, client: Player)
	assert(RegisteredControllers[self._name], "Controller of name", self._name, "isn't registered. Can't be started.")

	local controllerFailed = false

	TaskThreadManager.CreateTask(self._name)
	TaskThreadManager.BindFunctionToTask(self._name, function()
		local a, _ = pcall(function()
			assert(
				RegisteredControllers[self._name].Begin,
				"Controller of name",
				self._name,
				"doesn't contain the ':Begin()' function, therefore it will be cleared from the memory and ignored."
			)
		end)

		if not a then
			controllerFailed = true

			RegisteredControllers[self._name] = nil

			TaskThreadManager.StopTask(self._name, true)

			if TaskThreadManager.TaskExists(self._name .. "_" .. "LocalCharacterAdded") then
				TaskThreadManager.StopTask(self._name .. "_" .. "LocalCharacterAdded", true)
			end

			return
		end

		RegisteredControllers[self._name]:Begin()
	end)

	if not controllerFailed then
		TaskThreadManager.StartTask(self._name)
	end

	if RegisteredControllers[self._name]["LocalCharacterAdded"] and not controllerFailed then
		TaskThreadManager.CreateTask(self._name .. "_" .. "LocalCharacterAdded")
		TaskThreadManager.BindFunctionToTask(self._name .. "_" .. "LocalCharacterAdded", function()
			if client.Character then
				RegisteredControllers[self._name]:LocalCharacterAdded(client.Character)
			end

			client.CharacterAdded:Connect(function(character)
				RegisteredControllers[self._name]:LocalCharacterAdded(client.Character)
			end)
		end)
		TaskThreadManager.StartTask(self._name .. "_" .. "LocalCharacterAdded")
	end
end

--[=[
	Returns a Controller that can be edited and used.
    
	@return XController
--]=]
function ControllerManager.GetUseableController(self: SelfType): XController
	return RegisteredControllers[self._name]
end

--[=[
    Retrieves the registered controller by name.
    
    @param name string: The unique name of the controller.
    @return XController | nil: The registered controller if found, otherwise nil.
]=]
function ControllerManager.GetController(name: string): XController | nil
	if not RegisteredControllers[name] then
		warn("Controller of name:", name, "doesn't exist.")
		return
	end

	return RegisteredControllers[name]
end

-- End --
return ControllerManager
