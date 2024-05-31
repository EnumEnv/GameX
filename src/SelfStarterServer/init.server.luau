-- GameX --
local Core = require(script.Parent.Core)

-- Option Attributes --
local DebugModules = Core:GetAttribute("DebugModules")

-- Parse and Start --
Core.Start({ DebugModules = DebugModules })
