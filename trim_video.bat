@echo off
setlocal enabledelayedexpansion

:ulang
cls
echo ===============================
echo   TRIM VIDEO TANPA RE-ENCODE
echo ===============================
echo.

:: Minta input file video
set /p "input=Masukkan nama file video (contoh: video.mp4): "
if not exist "%input%" (
    echo File tidak ditemukan!
    pause
    goto ulang
)

:: Minta waktu mulai dan akhir
set /p "start=Masukkan waktu mulai (contoh: 00:01:23): "
set /p "end=Masukkan waktu akhir (contoh: 00:02:45): "

:: Ambil nama dasar dan ekstensi
for %%A in ("%input%") do (
    set "name=%%~nA"
    set "ext=%%~xA"
)

:: Buat nama output dasar
set "output=trimmed_!name!!ext!"

:: Cek duplikasi dan rename otomatis
set "count=1"
:checkloop
if exist "!output!" (
    set "output=trimmed_!name!_!count!!ext!"
    set /a count+=1
    goto checkloop
)

echo.
echo Memproses video...
ffmpeg -ss %start% -to %end% -i "%input%" -c copy "!output!" -avoid_negative_ts 1

echo.
echo Selesai! File tersimpan sebagai: !output!
echo.

:: Tanya mau lanjut
set /p "lagi=Apakah ingin trim video lain? (Y/N): "
if /i "!lagi!"=="Y" goto ulang

echo.
echo Terima kasih! Selesai.
pause
exit /b
