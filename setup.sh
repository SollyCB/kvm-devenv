#!/usr/bin/bash

if [ -d ramfs ]; then
    sudo rm -r ramfs/
fi

(
    mkdir -p ramfs/{bin,dev,mods}

    if ls mods | rg ".*\.ko$" > /dev/null; then
        cp mods/*.ko ramfs/mods
    else
        echo "no modules found"
    fi

    if ls mods | rg ".*\.sh$" > /dev/null; then
        cp mods/*.sh ramfs/mods
    else
        echo "no module scripts found"
    fi

    cd ramfs/bin
    cp /bin/busybox .
    "$PWD/busybox" --install .

    cd ..
    sudo cp -a /dev/{null,tty,zero,console} dev
    printf '%s\n' "#! /bin/sh -" "exec /bin/sh" > init
    chmod +x init
    find . | cpio -oHnewc | gzip > ../initramfs.gz
)

