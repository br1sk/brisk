import Cocoa

final class RadarViewController: NSViewController {
    @IBOutlet private var productPopUp: NSPopUpButton!
    @IBOutlet private var areaPopUp: NSPopUpButton!
    @IBOutlet private var versionTextField: NSTextField!
    @IBOutlet private var classificationPopUp: NSPopUpButton!
    @IBOutlet private var reproducibilityPopUp: NSPopUpButton!
    @IBOutlet private var configurationTextField: NSTextField!
    @IBOutlet private var titleTextField: NSTextField!
    @IBOutlet private var descriptionTextView: NSTextView!
    @IBOutlet private var stepsTextView: NSTextView!
    @IBOutlet private var expectedTextView: NSTextView!
    @IBOutlet private var actualTextView: NSTextView!
    @IBOutlet private var notesTextView: NSTextView!
    @IBOutlet private var submitButton: NSButton!

    private var radarComponents: RadarComponents[]()
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
    }

    @IBAction private func submitRadar(sender: AnyObject) {
        guard let radar = self.currentRadar() else {
            return
        }

        _ = radar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppleRadarService.retrieveProductsAndReproducibilityAndArea()
    }

    // MARK: - Private Methods

    private func currentRadar() -> Radar? {
        for field in self.validatables {
            if !field.isValid {
                return nil
            }
        }

        guard let product = self.products.find({ $0.name == self.productPopUp.selectedTitle }),
            let classification = self.classifications
                .find({ $0.name == self.classificationPopUp.selectedTitle }),
            let reproducibility = self.reproducibility
                .find({ $0.name == self.reproducibilityPopUp.selectedTitle }),
            let area = self.areas.find({ $0.name == self.areaPopUp.selectedTitle }) else
        {
            return nil
        }

        let actual = self.actualTextView.stringValue
        let configuration = self.configurationTextField.stringValue
        let description = self.descriptionTextView.stringValue
        let expected = self.expectedTextView.stringValue
        let notes = self.notesTextView.stringValue
        let steps = self.stepsTextView.stringValue
        let title = self.titleTextField.stringValue
        let version = self.versionTextField.stringValue

        return Radar(product: product, classification: classification, reproducibility: reproducibility,
                     area: area, title: title, description: description, steps: steps, expected: expected,
                     actual: actual, configuration: configuration, version: version, notes: notes)
    }

    private func enableSubmitIfValid() {
        for field in self.validatables {
            if !field.isValid {
                self.submitButton.enabled = false
                return
            }
        }

        self.submitButton.enabled = true
    }
}

extension RadarViewController: NSTextViewDelegate {
    override func controlTextDidChange(obj: NSNotification) {
//        super.controlTextDidChange(obj)
        self.enableSubmitIfValid()
    }

    func textDidChange(notification: NSNotification) {
        self.enableSubmitIfValid()
    }

    var textViews: [NSTextView] {
        return [
            self.actualTextView,
            self.descriptionTextView,
            self.expectedTextView,
            self.notesTextView,
            self.stepsTextView,
        ]
    }

    func setupTextViewDelegates() {
        for textView in self.textViews {
            textView.delegate = self
        }
    }
}

protocol Validatable {
    var isValid: Bool { get }
}

extension NSTextView: Validatable {
    var isValid: Bool {
        return self.string?.isEmpty == false
    }

    var stringValue: String {
        return self.string ?? ""
    }
}

extension NSTextField: Validatable {
    var isValid: Bool {
        return !self.stringValue.isEmpty
    }
}

extension NSPopUpButton: Validatable {
    var isValid: Bool {
        return true
        return !self.selectedTitle.isEmpty
    }
}

extension NSPopUpButton {
    var selectedTitle: String {
        return self.selectedItem?.title ?? ""
    }
}
