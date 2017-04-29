@echo off
cd /d %~dp0

"C:\Program Files\qemu\qemu-system-arm.exe" -M vexpress-a9 -kernel build\zImage -initrd build\initrd.gz -serial stdio -append "root=/dev/ram rdinit=/sbin/init"
