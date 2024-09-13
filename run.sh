#!/usr/bin/bash

kvm -m 512M -kernel linux/arch/x86_64/boot/bzImage -initrd initramfs.gz -nographic -append "console=ttyS0"
