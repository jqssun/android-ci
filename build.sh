#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <package_id>"
    exit 1
fi

cd $(dirname $0)

once() {
    source common.sh
    if [ -f "app/$1.sh" ]; then
        source app/$1.sh
    else
        echo "Package not found: $1"
        exit 1
    fi
    if ! command -v fdroid &> /dev/null; then
        source setup.sh
    fi
    set_dir
    update_metadata
    build_init
    set_git
    set_keys
    publish # requires froidserver
}

if [ "$1" == "all" ]; then
    for app in app/*.sh; do
        once $(basename $app .sh)
    done
else
    once $1
fi
