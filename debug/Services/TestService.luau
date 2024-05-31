-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GameX --
local Core = require(ReplicatedStorage.GameX.Core)

-- Service --
local TestService = Core.NewService { Name = "TestService" }.Service

-- Types --
export type SelfType = typeof(TestService)

-- Service Functions --
function TestService.Begin(self: SelfType)
    print("service began")
end

-- Service Final --
TestService.ServiceController:Start()

-- End --
return TestService
