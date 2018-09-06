local bloodyRoomRoom = nil
local bloodyLastRoom = nil

local f =
TrinketPatches.util.register("MC_POST_NEW_ROOM") ..
function()
    bloodyLastRoom = bloodyRoomRoom
    bloodyRoomRoom = TrinketPatches.game:GetRoom()

    if bloodyLastRoom == nil then
        return
    end

    if TrinketPatches.config.crown and bloodyRoomRoom:GetType() == RoomType.ROOM_TREASURE then
        local level = TrinketPatches.game:GetLevel()
        if not (level:GetStage() == LevelStage.STAGE4_1 or level:GetStage() == LevelStage.STAGE4_2) then
            local target = level:GetPreviousRoomIndex()
            level.EnterDoor = -1
            level.LeaveDoor = -1
            player:AnimateTeleport(true)
            TrinketPatches.game:StartRoomTransition(target, Direction.NO_DIRECTION, 1)
        end
    end
end

local f =
TrinketPatches.util.register("MC_POST_NEW_LEVEL") ..
function()
    bloodyLastRoom = nil
    bloodyRoomRoom = TrinketPatches.game:GetRoom()

    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(TrinketType.TRINKET_BLOODY_CROWN) then
        TrinketPatches.config.crown = true
    else
        TrinketPatches.config.crown = false
    end
end

err()
