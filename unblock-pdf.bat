@echo off
powershell -Command "Get-ChildItem -Path '%~dp0' -Filter *.pdf -Recurse | Unblock-File"
echo Done! All PDFs unblocked.
pause