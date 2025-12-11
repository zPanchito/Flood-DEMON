-- hola con todo respeto
-- Hello, with all due respect

-- Music Special --
smlua_audio_utils_replace_sequence(11,     37, 75,     "lobby1")
smlua_audio_utils_replace_sequence(12,     34, 75,     "lobby2")

smlua_audio_utils_replace_sequence(25,   0x25, 75,     "castle - grounds")
smlua_audio_utils_replace_sequence(26,     37, 75,     "bob")
smlua_audio_utils_replace_sequence(27,   0x18, 75,     "wf")
smlua_audio_utils_replace_sequence(28,   0x25, 75,     "jrb")
smlua_audio_utils_replace_sequence(16,   0x25, 60,     "ccm")
smlua_audio_utils_replace_sequence(0x09, 0x25, 75,     "ccm-slide")
smlua_audio_utils_replace_sequence(24,   0x25, 75,     "bbh")
smlua_audio_utils_replace_sequence(30,     24, 65,     "slide-pss")
smlua_audio_utils_replace_sequence(31,   0x25, 75,     "totwc")

smlua_audio_utils_replace_sequence(32,   0x25, 75,     "hmc-2")
smlua_audio_utils_replace_sequence(33,   0x25, 75,     "lll")
smlua_audio_utils_replace_sequence(34,   0x25, 75,     "ssl")
smlua_audio_utils_replace_sequence(35,   0x18, 75,     "vcutm")
smlua_audio_utils_replace_sequence(55,   0x25, 75,     "vcutm")
smlua_audio_utils_replace_sequence(36,   0x25, 75,     "cotmc")
smlua_audio_utils_replace_sequence(37,   0x25, 75,     "ddd")
smlua_audio_utils_replace_sequence(38,   0x1A, 75,     "wdw")
smlua_audio_utils_replace_sequence(17,     37, 75,     "sl")
smlua_audio_utils_replace_sequence(50,   0x25, 75,     "thi")
smlua_audio_utils_replace_sequence(51,   0x1A, 75,     "ttc")
smlua_audio_utils_replace_sequence(41,   0x25, 75,     "rr")

smlua_audio_utils_replace_sequence(56,   0x25, 75,     "bitdw")
smlua_audio_utils_replace_sequence(40,   0x25, 75,     "bits")
smlua_audio_utils_replace_sequence(55,     26, 75,     "bitfs")

local function demon_music()

if gNetworkPlayers[0].currLevelNum == LEVEL_CASTLE_GROUNDS then
    set_background_music(0, 25, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_BOB then
    set_background_music(0, 26, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_WF then
    set_background_music(0, 27, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_JRB then
    set_background_music(0, 28, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_BBH then
    set_background_music(0, 24, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_PSS then
    set_background_music(0, 30, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_TOTWC then
    set_background_music(0, 31, 60)
end	
if gNetworkPlayers[0].currLevelNum == LEVEL_HMC then
    set_background_music(0, 32, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_COTMC then
    set_background_music(0, 36, 60)
end	
if gNetworkPlayers[0].currLevelNum == LEVEL_LLL then
    set_background_music(0, 33, 60)
end	
if gNetworkPlayers[0].currLevelNum == LEVEL_SSL then
    set_background_music(0, 34, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_VCUTM then
    set_background_music(0, 35, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_DDD then
    set_background_music(0, 37, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_WDW then
    set_background_music(0, 38, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_TTM then
    set_background_music(0, 55, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_THI then
    set_background_music(0, 50, 60)
end
if gNetworkPlayers[0].currLevelNum == LEVEL_TTC then
    set_background_music(0, 51, 60)
end		
if gNetworkPlayers[0].currLevelNum == LEVEL_RR then
    set_background_music(0x09, 41, 60)
end				
if gNetworkPlayers[0].currLevelNum == LEVEL_SL then
    set_background_music(0, 17, 60)
end	
if gNetworkPlayers[0].currLevelNum == LEVEL_CCM then
    set_background_music(0, 16, 60)
end			
if gNetworkPlayers[0].currLevelNum == LEVEL_BLACK_WDW then
    set_background_music(0, 38, 60)
end	
	
if gNetworkPlayers[0].currLevelNum == LEVEL_BITDW then
    set_background_music(0, 56, 60)
end	
if gNetworkPlayers[0].currLevelNum == LEVEL_BITS then
    set_background_music(0, 40, 60)
end		
if gNetworkPlayers[0].currLevelNum == LEVEL_BITFS then
    set_background_music(0, 55, 60)
		end
end 

-- Lobby Music (Maisk mainly cooked this up)
function random()
if game == GAME_VANILLA and gNetworkPlayers[0].currLevelNum == LEVEL_ZEROLIFE then
        local randomnumb = math.random(2)
        if randomnumb == 1 then
            set_background_music(0, 11, 75)
        elseif randomnumb == 2 then
            set_background_music(0, 12, 75)
        end
    end
end

-- Audio system made by Cooliokid 956 (Great Kingdom Offical)
-- Gotta put credit here because this sound system is actually amazing

currentlyPlaying = nil

gSamples = {
	audio_sample_load("nsmbuse.mp3"),
	audio_sample_load("trolldie.mp3"),	
}

sNsmbUse = 1
sTrolldie = 2
   
function local_play(id, pos, vol)
	audio_sample_play(gSamples[id], pos, (is_game_paused() and 0 or vol))
end

function network_play(id, pos, vol, i)
    local_play(id, pos, vol)
    network_send(true, {id = id, x = pos.x, y = pos.y, z = pos.z, vol = vol, i = network_global_index_from_local(i)})
end

hook_event(HOOK_ON_PACKET_RECEIVE, function (data)
	if is_player_active(gMarioStates[network_local_index_from_global(data.i)]) ~= 0 then
		local_play(data.id, {x=data.x, y=data.y, z=data.z}, data.vol)
	end
end)

-- Stremeable audio system (v1.1) by Bomboclath with the help of BearDX, documentation soon.
-- everything its more complex. This works on all romhacks, but you need to add the "if gActiveMods[mod].name:find("") then".
-- and also, if you have 2 levels on 1 level area, you can't put 2 diferent songs in one same area, sorry.

hook_event(HOOK_ON_WARP, on_warp)
hook_event(HOOK_ON_LEVEL_INIT, random)
hook_event(HOOK_ON_WARP, demon_music)
