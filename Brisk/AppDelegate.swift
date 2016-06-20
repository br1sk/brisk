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

    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag {
            return true
        }

        NSDocumentController.sharedDocumentController().newDocument(self)
        return false
    }

    func application(sender: NSApplication, openFiles filenames: [String]) {
        let documentController = NSDocumentController.sharedDocumentController()
        let type = "com.brisk.radar"

        for filename in filenames {
            let URL = NSURL(fileURLWithPath: filename)
            if let document = try? documentController.makeDocumentWithContentsOfURL(URL, ofType: type) {
                documentController.addDocument(document)
                document.showWindows()
            }
        }
    }

    func applicationWillTerminate(notification: NSNotification) {
        self.cleanupStatusItem()
    }

    // MARK: - Private Methods

    private func setupStatusItem() {
        let image = NSImage(named: NSImageNameFlowViewTemplate)!
        self.statusItem = NSStatusItem.create(image: image, menu: self.statusMenu)
    }

    private func cleanupStatusItem() {
        self.statusItem?.remove()
        self.statusItem = nil
    }
}
