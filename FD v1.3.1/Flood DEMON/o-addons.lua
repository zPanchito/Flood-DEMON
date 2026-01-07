-- Slides bye bye (idk)
local function slides(m)
    if gNetworkPlayers[0].currLevelNum == LEVEL_CCM then
        if m.area.terrainType == TERRAIN_SLIDE then
            m.area.terrainType = TERRAIN_STONE
        end
    end
end

hook_event(HOOK_BEFORE_PHYS_STEP, slides)

-- No Hud (Roy3314)
function hide_hud()
    hud_hide()
  end
hook_event(HOOK_ON_HUD_RENDER, hide_hud)

--EmeraldLockdown door system
---@param m MarioState
---@param o Object
local function should_push_or_pull_door(m, o)
    local dx = o.oPosX - m.pos.x
    local dz = o.oPosZ - m.pos.z

    local dYaw = o.oMoveAngleYaw - atan2s(dz, dx)

    if dYaw >= -0x4000 and dYaw <= 0x4000 then
        return 1
    else
        return 0
    end
end

---@param o Object
local function door_loop(o)
    if o.oAction == 0 then
        if dist_between_objects(o, gMarioStates[0].marioObj) <= 1000 then
            o.oAction = 5
        end
    end

    if o.oAction == 5 then
        if o.oTimer == 0 then
            if should_push_or_pull_door(gMarioStates[0], o) == 1 then
                cur_obj_init_animation(1)
            else
                cur_obj_init_animation(2)
            end

            cur_obj_play_sound_2(SOUND_GENERAL_OPEN_WOOD_DOOR)
        end

        if o.header.gfx.animInfo.animFrame >= 40 then
            o.header.gfx.animInfo.animFrame = 40
            o.header.gfx.animInfo.prevAnimFrame = 40
        end

        if dist_between_objects(o, gMarioStates[0].marioObj) > 1000 then
            o.oAction = 6
        end
    end

    if o.oAction == 6 then
        if o.header.gfx.animInfo.animFrame >= 78 then
            cur_obj_play_sound_2(SOUND_GENERAL_CLOSE_WOOD_DOOR)
            o.oAction = 0
        end
    end
end

hook_behavior(id_bhvDoor, OBJ_LIST_SURFACE, false, function (o) o.collisionData = nil end, door_loop, "door")

function star_door_loop(o)
    if dist_between_objects(gMarioStates[0].marioObj, o) <= 1000 then
        if o.oAction == 0 then
            o.oAction = 1
            doorsClosing = false
        elseif o.oAction == 3 and not doorsClosing then
            o.oAction = 2
        end
        doorsCanClose = false
    elseif o.oAction == 3 then
        if doorsCanClose == false and not doorsClosing then
            o.oAction = 2
            doorsCanClose = true
        else
            doorsClosing = true
        end
    end
end


hook_behavior(id_bhvStarDoor, OBJ_LIST_SURFACE, false, function (o) o.collisionData = nil end, star_door_loop, "star-door")

-- removes the star spawn cutscene, created by Sunk 
function remove_timestop()
    ---@type MarioState
    local m = gMarioStates[0]
    ---@type Camera
    local c = gMarioStates[0].area.camera

    if m == nil or c == nil then
        return
    end

    if (c.cutscene == CUTSCENE_STAR_SPAWN) or (c.cutscene == CUTSCENE_RED_COIN_STAR_SPAWN) or (c.cutscene == CUTSCENE_ENTER_BOWSER_ARENA) then
        disable_time_stop_including_mario()
        m.freeze = 0
        c.cutscene = 0
    end
end

hook_event(HOOK_UPDATE, remove_timestop)