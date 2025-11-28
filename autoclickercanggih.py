# auto_clicker_menu.py
import time
import threading
import random
import keyboard   # pip install keyboard (Windows biasanya butuh Run as Admin)
import pyautogui  # pip install pyautogui

running = False

# ======== Helper input dengan default & validasi ========

def ask_int(prompt, default=None, min_val=None, max_val=None):
    while True:
        s = input(f"{prompt} [{'Enter' if default is not None else ''} default={default}]: ").strip()
        if not s and default is not None:
            return default
        try:
            v = int(s)
            if (min_val is not None and v < min_val) or (max_val is not None and v > max_val):
                print(f"  ↳ Masukkan integer antara {min_val}–{max_val}.")
                continue
            return v
        except ValueError:
            print("  ↳ Harus angka bulat (integer).")

def ask_float(prompt, default=None, min_val=None, max_val=None):
    while True:
        s = input(f"{prompt} [{'Enter' if default is not None else ''} default={default}]: ").strip()
        if not s and default is not None:
            return float(default)
        try:
            v = float(s)
            if (min_val is not None and v < min_val) or (max_val is not None and v > max_val):
                print(f"  ↳ Masukkan angka antara {min_val}–{max_val}.")
                continue
            return v
        except ValueError:
            print("  ↳ Harus angka (boleh desimal).")

def ask_yesno(prompt, default=True):
    d = "Y/n" if default else "y/N"
    while True:
        s = input(f"{prompt} ({d}): ").strip().lower()
        if not s:
            return default
        if s in ["y", "yes", "ya"]:
            return True
        if s in ["n", "no", "tidak", "t"]:
            return False
        print("  ↳ Jawab y / n.")

# ======== Konfigurasi via menu ========

def configure():
    print("="*56)
    print(" Auto Clicker — Konfigurasi Cepat")
    print("="*56)

    # Range posisi
    x_min = ask_int("X minimum", default=2800)
    x_max = ask_int("X maximum", default=2800)
    if x_max < x_min:
        x_min, x_max = x_max, x_min

    y_min = ask_int("Y minimum", default=755)
    y_max = ask_int("Y maximum", default=755)
    if y_max < y_min:
        y_min, y_max = y_max, y_min

    # Interval acak
    interval_min = ask_float("Interval minimum (detik)", default=0.1, min_val=0.0)
    interval_max = ask_float("Interval maximum (detik)", default=0.3, min_val=interval_min)
    if interval_max < interval_min:
        interval_min, interval_max = interval_max, interval_min

    # Pause opsional
    enable_pause = ask_yesno("Aktifkan jeda berkala (pause) setelah sejumlah klik?", default=False)
    pause_after = None
    pause_duration = None
    if enable_pause:
        pause_after = ask_int("Jeda setelah berapa klik", default=10, min_val=1)
        pause_duration = ask_float("Durasi jeda (detik)", default=4.0, min_val=0.0)

    # Keypress '3' dua kali setiap N klik (0 = nonaktif)
    key_press_after = ask_int("Setiap berapa klik tekan tombol '3' 2x? (0=nonaktif)", default=1000, min_val=0)
    keypress_gap = 1.0
    if key_press_after > 0:
        keypress_gap = ask_float("Jeda antar tekan '3' (detik)", default=3.0, min_val=0.0)

    print("\nRingkasan pengaturan:")
    print(f"  X: {x_min}–{x_max}, Y: {y_min}–{y_max}")
    print(f"  Interval acak: {interval_min}–{interval_max} detik")
    if enable_pause:
        print(f"  Pause: setiap {pause_after} klik jeda {pause_duration}s")
    else:
        print("  Pause: nonaktif")
    if key_press_after > 0:
        print(f"  Keypress: angka '3' dua kali tiap {key_press_after} klik (jeda {keypress_gap}s)")
    else:
        print("  Keypress: nonaktif")
    print()
    return {
        "x_min": x_min, "x_max": x_max,
        "y_min": y_min, "y_max": y_max,
        "interval_min": interval_min, "interval_max": interval_max,
        "enable_pause": enable_pause,
        "pause_after": pause_after, "pause_duration": pause_duration,
        "key_press_after": key_press_after, "keypress_gap": keypress_gap
    }

# ======== Fitur utama ========

def press_key_sequence(keypress_gap):
    print("⌨️ Menekan tombol 3 dua kali...")
    keyboard.press_and_release('3')
    time.sleep(keypress_gap)
    keyboard.press_and_release('3')
    print("✅ Selesai tekan tombol 3 dua kali")

def make_click_loop(cfg):
    def click_loop():
        global running
        click_count = 0
        while running:
            x_rand = random.randint(cfg["x_min"], cfg["x_max"])
            y_rand = random.randint(cfg["y_min"], cfg["y_max"])
            interval = random.uniform(cfg["interval_min"], cfg["interval_max"])

            pyautogui.click(x_rand, y_rand)
            click_count += 1
            print(f"Klik ke-{click_count} di X={x_rand}, Y={y_rand} | jeda={interval:.3f}s")

            # Pause opsional
            if cfg["enable_pause"] and click_count % cfg["pause_after"] == 0:
                print(f"⏸️  Jeda {cfg['pause_duration']} detik setelah {click_count} klik...")
                time.sleep(cfg["pause_duration"])

            # Keypress setiap N klik
            if cfg["key_press_after"] > 0 and click_count % cfg["key_press_after"] == 0:
                press_key_sequence(cfg["keypress_gap"])

            time.sleep(interval)
    return click_loop

def toggle_clicker(click_loop):
    global running
    running = not running
    if running:
        threading.Thread(target=click_loop, daemon=True).start()
        print("Auto-clicker ON (F6=toggle, Esc=keluar)")
    else:
        print("Auto-clicker OFF")

# ======== Main ========

if __name__ == "__main__":
    cfg = configure()
    loop_fn = make_click_loop(cfg)
    print("Tekan F6 untuk Start/Stop | Esc untuk keluar")
    keyboard.add_hotkey('F6', lambda: toggle_clicker(loop_fn))
    keyboard.wait('esc')
