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

    private var products = [Product]()
    private var areas = [Area]()
    private var classifications = [Classification]()
    private var reproducibility = [Reproducability]()
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
    }

    @IBAction private func submitRadar(sender: AnyObject) {
    }

    // MARK: - Private Methods

    private func currentRadar() -> Radar? {
        guard let product = self.products.find({ $0.name == self.productPopUp.selectedTitle }),
            let classification = self.classifications.find({ $0.name == self.classificationPopUp.selectedTitle }),
            let reproducibility = self.reproducibility.find({ $0.name == self.reproducibilityPopUp.selectedTitle }),
            let area = self.areas.find({ $0.name == self.areaPopUp.selectedTitle }),
            let description = self.descriptionTextView.string,
            let steps = self.stepsTextView.string,
            let expected = self.expectedTextView.string,
            let actual = self.actualTextView.string,
            let notes = self.notesTextView.string else
        {
            return nil
        }

        let title = self.titleTextField.stringValue
        let configuration = self.configurationTextField.stringValue
        let version = self.versionTextField.stringValue

        return Radar(product: product, classification: classification, reproducibility: reproducibility,
                     area: area, title: title, description: description, steps: steps, expected: expected,
                     actual: actual, configuration: configuration, version: version, notes: notes)
    }
}

extension RadarViewController: NSTextViewDelegate {
    override func controlTextDidChange(obj: NSNotification) {
        super.controlTextDidChange(obj)
    }
}

protocol Validatable {
    var isValid: Bool { get }
}

extension NSTextView: Validatable {
    var isValid: Bool {
        return self.string?.isEmpty == false
    }
}
extension NSTextField: Validatable {
    var isValid: Bool {
        return !self.stringValue.isEmpty
    }
}

extension NSPopUpButton: Validatable {
    var isValid: Bool {
        return self.selectedTitle?.isEmpty == false
    }
}

extension NSPopUpButton {
    var selectedTitle: String? {
        return self.selectedItem?.title
    }
}
