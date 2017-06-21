import AppKit

extension NSProgressIndicator {
    var isLoading: Bool {
        set(loading) {
            if loading {
                self.startAnimation(nil)
            } else {
                self.stopAnimation(nil)
            }
        }

        get {
            assertionFailure("This value is bogus")
            return false
        }
    }
}
