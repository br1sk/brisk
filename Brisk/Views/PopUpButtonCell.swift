import Cocoa

@IBDesignable
final class PopUpButtonCell: NSPopUpButtonCell {

    /// The color used to represent the selected item only when the popup is not shown.
    @IBInspectable var titleColor: NSColor = .black {
        didSet { self.synchronizeTitleAndSelectedItem() }
    }

    /// The color used to represent the selected item when the control is disabled.
    @IBInspectable var disableColor: NSColor = .gray {
        didSet { self.synchronizeTitleAndSelectedItem() }
    }

    // MARK: - NSPopUpButtonCell overrides

    override func drawTitle(_ title: NSAttributedString, withFrame frame: NSRect, in controlView: NSView)
        -> NSRect
    {
        let color = self.isEnabled ? self.titleColor : self.disableColor
        let attributed = NSMutableAttributedString(attributedString: title)
        attributed.addAttribute(NSForegroundColorAttributeName, value: color,
                                range: NSRange(location: 0, length: attributed.length))
        return super.drawTitle(attributed, withFrame: frame, in: controlView)
    }
}
