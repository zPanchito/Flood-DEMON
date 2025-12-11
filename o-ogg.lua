local audio1 = audio_stream_load("ctt.ogg")

if not unsupported and game == GAME_VANILLA then
    function on_warp()
        if gNetworkPlayers[0].currLevelNum == LEVEL_CTT then
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
