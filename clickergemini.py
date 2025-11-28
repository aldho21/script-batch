import time
import threading
from pynput.mouse import Button, Controller
# Import Key untuk menggunakan tombol F6 dan Esc
from pynput.keyboard import Listener, Key 

# --- Konfigurasi ---
delay = 0.1  # Jeda antara klik dalam detik
button = Button.left 

# === Tombol Pintasan (Hotkey) ===
start_stop_key = Key.f6
exit_key = Key.esc  # <--- Diubah dari KeyCode(char='b') menjadi Key.esc
# =================================

# === Koordinat Target X, Y ===
# Ganti nilai-nilai ini dengan koordinat yang Anda inginkan
TARGET_X = 900  
TARGET_Y = 722 
# ==============================
# --------------------

class AutoClicker(threading.Thread):
    def __init__(self, delay, button, x, y):
        super().__init__()
        self.delay = delay
        self.button = button
        self.target_x = x
        self.target_y = y
        self.clicking = False
        self.active = True

    def start_click(self):
        self.clicking = True

    def stop_click(self):
        self.clicking = False

    def exit(self):
        self.stop_click()
        self.active = False

    def run(self):
        mouse = Controller()
        while self.active:
            if self.clicking:
                # 1. Atur posisi kursor ke TARGET_X, TARGET_Y
                mouse.position = (self.target_x, self.target_y)
                
                # 2. Lakukan klik
                mouse.click(self.button)
                
                time.sleep(self.delay)
            # Jeda sebentar ketika klik dihentikan
            time.sleep(0.001) 

# Inisialisasi AutoClicker dengan koordinat target
click_thread = AutoClicker(delay, button, TARGET_X, TARGET_Y)

def on_press(key):
    """Fungsi yang dipanggil ketika tombol keyboard ditekan"""
    try:
        if key == start_stop_key:
            if click_thread.clicking:
                click_thread.stop_click()
                print("\r[INFO] Clicker Dihentikan.      ") 
            else:
                click_thread.start_click()
                print(f"\r[INFO] Clicker Dimulai. Mengklik pada X={TARGET_X}, Y={TARGET_Y}")
        elif key == exit_key: # <--- Perubahan di sini
            click_thread.exit()
            print("\r[INFO] Keluar dari program.")
            return False # Menghentikan listener keyboard
            
    except AttributeError:
        # Menangani tombol khusus seperti F6 atau Esc
        pass 

# --- Utama ---

print("=== Python Auto Clicker (Posisi Tetap) ===")
print(f"Posisi Klik: X={TARGET_X}, Y={TARGET_Y}")
print(f"Delay antar klik: {delay} detik")
print(f"Tombol Mulai/Stop: Tekan F6")
print(f"Tombol Keluar: Tekan ESC") # <--- Tampilan pesan diperbarui
print("-" * 30)
print("Tekan F6 untuk memulai...")

# Mulai thread klik
click_thread.start()

# Mulai listener keyboard, blokir program utama di sini
with Listener(on_press=on_press) as listener:
    listener.join()
