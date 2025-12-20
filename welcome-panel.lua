CLOSE_ON_MOUSE_HOVER = true

globalFont = FONT_MENU
scale = 0.5
color = "#DCDCDC"

TEX_ROUNDED_CORNER1 = get_texture_info("cornertl")
TEX_ROUNDED_CORNER2 = get_texture_info("cornertr")
TEX_ROUNDED_CORNER3 = get_texture_info("cornerbl")
TEX_ROUNDED_CORNER4 = get_texture_info("cornerbr")

-- 1. Variables de tiempo y estado
local animTimer = 0
local animDuration = 25.0 -- Duración de la animación visual (aprox 2 seg)
local interactionDelay = 120.0 -- 3 segundos (asumiendo 30 FPS constantes en SM64CoopDX)
local switched = true

local function easeOutBack(t)
    local c1 = 1.3
    local c3 = c1 + 1
    return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)
end

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
           ": Flood Extreme", -255, -110, globalFont, scale, color
        },
        {
            "Erik", -400, -110, globalFont, scale, "#555555"
        },
        {
            ": Flood Nightmare", -210, -75, globalFont, scale, color
        },
        {
            "DT] Ryan", -400, -75, globalFont, scale, "#ff3030"
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
            "SuperRodrigo0", -400, 20, globalFont, scale, "#ffffff"
        },
        {
            "Blocky.cmd", -400, 55, globalFont, scale, "#008888"
        },
        {
            ": Pause Menu", -235, 55, globalFont, scale, color
        },
        {
            ": Main Helper", -270, 90, globalFont, scale, color
        },
        {
            "Erik", -400, 90, globalFont, scale, "#555555"
        },
        {
            "- Play Tester -", -300, 175, globalFont, scale, "#ffff00"
        },
        {
            "Cent", -300, 210, globalFont, scale, "#ff3278"
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
            "Pre-Release ", 275, -110,  globalFont, 0.6, color
        },
        {
            "1 3", 275, -45,  globalFont, 1, color
        },
        {
		    ".", 280, -45,  globalFont, 1, color
        },
        {
            "OK", 0, 360, globalFont, 1.5, "#ffffff"
        },
    }


if not switched then 
        animTimer = 0 
        return 
    end

    -- Actualizar timer de animación
    if animTimer < animDuration then
        animTimer = animTimer + 1
    end
    
    local t = animTimer / animDuration
    local bounceScale = easeOutBack(t) -- Factor que va de 0 a ~1.05 y baja a 1

    m = gMarioStates[0]
    if (hasConfirmed == false) then
        set_mario_action(m, ACT_READING_AUTOMATIC_DIALOG, 0)
    end

    -- Dibujar fondo con el tamaño animado
    renderRect(0, 0, FONT_MENU, 1000 * bounceScale, 800 * bounceScale, "#000000")

    -- Dibujar textos (solo cuando el panel ya tiene un tamaño visible)
    if t > 0.3 then
        for _, v in ipairs(texts) do
            -- Los textos también se desplazan y escalan con el rebote
            printColorText(v[1], v[2] * bounceScale, v[3] * bounceScale, v[4], v[5] * bounceScale, v[6])
        end
    end

    -- Lógica de cierre (Botón OK)
    local xd = returnX("OK", 1.5 * bounceScale, globalFont)
    local yd = returnY("OK", 1.5 * bounceScale, globalFont) + (360 * bounceScale)
    local mousex, mousey = djui_hud_get_mouse_x(), djui_hud_get_mouse_y()
    local dist = math.sqrt(((xd - mousex) ^ 2) + (((yd + 40) - mousey) ^ 2))

    if (CLOSE_ON_MOUSE_HOVER and dist < 40) or (m.controller.buttonPressed & A_BUTTON ~= 0) then
        switched = false
        play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
        if not hasConfirmed then
            set_mario_action(m, ACT_IDLE, 0)
            hasConfirmed = true
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

    -- Cálculos de posición central
    local xd = x + (screenWidth / 2)
    local yd = y + (screenHeight / 2)
    local xe = x + (w / 2)
    local ye = y + (h / 2)
    local fx = xd - xe
    local fy = yd - ye

    local cornerSize = 16
    djui_hud_set_color(rgbtable.r, rgbtable.g, rgbtable.b, 170)

    djui_hud_render_rect(fx + cornerSize, fy, w - (cornerSize * 2), h) -- Rectángulo horizontal
    djui_hud_render_rect(fx, fy + cornerSize, cornerSize, h - (cornerSize * 2)) -- Lado izquierdo
    djui_hud_render_rect(fx + w - cornerSize, fy + cornerSize, cornerSize, h - (cornerSize * 2)) -- Lado derecho

    -- 2. Dibujar las 4 esquinas redondeadas usando las texturas cargadas
    djui_hud_render_texture(TEX_ROUNDED_CORNER1, fx, fy, cornerSize / 16, cornerSize / 16) -- Top Left
    djui_hud_render_texture(TEX_ROUNDED_CORNER2, fx + w - cornerSize, fy, cornerSize / 16, cornerSize / 16) -- Top Right
    djui_hud_render_texture(TEX_ROUNDED_CORNER3, fx, fy + h - cornerSize, cornerSize / 16, cornerSize / 16) -- Bottom Left
    djui_hud_render_texture(TEX_ROUNDED_CORNER4, fx + w - cornerSize, fy + h - cornerSize, cornerSize / 16, cornerSize / 16) -- Bottom Right
end

function displayrules2()
    if (switched) then
        djui_chat_message_create("Panel is already open.")
        return true
    end
    -- Resetear variables de animación
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
