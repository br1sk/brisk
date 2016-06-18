import Foundation

struct Classification {
    let id: String
    let name: String

    static func withDictionary(dictionary: NSDictionary) -> Classification? {
        guard let id = dictionary["id"] as? String, name = dictionary["name"] as? String else {
            return nil
        }

        return self.init(id: id, name: name)
    }
}
