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
        self.registerForDraggedTypes([makeFileURLType()])
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
    private var files: [String] {
        return self.draggingPasteboard().propertyList(forType: makeFileURLType()) as? [String] ?? []
    }

    fileprivate func getAttachments() throws -> [Attachment] {
        if self.files.isEmpty {
            throw AttachmentDropError.noAttachments
        }

        return try self.files.map { try Attachment(url: URL(fileURLWithPath: $0)) }
    }
}

private func makeFileURLType() -> NSPasteboard.PasteboardType {
    if #available(OSX 10.13, *) {
        return NSPasteboard.PasteboardType.fileURL
    } else {
        return NSPasteboard.PasteboardType("public.file-url")
    }
}
