import AppKit

extension NSTextView {
    var stringValue: String {
        return self.string
    }
}

extension NSTextView: Validatable {
    var isValid: Bool {
        return self.string.isEmpty == false
    }
}
