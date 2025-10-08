ID="ua.polodarb.gmsphixit"
REPO="https://github.com/polodarb/GMS-Phixit.git"
COMMIT="development"
SUBDIR="app"
FLAVOR="yes"

build_init() {
    rm -rf .gitignore
    wget https://github.com/firebase/quickstart-android/raw/refs/heads/master/mock-google-services.json
    sed -i 's/com.google.samples.quickstart.admobexample/ua.polodarb.gmsphixit/g' mock-google-services.json
    mv mock-google-services.json app/google-services.json

    sed -i '/[Cc][Rr][Aa][Ss][Hh][Ll][Yy][Tt][Ii][Cc][Ss]/d' app/src/main/java/ua/polodarb/gmsphixit/core/errors/general/CrashActivity.kt
}
