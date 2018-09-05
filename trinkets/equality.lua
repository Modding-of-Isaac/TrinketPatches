local doHeartBonus = false
local lastHeartStatus = false

local function getBlackHearts(player)
    -- Credits to piber20

    local heartmap = player:GetBlackHearts()
    local blackHearts = 0
    while heartmap > 0 do
        heartmap = heartmap - 2^(math.floor(math.log(heartmap) / math.log(2)))
        blackHearts = blackHearts + 1
    end

    --terrible workaround to guess half vs full black hearts
    blackHearts = blackHearts * 2
    local soulHearts = player:GetSoulHearts()
    if soulHearts / 2 ~= math.floor(soulHearts / 2) then
        blackHearts = blackHearts - 1
    end
    if blackHearts < 0 then
        blackHearts = 0
    end

    return blackHearts
end

local f =
TrinketPatches.util.register("MC_POST_PLAYER_UPDATE") ..
function()
    local player = Isaac.GetPlayer(0)

    local red = player:GetHearts() - player:GetBoneHearts()  -- Bone hearts are red hearts too, but we exclude these
    local black = getBlackHearts(player)
    local soul = player:GetSoulHearts() - black

    local currentHeartStatus = (red == black and red == soul)

    doHeartBonus = currentHeartStatus
    if currentHeartStatus ~= lastHeartStatus then
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
    end
    lastHeartStatus = currentHeartStatus
end

local f =
TrinketPatches.util.register("MC_EVALUATE_CACHE") ..
function(_, player, _)
    if doHeartBonus and player:HasTrinket(TrinketType.TRINKET_EQUALITY) then
        player.Damage = player.Damage + 0.1
        player.MoveSpeed = player.MoveSpeed + 0.1
        player.ShotSpeed = player.ShotSpeed + 0.05
        player.FireDelay = player.FireDelay + 0.05
        player.Luck = player.Luck + 1
        player.TearFallingSpeed = player.TearFallingSpeed + 0.1
    end
end
