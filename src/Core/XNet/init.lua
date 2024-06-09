-- Services --
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Module --
local XNet = {}

-- Variables --
local Encoding = script.Encoding

local B64 = require(Encoding.B64)
local DataManager = require(script.DataManager)

-- Module Functions --
function XNet.GetRemoteEvent(name: string): DataManager.APIType
	if RunService:IsClient() then
		return ReplicatedStorage:WaitForChild("XNetInstances"):FindFirstChild(B64.ToB64(name))
	end

	return DataManager.CreateRemoteEvent(name)
end

function XNet.GetDataEnum(name: string, children: { string })
	return DataManager.CreateDataEnum(name, children)
end

-- End --
return XNet
