import Foundation

public struct Radar {
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
                applicationID: String? = nil, userID: String? = nil)
    {
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

// MARK: JSON representation

private let kProductiOSID = 1
private let kProductiTunesConnectID = 12

extension Radar {

    /**
     Creates the JSON ready to be sent to apple's radar.

     - parameter CSRF: The Cross-Site Request Forgery token protection.

     - returns: A JSON representing the receivers in apple's radar format.
    */
    func toJSON(CSRF CSRF: String) -> NSData {
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
        let description = values
            .map { "\($0):\r\n\($1)" }
            .joinWithSeparator("\r\n\r\n")

        let JSON = [
            "problemTitle": self.title,
            "configIDPop": "",
            "configTitlePop": "",
            "configDescriptionPop": "",
            "configurationText": self.configuration,
            "notes": self.notes,
            "configurationSplit": "Configuration:\r\n",
            "configurationSplitValue": self.configuration,
            "workAroundText": "",
            "descriptionText": description,
            "problemAreaTypeCode": self.area.map { String($0.appleIdentifier) } ?? "",
            "classificationCode": String(self.classification.appleIdentifier),
            "reproducibilityCode": String(self.reproducibility.appleIdentifier),
            "component": [
                "ID": String(self.product.appleIdentifier),
                "compName": self.product.name,
            ],
            "draftID": "",
            "draftFlag": "0",
            "versionBuild": self.version,
            "desctextvalidate": description,
            "stepstoreprvalidate": self.steps,
            "experesultsvalidate": self.expected,
            "actresultsvalidate": self.actual,
            "addnotesvalidate": self.notes,
            "hiddenFileSizeNew": "",  // v2
            "attachmentsValue": "\r\n\r\nAttachments:\r\n",
            "configurationFileCheck": "",  // v2
            "configurationFileFinal": "",  // v2
            "csrftokencheck": CSRF,
        ]

        return try! NSJSONSerialization.dataWithJSONObject(JSON, options: [])
    }
}
