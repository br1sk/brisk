import AppKit

final class StoryboardRouter: NSObject {
    private static var sharedRouter = StoryboardRouter()
    private var windowController: NSWindowController?

    static func reloadTopWindowController() {
        self.sharedRouter.reloadTopWindowController()
    }

    private func reloadTopWindowController() {
        self.windowController?.window?.delegate = nil
        self.windowController?.close()
        NSApp.stopModal()

        let radarLogin = Keychain.get(.Radar)
        if radarLogin == nil {
            self.windowController = NSStoryboard.main.instantiateWindowControllerWithIdentifier("Login")
            NSApp.runModalForWindow(self.windowController!.window!)
        }

        self.windowController?.window?.delegate = self
        NSApp.activateIgnoringOtherApps(true)
    }
}

extension StoryboardRouter: NSWindowDelegate {
    func windowWillClose(notification: NSNotification) {
        StoryboardRouter.sharedRouter.windowController = nil
    }
}
