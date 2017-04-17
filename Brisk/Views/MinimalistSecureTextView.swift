import AppKit

@IBDesignable
final class MinimalistSecureTextView: MinimalistTextView {

    override var usesSingleLineMode: Bool {
        get { return true }
        set {}
    }

    override var isAutomaticTextCompletionEnabled: Bool {
        get { return false }
        set {}
    }

    override var isAutomaticTextReplacementEnabled: Bool {
        get { return false }
        set {}
    }

    override var isAutomaticSpellingCorrectionEnabled: Bool {
        get { return false }
        set {}
    }

    private var secureText = ""

    override var string: String? {
        get { return self.secureText }
        set {
            self.secureText = newValue ?? ""
            super.string = (0 ..< self.secureText.characters.count).map { _ in "•" }.joined()
            self.didChangeText()
        }
    }

    override func cut(_ sender: Any?) {}
    override func copy(_ sender: Any?) {}

    override func shouldChangeText(in affectedCharRange: NSRange, replacementString: String?) -> Bool {
        self.string = (self.secureText as NSString).replacingCharacters(in: affectedCharRange,
                                                                        with: replacementString ?? "")
        return false
    }
}
