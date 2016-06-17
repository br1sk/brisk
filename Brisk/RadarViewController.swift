import Cocoa

final class RadarViewController: NSViewController {
    @IBOutlet var productPopUp: NSPopUpButton!
    @IBOutlet var areaPopUp: NSPopUpButton!
    @IBOutlet var versionTextField: NSTextField!
    @IBOutlet var classificationPopUp: NSPopUpButton!
    @IBOutlet var reproducibilityPopUp: NSPopUpButton!
    @IBOutlet var configurationTextField: NSTextField!
    @IBOutlet var titleTextField: NSTextField!
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet var stepsTextView: NSTextView!
    @IBOutlet var expectedTextView: NSTextView!
    @IBOutlet var actualTextView: NSTextView!
    @IBOutlet var notesTextView: NSTextView!
    @IBOutlet var submitButton: NSButton!

    @IBAction func submitRadar(sender: AnyObject) {
    }

    // MARK: - Private Methods

    private func currentRadar() -> Radar {
        let 
    }
}
