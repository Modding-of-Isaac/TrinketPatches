local f =
TrinketPatches.util.register("MC_POST_NEW_ROOM") ..
function()
    local player = Isaac.GetPlayer(0)
    local room = TrinketPatches.game:GetRoom()
    local doDamage = not TrinketPatches.util.chance(80, true) -- inverted 80%, more luck should be lower chance

    if room:IsFirstVisit() and player:HasTrinket(TrinketType.TRINKET_CANCER) and doDamage then
        TrinketPatches.util.log("Cancer dealt damage")
        player:TakeDamage(1, 0, EntityRef(player), 0)
    end
end
