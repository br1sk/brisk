import AppKit

final class AppleRadarPreferencesViewController: ViewController {
    @IBOutlet private var appleIDTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let (username, _) = Keychain.get(.radar) {
            self.appleIDTextField.stringValue = username
        }
    }

    @IBAction private func logOut(sender: AnyObject) {
        Keychain.delete(.radar)
        self.view.window?.close()
        StoryboardRouter.reloadTopWindowController()
    }
}
