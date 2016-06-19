import Foundation

public struct Product {
    /// Internal apple's identifier
    public let appleIdentifier: Int
    /// The category of the product (e.g. 'Hardware').
    public let category: String
    /// The name of the product; useful to use as display name (e.g. 'iOS').
    public let name: String

    init?(dictionary: NSDictionary) {
        guard
            let category = dictionary["categoryName"] as? String,
            appleIdentifier = dictionary["componentID"] as? Int,
            name = dictionary["compNameForWeb"] as? String
        else {
            return nil
        }

        self.category = category
        self.appleIdentifier = appleIdentifier
        self.name = name
    }
}
