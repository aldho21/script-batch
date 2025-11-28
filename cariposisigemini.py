from pynput.mouse import Controller

mouse = Controller()

# Dapatkan koordinat X dan Y
posisi_x, posisi_y = mouse.position

print(f"Posisi kursor saat ini: X={posisi_x}, Y={posisi_y}")
