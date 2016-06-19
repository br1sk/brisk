import AppKit

private let kAPIKeyURL = NSURL(string: "https://openradar.appspot.com/apikey")!
private let kOpenRadarUsername = "openradar"

final class OpenRadarPreferencesViewController: ViewController {
    @IBOutlet private var APIKeyTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let (_, password) = Keychain.get(.OpenRadar) {
            self.APIKeyTextField.stringValue = password
        }

        self.APIKeyTextField.becomeFirstResponder()
    }

    @IBAction private func getAPIKey(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(kAPIKeyURL)
    }

    private func saveCurrentToken() {
        let token = self.APIKeyTextField.stringValue
        Keychain.set(username: kOpenRadarUsername, password: token, forKey: .OpenRadar)
    }
}

extension OpenRadarPreferencesViewController: NSTextFieldDelegate {
    override func controlTextDidEndEditing(obj: NSNotification) {
        if self.view.window?.keyWindow == true {
            self.saveCurrentToken()
        }
    }
}
