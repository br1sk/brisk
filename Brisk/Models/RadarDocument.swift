import AppKit
import Sonar

private struct DocumentError: Error {}

final class RadarDocument: NSDocument {
    override func makeWindowControllers() {
        self.makeWindowControllers(for: nil)
    }

    override func data(ofType typeName: String) throws -> Data {
        let viewController = self.windowControllers.first?.contentViewController as? RadarViewController
        if let radar = viewController?.currentRadar() {
            return try radar.toData()
        }

        throw DocumentError()
    }

    override func read(from data: Data, ofType typeName: String) throws {
        if let json = data.toJSONDictionary(), let radar = Radar(json: json) {
            self.makeWindowControllers(for: radar)
        } else {
            throw DocumentError()
        }
    }

    func makeWindowControllers(for radar: Radar?) {
        let windowController = NSStoryboard.main.instantiateWindowController(identifier: "Radar")
        if let radar = radar {
            let viewController = windowController.contentViewController as! RadarViewController
            viewController.restore(radar)
        }

        self.addWindowController(windowController)
    }
}
