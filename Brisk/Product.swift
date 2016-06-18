import Foundation

struct Product {
    let id: String
    let name: String
}

extension Product {
    init?(dictionary: NSDictionary) {
        if let id = dictionary["identifier"] as? String, let name = dictionary["name"] as? String {
            self.init(id: id, name: name)
        } else {
            return nil
        }
    }
}
