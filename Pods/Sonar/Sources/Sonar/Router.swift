import Alamofire
import Foundation

private let kRadarAppID = "77e2a60d4bdfa6b7311c854a56505800be3c24e3a27a670098ff61b69fc5214b"

typealias Components = (path: String, method: Alamofire.Method, headers: [String: String],
                        data: NSData?, parameters: [String: String])

/**
Apple's radar request router.

- Products:    The `Route` used to retrieve all available products
- Login:       The `Route` used to login an username/password pair..
- Create:      The `Route` used to create a new radar.
- ViewProblem: The main apple's radar page.
*/
enum SonarRouter {

    case Products(CSRF: String)
    case Login(appleID: String, password: String)
    case Create(radar: Radar, CSRF: String)
    case ViewProblem

    private static let baseURL = NSURL(string: "https://bugreport.apple.com")!

    /// The request components including headers and parameters.
    var components: Components {
        switch self {
            case .ViewProblem:
                return (path: "/problem/viewproblem", method: .GET, headers: [:], data: nil, parameters: [:])

            case .Login(let appleID, let password):
                let fullURL = "https://idmsa.apple.com/IDMSWebAuth/authenticate"
                let headers = ["Content-Type": "application/x-www-form-urlencoded"]
                return (path: fullURL, method: .POST, headers: headers, data: nil, parameters: [
                    "appIdKey": kRadarAppID, "accNameLocked": "false", "rv": "3", "Env": "PROD",
                    "appleId": appleID, "accountPassword": password
                ])

            case .Products(let CSRF):
                let headers = [
                    "X-Requested-With": "XMLHttpRequest",
                    "Accept": "application/json, text/javascript, */*; q=0.01",
                    "csrftokencheck": CSRF,
                ]

                let timestamp = Int(NSDate().timeIntervalSince1970 * 100)
                return (path: "/developer/problem/getProductFullList", method: .GET,
                        headers: headers, data: nil, parameters: ["_": String(timestamp)])

            case .Create(let radar, let CSRF):
                let headers = ["Referer": SonarRouter.ViewProblem.URL.URLString]
                return (path: "/developer/problem/createNewDevUIProblem", method: .POST, headers: headers,
                        data: radar.toJSON(CSRF: CSRF), parameters: [:])
        }
    }
}

extension SonarRouter: URLRequestConvertible {

    /// The URL that will be used for the request.
    var URL: NSURL {
        return self.URLRequest.URL!
    }

    /// The request representation of the route including parameters and HTTP method.
    var URLRequest: NSMutableURLRequest {
        let (path, method, headers, data, parameters) = self.components
        let fullURL: NSURL
        if let URL = NSURL(string: path) where URL.host != nil {
            fullURL = URL
        } else {
            fullURL = SonarRouter.baseURL.URLByAppendingPathComponent(path)
        }

        let request = NSMutableURLRequest(URL: fullURL)
        request.HTTPMethod = method.rawValue
        request.HTTPBody = data

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if data == nil {
            return Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters).0
        }

        return request
    }
}