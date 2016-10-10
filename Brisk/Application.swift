import AppKit

final class Application: NSApplication, NSSeguePerforming {
    override func orderFrontStandardAboutPanel(_ sender: Any?) {
        super.orderFrontStandardAboutPanel(sender)
        NSApp.activate(ignoringOtherApps: true)
    }
}
