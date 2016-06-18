import Alamofire

private let kAppleRadarServiceURL = "http://10.10.248.180/types"

struct AppleRadarService: RadarService {

    func submit(radar radar: Radar) {
        
    }

    static func retrieveRadarComponents(completion: RadarComponents -> Void) {
        Alamofire.request(.GET, kAppleRadarServiceURL, encoding: .URLEncodedInURL).responseJSON { response in
            guard let dictionary = response.result.value as? NSDictionary else {
                return
            }

            let productDictionaries = dictionary["products"] as? [NSDictionary]
            let areaDictionaries = dictionary["areas"] as? [NSDictionary]
            let classificationDictionaries = dictionary["classifications"] as? [NSDictionary]
            let reproducibilityDictionaries = dictionary["reproducibilities"] as? [NSDictionary]

            let products = productDictionaries!.flatMap(Product.init)
            let areas = areaDictionaries!.flatMap(Area.init)
            let classifications = classificationDictionaries!.flatMap(Classification.init)
            let reproducibilities = reproducibilityDictionaries!.flatMap(Reproducibility.init)

            dispatch_async(dispatch_get_main_queue()) {
                let components = RadarComponents(products: products, areas: areas,
                    classifications: classifications, reproducibilities: reproducibilities)
                completion(components)
            }
        }
    }
}