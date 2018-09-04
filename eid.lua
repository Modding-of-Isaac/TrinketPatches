local TrinketEIDOverwrites = {
    {"39", "+... #20% chance for half heart of damage in new room"},
    {"41", "+... #Full heart extra damage from fires"},
    {"53", "+... #Can be removed by walking into fires"},
    {"71", "+... #5% chance to fire an ipecac tear"},
    {"87", "+... #Full heart damage extra when entering curse room"},
    {"103", "+... #all stats up if amount of all hearts is equal"},
    {"110", "+... #Other shops cannot be entered"},
    {"111", "+... #Other item rooms cannot be entered"},
    {"119", "+... #Removes half soul/black heart on new floor"}
}

local registered = false

local function registerEID()
    if registered == true then
        return
    else
        registered = true
    end

    if not trinketdescriptions then
        log.debug("EID not loaded or installed. Some descriptions will not work")
        trinketdescriptions = {}
    end

    for _,entry in pairs(TrinketEIDOverwrites) do
        for _,registered in pairs(trinketdescriptions) do
            if registered[1] == entry[1] then
                -- Replace to ensure the old description is saved
                local replaced = string.gsub(entry[2], "+...", registered[2]:gsub("%% ", "%%%% "))
                -- log.debug(registered[2].." -> "..replaced)
                registered[2] = replaced
            end
        end
    end
end

TrinketPatches.mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, registerEID)
