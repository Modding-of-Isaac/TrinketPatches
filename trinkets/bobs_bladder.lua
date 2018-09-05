local f =
TrinketPatches.util.register("MC_POST_FIRE_TEAR") ..
function(_, tear)
    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(TrinketType.TRINKET_BOBS_BLADDER) then
        if TrinketPatches.util.chance(5, true) then
            -- Change into Ipecac tear
            tear.FallingSpeed = -11
            tear.FallingAcceleration = 0.6
            tear.TearFlags = tear.TearFlags | TearFlags.TEAR_EXPLOSIVE
            tear:SetColor(Color(0.5, 0.89, 0.4, 1, 0, 0, 0), -1, 0, false, false)
        end
    end
end
