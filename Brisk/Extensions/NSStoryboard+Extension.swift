import AppKit

private let kMainStoryboard = NSStoryboard(name: "Main", bundle: nil)

extension NSStoryboard {
    static var main: NSStoryboard {
        return kMainStoryboard
    }

    func instantiateWindowController(identifier: String) -> NSWindowController {
        return self.instantiateController(withIdentifier: identifier) as! NSWindowController
    }
}
