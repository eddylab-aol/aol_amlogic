@echo off
mode con cols=60 lines=10
title AndroidOverLinux Installer
echo VER : alpha
echo Online Manual : http://androidoverlinux.djjproject.com

set /p ip=enter device ip address : 
adb kill-server
adb disconnect
adb connect %ip%:5555
adb connect %ip%:5555

:select
cls
echo -- check Android Debug Allow.
echo [1] Install AoL
echo [2] Uninstall AoL
echo [3] Backup AoL
echo [4] Install AoL from Backup File

set /p sel=enter selection : 

if "%sel%"=="1" (
	cls
	echo Install started.
	goto :install
) else if "%sel%"=="2" (
	cls
	echo "Uninstall started."
	goto :uninstall
) else if "%sel%"=="3" (
	cls
	echo "Backup started."
	goto :backup
) else if "%sel%"=="4" (
	cls
	echo "Install from backup started."
	goto :backupinstall
) else (
	goto :select
)

:install
adb root
adb remount
adb push linux.tar /sdcard/linux.tar
adb push aolinstall /sdcard/aolinstall
adb push aoluninstall /sdcard/aoluninstall
adb shell "chmod a+x /sdcard/aolinstall && sh /sdcard/aolinstall"
echo Install finished. Rebooting device.
adb reboot
goto :exit

:backup
adb root
adb shell "rm /sdcard/aolrun"
echo Rebooting device
adb shell "sync"
adb reboot
echo Wait device rebooting.
timeout 60
adb disconnect
adb connect %ip%:5555
adb connect %ip%:5555
adb root
echo Backup Started.
adb shell "tar cf /sdcard/linux.tar /data/linux"
adb pull /sdcard/linux.tar linux_bak.tar
adb shell "rm /sdcard/linux.tar"
adb shell "touch /sdcard/aolrun"
adb shell "sync"
adb reboot
echo Backup Complete.
echo Rebooting device.
goto :exit

:backupinstall
if exist linux_bak.tar (
	adb root
	adb shell "rm /sdcard/aolrun"
	echo reboot device
	adb shell "sync"
	adb reboot
	echo Wait device rebooting.
	timeout 60
	adb disconnect
	adb connect %ip%:5555
	adb connect %ip%:5555
	adb root
	adb push linux_bak.tar /sdcard/linux.tar
	adb shell "rm -rf /data/linux"
	adb shell "tar xf /sdcard/linux.tar -C /"
	adb shell "rm /sdcard/linux.tar"
	adb shell "touch /sdcard/aolrun"
	adb shell "sync"
	adb reboot
	echo Install from backup complete.
	goto :exit
) else (
	echo Backup file not found.
	timeout 10
	goto :select
)
goto :exit

:uninstall
adb shell "rm /sdcard/aolrun"
echo Reboot device
adb shell "sync"
adb reboot
echo Wait device rebooting.
timeout 60
adb disconnect
adb connect %ip%:5555
adb connect %ip%:5555
adb root
adb remount
adb shell "chmod a+x /sdcard/aoluninstall && sh /sdcard/aoluninstall"
adb shell "rm /sdcard/aol*"
adb reboot
echo Uninstall finished.
goto :exit

:exit
pause








