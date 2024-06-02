-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GameX --
local Core = require(ReplicatedStorage.GameX.Core)

-- Service --
local ServiceCore = Core.NewService("TestService")
local TestService = ServiceCore.Service

-- Types --
export type SelfType = typeof(TestService)

-- Service Functions --
function TestService.Begin(self: SelfType)
	print("service began")
end

-- Service Final --
ServiceCore.ServiceController:Start()

-- End --
return TestService
