import AppKit

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet private var statusMenu: NSMenu!
    @IBOutlet private var dupeRadarMenuItem: NSMenuItem!

    private var statusItem: NSStatusItem?

    func applicationWillFinishLaunching(_ notification: Notification) {
        self.registerDefaults()
        self.setupDockIcon()
        self.setupStatusItem()
        self.registerRadarURLs()
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

        NSDocumentController.shared.newDocument(self)
        return false
    }

    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        for filename in filenames {
            let url = URL(fileURLWithPath: filename)

            if let openDocument = NSDocumentController.shared.document(for: url) {
                openDocument.showWindows()
            } else if let document = NSDocumentController.shared.makeRadarDocument(withContentsOf: url) {
                NSDocumentController.shared.addDocument(document)
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

    private func registerRadarURLs() {
        let eventManager = NSAppleEventManager.shared()
        let selector = #selector(self.handleGetURLEvent(event:withReplyEvent:))
        eventManager.setEventHandler(self, andSelector: selector,
                                     forEventClass: AEEventClass(kInternetEventClass),
                                     andEventID: AEEventID(kAEGetURL))
    }

    @objc
    private func handleGetURLEvent(event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        let radarLink = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue
        if let radarID = radarLink.flatMap(radarID(from:)) {
            _ = self.dupeRadarMenuItem.target!.perform(self.dupeRadarMenuItem.action!)
            let viewController = NSApp.windows
                .compactMap { $0.contentViewController as? FileDuplicateViewController }
                .first!
            viewController.searchForOpenRadar(text: radarID)
        } else {
            let alert = NSAlert()
            alert.messageText = "Invalid Radar ID"
            alert.informativeText = "The link '\(radarLink ?? "")' doesn't contain a valid radar ID"
            alert.runModal()
        }
    }
}
