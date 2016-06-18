import AppKit

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

    private var radarComponents: RadarComponents?
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
        AppleRadarService.retrieveRadarComponents { [weak self] components in
            self?.updateRadarComponents(components)
        }
    }

    @IBAction private func submitRadar(sender: AnyObject) {
        guard let radar = self.currentRadar() else {
            return
        }

        _ = radar
    }

    // MARK: - Private Methods

    private func updateRadarComponents(components: RadarComponents) {
        self.radarComponents = components
        self.areaPopUp.setItemsWithTitles(components.areas.map { $0.name })
        self.classificationPopUp.setItemsWithTitles(components.classifications.map { $0.name })
        self.productPopUp.setItemsWithTitles(components.products.map { $0.name })
        self.reproducibilityPopUp.setItemsWithTitles(components.reproducibilities.map { $0.name })
    }

    private func currentRadar() -> Radar? {
        for field in self.validatables {
            if !field.isValid {
                return nil
            }
        }

        guard let product = self.radarComponents?.products.find({ $0.name == self.productPopUp.selectedTitle }),
            let classification = self.radarComponents?.classifications
                .find({ $0.name == self.classificationPopUp.selectedTitle }),
            let reproducibility = self.radarComponents?.reproducibilities
                .find({ $0.name == self.reproducibilityPopUp.selectedTitle }),
            let area = self.radarComponents?.areas.find({ $0.name == self.areaPopUp.selectedTitle }) else
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
