local function flood_colors()
    local water = obj_get_first_with_behavior_id(id_bhvWater)
    if gNetworkPlayers[0].currLevelNum == gLevels[gGlobalSyncTable.level].level and water ~= nil then
        djui_hud_set_resolution(RESOLUTION_DJUI)
        if gLakituState.pos.y < gGlobalSyncTable.waterLevel + 2 then
            switch(water.oAnimState, {
                [FLOOD_WATER] = function()
                    djui_hud_set_adjusted_color(0, 20, 200, 175)
                end,
                [FLOOD_LAVA] = function()
                    djui_hud_set_adjusted_color(200, 0, 0, 175)
                end,
                [FLOOD_SAND] = function()
                    djui_hud_set_adjusted_color(254, 193, 121, 230)
                end,
                [FLOOD_MUD] = function()
                    djui_hud_set_adjusted_color(128, 71, 34, 240)
                end,
                [FLOOD_SNOW] = function()
                    djui_hud_set_adjusted_color(255, 255, 255, 220)
                end,
                [FLOOD_WASTE] = function()
                    djui_hud_set_adjusted_color(74, 123, 0, 220)
                end,
                [FLOOD_DESERT] = function()
                    djui_hud_set_adjusted_color(254, 193, 121, 230)
                end,
                [FLOOD_ACID] = function()
                    djui_hud_set_adjusted_color(0, 142, 36, 190)
                end,
                [FLOOD_POISON] = function()
                    djui_hud_set_adjusted_color(174, 0, 255, 190)
                end,
                [FLOOD_SUNSET] = function()
                    djui_hud_set_adjusted_color(235, 164, 0, 200)
                end,
                [FLOOD_FROSTBITE] = function()
                    djui_hud_set_adjusted_color(126, 197, 249, 200)
                end,
                [FLOOD_CLOUDS] = function()
                    djui_hud_set_adjusted_color(255, 255, 255, 200)
                end,
                [FLOOD_RAINBOW] = function()
                    djui_hud_set_adjusted_color(244, 140, 253, 230)
                end,
                [FLOOD_DARKNESS] = function()
                    djui_hud_set_adjusted_color(0, 0, 0, 200)
                end,
                [FLOOD_MAGMA] = function()
                    djui_hud_set_adjusted_color(237, 0, 0, 220)
                end,
                [FLOOD_SULFUR] = function()
                    djui_hud_set_adjusted_color(0, 20, 167, 220)
                end,
                [FLOOD_COTTON] = function()
                    djui_hud_set_adjusted_color(255, 181, 225, 220)
                end,
                [FLOOD_MOLTEN] = function()
                    djui_hud_set_adjusted_color(225, 106, 19, 220)
                end,
                [FLOOD_OIL] = function()
                    djui_hud_set_adjusted_color(0, 0, 0, 200)
                end,
                [FLOOD_MATRIX] = function()
                    djui_hud_set_adjusted_color(16, 71, 0, 200)
                end,
                [FLOOD_BUP] = function()
                    djui_hud_set_adjusted_color(254, 193, 121, 200)
                end,
                [FLOOD_TIDE] = function()
                    djui_hud_set_adjusted_color(15, 122, 211, 200)
                end,
                [FLOOD_DARKTIDE] = function()
                    djui_hud_set_adjusted_color(15, 75, 124, 200)
                end,
                [FLOOD_VOLCANO] = function()
                    djui_hud_set_adjusted_color(252, 30, 30, 200)
                end,
                [FLOOD_REDTIDE] = function()
                    djui_hud_set_adjusted_color(211, 12, 35, 200)
                end,
                [FLOOD_OPTIC] = function()
                    djui_hud_set_adjusted_color(146, 0, 132, 200)
                end,
            })
            djui_hud_render_rect(0, 0, djui_hud_get_screen_width(), djui_hud_get_screen_height())
            set_lighting_dir(1,128)
        else
            set_lighting_dir(1,0)
        end
    end
end 
hook_event(HOOK_ON_HUD_RENDER, flood_colors)
