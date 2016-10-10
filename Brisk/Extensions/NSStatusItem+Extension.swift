import AppKit

extension NSStatusItem {
    static func create(image: NSImage, menu: NSMenu) -> NSStatusItem {
        let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        statusItem.highlightMode = true
        statusItem.image = image
        statusItem.menu = menu

        return statusItem
    }

    func remove() {
        NSStatusBar.system().removeStatusItem(self)
    }
}
