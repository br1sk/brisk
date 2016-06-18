import Foundation

protocol RadarService {
    func submit(radar radar: Radar, completion: (Result<NSDictionary, APIError>) -> Void)
}
