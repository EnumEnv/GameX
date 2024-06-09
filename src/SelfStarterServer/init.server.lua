if script.Parent:GetAttribute("FirstServerThenClient") == true then
	script.Parent.SelfStarterClient.Enabled = false
end

-- GameX --
local GameX = script.Parent
local Core = require(script.Parent.Core)

-- Option Attributes --
local DebugModules = GameX:GetAttribute("DebugModules")
local FirstServerThenClient = GameX:GetAttribute("FirstServerThenClient")

-- Parse and Start --
Core.Start({ DebugModules = DebugModules, FirstServerThenClient = FirstServerThenClient })

-- Start Client --
if script.Parent.SelfStarterClient.Enabled == false and FirstServerThenClient == true then
	if DebugModules then
		print("<GAMEX>SERVER STARTER> Starting client after the server has started.")
	end

	script.Parent.SelfStarterClient.Enabled = true
end
