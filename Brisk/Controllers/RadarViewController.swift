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

    private var document: RadarDocument? {
        return self.windowController?.document as? RadarDocument
    }

    private var windowController: NSWindowController? {
        return self.view.window?.windowController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTextViewDelegates()
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
        self.descriptionTextView.string = radar.description
        self.stepsTextView.string = radar.steps
        self.expectedTextView.string = radar.expected
        self.actualTextView.string = radar.actual
        self.configurationTextField.stringValue = radar.configuration
        self.versionTextField.stringValue = radar.version
        self.notesTextView.string = radar.notes

        self.enableSubmitIfValid()
    }

    func currentRadar() -> Radar {
        let product = Product.All.find { $0.name == self.productPopUp.selectedTitle }!
        let classification = Classification.All.find { $0.name == self.classificationPopUp.selectedTitle }!
        let reproducibility = Reproducibility.All.find { $0.name == self.reproducibilityPopUp.selectedTitle }!
        let area = Area.All.find { $0.name == self.areaPopUp.selectedTitle }!
        return Radar(
            classification: classification, product: product, reproducibility: reproducibility,
            title: self.titleTextField.stringValue,
            description: self.descriptionTextView.stringValue, steps: self.stepsTextView.stringValue,
            expected: self.expectedTextView.stringValue, actual: self.actualTextView.stringValue,
            configuration: self.configurationTextField.stringValue,
            version: self.versionTextField.stringValue, notes: self.notesTextView.stringValue, area: area
        )
    }

    // MARK: - Private Methods

    @IBAction private func submitRadar(sender: AnyObject) {
        for field in self.validatables {
            if !field.isValid {
                return
            }
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
                self?.document?.save(self)
                self?.view.window?.close()
            }
        }

        let appleRadar = Sonar(service: .AppleRadar(appleID: username, password: password))
        appleRadar.loginThenCreate(radar: radar) { [weak self] result in
            switch result {
                case .success(let radarID):
                    guard let (_, token) = Keychain.get(.openRadar) else {
                        return completion(true)
                    }

                    radar.ID = radarID
                    let openRadar = Sonar(service: .OpenRadar(token: token))
                    openRadar.loginThenCreate(radar: radar) { result in
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

    @IBAction private func productChanged(sender: NSPopUpButton) {
        let product = Product.All.find { $0.name == sender.selectedTitle }!
        self.areaPopUp.isEnabled = product.appleIdentifier == Product.iOS.appleIdentifier
    }

    private func showError(message: String) {
        guard let window = self.view.window else {
            return
        }

        let alert = NSAlert()
        alert.messageText = message
        alert.beginSheetModal(for: window, completionHandler: nil)
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
