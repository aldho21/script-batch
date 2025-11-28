@echo off
setlocal EnableExtensions EnableDelayedExpansion
title yt-dlp Quick Downloader (MP4)
color 0A

:: ====== Folder output (ubah kalau mau) ======
set "OUTDIR=D:\Youtube Downloader"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

:: ====== Cek yt-dlp & ffmpeg (opsional tapi bagus) ======
where yt-dlp >nul 2>nul || (
  echo [!] yt-dlp tidak ditemukan di PATH. Install via:  pip install -U yt-dlp  atau taruh yt-dlp.exe di PATH.
  echo.
  pause
  goto :eof
)
where ffmpeg >nul 2>nul || (
  echo [!] ffmpeg/ffprobe tidak ditemukan di PATH. Merge ke MP4 tetap bisa, tapi sebaiknya install ffmpeg.
  echo.
)

:: ====== Input URL (aman untuk karakter & karena disimpan ke variabel) ======
echo.
echo Paste URL YouTube lalu tekan Enter (kosong = batal):
set "URL="
set /p "URL=> "
if "%URL%"=="" goto :eof
set "URL=%URL%"

echo.
echo ===== Mulai download ke: "%OUTDIR%" =====
echo.

:: ====== Jalankan yt-dlp ======
yt-dlp ^
  -N 8 --concurrent-fragments 8 ^
  --paths "%OUTDIR%" -o "%%(uploader)s\%%(title)s.%%(ext)s" ^
  -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]" ^
  --merge-output-format mp4 ^
  --embed-metadata --embed-thumbnail --restrict-filenames ^
  --newline --color always --console-title ^
  --progress-template "download:[download] %%(progress._percent_str)s of %%(progress._total_bytes_str)s at %%(progress._speed_str)s ETA %%(progress._eta_str)s" ^
  "%URL%"

echo.
pause
endlocal
