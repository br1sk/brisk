import AppKit

private let kMainStoryboard = NSStoryboard(name: "Main", bundle: nil)

extension NSStoryboard {
    static var main: NSStoryboard {
        return kMainStoryboard
    }

    func instantiateWindowControllerWithIdentifier(identifier: String) -> NSWindowController {
        return self.instantiateControllerWithIdentifier(identifier) as! NSWindowController
    }
}
