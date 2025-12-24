local function hud_render()
    if not eFloodVariables.hudHide then
        if gGlobalSyncTable.roundState ~= ROUND_STATE_ACTIVE
        and gGlobalSyncTable.roundState ~= ROUND_STATE_END then return end

        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_resolution(RESOLUTION_DJUI)
        local screenHeight = djui_hud_get_screen_height()
        local width = 300 + 90
        local height = 60

        survivors = {}

        for i = 0, MAX_PLAYERS - 1 do
            local np = gNetworkPlayers[i]
            local s = gPlayerSyncTable[i]
            if np.connected and (s.finished or gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE or gGlobalSyncTable.roundState == ROUND_STATE_END) then
                table.insert(survivors, i)
            end
        end

        -- Ordenamiento
        table.sort(survivors, function (a, b)
            local aDead = gMarioStates[a].health <= 0xFF
            local bDead = gMarioStates[b].health <= 0xFF
            if aDead ~= bDead then return bDead end
            if gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
                if gPlayerSyncTable[a].finished or gPlayerSyncTable[b].finished then
                    return gPlayerSyncTable[a].time < gPlayerSyncTable[b].time
                else
                    local aO = gMarioStates[a].marioObj
                    local bO = gMarioStates[b].marioObj
                    local pos = gLevels[gGlobalSyncTable.level].goalPos
                    return dist_between_object_and_point(aO, pos.x, pos.y, pos.z) < dist_between_object_and_point(bO, pos.x, pos.y, pos.z)
                end
            else
                return gPlayerSyncTable[a].time < gPlayerSyncTable[b].time
            end
        end)

        if #survivors < 1 then height = height + 30 else height = height + (#survivors - 1) * 35 + 25 end

        local x = 0
        local y = screenHeight / 2 - height / 2

		local x = 0
        local y = screenHeight / 2 - height / 2

        djui_hud_set_color(303, 0, 33, 84)
        djui_hud_render_rect(x, y, width, height)

        x = 5
        y = y + 5
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Survivors:", x + (width / 2) - (djui_hud_measure_text("Survivors:") / 2) - 10, y, 1)

        local position = 1
        for s = 1, #survivors do
            local i = survivors[s]
            local m = gMarioStates[i]
            local sTable = gPlayerSyncTable[i]
            y = y + 35
            
            local isDead = m.health <= 0xFF
            local isFinished = sTable.finished
            local roundEnded = (gGlobalSyncTable.roundState == ROUND_STATE_END)
            
            local posColor = {r=220, g=220, b=220}

            -- Nombre
            local r, g, b = hex_to_rgb(network_get_player_text_color_string(i))
            if isDead then djui_hud_set_color(150, 150, 150, 255) else djui_hud_set_color(r, g, b, 255) end
            djui_hud_print_text(string_without_hex(gNetworkPlayers[i].name), 10, y, 1) -- Jugadores

            -- Status
            local statusText = "None"
            local statusColor = {r=255, g=0, b=0}
            
            if isDead then
                statusText = "Dead"
				statusColor = {r=255, g=0, b=0}
            elseif isFinished then
                statusText = "!Finished!"
                statusColor = {r=255, g=245, b=0}
            elseif gGlobalSyncTable.roundState == ROUND_STATE_ACTIVE then
                local pos = gLevels[gGlobalSyncTable.level].goalPos
                statusText = tostring(math.floor(dist_between_object_and_point(m.marioObj, pos.x, pos.y, pos.z) / 100))
                statusColor = {r=255, g=255, b=255}
            end
            
            djui_hud_set_color(statusColor.r, statusColor.g, statusColor.b, 255)
            djui_hud_print_text(statusText, 290, y, 1) -- Rango de la bandera
        end
    end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)