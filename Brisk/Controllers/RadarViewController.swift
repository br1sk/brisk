import AppKit
import Sonar

final class RadarViewController: ViewController {
    @IBOutlet fileprivate var actualTextView: NSTextField!
    @IBOutlet fileprivate var descriptionTextView: NSTextField!
    @IBOutlet fileprivate var expectedTextView: NSTextField!
    @IBOutlet fileprivate var notesTextView: NSTextField!
    @IBOutlet fileprivate var stepsTextView: NSTextField!
    @IBOutlet private var areaPopUp: NSPopUpButton!
    @IBOutlet private var classificationPopUp: NSPopUpButton!
    @IBOutlet private var configurationTextField: NSTextField!
    @IBOutlet private var productPopUp: NSPopUpButton!
    @IBOutlet private var progressIndicator: NSProgressIndicator!
    @IBOutlet private var reproducibilityPopUp: NSPopUpButton!
    @IBOutlet private var submitButton: NSButton!
    @IBOutlet private var titleTextField: NSTextField!
    @IBOutlet private var versionTextField: NSTextField!
    @IBOutlet private var addAttachmentButton: NSButton!
    @IBOutlet private var attachmentBadge: BadgeView!
    @IBOutlet private var trackersBadge: BadgeView!

    private var trackers: BugTrackers = [.appleRadar] {
        didSet { self.trackersBadge.number = self.trackers.count }
    }

    private var attachments: [Attachment] = [] {
        didSet {
            if oldValue != self.attachments {
                self.document?.updateChangeCount(.changeDone)
            }

            self.addAttachmentButton.isEnabled = self.attachments.isEmpty
            self.attachmentBadge.number = self.attachments.count
        }
    }

    private var validatables: [Validatable] {
        return [
            self.actualTextView,
            self.areaPopUp,
            self.classificationPopUp,
            self.configurationTextField,
            self.descriptionTextView,
            self.expectedTextView,
            self.notesTextView,
            self.productPopUp,
            self.reproducibilityPopUp,
            self.stepsTextView,
            self.titleTextField,
            self.versionTextField,
        ]
    }

    fileprivate var document: RadarDocument? {
        return self.windowController?.document as? RadarDocument
    }

    private var windowController: NSWindowController? {
        return self.view.window?.windowController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.areaPopUp.setItems(titles: Area.All.map { $0.name })
        self.classificationPopUp.setItems(titles: Classification.All.map { $0.name })
        self.reproducibilityPopUp.setItems(titles: Reproducibility.All.map { $0.name })
        self.productPopUp.set(items: Product.All, getTitle: { $0.name }, getGroup: { $0.category })
    }

    func restore(_ radar: Radar) {
        self.classificationPopUp.selectItem(withTitle: radar.classification.name)
        self.reproducibilityPopUp.selectItem(withTitle: radar.reproducibility.name)
        self.productPopUp.selectItem(withTitle: radar.product.name)
        if let area = radar.area {
            self.areaPopUp.selectItem(withTitle: area.name)
        }

        self.titleTextField.stringValue = radar.title
        self.descriptionTextView.stringValue = radar.description
        self.stepsTextView.stringValue = radar.steps
        self.expectedTextView.stringValue = radar.expected
        self.actualTextView.stringValue = radar.actual
        self.configurationTextField.stringValue = radar.configuration
        self.versionTextField.stringValue = radar.version
        self.notesTextView.stringValue = radar.notes
        self.attachments = radar.attachments

        self.enableSubmitIfValid()
    }

    func currentRadar() -> Radar {
        let product = Product.All.first { $0.name == self.productPopUp.selectedTitle }!
        let classification = Classification.All.first { $0.name == self.classificationPopUp.selectedTitle }!
        let reproducibility = Reproducibility.All
            .first { $0.name == self.reproducibilityPopUp.selectedTitle }!
        let area = Area.All.first { $0.name == self.areaPopUp.selectedTitle }!

        return Radar(
            classification: classification, product: product, reproducibility: reproducibility,
            title: self.titleTextField.stringValue,
            description: self.descriptionTextView.stringValue, steps: self.stepsTextView.stringValue,
            expected: self.expectedTextView.stringValue, actual: self.actualTextView.stringValue,
            configuration: self.configurationTextField.stringValue,
            version: self.versionTextField.stringValue, notes: self.notesTextView.stringValue,
            attachments: self.attachments, area: area
        )
    }

    // MARK: - Private Methods

    @IBAction private func submitRadar(_ sender: Any) {
        for field in self.validatables where !field.isValid {
            return
        }

        guard let (username, password) = Keychain.get(.radar) else {
            return self.showError(message: "Submitting radar without username/password")
        }

        var radar = self.currentRadar()
        self.submitButton.isEnabled = false
        self.progressIndicator.startAnimation(self)

        let completion: (Bool) -> Void = { [weak self] success in
            self?.progressIndicator.stopAnimation(self)
            self?.submitButton.isEnabled = true
            if success {
                if self?.document?.fileURL != nil {
                    self?.document?.save(self)
                }

                self?.view.window?.close()
            }
        }

        let appleRadar = Sonar(service: .appleRadar(appleID: username, password: password))
        appleRadar.loginThenCreate(
            radar: radar,
            getTwoFactorCode: { [weak self] closure in self?.askForTwoFactorCode(closure: closure) })
        { [weak self] result in
            switch result {
                case .success(let radarID):
                    if self?.trackers.contains(.openRadar) != true {
                        return completion(true)
                    }

                    guard let (_, token) = Keychain.get(.openRadar) else {
                        self?.showError(message: "Go to Preferences > Open Radar to set an openradar token")
                        return completion(false)
                    }

                    radar.ID = radarID
                    let openRadar = Sonar(service: .openRadar(token: token))
                    openRadar.loginThenCreate(
                        radar: radar, getTwoFactorCode: { closure in
                            assertionFailure("Didn't handle Open Radar two factor")
                            closure(nil)
                    }) { result in
                        switch result {
                            case .success:
                                completion(true)
                            case .failure(let error):
                                self?.showError(message: error.message)
                                completion(false)
                        }
                    }
                case .failure(let error):
                    self?.showError(message: error.message)
                    completion(false)
            }
        }
    }

    @IBAction private func showTrackers(_ sender: NSButton) {
        let controller = TrackersSelectorViewController.instantiate(withEnabledTrackers: self.trackers)
        controller.onSave = { trackers in self.trackers = trackers }
        self.presentViewControllerAsSheet(controller)
    }

    @IBAction private func productChanged(_ sender: NSPopUpButton) {
        let product = Product.All.first { $0.name == sender.selectedTitle }!
        self.areaPopUp.isEnabled = product.appleIdentifier == Product.iOS.appleIdentifier
    }

    @IBAction private func addAttachment(_ sender: NSButton) {
        guard let window = self.view.window else {
            return
        }

        let panel = NSOpenPanel()
        panel.beginSheetModal(for: window) { [weak panel] response in
            guard response == NSFileHandlingPanelOKButton, let url = panel?.urls.first else {
                return
            }

            do {
                let attachment = try Attachment(url: url)
                self.attachments = [attachment]
            } catch AttachmentError.invalidMimeType(let fileExtension) {
                self.showError(message: "Unknown MIME type for extension: '\(fileExtension)'")
            } catch let error {
                let alert = NSAlert(error: error)
                alert.beginSheetModal(for: window, completionHandler: nil)
            }
        }
    }

    private func showError(message: String) {
        guard let window = self.view.window else {
            return
        }

        let alert = NSAlert()
        alert.messageText = message
        alert.beginSheetModal(for: window, completionHandler: nil)
    }

    private func askForTwoFactorCode(closure: @escaping (String?) -> Void) {
        guard let window = self.view.window else {
            return
        }

        let alert = NSAlert()
        alert.messageText = "Enter two factor auth code"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let field = NSTextField(frame: NSRect(x: 0, y: 0, width: 100, height: 22))
        alert.accessoryView = field
        alert.beginSheetModal(for: window) { [weak self] response in
            if response == NSAlertFirstButtonReturn {
                if field.stringValue.isEmpty {
                    self?.askForTwoFactorCode(closure: closure)
                } else {
                    closure(field.stringValue)
                }
            } else {
                closure(nil)
            }
        }

        field.becomeFirstResponder()
    }

    fileprivate func enableSubmitIfValid() {
        let isValid = self.validatables.reduce(true) { valid, validatable in
            return valid && validatable.isValid
        }

        self.submitButton.isEnabled = isValid
    }

    fileprivate func updateTitleFromDocument() {
        let newTitle = self.titleTextField.stringValue
        self.document?.displayName = newTitle
        self.windowController?.synchronizeWindowTitleWithDocumentName()
    }
}

extension RadarViewController: NSTextFieldDelegate {

    override func controlTextDidChange(_ obj: Notification) {
        self.document?.updateChangeCount(.changeDone)
        self.textChanged()
    }

    private func textChanged() {
        self.enableSubmitIfValid()
        self.updateTitleFromDocument()
    }
}
