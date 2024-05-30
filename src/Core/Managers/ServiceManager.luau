-- Manager Info --
local ServiceManager = {}
ServiceManager.__index = ServiceManager

-- Types --
export type SelfType = typeof(ServiceManager) & {
    _name: string,
    _module: ModuleScript
}

export type XService = {
    Begin: () -> (),
    PlayerAdded: (Player) -> (Player),
    PlayerRemoving: (Player) -> (Player),
}

-- Module Functions --
function ServiceManager.new(name: string, module: ModuleScript): SelfType
    local self = {
        _name = name,
        _module = module,
    }

    return setmetatable(self, ServiceManager) :: any
end

function ServiceManager.Register()

end

-- End --
return ServiceManager
