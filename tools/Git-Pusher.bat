@echo off
title Git-Pusher
color 0a
setlocal EnableDelayedExpansion
set format_date=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%%Time:~0,2%%Time:~3,2%

::项目目录
D:
cd \MyFiles\Axing-Tech


echo ======== Git Pusher ========
echo ============================
echo ============================
echo ============================
echo ======== 按任意键add ========
pause>nul
git add .

echo ======== 按任意键commit ========
pause>nul
git commit -m "Axing!format_date!"

echo ======== 按任意键push ========
pause>nul
git push

echo ============================
echo git push结束，按任意键退出...
pause>nul