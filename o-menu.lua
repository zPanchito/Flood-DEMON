showSettings = false

local bgWidth = 1000
local bgHeight = 800
local bgX = ((djui_hud_get_screen_width() - bgWidth) / 2)
local bgY = ((djui_hud_get_screen_height() - bgHeight) / 2)
local rectWidth = bgWidth - 80
local rectX = bgX + 40

local selection = 1

TTCC = {
    [0] = TTC_SPEED_FAST,
    [1] = TTC_SPEED_SLOW,
    [2] = TTC_SPEED_RANDOM,
    [3] = TTC_SPEED_STOPPED
}

INPUT_A = 0
INPUT_JOYSTICK = 1

PERMISSION_NONE = 0
PERMISSION_STAFF = 1

local function on_off_text(bool)
    if bool then return "On" else return "Off" end
end

local function has_permission(perm)
    if perm == PERMISSION_NONE then return true end
    if perm == PERMISSION_STAFF and (network_is_server() or network_is_moderator()) then return true end
    return false
end

local function get_controller_dir()
    local m = gMarioStates[0]
    local direction = CONT_LEFT

    if m.controller.buttonPressed & R_JPAD ~= 0
    or m.controller.stickX > 0.5 then direction = CONT_RIGHT end

    return direction
end

joystickCooldown = 0
local category = nil
local previousRgbValue = nil
local rgbValue = nil
local rgbAlphaEnabled = false

local mainEntries = {}
local startEntries = {}
local creditEntries = {}
local gameEntries = {}
local modifierEntries = {}
local manualEntries = {}
local settingEntries = {}
local hudEntries = {}
local generalEntries = {}
local entries = mainEntries

local function set_color_value(c)
    local m = gMarioStates[0]
    local direction = get_controller_dir()
    local speed = 1

    if m.controller.buttonPressed & R_JPAD ~= 0
    or m.controller.buttonPressed & L_JPAD ~= 0 then
        speed = 10
    end

    if direction == CONT_LEFT then
        c = c - speed
        if c < 0 then c = 255 end
    else
        c = c + speed
        if c > 255 then c = 0 end
    end

    return c
end

local function change_fov_engine()
    eFloodVariables.engine = not eFloodVariables.engine
    mod_storage_save_bool("fov", eFloodVariables.engine)
end

local function set_flood_speed()
    local m = gMarioStates[0]
    local direction = get_controller_dir()
    local speed = 1

    if m.controller.buttonPressed & R_JPAD ~= 0 or m.controller.buttonPressed & L_JPAD ~= 0 then
        speed = 1
    end

    gGlobalSyncTable.speedMultiplier = clampf(gGlobalSyncTable.speedMultiplier, 0, 99)
    if direction == CONT_LEFT then
        gGlobalSyncTable.speedMultiplier = gGlobalSyncTable.speedMultiplier - speed
        if gGlobalSyncTable.speedMultiplier <= 0 then
            gGlobalSyncTable.speedMultiplier = 0
        end
    else
        gGlobalSyncTable.speedMultiplier = gGlobalSyncTable.speedMultiplier + speed
    end
end

local function set_round_cooldown()
    local m = gMarioStates[0]
    local direction = get_controller_dir()
    local step = 1

    if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        djui_chat_message_create("\\#ff0000\\You can only change the cooldown before the round starts")
        return
    end

    local currentCooldown = math.floor(ROUND_COOLDOWN / 30 + 0.5)
    if direction == CONT_LEFT then
        currentCooldown = currentCooldown - step
    elseif direction == CONT_RIGHT then
        currentCooldown = currentCooldown + step
    else
        return
    end

    if currentCooldown < 1 then
        currentCooldown = 1
        djui_chat_message_create("\\#ffff00\\Cooldown must be >= 1 second")
    end

    ROUND_COOLDOWN = currentCooldown * 30
    gGlobalSyncTable.timer = ROUND_COOLDOWN
    COOLDO = (ROUND_COOLDOWN / 30) -1
    if currentCooldown > 1 then
        djui_chat_message_create(string.format("\\#ffffff\\Round cooldown set to \\#ff5533\\%d seconds", COOLDO))
    end
    mod_storage_save_number("cooldown", ROUND_COOLDOWN)
end

local function set_spectator_mode()
    local direction = get_controller_dir()
    if direction == CONT_LEFT then
        eFloodVariables.spectatorMode = (eFloodVariables.spectatorMode - 1) % 2
    else
        eFloodVariables.spectatorMode = (eFloodVariables.spectatorMode + 1) % 2
    end
    mod_storage_save_number("spectMode", eFloodVariables.spectatorMode)
end

local function set_ttc_speed()
    if gGlobalSyncTable.roundState ~= ROUND_STATE_ACTIVE then
        local direction = get_controller_dir()

        if direction == CONT_LEFT then
            gGlobalSyncTable.ttcIndex = (gGlobalSyncTable.ttcIndex - 1) % 4
        else
            gGlobalSyncTable.ttcIndex = (gGlobalSyncTable.ttcIndex + 1) % 4
        end
 
        set_ttc_speed_setting(TTCC[gGlobalSyncTable.ttcIndex])
        mod_storage_save_number("TTCS", gGlobalSyncTable.ttcIndex)
    else
        djui_popup_create("\\#ff0000\\You can only change the TTC speed before the round starts!", 2)
    end
end

local function reset_game_settings()
    if network_is_server() or network_is_moderator() then
        gGlobalSyncTable.speedMultiplier = 1
        gGlobalSyncTable.mapMode = 0
        mod_storage_save_number("mapMode", gGlobalSyncTable.mapMode)
        ROUND_COOLDOWN = 11 * 30
        gGlobalSyncTable.timer = ROUND_COOLDOWN
        mod_storage_save_number("cooldown", gGlobalSyncTable.timer)
    end
end

local function reset_general_settings()
    if network_is_server() or network_is_moderator() then
        gGlobalSyncTable.ttcIndex = 0
        set_ttc_speed_setting(TTCC[gGlobalSyncTable.ttcIndex])
        mod_storage_save_number("TTCS", gGlobalSyncTable.ttcIndex)
        gGlobalSyncTable.classic = false
    end
    eFloodVariables.spectatorMode = SPECTATOR_MODE_NORMAL
    mod_storage_save_number("spectMode", eFloodVariables.spectatorMode)
end

local function reset_hud_settings()
    eFloodVariables.engine = false
    mod_storage_save_bool("fov", eFloodVariables.engine)
    eFloodVariables.hudHide = false
    mod_storage_save_bool("hidehud", eFloodVariables.hudHide)
    eFloodVariables.globalFont = FONT_MENU
    eFloodVariables.textlv1Scale = 0.2
    eFloodVariables.textlv2Scale = 0.15
    mod_storage_save_number("globalFont", eFloodVariables.globalFont)
    mod_storage_save_number("textlv1Scale", eFloodVariables.textlv1Scale)
    mod_storage_save_number("textlv2Scale", eFloodVariables.textlv2Scale)
end

local function reset_all_settings()
    reset_hud_settings()
    reset_general_settings()
    reset_game_settings()
end

local function set_mapmode()
    local direction = get_controller_dir()
    if direction == CONT_LEFT then
        gGlobalSyncTable.mapMode = (gGlobalSyncTable.mapMode - 1) % 3
    else
        gGlobalSyncTable.mapMode = (gGlobalSyncTable.mapMode + 1) % 3
    end
    mod_storage_save_number("mapMode", gGlobalSyncTable.mapMode)
end

local function font_selection()
    local direction = get_controller_dir()

    local fontList = {
        { globalFont = FONT_MENU,         textlv1Scale = 0.2,  textlv2Scale = 0.15 },
        { globalFont = FONT_HUD,          textlv1Scale = 0.55, textlv2Scale = 0.4  },
        { globalFont = FONT_NORMAL,       textlv1Scale = 0.4,  textlv2Scale = 0.3  },
        { globalFont = FONT_TINY,         textlv1Scale = 0.6,  textlv2Scale = 0.4  },
        { globalFont = FONT_ALIASED,      textlv1Scale = 0.4,  textlv2Scale = 0.25 },
        { globalFont = FONT_SPECIAL,      textlv1Scale = 0.4,  textlv2Scale = 0.3  },
        { globalFont = FONT_RECOLOR_HUD,  textlv1Scale = 0.55, textlv2Scale = 0.4  },
        { globalFont = FONT_CUSTOM_HUD,   textlv1Scale = 0.55, textlv2Scale = 0.4  },
    }

    local currentIndex = 1
    for i, fontData in ipairs(fontList) do
        if eFloodVariables.globalFont == fontData.globalFont then
            currentIndex = i
            break
        end
    end

    if direction == CONT_LEFT then 
        currentIndex = (currentIndex - 2 + #fontList) % #fontList + 1
    else
        currentIndex = (currentIndex % #fontList) + 1
    end

    local selected = fontList[currentIndex]
    eFloodVariables.globalFont = selected.globalFont
    eFloodVariables.textlv1Scale = selected.textlv1Scale
    eFloodVariables.textlv2Scale = selected.textlv2Scale

    mod_storage_save_number("globalFont", eFloodVariables.globalFont)
    mod_storage_save_number("textlv1Scale", eFloodVariables.textlv1Scale)
    mod_storage_save_number("textlv2Scale", eFloodVariables.textlv2Scale)
end

local function toggle_pvp()
    gGlobalSyncTable.modif_pvp = not gGlobalSyncTable.modif_pvp
    mod_storage_save_bool("PvP", gGlobalSyncTable.modif_pvp)
end

local function toggle_devil()
    gGlobalSyncTable.modif_daredevil = not gGlobalSyncTable.modif_daredevil
    mod_storage_save_bool("Devil", gGlobalSyncTable.modif_daredevil)
end

local function toggle_nocoin()
    gGlobalSyncTable.modif_coinless = not gGlobalSyncTable.modif_coinless
    mod_storage_save_bool("Coinless", gGlobalSyncTable.modif_coinless)
end

local function toggle_slidejump() 
    gGlobalSyncTable.modif_slide_jump = not gGlobalSyncTable.modif_slide_jump
    mod_storage_save_bool("SlideJump", gGlobalSyncTable.modif_slide_jump)
end

local function toggle_troll()
    gGlobalSyncTable.modif_trollface = not gGlobalSyncTable.modif_trollface
    mod_storage_save_bool("Troll", gGlobalSyncTable.modif_trollface)
end

local function toggle_gravity()
    gGlobalSyncTable.modif_gravity = not gGlobalSyncTable.modif_gravity
    mod_storage_save_bool("Gravity", gGlobalSyncTable.modif_gravity)
end

local function reset_modifier_settings()
    if network_is_server() or network_is_moderator() then
        gGlobalSyncTable.modif_pvp = false
        mod_storage_save_bool("PvP", gGlobalSyncTable.modif_pvp)
        gGlobalSyncTable.modif_slide_jump = false
        mod_storage_save_bool("SlideJump", gGlobalSyncTable.modif_slide_jump)
        gGlobalSyncTable.modif_daredevil = false
        mod_storage_save_bool("Devil", gGlobalSyncTable.modif_daredevil)
        gGlobalSyncTable.modif_coinless = false
        mod_storage_save_bool("Coinless", gGlobalSyncTable.modif_coinless)
        gGlobalSyncTable.modif_trollface = false
        mod_storage_save_bool("Troll", gGlobalSyncTable.modif_trollface)
        gGlobalSyncTable.modif_gravity = false
        mod_storage_save_bool("Gravity", gGlobalSyncTable.modif_gravity)

        modifiersfe = {}
    end
end

local function reset_main_entries()
    local resetEntries = entries == mainEntries

    mainEntries = {
        {
            separator = "Main Section",
            name = "Start",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = startEntries
                selection = 1
            end,
            valueText = ">"
        },
        {
            name = "Settings",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = settingEntries
                selection = 1
            end,
            valueText = ">"
        },
        {
            name = "Modifiers",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = modifierEntries
                selection = 1
            end,
            valueText = ">"
        },
        {
            name = "Manual",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = manualEntries
                selection = 1
            end,
            valueText = ">"
        },
        {
            name = "Developer Manual",
            permission = PERMISSION_STAFF,
            input = INPUT_A,
            func = function ()
                djui_chat_message_create("Holy fuck, give me some time bro")
            end,
            valueText = ">"
        },
        {
            name = "Credits",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = creditEntries
                selection = 1
            end,
            valueText = ">"
        },
        {
            separator = "",
            name = "Close",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function () showSettings = not showSettings end
        },
    }

    if resetEntries then entries = mainEntries end
end

local function reset_start_entries()
    local resetEntries = entries == startEntries

    startEntries = {
        {
            name = "Random",
            permission = PERMISSION_STAFF,
            input = INPUT_A,
            func = function ()
                gGlobalSyncTable.level = math.random(#gLevels)
                if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
                    network_send(true, { restart = true })
                    gGlobalSyncTable.level = math.random(#gLevels)
                    level_restart()
                else
                    gGlobalSyncTable.level = math.random(#gLevels)
                    round_start()
                end
                showSettings = false
            end
        },
        {
            name = "Init a Voting",
            permission = PERMISSION_STAFF,
            input = INPUT_A,
            func = function()
                gGlobalSyncTable.timer = 1
                host_init_voting_timer()
                showSettings = false
            end
        }
    }

    for k in pairs(gLevels) do
        table.insert(startEntries, {
            name = name_of_level(gLevels[k].level, gLevels[k].area, gLevels[k].name, gLevels[k]),
            permission = PERMISSION_STAFF,
            input = INPUT_A,
            func = function ()
                gGlobalSyncTable.level = k
                if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
                    network_send(true, { restart = true })
                    level_restart()
                else
                    round_start()
                end
                showSettings = false
            end,
            separator = gLevels[k].separator ~= nil and gLevels[k].separator or nil
        })

        if k == 1 then
            startEntries[#startEntries].separator = FLOOD_LEVEL_COUNT .. " Levels"
        end
    end

    table.insert(startEntries, {
        name = "Back",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = function()
            entries = mainEntries 
            selection = 1
        end,
        separator = ""
    })

    if resetEntries then entries = startEntries end
end

local function reset_game_selections()
    local resetGameEntries = entries == gameEntries

    local floodMapmode = {
        [0] = "Normal",
        [1] = "Random",
        [2] = "Voting"
    }

    

    gameEntries = {
        {separator = "Game Settings",
        name = "Flood Speed",
        permission = PERMISSION_STAFF,
        input = INPUT_JOYSTICK,
        func = set_flood_speed,
        valueText = math.floor(gGlobalSyncTable.speedMultiplier),},
        {name = "Flood Mapmode",
        permission = PERMISSION_STAFF,
        input = INPUT_JOYSTICK,
        func = set_mapmode,
        valueText = floodMapmode[gGlobalSyncTable.mapMode],},
        {name = "Round Cooldown",
        permission = PERMISSION_STAFF,
        input = INPUT_JOYSTICK,
        func = set_round_cooldown,
        valueText = math.floor(ROUND_COOLDOWN / 30) -1,},
        {separator = "",
        name = "Risetto nau!", -- リセット・ナウ！
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = reset_game_settings,},
        {name = "Back",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = function ()
            entries = settingEntries
            selection = 1
        end,},
    }

    if resetGameEntries then entries = gameEntries end
end

local function reset_modifier_entries()
    local resetModifierEntries = entries == modifierEntries

    modifierEntries = {
        {separator = "Modifiers",
        name = "Coinless",
        permission = PERMISSION_STAFF,
        input = INPUT_JOYSTICK,
        func = toggle_nocoin,
        valueText = on_off_text(gGlobalSyncTable.modif_coinless),},
        {name = "Slide Jump",
        permission = PERMISSION_STAFF,
        input = INPUT_JOYSTICK,
        func = toggle_slidejump,
        valueText = on_off_text(gGlobalSyncTable.modif_slide_jump),},
        {name = "Gravity",
        permission = PERMISSION_STAFF,
        input = INPUT_JOYSTICK,
        func = toggle_gravity,
        valueText = on_off_text(gGlobalSyncTable.modif_gravity),},
        {name = "Devil",
        permission = PERMISSION_STAFF,
        input = INPUT_JOYSTICK,
        func = toggle_devil,
        valueText = on_off_text(gGlobalSyncTable.modif_daredevil),},
        {name = "PvP",
        permission = PERMISSION_STAFF,
        input = INPUT_JOYSTICK,
        func = toggle_pvp,
        valueText = on_off_text(gGlobalSyncTable.modif_pvp),},
        {name = "Troll",
        permission = PERMISSION_STAFF,
        input = INPUT_JOYSTICK,
        func = toggle_troll,
        valueText = on_off_text(gGlobalSyncTable.modif_trollface),},
        {separator = "",
        name = "Reset",
        permission = PERMISSION_STAFF,
        input = INPUT_A,
        func = reset_modifier_settings,},
        {name = "Back",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = function ()
            entries = mainEntries
            selection = 1
        end,},
    }

    if resetModifierEntries then
        entries = modifierEntries
    end
end

local function reset_general_selections()
    local resetGeneralEntries = entries == generalEntries

    SPEC = {
        [SPECTATOR_MODE_NORMAL] = "Normal",
        [SPECTATOR_MODE_FOLLOW] = "Follow"
    }

    local TTCSN = {
        [0] = "Fast",
        [1] = "Slow",
        [2] = "Random",
        [3] = "None"
    }

    generalEntries = {
        {separator = "General Settings",
        name = "TTC Speed",
        permission = PERMISSION_STAFF,
        input = INPUT_JOYSTICK,
        func = set_ttc_speed,
        valueText = TTCSN[gGlobalSyncTable.ttcIndex],},
        {name = "Spectator Mode",
        permission = PERMISSION_NONE,
        input = INPUT_JOYSTICK,
        func = set_spectator_mode,
        valueText = SPEC[eFloodVariables.spectatorMode],},
        {separator = "",
        name = "Reset",
        permission = PERMISSION_STAFF,
        input = INPUT_A,
        func = reset_general_settings,},
        {name = "Back",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = function ()
            entries = settingEntries
            selection = 1
        end,},
    }

    if resetGeneralEntries then
        entries = generalEntries
    end
end

local function reset_hud_selections()
    local resetHudEntries = entries == hudEntries

    local fonts = {
        [FONT_MENU] = "Menu",
        [FONT_HUD] = "Hud",
        [FONT_NORMAL] = "Normal",
        [FONT_TINY] = "Tiny",
        [FONT_ALIASED] = "Aliased",
        [FONT_SPECIAL] = "Special",
        [FONT_RECOLOR_HUD] = "Recolor",
        [FONT_CUSTOM_HUD] = "Custom",
    }

    hudEntries = {
        {separator = "Hud Settings",
        name = "Hide Hud",
        permission = PERMISSION_NONE,
        input = INPUT_JOYSTICK,
        func = hide_djui_hudelements,
        valueText = on_off_text(eFloodVariables.hudHide),},
        {name = "FOV Engine",
        permission = PERMISSION_NONE,
        input = INPUT_JOYSTICK,
        func = change_fov_engine,
        valueText = on_off_text(eFloodVariables.engine),},
        {name = "Font",
        permission = PERMISSION_NONE,
        input = INPUT_JOYSTICK,
        func = font_selection,
        valueText = fonts[eFloodVariables.globalFont],},
        {separator = "",
        name = "Reset",
        permission = PERMISSION_STAFF,
        input = INPUT_A,
        func = reset_hud_settings,},
        {name = "Back",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = function ()
            entries = settingEntries
            selection = 1
        end,},

    }

    if resetHudEntries then
        entries = hudEntries
    end
end

local function reset_setting_selections()
    local resetEntries = entries == settingEntries

    settingEntries = {
        {separator = "Settings",
        name = "Game Settings",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = function ()
            entries = gameEntries
            selection = 1
        end,
        valueText = ">",},
        {name = "General Settings",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = function ()
            entries = generalEntries
            selection = 1
        end,
        valueText = ">",},
        {name = "Hud Settings",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = function ()
            entries = hudEntries
            selection = 1
        end,
        valueText = ">",},
        {separator = "",
        name = "Reset",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = reset_all_settings,},
        {name = "Back",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = function ()
            entries = mainEntries
            selection = 1
        end,},
    }

    if resetEntries then entries = settingEntries end
end

local function reset_credit_entries()
    local AUTHOR = 1
    local OG_FLOODS = 2
    local DEV = 3
    local TESTER = 4
    local FAMILY = 5
    local CONTRIBUTOR = 6
    local SPECIAL_THANKS = 7
    local categories = {
        [AUTHOR] = "Author",
        [OG_FLOODS] = "Flood",
        [DEV] = "Developers",
        [TESTER] = "Testers",
        [CONTRIBUTOR] = "Contributors",
        [SPECIAL_THANKS] = "Special Thanks"
    }
    local players = {
        {
            name = "Erik",
            categories = { DEV },
            discord = "whatuwantfrman",
            modsite = "Bomboclath048",
            github = "Erik-Bomboclath"
        },
        {
            name = "Agent X",
            categories = { OG_FLOODS },
            discord = "AgentXLP",
            modsite = "AgentX",
            github = "AgentXLP"
        },
        {
            name = "DT Ryan",
            categories = { OG_FLOODS },
            discord = "?????",
            modsite = nil,
            github = nil
        },
        {
            name = "SuperRodrigo0",
            categories = { SPECIAL_THANKS },
            discord = "superrodrigo",
            modsite = nil,
            github = "SuperRodrigo0"
        },
        {
            name = "zPancho!",
            categories = { AUTHOR },
            discord = "zpanchoi",
            modsite = nil,
            github = zPanchito
        },
        {
            name = "Cent",
            categories = { TESTER },
            discord = "cent02.",
            modsite = nil,
            github = nil
        },
        {
            name = "Goku",
            categories = { TESTER },
            discord = "songoku5182",
            modsite = nil,
            github = ElJosBar
        },
        {
            name = "JCM(Corlg)",
            categories = { TESTER },
            discord = "jcmcorlg2010",
            modsite = nil,
            github = JCMCorlg
        }
    }

    creditEntries = {}

    for categoryIndex, categoryName in ipairs(categories) do
        local separatorAddedForCategory = false
        for _, player in ipairs(players) do
            if table.contains(player.categories, categoryIndex) then
                local separator = nil
                if not separatorAddedForCategory then
                    separatorAddedForCategory = true
                    separator = categoryName
                end
                table.insert(creditEntries, {
                    name = player.name,
                    permission = PERMISSION_NONE,
                    input = INPUT_A,
                    func = function ()
                        entries = {
                            {
                                name = "Name",
                                valueText = player.name
                            },
                            {
                                name = "Discord",
                                valueText = player.discord and player.discord or "None"
                            },
                            {
                                name = "Modsite",
                                valueText = player.modsite and player.modsite or "None"
                            },
                            {
                                name = "Github",
                                valueText = player.github and player.github or "None"
                            },
                            {
                                name = "Back",
                                permission = PERMISSION_NONE,
                                input = INPUT_A,
                                func = function ()
                                    entries = creditEntries
                                    selection = 1
                                end
                            }
                        }
                        selection = 1
                    end,
                    separator = separator
                })
            end
        end
    end

    table.insert(creditEntries, {
        name = "Back",
        permission = PERMISSION_NONE,
        input = INPUT_A,
        func = function()
            entries = mainEntries 
            selection = 1
        end,
        separator = ""
    })
end

local function reset_manual_entries()
    local resetManualEntries = entries == manualEntries

    manualEntries = {
        {
            separator = "The godly manual of Erik",
            name = "Objective",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = {
                    {
                        text = "The main goal of Flood Extreme is to reach the flag before the flood kills you. The flood can come in different variants (Water, Lava, Mud and Sand)"
                    },
                    {
                        name = "Back",
                        permission = PERMISSION_NONE,
                        input = INPUT_A,
                        func = function ()
                            entries = manualEntries
                            selection = 1
                        end
                    }
                }
                selection = 1
            end
        },
        {
            name = "Moderator Permissions",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = {
                    {
                        text = "If you are granted moderator status by the person hosting the server in Fex, you can affect what happens in the server. You can stop a round early and edit things like which modifiers are being used and the speed of the flood on the settings. Moderators have full power over the server like the hoster, so better not have trust issues"
                    },
                    {
                        name = "Back",
                        permission = PERMISSION_NONE,
                        input = INPUT_A,
                        func = function ()
                            entries = manualEntries
                            selection = 1
                        end
                    }
                }
                selection = 1
            end,
        },
        {
            name = "Emotes",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = {
                    {
                        text = "If you tap one of the DPad directions, you can do an emote! There are certain combinations you can use to emote in different ways. The combinations are L + DPad, X + DPad, and Y + DPad"
                    },
                    {
                        name = "Back",
                        permission = PERMISSION_NONE,
                        input = INPUT_A,
                        func = function ()
                            entries = manualEntries
                            selection = 1
                        end
                    }
                }
                selection = 1
            end,
        },
        {
            name = "Commands",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = {
                    {
                        text = "Flood Extreme comes with some essential commands like /flood start, speed, time, hide, score, info and spect. However, only info, score, hide and spect are available for non moderators and server hosters"
                    },
                    {
                        name = "Back",
                        permission = PERMISSION_NONE,
                        input = INPUT_A,
                        func = function ()
                            entries = manualEntries
                            selection = 1
                        end
                    }
                }
                selection = 1
            end,
        },
        {
            name = "Music",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = {
                    {
                        text = "Flood Extreme comes also with some fire bangers, while i didn't distribute any names on the songs, most of them come from the 'SMW Central'. You can find familiar some music like bitdw, ctt and bits, since they come from the Touhou OST"
                    },
                    {
                        name = "Back",
                        permission = PERMISSION_NONE,
                        input = INPUT_A,
                        func = function ()
                            entries = manualEntries
                            selection = 1
                        end
                    }
                }
                selection = 1
            end,
        },
        {
            name = "Back",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = mainEntries
                selection = 1
            end,
            separator = ""
        }
    }

    if resetManualEntries then
        entries = manualEntries
    end
end

local function is_entry_visible(entryIndex)
    local entryHeight = 90
    for i in pairs(entries) do
        entryHeight = entryHeight + 60
        if entries[i].separator ~= nil then
            entryHeight = entryHeight + 30
        end

        if i == entryIndex then break end
    end

    if entryHeight - scrollOffset < 30 then return false end
    if entryHeight - scrollOffset > 810 then return false end

    return true
end

local function background()
    local theme = get_selected_theme()
    djui_hud_set_color(theme.background.r, theme.background.g, theme.background.b, 255)
    djui_hud_render_rect(bgX, bgY - 100, bgWidth, bgHeight + 200)
end

local function settings_text()
    local theme = get_selected_theme()
    
    if bgY - scrollOffset < -20 then return end
    
    djui_hud_set_font(FONT_MENU)

    local part1 = " Flood"
    local part2 = " DEMON!  "
    local fullText = part1 .. part2
    local fullTextWidth = djui_hud_measure_text(fullText)

    local centerX = bgX + (bgWidth / 2) - (fullTextWidth / 2)
    local textY = bgY + 50 - scrollOffset

    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text(part1, centerX, textY, 1)

    djui_hud_set_color(139, 0, 0, 255)
    djui_hud_print_text(part2, centerX + djui_hud_measure_text(part1), textY, 1)
    
    djui_hud_set_font(FONT_NORMAL)
end

local function hud_render()
    local height = 90
    local x = bgX + 20
    local y = bgY + 20
    if not showSettings then
        entries = mainEntries
        selection = 1
        scrollOffset = 0
        return
    end

    djui_hud_set_font(FONT_NORMAL)
    djui_hud_set_resolution(RESOLUTION_DJUI)

    scrollOffset = 0

    scrollEntry = 12
    for i in pairs(entries) do
        if  entries[i].separator ~= nil
        and i < scrollEntry - 1 then
            scrollEntry = scrollEntry - (2/3)
        end
    end

    scrollEntry = math.floor(scrollEntry)

    if selection > scrollEntry then
        for i = scrollEntry + 1, selection do
            scrollOffset = scrollOffset + 60

            if entries[i].separator ~= nil then
                scrollOffset = scrollOffset + 30
            end
        end
    end

    background()
    settings_text()

    local theme = get_selected_theme()
    local height = 90
    local x = (djui_hud_get_screen_width() / 2) - (bgWidth / 2)
    local y = (djui_hud_get_screen_height() - bgHeight) / 2

    for i in pairs(entries) do
        if entries[i].separator ~= nil then
            if not is_entry_visible(i) then
                height = height + 90
                goto continue
            end
            height = height + 45

            djui_hud_set_color(theme.text.r, theme.text.g, theme.text.b, 255)
            djui_hud_print_text(entries[i].separator, x + 50, y + height + 4 - scrollOffset, 1)

            height = height + 45
        else
            height = height + 60
        end

        if not is_entry_visible(i) then goto continue end

        if entries[i].text ~= nil then

            if entries[i].name ~= nil then
                if selection == i then
                    djui_hud_set_color(theme.selectedText.r, theme.selectedText.g, theme.selectedText.b, 255)
                else
                    djui_hud_set_color(theme.text.r, theme.text.g, theme.text.b, 255)
                end

                djui_hud_print_text(tostring(entries[i].name), x + 30, y + height + 4 - scrollOffset, 1)

                height = height + 30
            end

            local textAmount = 64
            if SM64COOPDX_VERSION ~= nil then textAmount = 55 end
            local wrappedTextLines = wrap_text(entries[i].text, textAmount)

            for j, line in ipairs(wrappedTextLines) do
                if selection == i then
                    djui_hud_set_color(theme.selectedText.r, theme.selectedText.g, theme.selectedText.b, 255)
                else
                    djui_hud_set_color(theme.text.r, theme.text.g, theme.text.b, 255)
                end

                -- Calculate centered position for each line
                local lineWidth = djui_hud_measure_text(line)
                local centeredX = x + (bgWidth / 2) - (lineWidth / 2)
                
                djui_hud_print_text(line, centeredX, y + height - scrollOffset + (j - 1) * 28, 1)
            end

            for _ in pairs(wrappedTextLines) do
                height = height + 25
            end

            goto continue
        end

        if selection == i then
            djui_hud_set_color(theme.hoverRect.r, theme.hoverRect.g, theme.hoverRect.b, 230)
        else
            djui_hud_set_color(theme.rect.r, theme.rect.g, theme.rect.b, 200)
        end

        djui_hud_render_rect(rectX, y + height - scrollOffset, rectWidth, 40)

        if not has_permission(entries[i].permission)
        or entries[i].disabled then
            djui_hud_set_color(theme.disabledText.r, theme.disabledText.g, theme.disabledText.b, 255)
        else
            djui_hud_set_color(theme.text.r, theme.text.g, theme.text.b, 255)
        end

        if entries[i].name ~= nil then
            djui_hud_print_text(tostring(entries[i].name), rectX + 20, y + height + 4 - scrollOffset, 1)
        end

        if entries[i].valueText ~= nil then
            djui_hud_set_color(theme.text.r, theme.text.g, theme.text.b, 255)
            djui_hud_print_text(tostring(entries[i].valueText), rectX + rectWidth - 20 - djui_hud_measure_text(tostring(entries[i].valueText)), y + height + 4 - scrollOffset, 1)
        end

        ::continue::
    end
end

---@param m MarioState
local function mario_update(m)

    if lockedRunAnimation then
        if customRunAnimation == 1 then
            m.marioBodyState.torsoAngle.x = -3000
        elseif customRunAnimation == 2 then
            m.marioBodyState.torsoAngle.x = 0
            m.marioBodyState.torsoAngle.z = 0
        elseif customRunAnimation == 3 then
            m.marioBodyState.torsoAngle.y = 33000
            m.marioBodyState.torsoAngle.z = 0
        elseif customRunAnimation == 4 then
            m.marioBodyState.torsoAngle.x = 4690
        elseif customRunAnimation == 5 then
            m.marioBodyState.torsoAngle.x = 0
        elseif customRunAnimation == 6 then
            m.marioBodyState.torsoAngle.z = 3000
        elseif customRunAnimation == 7 then
            m.marioBodyState.torsoAngle.z = -3000
        elseif customRunAnimation == 8 then
            m.marioBodyState.torsoAngle.z = 33000
        end
    end

    if lockedEyeState and customEyeState ~= MARIO_EYES_DEFAULT then
        m.marioBodyState.eyeState = customEyeState
    end

    if lockedTrailParticle then
        set_mario_particle_flags(gMarioStates[0], customTrailParticle, 0)
    end

    if m.playerIndex ~= 0 then return end
    if not showSettings then return end

    m.freeze = 1

    if m.controller.stickX == 0
    and m.controller.stickY == 0
    and m.controller.buttonDown & U_JPAD == 0
    and m.controller.buttonDown & D_JPAD == 0 then joystickCooldown = 0 end

    if (m.controller.buttonDown & U_JPAD ~= 0
    or m.controller.stickY > 0.5) and joystickCooldown <= 0 then
        selection = selection - 1
        if selection < 1 then selection = clamp(#entries, 1,  #entries + 1) end
        play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, gGlobalSoundSource)
        joystickCooldown = 0.2 * 30
    elseif (m.controller.buttonDown & D_JPAD ~= 0
    or m.controller.stickY < -0.5) and joystickCooldown <= 0 then
        selection = selection + 1
        if selection > #entries then selection = 1 end
        play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, gGlobalSoundSource)
        joystickCooldown = 0.2 * 30
    end

    if (m.controller.buttonPressed & R_JPAD ~= 0 or (m.controller.stickX > 0.5
    and joystickCooldown <= 0))
    and entries[selection].input == INPUT_JOYSTICK then
        if has_permission(entries[selection].permission)
        and not entries[selection].disabled then
            if entries[selection].func ~= nil then
                entries[selection].func()
                play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, gGlobalSoundSource)
            end
        else
            play_sound(SOUND_MENU_CAMERA_BUZZ, gGlobalSoundSource)
        end

        joystickCooldown = 0.2 * 30
    elseif (m.controller.buttonPressed & L_JPAD ~= 0 or (m.controller.stickX < -0.5
    and joystickCooldown <= 0))
    and entries[selection].input == INPUT_JOYSTICK then
        if has_permission(entries[selection].permission)
        and not entries[selection].disabled then
            if entries[selection].func ~= nil then
                entries[selection].func()
                play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, gGlobalSoundSource)
            end
        else
            play_sound(SOUND_MENU_CAMERA_BUZZ, gGlobalSoundSource)
        end

        joystickCooldown = 0.2 * 30
    end

    if joystickCooldown > 0 then joystickCooldown = joystickCooldown - 1 end

    if  m.controller.buttonPressed & A_BUTTON ~= 0
    and entries[selection].input == INPUT_A then
        if has_permission(entries[selection].permission)
        and not entries[selection].disabled then
            if entries[selection].func ~= nil then
                entries[selection].func()
                play_sound(SOUND_MENU_CLICK_FILE_SELECT, gGlobalSoundSource)
            end
        else
            play_sound(SOUND_MENU_CAMERA_BUZZ, gGlobalSoundSource)
        end
    end
    reset_main_entries()
    reset_start_entries()
    reset_game_selections()
    reset_general_selections()
    reset_hud_selections()
    reset_credit_entries()
    reset_modifier_entries()
    reset_manual_entries()
    reset_setting_selections()
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_HUD_RENDER, hud_render)