import keyboard
import time
import random

keys = ['3']  # daftar tombol yang akan ditekan

print("Script mulai dalam 5 detik...")
time.sleep(5)

try:
    while True:
        random.shuffle(keys)

        for key in keys:
            # tekan tombol pertama kali
            keyboard.press_and_release(key)
            print(f"Tombol {key} ditekan (1)")
            sleep_time = random.randint(60, 120)
            print(f"Jeda selama {sleep_time} detik...")
            time.sleep(sleep_time)

            # tekan tombol kedua kali
            keyboard.press_and_release(key)
            print(f"Tombol {key} ditekan (2)")
            sleep_time = random.randint(80, 180)
            print(f"Jeda selama {sleep_time} detik...")
            time.sleep(sleep_time)

except KeyboardInterrupt:
    print("\nScript dihentikan.")
