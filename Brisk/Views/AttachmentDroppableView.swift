import Cocoa
import Sonar

private enum AttachmentDropError: Error {
    case noAttachments
}

final class AttachmentDroppableView: NSView {
    /// Called with the dropped attachment after the drop has been completed
    var droppedAttachment: ((Attachment) -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerForDraggedTypes([makeFileNameType()])
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        do {
            _ = try sender.getAttachments()
            return .copy
        } catch {
            return []
        }
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        do {
            let attachments = try sender.getAttachments()
            self.droppedAttachment(attachments.first!)
            return true
        } catch {
            return false
        }
    }
}

fileprivate extension NSDraggingInfo {
    private var files: [URL] {
        let asStrings = self.draggingPasteboard.propertyList(forType: makeFileNameType()) as? [String] ?? []
        return asStrings.map { URL(fileURLWithPath: $0) }
    }

    fileprivate func getAttachments() throws -> [Attachment] {
        if self.files.isEmpty {
            throw AttachmentDropError.noAttachments
        }

        return try self.files.map { try Attachment(url: $0) }
    }
}

private func makeFileNameType() -> NSPasteboard.PasteboardType {
    // in 10.13 there is more modern NSPasteboard.PasteboardType.fileURL or previously
    // NSPasteboard.PasteboardType("public.file-url"), but so far couldn't find a way
    // to read them from draggingPasteboard()
    return NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")
}
