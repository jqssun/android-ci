SCRIPT_DIR=$(realpath $(dirname $0))

set_dir() {
    rm -rf $SCRIPT_DIR/.tmp $SCRIPT_DIR/out
    mkdir -p $SCRIPT_DIR/.tmp $SCRIPT_DIR/out
    # wget ${REPO%.git}/archive/$COMMIT.zip
    # mv $COMMIT.zip $SCRIPT_DIR/out/$ID.zip
    git clone --recurse-submodules --shallow-submodules --depth 1 --branch $COMMIT --single-branch $REPO $SCRIPT_DIR/.tmp/$ID
    cd $SCRIPT_DIR/.tmp/$ID
    git archive --format=tar.gz $COMMIT > $SCRIPT_DIR/out/$ID.tar.gz
}

set_git() {
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
}

publish() {
    # ./gradlew assembleRelease
    fdroid build --skip-scan --no-tarball --no-refresh -W ignore

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
