
import Cocoa

@objc protocol FileDroppableViewDelegate {
    func fileDroppableView(_ view:FileDroppableView, canReceiveFiles files:[String]) -> Bool
    func fileDroppableView(_ view:FileDroppableView, receivedDroppedFiles files:[String]) -> Bool
}

class FileDroppableView: NSView {
    @IBOutlet var dropDelegate: AnyObject? // workaround for XCode8 InterfaceBuilder not supporting Swift protocols as IBOutlets

    override func awakeFromNib() {
        self.register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let dropDelegate = dropDelegate as? FileDroppableViewDelegate, let files = filesfromDraggingInfo(sender) else {
            return []
        }
        
        if dropDelegate.fileDroppableView(self, canReceiveFiles: files) {
            return NSDragOperation.copy
        } else {
            return []
        }
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let dropDelegate = dropDelegate as? FileDroppableViewDelegate, let files = filesfromDraggingInfo(sender) else {
            return false
        }
        
        return dropDelegate.fileDroppableView(self, receivedDroppedFiles: files)
    }
    
    // MARK: - Private Methods
    private func filesfromDraggingInfo(_ sender:NSDraggingInfo) -> [String]? {
        let pasteboard = sender.draggingPasteboard()
        if let types = pasteboard.types {
            if(types.contains(NSFilenamesPboardType)) {
                let files = pasteboard.propertyList(forType: NSFilenamesPboardType) as? [NSString]
                return files as [String]?
            }
        }
        
        return nil
    }
    
}
