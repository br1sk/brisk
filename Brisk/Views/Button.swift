import AppKit

private enum ButtonState {
    case highlighted, disabled, normal

    init(whenEnabled enabled: Bool, highlighted: Bool) {
        if !enabled {
            self = .disabled
        } else {
            self = highlighted ? .highlighted : .normal
        }
    }
}

@IBDesignable
final class Button: NSButton {

    // MARK: - Inspectables

    /// Defines the radius that will be use to round the corners of the button (only when bg color is set).
    @IBInspectable var borderRadius: CGFloat = 0.0 {
        didSet { self.setNeedsDisplay() }
    }

    /// Defines the color that will be use to render the button's background.
    @IBInspectable var backgroundColor: NSColor? {
        didSet { self.setNeedsDisplay() }
    }

    /// Defines the color that will be use to render the button's title.
    @IBInspectable var textColor: NSColor = .black {
        didSet {
            let attributed = NSMutableAttributedString(attributedString: self.attributedTitle)
            attributed.addAttribute(NSForegroundColorAttributeName, value: self.textColor,
                                    range: NSRange(location: 0, length: attributed.length))
            self.attributedTitle = attributed
        }
    }

    // MARK: - Private methods

    private func backgroundColorForCurrentState() -> NSColor? {
        guard let color = self.backgroundColor else {
            return nil
        }

        switch ButtonState(whenEnabled: self.isEnabled, highlighted: self.isHighlighted) {
        case .highlighted:
            return color.colorByAddingBrightness(-0.2)

        case .disabled:
            return color.colorByAddingBrightness(0.15, andSaturationFactor: 0.4, brightnessCap: 0.70)

        case .normal:
            return color
        }
    }

    // MARK: - NSButton Overrides

    override func draw(_ dirtyRect: NSRect) {
        guard let color = self.backgroundColorForCurrentState() else {
            return super.draw(dirtyRect)
        }

        let border = NSBezierPath(roundedRect: dirtyRect, xRadius: self.borderRadius,
                                  yRadius: self.borderRadius)
        color.set()
        border.fill()

        // Draw button title
        let title = self.title as NSString
        let attributed = self.attributedTitle.attributes(at: 0, effectiveRange: nil)
        let rect = title.boundingRect(with: dirtyRect.size, options: .usesLineFragmentOrigin,
                                      attributes: attributed)
        var textRect = dirtyRect
        textRect.origin.y = (dirtyRect.height / 2) - (rect.height / 2)
        title.draw(in: textRect, withAttributes: attributed)
    }
}
