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

LEVEL_ZEROLIFE = level_register('level_zerolife_entry',   COURSE_NONE, 'Lobby',           'c',  28000, 0x08, 0x08, 0x08)

GAME_VANILLA = 0
game = GAME_VANILLA

--- @class FloodLevel
--- @field public level integer
--- @field public name string
--- @field public flagPos Vec3f
--- @field public flagBase boolean
--- @field public author string
--- @field public speed number
--- @field public area integer
--- @field public type integer
--- @field public time integer
--- @field public startPos Vec3f
--- @field public unwantedBhvs table
--- @field public overrideName string
--- @field public overrideWater boolean
--- @field public floodHeight integer
--- @field public pipes table
--- @field public launchpads table
--- @field public capTimer integer
--- @field public act integer
--- @field public overrideSlide boolean
--- @field public powerUp string
--- @field public music table
--- @field public skybox integer
--- @field public separator string
--- @field public bonus boolean

--- @type FloodLevel[]
gLevels = {}
local djui_popup_create = djui_popup_create

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
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
			customStartPos = nil,
		},
        {
            level = LEVEL_BOB,
            codeName = "bob",
            goalPos = { x =  4119,   y =   7197,   z =  7875,   a =  -0x2000},
            speed = 2.5,
            area = 1,
            act = 6,
            levelName = "The Chain's Pissed Off",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
        },
        {
            level = LEVEL_WF,
            codeName = "wf",
            goalPos = { x =   2571,   y =  13715,   z =  -286,   a =  0x0000  },
            speed = 3.1,
            area = 1,
            levelName = "Chain's Fortress Hell",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = nil,
			floodHeight = -1490
        },
        {
            level = LEVEL_WF,
            codeName = "wf-2",
            goalPos = { x =   -519,   y =  6765,   z =  1864,   a =  0x0000  },
            speed = 6.1,
            area = 1,
            levelName = "The Chomp Challenge",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = { x =   -3144,   y =  3033,   z =  -1351,   a =  0x0000  },
			floodHeight = -3406
        },
        {
            level = LEVEL_WF,
            codeName = "wf-3",
            goalPos = { x =   356,   y =  2286,   z =  3716,   a =  -0x4000  },
            speed = 8.3,
            area = 1,
            levelName = "The escape of the enraged chomps",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = { x =   5804,   y =  1127,   z =  5837,   a =  -0x2000  },
			floodHeight = -2542
        },
        {
            level = LEVEL_JRB,
            codeName = "jrb",
            goalPos = { x =   4335,   y =   4607,   z =   3090,   a =  0x0000},
            speed = 3,
            area = 1,
            levelName = "JRB's Great Drought",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = nil,
            floodHeight = -2451
        },
        {
            level = LEVEL_JRB,
            codeName = "jrb-2",
            goalPos = { x =   1501,   y =   1946,   z =   2369,   a =  -0x2000},
            speed = 6.5,
            area = 1,
            levelName = "JRB's caverns",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = { x = -4014, y = -1462, z = -2787, a = 0x0000},
            floodHeight = -10421
        },
        {
            level = LEVEL_CCM,
            codeName = "ccm",
            goalPos = { x = 3036, y = 9595, z = -4378, a = 0x4000 },
            speed = 3.5,
            area = 1,
            levelName = "Demonic Snow Mountain",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			floodHeight = -6500
        },
        {
            level = LEVEL_CCM,
            codeName = "ccm-slide",
            goalPos = { x =  -6178,   y =   6656,   z =  -6162,   a =  0x4000  },
            speed = 8,
            area = 2,
            levelName = "Demonic Slide",
            author = "zPan",
            type = FLOOD_POISON,
            customStartPos = { x = -6498, y = -5836, z = -6937, a = 0x0000 },
			floodHeight = -8791
        },
        {
            level = LEVEL_BBH,
            codeName = "bbh",
            goalPos = { x =   980,   y =   5259,   z =   1764,   a = -0x4000  },
            speed = 1,
            area = 1,
            levelName = "The mansion's long jumps",
            author = "zPan",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
		},
        {
            level = LEVEL_TOTWC,
            codeName = "totwc",
            goalPos = { x =   4104,   y =   3951,   z =   4101,   a =  0x2000  },
            speed = 5,
            area = 1,
            levelName = "The cursed towers",
            author = "zPan",
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
            levelName = "The hideout of the Chuckay's",
            author = "zPan",
            type = FLOOD_POISON,
            customStartPos = { x =  -4763, y = -3057, z = -2985, a = -0x6000 },
        },
        {
            level = LEVEL_BITDW,
            codeName = "bitdw",
            goalPos = { x =   6312,   y =   7587,   z =    1884,   a = -0x4000  },
            speed = 2.43,
            area = 1,
            levelName = "Bowser in the heaven of suffering",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
        },
        {
            level = LEVEL_HMC,
            codeName = "hmc",
            goalPos = { x =  -2712,   y =   1843,   z =  -6406,   a = -0x0000  },
            speed = 1.2,
            area = 1,
            levelName = "Underground Volcano",
            author = "zPan",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
            customStartPos = { x =  -678, y = -409, z = -7365,   a = 0x4000 },
        },
        {
            level = LEVEL_HMC,
            codeName = "hmc",
            goalPos = { x =  3027,   y =   1426,   z =  6294,   a = -0x0000  },
            speed = 2.4,
            area = 1,
            levelName = "The challenge of the burning volcano",
            author = "zPan",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
			noWater = true,
			floodHeight = -6000,
            customStartPos = { x =  4245, y = -3247, z = 3930,   a = -0x2000 },
        },
        {
            level = LEVEL_COTMC,
            codeName = "cotmc",
            goalPos = { x =      4,   y =    372,   z =  -6063,   a =  0x0000  },
            containsbase = true,
            speed = 2.2,
            area = 1,
            levelName = "Metal Cavern",
            author = "zPan",
            type = FLOOD_POISON,
            customStartPos = nil,
			noWater = true,
        },
        {
            level = LEVEL_LLL,
            codeName = "lll",
            goalPos = { x =  -1451,   y =   5711,   z =  -3244,   a =  0x8000  },
			area = 1,
            speed = 1.4,
            levelName = "Erupting Volcano",
            author = "zPan",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
		    customStartPos = nil,
			floodHeight = -2412
        },
        {
            level = LEVEL_LLL,
            codeName = "lll",
            goalPos = { x =  2066,   y =   3232,   z =  1411,   a =  0x8000  },
			area = 2,
            speed = 2.1,
            levelName = "The inferior of the volcano",
            author = "zPan",
            type = FLOOD_POISON,
		    customStartPos = nil,
        },
        {
            level = LEVEL_SSL,
            codeName = "ssl",
            goalPos = { x =  -2483,   y =   4207,   z =      6,   a =  0x0000  },
            speed = 4,
            area = 1,
            levelName = "The Pyramids of Egypt",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			floodHeight = -2104
        },
        {
            level = LEVEL_SSL,
            codeName = "ssl",
            goalPos = { x =  3,   y =   4967,   z =      256,   a =  0x0000  },
            speed = 4,
            area = 2,
            levelName = "Inside the pyramids",
            author = "zPan",
            type = FLOOD_POISON,
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
            author = "zPan",
            type = FLOOD_POISON,
            customStartPos = { x = -6208, y = -2772, z =  1263,  a = -0x4000 },
        },
        {
            level = LEVEL_DDD,
            codeName = "ddd",
            goalPos = { x =   3361,   y =    772,   z =  -2445,   a = -0x4000  },
            speed = 1.13,
            area = 1,
            levelName = "The Dire Drought, Dire Docks",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			noWater = true,
			spawnArea = true
        },
        {
            level = LEVEL_BITFS,
            codeName = "bitfs",
            goalPos = { x =  -2660,   y =   11518,   z =   -161,   a =  0x0000  },
            speed = 3.4,
            area = 1,
            levelName = "Bowser in the fiery hell",
            author = "zPan",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			floodHeight = -4702
        },
        {
            level = LEVEL_SL,
            codeName = "sl",
            goalPos = { x =    -1993,   y =   8327,   z =   1118,   a =  0x6000  },
            speed = 5,
            area = 1,
            levelName = "Hellish Snow",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			noWater = true,
			floodHeight = -5000
        },
        {
            level = LEVEL_SL,
            codeName = "sl-2",
            goalPos = { x =    -337,   y =   4766,   z =   -3104,   a =  0x6000  },
            speed = 9.24,
            area = 1,
            levelName = "Freezer's Challenge",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = { x = -7116,   y =   5468,   z =   -7089,   a =  0x2000  },
			noWater = true,
			floodHeight = -1401
        },
        {
            level = LEVEL_SL,
            codeName = "sl-igloo",
            goalPos = { x =     -5,   y =      0,   z =   2575,   a =  0x8000  },
            containsbase = true,
            speed = 6.3,
            area = 2,
            levelName = "Hellish Snow Igloo",
            author = "zPan",
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
            levelName = "The Droughts of the City",
            author = "zPan",
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
            author = "zPan",
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
            author = "zPan",
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
            author = "zPan",
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
            author = "zPan",
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
            author = "zPan",
            type = FLOOD_POISON,
            customStartPos = nil,
        },
        {
            level = LEVEL_RR,
            codeName = "rr",
            goalPos = { x =  -3954,   y =   7467,   z =  -1037,   a =  0x0000  },
            speed = 2.1,
            area = 1,
            levelName = "The Skies of hell [1]",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			floodHeight = -4241
        },
        {
            level = LEVEL_RR,
            codeName = "rr-2",
            goalPos = { x =  -5841,   y =   4506,   z =  -5250,   a =  -0x6000  },
            speed = 1.43,
            area = 1,
            levelName = "The Skies of hell [2]",
            author = "zPan",
            type = FLOOD_POISON,
            sky = BACKGROUND_PURPLE_SKY,
            customStartPos = { x =  7330,   y =   -707,   z =  6549,   a =  -0x4000  },
			floodHeight = -4241
		},
		{
            level = LEVEL_BITS,
            codeName = "bits",
            goalPos = { x =   351,   y =   6652,   z =  -6039,   a =  0x0000  },
            containsbase = true,
            speed = 4,
            area = 1,
            levelName = "Bowser's HELL",
            author = "zPan",
            type = FLOOD_POISON,
			sky = BACKGROUND_PURPLE_SKY,
            customStartPos = nil,
			floodHeight = -7140
		}
    }
end

for mod in pairs(gActiveMods) do
    if gActiveMods[mod].incompatible ~= nil and gActiveMods[mod].incompatible:find("romhack") then
        unsupported = true
        djui_popup_create("Flood DEMON! is not compatible with romhacks.", 2)
    end
end

if game == GAME_VANILLA and not unsupported then
    flood_load_vanilla_levels()
end

FLOOD_LEVEL_COUNT = #gLevels
