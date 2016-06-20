import Alamofire
import Foundation

/**
Open radar request router.

- Create: The `Route` used to create a new radar.
*/
enum OpenRadarRouter {

    case Create(radar: Radar)

    private static let baseURL = NSURL(string: "https://openradar.appspot.com")!

    /// The request components including headers and parameters.
    var components: (path: String, method: Alamofire.Method, parameters: [String: String]) {
        switch self {
            case .Create(let radar):
                let formatter = NSDateFormatter()
                formatter.dateFormat = "dd-MMM-yyyy hh:mm a"

                return (path: "/api/radars/add", method: .POST, parameters: [
                    "classification": radar.classification.name,
                    "description": radar.body,
                    "number": radar.ID.map { String($0) } ?? "",
                    "originated": formatter.stringFromDate(NSDate()),
                    "product": radar.product.name,
                    "product_version": radar.version,
                    "reproducible": radar.reproducibility.name,
                    "status": "Open",
                    "title": radar.title,
                ])
        }
    }
}

extension OpenRadarRouter: URLRequestConvertible {

    /// The URL that will be used for the request.
    var URL: NSURL {
        return self.URLRequest.URL!
    }

    /// The request representation of the route including parameters and HTTP method.
    var URLRequest: NSMutableURLRequest {
        let (path, method, parameters) = self.components
        let URL = OpenRadarRouter.baseURL.URLByAppendingPathComponent(path)

        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = method.rawValue
        return Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters).0
    }
}

