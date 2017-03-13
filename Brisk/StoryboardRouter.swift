import AppKit

final class StoryboardRouter: NSObject {
    fileprivate static let sharedRouter = StoryboardRouter()
    fileprivate var windowController: NSWindowController?

    static func reloadTopWindowController() {
        self.sharedRouter.reloadTopWindowController()
    }

    private func reloadTopWindowController() {
        self.windowController?.window?.delegate = nil
        self.windowController?.close()
        NSApp.stopModal()

        let radarLogin = Keychain.get(.radar)
        if radarLogin == nil {
            self.windowController = NSStoryboard.main.instantiateWindowController(identifier: "Login")
            NSApp.runModal(for: self.windowController!.window!)
        }

        self.windowController?.window?.delegate = self
        NSApp.activate(ignoringOtherApps: true)
    }
}

extension StoryboardRouter: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        self.windowController = nil
    }
}
