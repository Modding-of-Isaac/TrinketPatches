local trinketBurntMatch =
TrinketPatches.util.registerEID("5% chance to turn fire into lower tier fire") ..
Isaac.GetTrinketIdByName("Burnt Match")

-- Make sure it doesn't appear regularly
local f =
TrinketPatches.util.register("MC_POST_GAME_STARTED") ..
function()
    TrinketPatches.game:GetItemPool():RemoveTrinket(trinketBurntMatch)
end

local f =
TrinketPatches.util.register("MC_POST_NEW_ROOM") ..
function()
    local room = TrinketPatches.game:GetRoom()
    local player = Isaac.GetPlayer(0)

    if room:IsFirstVisit() and player:HasTrinket(trinketBurntMatch) then
        for _, ent in pairs(Isaac.GetRoomEntities()) do
            if TrinketPatches.util.isFire(ent) then
                TrinketPatches.util.log(ent.Variant)
                if TrinketPatches.util.chance(5, false) and ent.Variant > 0 then
                    Isaac.Spawn(EntityType.ENTITY_FIREPLACE, ent.Variant - 1, 0, ent.Position, Vector(0, 0), nil)
                    ent:Remove()
                end
            end
        end
    end
end

err()
