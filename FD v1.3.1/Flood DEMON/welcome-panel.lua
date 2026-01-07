CLOSE_ON_MOUSE_HOVER = true

globalFont = FONT_MENU
scale = 0.5
color = "#DCDCDC"

TEX_ROUNDED_CORNER1 = get_texture_info("cornertl")
TEX_ROUNDED_CORNER2 = get_texture_info("cornertr")
TEX_ROUNDED_CORNER3 = get_texture_info("cornerbl")
TEX_ROUNDED_CORNER4 = get_texture_info("cornerbr")

local animTimer = 0
local animDuration = 60
local switched = true

function displayrules(m)
    hostnum = network_local_index_from_global(0)
    host = gNetworkPlayers[hostnum]
    texts = {
        {
            "-                       -", 25, -325, globalFont, 0.85, color
        },
        {
            " Flood               ", 40, -325, globalFont, 1, color
        },
        {
            "   DEMON!",  70, -325, globalFont, 1, "#8B0000"
        },
        {
            "- Credits -", -300, -190, globalFont, 0.6, "#ffff00"
        },
        {
            ": Flood", -290, -40,  globalFont, scale, color
        },
        {
            "Agent X", -400, -40, globalFont, 0.5, "#ec7731" -- 
        },
        {
            ": Flood Nightmare", -210, -115, globalFont, scale, color
        },
        {
            "DT] Ryan", -400, -115, globalFont, scale, "#ff3030"
        },
        {
            ": Flood DEMON!", -210, -150, globalFont, scale, color
        },
        {
            "zPan", -400, -150, globalFont, scale, "#00ff00"
		},
        {
            "cho!", -337, -150, globalFont, scale, "#ffff00"
        },
        {
		    ": Lobby Map", -215, 20, globalFont, scale, color
        },
        {
		    ": Flood Expanded", -215, -75, globalFont, scale, color -- 75
        },
        {
		    "birdekek", -400, -75, globalFont, scale, "#7089b8"
        },
        {
            "SuperRodrigo0", -400, 20, globalFont, scale, "#ffffff"
        },
        {
            "Blocky.cmd", -400, 55, globalFont, scale, "#008888"
        },
        {
            ": Pause Menu", -235, 55, globalFont, scale, color
        },
        {
            "- Play Tester -", -300, 175, globalFont, scale, "#ffff00"
        },
        {
            "Cent24", -300, 210, globalFont, scale, "#ff3278"
        },
        {
            "JCM-Corlg!", -300, 250, globalFont, scale, "#51d1f6"
        },
        {
            "Goku", -300, 290, globalFont, scale, "#004900"
		},
        {
            "Caleb", -370, 330, globalFont, scale, "#ff0000"
		},
        {
            "SM64", -300, 330, globalFont, scale, "#0000ff"
		},
        {
            "_CR", -235, 330, globalFont, scale, "#ffffff"
        },
        {
            "- Information -", 275, -200, globalFont, 0.6, "#ffff00"
	    },
        {
	        "Version", 275, -150,  globalFont, 0.6, color
        },
        {
            "1 3 1", 275, -60,  globalFont, 1, color
        },
        {
		    ". .", 280, -60,  globalFont, 1, color
        },
        {
            "OK", 0, 360, globalFont, 1.5, "#ffffff"
        },
    }

if not switched then
        animTimer = 0 
        return 
    end

    if animTimer < 120 then 
        animTimer = animTimer + 1
    end

    local progress = clampf(animTimer / 60, 0.001, 1)
    local slide_y = (128 / -progress) + 128

    local bounce_y = 0
    if animTimer >= 60 then
        local t_bounce = (animTimer - 60) / 20 
        bounce_y = 15 * math.exp(-4 * t_bounce) * math.sin(12 * t_bounce)
    end

    local global_y_modifier = slide_y + bounce_y

    m = gMarioStates[0]
    if (hasConfirmed == false) then
        set_mario_action(m, ACT_READING_AUTOMATIC_DIALOG, 0)
    end

    renderRect(0, -global_y_modifier, FONT_MENU, 1000, 800, "#000000")

    if animTimer > 1 then
        for _, v in ipairs(texts) do
            printColorText(v[1], v[2], v[3] - global_y_modifier, v[4], v[5], v[6])
        end
    end

    local xd = returnX("OK", 1.5, globalFont)
    local yd = returnY("OK", 1.5, globalFont) + (360 - global_y_modifier)
    local mousex, mousey = djui_hud_get_mouse_x(), djui_hud_get_mouse_y()
    local dist = math.sqrt(((xd - mousex) ^ 2) + (((yd + 40) - mousey) ^ 2))
    if animTimer > 60 then
        if (CLOSE_ON_MOUSE_HOVER and dist < 40) or (m.controller.buttonPressed & A_BUTTON ~= 0) then
            cerrarPanel(m)
        end
    end
end

function printColorText(text, x, y, font, scale, color)
    local r, g, b, a = 0, 0, 0, 0

    local rgbtable = checkColorFormat(color)
    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(font)

    local screenWidth = djui_hud_get_screen_width()
    local width = (djui_hud_measure_text(text) / 2) * scale

    local screenHeight = djui_hud_get_screen_height()
    local height = 64 * scale

    local halfwidth = screenWidth / 2
    local halfheight = screenHeight / 2

    local xc = halfwidth - width
    local yc = halfheight - height

    djui_hud_set_color(rgbtable.r, rgbtable.g, rgbtable.b, 255)
    djui_hud_print_text(text, xc + x, yc + y, scale)
end

function returnX(text, scale, font)
    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(font)

    local screenWidth = djui_hud_get_screen_width()
    local width = (djui_hud_measure_text(text) / 2) * scale

    local screenHeight = djui_hud_get_screen_height()
    local height = 64 * scale

    local halfwidth = screenWidth / 2
    local halfheight = screenHeight / 2

    local xc = halfwidth - width
    local yc = halfheight - height

    return xc
end

function returnY(text, scale, font)
    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(font)

    local screenWidth = djui_hud_get_screen_width()
    local width = (djui_hud_measure_text(text) / 2) * scale

    local screenHeight = djui_hud_get_screen_height()
    local height = 64 * scale

    local halfwidth = screenWidth / 2
    local halfheight = screenHeight / 2

    local xc = halfwidth - width
    local yc = halfheight - height

    return yc
end

function renderRect(x, y, font, w, h, color)
    local rgbtable = checkColorFormat(color)
    djui_hud_set_resolution(RESOLUTION_DJUI)

    local screenWidth = djui_hud_get_screen_width()
    local screenHeight = djui_hud_get_screen_height()

    local xd = x + (screenWidth / 2)
    local yd = y + (screenHeight / 2)
    local fx = xd - (w / 2)
    local fy = yd - (h / 2)

    local cornerSize = 16
    djui_hud_set_color(rgbtable.r, rgbtable.g, rgbtable.b, 170)

    djui_hud_render_rect(fx + cornerSize, fy, w - (cornerSize * 2), h)
    djui_hud_render_rect(fx, fy + cornerSize, cornerSize, h - (cornerSize * 2))
    djui_hud_render_rect(fx + w - cornerSize, fy + cornerSize, cornerSize, h - (cornerSize * 2))

    -- Esquinas
    djui_hud_render_texture(TEX_ROUNDED_CORNER1, fx, fy, cornerSize / 16, cornerSize / 16)
    djui_hud_render_texture(TEX_ROUNDED_CORNER2, fx + w - cornerSize, fy, cornerSize / 16, cornerSize / 16)
    djui_hud_render_texture(TEX_ROUNDED_CORNER3, fx, fy + h - cornerSize, cornerSize / 16, cornerSize / 16)
    djui_hud_render_texture(TEX_ROUNDED_CORNER4, fx + w - cornerSize, fy + h - cornerSize, cornerSize / 16, cornerSize / 16)
end

function displayrules2()
    if (switched) then
        djui_chat_message_create("Panel is already open.")
        return true
    end
    animTimer = 0
    panelScale = 0
    switched = true
    return true
end

if hud_state == 1 and hud_timer > 125 then
   hud_state = 2
end

        if hud_state == 0 then
            if (hud_timer - 60) <= 30 then
                render_colored_text_centered("3", screen_width / 2, (djui_hud_get_screen_height() / 2) - (global_y_modifier - 256), 1, 1)
            elseif (hud_timer - 60) <= 60 and (hud_timer - 60) > 30 then
                render_colored_text_centered("2", screen_width / 2, (djui_hud_get_screen_height() / 2) - (global_y_modifier - 256), 1, 1)
            elseif (hud_timer - 60) <= 90 and (hud_timer - 60) > 60 then
                render_colored_text_centered("1", screen_width / 2, (djui_hud_get_screen_height() / 2) - (global_y_modifier - 256), 1, 1)
            elseif (hud_timer - 60) > 90 then
                render_colored_text_centered(strings[5], screen_width / 2, (djui_hud_get_screen_height() / 2) - (global_y_modifier - 256), 1, 1)
            end
        end

local function on_mario_update(m)
    if (hud_timer - 60) > 90 and hud_state ~= 2 then
        if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
            hud_state = 1
            hud_timer = 90

            play_sound_cbutton_down()
        end
    end
end

function cerrarPanel(m)
    switched = false
    play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
    if (hasConfirmed == false) then
        set_mario_action(m, ACT_IDLE, 0)
        hasConfirmed = true
    end
end

function checkColorFormat(rgbhex)
    local r, g, b, a = 0, 0, 0, 0

    local d = string.find(color, "#")
    if ((d == 1) and (string.len(rgbhex) == 7)) then
        local colorhex = string.gsub(rgbhex, "#", "")
        r = string.sub(colorhex, 0, 2)
        g = string.sub(colorhex, 3, 4)
        b = string.sub(colorhex, 5, 6)

        r = tonumber(r, 16)
        g = tonumber(g, 16)
        b = tonumber(b, 16)
        return {r = r, g = g, b = b}
    else
        print("Color format is wrong.")
        return
    end
end
hook_chat_command("msg", "shows flood's panel msg", displayrules2)
hook_event(HOOK_ON_HUD_RENDER, displayrules)