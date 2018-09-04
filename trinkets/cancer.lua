local function cancerDamage()
    local player = Isaac.GetPlayer(0)
    local room = TrinketPatches.game:GetRoom()
    local doDamage = not TrinketPatches.chance(80, true) -- inverted 80%, more luck should be lower chance

    if room:IsFirstVisit() and player:HasTrinket(TrinketType.TRINKET_CANCER) and doDamage then
        TrinketPatches.log("Cancer dealt damage")
        player:TakeDamage(1, 0, EntityRef(player), 0)
    end
end

return {
    MC_POST_NEW_ROOM = cancerDamage
}
