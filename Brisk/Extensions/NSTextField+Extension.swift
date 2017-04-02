import AppKit

extension NSTextField: Validatable {
    var isValid: Bool {
        return !self.stringValue.isEmpty
    }
}
