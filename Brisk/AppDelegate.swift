import AppKit

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet private var statusMenu: NSMenu!
    private var statusItem: NSStatusItem?

    func applicationWillFinishLaunching(_ notification: Notification) {
        self.registerDefaults()
        self.setupDockIcon()
        self.setupStatusItem()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        StoryboardRouter.reloadTopWindowController()
        GlobalHotKey.register()
    }

    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return UserDefaults.standard.bool(forKey: Defaults.showDockIcon)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag {
            return true
        }

        NSDocumentController.shared().newDocument(self)
        return false
    }

    @IBAction private func dupeRadar(_ sender: Any) {
        // Opens a window and relays the action to the handler there.
        NSDocumentController.shared().newDocument(self)
        NSApp.sendAction(#selector(dupeRadar(_:)), to: nil, from: nil)
    }

    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        let documentController = NSDocumentController.shared()
        let type = "com.brisk.radar"

        for filename in filenames {
            let url = URL(fileURLWithPath: filename)
            if let document = try? documentController.makeDocument(withContentsOf: url, ofType: type) {
                documentController.addDocument(document)
                document.showWindows()
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        self.cleanupStatusItem()
    }

    // MARK: - Private Methods

    private func registerDefaults() {
        let defaults: [String: Any] = [
            Defaults.showDockIcon: false,
        ]

        UserDefaults.standard.register(defaults: defaults)
    }

    private func setupDockIcon() {
        if !UserDefaults.standard.bool(forKey: Defaults.showDockIcon) {
            return
        }

        NSApp.setActivationPolicy(.regular)
    }

    private func setupStatusItem() {
        let image = NSImage(named: "StatusItemIcon")!
        self.statusItem = NSStatusItem.create(image: image, menu: self.statusMenu)
    }

    private func cleanupStatusItem() {
        self.statusItem?.remove()
        self.statusItem = nil
    }
}
