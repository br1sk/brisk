extension Classification {
    public static let Security = Classification(appleIdentifier: 1, name: "Security")
    public static let Crash = Classification(appleIdentifier: 2, name: "Crash/Hang/Data Loss")
    public static let Power = Classification(appleIdentifier: 3, name: "Power")
    public static let Performance = Classification(appleIdentifier: 4, name: "Performance")
    public static let UI = Classification(appleIdentifier: 5, name: "UI/Usability")
    public static let SeriousBug = Classification(appleIdentifier: 6, name: "Serious Bug")
    public static let OtherBug = Classification(appleIdentifier: 8, name: "Other Bug")
    public static let Feature = Classification(appleIdentifier: 10, name: "Feature (New)")
    public static let Enhancement = Classification(appleIdentifier: 11, name: "Enhancement")

    public static let All: [Classification] = [
        .Security, .Crash, .Power, .Performance, .UI, .SeriousBug, .Feature, .Enhancement
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
