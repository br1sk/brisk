import AppKit

@IBDesignable
final class BadgeView: NSView {

    @IBOutlet private var label: NSTextField!

    /// The number of items the badge is indicating (when 0 the badge will be hidden).
    @IBInspectable var number: Int {
        get { return self.label.integerValue }
        set {
            self.label?.integerValue = newValue
            self.isHidden = newValue == 0
        }
    }
}
