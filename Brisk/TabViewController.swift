import AppKit

final class TabViewController: NSTabViewController {
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.title = self.tabView.selectedTabViewItem?.viewController?.title ?? ""
    }

    override func tabView(tabView: NSTabView, didSelectTabViewItem tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelectTabViewItem: tabViewItem)
        let newTitle = tabViewItem?.viewController?.title
        self.view.window?.title = newTitle ?? ""
    }
}
