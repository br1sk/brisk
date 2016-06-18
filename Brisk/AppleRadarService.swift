import Alamofire

private let kTypesURL = "http://10.10.248.180/types"
private let kSubmitURL = "http://10.10.248.180/radar"

struct AppleRadarService: RadarService {

    func submit(radar radar: Radar) {
        Alamofire.request(.POST, kSubmitURL, parameters: radar.toDictionary()).responseJSON { response in
            guard let dictionary = response.result.value as? NSDictionary else {
                return
            }
            print(dictionary)
        }

    }

    static func retrieveRadarComponents(completion: RadarComponents -> Void) {
        Alamofire.request(.GET, kTypesURL, encoding: .URLEncodedInURL).responseJSON { response in
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

private extension Radar {
    private func toDictionary() -> [String: AnyObject] {
        return [
            "product": self.product.id,
            "classification": self.classification.id,
            "reproducibility": self.reproducibility.id,
            "area": self.area.id,
            "title": self.title,
            "description": self.description,
            "steps": self.steps,
            "expected": self.expected,
            "actual": self.actual,
            "configuration": self.configuration,
            "version": self.version,
            "notes": self.notes,
        ]
    }
}
