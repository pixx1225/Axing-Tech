@echo off
title Git-Pusher
color 0a
setlocal EnableDelayedExpansion
set format_date=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%%Time:~0,2%%Time:~3,2%

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