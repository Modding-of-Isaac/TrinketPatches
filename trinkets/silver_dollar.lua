local silverRoomRoom = nil
local silverLastRoom = nil
local enteredWithSilverDollar = false

local function silverRoomChange()
    silverLastRoom = silverRoomRoom
    silverRoomRoom = TrinketPatches.game:GetRoom()

    if silverLastRoom == nil then
        return
    end

    if enteredWithSilverDollar and silverRoomRoom:GetType() == RoomType.ROOM_SHOP then
        local level = TrinketPatches.game:GetLevel()
        if not (level:GetStage() == LevelStage.STAGE4_1 or level:GetStage() == LevelStage.STAGE4_2) then
            local target = level:GetPreviousRoomIndex()
            level.EnterDoor = -1
            level.LeaveDoor = -1
            TrinketPatches.game:StartRoomTransition(target, Direction.NO_DIRECTION, 1)
        end
    end
end

local function silverFloorChange()
    silverLastRoom = nil
    silverRoomRoom = TrinketPatches.game:GetRoom()

    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(TrinketType.TRINKET_SILVER_DOLLAR) then
        enteredWithSilverDollar = true
    else
        enteredWithSilverDollar = false
    end
end

return {
    MC_POST_NEW_ROOM = silverRoomChange,
    MC_POST_NEW_LEVEL = silverFloorChange
}
