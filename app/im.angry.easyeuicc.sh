ID="im.angry.easyeuicc"
REPO="https://gitea.angry.im/PeterCxy/OpenEUICC.git"
COMMIT="master"
SUBDIR="app-unpriv"
FLAVOR="yes"

build_init() {
    true # sdkmanager "ndk;26.1.10909125"
}
