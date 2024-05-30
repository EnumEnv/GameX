-- Services --
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[=[
    The main class for the Core of GameX.
    @class CoreX
--]=]
local CoreX = {}

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
	local Controllers = ReplicatedStorage.Controllers
	local ClientComponents = ReplicatedStorage.Components.Client

    InitModulesInDirectory(Controllers)
    InitModulesInDirectory(ClientComponents)
end

--[=[
    Runs the server side of the GameX framework.
    @return void
--]=]
local function RunServer()
    local Services = ReplicatedStorage.Services
    local BackendServices = ReplicatedStorage.BackendServices
end

-- Module Functions --
function CoreX.Start() 
    if GetRunContext() == 'client' then
        RunClient()
    else
        RunServer()
    end
end

-- End --
return CoreX
