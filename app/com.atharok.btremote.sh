ID="com.atharok.btremote"
REPO="https://gitlab.com/Atharok/BtRemote.git"
COMMIT="main" # a7d894078cff537150daba51c78a44c5bb671983
SUBDIR="app"
FLAVOR="default"

# this build enables support for using the device as a BT HID device for a PC
build_init() {
    sed -i 's@sendReport(KEYBOARD_REPORT_ID, bytes)@sendReport(KEYBOARD_REPORT_ID, byteArrayOf(0x00) + bytes + byteArrayOf(0x00, 0x00, 0x00, 0x00))@' $SUBDIR/src/main/java/com/atharok/btremote/presentation/viewmodel/BluetoothHidViewModel.kt
    sed -i 's@sendReport(MOUSE_REPORT_ID, bytes)@sendReport(MOUSE_REPORT_ID, bytes + byteArrayOf(0x00))@' $SUBDIR/src/main/java/com/atharok/btremote/presentation/viewmodel/BluetoothHidViewModel.kt
    sed -i 's@MOUSE_REPORT_ID = 0x03@MOUSE_REPORT_ID = 0x02@' $SUBDIR/src/main/java/com/atharok/btremote/common/utils/Constants.kt
}

# for debugging: to sniff BT traffic on macOS, use PacketLogger from Xcode Additional Tools, then install the profile 
# https://developer.apple.com/bug-reporting/profiles-and-logs/?name=bluetooth
