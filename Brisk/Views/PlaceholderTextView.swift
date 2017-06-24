import AppKit

final class PlaceholderTextView: TextView {
    @IBInspectable var placeholderString: String?

    // Show a placeholder using the private API from NSTextView
    // https://stackoverflow.com/a/43028577/902968
    @objc
    private var placeholderAttributedString: NSAttributedString? {
        return self.placeholderString.map(NSAttributedString.init)
    }
}
