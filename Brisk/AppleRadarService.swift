import Alamofire

private let kAppleRadarServiceURL = "http://10.10.248.180/types"

struct AppleRadarService: RadarService {

    func submit(radar radar: Radar) {}

    static func retrieveRadarComponents(completion: RadarComponents -> Void) {
        let sessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()

        Alamofire.request(.GET, kAppleRadarServiceURL, encoding: .URLEncodedInURL)
                 .responseJSON { response in
                    guard let dictionary = response.result.value as? NSDictionary else {
                        return
                    }

                    let productDictionaries = dictionary["products"] as? [NSDictionary]
                    let areaDictionaries = dictionary["areas"] as? [NSDictionary]
                    let classificationDictionaries = dictionary["classifications"] as? [NSDictionary]
                    let reproducibilityDictionaries = dictionary["reproducibilities"] as? [NSDictionary]

                    let products = productDictionaries!.flatMap(Product.withDictionary)
                    let areas = areaDictionaries!.flatMap(Area.withDictionary)
                    let classifications = classificationDictionaries!.flatMap(Classification.withDictionary)
                    let reproducibilities = reproducibilityDictionaries!.flatMap(Reproducibility.withDictionary)


                    let components = RadarComponents(products: products, areas: areas,
                        classifications: classifications, reproducibilities: reproducibilities)


                 }
    }
}