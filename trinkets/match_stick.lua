local f =
TrinketPatches.util.register("MC_ENTITY_TAKE_DMG") ..
function(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    local player = tookDamage:ToPlayer()

    if player ~= nil and player:HasTrinket(TrinketType.TRINKET_MATCH_STICK) then
        if TrinketPatches.util.isFire(damageSource) then
            TrinketPatches.util.log("Player took damage from fire")
            player:TakeDamage(2, 0, damageSource, 10)
        end
    end
end

err()
