ID="ua.polodarb.gmsflags"
REPO="https://github.com/polodarb/GMS-Flags.git"
COMMIT="develop"
SUBDIR="app"
FLAVOR="yes"

build_init() {
    rm -rf app/.gitignore
    wget https://github.com/firebase/quickstart-android/raw/refs/heads/master/mock-google-services.json
    sed -i 's/com.google.samples.quickstart.admobexample/ua.polodarb.gmsflags/g' mock-google-services.json
    mv mock-google-services.json app/google-services.json

    # remove analytics
    # sed -i '/firebase/d' gradle/libs.versions.toml
    # sed -i '/firebase/d' build.gradle.kts
    # sed -i '/firebase/d' app/build.gradle.kts
    # sed -i '/firebase/d' app/src/main/java/ua/polodarb/gmsflags/ui/MainActivity.kt
    # sed -i 's/analytics = Firebase.analytics//g' app/src/main/java/ua/polodarb/gmsflags/ui/MainActivity.kt
    sed -i '/[Aa][Nn][Aa][Ll][Yy][Tt][Ii][Cc][Ss]/d' app/src/main/java/ua/polodarb/gmsflags/ui/MainActivity.kt
    sed -i '/[Cc][Rr][Aa][Ss][Hh][Ll][Yy][Tt][Ii][Cc][Ss]/d' app/src/main/java/ua/polodarb/gmsflags/errors/general/CrashActivity.kt
}

# https://t.me/gmsflags
# https://telegra.ph/Temporary-fix-for-GMS-FlagsGoogle-Play-Services-Unsupported-Schema-Error-11-24 
