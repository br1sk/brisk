import AppKit

final class Application: NSApplication, NSSeguePerforming {
    override func orderFrontStandardAboutPanel(sender: AnyObject?) {
        super.orderFrontStandardAboutPanel(sender)
        NSApp.activateIgnoringOtherApps(true)
    }
}
