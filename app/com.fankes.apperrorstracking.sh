ID="com.fankes.apperrorstracking"
REPO="https://github.com/KitsunePie/AppErrorsTracking.git"
COMMIT="master"
SUBDIR="module-app"
FLAVOR="yes"

build_init() {
    # strip_signing_kts $SUBDIR/build.gradle.kts
    sed -i "s/property.project.module.app.packageName/\"$ID\"/g" $SUBDIR/build.gradle.kts
    sed -i '/signingConfig =/d' $SUBDIR/build.gradle.kts
    # echo "-dontwarn" > $SUBDIR/proguard-rules.pro
    sed -i 's@include(":module-app", ":demo-app")@include(":module-app")@g' settings.gradle.kts
    rm -rf demo-app
}
