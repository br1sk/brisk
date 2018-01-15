import AppKit

extension NSTextView: Validatable {
    var isValid: Bool {
        return !self.string.isEmpty
    }
}
