import Cocoa

extension NSColor {

    /// Creates an instance of NSColor based on an RGB value.
    ///
    /// - parameter rgbValue: The Integer representation of the RGB value: Example: 0xFF0000.
    /// - parameter alpha:    The desired alpha for the color.
    convenience init(rgbValue: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// CGColor created using an sRGB color space
    var sRGBCGColor: CGColor? {
        return self.cgColor
            .components
            .flatMap { CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: $0) }
    }

    /// Creates an instance of NSColor by offseting its HSB values.
    ///
    /// - parameter brightnessDelta:  This delta it's going to be added to the current brightness. It can be
    ///                               negative to make the color darker or positive to make it brighter. From
    ///                               0 to 1.
    /// - parameter saturationFactor: This delta it's going to be added to the current saturation. From 0 to
    ///                               1.
    /// - parameter brightnessCap:    The maximum acceptable brightness.
    ///
    /// - returns: The newly created color with the new brightness value.
    public func colorByAddingBrightness(_ brightnessDelta: CGFloat,
                                        andSaturationFactor saturationFactor: CGFloat? = nil,
                                        brightnessCap: CGFloat = 1.0) -> NSColor
    {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let newSaturation = saturationFactor.map { $0 * saturation } ?? saturation
        let newBrightness = max(min(brightness + brightnessDelta, brightnessCap), 0.0)
        return NSColor(hue: hue, saturation: newSaturation, brightness: newBrightness, alpha: alpha)
    }

    // MARK: - Brisk colors

    static var moon: NSColor { return NSColor(rgbValue: 0xCFD7E0) }
    static var steel: NSColor { return NSColor(rgbValue: 0x269BDC) }
}
