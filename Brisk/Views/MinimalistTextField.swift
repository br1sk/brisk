import Cocoa

@IBDesignable
final class MinimalistTextField: NSTextField {

    // MARK: - Inspectable values

    /// Defines the margin between the bottom line and the baseline of the text.
    @IBInspectable var lineMargin: CGFloat = 9.0 {
        didSet { self.invalidateIntrinsicContentSize() }
    }

    /// Defines the color for the bottom line when the field is not selected.
    @IBInspectable var lineColor: NSColor = .moon {
        didSet { self.setCurrentStateColors(isFirstResponder: self.isFirstResponder) }
    }

    /// Defines the color for the bottom line when the field is selected.
    @IBInspectable var lineSelectedColor: NSColor = .steel {
        didSet { self.setCurrentStateColors(isFirstResponder: self.isFirstResponder) }
    }

    /// Defines the color for the placeholder text when the field is selected.
    @IBInspectable var placeholderColor: NSColor = .moon {
        didSet { self.setCurrentStateColors(isFirstResponder: self.isFirstResponder) }
    }

    /// Defines the color for the placeholder text when the field is not selected.
    @IBInspectable var placeholderSelectedColor: NSColor = .moon {
        didSet { self.setCurrentStateColors(isFirstResponder: self.isFirstResponder) }
    }

    // MARK: - Private methods & Properties

    private var becomingFirstResponder = false
    private var line = View(frame: .zero)
    private var isFirstResponder: Bool {
        return (self.window?.firstResponder as? NSView)?.isDescendant(of: self) == true
    }

    private func colors(whenStateIsSelected selected: Bool) -> (line: NSColor, placeholder: NSColor) {
        return (
            line: selected ? self.lineSelectedColor : self.lineColor,
            placeholder: selected ? self.placeholderSelectedColor : self.placeholderColor
        )
    }

    private func setCurrentStateColors(isFirstResponder: Bool) {
        let (line, placeholder) = self.colors(whenStateIsSelected: isFirstResponder)
        let string = self.placeholderString ?? self.placeholderAttributedString?.string ?? ""
        let attributes: [String: Any] = [
            NSFontAttributeName: self.font ?? NSFont.systemFont(ofSize: 1.0),
            NSForegroundColorAttributeName: placeholder,
        ]
        self.placeholderAttributedString = NSAttributedString(string: string, attributes: attributes)
        self.line.backgroundColor = line
    }

    private func setupLineView() {
        let bottom = NSLayoutConstraint(item: self.line, attribute: .bottom, relatedBy: .equal,
                                        toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: self.line, attribute: .left, relatedBy: .equal,
                                      toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self.line, attribute: .right, relatedBy: .equal,
                                       toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: self.line, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        self.addSubview(self.line)
        self.addConstraints([bottom, left, right, height])
        self.line.translatesAutoresizingMaskIntoConstraints = false
    }

    private func height(for text: String) -> CGFloat {
        let attributes = [NSFontAttributeName: self.font ?? NSFont.systemFont(ofSize: 1.0)]

        let bound = CGSize(width: self.frame.width - 5, height: CGFloat.infinity)
        let frame = text.boundingRect(with: bound, options: .usesLineFragmentOrigin, attributes: attributes)
        return frame.height + self.lineMargin
    }

    // MARK: - TextField overrides

    override var alignmentRectInsets: EdgeInsets {
        return EdgeInsets(top: 0, left: 0, bottom: self.lineMargin, right: 0)
    }

    override var intrinsicContentSize: NSSize {
        return NSSize(width: -1, height: self.height(for: self.stringValue))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupLineView()

        self.setCurrentStateColors(isFirstResponder: self.isFirstResponder)
    }

    override func becomeFirstResponder() -> Bool {
        // textDidEndEditing will be called in the process of becomingFirstResponder, making the logic for
        // highlighting tricky. We'll keep track of the execution here to avoid invalid highlights.
        self.becomingFirstResponder = true
        defer {
            (self.currentEditor() as? NSTextView)?.insertionPointColor = .moon
            self.becomingFirstResponder = false
        }

        self.setCurrentStateColors(isFirstResponder: true)
        return super.becomeFirstResponder()
    }

    override func textDidEndEditing(_ notification: Notification) {
        if !self.becomingFirstResponder {
            self.setCurrentStateColors(isFirstResponder: false)
        }
        super.textDidEndEditing(notification)
    }

    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        self.invalidateIntrinsicContentSize()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.awakeFromNib()
    }
}

extension MinimalistTextField: NSTextViewDelegate {
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector.description == "insertNewline:" {
            if !self.usesSingleLineMode {
                textView.insertNewlineIgnoringFieldEditor(self)
            } else {
                textView.insertTab(self)
            }

            return true
        }

        return false
    }
}
