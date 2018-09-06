local f =
TrinketPatches.util.register("MC_ENTITY_TAKE_DMG") ..
function(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    local player = tookDamage:ToPlayer()

    if player ~= nil and player:HasTrinket(TrinketType.TRINKET_MATCH_STICK) and not player:HasInvincibility() then
        if TrinketPatches.util.isFire(damageSource) then
            TrinketPatches.util.log("Player took damage from fire")
            damageAmount = damageAmount + 2

            if TrinketPatches.util.chance(5, false) then
                player:TryRemoveTrinket(TrinketType.TRINKET_MATCH_STICK)
                player:AddTrinket(Isaac.GetTrinketIdByName("Burnt Match"))
            end
        end
    end
end

err()
