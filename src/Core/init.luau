--[=[
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

-- Types --
export type SignalType = typeof(Signal)
export type XService = ServiceManager.XService

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
local function InitModulesInDirectory(directory: Folder)
    for _, module in directory:GetChildren() do
        if module:IsA("Folder") then
            InitModulesInDirectory(directory)
            continue
        end

        xpcall(function()
            require(module)
        end, function(err)
            warn("<GAMEX>CORE> Failed to initiate module", tostring(module), "for", err)
        end)
    end
end

--[=[
    Runs the client side of the GameX framework.
]=]
local function RunClient()
    assert(not (script:GetAttribute("ClientStarted") == true), "<GAMEX>CORE> Client already started.")

    local Controllers = ReplicatedStorage.Controllers
    local ClientComponents = ReplicatedStorage.Components.Client

    script:SetAttribute("ClientStarted", true)

    InitModulesInDirectory(Controllers)
    InitModulesInDirectory(ClientComponents)
end

--[=[
    Runs the server side of the GameX framework.
]=]
local function RunServer()
    assert(not (script:GetAttribute("ServerStarted") == true), "<GAMEX>CORE> Server already started.")

    local Services = ServerScriptService.Services
    local BackendServices = ServerScriptService.BackendServices

    script:SetAttribute("ServerStarted", true)

    InitModulesInDirectory(Services)
    InitModulesInDirectory(BackendServices)
end

-- Module Functions --

--[=[
    Starts the GameX framework on the current environment and run context.
]=]
function CoreX.Start()
    if GetRunContext() == "client" then
        RunClient()
    else
        RunServer()
    end
end

--[=[
    Creates a new signal.
    @return Signal: A new signal instance.
]=]
function CoreX.CreateSignal()
    return Signal.new()
end

--[=[
    Creates and starts a new service.
    @param name string: The name of the service.
    @param module { [any]: any }: The module table of the service.
]=]
function CoreX.NewService(name: string, module): XService
    local newService = ServiceManager.new(name, module)

    newService:Register()
    newService:Start()

    return newService:GetUseableService()
end

--[=[
    Retrieves a registered service by name.
    @param name string: The name of the service.
    @return XService | nil: The registered service if found, otherwise nil.
]=]
function CoreX.GetService(name: string): XService | nil
    return ServiceManager.GetService(name)
end

-- End --
return CoreX
