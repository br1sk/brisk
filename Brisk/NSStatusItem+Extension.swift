import AppKit

extension NSStatusItem {
    static func create(image image: NSImage, menu: NSMenu) -> NSStatusItem {
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusItem.highlightMode = true
        statusItem.image = image
        statusItem.menu = menu

        return statusItem
    }

    func remove() {
        NSStatusBar.systemStatusBar().removeStatusItem(self)
    }
}
