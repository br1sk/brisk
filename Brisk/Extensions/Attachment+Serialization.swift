import Sonar

public extension Attachment {
    func toJSON() -> [String: Any] {
        return [
            "filename": self.filename,
            "mimetype": self.mimeType,
            "data": self.data.base64EncodedString(),
        ]
    }

    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.toJSON(), options: [])
    }

    init?(json: [String: Any]) {
        guard let filename = json["filename"] as? String,
            let mimeType = json["mimetype"] as? String,
            let encodedData = json["data"] as? String,
            let data = Data(base64Encoded: encodedData) else
        {
            return nil
        }

        self.init(filename: filename, mimeType: mimeType, data: data)
    }

    public init(filename: String, mimeType: String, data: Data) {
        self.filename = filename
        self.mimeType = mimeType
        self.data = data
    }
}
