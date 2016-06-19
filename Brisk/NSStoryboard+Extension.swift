import AppKit

extension NSStoryboard {
    func instantiateWindowControllerWithIdentifier(identifier: String) -> NSWindowController {
        return self.instantiateControllerWithIdentifier(identifier) as! NSWindowController
    }
}
