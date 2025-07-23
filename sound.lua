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

smlua_audio_utils_replace_sequence(40,    0x25, 75,    "ctt")
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
    set_background_music(0, 39, 60)
		end
end 

hook_event(HOOK_ON_WARP, demon_music)
