-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- GameX --
local Core = require(ReplicatedStorage.GameX.Core)
local XNet = require(ReplicatedStorage.GameX.Core.XNet)

-- Service --
local ControllerCore = Core.NewController("XNetTestController")
local TestController = ControllerCore.Controller

-- Variables --
local LocalPlayer = Players.LocalPlayer

-- Types --
export type SelfType = typeof(TestController)

-- Controller Functions --
function TestController.Begin(self: SelfType)
	print("XNet controller began")
   -- local testRemote = XNet.GetRemoteEvent("TestRemote")
  --  testRemote:SendData(7,"abc","AUHGGGGGSSISIII",false,true,true,false)
end

function TestController.LocalCharacterAdded(self: SelfType, character: Model)
	print("<XNetTestController> local character has been added. name:", tostring(character))
end

-- Controller Final --
ControllerCore.ControllerOperator:Start(LocalPlayer)

-- End --
return ControllerCore
