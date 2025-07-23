-- Full credit goes to EmeraldLockdown for this theme system found in Tag
-- エリック

---@param r integer|number
---@param g integer|number
---@param b integer|number
local function color(r, g, b, a)
    if not a then a = 255 end
    return { r = r, g = g, b = b, a = a }
end

floodThemes = {
    {
        background = color(30, 0, 0),
        rect = color(0, 0, 0), 
        hoverRect = color(60, 10, 10),
        text = color(175, 175, 175),
        selectedText = color(240, 240, 240),
        disabledText = color(150, 150, 150),
    },
}

local latestThemeVersion = "v1.0"

local themeFormats = {
    ["v1.0"] = {
        "background",
        "rect",
        "hoverRect",
        "text",
        "selectedText",
        "disabledText",
    },
}

function validate_theme()
    if floodThemes[selectedTheme] == nil then
        if floodThemes[selectedTheme] == nil then
            selectedTheme = 1
        end
    end
end