ID="com.fankes.apperrorstracking"
REPO="https://github.com/KitsunePie/AppErrorsTracking.git"
COMMIT="master"
SUBDIR="module-app"
FLAVOR="yes"

build_init() {
    # git fetch --unshallow
    # git reset --hard $COMMIT

    # yukihook: https://highcapable.github.io/YukiHookAPI/en/config/xposed-using.html#injectyukihookwithxposed-annotation
    rm -rf $SUBDIR/.gitignore
    mkdir -p $SUBDIR/src/main/assets $SUBDIR/src/main/resources/META-INF
    echo "$ID.hook.AppErrorsTracking" > $SUBDIR/src/main/assets/xposed_init
    echo "$ID.hook.HookEntry" > $SUBDIR/src/main/resources/META-INF/yukihookapi_init
    sed -i '/ProjectPromote/d' $SUBDIR/src/main/java/com/fankes/apperrorstracking/ui/activity/main/MainActivity.kt

    # strip_signing_kts $SUBDIR/build.gradle.kts
    sed -i "s/property.project.module.app.packageName/\"$ID\"/g" $SUBDIR/build.gradle.kts
    sed -i '/signingConfig =/d' module-app/build.gradle.kts
    sed -i '/signingConfig =/d' demo-app/build.gradle.kts

    # echo "-dontwarn" > $SUBDIR/proguard-rules.pro
    sed -i 's@include(":module-app", ":demo-app")@include(":module-app")@g' settings.gradle.kts
    rm -rf demo-app
}
