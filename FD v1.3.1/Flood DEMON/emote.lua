gStateExtras = {}

for i = 0, (MAX_PLAYERS - 1) do
    gStateExtras[i] = {}
    local e = gStateExtras[i]

    e.emoteTimer = 0
end

emoteData = {
    [0]  = { anim = MARIO_ANIM_STAR_DANCE, sound = { id = SOUND_MENU_STAR_SOUND, frame = 36 }, charSound = { id = CHAR_SOUND_HERE_WE_GO, frame = 36 }, loopFunc = function (m) local e = gStateExtras[m.playerIndex] if e.emoteTimer == 8 then play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject) end if e.emoteTimer > 40 then m.marioBodyState.handState = MARIO_HAND_PEACE_SIGN else m.marioBodyState.handState = MARIO_HAND_FISTS end end },
    [1]  = { anim = MARIO_ANIM_CREDITS_WAVING, handState = MARIO_HAND_OPEN },
    [2]  = { anim = MARIO_ANIM_MISSING_CAP, eyeState = MARIO_EYES_HALF_CLOSED, handState = MARIO_HAND_OPEN, animStart = 110, animEnd = 40 },
    [3]  = { anim = MARIO_ANIM_START_SLEEP_SITTING, loopFunc = function (m) local e = gStateExtras[m.playerIndex] if e.emoteTimer > 26 then set_anim_to_frame(m, 26) end end },
    [4]  = { action = ACT_COUGHING },
    [5]  = { anim = MARIO_ANIM_CREDITS_PEACE_SIGN, loopFunc = function (m) local e = gStateExtras[m.playerIndex] if e.emoteTimer >= 95 then set_anim_to_frame(m, 95) m.marioBodyState.handState = MARIO_HAND_PEACE_SIGN end end },
    [6]  = { anim = MARIO_ANIM_CREDITS_RAISE_HAND },
    [7]  = { anim = MARIO_ANIM_REACH_POCKET },
    [8]  = { anim = MARIO_ANIM_UNLOCK_DOOR, loopFunc = function (m) local e = gStateExtras[m.playerIndex] if e.emoteTimer >= 54 then m.marioBodyState.eyeState = MARIO_EYES_LOOK_LEFT end if e.emoteTimer >= 63 then set_anim_to_frame(m, 63) end end },
    [9]  = { anim = MARIO_ANIM_GROUND_THROW, handState =  MARIO_HAND_OPEN, animEnd = 19 },
    [10] = { anim = MARIO_ANIM_DYING_ON_BACK, eyeState = MARIO_EYES_DEAD, charSound = { id = CHAR_SOUND_DYING, frame = 1 } },
    [11] = { anim = MARIO_ANIM_BREAKDANCE, charSound = { id = CHAR_SOUND_HERE_WE_GO, frame = 1 }, loopFunc = function (m) local e = gStateExtras[m.playerIndex] if e.emoteTimer > 14 then set_anim_to_frame(m, e.emoteTimer % 16) end if e.emoteTimer % 16 == 5 then play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject) end end },
    [12] = { anim = MARIO_ANIM_UNLOCK_DOOR, animStart = 64, loopFunc = function (m) local e = gStateExtras[m.playerIndex] if e.emoteTimer >= 68 then set_anim_to_frame(m, 72) e.emoteTimer = 10 end end },
    [13] = { anim = MARIO_ANIM_THROW_CATCH_KEY, eyeState = MARIO_EYES_CLOSED, loopFunc = function (m) local e = gStateExtras[m.playerIndex] if e.emoteTimer >= 26 then set_anim_to_frame(m, 20) e.emoteTimer = 15 end end },
    [14] = { anim = MARIO_ANIM_SUFFOCATING, loopFunc = function (m) local e = gStateExtras[m.playerIndex] if e.emoteTimer >= 59 then set_anim_to_frame(m, 52) e.emoteTimer = 52 end end },
    [15] = { anim = MARIO_ANIM_DYING_ON_STOMACH, eyeState = MARIO_EYES_DEAD, charSound = { id = CHAR_SOUND_DYING, frame = 1 } }
}

local emoteActions = {
    [ACT_IDLE] = true,
    [ACT_PANTING] = true,
    [ACT_COUGHING] = true
}

local normalDpadActions = {
    [L_JPAD] = 0,
    [R_JPAD] = 1,
    [U_JPAD] = 2,
    [D_JPAD] = 3,
}

local lDpadActions = {
    [L_JPAD] = 4,
    [R_JPAD] = 5,
    [U_JPAD] = 6,
    [D_JPAD] = 7
}

local xDpadActions = {
    [L_JPAD] = 8,
    [R_JPAD] = 9,
    [U_JPAD] = 10,
    [D_JPAD] = 11
}

local yDpadActions = {
    [L_JPAD] = 12,
    [R_JPAD] = 13,
    [U_JPAD] = 14,
    [D_JPAD] = 15
}

ACT_EMOTE = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_IDLE)

local function act_emote(m)
    local e = gStateExtras[m.playerIndex]

    if emoteData[m.actionArg].action ~= nil then
        set_mario_action(m, emoteData[m.actionArg].action, 0)
    end
    if emoteData[m.actionArg].anim ~= nil then
        set_mario_animation(m, emoteData[m.actionArg].anim)
    end
    if emoteData[m.actionArg] then
        if m.action == ACT_EMOTE then
            e.emoteTimer = e.emoteTimer + 1
            if emoteData[m.actionArg].eyeState then
                m.marioBodyState.eyeState = emoteData[m.actionArg].eyeState
            end
            if emoteData[m.actionArg].handState then
                m.marioBodyState.handState = emoteData[m.actionArg].handState
            end
            if emoteData[m.actionArg].sound then
                if e.emoteTimer == emoteData[m.actionArg].sound.frame then
                    play_sound(emoteData[m.actionArg].sound.id, m.pos)
                end
            end
            if emoteData[m.actionArg].charSound then
                if e.emoteTimer == emoteData[m.actionArg].charSound.frame then
                    play_character_sound(m, emoteData[m.actionArg].charSound.id)
                end
            end
            if emoteData[m.actionArg].animStart and e.emoteTimer <= 1 then
                set_anim_to_frame(m, emoteData[m.actionArg].animStart)
            end
            if emoteData[m.actionArg].animEnd and e.emoteTimer > emoteData[m.actionArg].animEnd then
                drop_and_set_mario_action(m, ACT_IDLE, 0)
            end
            if emoteData[m.actionArg].loopFunc then
                emoteData[m.actionArg].loopFunc(m)
            end
        end
    end
    stationary_ground_step(m)
    check_common_idle_cancels(m)
end

hook_mario_action(ACT_EMOTE, act_emote)

local function mario_update(m)
    local e = gStateExtras[m.playerIndex]
    if isPaused then return end
    if showSettings then return end

    if emoteActions[m.action] or m.action == ACT_EMOTE then
        for button, actionData in pairs(normalDpadActions) do
            if (m.controller.buttonPressed & button) ~= 0
            and (m.controller.buttonDown & L_TRIG) == 0
            and (m.controller.buttonDown & Y_BUTTON) == 0 then
                set_anim_to_frame(m, 0)
                set_mario_action(m, ACT_EMOTE, actionData)
            end
        end
        for button, actionData in pairs(lDpadActions) do
            if (m.controller.buttonPressed & button) ~= 0
            and (m.controller.buttonDown & L_TRIG) ~= 0 then
                set_anim_to_frame(m, 0)
                set_mario_action(m, ACT_EMOTE, actionData)
            end
        end
        for button, actionData in pairs(xDpadActions) do
            if (m.controller.buttonPressed & button) ~= 0
            and (m.controller.buttonDown & X_BUTTON) ~= 0 then
                set_anim_to_frame(m, 0)
                set_mario_action(m, ACT_EMOTE, actionData)
            end
        end
        for button, actionData in pairs(yDpadActions) do
            if (m.controller.buttonPressed & button) ~= 0
            and (m.controller.buttonDown & Y_BUTTON) ~= 0 then
                set_anim_to_frame(m, 0)
                set_mario_action(m, ACT_EMOTE, actionData)
            end
        end
    end
end

local function set_mario_action(m)
    local e = gStateExtras[m.playerIndex]

    if m.action == ACT_EMOTE or m.prevAction == ACT_EMOTE or m.action ~= ACT_EMOTE then
        e.emoteTimer = 0
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_SET_MARIO_ACTION, set_mario_action)