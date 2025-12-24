local level_lighting = {
  [LEVEL_ZEROLIFE] = { dir = {125, 12}, color = {121, 121, 121} },
  [LEVEL_CASTLE_GROUNDS] = { dir = {125, 45}, color = {195, 195, 255} },
  [LEVEL_BOB] = { dir = {180, 0}, color = {255, 192, 192} },
  [LEVEL_WF] = { dir = {180, 0}, color = {225, 255, 255} },
  [LEVEL_CCM] = { dir = {125, 270}, color = {255, 255, 255} },
  [LEVEL_BBH] = { dir = {180, 0}, color = {215, 215, 255} },
  [LEVEL_BITDW] = { dir = {180, 0}, color = {154, 31, 143} }
}

local degrees_to_radians = function(degree)
  return degree / 180 * math.pi
end

local sideways_factor_func = function(degrees)
  local radians = degrees_to_radians(degrees)
  return math.abs(math.sin(radians))
end

local direction = function(sdir)
  local camera_angle = sm64_to_radians(calculate_yaw(gLakituState.curPos, gLakituState.curFocus))
  local s_factor = sideways_factor_func(sdir[1])
  
  local x_normal = math.cos(camera_angle + degrees_to_radians(sdir[2])) * s_factor
  local y_normal = -math.cos(degrees_to_radians(sdir[1]))
  local z_normal = math.sin(camera_angle + degrees_to_radians(sdir[2])) * s_factor
  
  set_lighting_dir(0, x_normal)
  set_lighting_dir(1, y_normal)
  set_lighting_dir(2, z_normal)
  return true
end

local color = function(scolor)
  for i = 0, #scolor - 1 do
    local value = scolor[i + 1]
    set_lighting_color(i, value)
    if set_vertex_color ~= nil then
        set_vertex_color(i, (value + 255) / 2)
    end
  end
  return true
end

local lighting_standard = function(level)
  local level_has_lighting = false
  if level_lighting[level] then
    local sdir = level_lighting[level].dir
    local scolor = level_lighting[level].color
    direction(sdir)
    color(scolor)
    level_has_lighting = true
  end
  
  if not level_has_lighting then
    set_lighting_dir(0, 1)
    set_lighting_dir(1, 1)
    set_lighting_dir(2, 0)
    set_lighting_color(0, 255)
    set_lighting_color(1, 255)
    set_lighting_color(2, 255)
    if set_vertex_color ~= nil then
        set_vertex_color(0, 255)
        set_vertex_color(1, 255)
        set_vertex_color(2, 255)
    end
  end
  return true
end

local update = function()
  local m = gMarioStates[0]
  if m == nil then return end
  
  if _G.visual_mod == nil or _G.visual_mod == false then
    lighting_standard(current_level)
  end
end

hook_event(HOOK_UPDATE, update)
