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

    func setItemsWith<T>(objects: [T], @noescape getTitle: (T) -> String, @noescape getGroup: (T) -> String) {
        let menu = NSMenu()
        menu.autoenablesItems = false
        menu.setItemsWith(objects, getTitle: getTitle, getGroup: getGroup)
        self.menu = menu
        if let index = menu.itemArray.indexOf({ $0.indentationLevel == 1 }) {
            self.selectItemAtIndex(index)
        }
    }
}

extension NSPopUpButton: Validatable {
    var isValid: Bool {
        return !self.selectedTitle.isEmpty
    }
}

private extension NSMenu {
    private func setItemsWith<T>(objects: [T], @noescape getTitle: (T) -> String,
                                               @noescape getGroup: (T) -> String)
    {
        var groups = [String]()
        var titlesForGroup = [String: [String]]()

        for object in objects {
            let group = getGroup(object)
            if !groups.contains(group) {
                groups.append(group)
            }

            let names = titlesForGroup[group] ?? []
            titlesForGroup[group] = names + [getTitle(object)]
        }

        for group in groups {
            let titles = titlesForGroup[group]!
            let topLevelItem = NSMenuItem()
            topLevelItem.enabled = false
            topLevelItem.title = group
            self.addItem(topLevelItem)

            for title in titles {
                let item = NSMenuItem()
                item.title = title
                item.indentationLevel = 1
                self.addItem(item)
            }
        }
    }
}
