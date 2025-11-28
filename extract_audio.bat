@echo off
setlocal
title Extract Audio to WAV (Simple Loop, fixed rename)

:: --- Cek ffmpeg ---
where ffmpeg >nul 2>&1 || (
    echo [ERROR] ffmpeg tidak ditemukan di PATH.
    echo Taruh ffmpeg.exe di folder ini atau tambah ke PATH.
    echo Tekan tombol apapun untuk keluar...
    pause >nul
    exit /b
)

:LOOP
echo.
set "INFILE="
set /p INFILE=Masukkan path file video (kosong untuk keluar): 
if "%INFILE%"=="" goto :END

if not exist "%INFILE%" (
    echo [ERROR] File tidak ditemukan: "%INFILE%"
    goto :LOOP
)

:: --- Ambil nama dasar file ---
for %%I in ("%INFILE%") do set "BASE=%%~dpnI"

:: --- Output awal ---
set "OUT=%BASE%_audio.wav"

:: --- Jika sudah ada, tambahkan angka di belakang: _audio(1).wav, (2), ...
if exist "%OUT%" (
    set /a N=1
    :RENAME
    set "OUT=%BASE%_audio(%N%).wav"
    if exist "%OUT%" (
        set /a N+=1
        goto :RENAME
    )
)

echo.
echo [INFO] Sumber : "%INFILE%"
echo [INFO] Output : "%OUT%"
echo.

:: Ekstrak audio ke WAV (PCM 16-bit). Tampilkan progress (-stats).
ffmpeg -hide_banner -stats -y -i "%INFILE%" -vn -map 0:a:0 -c:a pcm_s16le "%OUT%"
if errorlevel 1 (
    echo [ERROR] Gagal mengekstrak audio.
) else (
    echo [OK] Audio tersimpan: "%OUT%"
)

echo.
choice /m "Proses file lain?"
if errorlevel 2 goto :END
goto :LOOP

:END
echo.
echo Selesai. Tekan tombol apapun untuk keluar...
pause >nul
endlocal
