-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- GameX --
local Core = require(ReplicatedStorage.GameX.Core)

-- Service --
local ControllerCore = Core.NewController("TestController")
local TestController = ControllerCore.Controller

-- Variables --
local LocalPlayer = Players.LocalPlayer

-- Types --
export type SelfType = typeof(TestController)

-- Controller Functions --
function TestController.Begin(self: SelfType)
	print("controller began")
end

-- OPTIONAL (LocalCharacterAdded)
function TestController.LocalCharacterAdded(self: SelfType, character: Model)
	print("local character has been added. name:", tostring(character))
end

-- Controller Final --
ControllerCore.ControllerOperator:Start(LocalPlayer)

-- End --
return ControllerCore
