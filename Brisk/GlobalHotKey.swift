import AppKit
import Carbon

struct GlobalHotKey {
    // ⌃⌥⌘-SPACE
    static func register() {
        // Register event handler
        var eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyReleased))
        InstallEventHandler(GetApplicationEventTarget(), { _ in
            return GlobalHotKey.hotKeyTriggered()
        }, 1, &eventSpec, nil, nil)

        // Register global hot key
        let htk1OSType = "htk1".utf16.reduce(0) { ($0 << 8) + OSType($1) }
        var carbonHotKey: EventHotKeyRef?
        // There's no reasonable way to handle this error, so just ignore it
        _ = RegisterEventHotKey(UInt32(kVK_Space), UInt32(controlKey | optionKey | cmdKey),
                                EventHotKeyID(signature: htk1OSType, id: 1),
                                GetEventDispatcherTarget(), 0, &carbonHotKey)
    }

    // Create new document when hot key is triggered
    private static func hotKeyTriggered() -> OSStatus {
        NSDocumentController.shared().newDocument(nil)
        return noErr
    }
}
