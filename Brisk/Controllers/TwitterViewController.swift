import Accounts
import AppKit
import Sonar

final class TwitterViewController: ViewController {
    @IBOutlet private var twitterEnabledCheckBox: NSButton!
    @IBOutlet private var formatTextView: NSTextView!
    @IBOutlet private var disableDuplicatesCheckBox: NSButton!

    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.formatTextView.string = UserDefaults.standard.string(forKey: Defaults.twitterFormat) ?? ""
        let tweetDuplicates = UserDefaults.standard.bool(forKey: Defaults.tweetDuplicates)
        self.disableDuplicatesCheckBox.state = tweetDuplicates ? NSOffState : NSOnState
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        UserDefaults.standard.set(self.formatTextView.stringValue, forKey: Defaults.twitterFormat)
        Radar.shortDescriptionFormat = self.formatTextView.string
    }

    @IBAction private func disableDuplicatesChanged(sender: NSButton) {
        let tweetDuplicates = sender.state == NSOnState
        UserDefaults.standard.set(tweetDuplicates, forKey: Defaults.tweetDuplicates)
    }

    @IBAction private func toggleTwitter(sender: NSButton) {
        if sender.state == NSOnState {
            self.enableTwitter()
        } else {
            self.disableTwitter()
        }
    }

    private func enableTwitter() {
        let account = ACAccountStore()
        let accountType = account.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)

        account.requestAccessToAccounts(with: accountType, options: nil) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.formatTextView.isEditable = true
                    self.disableDuplicatesCheckBox.isEnabled = true
                } else {
                    self.disableTwitter()
                }
            }
        }
    }

    private func disableTwitter() {
        self.twitterEnabledCheckBox.state = NSOffState
        self.disableDuplicatesCheckBox.isEnabled = false
        self.formatTextView.isEditable = false
    }
}
