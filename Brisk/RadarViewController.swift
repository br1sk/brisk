import AppKit
import Sonar

private let kSonar = Sonar()

final class RadarViewController: ViewController {
    @IBOutlet private var actualTextView: NSTextView!
    @IBOutlet private var areaPopUp: NSPopUpButton!
    @IBOutlet private var classificationPopUp: NSPopUpButton!
    @IBOutlet private var configurationTextField: NSTextField!
    @IBOutlet private var descriptionTextView: NSTextView!
    @IBOutlet private var expectedTextView: NSTextView!
    @IBOutlet private var notesTextView: NSTextView!
    @IBOutlet private var productPopUp: NSPopUpButton!
    @IBOutlet private var reproducibilityPopUp: NSPopUpButton!
    @IBOutlet private var stepsTextView: NSTextView!
    @IBOutlet private var submitButton: NSButton!
    @IBOutlet private var titleTextField: NSTextField!
    @IBOutlet private var versionTextField: NSTextField!
    @IBOutlet private var progressIndicator: NSProgressIndicator!

    private var products = [Product]()
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTextViewDelegates()
        self.areaPopUp.setItemsWithTitles(Area.All.map { $0.name })
        self.classificationPopUp.setItemsWithTitles(Classification.All.map { $0.name })
        self.reproducibilityPopUp.setItemsWithTitles(Reproducibility.All.map { $0.name })

        let (username, password) = Keychain.get(.Radar)!
        kSonar.login(withAppleID: username, password: password) { [weak self] result in
            print(result)
            switch result {
            case .Success(let products):
                self?.products = products
                self?.productPopUp.setItemsWithTitles(products.map { $0.name })
            case .Failure(let error):
                self?.showErrorWithMessage(error.message)
            }
        }
    }

    // MARK: - Private Methods

    @IBAction private func submitRadar(sender: AnyObject) {
        guard let radar = self.currentRadar() else {
            return
        }

        self.submitButton.enabled = false
        self.progressIndicator.startAnimation(self)

        kSonar.create(radar: radar) { [weak self] result in
            switch result {
            case .Success(let radarID):
                print("Submtited radar \(radarID)")
                NSPasteboard.generalPasteboard().writeObjects([String(radarID)])
                self?.view.window?.close()
            case .Failure(let error):
                self?.showErrorWithMessage(error.message)
            }

            self?.progressIndicator.stopAnimation(self)
            self?.submitButton.enabled = true
        }
    }

    private func showErrorWithMessage(message: String) {
        if let window = self.view.window {
            let alert = NSAlert()
            alert.messageText = message
            alert.beginSheetModalForWindow(window, completionHandler: nil)
        }
    }

    private func currentRadar() -> Radar? {
        for field in self.validatables {
            if !field.isValid {
                return nil
            }
        }

        let product = self.products.find { $0.name == self.productPopUp.selectedTitle }!
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

    private func enableSubmitIfValid() {
        let isValid = self.validatables.reduce(true) { valid, validatable in
            return valid && validatable.isValid
        }

        self.submitButton.enabled = isValid
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

    override func controlTextDidChange(obj: NSNotification) {
        self.enableSubmitIfValid()
    }

    func textDidChange(notification: NSNotification) {
        self.enableSubmitIfValid()
    }

    private func setupTextViewDelegates() {
        for textView in self.textViews {
            textView.delegate = self
        }
    }
}
