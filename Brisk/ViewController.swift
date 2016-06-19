import AppKit

class ViewController: NSViewController {
    override func viewWillAppear() {
        super.viewWillAppear()
        NSApp.activateIgnoringOtherApps(true)
    }
}
