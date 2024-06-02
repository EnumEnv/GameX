-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GameX --
local Core = require(ReplicatedStorage.GameX.Core)

-- Component --
local TestComponent = Core.NewComponent(script, "TestServerComponent")

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
TestComponent.Finish()

-- End --
return TestComponent
