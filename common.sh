SCRIPT_DIR=$(realpath $(dirname $0))

if [ $(uname) == "Darwin" ]; then
    export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
    export PATH=$(brew --prefix)/opt/sed/libexec/gnubin:$PATH
    export PATH=$(brew --prefix)/opt/openjdk@17/bin:$PATH
elif [ "${CI}" == "true" ]; then
    ANDROID_HOME="/tmp/android-sdk"
    export ANDROID_HOME
fi

replace() {
    export org=$1 new=$2
    find . -type f -exec sed -i 's@'$org'@'$new'@g' {} \;
}

rename() {
    export org=$1 new=$2
    find . -name "*$org*" -exec bash -c 'mv "$1" "${1/$org/$new}"' -- {} \;
}

use_jdk() {
    ver=$1
    if [ $(uname) == "Linux" ]; then
        if [ $CI == "true" ] || [ $(lsb_release -is) == "Ubuntu" ]; then
            sudo umount /opt/hostedtoolcache
            sudo apt install -y openjdk-$ver-jdk
            sudo update-alternatives --set java $(update-alternatives --list java | grep "java-$ver")
            export PATH=/usr/lib/jvm/java-$ver-openjdk-amd64/bin:$PATH
            export JAVA_HOME=/usr/lib/jvm/java-$ver-openjdk-amd64
        fi
    elif [ $(uname) == "Darwin" ]; then
        export PATH=$(brew --prefix)/opt/openjdk@$ver/bin:$PATH CPPFLAGS="-I$(brew --prefix)/opt/openjdk@$ver/include"
    fi
}

set_dir() {
    rm -rf $SCRIPT_DIR/.tmp $SCRIPT_DIR/out
    mkdir -p $SCRIPT_DIR/.tmp $SCRIPT_DIR/out
    # wget ${REPO%.git}/archive/$COMMIT.zip
    # mv $COMMIT.zip $SCRIPT_DIR/out/$ID.zip
    git clone --depth 1 --branch $COMMIT --single-branch $REPO $SCRIPT_DIR/.tmp/$ID # fdroid hanles submodules
    # git clone --recurse-submodules --shallow-submodules --depth 1 --branch $COMMIT --single-branch $REPO $SCRIPT_DIR/.tmp/$ID
    cd $SCRIPT_DIR/.tmp/$ID
    git archive --format=tar.gz $COMMIT > $SCRIPT_DIR/out/$ID.tar.gz
}

set_git() {
    if [ $(uname) == "Darwin" ]; then
        read -n 1 -s -r -p "Press any key to continue..." && echo
    fi
    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add .
    git commit -am "build"
}

set_keys() {
    # fdroid update --create-key
    # echo $CONFIG_TEST_P12 | base64 -d > config.yml
    # echo $STORE_TEST_P12 | base64 -d > keystore.p12
    mkdir -p $SCRIPT_DIR/keys
    if [ $(uname) == "Linux" ]; then
        echo $LOCAL_TEST_JKS | base64 -d > $SCRIPT_DIR/keys/local.properties
        echo $STORE_TEST_JKS | base64 -d > $SCRIPT_DIR/keys/test.jks
        apksigner=$(which apksigner)
    elif [ $(uname) == "Darwin" ]; then
        apksigner=$(find $ANDROID_HOME/build-tools -name apksigner | sort | tail -n 1)
    fi
}

strip_signing_kts() {
    sed -i '/keyAlias/d' $1
    sed -i '/keyPassword/d' $1
    sed -i '/storeFile/d' $1
    sed -i '/storePassword/d' $1
}

update_metadata() {
    cp $SCRIPT_DIR/metadata.yml .fdroid.yml
    sed -i "s/\${{COMMIT}}/$COMMIT/g" .fdroid.yml
    sed -i "s/\${{SUBDIR}}/$SUBDIR/g" .fdroid.yml
    sed -i "s/\${{FLAVOR}}/$FLAVOR/g" .fdroid.yml
    if ! [ -z $SUBMOD ]; then
        sed -i "s/submodules: false/submodules: true/g" .fdroid.yml
    fi

    # get_source_date_epoch in fdroidserver/common.py expects metadata/$ID.yml
    mkdir -p metadata
    cp .fdroid.yml metadata/$ID.yml
}

publish() {
    # ./gradlew assembleRelease
    fdroid build --skip-scan --no-tarball --no-refresh -W warn

    source $SCRIPT_DIR/keys/local.properties
    storeFile=$SCRIPT_DIR/keys/test.jks
    $apksigner sign -verbose -ks $storeFile --ks-pass pass:$storePassword --key-pass pass:$keyPassword --ks-key-alias $keyAlias --out $SCRIPT_DIR/out/$ID.apk unsigned/$ID*.apk
    # fdroid publish; mv repo/*.apk $SCRIPT_DIR/out

    cd $SCRIPT_DIR
    if [ $(uname) == "Linux" ]; then
        rm -rf $SCRIPT_DIR/keys $SCRIPT_DIR/.tmp
    elif [ $(uname) == "Darwin" ]; then
        osascript -e "tell application \"Finder\" to delete POSIX file \"$(realpath $SCRIPT_DIR/.tmp)\""
        rm -rf $HOME/Library/Caches/fdroidserver
    fi
}
