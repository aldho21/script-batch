obs = obslua

servers = {
    "rtmps://a.rtmps.youtube.com/live2",
    "rtmps://b.rtmps.youtube.com/live2?backup=1",
    "rtmp://x.rtmp.youtube.com/live2"
}

stream_key = "INPUT_Your_StreamKeyHere"

current_index = 1
connected = false
was_user_stopped = false

function script_description()
    return "Streaming Failover ke beberapa RTMP/RTMPS server jika disconnect."
end

function on_event(event)
    if event == obs.OBS_FRONTEND_EVENT_STREAMING_STARTED then
        connected = true
        was_user_stopped = false
    elseif event == obs.OBS_FRONTEND_EVENT_STREAMING_STOPPING then
        -- Deteksi bahwa user menekan stop
        was_user_stopped = true
    elseif event == obs.OBS_FRONTEND_EVENT_STREAMING_STOPPED then
        if not was_user_stopped and connected and current_index < #servers then
            obs.timer_add(try_next_server, 2000)
        else
            print("[OBS LUA] Streaming dihentikan oleh user. Tidak mencoba failover.")
        end
    end
end

function try_next_server()
    current_index = current_index + 1
    local next_server = servers[current_index]

    if next_server == nil then
        print("[OBS LUA] Semua server gagal. Gagal total.")
        obs.timer_remove(try_next_server)
        return
    end

    print("[OBS LUA] Beralih ke server selanjutnya: " .. next_server)

    -- Note: ini hanya memberi notifikasi, karena kita tidak bisa ubah server secara langsung dari script Lua OBS
    print("⚠ Ganti manual ke: " .. next_server .. " dengan stream key yang sama.")

    -- Kalau ingin tetap start, bisa panggil start kembali
    -- Tapi idealnya user yang klik start setelah ubah setting

    obs.timer_remove(try_next_server)
end

obs.obs_frontend_add_event_callback(on_event)

