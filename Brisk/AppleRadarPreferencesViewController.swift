import AppKit

final class AppleRadarPreferencesViewController: NSViewController {
    @IBOutlet private var appleIDTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let (username, _) = Keychain.get(.Radar) {
            self.appleIDTextField.stringValue = username
        }
    }

    @IBAction private func logOut(sender: AnyObject) {
        Keychain.delete(.Radar)
        self.view.window?.close()
        StoryboardRouter.reloadTopWindowController()
    }
}
