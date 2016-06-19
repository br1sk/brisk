import AppKit

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        StoryboardRouter.reloadTopWindowController()
    }

    func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
        return false
    }
}
