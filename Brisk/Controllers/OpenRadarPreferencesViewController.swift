import AppKit

private let kAPIKeyURL = URL(string: "https://openradar.appspot.com/apikey")!
private let kOpenRadarUsername = "openradar"

final class OpenRadarPreferencesViewController: ViewController {
    @IBOutlet private var APIKeyTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let (_, password) = Keychain.get(.openRadar) {
            self.APIKeyTextField.stringValue = password
        }

        self.APIKeyTextField.becomeFirstResponder()
    }

    @IBAction private func getAPIKey(_ sender: Any) {
        NSWorkspace.shared.open(kAPIKeyURL)
    }

    fileprivate func saveCurrentToken() {
        let token = self.APIKeyTextField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if token.isEmpty {
            Keychain.delete(.openRadar)
        } else {
            Keychain.set(username: kOpenRadarUsername, password: token, forKey: .openRadar)
        }
    }
}

extension OpenRadarPreferencesViewController: NSTextFieldDelegate {
    func controlTextDidEndEditing(_: Notification) {
        if self.view.window?.isKeyWindow == true {
            self.saveCurrentToken()
        }
    }
}
