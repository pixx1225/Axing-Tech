@echo off
title Get-Win-Pic
color 0a


set dir=C:\Users\%username%\Pictures\WinPic
if not exist %dir% md %dir%

C:
cd \Users\%username%\Pictures\WinPic
del /f /s /q *

C:
cd \Users\%username%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\
copy /y * C:\Users\%username%\Pictures\WinPic\*

ren C:\Users\%username%\Pictures\WinPic\* *.png