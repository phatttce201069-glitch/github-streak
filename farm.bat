@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0farm-commits.ps1" %*
