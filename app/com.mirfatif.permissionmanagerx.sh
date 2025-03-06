ID="com.mirfatif.permissionmanagerx"
REPO="https://github.com/mirfatif/PermissionManagerX.git"
COMMIT="master"
SUBDIR="app"
FLAVOR="[fdroid, foss]"
SUBMOD="true"

build_init() {
    sdkmanager "ndk;25.1.8937393"
    sed -i -e "s|createJarFromApk(apk, jar)|createJarFromApk('../'+apk, '../'+jar)|" app/build.gradle
    if [ $(uname) == "Linux" ]; then
        true
    elif [ $(uname) == "Darwin" ]; then
        sed -i "s/linux-x86_64/darwin-x86_64/g" native/build_native.sh
    fi
}

