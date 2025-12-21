if unsupported then return end

local inactiveTime = 5 * 30

local function mario_update(m)
    if m.playerIndex ~= 0 then return end
    if not gGlobalSyncTable.killInactive then inactiveTime = 15 * 30 return end
    if gGlobalSyncTable.roundState ~= ROUND_STATE_ACTIVE then inactiveTime = 15 * 30 return end
    if m.action & ACT_GROUP_MASK == ACT_GROUP_AIRBORNE then inactiveTime = 15 * 30 return end
    if m.controller.buttonPressed ~= 0
    or m.controller.stickX ~= 0
    or m.controller.stickY ~= 0
    or m.controller.extStickX ~= 0
    or m.controller.extStickY ~= 0 then
        inactiveTime = 15 * 30
        return
    end

    inactiveTime = inactiveTime - 1

    if inactiveTime <= 0 then
        m.health = 0xFF
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update)