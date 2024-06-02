--[=[
    -- OUTDATED DOCUMENTATION --

    The `CoreX` module serves as the main class for the GameX framework, managing the initialization and 
    execution of services and components for both client and server environments.

    **Functions:**
    - `CoreX.Start()`: Starts the GameX framework on the current environment and run context, initializing client or server components accordingly.
    - `CoreX.CreateSignal()`: Creates and returns a new signal instance using the `Signal` module.
    - `CoreX.NewService(name: string, moduleScript: ModuleScript): XService`: Creates, registers, and starts a new service with the specified name and module script.
    - `CoreX.GetService(name: string): XService | nil`: Retrieves a registered service by its name, returning the service if found, or `nil` if not.

    **Local Functions:**
    - `GetRunContext()`: Determines the run context (client or server) based on the current environment.
    - `InitModulesInDirectory(directory: Folder)`: Recursively initializes all modules within the specified directory.
    - `RunClient()`: Initializes and runs the client-side components of the GameX framework.
    - `RunServer()`: Initializes and runs the server-side components of the GameX framework.

    **Types:**
    - `SignalType`: Type representing a signal instance created by the `Signal` module.
    - `XService`: Type representing a service managed by the `ServiceManager` module, with methods `Begin`, `PlayerAdded`, and `PlayerRemoving`.
]=]

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

-- Types --
export type SignalType = typeof(Signal)
export type APIType = typeof(CoreX)
export type XService = ServiceManager.XService
export type XServiceManager = typeof(ServiceManager)
export type XController = ControllerManager.XController
export type XControllerManager = typeof(ControllerManager)
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
		if module:IsA("Folder") then
			if debugModules then
				print("<GAMEX>CORE>DEBUG> Looping through directory", tostring(module))
			end

			InitModulesInDirectory(directory, debugModules)
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
	local ClientComponents = ReplicatedStorage.Components.Client

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
	local BackendServices = ServerScriptService.BackendServices

	script:SetAttribute("ServerStarted", true)

	InitModulesInDirectory(Services, gamexOptions.DebugModules)
	InitModulesInDirectory(BackendServices, gamexOptions.DebugModules)
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
