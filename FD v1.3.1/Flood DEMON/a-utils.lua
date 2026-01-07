local math_floor,is_player_active,table_insert,is_game_paused,djui_hud_set_color = math.floor,is_player_active,table.insert,is_game_paused,djui_hud_set_color

moveset = false
cheats = false

for mod in pairs(gActiveMods) do
    if gActiveMods[mod].name:find("Object Spawner") or gActiveMods[mod].name:find("Noclip") or gActiveMods[mod].name:find("Cheats") then
        cheats = true
    end
end

for i in pairs(gActiveMods) do
    if (gActiveMods[i].incompatible ~= nil and gActiveMods[i].incompatible:find("moveset")) or gActiveMods[i].name:find("Squishy's Server") or (gActiveMods[i].name:find("Pasta") and gActiveMods[i].name:find("Castle")) then
        moveset = true
    end
end

function table.copy(orig)
    local copy
    if type(orig) == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function hex_valid(hex)
	-- remove the # and the \\ from the hex so that we can check it properly
	hex = hex:gsub('#','')
	hex = hex:gsub('\\','')
	for i = 0, 2 do
		local hexCode = "0x" .. hex:sub(i * 2 + 1, i * 2 + 2)
		if tonumber(hexCode) == nil then return false end
	end
	return true
end

rom_hack_cam_set_collisions(false)

--- @param x number
--- @return integer
function math_round(x)
    return if_then_else(x - math.floor(x) >= 0.5, math.ceil(x), math.floor(x))
end

function rgb_to_hex(r, g, b)
	return string.format("#%02X%02X%02X", r, g, b)
end

function tobool(v)
    local type = type(v)
    if type == "boolean" then
        return v
    elseif type == "number" then
        return v == 1
    elseif type == "string" then
        return v == "true"
    elseif type == "table" or type == "function" or type == "thread" or type == "userdata" then
        return true
    end
    return false
end

function name_of_level(level, area, name, levelTable)
	if levelTable ~= nil then
		if levelTable.levelName ~= nil then
			return levelTable.levelName
		end
	end

	for _, lvl in pairs(gLevels) do
		if lvl.level == level
		and lvl.area == area
        and lvl.codeName == name then
			-- search for an override name
			if lvl.levelName ~= nil then return lvl.levelName end
		end
	end

	return get_level_name(level_to_course(level), level, area)
end

function switch(param, case_table)
    if not case_table then return nil end
    local case = case_table[param]
    if case then return case() end
    local def = case_table['default']
    return def and def() or nil
end

--- @param m MarioState
function active_player(m)
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex == 0 then
        return 1
    end
    if not np.connected then
        return 0
    end
    if np.currCourseNum ~= gNetworkPlayers[0].currCourseNum then
        return 0
    end
    if np.currActNum ~= gNetworkPlayers[0].currActNum then
        return 0
    end
    if np.currLevelNum ~= gNetworkPlayers[0].currLevelNum then
        return 0
    end
    if np.currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then
        return 0
    end
    return is_player_active(m)
end

function if_then_else(cond, if_true, if_false)
    if cond then return if_true end
    return if_false
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end

    return false
end

---@return integer|boolean
function table.poselement(table, element)
    for i, value in pairs(table) do
        if value == element then
            return i
        end
    end

    return false
end

function approach_number(current, target, inc, dec)
    if current < target then
        current = current + inc
        if current > target then
            current = target
        end
    else
        current = current - dec
        if current < target then
            current = target
        end
    end
    return current
end

function string_without_hex(name)
    local s = ''
    local inSlash = false
    for i = 1, #name do
        local c = name:sub(i,i)
        if c == '\\' then
            inSlash = not inSlash
        elseif not inSlash then
            s = s .. c
        end
    end
    return s
end

function on_or_off(value)
    if value then return "\\#00ff00\\ON" end
    return "\\#ff0000\\OFF"
end

function split(s)
    local result = {}
    for match in (s):gmatch(string.format("[^%s]+", " ")) do
        table.insert(result, match)
    end
    return result
end

function djui_hud_set_adjusted_color(r, g, b, a)
    local multiplier = 1
    if is_game_paused() then multiplier = 0.5 end
    djui_hud_set_color(r * multiplier, g * multiplier, b * multiplier, a)
end

function SEQUENCE_ARGS(priority, seqId)
    return ((priority << 8) | seqId)
end

--- @param m MarioState
function mario_set_full_health(m)
    m.health = 0x880
    m.healCounter = 0
    m.hurtCounter = 0
end

local levelToCourse = {
    [LEVEL_NONE] = COURSE_NONE,
    [LEVEL_BOB] = COURSE_BOB,
    [LEVEL_WF] = COURSE_WF,
    [LEVEL_JRB] = COURSE_JRB,
    [LEVEL_CCM] = COURSE_CCM,
    [LEVEL_BBH] = COURSE_BBH,
    [LEVEL_HMC] = COURSE_HMC,
    [LEVEL_LLL] = COURSE_LLL,
    [LEVEL_SSL] = COURSE_SSL,
    [LEVEL_DDD] = COURSE_DDD,
    [LEVEL_SL] = COURSE_SL,
    [LEVEL_WDW] = COURSE_WDW,
    [LEVEL_TTM] = COURSE_TTM,
    [LEVEL_THI] = COURSE_THI,
    [LEVEL_TTC] = COURSE_TTC,
    [LEVEL_RR] = COURSE_RR,
    [LEVEL_BITDW] = COURSE_BITDW,
    [LEVEL_BITFS] = COURSE_BITFS,
    [LEVEL_BITS] = COURSE_BITS,
	[LEVEL_BOWSER_1] = COURSE_NONE,
	[LEVEL_BOWSER_2] = COURSE_NONE,
	[LEVEL_BOWSER_3] = COURSE_NONE,
    [LEVEL_PSS] = COURSE_PSS,
    [LEVEL_CASTLE_COURTYARD] = COURSE_NONE,
    [LEVEL_CASTLE_GROUNDS] = COURSE_NONE,
    [LEVEL_CASTLE] = COURSE_NONE,
    [LEVEL_ENDING] = COURSE_CAKE_END,
    [LEVEL_COTMC] = COURSE_COTMC,
    [LEVEL_TOTWC] = COURSE_TOTWC,
    [LEVEL_VCUTM] = COURSE_VCUTM,
    [LEVEL_WMOTR] = COURSE_WMOTR,
    [LEVEL_SA] = COURSE_SA,
}

function level_to_course(level)
    return levelToCourse[level] or COURSE_NONE
end

function get_selected_theme()
    validate_theme()
	return floodThemes[selectedTheme]
end

function timestamp(seconds)
    seconds = seconds / 30
    local minutes = math.floor(seconds / 60)
    local milliseconds = math.floor((seconds - math.floor(seconds)) * 1000)
    seconds = math.floor(seconds) % 60
    return string.format("%d:%02d:%03d", minutes, seconds, milliseconds)
end

function nearest_living_mario_state_to_object(vec3f)
    if not vec3f then return end
    local nearest
    local nearestDist = 0;
    for i = 0, MAX_PLAYERS - 1 do
        if gMarioStates[i].marioObj and
        gMarioStates[i].action ~= ACT_SPECTATOR and
        gMarioStates[i].action ~= ACT_FOLLOW_SPECTATOR and
        is_player_active(gMarioStates[i]) ~= 0 then
            local dist = dist_between_object_and_point(gMarioStates[i].marioObj, vec3f.x, vec3f.y, vec3f.z)
            if (not nearest or (dist < nearestDist)) then
                nearest = gMarioStates[i]
                nearestDist = dist
            end
        end
    end

    return nearest
end

function hex_to_rgb(hex)
	hex = hex:gsub('#','')
	hex = hex:gsub('\\','')

	if string.len(hex) == 6 then
		return tonumber('0x'..hex:sub(1,2)), tonumber('0x'..hex:sub(3,4)), tonumber('0x'..hex:sub(5,6))
	else
		return 0, 0, 0
	end
end

local positionColors = {
    [1] = "\\#FFD700\\",
    [2] = "\\#AAAAAA\\",
    [3] = "\\#CD7F32\\",
    [4] = "\\#CDA726\\",
    [5] = "\\#CDA726\\",
    [6] = "\\#CDA726\\",
    [7] = "\\#CDA726\\",
    [8] = "\\#2B00A6\\",
    [9] = "\\#2B00A6\\",
    [10] = "\\#2B00A6\\",
    [11] = "\\#2B00A6\\",
    [12] = "\\#9B0F82\\",
    [13] = "\\#9B0F82\\",
    [14] = "\\#9B0F82\\",
    [15] = "\\#9B0F82\\",
    [16] = "\\#9B0F82\\",
}

function get_placement_text(position)
    if position == 1 then return position .. "st"
    elseif position == 2 then return position .. "nd"
    elseif position == 3 then return position .. "rd"
    else return position .. "th" end
end

function get_placement_text_colored(position)
    if position == 1 then return positionColors[position] .. position .. "st"
    elseif position == 2 then return positionColors[position] .. "\\#AAAAAA\\" .. position .. "nd"
    elseif position == 3 then return positionColors[position] .. "\\#CD7F32\\" .. position .. "rd"
    else return positionColors[position].. position .. "th" end
end

function get_placement_color(position)
    return positionColors[position]
end