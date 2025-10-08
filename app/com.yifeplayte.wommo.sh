ID="com.yifeplayte.wommo"
REPO="https://github.com/YifePlayte/WOMMO.git"
COMMIT="main"
SUBDIR="app"
FLAVOR="yes"

build_init() {
    sed -i 's@isEnable = true@isEnable = false@' $SUBDIR/build.gradle.kts
}
