import AppKit

private let kStoryboard = NSStoryboard(name: "Main", bundle: nil)

final class StoryboardRouter: NSObject {
    private static var sharedRouter = StoryboardRouter()
    private var windowController: NSWindowController?

    static func reloadTopWindowController() {
        self.sharedRouter.reloadTopWindowController()
    }

    private func reloadTopWindowController() {
        self.windowController?.window?.delegate = nil
        self.windowController?.close()

        let radarLogin = Keychain.get(.Radar)
        if radarLogin == nil {
            self.windowController = kStoryboard.instantiateWindowControllerWithIdentifier("Login")
        } else {
            self.windowController = kStoryboard.instantiateWindowControllerWithIdentifier("Radar")
        }

        self.windowController!.showWindow(self)
        self.windowController!.window!.delegate = self
        NSApp.activateIgnoringOtherApps(true)
    }
}

extension StoryboardRouter: NSWindowDelegate {
    func windowWillClose(notification: NSNotification) {
        StoryboardRouter.sharedRouter.windowController = nil
    }
}
