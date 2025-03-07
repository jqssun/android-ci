ID="laas.rcayre.radiosploit"
REPO="https://github.com/RCayre/radiosploit.git"
COMMIT="main"
SUBDIR="app"
FLAVOR="yes"

build_init() {
    use_jdk8
}

# https://naehrdine.blogspot.com/2021/01/broadcom-bluetooth-unpatching.html
