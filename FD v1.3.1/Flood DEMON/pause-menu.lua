local zero = {x=0,y=0,z=0}
local m = gMarioStates[0]
local np = gNetworkPlayers[0]
local restartLevelArea = 1

local isPaused = false

local function is_game_paused_modded()
    return isPaused
end

_G.is_game_paused = is_game_paused_modded

local pause_exit_funcs = {}

local real_hook_event = hook_event
local function hook_event_modded(hook, func)
    if hook == HOOK_ON_PAUSE_EXIT then
        table.insert(pause_exit_funcs, func)
    else
        return real_hook_event(hook, func)
    end
end
_G.hook_event = hook_event_modded

local function call_pause_exit_hooks(exitToCastle)
    local allowExit = true
    for _, func in ipairs(pause_exit_funcs) do
        if func(exitToCastle) == false then
            allowExit = false
            break
        end
    end
    return allowExit
end

local play_sound,save_file_get_star_flags,level_trigger_warp,warp_to_warpnode,djui_hud_set_resolution,djui_hud_set_font,
      djui_hud_get_screen_height,djui_hud_get_screen_width,djui_hud_set_color,djui_hud_render_rect,course_is_main_course,get_level_name,
      get_star_name,save_file_get_course_star_count,get_current_save_file_num,save_file_get_course_coin_score,djui_hud_measure_text,
      djui_hud_print_text,obj_count_objects_with_behavior_id,djui_open_pause_menu =
      play_sound,save_file_get_star_flags,level_trigger_warp,warp_to_warpnode,djui_hud_set_resolution,djui_hud_set_font,
      djui_hud_get_screen_height,djui_hud_get_screen_width,djui_hud_set_color,djui_hud_render_rect,course_is_main_course,get_level_name,
      get_star_name,save_file_get_course_star_count,get_current_save_file_num,save_file_get_course_coin_score,djui_hud_measure_text,
      djui_hud_print_text,obj_count_objects_with_behavior_id,djui_open_pause_menu

local selectedOption = 1

function var_close()
    if isPaused then
        isPaused = false
        play_sound(SOUND_MENU_PAUSE_HIGHPRIO, zero)
        m.controller.buttonPressed = 0
    end
end

local cooldown = 5
local cooldownCounter = 0

local previousStickY = 0

function loop_var(var, min, max)
    if var > max then
        var = min
    elseif var < min then
        var = max
    end
    return var
end

local function menu_controls(options)
    local stickY = gMarioStates[0].controller.stickY

    if stickY * previousStickY <= 0 then
        cooldownCounter = cooldownCounter // 2
    end

    if cooldownCounter > 0 then
        cooldownCounter = cooldownCounter - 1
    else
        local delta = options and 1 or -1
        if stickY > 0.5 or gMarioStates[0].controller.buttonPressed & U_JPAD ~= 0 then
            selectedOption = (selectedOption - delta)
            if options then
                selectedOption = loop_var(selectedOption, 1, #options)
            else
                selectedOption = loop_var(selectedOption, 0, COURSE_MAX)
            end
            play_sound(SOUND_MENU_CHANGE_SELECT, zero)
            cooldownCounter = cooldown
        elseif stickY < -0.5 or gMarioStates[0].controller.buttonPressed & D_JPAD ~= 0 then
            selectedOption = (selectedOption + delta)
            if options then
                selectedOption = loop_var(selectedOption, 1, #options)
            else
                selectedOption = loop_var(selectedOption, 0, COURSE_MAX)
            end
            play_sound(SOUND_MENU_CHANGE_SELECT, zero)
            cooldownCounter = cooldown
        end
    end

    if gMarioStates[0].controller.buttonPressed & A_BUTTON ~= 0 and options then
        play_sound(SOUND_MENU_CLICK_FILE_SELECT, gMarioStates[0].pos)
        local option = options[selectedOption]
        if option and option.func then
            option.func()
        end
    end

    previousStickY = stickY
end

local romhackText = ""

for i, mod in pairs(gActiveMods) do
    if mod.enabled then
        if mod.incompatible and mod.incompatible:find("romhack") then
            if romhackInfo == nil then
                romhackText = string_without_hex(mod.name)
            else
                romhackText = string_without_hex(romhackInfo)
            end
        end
    end
end

-- Round Start
local function start_var()
    if call_pause_exit_hooks(false) then
        if network_is_server() then
            if gGlobalSyncTable.roundState ~= ROUND_STATE_ACTIVE then
                var()
            end
        else
            play_sound(SOUND_MENU_CAMERA_BUZZ, zero)
        end
    end
end

-- Reset Round
local function reset_var()
    if call_pause_exit_hooks(false) then
        if network_is_server() then
            if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
                var_close()
                network_send(true, { restart = true })
                level_restart()
            end
        else
            play_sound(SOUND_MENU_CAMERA_BUZZ, zero)
        end
    end
end

-- End Round
local function stop_var()
    if call_pause_exit_hooks(false) then
        if network_is_server()
        or network_is_moderator() then
            if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
                var_close()
                end_var()
            end
        else
            play_sound(SOUND_MENU_CAMERA_BUZZ, zero)
        end
    end
end

-- Skip Round
local function skip_var()
    if call_pause_exit_hooks(false) then
        if network_is_server() then
            round_skip()
        else
            play_sound(SOUND_MENU_CAMERA_BUZZ, zero)
        end
    end
end

local function close_var()
    if call_pause_exit_hooks(false) then
        if network_is_server() then
            close_var()
        else
            play_sound(SOUND_MENU_CAMERA_BUZZ, zero)
        end
    end
end


local function menu_var()
    if call_pause_exit_hooks(false) then
        var_close()
        showSettings = not showSettings
        if true then return true end
    else
        play_sound(SOUND_MENU_CAMERA_BUZZ, zero)
    end
end

local function coop_var()
    if call_pause_exit_hooks(false) then
        var_close()
        play_sound(SOUND_MENU_CAMERA_BUZZ, zero)
        djui_open_pause_menu()
    end
end

local pauseMenuLevelOptions = {
    {name = "Continue"      , func = var_close},
}

local function open_cs()
    _G.charSelect.set_menu_open(true)
    var_close()
end

local function render_options(options, screenHeight, screenWidth, optionPosY)
    local arrowUp = ""
    local arrowDown = ""
    if #options > 4 then
        if selectedOption > 4 then
            arrowUp = "^"
        end
        if selectedOption <= #options - 1 then
            arrowDown = "v"
        end
    end

    local startOptionIndex = math.max(selectedOption - 3, 1)
    local endOptionIndex = math.min(startOptionIndex + 3, #options)

    for i = startOptionIndex, endOptionIndex do
        local option = options[i]
        local optionNameLength = djui_hud_measure_text(option.name)
        local optionPosX = screenWidth * 0.5 - optionNameLength * 0.5

        djui_hud_set_color(0, 0, 0, 128)
        djui_hud_print_text(option.name, optionPosX + 1, optionPosY + 1, 1)
        djui_hud_set_color(255, 255, 255, 255)

        if i == selectedOption then
            djui_hud_set_color(0, 0, 0, 128)
            djui_hud_print_text(">", optionPosX - 15, optionPosY + 1, 1)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(">", optionPosX - 16, optionPosY, 1)
        end

        djui_hud_print_text(option.name, optionPosX, optionPosY, 1)
        optionPosY = optionPosY + 20
    end

    local arrowUpPosY = screenHeight * 0.55 - 10
    local arrowDownPosY = screenHeight - 30
    local arrowDownPosX = screenWidth * 0.5 - djui_hud_measure_text(arrowDown) * 0.5
    local arrowUpPosX = screenWidth * 0.5 - djui_hud_measure_text(arrowUp) * 0.5

    if arrowUp ~= "" then
        djui_hud_print_text(arrowUp, arrowUpPosX, arrowUpPosY, 1)
    end
    if arrowDown ~= "" then
        djui_hud_print_text(arrowDown, arrowDownPosX, arrowDownPosY, 1)
    end
end

local function render_text(text)
    for _, data in ipairs(text) do
        djui_hud_set_font(data.font)
        djui_hud_set_color(0, 0, 0, 128)
        djui_hud_print_text(data.text, data.posX + 1, data.posY + 1, 1)
        if data.color then
            djui_hud_set_color(data.color.r, data.color.g, data.color.b, data.color.a)
        else
            djui_hud_set_color(255, 255, 255, 255)
        end
        djui_hud_print_text(data.text, data.posX, data.posY, 1)
    end
end

local function hud_render()
    if not isPaused then return end

    if network_is_server() or network_is_moderator() then
        local specialOptionsExist = true
        for _, option in ipairs(pauseMenuLevelOptions) do
            if option.name == "Round Start"
            or option.name == "Round Reset"
            or option.name == "Round End" then
                specialOptionsExist = false
                break
            end
        end
        if specialOptionsExist then
            table.insert(pauseMenuLevelOptions, {name = "Round Start", func = start_var})
            table.insert(pauseMenuLevelOptions, {name = "Round Reset", func = reset_var})
            table.insert(pauseMenuLevelOptions, {name = "Round Skip" , func = skip_var})
            table.insert(pauseMenuLevelOptions, {name = "Round End"  , func = stop_var})
        end
    end

    local normalOptionsExist = true
    for _, option in ipairs(pauseMenuLevelOptions) do
        if option.name == "Coop Settings"
        or option.name == "Flood Menu" then
            normalOptionsExist = false
            break
        end
    end
    if normalOptionsExist then
        table.insert(pauseMenuLevelOptions, {name = "Coop Settings", func = coop_var})
        table.insert(pauseMenuLevelOptions, {name = "Flood Menu", func = menu_var})
    end

    -- Character Select Support
    if _G.charSelectExists then
        local csOptionExists = false
        for _, option in ipairs(pauseMenuLevelOptions) do
            if option.name == "CS Menu" then
                csOptionExists = true
                break
            end
        end
        if not csOptionExists then
            table.insert(pauseMenuLevelOptions, {name = "CS Menu", func = open_cs})
        end

        if isPaused and _G.charSelect.is_menu_open() then
            var_close()
        end
    end

    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_font(FONT_TINY)
    local theme = get_selected_theme()
    local screenHeight = djui_hud_get_screen_height()
    local screenWidth = djui_hud_get_screen_width()
    local optionPosY = screenHeight * 0.55
	
	djui_hud_set_color(303, 0, 33, 84)
    djui_hud_render_rect(0, 0, screenWidth + 20, screenHeight)
    djui_hud_set_color(255, 255, 255, 255)

    m.freeze = 1
    showSettings = false

    local textPositions = {
        { text = "PAUSE",     font = FONT_HUD,     posX = screenWidth * 0.5 -  djui_hud_measure_text("PAUSE"),        posY = optionPosY - 80 },
        { text = textlv1,     font = FONT_TINY,    posX = screenWidth * 0.5 -  djui_hud_measure_text(textlv1) * 0.5,  posY = optionPosY - 40 },
		{ text = gGlobalSyncTable.level .. "/" .. FLOOD_LEVEL_COUNT, font = FONT_TINY, posX = screenWidth * 0.5 - djui_hud_measure_text(gGlobalSyncTable.level .. "/" .. FLOOD_LEVEL_COUNT) * 0.5, posY = optionPosY + 90 },
		
	}
		

    render_text(textPositions)

    djui_hud_set_font(FONT_TINY)
    if (gLevelValues.pauseExitAnywhere or (gMarioStates[0].action & ACT_FLAG_PAUSE_EXIT) ~= 0) then
        menu_controls(pauseMenuLevelOptions)
        render_options(pauseMenuLevelOptions, screenHeight, screenWidth, optionPosY)
    end
end

local function pressed_pause()
    if get_dialog_id() >= 0 or (_G.charSelectExists and _G.charSelect.is_menu_open()) then
        return false
    end

    return gMarioStates[0].controller.buttonPressed & START_BUTTON ~= 0
end

function before_mario_update()
    local rTrigPressed = m.controller.buttonPressed & R_TRIG ~= 0

    if pressed_pause() then
        if not isPaused then
            isPaused = true
            selectedOption = 1
            m.controller.buttonPressed = 0
            play_sound(SOUND_MENU_PAUSE_HIGHPRIO, zero)
        else
            var_close()
        end
    elseif rTrigPressed and isPaused then
        djui_open_pause_menu()
        m.controller.buttonPressed = 0
        play_sound(SOUND_MENU_EXIT_A_SIGN, zero)
    end
end

real_hook_event(HOOK_ON_HUD_RENDER, hud_render)
real_hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)
real_hook_event(HOOK_ON_WARP, var_close)
real_hook_event(HOOK_ON_LEVEL_INIT, function () restartLevelArea = gNetworkPlayers[0].currAreaIndex var_close() end)
