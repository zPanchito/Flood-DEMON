-- name: !Flood \\#900C3F\\DEMON! \\#dcdcdc\\Pre-Release [WIP]
-- ignore-script-warnings: true
-- incompatible: gamemode
-- description: ---- Flood \\#900C3F\\DEMON!\\#dcdcdc\\ ----     \n\n\\#dcdcdc\\Sequel to Flood Extreme. Created by Erikku, I also thank him for his help with this mod <3 \n\n -- Credits -- \n\Flood DEMON!: zPancho!\n\Flood Extreme: Erikku\n\Flood Nightmare: DT Ryan \n\n - Play Tester's - \n\JCM-Corlg!\n\Goku\n\Cent\n\n -- Pr...--Cu3I4 --\n\ ..-. .-..0od ??....3??.-..?L?if unsupported then return end
-- エリック

LEVEL_LOBBY = LEVEL_ZEROLIFE

flood_demon_data = {
    version = 'v1.3',
    date_released = '25/12/25'
}

if unsupported then return end

ROUND_STATE_INACTIVE   = 0
ROUND_STATE_ACTIVE     = 1
ROUND_STATE_END        = 2
ROUND_COOLDOWN         = 31 * 30 -- 11 seconds, the 11 should only be shown on 1 frame [its basically 10 seconds (11 - 1)]

SPECTATOR_MODE_NORMAL  = 0
SPECTATOR_MODE_FOLLOW  = 1

TEX_FLOOD_FLAG = get_texture_info("flood_flag")

local globalTimer = 0
local timerr = 0
local deadp = 0
local listedSurvivors = false
local m = gMarioStates[0]

version = "v1.3"
targetPlayer = 0
deathspawn = 0

gGlobalSyncTable.roundState = ROUND_STATE_INACTIVE
gGlobalSyncTable.timer = ROUND_COOLDOWN
gGlobalSyncTable.level = 1
gGlobalSyncTable.waterLevel = -20000
gGlobalSyncTable.speedMultiplier = 1
gGlobalSyncTable.ttcIndex = 0
gGlobalSyncTable.coinCount = 4
gGlobalSyncTable.mapMode = 0
gGlobalSyncTable.popups = true
gGlobalSyncTable.classic = false
gGlobalSyncTable.hardcodedfrfr = true
gGlobalSyncTable.modif_gravity = false
gGlobalSyncTable.modif_coinless = false
gGlobalSyncTable.modif_trollface = false
gGlobalSyncTable.modif_daredevil = false
gGlobalSyncTable.modif_slide_jump = false
gGlobalSyncTable.modif_pvp = false
gGlobalSyncTable.lp = false
gLevelValues.entryLevel = LEVEL_LOBBY
gLevelValues.floorLowerLimit = -20000
gLevelValues.floorLowerLimitMisc = -20000 + 1000
gLevelValues.floorLowerLimitShadow = -20000 + 1000.0
gLevelValues.fixCollisionBugs = 1
gLevelValues.fixCollisionBugsRoundedCorners = 0
gLevelValues.pssSlideStarTime = 999
gLevelValues.metalCapDuration = 1
gLevelValues.wingCapDuration = 0
gLevelValues.vanishCapDuration = 150
gLevelValues.metalCapDurationCotmc = 1
gLevelValues.wingCapDurationTotwc = 0
gLevelValues.vanishCapDurationVcutm = 150
gServerSettings.skipIntro = 1
gServerSettings.stayInLevelAfterStar = 2
if moveset then gGlobalSyncTable.modif_trollface = true end

eFloodVariables = {
    hudHide = false,
    spectatorMode = SPECTATOR_MODE_NORMAL,
    globalFont = FONT_MENU,
    textlv1Scale = 0.2,
    textlv2Scale = 0.15,
    engine = false
}

local function get_dest_act()
    return gLevels[gGlobalSyncTable.level].act or 6
end

for i = 0, MAX_PLAYERS - 1 do
    gPlayerSyncTable[i].finished = false
    gPlayerSyncTable[i].time = 0
end

local flagIconPrevPos = { x = 0, y = 0 }
local customCoinCounter = 0
modifiersfe = {}
floodact = get_dest_act()

function round_start()
    customCoinCounter = 0
    gGlobalSyncTable.alpha = 0
    gGlobalSyncTable.roundState = ROUND_STATE_ACTIVE
    gGlobalSyncTable.timer = 100
end

function var()
    if gGlobalSyncTable.mapMode == 0 then
        round_start()
    elseif gGlobalSyncTable.mapMode == 1 then
        gGlobalSyncTable.level = math.random(#gLevels)
        round_start()
    elseif gGlobalSyncTable.mapMode == 2 then
        gGlobalSyncTable.timer = 1
        host_init_voting_timer()
    end
end

local function checker()
    if gGlobalSyncTable.modif_trollface == true then
        if table.contains(modifiersfe, "Troll") == false then
            table.insert(modifiersfe, "Troll")
        end
    else
        if table.contains(modifiersfe, "Troll") == true then
            local pos = table.poselement(modifiersfe, "Troll")
            table.remove(modifiersfe, pos)
        end
    end

    if gGlobalSyncTable.modif_daredevil == true then
        if table.contains(modifiersfe, "Devil") == false then
            table.insert(modifiersfe, "Devil")
        end
    else
        if table.contains(modifiersfe, "Devil") == true then
            local pos = table.poselement(modifiersfe, "Devil")
            table.remove(modifiersfe, pos)
        end
    end

    if gGlobalSyncTable.modif_gravity == true then
        if table.contains(modifiersfe, "Gravity") == false then
            table.insert(modifiersfe, "Gravity")
        end
    else
        if table.contains(modifiersfe, "Gravity") == true then
            local pos = table.poselement(modifiersfe, "Gravity")
            table.remove(modifiersfe, pos)
        end
    end

    if gGlobalSyncTable.modif_slide_jump == true then
        if table.contains(modifiersfe, "Slide-Jump") == false then
            table.insert(modifiersfe, "Slide-Jump")
        end
    else
        if table.contains(modifiersfe, "Slide-Jump") == true then
            local pos = table.poselement(modifiersfe, "Slide-Jump")
            table.remove(modifiersfe, pos)
        end
    end

    if gGlobalSyncTable.modif_coinless == true then
        if table.contains(modifiersfe, "No Coin") == false then
            table.insert(modifiersfe, "No Coin")
        end
    else
        if table.contains(modifiersfe, "No Coin") == true then
            local pos = table.poselement(modifiersfe, "No Coin")
            table.remove(modifiersfe, pos)
        end
    end

    if gGlobalSyncTable.modif_pvp == true then
        if table.contains(modifiersfe, "PvP") == false then
            table.insert(modifiersfe, "PvP")
        end
    else
        if table.contains(modifiersfe, "PvP") == true then
            local pos = table.poselement(modifiersfe, "PvP")
            table.remove(modifiersfe, pos)
        end
    end
end

function end_var()
    gGlobalSyncTable.roundState = ROUND_STATE_END
    gGlobalSyncTable.timer = 5 * 30
    gGlobalSyncTable.waterLevel = -20000
end

local function server_update()
    if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        if gNetworkPlayers[0].currLevelNum == gLevels[gGlobalSyncTable.level].level then
            gGlobalSyncTable.waterLevel = gGlobalSyncTable.waterLevel + gLevels[gGlobalSyncTable.level].speed * gGlobalSyncTable.speedMultiplier

            local active = 0
            for i = 0, (MAX_PLAYERS - 1) do
                local m = gMarioStates[i]
                if active_player(m) ~= 0 and m.health > 0xff and not gPlayerSyncTable[i].finished then
                    active = active + 1
                end
            end

            if active == 0 then
                local dead = 0
                for i = 0, (MAX_PLAYERS) - 1 do
                    if active_player(gMarioStates[i]) ~= 0 and gMarioStates[i].health <= 0xff then
                        dead = dead + 1
                    end
                end

                if gGlobalSyncTable.timer > 0 then
                    gGlobalSyncTable.timer = gGlobalSyncTable.timer - 1
                else
                    end_var()
                    local finished = 0
                    for i = 0, (MAX_PLAYERS - 1) do
                        if active_player(gMarioStates[i]) ~= 0 and gPlayerSyncTable[i].finished then
                            finished = finished + 1
                        end
                    end
                    if finished ~= 0 then
                        gGlobalSyncTable.level = gGlobalSyncTable.level + 1
                        if gGlobalSyncTable.level > FLOOD_LEVEL_COUNT - FLOOD_BONUS_LEVELS then
                            gGlobalSyncTable.level = 1
                        end
                    end
                end
            end
        end
    elseif gGlobalSyncTable.roundState == ROUND_STATE_INACTIVE then
        if network_player_connected_count() > 1 then
            if gGlobalSyncTable.timer > 0 then
                gGlobalSyncTable.timer = gGlobalSyncTable.timer - 1

                if gGlobalSyncTable.timer == 30 or gGlobalSyncTable.timer == 60 or gGlobalSyncTable.timer == 90 then
                    play_sound(SOUND_MENU_CHANGE_SELECT, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                elseif gGlobalSyncTable.timer == 11 then
                    play_sound(SOUND_GENERAL_RACE_GUN_SHOT, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                end
            end
            
            if gGlobalSyncTable.timer == 1 then
                if gGlobalSyncTable.mapMode == 0 then
                    round_start()
                elseif gGlobalSyncTable.mapMode == 1 then
                    gGlobalSyncTable.level = math.random(#gLevels)
                    round_start()
                elseif gGlobalSyncTable.mapMode == 2 then
                    init_voting_timer()
                end
            end
        end
    elseif gGlobalSyncTable.roundState == ROUND_STATE_END then
        if gGlobalSyncTable.timer > 0 then
            gGlobalSyncTable.timer = gGlobalSyncTable.timer - 1
        else
            gGlobalSyncTable.timer = ROUND_COOLDOWN
            gGlobalSyncTable.roundState = ROUND_STATE_INACTIVE
        end
    end
end

local function get_modifiers_string()
    if not cheats and not moveset then return "" end

    local modifiers = " ("
    if moveset then
        modifiers = modifiers .. "Moveset"
    else
        modifiers = modifiers .. "No moveset"
    end
    if cheats then
        modifiers = modifiers .. ", cheats"
    end
    modifiers = modifiers .. ")"
    return modifiers
end

function level_restart()
    round_start()
    gGlobalSyncTable.timer = 100
    init_single_mario(gMarioStates[0])
    mario_set_full_health(gMarioStates[0])
    gPlayerSyncTable[0].time = 0
    warp_to_flood_level(gLevels[gGlobalSyncTable.level].level, gLevels[gGlobalSyncTable.level].area, floodact)
    customCoinCounter = 0
end

function round_skip()
    network_send(true, { restart = true })
    if gGlobalSyncTable.level < FLOOD_LEVEL_COUNT then
        gGlobalSyncTable.level = gGlobalSyncTable.level + 1
        network_send(true, { restart = true })
        level_restart()
    else
        network_send(true, { restart = true })
        level_restart()
        gGlobalSyncTable.level = 1
	end
end

local function update()
    if gGlobalSyncTable.roundState == ROUND_STATE_INACTIVE and not network_is_server() then
        if gGlobalSyncTable.timer == 1 and not gGlobalSyncTable.map_deciding then
            if gGlobalSyncTable.mapMode == 2 then
                init_voting_timer()
            end
        end
    end

    if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        local levelData = gLevels[gGlobalSyncTable.level]
        local currentArea = gNetworkPlayers[0].currAreaIndex

        if obj_get_first_with_behavior_id(id_bhvWater) == nil then
            spawn_non_sync_object(
                id_bhvWater,
                E_MODEL_FLOOD,
                0, gGlobalSyncTable.waterLevel, 0,
                nil
            )
        end

        if levelData.spawnArea ~= true then
            if m.floor ~= nil and (m.floor.type == SURFACE_WARP or (m.floor.type >= SURFACE_PAINTING_WARP_D3 and m.floor.type <= SURFACE_PAINTING_WARP_FC) or (m.floor.type >= SURFACE_INSTANT_WARP_1B and m.floor.type <= SURFACE_INSTANT_WARP_1E)) then
                m.floor.type = SURFACE_DEFAULT
            end
        elseif levelData.spawnArea == true then
            if obj_get_first_with_behavior_id(id_bhvFloodFlag) == nil then
                local pos = levelData.goalPos or {x=0, y=0, z=0, a=0}

                spawn_non_sync_object(
                    id_bhvFloodFlag,
                    E_MODEL_KOOPA_FLAG,
                    pos.x, pos.y + 100, pos.z,
                    function(o)
                        o.oFaceAnglePitch = 0
                        o.oFaceAngleYaw = pos.a or 0
                        o.oFaceAngleRoll = 0
                    end
                )

                if levelData.containsbase == true then
                    spawn_non_sync_object(
                        id_bhvBasePlatform,
                        E_MODEL_BASE,
                        pos.x, pos.y, pos.z,
                        function(o)
                            o.oFaceAnglePitch = 0
                            o.oFaceAngleYaw = 0
                            o.oFaceAngleRoll = 0
                        end
                    )
                end
            end
        else
            local flag = obj_get_first_with_behavior_id(id_bhvFloodFlag)
            if flag then
                obj_mark_for_deletion(flag)
            end
        end
    end

    if network_is_server() then server_update() end

    if gGlobalSyncTable.roundState ~= ROUND_STATE_ACTIVE then
        if gNetworkPlayers[0].currLevelNum ~= LEVEL_LOBBY or gNetworkPlayers[0].currActNum ~= 0 then
            warp_to_flood_level(LEVEL_LOBBY, 1, 0)
        end                
    elseif gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        if gNetworkPlayers[0].currLevelNum ~= gLevels[gGlobalSyncTable.level].level or gNetworkPlayers[0].currActNum ~= floodact then
            mario_set_full_health(gMarioStates[0])
            gPlayerSyncTable[0].time = 0
            gPlayerSyncTable[0].finished = false
            warp_to_flood_level(gLevels[gGlobalSyncTable.level].level, gLevels[gGlobalSyncTable.level].area, floodact)
        end
        return checker()
    end

    globalTimer = globalTimer + 1
    local m = gMarioStates[0]
    if m.area ~= nil and m.area.camera ~= nil and (m.area.camera.cutscene == CUTSCENE_STAR_SPAWN or m.area.camera.cutscene == CUTSCENE_RED_COIN_STAR_SPAWN) then
        disable_time_stop_including_mario()
        m.area.camera.cutscene = 0
        m.freeze = 0
    end
end

--- @param m MarioState
local function mario_update(m)
    if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        network_player_set_override_location(gNetworkPlayers[m.playerIndex], name_of_level(gLevels[gGlobalSyncTable.level].level, gLevels[gGlobalSyncTable.level].area, gLevels[gGlobalSyncTable.level].codeName, gLevels[gGlobalSyncTable.level]))
    else
        network_player_set_override_location(gNetworkPlayers[m.playerIndex], "Lobby")
    end

    if m.health > 0xff and not gPlayerSyncTable[m.playerIndex].finished then
        network_player_set_description(gNetworkPlayers[m.playerIndex], "Alive", 75, 255, 75, 255)
    elseif m.health > 0xff then
        network_player_set_description(gNetworkPlayers[m.playerIndex], "GG!", 255, 215, 0, 255)
    else
        network_player_set_description(gNetworkPlayers[m.playerIndex], "Dead", 255, 75, 75, 255)
    end
	
    if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        if not gPlayerSyncTable[m.playerIndex].finished and m.health > 0xFF then
            gPlayerSyncTable[m.playerIndex].time = gPlayerSyncTable[m.playerIndex].time + 1
        end
        timerr = timerr + 1
    end

    if gGlobalSyncTable.roundState == ROUND_STATE_INACTIVE then
       timerr = 0
       deadp = 0
    end

    if m.playerIndex == 0 then
        if m.health == 0xFF and deadp == 0 then
            if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE and timerr > 60 and gGlobalSyncTable.popups == true then
                deadp = 1
                if network_player_connected_count() > 1 then 
                    djui_popup_create_global(network_get_player_text_color_string(0)..gNetworkPlayers[m.playerIndex].name.."\\#ffffff\\ has died", 1)
                end
				m.health = 0xFF
            end
        end
    end	

    if m.playerIndex ~= 0 then return end

    ---@type MarioState
    local m = gMarioStates[0]
    ---@type Camera
    local c = gMarioStates[0].area.camera

    if m == nil or c == nil then
        return
    end

    if m.action == ACT_STEEP_JUMP then
        m.action = ACT_JUMP
    elseif m.action == ACT_JUMBO_STAR_CUTSCENE then
        m.flags = m.flags | MARIO_WING_CAP
    end

    if gLevels[gGlobalSyncTable.level].surfaceKill ~= true then
        if m.floor ~= nil and (m.floor.type == SURFACE_INSTANT_QUICKSAND or m.floor.type == SURFACE_INSTANT_MOVING_QUICKSAND) then
            m.floor.type = SURFACE_BURNING
        end
    else
        if m.floor.type == SURFACE_INSTANT_QUICKSAND then
            m.floor.type = ACT_QUICKSAND_DEATH
        end
    end

    if gGlobalSyncTable.roundState ~= ROUND_STATE_ACTIVE then
        mario_set_full_health(m)
        m.peakHeight = m.pos.y
        if gGlobalSyncTable.classic == true then
            local DEATH = -6450
            if m.pos.y < DEATH then
                if deathspawn == 0 then
                    vec3f_set(m.pos, -2042, -2926, 1179)
                    m.faceAngle.y = 0x0000
                else
                    vec3f_set(m.pos, 4503, 190, -6253)
                    m.faceAngle.y = -0x4000
                end
                set_mario_action(m, ACT_SPAWN_NO_SPIN_AIRBORNE, 0)
                m.vel.y = 0
            end
        elseif gGlobalSyncTable.classic == false then
            if m.floor ~= nil and (m.floor.type == SURFACE_DEATH_PLANE) then
                m.floor.type = SURFACE_DEFAULT
            end			
        end
    end

    if gGlobalSyncTable.modif_slide_jump == false and m.action == ACT_STEEP_JUMP then
        m.action = ACT_JUMP
    end
		
    if gNetworkPlayers[0].currLevelNum == LEVEL_WMOTR then
        m.flags = m.flags | MARIO_WING_CAP
	end

    if (m.action == ACT_SPAWN_NO_SPIN_AIRBORNE or m.action == ACT_SPAWN_NO_SPIN_LANDING or m.action == ACT_SPAWN_SPIN_AIRBORNE or m.action == ACT_SPAWN_SPIN_LANDING) and m.pos.y < m.floorHeight + 10 then
        set_mario_action(m, ACT_FREEFALL, 0)
    end

    if gNetworkPlayers[0].currLevelNum == LEVEL_CTT then
        m.peakHeight = m.pos.y

        local star = obj_get_first_with_behavior_id(id_bhvFinalStar)
        if star ~= nil and obj_check_hitbox_overlap(m.marioObj, star)
        and m.action ~= ACT_JUMBO_STAR_CUTSCENE
        and m.health > 0xFF then
            spawn_mist_particles()
            set_mario_action(m, ACT_JUMBO_STAR_CUTSCENE, 0)
        end

        if m.action == ACT_JUMBO_STAR_CUTSCENE and m.actionTimer >= 499 then
            set_mario_spectator(m)
        end
    end

    if gGlobalSyncTable.modif_daredevil == true then 
        if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
            m.health = 256 
            if m.hurtCounter > 0.1 or m.pos.y + 40 < gGlobalSyncTable.waterLevel or m.action == ACT_STANDING_DEATH or m.action == ACT_DEATH_EXIT then 
            m.health = 0xFF 
            end
        end      
    end

    if gNetworkPlayers[0].currLevelNum == gLevels[gGlobalSyncTable.level].level and not gPlayerSyncTable[0].finished and ((gNetworkPlayers[0].currLevelNum ~= LEVEL_CTT and m.pos.y == m.floorHeight)
    or ((gNetworkPlayers[0].currLevelNum == LEVEL_CTT and m.action == ACT_JUMBO_STAR_CUTSCENE)) or (m.action & ACT_FLAG_ON_POLE) ~= 0)
    and vec3f_dist(m.pos, gLevels[gGlobalSyncTable.level].goalPos) < 755
    and m.health > 0xFF then
        if m.playerIndex ~= 0 then return end

        gPlayerSyncTable[0].finished = true
        if gGlobalSyncTable.popups == true then
            djui_popup_create_global(network_get_player_text_color_string(0) .. gNetworkPlayers[0].name .. "\\#dcdcdc\\ has finished in\n Time: \\#00ff00\\" .. string.format("%.3f", gPlayerSyncTable[0].time / 30), 2)
        end
        
        local string = ""
        if gNetworkPlayers[0].currLevelNum ~= LEVEL_CTT then
            string = string .. djui_chat_message_create("You escaped the flood!\nTime: \\#00ff00\\" .. string.format("%.3f", gPlayerSyncTable[0].time / 30))
            play_race_fanfare()
        else
            string = string .. djui_chat_message_create("\\#00ff00\\You escaped CTT, \\#ffff00\\Congratulations!\n")
            play_music(0, SEQUENCE_ARGS(8, SEQ_EVENT_CUTSCENE_VICTORY), 0)
        end
    end

    if gPlayerSyncTable[0].finished then
        mario_set_full_health(m)
        if network_player_connected_count() > 1 and m.action ~= ACT_JUMBO_STAR_CUTSCENE and gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
            set_mario_spectator(m)
        end
    else
        if m.playerIndex ~= 0 then return end

        if (m.flags & MARIO_METAL_CAP ~= 0) or (m.flags & MARIO_WING_CAP ~= 0) then
            m.particleFlags=m.particleFlags|PARTICLE_SPARKLES
        elseif (m.flags & MARIO_VANISH_CAP ~= 0) then
            m.particleFlags=m.particleFlags|PARTICLE_DUST
        end
  
	    if (m.action == ACT_SPAWN_NO_SPIN_AIRBORNE or m.action == ACT_SPAWN_NO_SPIN_LANDING or m.action == ACT_SPAWN_SPIN_AIRBORNE or m.action == ACT_SPAWN_SPIN_LANDING) then
	        m.particleFlags = m.particleFlags | PARTICLE_SPARKLES
	    end

        if m.action == ACT_QUICKSAND_DEATH then
            m.health = 0xff
        end
		
		if m.area.camera.cutscene == CUTSCENE_DEATH_EXIT or m.area.camera.cutscene == CUTSCENE_DEATH_ON_BACK or m.area.camera.cutscene == CUTSCENE_DEATH_ON_STOMACH then
		    set_mario_spectator(m)
		end	

        if m.pos.y + 40 < gGlobalSyncTable.waterLevel then
            if (m.flags & MARIO_METAL_CAP) ~= 0 then
            elseif (m.flags & MARIO_VANISH_CAP ) ~= 0 then
                m.health = m.health - 3000
            else
                m.health = m.health - 3000
            end
        end

        if m.health <= 0xff and gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
            local c=network_player_connected_count()
            if c > 1 then
                m.area.camera.cutscene = 0
                set_mario_spectator(m)
            elseif c == 1 and gGlobalSyncTable.hardcodedfrfr then
                end_var()
            else
                gPlayerSyncTable[0].time = gPlayerSyncTable[0].time + 1
            end
        end
    end
end

local function on_hud_render()
    local water = obj_get_first_with_behavior_id(id_bhvWater)
    if gNetworkPlayers[0].currLevelNum == gLevels[gGlobalSyncTable.level].level and water ~= nil then -- LEVEL 52 + 36 VOTING ERROR
        djui_hud_set_resolution(RESOLUTION_DJUI)
        if gLakituState.pos.y < gGlobalSyncTable.waterLevel + 2 then
            switch(water.oAnimState, {
                [FLOOD_WATER] = function()
                    djui_hud_set_adjusted_color(0, 20, 200, 175)
                end,
                [FLOOD_LAVA] = function()
                    djui_hud_set_adjusted_color(200, 0, 0, 175)
                end,
                [FLOOD_SAND] = function()
                    djui_hud_set_adjusted_color(254, 193, 121, 230)
                end,
                [FLOOD_MUD] = function()
                    djui_hud_set_adjusted_color(128, 71, 34, 240)
                end,
                [FLOOD_SNOW] = function()
                    djui_hud_set_adjusted_color(255, 255, 255, 220)
                end,
                [FLOOD_WASTE] = function()
                    djui_hud_set_adjusted_color(74, 123, 0, 220)
                end,
                [FLOOD_DESERT] = function()
                    djui_hud_set_adjusted_color(254, 193, 121, 230)
                end,
                [FLOOD_ACID] = function()
                    djui_hud_set_adjusted_color(0, 142, 36, 190)
                end,
                [FLOOD_POISON] = function()
                    djui_hud_set_adjusted_color(174, 0, 255, 190)
                end,
                [FLOOD_SUNSET] = function()
                    djui_hud_set_adjusted_color(235, 164, 0, 200)
                end,
                [FLOOD_FROSTBITE] = function()
                    djui_hud_set_adjusted_color(126, 197, 249, 200)
                end,
                [FLOOD_CLOUDS] = function()
                    djui_hud_set_adjusted_color(255, 255, 255, 200)
                end,
                [FLOOD_RAINBOW] = function()
                    djui_hud_set_adjusted_color(244, 140, 253, 230)
                end,
                [FLOOD_DARKNESS] = function()
                    djui_hud_set_adjusted_color(0, 0, 0, 200)
                end,
                [FLOOD_MAGMA] = function()
                    djui_hud_set_adjusted_color(237, 0, 0, 220)
                end,
                [FLOOD_SULFUR] = function()
                    djui_hud_set_adjusted_color(0, 20, 167, 220)
                end,
                [FLOOD_COTTON] = function()
                    djui_hud_set_adjusted_color(255, 181, 225, 220)
                end,
                [FLOOD_MOLTEN] = function()
                    djui_hud_set_adjusted_color(225, 106, 19, 220)
                end,
                [FLOOD_OIL] = function()
                    djui_hud_set_adjusted_color(0, 0, 0, 200)
                end,
                [FLOOD_MATRIX] = function()
                    djui_hud_set_adjusted_color(16, 71, 0, 200)
                end,
                [FLOOD_BUP] = function()
                    djui_hud_set_adjusted_color(254, 193, 121, 200)
                end,
                [FLOOD_TIDE] = function()
                    djui_hud_set_adjusted_color(15, 122, 211, 200)
                end,
                [FLOOD_DARKTIDE] = function()
                    djui_hud_set_adjusted_color(15, 75, 124, 200)
                end,
                [FLOOD_VOLCANO] = function()
                    djui_hud_set_adjusted_color(252, 30, 30, 200)
                end,
                [FLOOD_REDTIDE] = function()
                    djui_hud_set_adjusted_color(211, 12, 35, 200)
                end,
                [FLOOD_OPTIC] = function()
                    djui_hud_set_adjusted_color(146, 0, 132, 200)
                end,
            })
            djui_hud_render_rect(0, 0, djui_hud_get_screen_width(), djui_hud_get_screen_height())
            set_lighting_dir(1,128)
        else
            set_lighting_dir(1,0)
        end
    end

    if eFloodVariables.hudHide == false then
        if gGlobalSyncTable.modif_daredevil == true then				
            local m = gMarioStates[0]		
            djui_hud_set_resolution(RESOLUTION_N64);	
            djui_hud_set_font(FONT_HUD)	
            djui_hud_set_adjusted_color(255, 25, 25, 255)		
	        djui_hud_print_text("$$$$$", 360, 55, 1)					
	    end	

        if gGlobalSyncTable.roundState ~= ROUND_STATE_ACTIVE then
            set_lighting_dir(1,0)
        end
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_font(FONT_TINY)

        local level = gLevels[gGlobalSyncTable.level]
        local out = { x = 0, y = 0, z = 0 }
        djui_hud_world_pos_to_screen_pos(level.goalPos, out)
        local dX = clampf(out.x - 0, 0, djui_hud_get_screen_width())
        local dY = clampf(out.y - 0, 0, djui_hud_get_screen_height())

        djui_hud_set_adjusted_color(255, 255, 255, 145)
            
        if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
            if gNetworkPlayers[0].currLevelNum ~= LEVEL_CTT then
                djui_hud_render_texture_interpolated(TEX_FLOOD_FLAG, flagIconPrevPos.x - 8, flagIconPrevPos.y - 8, 0.15, 0.15, dX - 8, dY - 8, 0.15, 0.15)
            end
        end

        djui_hud_set_adjusted_color(255, 255, 255, 255)

        flagIconPrevPos.x = dX
        flagIconPrevPos.y = dY

        local text = if_then_else(gGlobalSyncTable.roundState == ROUND_STATE_INACTIVE, 'Type "/flood start" or press [Start] + [A]', "0.000 seconds" .. get_modifiers_string())
        if gNetworkPlayers[0].currAreaSyncValid then
            if gGlobalSyncTable.roundState == ROUND_STATE_INACTIVE then
                if gGlobalSyncTable.mapMode == 2 then
                    if network_player_connected_count() > 1 then
                        text = if_then_else(network_player_connected_count() > 1, "Voting in " .. tostring(math.floor(gGlobalSyncTable.timer / 30)), 'Type "/flood start" or press [Start] + [A]')
                    end
                else
                    text = if_then_else(network_player_connected_count() > 1, "Starts in " .. tostring(math.floor(gGlobalSyncTable.timer / 30)), 'Type "/flood start" or press [Start] + [A]')
                end
            elseif gGlobalSyncTable.roundState == ROUND_STATE_END then
                text = "Countdown will begin"
                text = if_then_else(network_player_connected_count() > 1, "Countdown will begin", 'Ending')
            elseif gNetworkPlayers[0].currLevelNum == gLevels[gGlobalSyncTable.level].level then
                text = tostring(string.format("%.3f", gPlayerSyncTable[0].time / 30)) .. " seconds" .. get_modifiers_string()
            end
        end

        local scale = 1
        local width = djui_hud_measure_text(text) * scale
        local x = (djui_hud_get_screen_width() - width) * 0.5

        djui_hud_set_adjusted_color(0, 0, 0, 200)
        djui_hud_render_rect(x - 6, 0, width + 12, 17)
        djui_hud_set_adjusted_color(255, 255, 255, 255)
        djui_hud_print_text(text, x, 0, scale)

        hud_render_power_meter(gMarioStates[0].health, djui_hud_get_screen_width() - 64, 0, 64, 64)

        if gGlobalSyncTable.speedMultiplier ~= 1 then
            local speedtex = string.format("%.2fx", gGlobalSyncTable.speedMultiplier)
            local widthtex2 = djui_hud_measure_text(speedtex) * 0.25
            djui_hud_set_adjusted_color(0, 0, 0, 200)
            djui_hud_render_rect((djui_hud_get_screen_width() * 0.5) - widthtex2, 16, widthtex2 + 11, 8)
            djui_hud_set_adjusted_color(255, 255, 255, 255)
            djui_hud_print_text(speedtex, (djui_hud_get_screen_width() * 0.5 - (widthtex2 - 2)), 16, 0.5)
        end

        if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
            textlv1 = name_of_level(gLevels[gGlobalSyncTable.level].level, gLevels[gGlobalSyncTable.level].area, gLevels[gGlobalSyncTable.level].codeName, gLevels[gGlobalSyncTable.level])
            textlv2 = gLevels[gGlobalSyncTable.level].author
        else
            textlv1 = " "
            textlv2 = " "
	    end

 
        djui_hud_set_resolution(RESOLUTION_N64);
        djui_hud_set_font(eFloodVariables.globalFont)
        if (gGlobalSyncTable.modif_coinless or gGlobalSyncTable.modif_daredevil or gGlobalSyncTable.modif_trollface 
        or gGlobalSyncTable.modif_slide_jump or gGlobalSyncTable.modif_gravity or gGlobalSyncTable.modif_pvp) then
            djui_hud_print_text("Modifiers: " ..table.concat(modifiersfe, ", "), 16, 26, eFloodVariables.textlv2Scale)
        end
		       if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE and not eFloodVariables.hudHide then
            djui_hud_print_text(textlv1, 16, 8, eFloodVariables.textlv1Scale)
            djui_hud_set_adjusted_color(255, 255, 255, 255)
            djui_hud_print_text("By", 16, 18, eFloodVariables.textlv2Scale)
            switch(gLevels[gGlobalSyncTable.level].author, authorColors)

            if textlv2 then
                djui_hud_print_text("    " .. textlv2, 16, 18, eFloodVariables.textlv2Scale)
            end
            djui_hud_set_adjusted_color(255, 255, 255, 255)
        end
    

        local metal = get_texture_info("metal")
        local vanish = get_texture_info("vanish")
        local wing = get_texture_info("wing")
	    local wmcap = get_texture_info("wmcap")
	    local vmcap = get_texture_info("vmcap")
	    local wvcap = get_texture_info("wvcap")
        local threecap = get_texture_info("threecap")
        local m = gMarioStates[0]
    
        if (m.flags & (MARIO_WING_CAP | MARIO_METAL_CAP | MARIO_VANISH_CAP)) ~= 0 then
	    djui_hud_set_font(FONT_HUD)
            djui_hud_print_text("=", 37, 204, 1) djui_hud_print_text(tostring(math.ceil(m.capTimer/30)), 53, 204, 1)
        end
        if (m.flags & MARIO_METAL_CAP) ~= 0 and (m.flags & MARIO_WING_CAP) ~= 0 and (m.flags & MARIO_VANISH_CAP) ~= 0 then
	    	djui_hud_render_texture(threecap, 21, 204, 1, 1)
        elseif (m.flags & MARIO_METAL_CAP) ~= 0 and (m.flags & MARIO_WING_CAP) ~= 0 then
	    	djui_hud_render_texture(wmcap, 21, 204, 1, 1)
	    elseif (m.flags & MARIO_METAL_CAP) ~= 0 and (m.flags & MARIO_VANISH_CAP) ~= 0 then
	    	djui_hud_render_texture(vmcap, 21, 204, 1, 1)
	    elseif (m.flags & MARIO_VANISH_CAP) ~= 0 and (m.flags & MARIO_WING_CAP) ~= 0 then
	    	djui_hud_render_texture(wvcap, 21, 204, 1, 1)
        elseif (m.flags & (MARIO_METAL_CAP)) ~= 0 then
             djui_hud_render_texture(metal, 21, 204, 1, 1)
        elseif(m.flags & (MARIO_VANISH_CAP)) ~= 0 then
            djui_hud_render_texture(vanish, 21, 204, 1, 1)
        elseif (m.flags & (MARIO_WING_CAP)) ~= 0 then
            djui_hud_render_texture(wing, 21, 204, 1, 1)
        end
    end
    hud_hide()

    m = gMarioStates[0]
    if m.action == ACT_FOLLOW_SPECTATOR then
        djui_hud_set_font(FONT_MENU)
        scale = 0.2
        text = "< " .. string_without_hex(gNetworkPlayers[targetPlayer].name) .. " >"
        local measureText = djui_hud_measure_text(text)
        x = (djui_hud_get_screen_width() - measureText * scale) / 2
        y = djui_hud_get_screen_height() - 100 * scale
        djui_hud_set_adjusted_color(220, 220, 220, 255)
        djui_hud_print_text(text, x, y, scale)
    end
end

local function on_speed_command(msg)
    local speed = tonumber(msg)

    if not moveset then
        if speed ~= nil then
            speed = clampf(speed, -8, 8)
            djui_chat_message_create("Water speed set to " .. speed)
            gGlobalSyncTable.speedMultiplier = speed

            if gGlobalSyncTable.popups == true then
                djui_popup_create_global("Flood Speed changed to " .. speed .. "x", 1)
            end

            return true
        end
    else
        djui_chat_message_create("Flood speed cannot be changed right now, Try disabiling OMM first.")
        if gGlobalSyncTable.popups == true then
            djui_popup_create_global("Flood Speed was tried to be changed to " .. speed .. "x", 1)
        end
    end

    djui_chat_message_create("/flood \\#8B0000\\speed\\#ff5533\\ [number] \\#ffffff\\\nSets the speed multiplier of the flood")
    return true
end

--info is a mess, i should fix it later
local function on_info_command(msg)
        djui_chat_message_create("Flood \\#8B0000\\DEMON!")
        djui_chat_message_create("A reimagined version of !Flood \\#8B0000\\Extreme!")
        djui_chat_message_create("Flood Extreme by: Bomboclath")
		djui_chat_message_create("Flood DEMON! by: \\#00ff00\\zPan\\#ffff00\\cho!")
        djui_chat_message_create("Version:\\#8B0000\\ "..version)
        djui_chat_message_create("Total Levels:\\#8B0000\\ " .. FLOOD_LEVEL_COUNT)
        djui_chat_message_create("Level name: " .. textlv1)
        djui_chat_message_create("Flood Speed: \\#8B0000\\" .. tostring(gGlobalSyncTable.speedMultiplier .. "x"))
        djui_chat_message_create("Modifiers: " .. table.concat(modifiersfe, ", "))
    return true
end

local function on_level_init()
    save_file_erase_current_backup_save()
    metalcapboost = 1
    if gNetworkPlayers[0].currLevelNum ~= LEVEL_CASTLE_GROUNDS then
        save_file_set_flags(SAVE_FLAG_HAVE_METAL_CAP)
        save_file_set_flags(SAVE_FLAG_HAVE_VANISH_CAP)
        save_file_set_flags(SAVE_FLAG_HAVE_WING_CAP)
    end

    save_file_set_using_backup_slot(true)
    if gGlobalSyncTable.modif_daredevil == false then
        if gGlobalSyncTable and gGlobalSyncTable.level and gLevels[gGlobalSyncTable.level] then
            local skybox = gLevels[gGlobalSyncTable.level]
            if skybox.sky ~= nil then
                set_override_skybox(skybox.sky)
            else
                set_override_skybox(-1)
            end
        else
            set_override_skybox(-1)
        end
    else
        set_override_skybox(BACKGROUND_FLAMING_SKY)
    end

    if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        if network_is_server() then
            local start = gLevels[gGlobalSyncTable.level].customStartPos
            local floodHeight = gLevels[gGlobalSyncTable.level].floodHeight
            if start ~= nil and floodHeight == nil then
                gGlobalSyncTable.waterLevel = find_floor_height(start.x, start.y, start.z) - 1200
            else
                gGlobalSyncTable.waterLevel = if_then_else(gLevels[gGlobalSyncTable.level].area == 1, find_floor_height(gMarioStates[0].pos.x, gMarioStates[0].pos.y, gMarioStates[0].pos.z), gMarioStates[0].pos.y) - 1200
            end
            if floodHeight ~= nil then
                gGlobalSyncTable.waterLevel = floodHeight
            end
        end

        local m = gMarioStates[0]

        if table.contains(modifiersfe, "Troll") == true then
            trollface = spawn_non_sync_object(id_bhvTrollface, E_MODEL_TROLLFACE, m.pos.x, m.pos.y + 800, m.pos.z, nil)
        end

        if gNetworkPlayers[0].currLevelNum == LEVEL_BITS then
            spawn_non_sync_object(
                id_bhvCustomStaticObject,
                E_MODEL_CTT,
                10000, -2000, -40000,
                function(o) obj_scale(o, 0.5) end
            )
        end
        spawn_non_sync_object(
            id_bhvWater,
            E_MODEL_FLOOD,
            0, gGlobalSyncTable.waterLevel, 0,
            nil
        )
    end

    local pos = gLevels[gGlobalSyncTable.level].goalPos
    if pos == nil then return end
    if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        if gNetworkPlayers[0].currLevelNum == LEVEL_CTT then
            spawn_non_sync_object(
                id_bhvFinalStar,
                E_MODEL_STAR,
                pos.x, pos.y, pos.z,
                nil
            )
        else
            if gLevels[gGlobalSyncTable.level].containsbase == true then
                spawn_non_sync_object(
                    id_bhvFloodFlag,
                    E_MODEL_KOOPA_FLAG,
                    pos.x, pos.y + 85, pos.z,
                    --- @param o Object
                    function(o)
                        o.oFaceAnglePitch = 0
                        o.oFaceAngleYaw = pos.a
                        o.oFaceAngleRoll = 0
                    end
                )
                spawn_non_sync_object(
                    id_bhvBasePlatform,
                    E_MODEL_BASE,
                    pos.x, pos.y, pos.z,
                    --- @param o Object
                    function(o)
                        o.oFaceAnglePitch = 0
                        o.oFaceAngleYaw = 0
                        o.oFaceAngleRoll = 0
                    end
                )
                return true
            else
                spawn_non_sync_object(
                    id_bhvFloodFlag,
                    E_MODEL_KOOPA_FLAG,
                    pos.x, pos.y, pos.z,
                    --- @param o Object
                    function(o)
                        o.oFaceAnglePitch = 0
                        o.oFaceAngleYaw = pos.a
                        o.oFaceAngleRoll = 0
                    end
                )
                return true
            end
        end
    end
end

local function on_warp()
    --- @type MarioState
    local m = gMarioStates[0]

    if table.contains(modifiersfe, "PvP") == true then
        gServerSettings.playerInteractions = PLAYER_INTERACTIONS_PVP
        if gGlobalSyncTable.roundState ~= ROUND_STATE_END then
            m.flags = m.flags | MARIO_VANISH_CAP
            m.capTimer = 120 -- 4 seconds in-game
        end
    else 
        gServerSettings.playerInteractions = PLAYER_INTERACTIONS_NONE
    end

    if gNetworkPlayers[0].currLevelNum == LEVEL_CASTLE_GROUNDS then
        m.faceAngle.y = m.faceAngle.y + 0x8000
    elseif gNetworkPlayers[0].currLevelNum == LEVEL_ZEROLIFE and gGlobalSyncTable.roundState ~= ROUND_STATE_ACTIVE then
        if gGlobalSyncTable.roundState == ROUND_STATE_INACTIVE then
            vec3f_set(m.pos, -4659, -3648, -201)
            m.faceAngle.y = 0x2000
        else
            vec3f_set(m.pos, 2663, -2991, -622)
            m.faceAngle.y = 0x0000
        end	
    end

    local customStartPos = gLevels[gGlobalSyncTable.level].customStartPos
    if customStartPos ~= nil and gPlayerSyncTable[0].time <= 30 then
        vec3f_set(m.pos, customStartPos.x, customStartPos.y, customStartPos.z)
        m.faceAngle.y = customStartPos.a
    end

    if not moveset then
        local currMusic = get_current_background_music()
        if gNetworkPlayers[0].currLevelNum == LEVEL_TTM then
            if currMusic == SEQ_LEVEL_GRASS or currMusic == SEQ_LEVEL_UNDERGROUND then
                play_music(0, SEQUENCE_ARGS(4, 0x50), 0)
            end
        end
    end

    if moveset and gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        play_music(0, SEQUENCE_ARGS(4, 0x40), 0)
    end
end

---@param m MarioState
local function on_player_connected(m)
    if network_is_server()
    and gGlobalSyncTable.roundState == ROUND_STATE_INACTIVE
    and m.playerIndex == 0 then
        gGlobalSyncTable.timer = ROUND_COOLDOWN
    end
end

local function before_phys_step(m)		
    if gGlobalSyncTable.modif_gravity == true then
        if m.playerIndex ~= 0 then return end
        if gNetworkPlayers[m.playerIndex].currLevelNum == gLevels[gGlobalSyncTable.level].level then
            m.vel.y = m.vel.y + 1.25
            m.peakHeight = m.pos.y
        end             
    end

    if gLevels[gGlobalSyncTable.level].removeSlide == true then
        if m.area.terrainType == TERRAIN_SLIDE then
                m.area.terrainType = TERRAIN_STONE
	    end
    end
end

local function on_start_command(msg)
    if msg == "?" then
        djui_chat_message_create("/flood \\#8B0000\\start\\#ff5533\\ [1-" .. FLOOD_LEVEL_COUNT .. "]\\#ffffff\\\nSets the level to a specific one or normal progression.\nYou can also play on mode random to set a random map.")
        return true
    end

    if gGlobalSyncTable.mapMode == 1 then
        gGlobalSyncTable.level = math.random(#gLevels)
        round_start()
        return true
    else
        local override = tonumber(msg)
        if override ~= nil then
            override = clamp(math.floor(override), 1, FLOOD_LEVEL_COUNT)
            gGlobalSyncTable.level = override
        else
            for k, v in pairs(gLevels) do
                if msg ~= nil and msg:lower() == v.name then
                    gGlobalSyncTable.level = k
                end
            end
        end
        if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
            network_send(true, { restart = true })
            level_restart()
        else
            round_start()
        end
    end
    return true
end

local function on_time_command(msg)
    local override = tonumber(msg)
    if msg == "?" or override == nil then
        djui_chat_message_create("/flood \\#8B0000\\time\\#ff5533\\ [Number]\\#ffffff\\ Sets round cooldown to a custom one")
        return true
    end

    if override <= 0 then
        djui_chat_message_create("\\#ffff00\\Number must be bigger than 0")
        return true
    end

    if gGlobalSyncTable.roundState ~= ROUND_STATE_ACTIVE then
        ROUND_COOLDOWN = (override + 1) * 30
        gGlobalSyncTable.timer = ROUND_COOLDOWN
        djui_chat_message_create(string.format("\\#ffffff\\Round cooldown set to \\#ff5533\\%d seconds", override))
        

        return true
    else 
        djui_chat_message_create("\\#ff0000\\You can only change the cooldown before the round starts")
        return true
    end

    return true
end

local function on_scoreboard_command()
    djui_chat_message_create("Score:")
    local modifiers = get_modifiers_string()
    local total = 0

    for k = 1, FLOOD_LEVEL_COUNT do
        local level_name = name_of_level(gLevels[k].level, gLevels[k].area, gLevels[k].name, gLevels[k]) or "Unknown"
        local message = level_name .. " - " .. timestamp(gPlayerSyncTable[0].time) .. modifiers
        djui_chat_message_create(message)
        total = total + gPlayerSyncTable[0].time
    end

    djui_chat_message_create("Total Time: " .. timestamp(total))
    return true
end

function hide_djui_hudelements()
    eFloodVariables.hudHide = not eFloodVariables.hudHide
    mod_storage_save_bool("hidehud", eFloodVariables.hudHide)
    return true
end

---@param msg string
local function spectator_command(msg)
    if msg == nil or type(msg) ~= "string" then goto help end
    msg = msg:lower()
    if msg == "normal" then
        eFloodVariables.spectatorMode = SPECTATOR_MODE_NORMAL
        djui_chat_message_create("Spect Mode set to Normal")
        return true
    elseif msg == "follow" then
        eFloodVariables.spectatorMode = SPECTATOR_MODE_FOLLOW
        djui_chat_message_create("Spect Mode set to Following")
        return true
    end
    ::help::

    djui_chat_message_create("/flood \\#8B0000\\spect\\#ff5533\\ [normal|follow]")
    return true
end

local function on_fex_command()
    showSettings = not showSettings
    play_sound(SOUND_MENU_PAUSE, gMarioStates[0].pos)
    return true
end

local function on_flood_command(msg)
    local args = split(msg)
    if args[1] == "start" then
        return on_start_command(args[2])
    elseif args[1] == "speed" then
        return on_speed_command(args[2])
    elseif args[1] == "score" then
        return on_scoreboard_command()
    elseif args[1] == "info" then
        return on_info_command()
    elseif args[1] == "spect" then
        return spectator_command(args[2])
    elseif args[1] == "hide" then
        return hide_djui_hudelements()
    elseif args[1] == "time" then
        return on_time_command(args[2])
    end

    on_fex_command()
    return true
end

local function on_flood_baby_command(msg)
    local args = split(msg)
    if args[1] == "info" then
        return on_info_command()
    elseif args[1] == "score" then
        return on_scoreboard_command()
    elseif args[1] == "spect" then
        return spectator_command(args[2])
    elseif args[1] == "hide" then
        return hide_djui_hudelements()	
    end

    on_fex_command()
    return true
end

local function coin_update(m, o, interactType)
    if gGlobalSyncTable.modif_coinless == true then
        if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
	        if o.oInteractType == INTERACT_COIN then
	   	        m.health = 0xFF
			end
     	end	
    end
end

hud_hide()

hook_event(HOOK_UPDATE, update)
hook_event(HOOK_ON_WARP, on_warp)
hook_event(HOOK_ON_INTERACT, coin_update)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_ON_LEVEL_INIT, on_level_init)
hook_event(HOOK_BEFORE_PHYS_STEP, before_phys_step)
hook_event(HOOK_ON_DIALOG, function () return false end)
hook_event(HOOK_ON_PLAYER_CONNECTED, on_player_connected)

if not network_is_server() and not network_is_moderator() then
    hook_chat_command("flood", "\\#8B0000\\[info|score|hide|spect]", on_flood_baby_command)
elseif network_is_server() or network_is_moderator() then
    hook_chat_command("flood", "\\#8B0000\\[start|speed|time|hide|score|info|spect]", on_flood_command)
end
hook_chat_command("menu", "open menu", on_fex_command)