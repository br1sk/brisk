extension Classification {
    public static let Security = Classification(appleIdentifier: 1, name: "Security")
    public static let Crash = Classification(appleIdentifier: 2, name: "Crash/Hang/Data Loss")
    public static let Power = Classification(appleIdentifier: 3, name: "Power")
    public static let Performance = Classification(appleIdentifier: 4, name: "Performance")
    public static let UI = Classification(appleIdentifier: 5, name: "UI/Usability")
    public static let SeriousBug = Classification(appleIdentifier: 7, name: "Serious Bug")
    public static let OtherBug = Classification(appleIdentifier: 8, name: "Other Bug")
    public static let Feature = Classification(appleIdentifier: 10, name: "Feature (New)")
    public static let Enhancement = Classification(appleIdentifier: 11, name: "Enhancement")

    public static let All: [Classification] = [
        .Security, .Crash, .Power, .Performance, .UI, .SeriousBug, .OtherBug, .Feature, .Enhancement
    ]
}

extension Reproducibility {
    public static let Always = Reproducibility(appleIdentifier: 1, name: "Always")
    public static let Sometimes = Reproducibility(appleIdentifier: 2, name: "Sometimes")
    public static let Rarely = Reproducibility(appleIdentifier: 3, name: "Rarely")
    public static let Unable = Reproducibility(appleIdentifier: 4, name: "Unable")
    public static let DidntTry = Reproducibility(appleIdentifier: 5, name: "I didn't try")
    public static let NotApplicable = Reproducibility(appleIdentifier: 6, name: "Not Applicable")

    public static let All: [Reproducibility] = [
        .Always, .Sometimes, .Rarely, .Unable, .DidntTry, .NotApplicable
    ]
}

extension Area {
    public static let Accessibility = Area(appleIdentifier: 1, name: "Accessibility")
    public static let APNS = Area(appleIdentifier: 2, name: "APNS (Notifications)")
    public static let AppSwitcher = Area(appleIdentifier: 3, name: "App Switcher")
    public static let AVFoundation = Area(appleIdentifier: 4, name: "AVFoundation (Audio / Video)")
    public static let BatteryLife = Area(appleIdentifier: 5, name: "Battery Life")
    public static let Bluetooth = Area(appleIdentifier: 6, name: "Bluetooth")
    public static let Calendar = Area(appleIdentifier: 7, name: "Calendar")
    public static let CarPlay = Area(appleIdentifier: 8, name: "CarPlay")
    public static let CellularService = Area(appleIdentifier: 9, name: "Cellular Service (Calls / Data)")
    public static let CloudKit = Area(appleIdentifier: 10, name: "CloudKit (iCloud)")
    public static let Contacts = Area(appleIdentifier: 11, name: "Contacts")
    public static let ControlCenter = Area(appleIdentifier: 12, name: "Control Center")
    public static let CoreLocation = Area(appleIdentifier: 13, name: "CoreLocation (Location Services)")
    public static let DeviceManagement = Area(appleIdentifier: 14, name: "Device Management / Profiles")
    public static let Facetime = Area(appleIdentifier: 15, name: "Facetime")
    public static let GameKit = Area(appleIdentifier: 16, name: "GameKit")
    public static let HealthKit = Area(appleIdentifier: 17, name: "HealthKit")
    public static let HomeKit = Area(appleIdentifier: 18, name: "HomeKit")
    public static let iPodAccessoryProtocol = Area(appleIdentifier: 19, name: "iPod Accessory Protocol (AP)")
    public static let iTunesConnect = Area(appleIdentifier: 20, name: "iTunes Connect")
    public static let iTunesStore = Area(appleIdentifier: 21, name: "iTunes Store")
    public static let Keyboard = Area(appleIdentifier: 22, name: "Keyboard")
    public static let LockScreen = Area(appleIdentifier: 23, name: "Lock Screen")
    public static let Mail = Area(appleIdentifier: 24, name: "Mail")
    public static let MapKit = Area(appleIdentifier: 25, name: "MapKit")
    public static let Messages = Area(appleIdentifier: 26, name: "Messages")
    public static let Metal = Area(appleIdentifier: 27, name: "Metal")
    public static let Music = Area(appleIdentifier: 28, name: "Music")
    public static let NightShift = Area(appleIdentifier: 29, name: "Night Shift")
    public static let Notes = Area(appleIdentifier: 30, name: "Notes")
    public static let NotificationCenter = Area(appleIdentifier: 31, name: "Notification Center")
    public static let NSURL = Area(appleIdentifier: 32, name: "NSURL")
    public static let PhoneApp = Area(appleIdentifier: 33, name: "Phone App")
    public static let Photos = Area(appleIdentifier: 34, name: "Photos")
    public static let Reminders = Area(appleIdentifier: 35, name: "Reminders")
    public static let SafariServices = Area(appleIdentifier: 36, name: "Safari Services")
    public static let SceneKit = Area(appleIdentifier: 37, name: "SceneKit")
    public static let SetupAssistant = Area(appleIdentifier: 38, name: "Setup Assistant")
    public static let SoftwareUpdate = Area(appleIdentifier: 39, name: "Software Update")
    public static let Spotlight = Area(appleIdentifier: 40, name: "Spotlight")
    public static let SpringBorad = Area(appleIdentifier: 41, name: "SpringBorad (Home Screen)")
    public static let SpriteKit = Area(appleIdentifier: 42, name: "SpriteKit")
    public static let StoreKit = Area(appleIdentifier: 43, name: "StoreKit")
    public static let SystemSlow = Area(appleIdentifier: 44, name: "System Slow/Unresponsive")
    public static let TouchID = Area(appleIdentifier: 45, name: "TouchID")
    public static let UIKit = Area(appleIdentifier: 46, name: "UIKit")
    public static let VPN = Area(appleIdentifier: 47, name: "VPN")
    public static let WebKit = Area(appleIdentifier: 48, name: "WebKit")
    public static let WiFi = Area(appleIdentifier: 49, name: "Wi-Fi")
    public static let Xcode = Area(appleIdentifier: 50, name: "Xcode")
    public static let OtherArea = Area(appleIdentifier: 51, name: "Other Area")

    public static let All: [Area] = [
        .Accessibility, .APNS, .AppSwitcher, .AVFoundation, .BatteryLife, .Bluetooth, .Calendar, .CarPlay,
        .CellularService, .CloudKit, .Contacts, .ControlCenter, .CoreLocation, .DeviceManagement, .Facetime,
        .GameKit, .HealthKit, .HomeKit, .iPodAccessoryProtocol, .iTunesConnect, .iTunesStore, .Keyboard,
        .LockScreen, .Mail, .MapKit, .Messages, .Metal, .Music, .NightShift, .Notes, .NotificationCenter,
        .NSURL, .PhoneApp, .Photos, .Reminders, .SafariServices, .SceneKit, .SetupAssistant, .SoftwareUpdate,
        .Spotlight, .SpringBorad, .SpriteKit, .StoreKit, .SystemSlow, .TouchID, .UIKit, .VPN, .WebKit, .WiFi,
        .Xcode, .OtherArea
    ]
}

extension Product {

    private init(_ appleIdentifier: Int, _ category: String, _ name: String) {
        self.appleIdentifier = appleIdentifier
        self.category = category
        self.name = name
    }

    public static let iOS = Product(579020, "iOS", "OS and Development")
    public static let iOSSDK = Product(584784, "iOS SDK", "OS and Development")
    public static let macOS = Product(137701, "OS X", "OS and Development")
    public static let macOSSDK = Product(430026, "OS X SDK", "OS and Development")
    public static let macOSServer = Product(84100, "OS X Server", "OS and Development")
    public static let tvOS = Product(660932, "tvOS", "OS and Development")
    public static let tvOSSDK = Product(662000, "tvOS SDK", "OS and Development")
    public static let watchOS = Product(645251, "watchOS", "OS and Development")
    public static let watchOSSDK = Product(645445, "watchOS SDK", "OS and Development")
    public static let DeveloperTools = Product(175326, "Developer Tools", "OS and Development")
    public static let Documentation = Product(183045, "Documentation", "OS and Development")
    public static let iTunesConnect = Product(500515, "iTunes Connect", "OS and Development")
    public static let ParallaxPreviewer = Product(720650, "Parallax Previewer", "OS and Development")
    public static let SampleCode = Product(205728, "Sample Code", "OS and Development")
    public static let TechNote = Product(385563, "Tech Note/Q&A", "OS and Development")
    public static let iBooks = Product(571983, "iBooks", "Applications and Software")
    public static let iCloud = Product(458288, "iCloud", "Applications and Software")
    public static let iLife = Product(445858, "iLife", "Applications and Software")
    public static let iTunes = Product(430173, "iTunes", "Applications and Software")
    public static let iWork = Product(372025, "iWork", "Applications and Software")
    public static let Mail = Product(372031, "Mail", "Applications and Software")
    public static let ProApps = Product(175412, "Pro Apps", "Applications and Software")
    public static let QuickTime = Product(84201, "QuickTime", "Applications and Software")
    public static let Safari = Product(175305, "Safari", "Applications and Software")
    public static let SafariBeta = Product(697770, "Safari Technology Preview", "Applications and Software")
    public static let Siri = Product(750751, "Siri", "Applications and Software")
    public static let SwiftPlaygrounds = Product(743970, "Swift Playgrounds", "Applications and Software")
    public static let AppleTV = Product(430025, "Apple TV", "Hardware")
    public static let iPad = Product(375383, "iPad", "Hardware")
    public static let iPhone = Product(262954, "iPhone/iPod touch", "Hardware")
    public static let iPod = Product(185585, "iPod", "Hardware")
    public static let Mac = Product(213680, "Mac", "Hardware")
    public static let Printing = Product(213679, "Printing/Fax", "Hardware")
    public static let OtherHardware = Product(657117, "Other Hardware", "Hardware")
    public static let CarPlayAccessoryCert = Product(571212, "CarPlay Accessory Certification", "Hardware")
    public static let HomeKitAccessoryCert = Product(601986, "HomeKit Accessory Certification", "Hardware")
    public static let Accessibility = Product(437784, "Accessibility", "Other")
    public static let AppStore = Product(251822, "App Store", "Other")
    public static let MacAppStore = Product(430023, "Mac App Store", "Other")
    public static let BugReporter = Product(242322, "Bug Reporter", "Other")
    public static let iAdNetwork = Product(445860, "iAd Network", "Other")
    public static let iAdProducer = Product(446084, "iAd Producer", "Other")
    public static let Java = Product(84060, "Java", "Other")
    public static let Other = Product(20206, "Other", "Other")

    public static let All: [Product] = [
        .iOS, .iOSSDK, .macOS, .macOSSDK, .macOSServer, .tvOS, .tvOSSDK, .watchOS, .watchOSSDK,
        .DeveloperTools, .Documentation, .iTunesConnect, .ParallaxPreviewer, .SampleCode, .TechNote,
        .iBooks, .iCloud, .iLife, .iTunes, .iWork, .Mail, .ProApps, .QuickTime, .Safari, .SafariBeta, .Siri,
        .SwiftPlaygrounds, .AppleTV, .iPad, .iPhone, .iPod, .Mac, .Printing, .OtherHardware,
        .CarPlayAccessoryCert, .HomeKitAccessoryCert, .Accessibility, .AppStore, .MacAppStore, .BugReporter,
        .iAdNetwork, .iAdProducer, .Java, .Other,
    ]
}
