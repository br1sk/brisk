import AppKit

final class RadarDocument: NSDocument {
    override func makeWindowControllers() {
        let windowController = NSStoryboard.main.instantiateWindowControllerWithIdentifier("Radar")
        self.addWindowController(windowController)
    }
}
