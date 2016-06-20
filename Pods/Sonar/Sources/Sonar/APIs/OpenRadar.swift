import Alamofire
import Foundation

class OpenRadar: BugTracker {

    private let manager: Alamofire.Manager

    init(token: String) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization": token]

        self.manager = Alamofire.Manager(configuration: configuration)
    }

    /**
     Login into open radar. This is actually a NOP for now (token is saved into the session).

     - parameter closure: A closure that will be called when the login is completed, on success it will
                          contain a list of `Product`s; on failure a `SonarError`.
    */
    func login(closure: Result<Void, SonarError> -> Void) {
        closure(.Success())
    }

    /**
     Creates a new ticket into open radar (needs authentication first).

     - parameter radar:   The radar model with the information for the ticket.
     - parameter closure: A closure that will be called when the login is completed, on success it will
                          contain a radar ID; on failure a `SonarError`.
    */
    func create(radar radar: Radar, closure: Result<Int, SonarError> -> Void) {
        guard let ID = radar.ID else {
            closure(.Failure(SonarError(message: "Invalid radar ID")))
            return
        }

        self.manager
            .request(OpenRadarRouter.Create(radar: radar))
            .validate()
            .responseJSON { response in
                guard case .Success = response.result else {
                    closure(.Failure(SonarError.fromResponse(response)))
                    return
                }

                closure(.Success(ID))
            }
    }
}

