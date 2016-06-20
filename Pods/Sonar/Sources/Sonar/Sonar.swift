import Alamofire
import Foundation

public class Sonar {
    private let tracker: BugTracker

    public init(service: ServiceAuthentication) {
        switch service {
            case .AppleRadar(let appleID, let password):
                self.tracker = AppleRadar(appleID: appleID, password: password)

            case .OpenRadar(let token):
                self.tracker = OpenRadar(token: token)
        }
    }

    /**
     Login into bug tracker. This method will use the authentication information provided by the service enum.

     - parameter closure: A closure that will be called when the login is completed,
                          on failure a `SonarError`.
    */
    public func login(closure: Result<Void, SonarError> -> Void) {
        self.tracker.login { result in
            closure(result)
            self.hold()
        }
    }

    /**
     Creates a new ticket into the bug tracker (needs authentication first).

     - parameter radar:   The radar model with the information for the ticket.
     - parameter closure: A closure that will be called when the login is completed, on success it will
                          contain a radar ID; on failure a `SonarError`.
    */
    public func create(radar radar: Radar, closure: Result<Int, SonarError> -> Void) {
        self.tracker.create(radar: radar) { result in
            closure(result)
            self.hold()
        }
    }

    /**
     Similar to `create` but logs the user in first.

     - parameter radar:   The radar model with the information for the ticket.
     - parameter closure: A closure that will be called when the login is completed, on success it will
                          contain a radar ID; on failure a `SonarError`.
    */
    public func loginThenCreate(radar radar: Radar, closure: Result<Int, SonarError> -> Void) {
        self.tracker.login { result in
            if case let .Failure(error) = result {
                closure(.Failure(error))
                return
            }

            self.create(radar: radar, closure: closure)
        }
    }

    private func hold() {}
}
