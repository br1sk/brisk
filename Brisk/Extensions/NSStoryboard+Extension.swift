import AppKit

private let kMainStoryboard = NSStoryboard(name: .init(rawValue: "Main"), bundle: nil)

extension NSStoryboard {
    static var main: NSStoryboard {
        return kMainStoryboard
    }

    func instantiateWindowController(identifier: String) -> NSWindowController {
        return self.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: identifier)) as! NSWindowController
    }
}
