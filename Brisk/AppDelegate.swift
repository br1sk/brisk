import AppKit

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet private var statusMenu: NSMenu!
    private var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        StoryboardRouter.reloadTopWindowController()
        self.setupStatusItem()
    }

    func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
        return false
    }

    func applicationWillTerminate(notification: NSNotification) {
        self.cleanupStatusItem()
    }

    // MARK: - Private Methods

    private func setupStatusItem() {
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusItem.highlightMode = true
        statusItem.image = NSImage(named: NSImageNameFlowViewTemplate)
        statusItem.menu = self.statusMenu

        self.statusItem = statusItem
    }

    private func cleanupStatusItem() {
        if let statusItem = self.statusItem {
            NSStatusBar.systemStatusBar().removeStatusItem(statusItem)
        }

        self.statusItem = nil
    }
}
