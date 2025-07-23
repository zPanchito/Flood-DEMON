unsupported = false

FLOOD_WATER     = 0
FLOOD_LAVA      = 1
FLOOD_SAND      = 2
FLOOD_MUD       = 3
FLOOD_SNOW      = 4
FLOOD_WASTE     = 5
FLOOD_DESERT    = 6
FLOOD_ACID      = 7
FLOOD_POISON    = 8
FLOOD_SUNSET    = 9
FLOOD_FROSTBITE = 10
FLOOD_CLOUDS    = 11
FLOOD_RAINBOW   = 12
FLOOD_DARKNESS  = 13
FLOOD_MAGMA     = 14
FLOOD_SULFUR    = 15
FLOOD_COTTON    = 16
FLOOD_MOLTEN    = 17
FLOOD_OIL       = 18
FLOOD_MATRIX    = 19
FLOOD_BUP       = 20
FLOOD_TIDE      = 21
FLOOD_DARKTIDE  = 22
FLOOD_VOLCANO   = 23
FLOOD_REDTIDE   = 24
FLOOD_OPTIC     = 25

FLOOD_LEVEL_COUNT = 0
FLOOD_BONUS_LEVELS = 0

LEVEL_CTT       = level_register('level_ctt_entry',        COURSE_NONE, 'CTT',             'c',  28000, 0x08, 0x08, 0x08)
LEVEL_ZEROLIFE  = level_register('level_zerolife_entry',   COURSE_NONE, 'Lobby',           'c',  28000, 0x08, 0x08, 0x08)
LEVEL_BLACK_WDW = level_register('level_black_wdw_entry',  COURSE_NONE, 'Blind Night [1]', 'c',  28000, 0x08, 0x08, 0x08) 

GAME_VANILLA = 0
game = GAME_VANILLA

--- @class FloodLevel
--- @field public level integer
--- @field public codeName string
--- @field public goalPos Vec3f
--- @field public containsbase boolean
--- @field public speed number
--- @field public area integer
--- @field public act integer
--- @field public levelName string
--- @field public author string
--- @field public type integer
--- @field public sky integer
--- @field public floodScale number
--- @field public noWater boolean
--- @field public customStartPos Vec3f
--- @field public painting TextureInfo
--- @field public floodHeight integer
--- @field public floodScale number
--- @field public bonus boolean
--- @field public allowWarps boolean
--- @field public spawnArea table

--- @type FloodLevel[]
gLevels = {}
local djui_popup_create = djui_popup_create

-- Finally, a good gLevels src
local function flood_load_vanilla_levels()
    game = GAME_VANILLA
    gLevels = {
		{
            level = LEVEL_CASTLE_GROUNDS,
            codeName = "cg",
            goalPos = { x =   4021,   y =   7503,   z =   34,   a =  0x8000},
            speed = 1,
            area = 1,
			act = 99,
            levelName = "Demonic Battle Grounds",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
			customStartPos = nil,
		},
        {
            level = LEVEL_BOB,
            codeName = "bob",
            goalPos = { x =  -4241,   y =   7197,   z =  -2897,   a =  0x0000},
            speed = 2.5,
            area = 1,
            act = 6,
            levelName = "The Chain's Pissed Off",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			painting = TEX_BOB_PAINTING,
            customStartPos = nil,
        },
        {
            level = LEVEL_WF,
            codeName = "wf",
            goalPos = { x =   1774,   y =  11227,   z =  -1955,   a =  0x0000  },
            speed = 3.1,
            area = 1,
            levelName = "Chain's Fortress Hell",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = nil,
			painting = TEX_WF_PAINTING,
			floodHeight = -1490
        },
        {
            level = LEVEL_JRB,
            codeName = "jrb",
            goalPos = { x =   6055,   y =   2593,   z =   2545,   a =  0x0000},
            speed = 3,
            area = 1,
            levelName = "The Lake of Bolivia",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = nil,
			painting = TEX_JRB_PAINTING,
            floodHeight = -2500
        },
        {
            level = LEVEL_CCM,
            codeName = "ccm",
            goalPos = { x = 3036, y = 9595, z = -4378, a = 0x4000 },
            speed = 3.5,
            area = 1,
            levelName = "Demonic Snow Mountain",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			painting = TEX_CCM_PAINTING,
			floodHeight = -6500
        },
        {
            level = LEVEL_CCM,
            codeName = "ccm-slide",
            goalPos = { x =  -6178,   y =   6656,   z =  -6162,   a =  0x4000  },
            speed = 8,
            area = 2,
            levelName = "Demonic Slide",
            author = "zPancho!",
            type = FLOOD_POISON,
            customStartPos = { x = -6498, y = -5836, z = -6937, a = 0x0000 },
			painting = TEX_CCM_PAINTING,
			floodHeight = -8791
        },
        {
            level = LEVEL_BBH,
            codeName = "bbh",
            goalPos = { x =   1674,   y =   5784,   z =   2507,   a = -0x4000  },
            speed = 1,
            area = 1,
            levelName = "Long Jump Mansion",
            author = "zPancho!",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			painting = TEX_BBH_PAINTING,
		},
        {
            level = LEVEL_TOTWC,
            codeName = "totwc",
            goalPos = { x =   4104,   y =   3951,   z =   4101,   a =  0x2000  },
            speed = 5,
            area = 1,
            levelName = "Deadly Towers",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
        },
        {
            level = LEVEL_PSS,
            codeName = "pss",
            goalPos = { x =   6013,   y =   7182,   z =  -4181,   a =  0x6000  },
            speed = 6.5,
            area = 1,
            levelName = "Secret Slide of the Chuckay's",
            author = "zPancho!",
            type = FLOOD_POISON,
            customStartPos = { x =  -4763, y = -3057, z = -2985, a = -0x6000 },
			painting = TEX_PSS_PAINTING,
        },
        {
            level = LEVEL_BITDW,
            codeName = "bitdw",
            goalPos = { x =   6828,   y =   2867,   z =    -25,   a = -0x4000  },
            containsbase = true,
            speed = 2.1,
            area = 1,
            levelName = "Bowser in the heaven of suffering",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
        },
        {
            level = LEVEL_HMC,
            codeName = "hmc",
            goalPos = { x =  -2712,   y =   2204,   z =  -6406,   a = -0x0000  },
            speed = 1.2,
            area = 1,
            levelName = "Underground Volcano [1]",
            author = "zPancho!",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = { x =  -678, y = -409, z = -7365,   a = 0x4000 },
        },
        {
            level = LEVEL_COTMC,
            codeName = "cotmc",
            goalPos = { x =      4,   y =    372,   z =  -6063,   a =  0x0000  },
            containsbase = true,
            speed = 2.2,
            area = 1,
            levelName = "Metal Cavern",
            author = "zPancho!",
            type = FLOOD_POISON,
            customStartPos = nil,
			noWater = true,
        },
        {
            level = LEVEL_LLL,
            codeName = "lll",
            goalPos = { x =  -1451,   y =   5711,   z =  -3244,   a =  0x8000  },
			area = 1,
            speed = 0.1,
            levelName = "Erupting Volcano",
            author = "zPancho!",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
		    customStartPos = nil,
			floodHeight = 21,
        },
        {
            level = LEVEL_SSL,
            codeName = "ssl",
            goalPos = { x =  -2483,   y =   4207,   z =      6,   a =  0x0000  },
            speed = 4,
            area = 1,
            levelName = "The Pyramids of Egypt",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			floodHeight = -2104
		},
        {
            level = LEVEL_VCUTM,
            codeName = "vcutm",
            goalPos = { x =   4592,   y =   1067,   z =  -4486,   a =  0x8000  },
            containsbase = true,
            speed = 3.6,
            area = 1,
            levelName = "Vanish Temple",
            author = "zPancho!",
            type = FLOOD_POISON,
            customStartPos = { x = -6208, y = -2772, z =  1263,  a = -0x4000 },
        },
        {
            level = LEVEL_DDD,
            codeName = "ddd",
            goalPos = { x =   3230,   y =    772,   z =  -2314,   a = -0x4000  },
            speed = 1.50,
            area = 1,
            levelName = "The Dire Drought, Dire Docks",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			noWater = true,
			spawnArea = true
        },
        {
            level = LEVEL_BITFS,
            codeName = "bitfs",
            goalPos = { x =  -3005,   y =   8513,   z =   -200,   a =  0x0000  },
            speed = 4,
            area = 1,
            levelName = "Bowser Underground",
            author = "zPancho!",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			floodHeight = -5135
        },
        {
            level = LEVEL_SL,
            codeName = "sl",
            goalPos = { x =    153,   y =   7827,   z =   3351,   a =  0x6000  },
            containsbase = true,
            speed = 5,
            area = 1,
            levelName = "Hellish Snow [1]",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			noWater = true,
			floodHeight = -5000
        },
        {
            level = LEVEL_SL,
            codeName = "sl-igloo",
            goalPos = { x =     -5,   y =      0,   z =   2575,   a =  0x8000  },
            containsbase = true,
            speed = 4,
            area = 2,
            levelName = "Hellish Snow Igloo",
            author = "zPancho!",
            type = FLOOD_POISON,
            customStartPos = nil,
            floodHeight = -4000
        },
        {
            level = LEVEL_WDW,
            codeName = "wdw",
            goalPos = { x =   2490,   y =   5277,   z =   2663,   a = -0x4000  },
            speed = 4,
            area = 1,
            levelName = "The Droughts of the City [1]",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = nil,
        },
        {
            level = LEVEL_TTM,
            codeName = "ttm",
            goalPos = { x =  -3037,   y =   3737,   z =  -2207,   a =  0x0000  },
            containsbase = true,
            speed = 3,
            area = 1,
            levelName = "The Mountain of Eternal Suffering",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = nil,
        },
        {
            level = LEVEL_THI,
            codeName = "thi",
            goalPos = { x =      0,   y =   3891,   z =  -1533,   a =  0x0000  },
            speed = 3,
            area = 1,
            levelName = "The Island of Chain's",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = nil,
        },
        {
            level = LEVEL_THI,
            codeName = "thi-tiny",
            goalPos = { x =    -39,   y =   -767,   z =  -4531,   a =  0x0000  },
            speed = 4,
            area = 2,
            levelName = "Fire Island",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = nil,
        },
        {
            level = LEVEL_THI,
            codeName = "thi-cave",
            goalPos = { x =  -1997,   y =   1331,   z =  -1997,   a =  0x0000  },
            speed = 15,
            area = 3,
            levelName = "The Otaku Cave",
            author = "zPancho!",
            type = FLOOD_POISON,
            customStartPos = nil,
        },
        {
            level = LEVEL_TTC,
            codeName = "ttc",
            goalPos = { x =   -673,   y =   7548,   z =    594,   a =  0x0000  },
            speed = 4,
            area = 1,
            levelName = "Tick Tock Wallkick's",
            author = "zPancho!",
            type = FLOOD_POISON,
            customStartPos = nil,
        },
        {
            level = LEVEL_RR,
            codeName = "rr",
            goalPos = { x =  -5524,   y =   7210,   z =  -3672,   a =  0x0000  },
            speed = 4,
            area = 1,
            levelName = "The Heaven of Suffering",
            author = "zPancho!",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			floodHeight = -4241
        },
        {
            level = LEVEL_CTT,
            codeName = "ctt",
            goalPos = { x =  -49,   y =   307,   z =  -1571,   a =  0x0000  },
            speed = 13.1,
            area = 1,
            levelName = "Climb The Tower",
            author = "Agent X",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = { x = -2689, y = -11526, z = -870, a = 0x4000 }, 
			floodHeight = -20649
		},
		{
            level = LEVEL_BITS,
            codeName = "bits",
            goalPos = { x =   351,   y =   7108,   z =  -6039,   a =  0x0000  },
            containsbase = true,
            speed = 4,
            area = 1,
            levelName = "Bowser's HELL",
            author = "zPancho!",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			floodHeight = -7000
		},
		{
            level = LEVEL_BLACK_WDW,
            codeName = "black-wdw",
            goalPos = { x =   17987,   y =   6723,   z =  -9413,   a =  0x2000  },
            containsbase = true,
            speed = 4,
            area = 1,
            author = "NormalX71",
            type = FLOOD_OIL,
			levelName = "Blind Night",
            customStartPos = nil,
			floodHeight = -7000
		}
    }
end

for mod in pairs(gActiveMods) do
    if gActiveMods[mod].incompatible ~= nil and gActiveMods[mod].incompatible:find("romhack") then
        unsupported = true
        djui_popup_create("Flood Extreme is not compatible with romhacks.", 2)
    end
end

if game == GAME_VANILLA and not unsupported then
    flood_load_vanilla_levels()
end

FLOOD_LEVEL_COUNT = #gLevels
