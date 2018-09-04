local function removeTick(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    local player = tookDamage:ToPlayer()
    TrinketPatches.log(damageFlag)

    if player ~= nil and player:HasTrinket(TrinketType.TRINKET_TICK) then
        if damageSource.Type == EntityType.ENTITY_FIREPLACE then
            TrinketPatches.log("Player took damage from fire")
            player:DropTrinket(player.Position, true)
        end
    end
end

return {
    MC_ENTITY_TAKE_DMG = removeTick
}
