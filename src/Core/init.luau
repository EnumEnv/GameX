-- Services --
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
--]=]
local function GetRunContext(): "client" | "server"
	return if RunService:IsClient() then "client" else "server"
end

--[=[
    Initiates modules in a directory.
--]=]
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
    @return void
--]=]
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
    @return void
--]=]
local function RunServer()
	assert(not (script:GetAttribute("ServerStarted") == true), "<GAMEX>CORE> Server already started.")

	local Services = ReplicatedStorage.Services
	local BackendServices = ReplicatedStorage.BackendServices

	script:SetAttribute("ServerStarted", true)

	InitModulesInDirectory(Services)
	InitModulesInDirectory(BackendServices)
end

-- Module Functions --
--[=[
    Starts the GameX framework on the current environment and run context.
    @return void
--]=]
function CoreX.Start()
	if GetRunContext() == "client" then
		RunClient()
	else
		RunServer()
	end
end

--[=[
    Creates a new signal.
    @return Signal
--]=]
function CoreX.CreateSignal()
	return Signal.new()
end

function CoreX.NewService(name: string, moduleScript: ModuleScript): XService
	local newService = ServiceManager.new(name, moduleScript)
	newService:Register()
	newService:Start()
end

function CoreX.GetService(name: string): XService | nil
	return ServiceManager.GetService(name)
end

-- End --
return CoreX
