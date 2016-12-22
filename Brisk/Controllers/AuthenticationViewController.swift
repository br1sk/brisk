import AppKit

final class AuthenticationViewController: ViewController {
    @IBOutlet private var loginButton: NSButton!
    @IBOutlet private var appleIDTextField: NSTextField!
    @IBOutlet private var passwordTextField: NSSecureTextField!

    private var validatables: [Validatable] {
        return [
            self.appleIDTextField,
            self.passwordTextField,
        ]
    }

    var userDidLogin: (() -> Void)?

    override func viewWillAppear() {
        super.viewWillAppear()
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

    private func enableInterface(enable: Bool) {
        self.loginButton.isEnabled = enable
        self.appleIDTextField.isEnabled = enable
        self.passwordTextField.isEnabled = enable
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
