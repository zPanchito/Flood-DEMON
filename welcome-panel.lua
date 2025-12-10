-- belongs to flood extreme, but use it as you want

CLOSE_ON_MOUSE_HOVER = true

globalFont = FONT_MENU
scale = 0.5
color = "#DCDCDC"

-- Code by Erik
local rotatingTextTimer = 0
local currentRotatingText = "aña" -- "Ah! There is no text for you!!"
local rotatingTextOptions = {
    "Will there be a sequel to Flood Demon?", -- "Dry box holds a secret, ask Erik"
    "!Flood ???H??3iL??!",
	"Ahhh!, very difficult!!!",
	"Erik and his flood extreme make a good pair",
	"Get rid of the flood+",
	"Uziel likes TV Woman!!",
	"Free Venezuela!!!!!!",
	"Coming soon: Flood De-He",
	"Will they release the end update?",
	"Why am I still working with this flood?? Sincerely, zPancho!",
	"Departure date: ????????",
	"Code of random text By Erik"
}

local switched = true
local hasConfirmed = false
function displayrules(m)
    -- Update rotating text every 5 seconds (5 * 30 = 300 frames at 30 FPS)
    if rotatingTextTimer <= 0 then
        local randomIndex = math.random(1, #rotatingTextOptions)
        randomText = rotatingTextOptions[randomIndex]
        rotatingTextTimer = 5 * 30
    else
        rotatingTextTimer = rotatingTextTimer - 1
    end

    hostnum = network_local_index_from_global(0)
    host = gNetworkPlayers[hostnum]
    texts = {
        {
            "-                         -", 25, -325, globalFont, 0.85, "#8B0000"
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
            "DT] Ryan", -400, -75, globalFont, scale, "#ff3030" -- ff3030
        },
        {
            ": Flood DEMON", -210, -150, globalFont, scale, color
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
            "- Information -", 275, -200, globalFont, 0.6, "#ffff00"
		},
        {
            "- Notices -", 275, 175, globalFont, 0.6, "#ffff00"
		},
        {
            "Im fixing the PvP modification", 275, 210, globalFont, scale, color
        },
        {
            "The voting mode still has bugs", 275, 250, globalFont, scale, color
        },
        {
            "A new map will be added!!", 275, 290, globalFont, scale, color
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
            randomText, 0, 385, globalFont, 0.6, color
        },
        {
            "OK", 0, 360, globalFont, 1.5, "#ffffff"
        },
    }


    m = gMarioStates[0]
    if (switched == true) then
        if (hasConfirmed == false) then
            set_mario_action(m, ACT_READING_AUTOMATIC_DIALOG, 0)
        end

        renderRect(190, 120, FONT_MENU, 1000, 800, "#000000")

        for _, v in ipairs(texts) do
            printColorText(v[1], v[2], v[3], v[4], v[5], v[6])
        end

        local xd = returnX("OK", scale, globalFont)
        local yd = returnY("OK", scale, globalFont) + 360

        local mousex = djui_hud_get_mouse_x()
        local mousey = djui_hud_get_mouse_y()

        local dist = math.sqrt(((xd - mousex) ^ 2) + (((yd + 40) - mousey) ^ 2))
        if (CLOSE_ON_MOUSE_HOVER) then
            if (dist < 40) then
                switched = false
                play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
                if (hasConfirmed == false) then
                    set_mario_action(m, ACT_IDLE, 0) -- ACT_READING_AUTOMATIC_DIALOG
                    hasConfirmed = true
                end
            end
        end

        if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
            switched = false
            play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
            if (hasConfirmed == false) then
                set_mario_action(m, ACT_IDLE, 0)
                hasConfirmed = true
            end
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

    local halfwidth = screenWidth / 2
    local halfheight = screenHeight / 2

    local xc = x + halfwidth
    local yc = y + halfheight

    local xx = xc - halfwidth
    local yy = yc - halfheight

    local xd = x + (screenWidth / 2)
    local yd = y + (screenHeight / 2)

    local xe = x + (w / 2)
    local ye = y + (h / 2)

    local fx = xd - xe
    local fy = yd - ye

    djui_hud_set_color(rgbtable.r, rgbtable.g, rgbtable.b, 170)
    djui_hud_render_rect(fx, fy, w, h)
end

function displayrules2()
    if (switched) then
        djui_chat_message_create("Panel is already open.")
        return true
    end
    switched = true
    return true
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

hook_event(HOOK_ON_HUD_RENDER, displayrules)
hook_chat_command("msg", "shows flood's panel msg", displayrules2)
