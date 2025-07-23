if unsupported then return end
smlua_audio_utils_replace_sequence(0x12, 12, 175, "voting") -- remember to make this compatible with music packs later [not finished]

-- Load Textures
TEX_HUDCORNER1 = get_texture_info("cornertl")
TEX_HUDCORNER2 = get_texture_info("cornertr")
TEX_HUDCORNER3 = get_texture_info("cornerbl")
TEX_HUDCORNER4 = get_texture_info("cornerbr")
local TEX_EXCLAMATION_BLOCK = get_texture_info("wing_cap_box_front.rgba16")
local TEX_BREAK_BOX = get_texture_info("segment2.13C58.rgba16")

--- @class Box
--- @field public x integer
--- @field public y integer
--- @field public w integer
--- @field public h integer
--- @field public cornerRadius integer

gGlobalSyncTable.newtimer = 0
gGlobalSyncTable.votingTimer = (16 * 30) + 45
gGlobalSyncTable.alpha = 0
gGlobalSyncTable.map_deciding = false
gGlobalSyncTable.course1_v = 0
gGlobalSyncTable.course2_v = 0
gGlobalSyncTable.course3_v = 0

--- Locals
local pickedMap = false
local position = 1
local screenWidth = djui_hud_get_screen_width()

if network_is_server() then
    repeat
        gGlobalSyncTable.course1 = math.random(1, #gLevels)
        gGlobalSyncTable.course2 = math.random(1, #gLevels)
        gGlobalSyncTable.course3 = math.random(1, #gLevels)
        attempts = (attempts or 0) + 1
        if attempts > 100 then  -- Prevent infinite loops
            djui_chat_message_create("Failed to find unique levels")
            return
        end
    until gGlobalSyncTable.course1 ~= gGlobalSyncTable.course2 and
        gGlobalSyncTable.course1 ~= gGlobalSyncTable.course3 and
        gGlobalSyncTable.course2 ~= gGlobalSyncTable.course3
end

if not gLevels[gGlobalSyncTable.course1] or not gLevels[gGlobalSyncTable.course2] or not gLevels[gGlobalSyncTable.course3] then
    --djui_chat_message_create("Invalid level selection. Aborting vote.")
end

gBoxTable = {}

local function truncateString(inputString, maxLength)
    if #inputString > maxLength then
        return string.sub(inputString, 1, maxLength - 3) .. "..."
    else
        return inputString
    end
end

local function add_new_box(x, y, w, h, cornerRadius)
    table.insert(gBoxTable, {x = x, y = y, w = w, h = h, cornerRadius = cornerRadius})
end

---@param tex TextureInfo
---@param box Box
local function render_texture_within_box(tex, box)
    if not tex or not box then return end
    djui_hud_render_texture(tex,
                            box.x + box.cornerRadius,
                            box.y + box.cornerRadius,
                            (box.w - box.cornerRadius * 2) / tex.width,
                            (box.h - box.cornerRadius * 2) / tex.height)
end

local function move_hud_box(boxnum, dist, angle)
    local angle_rad = math.rad(angle)
    local dx = dist * math.cos(angle_rad)
    local dy = dist * math.sin(angle_rad)

    for i, box in pairs(gBoxTable) do
        if i == boxnum then
            box.x = box.x + dx
            box.y = box.y + dy
        end
    end
end

function init_voting_menu()
    if network_is_server() then
        gGlobalSyncTable.votingTimer = (16 * 30) + 45
    end
    --position = 0
    --pickedMap = false
    if network_is_server() then
        gGlobalSyncTable.newtimer = 0
    end
    if network_is_server() then
        gGlobalSyncTable.alpha = 0
    end

    --djui_chat_message_create(tostring(#gBoxTable))

    if #gBoxTable == 0 then
        add_new_box((screenWidth / 2) - 512, 384, 256, 256, 16)
        add_new_box((screenWidth / 2) - 128, 384, 256, 256, 16)
        add_new_box((screenWidth / 2) + 256, 384, 256, 256, 16)

        -- Name Boxes
        add_new_box((screenWidth / 2) - (512 - 42), 655, 170, 32, 16)
        add_new_box((screenWidth / 2) - (128 - 42), 655, 170, 32, 16)
        add_new_box((screenWidth / 2) + (256 + 42), 655, 170, 32, 16)

        -- Selection Box
        add_new_box((screenWidth / 2) - 512, 384, 256, 256, 16)


    end

end

function init_voting_timer()
    if #gLevels < 3 then  -- Add this check
        djui_chat_message_create("Not enough levels to vote (need at least 3)")
        return
    end

    -- Reset vote counts
    gGlobalSyncTable.course1_v = 0
    gGlobalSyncTable.course2_v = 0
    gGlobalSyncTable.course3_v = 0
    gGlobalSyncTable.map_deciding = true

    -- Select 3 unique random levels
    repeat
        gGlobalSyncTable.course1 = math.random(#gLevels)
        gGlobalSyncTable.course2 = math.random(#gLevels)
        gGlobalSyncTable.course3 = math.random(#gLevels)
    until gGlobalSyncTable.course1 ~= gGlobalSyncTable.course2 and
          gGlobalSyncTable.course1 ~= gGlobalSyncTable.course3 and
          gGlobalSyncTable.course2 ~= gGlobalSyncTable.course3

    -- Set timers and visual effects
    if network_is_server() then
        gGlobalSyncTable.votingTimer = (16 * 30) + 45
    end
    --position = 0
    --pickedMap = false
    if network_is_server() then
        gGlobalSyncTable.newtimer = 0
    end
    if network_is_server() then
        gGlobalSyncTable.alpha = 0
    end

    -- Reset UI boxes
    gBoxTable = {}
    local centerX = screenWidth / 2

    -- Main Course Boxes (3 columns)
    add_new_box(centerX - 512, 384, 256, 256, 16)  -- Left
    add_new_box(centerX - 128, 384, 256, 256, 16)  -- Middle
    add_new_box(centerX + 256, 384, 256, 256, 16)  -- Right

    -- Name Boxes (below each course box)
    add_new_box(centerX - (512 - 42), 655, 170, 32, 16)  -- Left name
    add_new_box(centerX - (128 - 42), 655, 170, 32, 16)  -- Middle name
    add_new_box(centerX + (256 + 42), 655, 170, 32, 16)  -- Right name

    -- Selection Box (initial position)
    add_new_box(centerX - 512, 384, 256, 256, 16)
end

function host_init_voting_timer()
    if not network_is_server() then return end
    if #gLevels < 3 then  -- Add this check
        djui_chat_message_create("Not enough levels to vote (need at least 3)")
        return
    end

    -- Reset vote counts
    gGlobalSyncTable.course1_v = 0
    gGlobalSyncTable.course2_v = 0
    gGlobalSyncTable.course3_v = 0
    gGlobalSyncTable.map_deciding = true

    -- Select 3 unique random levels
    repeat
        gGlobalSyncTable.course1 = math.random(#gLevels)
        gGlobalSyncTable.course2 = math.random(#gLevels)
        gGlobalSyncTable.course3 = math.random(#gLevels)
    until gGlobalSyncTable.course1 ~= gGlobalSyncTable.course2 and
          gGlobalSyncTable.course1 ~= gGlobalSyncTable.course3 and
          gGlobalSyncTable.course2 ~= gGlobalSyncTable.course3

    -- Set timers and visual effects
    gGlobalSyncTable.votingTimer = (16 * 30) + 45  -- ~16.45 seconds
    gGlobalSyncTable.newtimer = 0
    gGlobalSyncTable.alpha = 0

    -- Reset UI boxes
    gBoxTable = {}
    local centerX = screenWidth / 2

    -- Main Course Boxes (3 columns)
    add_new_box(centerX - 512, 384, 256, 256, 16)  -- Left
    add_new_box(centerX - 128, 384, 256, 256, 16)  -- Middle
    add_new_box(centerX + 256, 384, 256, 256, 16)  -- Right

    -- Name Boxes (below each course box)
    add_new_box(centerX - (512 - 42), 655, 170, 32, 16)  -- Left name
    add_new_box(centerX - (128 - 42), 655, 170, 32, 16)  -- Middle name
    add_new_box(centerX + (256 + 42), 655, 170, 32, 16)  -- Right name

    -- Selection Box (initial position)
    add_new_box(centerX - 512, 384, 256, 256, 16)
end

function djui_hud_set_adjusted_color(r, g, b, a)
    local multiplier = is_game_paused() and 0.5 or 1
    djui_hud_set_color(r * multiplier, g * multiplier, b * multiplier, a)
end

local function on_hud_render()
    if #gLevels == 0 then return end
    if gGlobalSyncTable.map_deciding then
        if gGlobalSyncTable.newtimer < 128 then
            if gGlobalSyncTable.newtimer < 45 then
                if network_is_server() then
                    gGlobalSyncTable.alpha = gGlobalSyncTable.alpha + 5.67
                end
            elseif gGlobalSyncTable.alpha ~= 0 then
                if network_is_server() then
                    gGlobalSyncTable.alpha = math.max(gGlobalSyncTable.alpha - 5.67, 0)
                end
            end
        elseif gGlobalSyncTable.newtimer > 480 then
            if network_is_server() then
                gGlobalSyncTable.alpha = gGlobalSyncTable.alpha + 5.67
            end
        end

        if network_is_server() then
            gGlobalSyncTable.votingTimer = gGlobalSyncTable.votingTimer - 1
        end

        if network_is_server() then
            gGlobalSyncTable.newtimer = gGlobalSyncTable.newtimer + 1
        end

        if gGlobalSyncTable.newtimer > 45 then
            set_background_music(0, 0x3F, 60)
            gLakituState.mode = CAMERA_MODE_NONE

            if gGlobalSyncTable.newtimer == 480 then
                fade_volume_scale(0, 0, 45)
            end

            djui_hud_set_adjusted_color(100, 0, 25, 255)
            djui_hud_render_rect(0, 0, 8192, 8192)

            djui_hud_set_adjusted_color(100, 35, 55, 155)

            local screenWidth = djui_hud_get_screen_width()
            for i = 0, math.ceil(screenWidth / 30) do
                for j = 0, 10 do
                    djui_hud_render_texture(TEX_EXCLAMATION_BLOCK, i * 128 + ((gGlobalSyncTable.newtimer % 64) * 8) - 512, j * 128 + (math.sin(gGlobalSyncTable.newtimer / 16) * 64) - 128, 4, 4)
                end
            end

            for i = 0, 32 do
                for j = 0, 2 do
                    djui_hud_render_texture(TEX_BREAK_BOX, i * 512 + ((gGlobalSyncTable.newtimer % 128) * 12) - 4096, j * 512, 16, 16)
                end
            end

            djui_hud_set_font(FONT_MENU)
            djui_hud_set_adjusted_color(255, 255, 255, 255)

            if gGlobalSyncTable.newtimer < 128 then
                djui_hud_print_text("...", (screenWidth / 2) - djui_hud_measure_text("..."), 75, 2)
            else
                djui_hud_print_text("Vote now!", (screenWidth / 2) - djui_hud_measure_text("Vote now!"), 75, 2)
            end

            if gGlobalSyncTable.newtimer == 128 then
                djui_chat_message_create("Use \\#8B0000\\L-Stick \\#dcdcdc\\to select and use \\#FF3030\\A \\#dcdcdc\\to finalize your vote.")
            end

            gBoxTable = {}

            -- Main Course Boxes
            add_new_box((screenWidth / 2) - 512, 384, 256, 256, 16)
            add_new_box((screenWidth / 2) - 128, 384, 256, 256, 16)
            add_new_box((screenWidth / 2) + 256, 384, 256, 256, 16)

            -- Name Boxes
            add_new_box((screenWidth / 2) - (512 - 42), 655, 170, 32, 16)
            add_new_box((screenWidth / 2) - (128 - 42), 655, 170, 32, 16)
            add_new_box((screenWidth / 2) + (256 + 42), 655, 170, 32, 16)

            -- Selection Box
            add_new_box((screenWidth / 2) - 512, 384, 256, 256, 16)

            for i, box in ipairs(gBoxTable) do
                if i == 7 and gGlobalSyncTable.newtimer > 127 then
                    if position == 1 then
                        move_hud_box(7, 384, 0)
                    elseif position == 2 then
                        move_hud_box(7, 768, 0)
                    end
                    djui_hud_set_adjusted_color(119, 219, 99, 50)
                else
                    djui_hud_set_adjusted_color(0, 0, 0, 155)
                end

                djui_hud_render_texture(TEX_HUDCORNER1, box.x, box.y, 0.0625 * box.cornerRadius, 0.0625 * box.cornerRadius)
                djui_hud_render_texture(TEX_HUDCORNER3, box.x, box.y + box.h - box.cornerRadius, 0.0625 * box.cornerRadius, 0.0625 * box.cornerRadius)
                djui_hud_render_texture(TEX_HUDCORNER2, box.x + box.w - box.cornerRadius, box.y, 0.0625 * box.cornerRadius, 0.0625 * box.cornerRadius)
                djui_hud_render_texture(TEX_HUDCORNER4, box.x + box.w - box.cornerRadius, box.y + box.h - box.cornerRadius, (0.0625 * box.cornerRadius), (0.0625 * box.cornerRadius))

                djui_hud_render_rect(box.x + box.cornerRadius, box.y, box.w - (box.cornerRadius * 2), box.h)
                djui_hud_render_rect(box.x, box.y + box.cornerRadius, box.cornerRadius, box.h - (box.cornerRadius * 2))
                djui_hud_render_rect(box.x + box.w - box.cornerRadius, box.y + box.cornerRadius, box.cornerRadius, box.h - (box.cornerRadius * 2))
            end

            -- Centered Text

            djui_hud_set_font(FONT_NORMAL)

            djui_hud_set_adjusted_color(255, 255, 255, 255)

            djui_hud_print_text(truncateString(tostring(gLevels[gGlobalSyncTable.course1].codeName), 9) .. ": " .. tostring(gGlobalSyncTable.course1_v), ((djui_hud_get_screen_width() / 2) - 384) - (djui_hud_measure_text(truncateString(tostring(gLevels[gGlobalSyncTable.course1].name), 9) .. ": " .. tostring(gGlobalSyncTable.course1_v)) / 2), 655, 1)

            djui_hud_print_text(truncateString(tostring(gLevels[gGlobalSyncTable.course2].codeName), 9) .. ": " .. tostring(gGlobalSyncTable.course2_v), (djui_hud_get_screen_width() / 2) - (djui_hud_measure_text(truncateString(tostring(gLevels[gGlobalSyncTable.course2].name), 9) .. ": " .. tostring(gGlobalSyncTable.course2_v)) / 2), 655, 1)

            djui_hud_print_text(truncateString(tostring(gLevels[gGlobalSyncTable.course3].codeName), 9) .. ": " .. tostring(gGlobalSyncTable.course3_v), ((djui_hud_get_screen_width() / 2) + 384) - (djui_hud_measure_text(truncateString(tostring(gLevels[gGlobalSyncTable.course3].name), 9) .. ": " .. tostring(gGlobalSyncTable.course3_v)) / 2), 655, 1)

            -- Icons

            render_texture_within_box(gLevels[gGlobalSyncTable.course1].painting, gBoxTable[1]) -- option 1
            render_texture_within_box(gLevels[gGlobalSyncTable.course2].painting, gBoxTable[2]) -- option 2
            render_texture_within_box(gLevels[gGlobalSyncTable.course3].painting, gBoxTable[3]) -- option 3
        end

        -- Black Fade

        djui_hud_set_adjusted_color(0, 0, 0, math.floor(gGlobalSyncTable.alpha))

        djui_hud_render_rect(0, 0, 8192, 8192)

        hud_hide()
    end

    if gGlobalSyncTable.votingTimer <= 0 then
        stop_background_music(0x3F)

        local highest_v = math.max(gGlobalSyncTable.course1_v, gGlobalSyncTable.course2_v, gGlobalSyncTable.course3_v)

        -- Idk what i did here.

        local highest_courses = {}
        if highest_v == gGlobalSyncTable.course1_v then
            table.insert(highest_courses, gGlobalSyncTable.course1)
        end
        if highest_v == gGlobalSyncTable.course2_v then
            table.insert(highest_courses, gGlobalSyncTable.course2)
        end
        if highest_v == gGlobalSyncTable.course3_v then
            table.insert(highest_courses, gGlobalSyncTable.course3)
        end

        local random_index = math.random(#highest_courses)
        gGlobalSyncTable.level = highest_courses[random_index]

        round_start()
        if network_is_server() then
            gGlobalSyncTable.map_deciding = false
        end
        if network_is_server() then
            gGlobalSyncTable.votingTimer = (16 * 30) + 45
        end

    end
end

local function mario_update(m)
    if m.playerIndex ~= 0 then return end

    if gGlobalSyncTable.map_deciding and gGlobalSyncTable.newtimer > 127 then
        if gGlobalSyncTable.newtimer == 128 then
            play_sound_with_freq_scale(SOUND_MENU_PAUSE_2, gGlobalSoundSource, 1)

            position = 0
            pickedMap = false
        end

        if m.controller.stickX == 0 and m.controller.stickY == 0 then joystickCooldown = 0 end

        -- democratic nation... we need voting1!!!111

        if not pickedMap then
            if m.controller.buttonPressed & L_JPAD ~= 0 or (m.controller.stickX < -0.5
            and joystickCooldown <= 0) and position > 0 then
                position = position - 1
                play_sound_with_freq_scale(SOUND_MENU_MESSAGE_NEXT_PAGE, gGlobalSoundSource, 1)
                joystickCooldown = 0.2 * 30
            end

            if m.controller.buttonPressed & R_JPAD ~= 0 or (m.controller.stickX > 0.5
            and joystickCooldown <= 0) and position < 2 then
                position = position + 1
                play_sound_with_freq_scale(SOUND_MENU_MESSAGE_NEXT_PAGE, gGlobalSoundSource, 1)
                joystickCooldown = 0.2 * 30
            end

            if joystickCooldown > 0 then joystickCooldown = joystickCooldown - 1 end

            if m.controller.buttonPressed & A_BUTTON ~= 0 then
                play_sound_with_freq_scale(SOUND_MENU_CLICK_FILE_SELECT, gGlobalSoundSource, 1)
                pickedMap = true

                if position == 0 then
                    gGlobalSyncTable.course1_v = gGlobalSyncTable.course1_v + 1
                elseif position == 1 then
                    gGlobalSyncTable.course2_v = gGlobalSyncTable.course2_v + 1
                elseif position == 2 then
                    gGlobalSyncTable.course3_v = gGlobalSyncTable.course3_v + 1
                end
            end
        else
            if (m.controller.buttonPressed & B_BUTTON) ~= 0 and gGlobalSyncTable.votingTimer >= 50 then
                play_sound_with_freq_scale(SOUND_MENU_CLICK_FILE_SELECT, gGlobalSoundSource, 1)
                if position == 0 then
                    gGlobalSyncTable.course1_v = gGlobalSyncTable.course1_v - 1
                elseif position == 1 then
                    gGlobalSyncTable.course2_v = gGlobalSyncTable.course2_v - 1
                elseif position == 2 then
                    gGlobalSyncTable.course3_v = gGlobalSyncTable.course3_v - 1
                end
                pickedMap = false
            end
        end
    end
end

local soundAllowed = {
    [SOUND_MENU_PAUSE_2] = 1,
    [SOUND_MENU_MESSAGE_NEXT_PAGE] = 1,
    [SOUND_MENU_CLICK_FILE_SELECT] = 1,
    [SOUND_MENU_CAMERA_BUZZ] = 1,
    [SOUND_GENERAL_RACE_GUN_SHOT] = 1
}
local function cancel_everything(sound)
    if gGlobalSyncTable.map_deciding and gGlobalSyncTable.newtimer > 45 and not soundAllowed[sound] then
        return NO_SOUND
    end
end

local function cancel_everything2()
    if gGlobalSyncTable.map_deciding and gGlobalSyncTable.newtimer > 45 then
        return 0
    end
end

hook_event(HOOK_ON_PLAY_SOUND, cancel_everything)
hook_event(HOOK_CHARACTER_SOUND, cancel_everything2)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_MARIO_UPDATE, mario_update)
