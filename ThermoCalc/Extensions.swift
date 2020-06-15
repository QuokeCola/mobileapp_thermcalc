//
//  DeviceInfo.swift
//  ThermoCalc
//  Thanks for the code from stackoverflow:
//  https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model

import UIKit

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

// Allows searchbar's Textfield's placeholders detect touch.
extension UITextField {
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if let candidate = subview.hitTest(convertedPoint, with: event) {
                if subview.tag != 0 {
                    return candidate
                }
            }
        }
        return self
    }
    
}

// Detect searchbar size change for hiding the placeholders.
extension UISearchBar {
    override open var bounds: CGRect {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationSearchBarSizeChangeKey), object: bounds)
        }
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

func getToolbarHeight()->CGFloat {
    let DeviceModel = UIDevice.modelName
    let Orientation = UIApplication.shared.statusBarOrientation
    switch Orientation {
    case .landscapeLeft:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 53.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 70.0
        } else if (DeviceModel.contains("Plus")) {
            return 49.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 70.0
        } else if DeviceModel.contains("iPad") {
            return 50.0
        } else {
            return 32.0
        }
    case .landscapeRight:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 53.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 70.0
        } else if (DeviceModel.contains("Plus")) {
            return 49.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 70.0
        } else if DeviceModel.contains("iPad") {
            return 50.0
        } else {
            return 32.0
        }
    case .portrait:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 83.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 83.0
        } else if (DeviceModel.contains("Plus")) {
            return 49.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 70.0
        } else if DeviceModel.contains("iPad") {
            return 50.0
        } else {
            return 49.0
        }
    case .portraitUpsideDown:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 83.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 83.0
        } else if (DeviceModel.contains("Plus")) {
            return 49.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 70.0
        } else if DeviceModel.contains("iPad") {
            return 50.0
        } else {
            return 49.0
        }
    case .unknown:
        return 50.0
    }
}

func getTitleBarHeight()->CGFloat {
    let DeviceModel = UIDevice.modelName
    let Orientation = UIApplication.shared.statusBarOrientation
    switch Orientation {
    case .landscapeLeft:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 32.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 32.0
        } else if (DeviceModel.contains("Plus")) {
            return 64.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 74.0
        } else if DeviceModel.contains("iPad") {
            return 70.0
        } else {
            return 52.0
        }
    case .landscapeRight:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 32.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 32.0
        } else if (DeviceModel.contains("Plus")) {
            return 64.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 74.0
        } else if DeviceModel.contains("iPad") {
            return 70.0
        } else {
            return 52.0
        }
    case .portrait:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 88.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 88.0
        } else if (DeviceModel.contains("Plus")) {
            return 64.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 74.0
        } else if DeviceModel.contains("iPad") {
            return 70.0
        } else {
            return 64.0
        }
    case .portraitUpsideDown:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 88.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 88.0
        } else if (DeviceModel.contains("Plus")) {
            return 64.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 74.0
        } else if DeviceModel.contains("iPad") {
            return 70.0
        } else {
            return 64.0
        }
    case .unknown:
        return 64.0
    }
}

func getBottomHeight()->CGFloat {
    let DeviceModel = UIDevice.modelName
    let Orientation = UIApplication.shared.statusBarOrientation
    switch Orientation {
    case .landscapeLeft:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 21.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 21.0
        } else if (DeviceModel.contains("Plus")) {
            return 0.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 15.0
        } else if DeviceModel.contains("iPad") {
            return 0.0
        } else {
            return 0.0
        }
    case .landscapeRight:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 21.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 21.0
        } else if (DeviceModel.contains("Plus")) {
            return 0.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 15.0
        } else if DeviceModel.contains("iPad") {
            return 0.0
        } else {
            return 0.0
        }
    case .portrait:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 34.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 34.0
        } else if (DeviceModel.contains("Plus")) {
            return 0.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 15.0
        } else if DeviceModel.contains("iPad") {
            return 0.0
        } else {
            return 0.0
        }
    case .portraitUpsideDown:
        if(DeviceModel == "iPhone XS" || DeviceModel == "iPhone X" || DeviceModel == "iPhone 11 Pro") {
            return 34.0
        } else if (DeviceModel == "iPhone XS Max" || DeviceModel == "iPhone XR" || DeviceModel == "iPhone 11 Pro Max" || DeviceModel == "iPhone 11") {
            return 34.0
        } else if (DeviceModel.contains("Plus")) {
            return 0.0
        } else if (DeviceModel.contains("iPad Pro (11-inch)") || DeviceModel == "iPad Pro (12.9-inch) (3rd generation)" || DeviceModel == "iPad Pro (12.9-inch) (4th generation)"){
            return 15.0
        } else if DeviceModel.contains("iPad") {
            return 0.0
        } else {
            return 0.0
        }
    case .unknown:
        return 0.0
    }
}
