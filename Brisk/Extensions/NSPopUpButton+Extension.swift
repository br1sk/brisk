import AppKit

extension NSPopUpButton {
    var selectedTitle: String {
        return self.selectedItem?.title ?? ""
    }

    func setItems(titles: [String]) {
        let selectedTitle = self.selectedTitle
        self.removeAllItems()
        self.addItems(withTitles: titles)
        self.selectItem(withTitle: selectedTitle)
        if self.selectedItem == nil && self.numberOfItems > 0 {
            self.selectItem(at: 0)
        }
    }

    func set<T>(items: [T], getTitle: (T) -> String, getGroup: (T) -> String) {
        let menu = NSMenu()
        menu.autoenablesItems = false
        menu.set(items: items, getTitle: getTitle, getGroup: getGroup)
        self.menu = menu
        if let index = menu.items.index(where: { $0.indentationLevel == 1 }) {
            self.selectItem(at: index)
        }
    }
}

extension NSPopUpButton: Validatable {
    var isValid: Bool {
        return !self.selectedTitle.isEmpty
    }
}

private extension NSMenu {
    func set<T>(items: [T], getTitle: (T) -> String, getGroup: (T) -> String) {
        var groups = [String]()
        var titlesForGroup = [String: [String]]()

        for item in items {
            let group = getGroup(item)
            if !groups.contains(group) {
                groups.append(group)
            }

            let names = titlesForGroup[group] ?? []
            titlesForGroup[group] = names + [getTitle(item)]
        }

        for group in groups {
            let titles = titlesForGroup[group]!
            let topLevelItem = NSMenuItem()
            topLevelItem.isEnabled = false
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
