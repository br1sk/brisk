# Sonar

An interface to create radars on [Apple's bug tracker](https://radar.apple.com)
frictionless from swift.

## Example

### Login

```swift
let sonar = Sonar()
sonar.login(withAppleID: appleID, password: password) { result in
    guard case let .Success(products) = result else {
        return
    }

    print(products) // These are all the supported products
}
```

### Create radar

```swift
let radar = Radar(
    classification: .Feature, product: products[2], reproducibility: .Always,
    title: "Add REST API to Radar", description: "Add REST API to Radar", steps: "N/A",
    expected: "Radar to have a REST API available", actual: "HTML", configuration: "N/A",
    version: "Any", notes: "N/A"
)

sonar.create(radar: radar) { result in
    print(result.value) // This is the radar ID!
}
```
