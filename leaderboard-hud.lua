-- エリック
if unsupported then return end

local function hud_render()
if not eFloodVariables.hudHide then
    -- ensure round state is set to round active or end
    if  gGlobalSyncTable.roundState ~= ROUND_STATE_ACTIVE
    and gGlobalSyncTable.roundState ~= ROUND_STATE_END then return end

    -- set font and res
    djui_hud_set_font(FONT_NORMAL)
    djui_hud_set_resolution(RESOLUTION_DJUI)

    -- get screen height
    local screenHeight = djui_hud_get_screen_height()

    -- get width of rect
    local width = 300

    -- get initial height for rect
    -- this includes survivor text
    local height = 60

    survivors = {}

    -- loop thru all survivors
    for i = 0, MAX_PLAYERS - 1 do
        local np = gNetworkPlayers[i]
        local s = gPlayerSyncTable[i]
        local m = gMarioStates[i]

        if np.connected and m.health > 0xFF and (s.finished
        or gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE) then
            -- add survivor to table
            table.insert(survivors, i)
        end
    end

    if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
        -- sort survivers via time if the player's finished
        -- otherwise use the distance to the flag
        table.sort(survivors, function (a, b)
            if gPlayerSyncTable[a].finished
            or gPlayerSyncTable[b].finished then
                return gPlayerSyncTable[a].time < gPlayerSyncTable[b].time
            else
                local aO = gMarioStates[a].marioObj
                local bO = gMarioStates[b].marioObj

                local pos = gLevels[gGlobalSyncTable.level].goalPos

                return dist_between_object_and_point(aO, pos.x, pos.y, pos.z) < dist_between_object_and_point(bO, pos.x, pos.y, pos.z)
            end
        end)
    else
        -- sort survivers via time
        table.sort(survivors, function (a, b)
            return gPlayerSyncTable[a].time < gPlayerSyncTable[b].time
        end)
    end

    if #survivors < 1 then
        -- if there are no survivors, increase height by 25
        height = height + 30
    else
        -- give each survivor 35 pixels of play room plus 25 for padding at bottom
        height = height + (#survivors - 1) * 35 + 25
    end

    -- get x and y for rect
    local x = 0
    local y = screenHeight / 2 - height / 2

    -- render rect
    djui_hud_set_color(0, 0, 0, 200)
    djui_hud_render_rect(x, y, width + 90, height)

    -- Ajust x & y again
    x = 5
    y = y + 5

    -- Calculate Text
    local text = "Survivors"
    local textWidth = djui_hud_measure_text(text)

    -- Calculate position
    local rectWidth = width + 90
    local textX = x + (rectWidth / 2) - (textWidth / 2)

    -- Render Text
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text(text, textX - 10, y, 1)

    local position = 1

    if #survivors > 0 then
        -- render players text
        for s = 1, #survivors do -- survivors is a table that starts at 1

            local i = survivors[s]
            -- offset y
            y = y + 35
            -- reset x
            x = 5
            -- render player position
            local positionText = "#" .. position
            local positionColor = { r = 0, g = 0, b = 0 }
            if position == 1 then
                positionColor.r = 255
                positionColor.g = 215
                positionColor.b = 0
            elseif position == 2 then
                positionColor.r = 170
                positionColor.g = 170
                positionColor.b = 170
            elseif position == 3 then
                positionColor.r = 205
                positionColor.g = 127
                positionColor.b = 50
            else
                positionColor.r = 220
                positionColor.g = 220
                positionColor.b = 220
            end
            djui_hud_set_color(positionColor.r, positionColor.g, positionColor.b, 255)
            djui_hud_print_text(positionText, x, y, 1)
            -- get player color
            local r, g, b = hex_to_rgb(network_get_player_text_color_string(i))
            djui_hud_set_color(r, g, b, 255)
            -- get player name
            local name = string_without_hex(gNetworkPlayers[i].name)
            -- offset x
            x = djui_hud_measure_text(positionText) + 10
            -- render text
            djui_hud_print_text(name, 40, y, 1)
            -- get dist between mario and flag
            -- if the round state is set to round active
            if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
                local pos = gLevels[gGlobalSyncTable.level].goalPos
                -- get dist between objects
                local dist = math.floor(dist_between_object_and_point(gMarioStates[i].marioObj, pos.x, pos.y, pos.z) / 100)
                -- get distance text
                local distText = tostring(dist)
                -- if we finished, set dist text to finished
                if gPlayerSyncTable[i].finished then
                    distText = "!GG!"
                end
                -- offset x
                x = djui_hud_measure_text(positionText .. name) + 25
                -- set color
                djui_hud_set_color(positionColor.r, positionColor.g, positionColor.b, 255)
                -- render text

                djui_hud_print_text(distText, 335, y, 1)
            end

            -- increase position
            position = position + 1
        end
    end

    -- if we didn't render a player...
    if position == 1 then
        -- offset y
        y = y + 35

        local text = "None"
        local textWidth = djui_hud_measure_text(text)
        local rectWidth = width + 90

        -- None
        local textX = x + (rectWidth / 2) - (textWidth / 2)

        -- render text
        djui_hud_set_color(255, 0, 0, 255)
        djui_hud_print_text(text, textX - 10, y, 1)
    end
end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)