-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GameX --
local Core = require(ReplicatedStorage.GameX.Core)

-- Component --
local NewComponent = Core.NewComponent("TestClientComponent")
local TestComponent = {}

-- Types --
export type SelfType = typeof(TestComponent)

-- Controller Functions --
function TestComponent.Init(self: SelfType, object: Instance)
	print("component initiated on object:", tostring(object))
end

function TestComponent.Deinit(self: SelfType, object: Instance)
	print("component deinitated on object:", tostring(object))
end

-- Component Final --
NewComponent.AssignComponentTable(TestComponent)
NewComponent.Finish()

-- End --
return TestComponent
