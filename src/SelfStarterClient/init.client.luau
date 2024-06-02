-- GameX --
local GameX = script.Parent
local Core = require(script.Parent.Core)

-- Option Attributes --
local DebugModules = GameX:GetAttribute("DebugModules")

-- Parse and Start --
Core.Start({ DebugModules = DebugModules })
