@echo off
title Git-Pusher
color 0a
setlocal EnableDelayedExpansion
set date=%DATE:~3,13%

for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
	set format_date=%%a
	if not "%%b"=="" (
    	set format_date=!format_date!%%b
 	)
	if not "%%c"=="" (
	    set format_date=!format_date!%%c
	)
)

::开始操作，目录确定正确
D:
cd \MyFiles\Axing-Tech

echo git开始，按任意键add...
pause>nul

git add .
echo git add结束，按任意键commit...
pause>nul

git commit -m "Axing!format_date!"
echo git commit结束，按任意键push...
pause>nul

git push
echo git push结束，按任意键退出...
pause>nul