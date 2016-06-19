import AppKit

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var windowController: NSWindowController?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.showWindowBasedOnKeychain()
    }

    // MARK: - Private Methods

    private func showWindowBasedOnKeychain() {
        self.windowController?.close()

        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let radarLogin = Keychain.get(.Radar)
        if radarLogin == nil {
            self.windowController = storyboard.instantiateWindowControllerWithIdentifier("Login")
            let authenticationViewController = self.windowController?.contentViewController
                as! AuthenticationViewController
            authenticationViewController.userDidLogin = { [weak self] in
                self?.showWindowBasedOnKeychain()
            }
        } else {
            self.windowController = storyboard.instantiateWindowControllerWithIdentifier("Radar")
        }

        self.windowController!.showWindow(self)
        NSApp.activateIgnoringOtherApps(true)
    }
}
