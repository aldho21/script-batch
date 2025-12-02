@echo off
title Instal Aplikasi Favorit (EXE) + Winget Tools - 64-bit
chcp 65001 >nul

:MENU
cls
echo ================================
echo   INSTALLER APLIKASI (EXE)
echo ================================
echo  1. Google Chrome
echo  2. 7-Zip (64-bit)
echo  3. WinRAR (64-bit)
echo  4. VLC Media Player (64-bit)
echo  5. Notepad++ (64-bit)
echo  6. Discord (64-bit)
echo  7. Steam (64-bit)
echo  8. OBS Studio (64-bit)
echo -------------------------------
echo  9. Install SEMUA di atas
echo -------------------------------
echo  S. Search aplikasi (winget, paksa x64)
echo  U. Update semua apps (winget)
echo  Q. Keluar
echo ================================
set "CHOICE="
set /p CHOICE= Pilih menu (1-9, S, U, Q) : 

if /I "%CHOICE%"=="1"  call :CHROME   & goto MENU
if /I "%CHOICE%"=="2"  call :ZIP7     & goto MENU
if /I "%CHOICE%"=="3"  call :WINRAR   & goto MENU
if /I "%CHOICE%"=="4"  call :VLC      & goto MENU
if /I "%CHOICE%"=="5"  call :NPP      & goto MENU
if /I "%CHOICE%"=="6"  call :DISCORD  & goto MENU
if /I "%CHOICE%"=="7"  call :STEAM    & goto MENU
if /I "%CHOICE%"=="8"  call :OBS      & goto MENU
if /I "%CHOICE%"=="9"  goto ALL
if /I "%CHOICE%"=="S"  goto SEARCH
if /I "%CHOICE%"=="U"  goto UPDATE
if /I "%CHOICE%"=="Q"  goto END

echo.
echo Pilihan tidak dikenal...
pause
goto MENU


:: =========================
:: FUNGSI UMUM DOWNLOAD+RUN
:: =========================
:DownloadAndRun
set "DL_URL=%~1"
set "DL_FILE=%~2"

echo.
echo [*] Downloading %DL_FILE%
echo     Dari: %DL_URL%
powershell -Command "try { Invoke-WebRequest '%DL_URL%' -OutFile \"$env:TEMP\\%DL_FILE%\" -UseBasicParsing } catch { Write-Error $_; exit 1 }"

if errorlevel 1 (
    echo.
    echo [!] Gagal download %DL_FILE%
    pause
    goto :EOF
)

echo.
echo [*] Menjalankan installer %DL_FILE%
start "" "%TEMP%\%DL_FILE%"

echo.
echo Setelah selesai instalasi, tekan tombol apa saja...
pause >nul
goto :EOF


:: =========================
::  INSTALL APP (64-bit)
:: =========================

:CHROME
:: **Kembali ke link original kamu**
call :DownloadAndRun "https://dl.google.com/chrome/install/latest/chrome_installer.exe" "chrome_installer.exe"
goto :EOF

:ZIP7
call :DownloadAndRun "https://www.7-zip.org/a/7z2501-x64.exe" "7zip_x64.exe"
goto :EOF

:WINRAR
call :DownloadAndRun "https://www.rarlab.com/rar/winrar-x64-713.exe" "winrar_x64.exe"
goto :EOF

:VLC
call :DownloadAndRun "https://get.videolan.org/vlc/3.0.21/win64/vlc-3.0.21-win64.exe" "vlc_win64.exe"
goto :EOF

:NPP
call :DownloadAndRun "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.8.8/npp.8.8.8.Installer.x64.exe" "npp_x64.exe"
goto :EOF

:DISCORD
call :DownloadAndRun "https://dl.discordapp.net/distro/app/stable/win/x64/DiscordSetup.exe" "DiscordSetup_x64.exe"
goto :EOF

:STEAM
call :DownloadAndRun "https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe" "SteamSetup.exe"
goto :EOF

:OBS
call :DownloadAndRun "https://cdn-fastly.obsproject.com/downloads/OBS-Studio-32.0.2-Windows-x64-Installer.exe" "OBS-Studio-x64.exe"
goto :EOF


:ALL
echo.
echo === Install semua aplikasi (64-bit) ===
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
echo Selesai.
pause
goto MENU


:: =========================
::   WINGET (PAKSA 64-bit)
:: =========================

:SEARCH
cls
echo ====== PENCARIAN APLIKASI (WINGET - FORCE x64) ======
echo.
set /p APP=Nama aplikasi: 
if "%APP%"=="" goto MENU

echo.
winget search "%APP%"
echo.
set /p APPID=Masukkan Id untuk di-install (kosong = batal): 
if "%APPID%"=="" goto MENU

echo.
echo [INSTALL 64-bit] %APPID%
echo (akan error jika paket tidak punya versi x64)
winget install --id "%APPID%" --architecture x64 --accept-package-agreements --accept-source-agreements

pause
goto MENU


:UPDATE
cls
winget upgrade --all
pause
goto MENU


:END
exit /b
