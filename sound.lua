-- hola con todo respeto
-- Hello, with all due respect

-- Music Special --
smlua_audio_utils_replace_sequence(15, 0x25,   100,    "lobby")

smlua_audio_utils_replace_sequence(25,   0x25, 75,     "castle - grounds")
smlua_audio_utils_replace_sequence(26,     37, 75,     "bob")
smlua_audio_utils_replace_sequence(27,   0x1A, 75,     "wf")
smlua_audio_utils_replace_sequence(28,   0x25, 75,     "jrb")
smlua_audio_utils_replace_sequence(0x08, 0x25, 60,     "snow")
smlua_audio_utils_replace_sequence(0x09, 0x25, 75,     "ccm-slide")
smlua_audio_utils_replace_sequence(24,   0x25, 75,     "bbh")
smlua_audio_utils_replace_sequence(30,     37, 65,     "pss")
smlua_audio_utils_replace_sequence(31,   0x25, 75,     "totwc")

smlua_audio_utils_replace_sequence(32,   0x25, 50,     "hmc")
smlua_audio_utils_replace_sequence(33,   0x25, 75,     "lll")
smlua_audio_utils_replace_sequence(34,   0x25, 75,     "ssl")
smlua_audio_utils_replace_sequence(35,   0x18, 75,     "vcutm")
smlua_audio_utils_replace_sequence(55,   0x25, 75,     "vcutm")
smlua_audio_utils_replace_sequence(36,   0x25, 75,     "cotmc")
smlua_audio_utils_replace_sequence(37,   0x25, 75,     "ddd")
smlua_audio_utils_replace_sequence(38,   0x1A, 75,     "wdw")
smlua_audio_utils_replace_sequence(50,   0x25, 75,     "thi")
smlua_audio_utils_replace_sequence(51,   0x1A, 75,     "ttc")

smlua_audio_utils_replace_sequence(40,    0x25, 75,    "bits")
smlua_audio_utils_replace_sequence(41,    0x25, 75,    "rr")

local function demon_music()

if gNetworkPlayers[0].currLevelNum == LEVEL_ZEROLIFE then
    set_background_music(0, 15, 60)
end
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
if gNetworkPlayers[0].currLevelNum == LEVEL_CTT then
    set_background_music(0, 100, 60)
end		
	
if gNetworkPlayers[0].currLevelNum == LEVEL_BLACK_WDW then
    set_background_music(0, 38, 60)
end	
	
if gNetworkPlayers[0].currLevelNum == LEVEL_BITS then
    set_background_music(0, 40, 60)
end		
if gNetworkPlayers[0].currLevelNum == LEVEL_BITFS then
    set_background_music(0, 41, 60)
		end
end 

hook_event(HOOK_ON_WARP, demon_music)

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

local audio1 = audio_stream_load("bowser_castle_nsmb.ogg")


if not unsupported and game == GAME_VANILLA then
    function on_warp()
        if gNetworkPlayers[0].currLevelNum == LEVEL_BITDW then
            if gNetworkPlayers[0].currAreaIndex == 1 then
                stop_background_music(get_current_background_music())
                audio_stream_set_looping(audio1, true)
                audio_stream_play(audio1, true, 1)
            else
                audio_stream_play(audio1, true, 0)
            end  
        else
            audio_stream_stop(audio1)
        end
    end
    hook_event(HOOK_ON_WARP, on_warp)
end

-- STREAMABLE AUDIO MODULE LOADER v2.0 - Erik(ku) - (thx BEAR64DX for some help on the v1.1!!) - FREE OF USE
-- エリック
local audio1 = audio_stream_load("ctt.ogg")

-- Idk if these definitions are correct
SEQ_EVENT_POWERUP = SEQ_EVENT_POWERUP or 35
SEQ_EVENT_STAR = SEQ_EVENT_STAR or 33
SEQ_EVENT_DEATH = SEQ_EVENT_DEATH or 36
SEQ_EVENT_CUTSCENE_ENDING = SEQ_EVENT_CUTSCENE_ENDING or 38
SEQ_EVENT_BOSS = SEQ_EVENT_BOSS or 39

local isPlaying = false
local currentVolume = 0      -- actual float volume
local targetVolume = 0       -- targer volume
local fadeStep = 0.1         -- how does the volume change per frame
local maxVolume = 4          -- normal one
local minVolume = 1        -- low volume

local function is_special_music_playing()
    local music = get_current_background_music()
    return (
        music == SEQUENCE_ARGS(4, SEQ_EVENT_POWERUP) or
        music == SEQUENCE_ARGS(4, SEQ_EVENT_STAR) or
        music == SEQUENCE_ARGS(4, SEQ_EVENT_DEATH) or
        music == SEQUENCE_ARGS(4, SEQ_EVENT_CUTSCENE_ENDING) or
        music == SEQUENCE_ARGS(4, SEQ_EVENT_BOSS)
    )
end

local function clamp(value, minVal, maxVal)
    if value < minVal then return minVal end
    if value > maxVal then return maxVal end
    return value
end

local function update_audio_logic()
    if gNetworkPlayers[0].currLevelNum == LEVEL_CTT then
        if is_special_music_playing() then
            targetVolume = minVolume
            if (not isPlaying) and (not unsupported) and (not wiped or oggWipe) then
                -- If not already playing then idk, play it?
                stop_background_music(get_current_background_music())
                audio_stream_set_looping(audio1, true)
                audio_stream_play(audio1, true, minVolume)
                isPlaying = true
                currentVolume = minVolume
            end
        else
            targetVolume = maxVolume
            if (not isPlaying) and not unsupported and (not wiped or oggWipe) then
                stop_background_music(get_current_background_music())
                audio_stream_set_looping(audio1, true)
                audio_stream_play(audio1, true, maxVolume)
                isPlaying = true
                currentVolume = maxVolume
            end
        end

        -- Ajuste volume idk
        if isPlaying then
            if math.abs(currentVolume - targetVolume) > 0.01 then
                if currentVolume < targetVolume then
                    currentVolume = clamp(currentVolume + fadeStep, minVolume, maxVolume)
                else
                    currentVolume = clamp(currentVolume - fadeStep, minVolume, maxVolume)
                end
                audio_stream_set_volume(audio1, currentVolume)
            end
        end

    else
        if isPlaying then
            audio_stream_stop(audio1)
            isPlaying = false
            currentVolume = 0
            targetVolume = 0
        end
    end
end

hook_event(HOOK_MARIO_UPDATE, update_audio_logic)

local function on_warp()
    if not unsupported and not wiped then
        if isPlaying then
            audio_stream_stop(audio1)
            isPlaying = false
            currentVolume = 0
            targetVolume = 0
        end
    end
end
