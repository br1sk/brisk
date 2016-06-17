import Foundation

extension NSData {
    func toJSONDictionary() -> NSDictionary? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(self, options: []) as? NSDictionary
        } catch {
            return nil
        }
    }
}
