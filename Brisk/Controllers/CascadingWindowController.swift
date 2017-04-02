import AppKit

final class CascadingWindowController: NSWindowController {
    override var shouldCascadeWindows: Bool {
        get { return true }
        set { super.shouldCascadeWindows = newValue }
    }
}
