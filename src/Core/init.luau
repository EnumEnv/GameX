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
local function GetRunContext()
    return if RunService:IsClient() then 'client' else 'server'
end

--[=[
    Runs the client side of the GameX framework.
    @return void
--]=]
local function RunClient()
    local Controllers = ReplicatedStorage.Controllers
    local ClientComponents = ReplicatedStorage.Components.Client
end

-- Module Functions --
function CoreX.Start()
    
end

-- End --
return CoreX
