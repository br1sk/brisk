import AppKit
import Sonar

final class RadarViewController: ViewController {
    @IBOutlet fileprivate var actualTextView: NSTextView!
    @IBOutlet fileprivate var descriptionTextView: NSTextView!
    @IBOutlet fileprivate var expectedTextView: NSTextView!
    @IBOutlet fileprivate var notesTextView: NSTextView!
    @IBOutlet fileprivate var stepsTextView: NSTextView!
    @IBOutlet private var areaPopUp: NSPopUpButton!
    @IBOutlet private var classificationPopUp: NSPopUpButton!
    @IBOutlet private var configurationTextField: NSTextField!
    @IBOutlet private var productPopUp: NSPopUpButton!
    @IBOutlet private var progressIndicator: NSProgressIndicator!
    @IBOutlet private var reproducibilityPopUp: NSPopUpButton!
    @IBOutlet private var submitButton: NSButton!
    @IBOutlet private var titleTextField: NSTextField!
    @IBOutlet private var versionTextField: NSTextField!
    @IBOutlet private var toggleAttachmentButton: NSButton!
    @IBOutlet private var attachmentTextField: NSTextField!
    @IBOutlet private var postToOpenRadarButton: NSButton!

    private var attachments: [Attachment] = [] {
        didSet {
            if oldValue != self.attachments {
                self.document?.updateChangeCount(.changeDone)
            }

            let attachment = self.attachments.first
            self.toggleAttachmentButton.title = attachment == nil ? "Add Attachment" : "Remove Attachment"
            self.attachmentTextField.stringValue = attachment?.filename ?? "No Attachment"
        }
    }

    private var validatables: [Validatable] {
        return [
            self.actualTextView,
            self.classificationPopUp,
            self.descriptionTextView,
            self.expectedTextView,
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

        self.setupTextViewDelegates()
        self.classificationPopUp.setItems(titles: Classification.All.map { $0.name })
        self.reproducibilityPopUp.setItems(titles: Reproducibility.All.map { $0.name })
        self.productPopUp.set(items: Product.All, getTitle: { $0.name }, getGroup: { $0.category })

        let product = Product.All.first { $0.name == self.productPopUp.selectedTitle }!
        self.updateAreas(with: product)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.delegate = self
    }

    func restore(_ radar: Radar) {
        if self.document?.fileURL == nil {
            self.document?.updateChangeCount(.changeDone)
        }

        self.classificationPopUp.selectItem(withTitle: radar.classification.name)
        self.reproducibilityPopUp.selectItem(withTitle: radar.reproducibility.name)
        self.productPopUp.selectItem(withTitle: radar.product.name)
        self.updateAreas(with: radar.product)
        if let area = radar.area {
            self.areaPopUp.selectItem(withTitle: area.name)
        }

        self.titleTextField.stringValue = radar.title
        self.descriptionTextView.string = radar.description
        self.stepsTextView.string = radar.steps
        self.expectedTextView.string = radar.expected
        self.actualTextView.string = radar.actual
        self.configurationTextField.stringValue = radar.configuration
        self.versionTextField.stringValue = radar.version
        self.notesTextView.string = radar.notes
        self.attachments = radar.attachments

        self.enableSubmitIfValid()
        self.updateTitleFromDocument()
        self.document?.updateChangeCount(.changeCleared)
    }

    func currentRadar() -> Radar {
        let product = Product.All.first { $0.name == self.productPopUp.selectedTitle }!
        let classification = Classification.All.first { $0.name == self.classificationPopUp.selectedTitle }!
        let reproducibility = Reproducibility.All
            .first { $0.name == self.reproducibilityPopUp.selectedTitle }!
        let area = Area.areas(for: product).first { $0.name == self.areaPopUp.selectedTitle }

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
            assertionFailure("Shouldn't be able to submit with invalid fields")
            return self.showError(message: "Validation failed")
        }

        guard let (username, password) = Keychain.get(.radar) else {
            assertionFailure("Shouldn't be able to submit a radar without credentials")
            return self.showError(message: "Submitting radar without username/password")
        }

        var radar = self.currentRadar()
        self.submitButton.isEnabled = false
        self.progressIndicator.startAnimation(self)

        let appleRadar = Sonar(service: .appleRadar(appleID: username, password: password))
        appleRadar.loginThenCreate(
            radar: radar,
            getTwoFactorCode: { [weak self] closure in self?.askForTwoFactorCode(closure: closure) })
        { [weak self] result in
            switch result {
                case .success(let radarID):
                    guard self?.postToOpenRadarButton.state == NSOnState,
                        let (_, token) = Keychain.get(.openRadar) else
                    {
                        self?.submitRadarCompletion(success: true)
                        return
                    }

                    radar.ID = radarID
                    let openRadar = Sonar(service: .openRadar(token: token))
                    openRadar.loginThenCreate(
                        radar: radar, getTwoFactorCode: { closure in
                            assertionFailure("Didn't handle Open Radar two factor")
                            closure(nil)
                    }) { [weak self] result in
                        switch result {
                            case .success:
                                self?.submitRadarCompletion(success: true)
                            case .failure(let error):
                                self?.showError(message: error.message)
                                self?.submitRadarCompletion(success: false)
                        }
                    }
                case .failure(let error):
                    self?.showError(message: error.message)
                    self?.submitRadarCompletion(success: false)
            }
        }
    }

    @IBAction private func productChanged(_ sender: NSPopUpButton) {
        let product = Product.All.first { $0.name == sender.selectedTitle }!
        self.updateAreas(with: product)
    }

    @IBAction private func toggleAttachment(_ sender: NSButton) {
        if !self.attachments.isEmpty {
            self.attachments = []
            return
        }

        guard let window = self.view.window else {
            assertionFailure("Adding attachment with no window")
            return
        }

        self.addAttachment(to: window)
    }

    private func addAttachment(to window: NSWindow) {
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

    private func submitRadarCompletion(success: Bool) {
        self.progressIndicator.stopAnimation(self)
        self.submitButton.isEnabled = true

        if success {
            if self.document?.fileURL != nil {
                self.document?.save(self)
            }

            self.document?.close()
        }
    }

    private func updateAreas(with product: Product) {
        let areaNames = Area.areas(for: product).map { $0.name }
        self.areaPopUp.setItems(titles: areaNames)
        self.areaPopUp.isEnabled = !areaNames.isEmpty
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

    fileprivate func updateOpenRadarButton() {
        let canPostToOpenRadar = Keychain.get(.openRadar) != nil
        self.postToOpenRadarButton.isEnabled = canPostToOpenRadar
        self.postToOpenRadarButton.toolTip = canPostToOpenRadar ? nil : "Open Preferences to add an account"

        if !canPostToOpenRadar {
            self.postToOpenRadarButton.state = NSOffState
        }
    }

    fileprivate func enableSubmitIfValid() {
        let isValid = self.validatables.reduce(true) { valid, validatable in
            return valid && validatable.isValid
        }

        self.submitButton.isEnabled = isValid
    }

    fileprivate func updateTitleFromDocument() {
        let title = self.titleTextField.stringValue
        if title.isEmpty {
            return
        }

        self.document?.displayName = title
        self.windowController?.synchronizeWindowTitleWithDocumentName()
    }
}

extension RadarViewController: NSTextViewDelegate {
    private var textViews: [NSTextView] {
        return [
            self.actualTextView,
            self.descriptionTextView,
            self.expectedTextView,
            self.notesTextView,
            self.stepsTextView,
        ]
    }

    override func controlTextDidChange(_ obj: Notification) {
        self.document?.updateChangeCount(.changeDone)
        self.textChanged()
    }

    func textDidChange(_ notification: Notification) {
        self.textChanged()
    }

    private func textChanged() {
        self.enableSubmitIfValid()
        self.updateTitleFromDocument()
    }

    fileprivate func setupTextViewDelegates() {
        for textView in self.textViews {
            textView.delegate = self
        }
    }
}

extension RadarViewController: NSWindowDelegate {
    func windowDidBecomeKey(_ notification: Notification) {
        self.updateOpenRadarButton()
    }
}
