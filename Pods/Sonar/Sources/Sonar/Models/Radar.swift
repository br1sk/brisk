import Foundation

private let kProductiOSID = 1
private let kProductiTunesConnectID = 12

public struct Radar {
    // The unique identifier on apple's radar platform.
    public var ID: Int?
    // The type of problem.
    public let classification: Classification
    // The product related to the report.
    public let product: Product
    // How often the problem occurs.
    public let reproducibility: Reproducibility
    // A short but descriptive sentence that summarizes the issue.
    public let title: String
    // A detailed description about the issue and include specific details to help the engineering 
    // team understand the problem.
    public let description: String
    // The step by step process to reproduce the issue.
    public let steps: String
    // What you expected to see.
    public let expected: String
    // What you actually saw.
    public let actual: String
    // The circumstances where this does or does not occur.
    public let configuration: String
    // Product version and build number.
    public let version: String
    // Any other relevant notes not previously mentioned
    public let notes: String

    // The area in which the problem occurs (only applies for product=iOS).
    public let area: Area?
    // The identifier for your app located as part of General Information section (iTunes Connect only)
    public let applicationID: String?
    // Email address or username of the user experiencing the issue (iTunes Connect only)
    public let userID: String?

    public init(classification: Classification, product: Product, reproducibility: Reproducibility,
                title: String, description: String, steps: String, expected: String, actual: String,
                configuration: String, version: String, notes: String, area: Area? = nil,
                applicationID: String? = nil, userID: String? = nil, ID: Int? = nil)
    {
        self.ID = ID
        self.classification = classification
        self.product = product
        self.reproducibility = reproducibility
        self.title = title
        self.description = description
        self.steps = steps
        self.expected = expected
        self.actual = actual
        self.configuration = configuration
        self.version = version
        self.notes = notes
        self.area = area
        self.applicationID = applicationID
        self.userID = userID
    }
}

// MARK: - Body

extension Radar {

    /// The composed body string using many of the components from the Radar model.
    var body: String {
        let baseTemplate = [
            ("Summary", self.description),
            ("Steps to Reproduce", self.steps),
            ("Expected Results", self.expected),
            ("Actual Results", self.actual),
            ("Version", self.version),
            ("Notes", self.notes),
        ]

        let templates = [
            kProductiTunesConnectID: [
                ("Apple ID of the App", self.applicationID ?? ""),
                ("Apple ID of the User", self.userID ?? "")
            ],
            kProductiOSID: [
                ("Area", self.area?.name ?? ""),
            ],
        ]

        let values = baseTemplate + (templates[self.product.appleIdentifier] ?? [])
        let body = values
            .map { "\($0):\r\n\($1)" }
            .joinWithSeparator("\r\n\r\n")
        return body + "\r\n\r\n"
    }
}
