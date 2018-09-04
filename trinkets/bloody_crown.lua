local bloodyRoomRoom = nil
local bloodyLastRoom = nil
local enteredWithBloodyCrown = false

local function bloodyRoomChange()
    bloodyLastRoom = bloodyRoomRoom
    bloodyRoomRoom = TrinketPatches.game:GetRoom()

    if bloodyLastRoom == nil then
        return
    end

    if enteredWithBloodyCrown and bloodyRoomRoom:GetType() == RoomType.ROOM_TREASURE then
        local level = TrinketPatches.game:GetLevel()
        if not (level:GetStage() == LevelStage.STAGE4_1 or level:GetStage() == LevelStage.STAGE4_2) then
            local target = level:GetPreviousRoomIndex()
            level.EnterDoor = -1
            level.LeaveDoor = -1
            TrinketPatches.game:StartRoomTransition(target, Direction.NO_DIRECTION, 1)
        end
    end
end

local function bloodyFloorChange()
    bloodyLastRoom = nil
    bloodyRoomRoom = TrinketPatches.game:GetRoom()

    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(TrinketType.TRINKET_BLOODY_CROWN) then
        enteredWithBloodyCrown = true
    else
        enteredWithBloodyCrown = false
    end
end

return {
    MC_POST_NEW_ROOM = bloodyRoomChange,
    MC_POST_NEW_LEVEL = bloodyFloorChange
}
