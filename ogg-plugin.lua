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