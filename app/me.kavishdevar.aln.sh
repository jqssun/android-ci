ID="me.kavishdevar.aln"
REPO="https://github.com/kavishdevar/aln.git"
COMMIT="main"
SUBDIR="app"
FLAVOR="yes"

build_init() {
    SUBFOLDER="android"
    mv .fdroid.yml $SUBFOLDER/
    find . -mindepth 1 -maxdepth 1 ! -name ".git" ! -name $SUBFOLDER -exec rm -rf {} +
    mv $SUBFOLDER/* $SUBFOLDER/.* . 2>/dev/null || true
    rm -rf $SUBFOLDER
}
