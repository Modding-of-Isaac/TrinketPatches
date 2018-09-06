local f =
TrinketPatches.util.register("MC_POST_NEW_LEVEL") ..
function()
    local player = Isaac.GetPlayer(0)
    if not player:HasFullHearts() then
        player:AddHearts(player:GetMaxHearts()/2 - 1)  -- Heal half health
    end

    if player:HasTrinket(TrinketType.TRINKET_STEM_CELL) then
        if (player:GetSoulHearts() > 0) then
            player:AddSoulHearts(-1)
        else
            if player:GetBlackHearts() > 0 then
                player:AddBlackHearts(-1)
            end
        end
    end
end

err()
