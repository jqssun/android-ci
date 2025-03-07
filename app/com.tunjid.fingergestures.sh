ID="com.tunjid.fingergestures"
REPO="https://github.com/tunjid/digilux-android.git"
COMMIT="develop"
SUBDIR="app"
FLAVOR="yes"

build_init() {
    if [ $(uname) == "Linux" ]; then
        if [ $(lsb_release -is) == "Ubuntu" ]; then
            sudo umount /opt/hostedtoolcache
            sudo apt install -y openjdk-8-jdk
            sudo update-alternatives --set java $(update-alternatives --list java | grep "java-8")
            export PATH=/usr/lib/jvm/java-8-openjdk-amd64/bin:$PATH
            export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
        fi
    elif [ $(uname) == "Darwin" ]; then
        export PATH=$(brew --prefix)/opt/openjdk@8/bin:$PATH CPPFLAGS="-I$(brew --prefix)/opt/openjdk@8/include"
    fi
    sed -i "s|com.tunjid.androidx:material:1.0.2|com.tunjid.androidx:material:1.0.4|g" app/build.gradle
    sed -i "s|jcenter()|maven { url 'https://repo.grails.org/grails/core/' }|g" build.gradle
}

