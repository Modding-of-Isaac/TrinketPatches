local TrinketPatches = RegisterMod("TrinketPatches", 1)

local log = require("log.lua")

-- Register callbacks
local TrinketCallbacks = require("trinkets.lua")

for k, v in pairs(TrinketCallbacks) do
    for _,callback in pairs(v) do
        log.debug(k.." -> "..tostring(callback))
        TrinketPatches:AddCallback(ModCallbacks[k], callback)
    end
end
