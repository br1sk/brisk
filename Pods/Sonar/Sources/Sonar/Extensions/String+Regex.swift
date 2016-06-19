import Foundation

extension String {

    /**
     Returns the string matching in the given group number (if any), nil otherwise.

     - parameter pattern: The regular expression to match.
     - parameter group:   The group number to return from the match.
     - parameter options: Options that will be use for matching using regular expressions.

     - returns: The string from the given group on the match (if any).
    */
    func match(pattern: String, group: Int, options: NSRegularExpressionOptions = []) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: options)
            let range = NSRange(location: 0, length: self.characters.count)

            guard let match = regex.firstMatchInString(self, options: [], range: range) else {
                return nil
            }

            if match.numberOfRanges < group {
                return nil
            }

            let matchRange = match.rangeAtIndex(group)
            let startRange = self.startIndex.advancedBy(matchRange.location)
            let endRange = startRange.advancedBy(matchRange.length)

            return self
                .substringWithRange(startRange ..< endRange)
                .stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        } catch {
            return nil
        }
    }
}
