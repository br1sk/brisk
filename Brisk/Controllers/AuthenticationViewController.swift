import AppKit

final class AuthenticationViewController: ViewController {
    @IBOutlet private var loginButton: NSButton!
    @IBOutlet private var appleIDTextField: NSTextView!
    @IBOutlet private var passwordTextField: NSTextView!

    private var validatables: [Validatable] {
        return [
            self.appleIDTextField,
            self.passwordTextField,
        ]
    }

    var userDidLogin: (() -> Void)?

    override func viewDidAppear() {
        super.viewDidAppear()
        self.appleIDTextField.becomeFirstResponder()
    }

    // MARK: - Private Methods

    @IBAction private func login(_ sender: Any) {
        let username = self.appleIDTextField.stringValue
        let password = self.passwordTextField.stringValue
        Keychain.set(username: username, password: password, forKey: .radar)
        StoryboardRouter.reloadTopWindowController()
        NSDocumentController.shared().newDocument(self)
    }

    fileprivate func enableLoginIfValid() {
        let isValid = self.validatables.reduce(true) { valid, validatable in
            return valid && validatable.isValid
        }

        self.loginButton.isEnabled = isValid
    }
}

extension AuthenticationViewController {
    override func controlTextDidChange(_: Notification) {
        self.enableLoginIfValid()
    }
}
