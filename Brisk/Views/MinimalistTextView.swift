import Cocoa

final class MinimalistTextScrollView: NSScrollView {

    override var intrinsicContentSize: NSSize {
        let editors = self.contentView.subviews.flatMap { $0 as? MinimalistTextView }
        guard let editor = editors.first else {
            return super.intrinsicContentSize
        }

        return editor.intrinsicContentSize
    }
}

@IBDesignable
class MinimalistTextView: NSTextView {

    // MARK: - Inspectable values

    /// The title that will be shown on the top-left of the field.
    @IBInspectable public var placeholder: String = "" {
        didSet { self.setNeedsDisplay(self.bounds) }
    }

    /// The textview will stop growing after this value is reached.
    @IBInspectable var maxHeight: CGFloat = 75.0

    /// This property forces the field to be single-lined (return will focus next field).
    @IBInspectable var usesSingleLineMode: Bool = false

    /// The space between the left edge and the text container.
    @IBInspectable var leftMargin: CGFloat = 0.0

    /// A boolean that defines the placeholder behavior (title won't dissapear even when text is not empty).
    @IBInspectable var placeholderIsTitle: Bool = false

    /// Defines the margin between the bottom line and the baseline of the text.
    @IBInspectable var lineMargin: CGFloat = 9.0

    /// Defines the color for the bottom line when the field is not selected.
    @IBInspectable var lineColor: NSColor = .moon {
        didSet { self.setLineColor(isFirstResponder: self.isFirstResponder) }
    }

    /// Defines the color for the bottom line when the field is selected.
    @IBInspectable var lineSelectedColor: NSColor = .steel {
        didSet { self.setLineColor(isFirstResponder: self.isFirstResponder) }
    }

    /// Defines the color for the placeholder text when the field is selected.
    @IBInspectable var placeholderColor: NSColor = .moon {
        didSet { self.setLineColor(isFirstResponder: self.isFirstResponder) }
    }

    /// Defines the color for the placeholder text when the field is not selected.
    @IBInspectable var placeholderSelectedColor: NSColor = .moon {
        didSet { self.setLineColor(isFirstResponder: self.isFirstResponder) }
    }

    // MARK: - Private methods & Properties

    private var line = View(frame: .zero)
    private var isFirstResponder: Bool {
        return self.window?.firstResponder == self
    }

    private func colors(whenStateIsSelected selected: Bool) -> (line: NSColor, placeholder: NSColor) {
        return (
            line: selected ? self.lineSelectedColor : self.lineColor,
            placeholder: selected ? self.placeholderSelectedColor : self.placeholderColor
        )
    }

    private func setLineColor(isFirstResponder: Bool) {
        let (line, _) = self.colors(whenStateIsSelected: isFirstResponder)
        self.line.backgroundColor = line
    }

    private func setupLineView() {
        let scrollView = self.enclosingScrollView!

        let bottom = NSLayoutConstraint(item: self.line, attribute: .bottom, relatedBy: .equal,
                                        toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: self.line, attribute: .left, relatedBy: .equal,
                                      toItem: scrollView, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self.line, attribute: .right, relatedBy: .equal,
                                       toItem: scrollView, attribute: .right, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: self.line, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        scrollView.addSubview(self.line)
        scrollView.addConstraints([bottom, left, right, height])
        self.line.translatesAutoresizingMaskIntoConstraints = false

    }

    // MARK: - TextFieldView override

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        if self.placeholderIsTitle || self.string?.isEmpty != false, let font = self.font {
            let (_, placholder) = self.colors(whenStateIsSelected: self.isFirstResponder)
            let contentView = self.enclosingScrollView?.contentView
            let title = self.placeholder as NSString
            let attributes: [String: Any] = [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: placholder
            ]

            var textRect = dirtyRect
            textRect.origin.y = contentView?.documentVisibleRect.origin.y ?? 0.0
            textRect.origin.x = (self.placeholderIsTitle ? 0 : self.leftMargin) + 5
            title.draw(in: textRect, withAttributes: attributes)
        }
    }

    override var textContainerOrigin: NSPoint {
        let origin = super.textContainerOrigin
        return NSPoint(x: origin.x + self.leftMargin, y: origin.y)
    }

    override var intrinsicContentSize: NSSize {
        guard let container = self.textContainer, let manager = self.layoutManager else {
            return super.intrinsicContentSize
        }

        manager.ensureLayout(for: container)
        let height = manager.usedRect(for: container).height + self.lineMargin + self.textContainerOrigin.y
        return NSSize(width: -1, height: min(height, self.maxHeight))
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // This is a workaround for an Interface Builder bug that was around for years (you can't set the font
        // and text color when the text is empty).
        if !self.attributedString().string.isEmpty {
            let attributes = self.attributedString().attributes(at: 0, effectiveRange: nil)
            self.font = attributes[NSFontAttributeName] as? NSFont
            self.textColor = attributes[NSForegroundColorAttributeName] as? NSColor
            self.string = ""
        }

        self.setupLineView()
        self.setLineColor(isFirstResponder: self.isFirstResponder)
    }

    override func becomeFirstResponder() -> Bool {
        self.setLineColor(isFirstResponder: true)
        self.insertionPointColor = self.textColor ?? .moon
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        self.setLineColor(isFirstResponder: false)
        self.setNeedsDisplay(self.bounds)
        return super.resignFirstResponder()
    }

    override func didChangeText() {
        super.didChangeText()
        self.enclosingScrollView?.invalidateIntrinsicContentSize()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.awakeFromNib()
    }

    override func doCommand(by selector: Selector) {
        switch selector.description {
        case "insertNewline:":
            if self.usesSingleLineMode {
                self.window?.selectNextKeyView(self)
                return
            }

            super.doCommand(by: selector)

        case "insertTab:":
            self.window?.selectNextKeyView(self)
            
        case "insertBacktab:":
            self.window?.selectPreviousKeyView(self)
            
        default:
            super.doCommand(by: selector)
        }
    }
}
