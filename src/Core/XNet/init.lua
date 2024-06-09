-- Module --
local XNet = {}

-- Variables --
local DataManager = require(script.DataManager)

-- Module Functions --
function XNet.GetRemoteEvent(name: string): DataManager.APIType
    return DataManager.CreateRemoteEvent(name)
end

-- End --
return XNet