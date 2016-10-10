import Foundation

extension Data {
    func toJSONDictionary() -> NSDictionary? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? NSDictionary
        } catch {
            return nil
        }
    }
}
