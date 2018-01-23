import AppKit

final class TextView: NSTextView {
    @IBInspectable var placeholderString: String?

    // Show a placeholder using the private API from NSTextView
    // https://stackoverflow.com/a/43028577/902968
    @objc
    private var placeholderAttributedString: NSAttributedString? {
        return self.placeholderString.map(NSAttributedString.init)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
    }

    override func doCommand(by selector: Selector) {
        switch selector {
        case #selector(TextView.insertTab(_:)):
            self.window?.selectNextKeyView(self)
        case #selector(TextView.insertBacktab(_:)):
            self.window?.selectPreviousKeyView(self)
        case #selector(NSWindow.selectNextKeyView(_:)):
            super.doCommand(by: #selector(TextView.insertTab(_:)))
        case #selector(NSWindow.selectPreviousKeyView(_:)):
            super.doCommand(by: #selector(TextView.insertBacktab(_:)))
        default:
            super.doCommand(by: selector)
        }
    }
}
