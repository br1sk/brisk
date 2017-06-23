import AppKit

private let kDocumentType = "com.brisk.radar"

extension NSDocumentController {
    func makeRadarDocument() -> RadarDocument? {
        return (try? self.makeUntitledDocument(ofType: kDocumentType)) as? RadarDocument
    }

    func makeRadarDocument(withContentsOf url: URL) -> RadarDocument? {
        return (try? self.makeDocument(withContentsOf: url, ofType: kDocumentType)) as? RadarDocument
    }
}
