import AppKit

/// Option set with all available trackers.
///
/// - appleRadar: Apple's official bug tracker (https://bugreport.apple.com)
/// - openRadar:  Community bug reports (https://openradar.appspot.com/)
/// - swiftJIRA:  Swift project official bug tracker (https://bugs.swift.org)
struct BugTrackers: OptionSet {
    let rawValue: Int

    /// Number of trackers included in this optionset.
    var count: Int {
        var num = self.rawValue
        var count = 0
        while num > 0 {
            count += num % 2
            num /= 2
        }
        return count
    }

    static let appleRadar = BugTrackers(rawValue: 1)
    static let openRadar = BugTrackers(rawValue: 2)
    static let swiftJIRA = BugTrackers(rawValue: 4)
}

private struct Storyboard {
    static let name = "Main"
    static let identifier = "trackersSelector"
}

final class TrackersSelectorViewController: NSViewController {
    @IBOutlet private var appleRadarToggle: NSButton!
    @IBOutlet private var openRadarToggle: NSButton!
    @IBOutlet private var swiftJIRAToggle: NSButton!

    /// Closure that will be called with the saved trackers.
    var onSave: ((BugTrackers) -> Void)?

    /// Sets the enabled trackers that will be reflected on the shown toggles.
    var enabledTrackers: BugTrackers = [] {
        didSet { self.updateToggles() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateToggles()
    }

    static func instantiate(withEnabledTrackers trackers: BugTrackers) -> TrackersSelectorViewController {
        let storyboard = NSStoryboard(name: Storyboard.name, bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: Storyboard.identifier)
            as! TrackersSelectorViewController
        controller.enabledTrackers = trackers
        return controller
    }

    // MARK: - Button Actions

    @IBAction private func close(sender: Any) {
        self.onSave?(self.enabledTrackers)
        self.dismissViewController(self)
    }

    @IBAction private func toggleDidChange(sender: Any) {
        var enabledTrackers: BugTrackers = []
        enabledTrackers.formUnion(self.appleRadarToggle.state == NSOnState ? .appleRadar : [])
        enabledTrackers.formUnion(self.openRadarToggle.state == NSOnState ? .openRadar : [])
        enabledTrackers.formUnion(self.swiftJIRAToggle.state == NSOnState ? .swiftJIRA : [])
        self.enabledTrackers = enabledTrackers
    }

    // MARK: - Private methods

    private func updateToggles() {
        self.appleRadarToggle?.state = self.enabledTrackers.contains(.appleRadar) ? NSOnState : NSOffState
        self.openRadarToggle?.state = self.enabledTrackers.contains(.openRadar) ? NSOnState : NSOffState
        self.swiftJIRAToggle?.state = self.enabledTrackers.contains(.swiftJIRA) ? NSOnState : NSOffState
    }
}
