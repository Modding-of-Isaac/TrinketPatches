local function removeTick(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    local player = Isaac.GetPlayer(0)
    TrinketPatches.log(damageFlag)

    if player:HasTrinket(TrinketType.TRINKET_TICK) then
        if tookDamage.Type == EntityType.ENTITY_PLAYER and damageSource.Type == EntityType.ENTITY_FIREPLACE then
            TrinketPatches.log("Player took damage from fire")
            player:DropTrinket(player.Position, true)
        end
    end
end

return {
    MC_ENTITY_TAKE_DMG = removeTick
}
