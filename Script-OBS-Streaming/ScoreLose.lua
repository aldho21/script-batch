local obs = obslua  -- Wajib: alias untuk OBS API

score = 0
source_name = "ScoreLose"  -- Ganti ini dengan nama Text (GDI+) kamu

function update_text()
    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", "L: " .. tostring(score))
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    end
end

function increase_scorelose(pressed)
    if not pressed then return end
    score = score + 1
    update_text()
end

function decrease_scorelose(pressed)
    if not pressed then return end
    score = score - 1
    update_text()
end

function reset_scorelose(pressed)
    if not pressed then return end
    score = 0
    update_text()
end

function script_description()
    return "Script untuk update skor otomatis:\n- Ctrl+Alt+1: +1\n- Ctrl+Alt+2: -1\n- Ctrl+Alt+0: Reset"
end

hotkey_increase = nil
hotkey_decrease = nil
hotkey_reset = nil

function script_load(settings)
    -- Increase
    hotkey_increase = obs.obs_hotkey_register_frontend("increase_scorelose", "Increase Scorelose", increase_scorelose)
    local hk_increase_array = obs.obs_data_get_array(settings, "hotkey_increase")
    obs.obs_hotkey_load(hotkey_increase, hk_increase_array)
    obs.obs_data_array_release(hk_increase_array)

    -- Decrease
    hotkey_decrease = obs.obs_hotkey_register_frontend("decrease_scorelose", "Decrease Scorelose", decrease_scorelose)
    local hk_decrease_array = obs.obs_data_get_array(settings, "hotkey_decrease")
    obs.obs_hotkey_load(hotkey_decrease, hk_decrease_array)
    obs.obs_data_array_release(hk_decrease_array)

    -- Reset
    hotkey_reset = obs.obs_hotkey_register_frontend("reset_scorelose", "Reset Scorelose", reset_scorelose)
    local hk_reset_array = obs.obs_data_get_array(settings, "hotkey_reset")
    obs.obs_hotkey_load(hotkey_reset, hk_reset_array)
    obs.obs_data_array_release(hk_reset_array)
end

function script_save(settings)
    local hk_increase_array = obs.obs_hotkey_save(hotkey_increase)
    obs.obs_data_set_array(settings, "hotkey_increase", hk_increase_array)
    obs.obs_data_array_release(hk_increase_array)

    local hk_decrease_array = obs.obs_hotkey_save(hotkey_decrease)
    obs.obs_data_set_array(settings, "hotkey_decrease", hk_decrease_array)
    obs.obs_data_array_release(hk_decrease_array)

    local hk_reset_array = obs.obs_hotkey_save(hotkey_reset)
    obs.obs_data_set_array(settings, "hotkey_reset", hk_reset_array)
    obs.obs_data_array_release(hk_reset_array)
end
