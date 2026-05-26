QtObject {
    id: button

    required property string command
    required property string inhalt
    required property string farbe

    Process {
        id: process

        command: button.command
    }

    function run() {
        process.startDetached()
        Qt.quit()
    }
}