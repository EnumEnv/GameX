-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GameX --
local Core = require(ReplicatedStorage.GameX.Core)
local XNet = require(ReplicatedStorage.GameX.Core.XNet)

-- Service --
local ServiceCore = Core.NewService("XNetTestService")
local TestService = ServiceCore.Service

-- Types --
export type SelfType = typeof(TestService)

-- Service Functions --
function TestService.Begin(self: SelfType)
	print("XNet service began")
    local testRemote = XNet.GetRemoteEvent("TestRemote")
    testRemote:ListenForData(function(a,b,c,d,e,f,g,h)
        print(a,b,c,d,e,f,g,h)
    end)
end

-- Service Final --
ServiceCore.ServiceController:Start()

-- End --
return TestService
