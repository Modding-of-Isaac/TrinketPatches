local function damageMatchStick(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(TrinketType.TRINKET_MATCH_STICK) then
        if tookDamage.Type == EntityType.ENTITY_PLAYER and damageSource.Type == EntityType.ENTITY_FIREPLACE then
            TrinketPatches.log("Player took damage from fire")
            player:TakeDamage(2, 0, damageSource, 1)
        end
    end
end

return {
    MC_ENTITY_TAKE_DMG = damageMatchStick
}
