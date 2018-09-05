TrinketPatches.util.register("MC_ENTITY_TAKE_DMG") ..
function removeTick(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    local player = tookDamage:ToPlayer()

    if player ~= nil and player:HasTrinket(TrinketType.TRINKET_TICK) then
        if TrinketPatches.util.isFire(damageSource) then
            TrinketPatches.util.log("Player took damage from fire")
            player:DropTrinket(player.Position, true)
        end
    end
end
