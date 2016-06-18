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

    @IBAction private func submitRadar(sender: AnyObject) {
    }

    // MARK: - Private Methods

//    private func currentRadar() -> Radar {
//    }
}
