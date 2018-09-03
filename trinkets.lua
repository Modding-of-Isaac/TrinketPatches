local log = require("log.lua")

local game = Game()

local TrinketCallbacks = {
    MC_POST_NEW_ROOM = {},
    MC_POST_GAME_STARTED = {},
    MC_ENTITY_TAKE_DMG = {},
    MC_POST_NEW_LEVEL = {},
    MC_PRE_GAME_EXIT = {},
    MC_POST_GAME_STARTED = {},
    MC_POST_PLAYER_UPDATE = {},
    MC_EVALUATE_CACHE = {},
    MC_POST_FIRE_TEAR = {}
}

----- Utility

function chance(x, affectedByLuck)
    -- Takes percentage, i.e. 20 for 20%
    if not affectedByLuck then
        return math.random() < (x / 100)
    else
        local player = Isaac.GetPlayer(0)
        -- +5% chance for every luck up
        local modifier = x + 5 * player.Luck
        return math.random() < (x / 100)
    end
end

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

----- Callbacks

-- Cancer

local function cancerDamage()
    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()
    local doDamage = not chance(80, true) -- inverted 80%, more luck should be lower chance
    
    if room:IsFirstVisit() and player:HasTrinket(TrinketType.TRINKET_CANCER) and doDamage then
        log.debug("Cancer dealt damage")
        player:TakeDamage(1, 0, EntityRef(player), 0)
    end
end

-- Mom's locket

local function locketDamage(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    local player = Isaac.GetPlayer(0)
    
    if player:HasTrinket(TrinketType.TRINKET_MOMS_LOCKET) then
        if tookDamage.Type == EntityType.ENTITY_PLAYER and damageFlag == DamageFlag.DAMAGE_CURSED_DOOR then
            log.debug("Player took damage from door")
            player:TakeDamage(2, 0, EntityRef(player), 1)
        end
    end
end

-- Bloody Crown

local bloodyRoomRoom = nil
local bloodyLastRoom = nil
local enteredWithBloodyCrown = false

local function bloodyRoomChange()
    bloodyLastRoom = bloodyRoomRoom
    bloodyRoomRoom = game:GetRoom()
    
    if bloodyLastRoom == nil then
        return
    end

    if enteredWithBloodyCrown and bloodyRoomRoom:GetType() == RoomType.ROOM_TREASURE then
        local level = game:GetLevel()
        if not (level:GetStage() == LevelStage.STAGE4_1 or level:GetStage() == LevelStage.STAGE4_2) then
            local target = level:GetPreviousRoomIndex()
            level.EnterDoor = -1
            level.LeaveDoor = -1
            game:StartRoomTransition(target, Direction.NO_DIRECTION, 1)
        end
    end
end

local function bloodyFloorChange()
    bloodyLastRoom = nil
    bloodyRoomRoom = game:GetRoom()
    
    local player = Isaac.GetPlayer(0)
    
    if player:HasTrinket(TrinketType.TRINKET_BLOODY_CROWN) then
        enteredWithBloodyCrown = true
    else
        enteredWithBloodyCrown = false
    end
end

-- Silver Dollar

local silverRoomRoom = nil
local silverLastRoom = nil
local enteredWithSilverDollar = false

local function silverRoomChange()
    silverLastRoom = silverRoomRoom
    silverRoomRoom = game:GetRoom()
    
    if silverLastRoom == nil then
        return
    end

    if enteredWithSilverDollar and silverRoomRoom:GetType() == RoomType.ROOM_SHOP then
        local level = game:GetLevel()
        if not (level:GetStage() == LevelStage.STAGE4_1 or level:GetStage() == LevelStage.STAGE4_2) then
            local target = level:GetPreviousRoomIndex()
            level.EnterDoor = -1
            level.LeaveDoor = -1
            game:StartRoomTransition(target, Direction.NO_DIRECTION, 1)
        end
    end
end

local function silverFloorChange()
    silverLastRoom = nil
    silverRoomRoom = game:GetRoom()
    
    local player = Isaac.GetPlayer(0)
    
    if player:HasTrinket(TrinketType.TRINKET_SILVER_DOLLAR) then
        enteredWithSilverDollar = true
    else
        enteredWithSilverDollar = false
    end
end

-- Stem Cell

local function stemSwitch()
    local player = Isaac.GetPlayer(0)
    
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

-- Equality

local doHeartBonus = false
local lastHeartStatus = false

local function triggerHeartsBonus() -- Called on MC_POST_PLAYER_UPDATE
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

local function heartsBonus(_, player, _)  -- Called on MC_EVALUATE_CACHE
    if doHeartBonus and player:HasTrinket(TrinketType.TRINKET_EQUALITY) then
        player.Damage = player.Damage + 0.1
        player.MoveSpeed = player.MoveSpeed + 0.1
        player.ShotSpeed = player.ShotSpeed + 0.05
        player.FireDelay = player.FireDelay + 0.05
        player.Luck = player.Luck + 1
        player.TearFallingSpeed = player.TearFallingSpeed + 0.1
    end
end

-- Bob's Bladder
local function bobTear(_, tear) -- MC_POST_FIRE_TEAR
    local player = Isaac.GetPlayer(0)
    
    if player:HasTrinket(TrinketType.TRINKET_BOBS_BLADDER) then
        if chance(5, true) then
            tear.FallingSpeed = -11
            tear.FallingAcceleration = 0.6
            tear.TearFlags = tear.TearFlags | TearFlags.TEAR_EXPLOSIVE
			tear:SetColor(Color(0.5, 0.89, 0.4, 1, 0, 0, 0), -1, 0, false, false)
			-- tear:Remove() -- Remove old tear to cause a replacement effect
        end
    end
end

----- EID

local registered = false

local function registerEID()
    if registered == true then
        return
    else
        registered = true
    end

    if not trinketdescriptions then
        log.debug("EID not loaded or installed. Some descriptions will not work")
        trinketdescriptions = {}
    end
    
    local TrinketDesc = require("eid.lua")

    for _,entry in pairs(TrinketDesc) do
        for _,registered in pairs(trinketdescriptions) do
            if registered[1] == entry[1] then
                -- Replace to ensure the old description is saved
                local replaced = string.gsub(entry[2], "+...", registered[2])
                -- log.debug(registered[2].." -> "..replaced)
                registered[2] = replaced
            end
        end
    end
end

----- Save/Load

local function saveTrinketProperties()
    local stringified = "<DATA dollar="..tostring(enteredWithSilverDollar)..", crown="..tostring(enteredWithBloodyCrown)..">"
    Isaac.SaveModData(TrinketPatches, stringified)
end

local function loadTrinketProperties()
    local data = Isaac.LoadModData(TrinketPatches)
    enteredWithBloodyCrown = (string.match(data, "crown=(true|false)") == true)
    enteredWithSilverDollar = (string.match(data, "dollar=(true|false)") == true)
end

----- Registry

table.insert(TrinketCallbacks.MC_POST_NEW_ROOM, cancerDamage)

table.insert(TrinketCallbacks.MC_ENTITY_TAKE_DMG, locketDamage)

table.insert(TrinketCallbacks.MC_POST_NEW_ROOM, bloodyRoomChange)
table.insert(TrinketCallbacks.MC_POST_NEW_LEVEL, bloodyFloorChange)

table.insert(TrinketCallbacks.MC_POST_NEW_ROOM, silverRoomChange)
table.insert(TrinketCallbacks.MC_POST_NEW_LEVEL, silverFloorChange)

table.insert(TrinketCallbacks.MC_POST_NEW_LEVEL, stemSwitch)

table.insert(TrinketCallbacks.MC_EVALUATE_CACHE, heartsBonus)
table.insert(TrinketCallbacks.MC_POST_PLAYER_UPDATE, triggerHeartsBonus)


table.insert(TrinketCallbacks.MC_POST_FIRE_TEAR, bobTear)
------

table.insert(TrinketCallbacks.MC_POST_GAME_STARTED, registerEID)
table.insert(TrinketCallbacks.MC_POST_GAME_STARTED, loadTrinketProperties)
table.insert(TrinketCallbacks.MC_PRE_GAME_EXIT, saveTrinketProperties)

return TrinketCallbacks