import Foundation
import AppKit

final class FileADuplicateViewController: ViewController {
    @IBOutlet private var radarTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public var radarID: String {
        get {
            return radarTextField.stringValue
        }
    }

    @IBAction private func fetchData(_ sender: Any) {
        closeSheetWithReturnCode(NSModalResponseContinue)
    }

    @IBAction private func closeSheet(_ sender: Any) {
        closeSheetWithReturnCode(NSModalResponseStop)
    }

    private func closeSheetWithReturnCode(_ returnCode: NSModalResponse) {
        view.window?.sheetParent?.endSheet(view.window!, returnCode: returnCode)
        StoryboardRouter.reloadTopWindowController()
    }
}
