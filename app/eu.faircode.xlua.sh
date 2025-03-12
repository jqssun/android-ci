ID="eu.faircode.xlua"
REPO="https://github.com/0bbedCode/XPL-EX.git"
COMMIT="new"
SUBDIR="app"
FLAVOR="yes"

build_init() {
    use_jdk 11
    sed -i '/signingConfigs.release/{N;N;d}' $SUBDIR/build.gradle
}
