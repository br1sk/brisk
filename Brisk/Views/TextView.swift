import AppKit

final class TextView: NSTextView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize())
    }
}
