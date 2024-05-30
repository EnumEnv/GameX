-- Manager Info --
local ServiceManager = {}
ServiceManager.__index = ServiceManager

-- Types --
export type SelfType = typeof(ServiceManager) & {
    _name: string
}

-- Module Functions --
function ServiceManager.new(name: string): SelfType
    local self = {
        _name = name
    }

    return setmetatable(self, ServiceManager) :: any
end

-- End --
return ServiceManager
