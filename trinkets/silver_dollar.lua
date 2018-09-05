local silverRoomRoom = nil
local silverLastRoom = nil

local f =
TrinketPatches.util.register("MC_POST_NEW_ROOM") ..
function()
    silverLastRoom = silverRoomRoom
    silverRoomRoom = TrinketPatches.game:GetRoom()

    if silverLastRoom == nil then
        return
    end

    if TrinketPatches.config.dollar and silverRoomRoom:GetType() == RoomType.ROOM_SHOP then
        local level = TrinketPatches.game:GetLevel()
        if not (level:GetStage() == LevelStage.STAGE4_1 or level:GetStage() == LevelStage.STAGE4_2) then
            local target = level:GetPreviousRoomIndex()
            level.EnterDoor = -1
            level.LeaveDoor = -1
            TrinketPatches.game:StartRoomTransition(target, Direction.NO_DIRECTION, 1)
        end
    end
end

local f =
TrinketPatches.util.register("MC_POST_NEW_LEVEL") ..
function()
    silverLastRoom = nil
    silverRoomRoom = TrinketPatches.game:GetRoom()

    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(TrinketType.TRINKET_SILVER_DOLLAR) then
        TrinketPatches.config.dollar = true
    else
        TrinketPatches.config.dollar = false
    end
end

err()
