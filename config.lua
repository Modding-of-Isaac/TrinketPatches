return {
    crown = nil,
    dollar = nil,

    save = function(conf)
        local stringified = "<DATA dollar="..tostring(conf.dollar)..", crown="..tostring(conf.crown)..">"
        Isaac.SaveModData(TrinketPatches, stringified)
    end,

    load = function(conf)
        local data = Isaac.LoadModData(TrinketPatches)
        conf.crown = (string.match(data, "crown=(true|false)") == true)
        conf.dollar = (string.match(data, "dollar=(true|false)") == true)
    end
}
