showSettings = false

TEX_ROUNDED_CORNER1 = get_texture_info("cornertl")
TEX_ROUNDED_CORNER2 = get_texture_info("cornertr")
TEX_ROUNDED_CORNER3 = get_texture_info("cornerbl")
TEX_ROUNDED_CORNER4 = get_texture_info("cornerbr")

local bgWidth = 600 
local bgHeight = 800
local bgX = ((djui_hud_get_screen_width() - bgWidth) / 2)
local bgY = ((djui_hud_get_screen_height() - bgHeight) / 2)
local rectWidth = bgWidth - 80
local rectX = bgX + 40

local selection = 1

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
local devManualEntries = {}
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

local function toggle_pvp()
    gGlobalSyncTable.modif_pvp = not gGlobalSyncTable.modif_pvp
    mod_storage_save_bool("PvP", gGlobalSyncTable.modif_pvp)
end

local function toggle_devil()
    gGlobalSyncTable.modif_daredevil = not gGlobalSyncTable.modif_daredevil
    mod_storage_save_bool("Devil", gGlobalSyncTable.modif_daredevil)
end

local function reset_modifier_settings()
    if network_is_server() or network_is_moderator() then
        gGlobalSyncTable.modif_pvp = false
        mod_storage_save_bool("PvP", gGlobalSyncTable.modif_pvp)
        gGlobalSyncTable.modif_daredevil = false
        mod_storage_save_bool("Devil", gGlobalSyncTable.modif_daredevil)

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
        },
        {
            name = "Settings",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
				djui_chat_message_create("Comming Soon!")
            end,
        },
        {
            name = "Modifiers",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = modifierEntries
                selection = 1
            end,
        },
        {
            name = "Manual",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                djui_chat_message_create("Comming Soon!")
            end
        },
        {
            name = "Credits",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function ()
                entries = creditEntries
                selection = 1
            end
        },
        {
            separator = "",
            name = "Close",
            permission = PERMISSION_NONE,
            input = INPUT_A,
            func = function () showSettings = not showSettings end,
            separator = ""
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

local function reset_modifier_entries()
    local resetModifierEntries = entries == modifierEntries

    modifierEntries = {
        {separator = "Modifiers",
        name = "Devil",
        permission = PERMISSION_STAFF,
        input = INPUT_A,
        func = toggle_devil,
        valueText = on_off_text(gGlobalSyncTable.modif_daredevil),},
        {name = "PvP",
        permission = PERMISSION_STAFF,
        input = INPUT_A,
        func = toggle_pvp,
        valueText = on_off_text(gGlobalSyncTable.modif_pvp),},
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
            name = "Cent24",
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
            name = "JCM-Corlg!",
            categories = { TESTER },
            discord = "jcmcorlg2010",
            modsite = nil,
            github = JCMCorlg
        },
        {
            name = "CalebSM64_CR!",
            categories = { TESTER },
            discord = "calebsito_cr8",
            modsite = nil,
            github = Caleb48852
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

-- Bordes
local function background()
    local theme = get_selected_theme()
    local cornerSize = 32 
    local overlap = 1 
    
    local x = bgX
    local y = bgY - 100
    local w = bgWidth
    local h = bgHeight + 200

    djui_hud_set_color(theme.background.r, theme.background.g, theme.background.b, 255)

    djui_hud_render_rect(x + cornerSize - overlap, y, w - (cornerSize * 2) + (overlap * 2), h) 
    
    djui_hud_render_rect(x, y + cornerSize - overlap, cornerSize, h - (cornerSize * 2) + (overlap * 2)) 
    
    djui_hud_render_rect(x + w - cornerSize, y + cornerSize - overlap, cornerSize, h - (cornerSize * 2) + (overlap * 2)) 

    djui_hud_render_texture(TEX_ROUNDED_CORNER1, x, y, cornerSize / 17, cornerSize / 17)
    djui_hud_render_texture(TEX_ROUNDED_CORNER2, x + w - cornerSize, y, cornerSize / 17, cornerSize / 17)
    djui_hud_render_texture(TEX_ROUNDED_CORNER3, x, y + h - cornerSize, cornerSize / 17, cornerSize / 17)
    djui_hud_render_texture(TEX_ROUNDED_CORNER4, x + w - cornerSize, y + h - cornerSize, cornerSize / 17, cornerSize / 17)
end

-- Bordes2
local function render_rounded_rect(x, y, w, h, cornerSize)
    local overlap = 1
    djui_hud_render_rect(x + cornerSize - overlap, y, w - (cornerSize * 2) + (overlap * 2), h)
    djui_hud_render_rect(x, y + cornerSize - overlap, cornerSize, h - (cornerSize * 2) + (overlap * 2))
    djui_hud_render_rect(x + w - cornerSize, y + cornerSize - overlap, cornerSize, h - (cornerSize * 2) + (overlap * 2))

    local texScale = cornerSize / 16
    djui_hud_render_texture(TEX_ROUNDED_CORNER1, x, y, texScale, texScale)
    djui_hud_render_texture(TEX_ROUNDED_CORNER2, x + w - cornerSize, y, texScale, texScale)
    djui_hud_render_texture(TEX_ROUNDED_CORNER3, x, y + h - cornerSize, texScale, texScale)
    djui_hud_render_texture(TEX_ROUNDED_CORNER4, x + w - cornerSize, y + h - cornerSize, texScale, texScale)
end

local function settings_text()
    local theme = get_selected_theme()

    if bgY - scrollOffset < -20 then return end

    djui_hud_set_font(FONT_MENU)

    local part1 = "Flood"
    local part2 = " DEMON!"
    local fullText = part1 .. part2
    local fullTextWidth = djui_hud_measure_text(fullText)

    local centerX = bgX + (bgWidth / 2) - (fullTextWidth / 2)
    local textY = bgY + 70 - scrollOffset

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

                djui_hud_print_text(line, x + 20, y + height - scrollOffset + (j - 1) * 28, 1)
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

        -- Usamos un tamaño de esquina pequeño (por ejemplo 12) para que se vea bien en botones finos
		render_rounded_rect(rectX, y + height - scrollOffset, rectWidth, 40, 12)

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
		
		-- Dentro del bucle for i in pairs(entries) do ...

	-- Calcular la posición final en pantalla del botón actual
	local buttonY = y + height - scrollOffset
	local menuTop = y + 10 -- Límite superior del área de botones
	local menuBottom = y + bgHeight - 50 -- Límite inferior

	-- Calcular opacidad basada en la distancia a los bordes
	local alpha = 255
	if buttonY < menuTop + 100 then
		alpha = clampf((buttonY - menuTop) * 2.55, 0, 255)
	elseif buttonY > menuBottom - 100 then
		alpha = clampf((menuBottom - buttonY) * 2.55, 0, 255)
	end

	-- Aplicar el color del rectángulo con la nueva opacidad
	if selection == i then
		djui_hud_set_color(theme.hoverRect.r, theme.hoverRect.g, theme.hoverRect.b, alpha * 0.9)
	else
		djui_hud_set_color(theme.rect.r, theme.rect.g, theme.rect.b, alpha * 0.78)
	end

	-- Dibujar el rectángulo redondeado (usando la función que creamos antes)
	render_rounded_rect(rectX, buttonY, rectWidth, 40, 12)

	-- Aplicar la misma opacidad al texto
	if not has_permission(entries[i].permission) or entries[i].disabled then
		djui_hud_set_color(theme.disabledText.r, theme.disabledText.g, theme.disabledText.b, alpha)
	else
		if selection == i then
			djui_hud_set_color(theme.selectedText.r, theme.selectedText.g, theme.selectedText.b, alpha)
		else
			djui_hud_set_color(theme.text.r, theme.text.g, theme.text.b, alpha)
		end
	end

	if entries[i].name ~= nil then
		djui_hud_print_text(tostring(entries[i].name), rectX + 20, buttonY + 4, 1)
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
    reset_credit_entries()
    reset_modifier_entries()
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_HUD_RENDER, hud_render)
