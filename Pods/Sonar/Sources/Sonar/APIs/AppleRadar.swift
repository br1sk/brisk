import Alamofire
import Foundation

class AppleRadar: BugTracker {

    private let credentials: (appleID: String, password: String)
    private let manager: Alamofire.Manager
    private var CSRF: String?

    /**
     - parameter appleID:  Username to be used on `bugreport.apple.com` authentication.
     - parameter password: Password to be used on `bugreport.apple.com` authentication.
    */
    init(appleID: String, password: String) {
        self.credentials = (appleID: appleID, password: password)

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        configuration.HTTPCookieStorage = cookies
        configuration.HTTPCookieAcceptPolicy = .Always

        self.manager = Alamofire.Manager(configuration: configuration)
    }

    /**
     Login into radar by an apple ID and password.

     - parameter closure: A closure that will be called when the login is completed, on success it will
                          contain a list of `Product`s; on failure a `SonarError`.
    */
    func login(closure: Result<Void, SonarError> -> Void) {
        self.manager
            .request(AppleRadarRouter.Login(appleID: credentials.appleID, password: credentials.password))
            .validate()
            .responseString { [weak self] response in
                guard case let .Success(value) = response.result else {
                    closure(.Failure(SonarError.fromResponse(response)))
                    return
                }

                if let error = value.match("class=\"dserror\".*?>(.*?)</", group: 1) {
                    closure(.Failure(SonarError(message: error)))
                    return
                }

                guard let CSRF = value.match("<input.*csrftoken.*value=\"(.*)\"", group: 1) else {
                    closure(.Failure(SonarError(message: "CSRF not found. Maybe the ID is invalid?")))
                    return
                }

                self?.CSRF = CSRF
                self?.products { result in
                    if case let .Failure(error) = result {
                        closure(.Failure(error))
                        return
                    }

                    closure(.Success())
                }
            }
    }

    /**
     Fetches the list of available products (needs authentication first).

     - parameter closure:  A closure that will be called when the login is completed, on success it will
                           contain a list of `Product`s; on failure a `SonarError`.
    */
    func products(closure: Result<[Product], SonarError> -> Void) {
        guard let CSRF = self.CSRF else {
            closure(.Failure(SonarError(message: "User is not logged in")))
            return
        }

        self.manager
            .request(AppleRadarRouter.Products(CSRF: CSRF))
            .validate()
            .responseJSON { response in
                guard case let .Success(value) = response.result else {
                    closure(.Failure(SonarError.fromResponse(response)))
                    return
                }

                let products = (value as? [NSDictionary])?.flatMap(Product.init) ?? []
                closure(.Success(products))
            }
    }

    /**
     Creates a new ticket into apple's radar (needs authentication first).

     - parameter radar:   The radar model with the information for the ticket.
     - parameter closure: A closure that will be called when the login is completed, on success it will
                          contain a radar ID; on failure a `SonarError`.
    */
    func create(radar radar: Radar, closure: Result<Int, SonarError> -> Void) {
        guard let CSRF = self.CSRF else {
            closure(.Failure(SonarError(message: "User is not logged in")))
            return
        }

        let route = AppleRadarRouter.Create(radar: radar, CSRF: CSRF)
        let (_, method, headers, body, _) = route.components
        let createMultipart = { (data: MultipartFormData) -> Void in
            data.appendBodyPart(data: body ?? NSData(), name: "hJsonScreenVal")

            // TODO: Add attachments here (needs to change Radar.toJSON too).
        }

        self.manager
            .upload(method, route.URL, headers: headers, multipartFormData: createMultipart) { result in
                guard case let .Success(upload, _, _) = result else {
                    closure(.Failure(.UnknownError))
                    return
                }

                upload.validate().responseString { response in
                    guard case let .Success(value) = response.result else {
                        closure(.Failure(SonarError.fromResponse(response)))
                        return
                    }

                    guard let radarID = Int(value) else {
                        closure(.Failure(SonarError(message: "Invalid Radar ID received")))
                        return
                    }

                    closure(.Success(radarID))
                }
            }
    }
}
