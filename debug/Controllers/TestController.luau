-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GameX --
local Core = require(ReplicatedStorage.GameX.Core)

-- Service --
local ControllerCore = Core.NewController { Name = "TestController" }
local TestController = ControllerCore.Controller

-- Types --
export type SelfType = typeof(TestController)

-- Controller Functions --
function TestController.Begin(self: SelfType)
    print("controller began")
end

-- Controller Final --
ControllerCore.ControllerOperator:Start()

-- End --
return ControllerCore
