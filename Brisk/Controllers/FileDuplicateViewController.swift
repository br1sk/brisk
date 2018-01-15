import Alamofire
import AppKit
import Sonar

final class FileDuplicateViewController: ViewController {
    @IBOutlet private var progressIndicator: NSProgressIndicator!
    @IBOutlet private var radarIDTextField: NSTextField!
    @IBOutlet private var searchButton: NSButton!

    func searchForOpenRadar(text: String) {
        self.radarIDTextField.stringValue = text
        self.searchForOpenRadar(self.searchButton)
    }

    @IBAction private func searchForOpenRadar(_ sender: NSButton) {
        let setLoading: (Bool) -> Void = { [weak self] loading in
            self?.progressIndicator.isLoading = loading
            self?.radarIDTextField.isEnabled = !loading
            self?.searchButton.isEnabled = !loading
        }

        setLoading(true)
        let id = radarID(from: self.radarIDTextField.stringValue)!
        let url = URL(string: "https://openradar.appspot.com/api/radar?number=\(id)")!
        Alamofire.request(url)
            .validate()
            .responseJSON { [weak self] result in
                setLoading(false)

                if let error = result.error {
                    self?.show(NSAlert(error: error))
                    return
                }

                guard let json = result.value as? [String: Any],
                    let result = json["result"] as? [String: Any], !result.isEmpty else
                {
                    self?.showError(title: "No OpenRadar found",
                                    message: "Couldn't find an OpenRadar with ID #\(id)")
                    return
                }

                guard let radar = try? Radar(openRadar: json),
                    let document = NSDocumentController.shared.makeRadarDocument() else
                {
                    self?.showError(title: "Invalid OpenRadar",
                                    message: "OpenRadar is missing required fields")
                    return
                }

                document.makeWindowControllers(for: radar)
                NSDocumentController.shared.addDocument(document)
                document.showWindows()

                self?.view.window?.windowController?.close()
            }
    }

    override func controlTextDidChange(_ notification: Notification) {
        assert(notification.object as? NSTextField === self.radarIDTextField)
        self.searchButton.isEnabled = radarID(from: self.radarIDTextField.stringValue) != nil
    }

    private func showError(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        self.show(alert)
    }

    private func show(_ alert: NSAlert) {
        alert.runModal()
        self.radarIDTextField.becomeFirstResponder()
    }
}

public func radarID(from string: String) -> String? {
    guard let text = string.components(separatedBy: "/").last?.strip(), !text.isEmpty else {
        return nil
    }

    if text.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted)?.isEmpty != false {
        return text
    } else {
        return nil
    }
}
