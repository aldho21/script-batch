@echo off
title Instal Aplikasi Favorit (EXE) + Winget Tools
chcp 65001 >nul

:MENU
cls
echo ================================
echo   INSTALLER APLIKASI (EXE)
echo ================================
echo  1. Google Chrome
echo  2. 7-Zip
echo  3. WinRAR
echo  4. VLC Media Player
echo  5. Notepad++
echo  6. Discord
echo  7. Steam
echo  8. OBS Studio
echo -------------------------------
echo  9. Install SEMUA di atas
echo -------------------------------
echo  S. Search aplikasi (winget)
echo  U. Update semua apps (winget)
echo  Q. Keluar
echo ================================
set "CHOICE="
set /p CHOICE= Pilih menu (1-9, S, U, Q) : 

if /I "%CHOICE%"=="1" goto CHROME
if /I "%CHOICE%"=="2" goto ZIP7
if /I "%CHOICE%"=="3" goto WINRAR
if /I "%CHOICE%"=="4" goto VLC
if /I "%CHOICE%"=="5" goto NPP
if /I "%CHOICE%"=="6" goto DISCORD
if /I "%CHOICE%"=="7" goto STEAM
if /I "%CHOICE%"=="8" goto OBS
if /I "%CHOICE%"=="9" goto ALL
if /I "%CHOICE%"=="S" goto SEARCH
if /I "%CHOICE%"=="U" goto UPDATE
if /I "%CHOICE%"=="Q" goto END

echo.
echo Pilihan tidak dikenal...
pause
goto MENU

:: =========================
:: FUNGSI UMUM DOWNLOAD+RUN
:: =========================
:DownloadAndRun
:: %1 = URL, %2 = nama file
set "DL_URL=%~1"
set "DL_FILE=%~2"

echo.
echo [*] Downloading %DL_FILE%
echo     Dari: %DL_URL%
powershell -Command "try { Invoke-WebRequest '%DL_URL%' -OutFile \"$env:TEMP\\%DL_FILE%\" -UseBasicParsing } catch { Write-Error $_; exit 1 }"

if errorlevel 1 (
    echo.
    echo [!] Gagal download %DL_FILE%
    echo     Cek koneksi internet / ganti URL di script.
    pause
    goto :EOF
)

echo.
echo [*] Menjalankan installer %DL_FILE%
start "" "%TEMP%\%DL_FILE%"

echo.
echo Setelah selesai instalasi, tekan tombol apa saja untuk kembali ke menu...
pause >nul
goto :EOF

:: =========================
::   MENU INSTALL PER APP
:: =========================

:CHROME
call :DownloadAndRun "https://dl.google.com/chrome/install/latest/chrome_installer.exe" "chrome_installer.exe"
goto MENU

:ZIP7
call :DownloadAndRun "https://www.7-zip.org/a/7z2501-x64.exe" "7zip_x64.exe"
goto MENU

:WINRAR
call :DownloadAndRun "https://www.rarlab.com/rar/winrar-x64-713.exe" "winrar_x64.exe"
goto MENU

:VLC
call :DownloadAndRun "https://get.videolan.org/vlc/3.0.21/win64/vlc-3.0.21-win64.exe" "vlc_win64.exe"
goto MENU

:NPP
call :DownloadAndRun "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.8.8/npp.8.8.8.Installer.x64.exe" "npp_8.8.8_x64.exe"
goto MENU

:DISCORD
:: Link resmi Discord untuk Windows; otomatis pilih versi stabil
call :DownloadAndRun "https://discord.com/api/download?platform=win" "DiscordSetup.exe"
goto MENU

:STEAM
call :DownloadAndRun "https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe" "SteamSetup.exe"
goto MENU

:OBS
call :DownloadAndRun "https://cdn-fastly.obsproject.com/downloads/OBS-Studio-32.0.2-Windows-x64-Installer.exe" "OBS-Studio-Installer.exe"
goto MENU

:ALL
echo.
echo === Install semua aplikasi (EXE) ===
echo Pastikan koneksi internet stabil.
pause

call :CHROME
call :ZIP7
call :WINRAR
call :VLC
call :NPP
call :DISCORD
call :STEAM
call :OBS

echo.
echo Selesai memanggil semua installer.
pause
goto MENU

:: =========================
::   FITUR WINGET
:: =========================

:SEARCH
cls
echo ====== PENCARIAN APLIKASI (WINGET) ======
echo Contoh: firefox, telegram, spotify, dll.
echo (kosongkan lalu Enter untuk kembali)
echo.
set "APP="
set /p APP=Nama / keyword aplikasi: 
if "%APP%"=="" goto MENU

echo.
echo [HASIL PENCARIAN]
echo ------------------------------------------
winget search "%APP%"
echo ------------------------------------------
echo.
echo Ambil kolom [Id] dari daftar di atas.
echo.

set "APPID="
set /p APPID=Masukkan Id untuk di-install (kosong = batal): 
if "%APPID%"=="" goto MENU

echo.
echo [INSTALL] %APPID%
winget install --id "%APPID%" --accept-package-agreements --accept-source-agreements
echo.
echo Selesai (kalau ada error, cek pesan di atas).
pause
goto MENU

:UPDATE
cls
echo ====== UPDATE APPS (WINGET) ======
echo Ini akan mencoba mengupdate semua aplikasi yang terdeteksi winget.
echo.
pause
winget upgrade --all
echo.
echo Selesai cek/update.
pause
goto MENU

:END
echo.
echo Keluar...
timeout /t 1 >nul
exit /b
