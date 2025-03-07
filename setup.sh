#!/bin/bash

if [ $(uname) == "Linux" ]; then
    if [ $(lsb_release -is) == "Ubuntu" ]; then
        echo "Running on Ubuntu"
        sudo apt update
        # sudo apt install -y openjdk-17-jdk-headless
        # sudo update-alternatives --set java $(update-alternatives --list java | grep "java-17")
        sudo apt install -y aapt apksigner # git bat dexdump dos2unix unzip python3-pip
    fi
    ANDROID_HOME="/opt/android-sdk"
    wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O commandlinetools.zip > /dev/null 2>&1
    mkdir -p $ANDROID_HOME/cmdline-tools
    unzip commandlinetools.zip -d $ANDROID_HOME/cmdline-tools > /dev/null 2>&1; rm commandlinetools.zip
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest
    yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null 2>&1

    pip install apksigcopier oscrypto --force-reinstall > /dev/null 2>&1
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "build-tools;30.0.3" "platform-tools" "tools"
fi

pip install git+https://gitlab.com/fdroid/fdroidserver; pip uninstall --yes fdroidserver 
# pip-autoremove fdroidserver
git clone --recurse-submodules --depth 1 https://gitlab.com/fdroid/fdroidserver
rm -rf fdroidserver/.git
if [ $(uname) == "Linux" ]; then
    if [ $(lsb_release -is) == "Ubuntu" ]; then
        sudo ln -s $(pwd)/fdroidserver/fdroid /usr/local/bin
    fi
elif [ $(uname) == "Darwin" ]; then
    pip uninstall --yes sdkmanager
    rm -f $(conda info --base)/bin/fdroid
    ln -s $(pwd)/fdroidserver/fdroid $(conda info --base)/bin
    # mamba install gnupg
fi
