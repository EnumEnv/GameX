-- Services --
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--[=[
    The main class for the Core of GameX.
    @class CoreX
--]=]
local CoreX = {}

-- Variables --
local Managers = script.Managers

local Signal = require(script.Signal)
local ServiceManager = require(Managers.ServiceManager)
local ControllerManager = require(Managers.ControllerManager)
local ComponentManager = require(Managers.ComponentManager)

-- Types --
export type SignalType = typeof(Signal)
export type APIType = typeof(CoreX)
export type XService = ServiceManager.XService
export type XServiceManager = typeof(ServiceManager)
export type XController = ControllerManager.XController
export type XControllerManager = typeof(ControllerManager)
export type XComponent = ComponentManager.Component
export type GameXOptions = {
	DebugModules: boolean?,
}

-- Local Functions --

--[=[
    Gets the run context of the current environment.
    @return "client" | "server" --> string
]=]
local function GetRunContext(): "client" | "server"
	return if RunService:IsClient() then "client" else "server"
end

--[=[
    Initiates modules in a directory.
    @param directory Folder: The folder containing modules to initialize.
]=]
local function InitModulesInDirectory(directory: Folder, debugModules: boolean?)
	for _, module in directory:GetChildren() do
		print(module)
		if module:IsA("Folder") then
			if debugModules then
				print("<GAMEX>CORE>DEBUG> Looping through directory", tostring(module))
			end

			InitModulesInDirectory(module, debugModules)
			continue
		end

		if debugModules then
			print("<GAMEX>CORE>DEBUG> Requiring module", tostring(module))
		end

		xpcall(function()
			require(module)

			if debugModules then
				print("<GAMEX>CORE>DEBUG> Module", tostring(module), "required.")
			end
		end, function(err)
			warn("<GAMEX>CORE> Failed to initiate module", tostring(module), "for", err)
		end)
	end
end

--[=[
    Runs the client side of the GameX framework.
]=]
local function RunClient(gamexOptions: GameXOptions)
	assert(not (script:GetAttribute("ClientStarted") == true), "<GAMEX>CORE> Client already started.")

	local Controllers = ReplicatedStorage.Controllers
	local ClientComponents = ReplicatedStorage.Components

	script:SetAttribute("ClientStarted", true)

	InitModulesInDirectory(Controllers, gamexOptions.DebugModules)
	InitModulesInDirectory(ClientComponents, gamexOptions.DebugModules)
end

--[=[
    Runs the server side of the GameX framework.
]=]
local function RunServer(gamexOptions: GameXOptions)
	assert(not (script:GetAttribute("ServerStarted") == true), "<GAMEX>CORE> Server already started.")

	local Services = ServerScriptService.Services
	--local BackendServices = ServerScriptService.BackendServices
	local ServerComponents = ServerScriptService.Components

	script:SetAttribute("ServerStarted", true)

	InitModulesInDirectory(Services, gamexOptions.DebugModules)
	--InitModulesInDirectory(BackendServices, gamexOptions.DebugModules)
	InitModulesInDirectory(ServerComponents, gamexOptions.DebugModules)
end

-- Module Functions --

--[=[
    Starts the GameX framework on the current environment and run context.
    @param gamexOptions GameXOptions: Attributes on the GameX Folder.
]=]
function CoreX.Start(gamexOptions: GameXOptions)
	if GetRunContext() == "client" then
		RunClient(gamexOptions)
	else
		RunServer(gamexOptions)
	end
end

--[=[
    Creates a new signal.
    @return Signal: A new signal instance.
]=]
function CoreX.CreateNormalSignal()
	return Signal.new()
end

--[=[
    Creates and registers a new controller.
    @param name string: The name of the controller.
    @return XController
]=]
function CoreX.NewController(name: string): { ControllerOperator: XControllerManager, Controller: XController }
	assert(
		RunService:IsClient(),
		"Can not create controller under name",
		name,
		"due to the context not being on the client."
	)
	assert(script:GetAttribute("ClientStarted"), "GameX.Start() hasn't been ran on the client.")

	local newController = ControllerManager.new(name)

	newController:Register()

	return {
		ControllerOperator = newController,
		Controller = newController:GetUseableController(),
	}
end

--[=[
	Creates a new component managed by a module and a tag.
	@param module --> XComponent -- The component for the entity component.
	@param tag --> string -- The tag to be assigned for the component.
	@return void
--]=]
function CoreX.NewComponent(tag: string)
	local module: XComponent

	return {
		AssignComponentTable = function(tab: XComponent)
			module = tab
		end,

		Finish = function()
			ComponentManager.NewComponent(module, tag)
		end,
	}
end

--[=[
	Removes the loaded component, as well as the objects loaded with it.
	@param tag --> string -- The tag assigned to the loaded component to be removed.
	@return void
--]=]
function CoreX.RemoveLoadedComponent(tag: string)
	ComponentManager.RemoveLoadedComponent(tag)
end

--[=[
	Removes/deinits a component loaded onto a object.
	@param tag --> string -- The component tag to remove from the object.
	@param object --> Instance -- The object to remove the component from.
	@param removeTag --> boolean -- Whether or not to remove the tag from the object.
	@return void
--]=]
function CoreX.RemoveObjectComponent(tag: string, object: Instance, removeTag: boolean?)
	ComponentManager.RemoveObjectComponent(tag, object, removeTag)
end

--[=[
    Creates and registers a new service.
    @param name string: The name of the service.
    @return XService
]=]
function CoreX.NewService(name: string): { ServiceController: XServiceManager, Service: XService }
	assert(
		RunService:IsServer(),
		"Can not create service under name",
		name,
		"due to the context not being on the server."
	)
	assert(script:GetAttribute("ServerStarted"), "GameX.Start() hasn't been ran on the server.")

	local newService = ServiceManager.new(name)

	newService:Register()

	return {
		ServiceController = newService,
		Service = newService:GetUseableService(),
	}
end

--[=[
    Retrieves a registered service by name.
    @param name string: The name of the service.
    @return XService | nil: The registered service if found, otherwise nil.
]=]
function CoreX.GetService(name: string): XService | nil
	assert(RunService:IsServer(), "Can not get service under name", name, "due to the context not being on the server.")
	assert(script:GetAttribute("ServerStarted"), "GameX.Start() hasn't been ran on the server.")

	return ServiceManager.GetService(name)
end

--[=[
	Returns the component of a object on a specific tag.
	@param tag --> string -- The tag to look for.
	@param object --> Instance -- The object the tag should be looked for on.
	@return Component (:Init(), :Deinit(), ...)
--]=]
function CoreX.GetObjectComponent(tag: string, object: Instance): XComponent | nil
	return ComponentManager.GetObjectComponent(tag, object)
end

--[=[
	Waits for a specific component tag to be loaded.
	@yields
	@param tag --> string -- The tag/component to wait to be loaded.
	@return Component
--]=]
function CoreX.WaitForLoadedComponent(tag: string): XComponent | nil
	return ComponentManager.WaitForLoadedComponent(tag)
end

--[=[
	Waits for a specific object to recieve a component of a specific tag.
	@param tag --> string -- The tag/component to wait for.
	@param object --> Instance -- The object to wait for the tag to be assigned to.
	@return Component (:Init(), :Deinit(), ...)
--]=]
function CoreX.WaitForObjectComponent(tag: string, object: Instance): XComponent | nil
	return ComponentManager.WaitForObjectComponent(tag, object)
end

--[=[
    Retrieves a registered controller by name.
    @param name string: The name of the controller.
    @return XController | nil: The registered controller if found, otherwise nil.
--]=]
function CoreX.GetController(name: string): XController | nil
	assert(
		RunService:IsClient(),
		"Can not get controller under name",
		name,
		"due to the context not being on the client."
	)
	assert(script:GetAttribute("ClientStarted"), "GameX.Start() hasn't been ran on the client.")

	return ControllerManager.GetController(name)
end

-- End --
return CoreX
