#!/bin/bash

if [ $(uname) == "Linux" ]; then
    if [ "${CI}" == "true" ] || [ $(lsb_release -is) == "Ubuntu" ]; then
        sudo apt update
        # sudo apt install -y openjdk-17-jdk-headless # aapt apksigner
        sudo apt install -y software-properties-common # git bat dexdump dos2unix unzip python3-pip
        # sudo update-alternatives --set java $(update-alternatives --list java | grep "java-17")
    fi
    wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O commandlinetools.zip > /dev/null 2>&1
    mkdir -p $ANDROID_HOME/cmdline-tools
    unzip commandlinetools.zip -d $ANDROID_HOME/cmdline-tools > /dev/null 2>&1; rm commandlinetools.zip
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest
    yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null 2>&1
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "build-tools;30.0.3" "platform-tools" "tools"

    if [ "${CI}" == "true" ] || [ -n "$GITHUB_RUN_ID" ] || [ "$(lsb_release -is)" == "Ubuntu" ]; then
        sudo add-apt-repository -y ppa:apt-fast/stable
        sudo DEBIAN_FRONTEND=noninteractive apt install -y apt-fast
        sudo add-apt-repository -y ppa:fdroid/fdroidserver
        sudo apt-fast install -y fdroidserver
    elif [ $(lsb_release -is) == "Debian" ]; then
        sudo apt install -y -t $(lsb_release -sc)-backports fdroidserver
    fi
    sudo sed -i '/exit 1/d' /usr/lib/python3/dist-packages/gradlew-fdroid
elif [ $(uname) == "Darwin" ]; then
    brew install fdroidserver
    # mamba install gnupg
fi
