import Foundation
import Security

private let kAccessibilityLevel = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
private let kService = "Brisk"

enum KeychainKey: String {
    case Radar = "Radar Login"
}

struct Keychain {
    static func get(key: KeychainKey) -> (String, String)? {
        let attributes: [CFString: AnyObject] = [
            kSecAttrAccessible: kAccessibilityLevel,
            kSecAttrLabel: key.rawValue,
            kSecAttrService: kService,
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: kCFBooleanTrue,
            kSecReturnData: kCFBooleanTrue,
        ]

        var result: NSDictionary?
        let status = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(attributes, UnsafeMutablePointer($0))
        }

        if !status.success {
            return nil
        }

        let username = result?[kSecAttrAccount as String] as? String
        let passwordData = result?[kSecValueData as String] as? NSData
        let password = passwordData.flatMap { String(data: $0, encoding: NSUTF8StringEncoding) }
        if let username = username, let password = password {
            return (username, password)
        }

        return nil
    }

    static func set(username username: String, password: String, forKey key: KeychainKey) -> Bool {
        guard let passwordData = password.dataUsingEncoding(NSUTF8StringEncoding) else {
            return false
        }

        self.purge()

        let attributes: [CFString: AnyObject] = [
            kSecAttrAccessible: kAccessibilityLevel,
            kSecAttrAccount: username,
            kSecAttrLabel: key.rawValue,
            kSecAttrService: kService,
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passwordData,
        ]

        let status = SecItemAdd(attributes, nil)
        return status.success
    }

    static func purge() -> Bool {
        let attributes: [CFString: AnyObject] = [
            kSecAttrAccessible: kAccessibilityLevel,
            kSecAttrService: kService,
            kSecClass: kSecClassGenericPassword,
        ]

        let status = SecItemDelete(attributes)
        return status.success
    }
}

extension CFString: Hashable {
    public var hashValue: Int {
        return (self as String).hashValue
    }
}

public func == (lhs: CFString, rhs: CFString) -> Bool {
    return lhs as String == rhs as String
}

private extension OSStatus {
    private var success: Bool {
        return self == noErr
    }
}
