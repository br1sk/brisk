import AppKit

final class RadarViewController: NSViewController {
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

        let appleService = AppleRadarService()
        appleService.submit(radar: radar) { result in

        }
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

        return Radar(product: product, classification: classification, reproducibility: reproducibility,
                     area: area, title: self.titleTextField.stringValue,
                     description: self.descriptionTextView.stringValue, steps: self.stepsTextView.stringValue,
                     expected: self.expectedTextView.stringValue, actual: self.actualTextView.stringValue,
                     configuration: self.configurationTextField.stringValue,
                     version: self.versionTextField.stringValue, notes: self.notesTextView.stringValue)
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
