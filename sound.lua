-- Lobby --
smlua_audio_utils_replace_sequence(11,     37, 75,     "lobby")
smlua_audio_utils_replace_sequence(12,   0x25, 75,     "lobby1")
smlua_audio_utils_replace_sequence(13,     37, 75,     "lobby2")

-- Castle Main
smlua_audio_utils_replace_sequence(25,   0x25, 75,     "castle - grounds")
smlua_audio_utils_replace_sequence(26,     37, 75,     "bob")
smlua_audio_utils_replace_sequence(27,   0x18, 75,     "wf")
smlua_audio_utils_replace_sequence(28,   0x25, 75,     "jrb")
smlua_audio_utils_replace_sequence(29,   0x25, 60,     "ccm")
smlua_audio_utils_replace_sequence(30,   0x25, 75,     "ccm-slide")
smlua_audio_utils_replace_sequence(31,   0x23, 100,     "bbh")
smlua_audio_utils_replace_sequence(32,     37, 65,     "slide-pss")
smlua_audio_utils_replace_sequence(33,   0x25, 75,     "totwc")

-- Castle Basement
smlua_audio_utils_replace_sequence(34,   0x25, 75,     "hmc")
smlua_audio_utils_replace_sequence(35,   0x25, 75,     "lll")
smlua_audio_utils_replace_sequence(36,   0x25, 75,     "ssl")
smlua_audio_utils_replace_sequence(37,   0x18, 75,     "vcutm")
smlua_audio_utils_replace_sequence(38,   0x25, 75,     "cotmc")
smlua_audio_utils_replace_sequence(49,   0x18, 75,     "ddd")

-- Castle Upper
smlua_audio_utils_replace_sequence(40,   0x1A, 75,     "wdw")
smlua_audio_utils_replace_sequence(41,     37, 75,     "sl")
smlua_audio_utils_replace_sequence(42,   0x25, 75,     "ttm")
smlua_audio_utils_replace_sequence(43,   0x25, 75,     "thi")
smlua_audio_utils_replace_sequence(44,     35, 75,     "ttc")
smlua_audio_utils_replace_sequence(45,   0x25, 75,     "rr")

-- Bowser Levels
smlua_audio_utils_replace_sequence(46,   0x25, 75,     "bitdw")
smlua_audio_utils_replace_sequence(47,   0x25, 75,     "bits")
smlua_audio_utils_replace_sequence(48,   0x25, 75,     "bitfs")

-- Areas Levels
smlua_audio_utils_replace_sequence(54,   0x2A, 75,     "lll-2")
smlua_audio_utils_replace_sequence(50,     42, 75,     "ssl-2")
smlua_audio_utils_replace_sequence(52,   0x2A, 75,     "sl-2")

local REPLACEMENTS = {
    [LEVEL_CASTLE_GROUNDS]= {seq = 25},
    [LEVEL_BOB]           = {seq = 26},
    [LEVEL_WF]            = {seq = 27},
    [LEVEL_JRB]           = {seq = 28},
    [LEVEL_CCM]           = {seq = 29, areas = {[2] = 30}},
    [LEVEL_BBH]           = {seq = 31},
    [LEVEL_PSS]           = {seq = 32},
    [LEVEL_TOTWC]         = {seq = 33},
    [LEVEL_HMC]           = {seq = 34},
    [LEVEL_LLL]           = {seq = 35, areas = {[2] = 54}},
    [LEVEL_SSL]           = {seq = 36, areas = {[2] = 50}},
    [LEVEL_VCUTM]         = {seq = 37},
    [LEVEL_COTMC]         = {seq = 38},
    [LEVEL_DDD]           = {seq = 49},
    [LEVEL_WDW]           = {seq = 40},
    [LEVEL_SL]            = {seq = 41, areas = {[2] = 52}},
    [LEVEL_TTM]           = {seq = 42},
    [LEVEL_THI]           = {seq = 43},
    [LEVEL_TTC]           = {seq = 44},
    [LEVEL_RR]            = {seq = 45},
    [LEVEL_BITDW]         = {seq = 46},
    [LEVEL_BITS]          = {seq = 47},
    [LEVEL_BITFS]         = {seq = 48},
}

local function update_level_music()
    local np = gNetworkPlayers[0]
    local config = REPLACEMENTS[np.currLevelNum]

    if config then
        local sequence = config.seq
        if config.areas and config.areas[np.currAreaIndex] then
            sequence = config.areas[np.currAreaIndex]
        end
        
        set_background_music(0, sequence, 60)
    end
end

local LOBBY_SEQUENCES = {11, 12, 13}

local LOBBY_LEVELS = {
    [LEVEL_CASTLE] = true,
    [LEVEL_CASTLE_COURTYARD] = true,
    [LEVEL_ZEROLIFE] = true  
}

local function play_random_lobby_music()
    if gNetworkPlayers[0] ~= nil and LOBBY_LEVELS[gNetworkPlayers[0].currLevelNum] then
        local track = LOBBY_SEQUENCES[math.random(#LOBBY_SEQUENCES)]
        set_background_music(0, track, 75)
    end
end

hook_event(HOOK_ON_LEVEL_INIT, play_random_lobby_music)
hook_event(HOOK_ON_WARP, function()
    play_random_lobby_music()
    update_level_music()
end)