ID="de.tu_darmstadt.seemoo.nfcgate"
REPO="https://github.com/nfcgate/nfcgate.git"
COMMIT="v2"
SUBDIR="app"
FLAVOR="yes"
SUBMOD="true"

build_init() {
    sed -i "s@url = ../protocol.git@url = https://github.com/nfcgate/protocol.git@g" .gitmodules
}
