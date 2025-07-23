-- original code created by Gaming32, modified by Jzzay & Bear64DX

local MESSAGE_COLOR = "\\#dcdcdc\\"
local hasDied = false

---@type Object | nil
local hurtMario = nil

---@param np NetworkPlayer?
---@return string
local function get_display_name(np)
    if not np then np = gNetworkPlayers[0] end
    return network_get_player_text_color_string(np.localIndex) .. np.name .. MESSAGE_COLOR
end

---@param m MarioState
local function mario_update(m)
    if m.playerIndex ~= 0 then return end

    if m.health <= 0xFF and not hasDied then
        hasDied = true
        local message = "%s has died."
        if m.action == ACT_DROWNING then
            message = "%s drowned."
        elseif m.action == ACT_CAUGHT_IN_WHIRLPOOL then
            message = "%s was sucked into a whirlpool."
        elseif m.action == ACT_LAVA_BOOST then
            message = "%s lit their bum on fire."
        elseif m.action == ACT_QUICKSAND_DEATH then
            message = "%s drowned in sand."
        elseif m.action == ACT_EATEN_BY_BUBBA then
            message = "%s was eaten alive."
        elseif m.action == ACT_SQUISHED then
            message = "%s got squished inside a wall."
        elseif m.action == ACT_ELECTROCUTION then
            message = "%s felt the power."
        elseif m.action == ACT_SUFFOCATION then
            message = "%s was smoked out."
        elseif m.action == ACT_STANDING_DEATH then
            if m.prevAction == ACT_BURNING_GROUND then
                message = "%s burned to death."
            end
        elseif m.action == ACT_DEATH_ON_BACK or m.action == ACT_DEATH_ON_STOMACH then
            if hurtMario ~= nil then
                local behavior = get_id_from_behavior(hurtMario.behavior)
                local ememyName = ""
                if behavior == id_bhvMario then
                    ememyName = get_display_name(network_player_from_global_index(hurtMario.globalPlayerIndex))
                else
                    local objName = get_behavior_name_from_id(behavior)
                    for i = 4, #objName do
                        local c = objName:sub(i, i)
                        if (#ememyName > 0) and (c:upper() == c) then
                            ememyName = ememyName .. " "
                        end
                        ememyName = ememyName .. c
                    end
                end
                hurtMario = nil
                message = "%s was killed by " .. ememyName .. "."
            else
                message = "%s fell from a high place."
            end
        elseif m.floor.type == SURFACE_DEATH_PLANE and m.pos.y < m.floorHeight + 2048 then
            hasDied = true
            message = "%s fell out of " .. name_of_level(gLevels[gGlobalSyncTable.level].level, gLevels[gGlobalSyncTable.level].area, gLevels[gGlobalSyncTable.level].name, gLevels[gGlobalSyncTable.level]) .. "."
        end
        djui_popup_create_global(string.format(message, get_display_name()), 1)
    elseif m.health > 0xFF then
        hasDied = false
    end
end

---@param m MarioState
---@param o Object
local function on_interact(m, o)
    if m.playerIndex == 0 and o.oInteractStatus & INT_STATUS_ATTACKED_MARIO ~= 0 then
        hurtMario = o
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_INTERACT, on_interact)