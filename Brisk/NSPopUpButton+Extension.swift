import AppKit

extension NSPopUpButton {
    var selectedTitle: String {
        return self.selectedItem?.title ?? ""
    }

    func setItemsWithTitles(titles: [String]) {
        let selectedTitle = self.selectedTitle
        self.removeAllItems()
        self.addItemsWithTitles(titles)
        self.selectItemWithTitle(selectedTitle)
        if self.selectedItem == nil && self.numberOfItems > 0 {
            self.selectItemAtIndex(0)
        }
    }
}

extension NSPopUpButton: Validatable {
    var isValid: Bool {
        return !self.selectedTitle.isEmpty
    }
}
