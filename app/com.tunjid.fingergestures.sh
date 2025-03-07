ID="com.tunjid.fingergestures"
REPO="https://github.com/tunjid/digilux-android.git"
COMMIT="develop"
SUBDIR="app"
FLAVOR="yes"

build_init() {
    use_jdk8
    sed -i "s|com.tunjid.androidx:material:1.0.2|com.tunjid.androidx:material:1.0.4|g" app/build.gradle
    sed -i "s|jcenter()|maven { url 'https://repo.grails.org/grails/core/' }|g" build.gradle
}

