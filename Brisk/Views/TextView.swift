import AppKit

final class TextView: NSTextView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize())
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
