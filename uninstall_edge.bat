@echo off
title Uninstall Microsoft Edge - by Bojji
color 0A

:: Cek apakah dijalankan sebagai Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Jalankan script ini sebagai Administrator!
    echo Klik kanan pada file ini, lalu pilih "Run as administrator"
    pause
    exit /b 1
)

echo ============================================
echo   UNINSTALL MICROSOFT EDGE - WINDOWS 11
echo ============================================
echo.

:: =============================================
:: STEP 1: Cari versi Edge yang terinstall
:: =============================================
echo [1/6] Mencari versi Edge...
set EDGE_SETUP=
for /f "delims=" %%i in ('dir "C:\Program Files (x86)\Microsoft\Edge\Application" /b /ad 2^>nul') do (
    if exist "C:\Program Files (x86)\Microsoft\Edge\Application\%%i\Installer\setup.exe" (
        set EDGE_SETUP=C:\Program Files (x86)\Microsoft\Edge\Application\%%i\Installer\setup.exe
        set EDGE_VER=%%i
    )
)

if "%EDGE_SETUP%"=="" (
    echo [INFO] Edge tidak ditemukan atau sudah terhapus.
    goto :CLEANUP
)

echo [OK] Ditemukan Edge versi: %EDGE_VER%
echo.

:: =============================================
:: STEP 2: Stop proses Edge
:: =============================================
echo [2/6] Menghentikan proses Edge...
taskkill /F /IM msedge.exe >nul 2>&1
taskkill /F /IM MicrosoftEdgeUpdate.exe >nul 2>&1
echo [OK] Proses Edge dihentikan.
echo.

:: =============================================
:: STEP 3: Uninstall Edge
:: =============================================
echo [3/6] Menjalankan uninstall Edge...
start /wait "" "%EDGE_SETUP%" --uninstall --system-level --verbose-logging --force-uninstall
echo [OK] Proses uninstall selesai.
echo.

:: =============================================
:: STEP 4: Hapus sisa folder dan shortcut
:: =============================================
:CLEANUP
echo [4/6] Membersihkan sisa file Edge...
if exist "C:\Program Files (x86)\Microsoft\Edge" (
    rd /s /q "C:\Program Files (x86)\Microsoft\Edge" >nul 2>&1
)
if exist "C:\Program Files (x86)\Microsoft\EdgeUpdate" (
    rd /s /q "C:\Program Files (x86)\Microsoft\EdgeUpdate" >nul 2>&1
)
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" (
    del /f /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" >nul 2>&1
)
echo [OK] Sisa file dibersihkan.
echo.

:: =============================================
:: STEP 5: Blokir reinstall otomatis
:: =============================================
echo [5/6] Memblokir reinstall otomatis...
reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "InstallDefault" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Registry diset.
echo.

:: =============================================
:: STEP 6: Disable EdgeUpdate service
:: =============================================
echo [6/6] Menonaktifkan EdgeUpdate service...
sc stop edgeupdate >nul 2>&1
sc config edgeupdate start= disabled >nul 2>&1
sc stop edgeupdatem >nul 2>&1
sc config edgeupdatem start= disabled >nul 2>&1
echo [OK] EdgeUpdate service dinonaktifkan.
echo.

echo ============================================
echo   SELESAI! Microsoft Edge telah dihapus.
echo   Restart PC untuk membersihkan cache.
echo ============================================
echo.
pause
