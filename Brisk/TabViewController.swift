import AppKit

final class TabViewController: NSTabViewController {
    override func viewWillAppear() {
        super.viewWillAppear()
        self.setTitle(withItem: self.tabView.selectedTabViewItem)
    }

    override func tabView(tabView: NSTabView, didSelectTabViewItem tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelectTabViewItem: tabViewItem)
        self.setTitle(withItem: tabViewItem)
    }

    private func setTitle(withItem item: NSTabViewItem?) {
        let newTitle = item?.viewController?.title
        self.view.window?.title = newTitle ?? ""
    }
}
