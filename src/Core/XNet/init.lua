-- Module --
local XNet = {}

-- Variables --
local DataManager = require(script.DataManager)

-- Module Functions --
function XNet.GetRemoteEvent(name: string): DataManager.APIType
	return DataManager.CreateRemoteEvent(name)
end

function XNet.GetDataEnum(name: string, children: { string })
	return DataManager.CreateDataEnum(name, children)
end

-- End --
return XNet
