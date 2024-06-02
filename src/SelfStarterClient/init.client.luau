-- GameX --
local GameX = script.Parent
local Core = require(script.Parent.Core)

-- Option Attributes --
local DebugModules = GameX:GetAttribute("DebugModules")
local FirstServerThenClient = GameX:GetAttribute("FirstServerThenClient")

-- Parse and Start --
if DebugModules then
    print("<GAMEX>CLIENT STARTER> Starting the client.")
end

Core.Start({ DebugModules = DebugModules, FirstServerThenClient = FirstServerThenClient })
