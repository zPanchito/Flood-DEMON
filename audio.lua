-- Audio system made by Cooliokid 956 (Great Kingdom Offical)
-- Gotta put credit here because this sound system is actually amazing
-- エリック

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