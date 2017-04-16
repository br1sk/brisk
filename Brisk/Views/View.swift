import Cocoa

@IBDesignable
final class View: NSView {

    /// The color used to paint the view's background (default: clear).
    @IBInspectable var backgroundColor: NSColor = .clear {
        didSet {
            self.wantsLayer = true
            self.layer?.backgroundColor = self.backgroundColor.sRGBCGColor
        }
    }
}
