@echo off
title Git-Pusher
color 0a
setlocal EnableDelayedExpansion
set date=%DATE:~0,10%

for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
	set format_date=%%a
	if not "%%b"=="" (
		set format_date=!format_date!%%b
	)
	if not "%%c"=="" (
		set format_date=!format_date!%%c
	)
)

::��ĿĿ¼
D:
cd \MyFiles\Axing-Tech


echo ======== Git Pusher ========
echo ============================
echo ============================
echo ============================
echo ======== �������add ========
pause>nul
git add .

echo ======== �������commit ========
pause>nul
git commit -m "Axing!format_date!"

echo ======== �������push ========
pause>nul
git push

echo ============================
echo git push��������������˳�...
pause>nul