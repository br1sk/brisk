import Foundation
import Security

private let kAccessibilityLevel = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
private let kService = "Brisk"

enum KeychainKey: String {
    case radar = "Radar Login"
    case openRadar = "Open Radar Token"
}

struct Keychain {
    static func get(_ key: KeychainKey) -> (String, String)? {
        let attributes: [CFString: Any] = [
            kSecAttrAccessible: kAccessibilityLevel,
            kSecAttrLabel: key.rawValue,
            kSecAttrService: kService,
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: kCFBooleanTrue,
            kSecReturnData: kCFBooleanTrue,
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(attributes as CFDictionary, &result)

        guard let dictionary = result as? NSDictionary, status.success else {
            return nil
        }

        let username = dictionary[kSecAttrAccount as String] as? String
        let passwordData = dictionary[kSecValueData as String] as? Data
        let password = passwordData.flatMap { String(data: $0, encoding: String.Encoding.utf8) }
        if let username = username, let password = password {
            return (username, password)
        }

        return nil
    }

    @discardableResult
    static func set(username: String, password: String, forKey key: KeychainKey) -> Bool {
        guard let passwordData = password.data(using: String.Encoding.utf8) else {
            return false
        }

        self.delete(key)

        let attributes: [CFString: Any] = [
            kSecAttrAccessible: kAccessibilityLevel,
            kSecAttrAccount: username,
            kSecAttrLabel: key.rawValue,
            kSecAttrService: kService,
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passwordData,
        ]

        let status = SecItemAdd(attributes as CFDictionary, nil)
        return status.success
    }

    @discardableResult
    static func delete(_ key: KeychainKey) -> Bool {
        let attributes: [CFString: Any] = [
            kSecAttrAccessible: kAccessibilityLevel,
            kSecAttrLabel: key.rawValue,
            kSecAttrService: kService,
            kSecClass: kSecClassGenericPassword,
        ]

        let status = SecItemDelete(attributes as CFDictionary)
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

fileprivate extension OSStatus {
    fileprivate var success: Bool {
        return self == noErr
    }
}
