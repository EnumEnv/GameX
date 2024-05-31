-- GameX --
local CoreInstance = script.Parent.Core
local Core = require(script.Parent.Core)

-- Option Attributes --
local DebugModules = CoreInstance:GetAttribute("DebugModules")

-- Parse and Start --
Core.Start({ DebugModules = DebugModules })
