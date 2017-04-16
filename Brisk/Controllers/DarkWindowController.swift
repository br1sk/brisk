import AppKit

final class DarkWindow: NSWindow {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.titleVisibility = .hidden
    }
}
