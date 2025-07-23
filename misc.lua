-- エリック
if unsupported then return end

E_MODEL_FLOOD = smlua_model_util_get_id("flood_geo")
E_MODEL_CTT = smlua_model_util_get_id("ctt_geo") 
E_MODEL_BASE = smlua_model_util_get_id("base_geo")
E_MODEL_TROLLFACE = smlua_model_util_get_id("trollface_geo")
E_MODEL_LAUNCHPAD = smlua_model_util_get_id("launchpad_geo")

local COL_BASE = smlua_collision_util_get("base_collision")
local COL_LAUNCHPAD = smlua_collision_util_get("launchpad_collision")
local metalcapboost = 1
local sleddirection = 1

--- @param o Object
local function bhv_water_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oAnimState = gLevels[gGlobalSyncTable.level].type

    o.header.gfx.skipInViewCheck = true

    o.oFaceAnglePitch = 0
    o.oFaceAngleRoll = 0
end

--- @param o Object
local function bhv_trollface_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
	o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
	o.header.gfx.skipInViewCheck = true
    o.hitboxRadius = 125
    o.hitboxHeight = 125
    o.oAction = 0
	cur_obj_scale(0.5)
end

--- @param o Object
local function bhv_trollface_loop(o)
    local pos = gLevels[gGlobalSyncTable.level].goalPos
    local pmario = nearest_living_mario_state_to_object({x=pos.x,y=pos.y,z=pos.z})
    local nmetalcap = obj_get_nearest_object_with_behavior_id(o, id_bhvMetalCap)
    local m = gMarioStates[0]

    if nmetalcap ~= nil then
        o.oAction = 1
    else
        o.oAction = 0
    end

    if o.oAction == 0 then
        if o.oTimer > 120 then
            if metalcapboost > 1 then metalcapboost = metalcapboost - 0.01 end
            if metalcapboost <= 1 then metalcapboost = 1 end --< safeguard
            if metalcapboost > 8 then metalcapboost = 8 end

            if pmario ~= nil then
                obj_rotate_towards_point(o, pmario.pos, 0,0,0,0)
                o.oForwardVel = 15 * (dist_between_objects(o, pmario.marioObj) / 325) * metalcapboost
                obj_compute_vel_from_move_pitch(o.oForwardVel)
                obj_move_xyz_using_fvel_and_yaw(o)
            end
        end
    end

    if o.oAction == 1 then
        if o.oTimer > 32 then
            if pmario ~= nil then
                obj_rotate_towards_point(o, {x=nmetalcap.oPosX,y=nmetalcap.oPosY,z=nmetalcap.oPosZ}, 0,0,0,0)
                o.oForwardVel = 45
                obj_compute_vel_from_move_pitch(o.oForwardVel)
                obj_move_xyz_using_fvel_and_yaw(o)
            end

            if dist_between_objects(o, nmetalcap) < 75 and o.oTimer > 32 then
                network_play(sTrolleat, m.pos, 1.2, m.playerIndex)
                obj_mark_for_deletion(nmetalcap)
                metalcapboost = metalcapboost + 2
            end
        end
    end

    o.oGraphYOffset = math.sin(o.oTimer * 0.2) * 30

	if dist_between_objects(o, m.marioObj) < 75 and o.oTimer > 120 then
	    network_play(sTrolldie, m.pos, 1.2, m.playerIndex)
        m.health = 0xff
        metalcapboost = 1
	end
end

id_bhvTrollface = hook_behavior(nil, OBJ_LIST_SURFACE, true, bhv_trollface_init, bhv_trollface_loop)

--- @param o Object
local function bhv_water_loop(o)
    o.oPosY = gGlobalSyncTable.waterLevel
    o.oFaceAngleYaw = o.oTimer * 5 * (gLevels[gGlobalSyncTable.level].speed or 1)

    if gLevels[gGlobalSyncTable.level].floodScale ~= nil then
        obj_scale(o, gLevels[gGlobalSyncTable.level].floodScale)
    end
end

id_bhvWater = hook_behavior(nil, OBJ_LIST_SURFACE, true, bhv_water_init, bhv_water_loop)

--- @param o Object
local function bhv_custom_static_object_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.skipInViewCheck = true
    set_override_far(50000)
end

id_bhvCustomStaticObject = hook_behavior(nil, OBJ_LIST_LEVEL, true, bhv_custom_static_object_init, nil)


--- @param o Object
local function bhv_final_star_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.hitboxRadius = 160
    o.hitboxHeight = 100

    cur_obj_scale(2)
end

--- @param o Object
local function bhv_final_star_loop(o)
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x800
end

id_bhvFinalStar = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_final_star_init, bhv_final_star_loop)


--- @param o Object
local function bhv_flood_flag_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oInteractType = INTERACT_POLE
    o.hitboxRadius = 80
    o.hitboxHeight = 700
    o.oIntangibleTimer = 0
    o.oAnimations = gObjectAnimations.koopa_flag_seg6_anims_06001028

    cur_obj_init_animation(0)

end

--- @param o Object
local function bhv_flood_flag_loop(o)
    bhv_pole_base_loop()
end

local function water_check()
    if gLevels[gGlobalSyncTable.level].noWater 
    and gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        for i = 0, 10 do
            set_water_level(i, -90000, false)
        end
    end
end

id_bhvFloodFlag = hook_behavior(nil, OBJ_LIST_POLELIKE, true, bhv_flood_flag_init, bhv_flood_flag_loop)

local function bhv_launchpad_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oCollisionDistance = 500
    o.collisionData = COL_LAUNCHPAD
    obj_scale(o, 0.85)
end

local function bhv_launchpad_loop(o)
    local m = nearest_mario_state_to_object(o)
    if m.marioObj.platform == o then
        play_mario_jump_sound(m)
        if o.oBehParams2ndByte ~= 255 then
            set_mario_action(m, ACT_TWIRLING, 0)
            m.vel.y = o.oBehParams2ndByte
        else
            spawn_non_sync_object(
                id_bhvWingCap,
                E_MODEL_NONE,
                m.pos.x + m.vel.x, m.pos.y + m.vel.y, m.pos.z + m.vel.z,
                nil
            )
            set_mario_action(m, ACT_FLYING_TRIPLE_JUMP, 0)
            mario_set_forward_vel(m, 100)
            vec3f_set(m.angleVel, 0, 0, 0)
            vec3f_set(m.faceAngle, 0, 0x4500, 0)
            m.vel.y = 55
        end
    end
    load_object_collision_model()
end

id_bhvLaunchpad = hook_behavior(nil, OBJ_LIST_SURFACE, true, bhv_launchpad_init, bhv_launchpad_loop)

local function bhv_baseplatform_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oCollisionDistance = 7000
    o.collisionData = COL_BASE
    obj_scale(o, 1)
end

local function bhv_baseplatform_loop(o)
    load_object_collision_model()
end

id_bhvBasePlatform = hook_behavior(nil, OBJ_LIST_SURFACE, true, bhv_baseplatform_init, bhv_baseplatform_loop)

--bhvEmitter_MOP, the thing that u don't want to see an error with
---@param name string
---@return Pointer_BehaviorScript
function get_behavior_from_name(name)
    return get_behavior_from_id(get_id_from_behavior_name(name))
end

bhvEmitter_MOP = get_behavior_from_name("bhvEmitter_MOP")

---@param parent Object
---@param model ModelExtendedId
---@param behaviorId BehaviorId
function spawn_object_attached_to_parent(parent, model, behaviorId)
    local obj = spawn_non_sync_object(behaviorId, model, 0, 0, 0, nil)
    if obj == nil then return nil end

    obj_copy_pos_and_angle(obj, parent)
    return obj
end

---@param obj Object
function bhv_emitter_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.oDrawingDistance = 5120
end

---@param obj Object
function bhv_emitter_loop(obj)
    spawn_object_attached_to_parent(obj, E_MODEL_NONE, id_bhvSparkleSpawn)
end

--- @param o Object
local function obj_hide(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
end

--- @param o Object
local function obj_mark_for_deletion_on_sync(o)
    if gNetworkPlayers[0].currAreaSyncValid then obj_mark_for_deletion(o) end
end

hook_behavior(id_bhvStar, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvHoot, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvBalconyBigBoo, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvWaterLevelDiamond, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvKoopaRaceEndpoint, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvCapSwitch, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvCapSwitchBase, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvRacingPenguin, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvHiddenStar, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvSpawnedStar, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvUnusedFakeStar, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvFakeStar, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvHiddenRedCoinStar, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvHiddenStarTrigger, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvRedCoinStarMarker, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvChainChompGate, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvOpenableGrill, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvToadMessage, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvExclamationBox, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvWarpPipe, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)
hook_behavior(id_bhvBowser, OBJ_LIST_UNIMPORTANT, true, obj_hide, obj_mark_for_deletion_on_sync)

local function slide(m)
	    if gNetworkPlayers[0].currLevelNum == 27 then
        if m.area.terrainType == TERRAIN_SLIDE then
            m.area.terrainType = TERRAIN_STONE
            end
        end		
	end	

--- @param m MarioState
local function before_phys_step(m)
    if m.playerIndex ~= 0 then return end
    if m.pos.y + 40 < gGlobalSyncTable.waterLevel and gNetworkPlayers[m.playerIndex].currLevelNum == gGlobalSyncTable.level then
        m.vel.y = m.vel.y + 2
        m.peakHeight = m.pos.y
    end
end

--- @param m MarioState
--- @param o Object
local function allow_interact(m, o)
    if m.action == ACT_SPECTATOR or m.action == ACT_FOLLOW_SPECTATOR or
    (o.header.gfx.node.flags & GRAPH_RENDER_ACTIVE) == 0 or
    o.oInteractType == INTERACT_WARP_DOOR or
    o.oInteractType == INTERACT_WARP and gNetworkPlayers[0].currLevelNum ~= 53 then
        return false
    end

    if o.behavior == get_behavior_from_id(id_bhvMario) then
        for i = 0, MAX_PLAYERS - 1 do
            if gMarioStates[i].marioObj == o then
                local oM = gMarioStates[i]

                if oM.action == ACT_SPECTATOR or oM.action == ACT_FOLLOW_SPECTATOR then
                    return false
                end
            end
        end
    end
end

local function on_death()
    local m = gMarioStates[0]
    if m.floor.type == SURFACE_DEATH_PLANE or m.floor.type == SURFACE_VERTICAL_WIND then
        m.health = 0xFF
    end
    return false
end

local function on_pause_exit()
    if network_is_server() then
        network_send(true, { restart = true })
        level_restart()
    end

    return false
end

--- @param m MarioState
local function allow_hazard_surface(m)
    if m.health <= 0xFF then return false end
    return true
end

--- @param o Object
local function on_object_unload(o)
    local m = gMarioStates[0]
    if (o.header.gfx.node.flags & GRAPH_RENDER_INVISIBLE) == 0 and obj_has_behavior_id(o, id_bhv1Up) == 1 and obj_check_hitbox_overlap(o, m.marioObj) then
        m.healCounter = 31
        m.hurtCounter = 0
    end
end

local function on_packet_receive(dataTable)
    if dataTable.restart then level_restart() end
end

local function trollface_skin(model)
    eTrollProperties.skin = model
end

function wrapNumber(num, max)
    return (num % (max + 1) + max + 1) % (max + 1)
end

hook_event(HOOK_UPDATE, water_check)
hook_event(HOOK_ON_LEVEL_INIT, water_check)
hook_event(HOOK_BEFORE_PHYS_STEP, before_phys_step)
hook_event(HOOK_ALLOW_INTERACT, allow_interact)
hook_event(HOOK_ON_DEATH, on_death)
hook_event(HOOK_ON_PAUSE_EXIT, on_pause_exit)
hook_event(HOOK_ALLOW_HAZARD_SURFACE, allow_hazard_surface)
hook_event(HOOK_ON_OBJECT_UNLOAD, on_object_unload)
hook_event(HOOK_ON_PACKET_RECEIVE, on_packet_receive)
hook_event(HOOK_BEFORE_PHYS_STEP, slide)	