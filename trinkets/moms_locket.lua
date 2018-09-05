local f =
TrinketPatches.util.register("MC_ENTITY_TAKE_DMG") ..
function(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(TrinketType.TRINKET_MOMS_LOCKET) then
        if tookDamage.Type == EntityType.ENTITY_PLAYER and damageFlag == DamageFlag.DAMAGE_CURSED_DOOR then
            TrinketPatches.util.log("Player took damage from door")
            player:TakeDamage(2, 0, EntityRef(player), 1)
        end
    end
end
