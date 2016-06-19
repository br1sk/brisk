import AppKit

final class AuthenticationViewController: NSViewController {
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

    @IBAction private func login(sender: AnyObject) {
        let username = self.appleIDTextField.stringValue
        let password = self.passwordTextField.stringValue
        Keychain.set(username: username, password: password, forKey: .Radar)
        self.userDidLogin?()
    }

    private func enableInterface(enable: Bool) {
        self.loginButton.enabled = enable
        self.appleIDTextField.enabled = enable
        self.passwordTextField.enabled = enable
    }

    private func enableLoginIfValid() {
        let isValid = self.validatables.reduce(true) { valid, validatable in
            return valid && validatable.isValid
        }

        self.loginButton.enabled = isValid
    }
}

extension AuthenticationViewController {
    override func controlTextDidChange(obj: NSNotification) {
        self.enableLoginIfValid()
    }
}
