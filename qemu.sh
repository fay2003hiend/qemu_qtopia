#!/bin/bash

cd ${0%/*}

qemu-system-arm -M vexpress-a9 -kernel build/zImage -initrd build/initrd.gz -serial stdio -append "root=/dev/ram rdinit=/sbin/init"
