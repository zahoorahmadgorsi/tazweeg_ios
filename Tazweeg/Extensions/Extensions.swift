//
//  Extensions.swift
//  Preplsy
//
//  Created by Waqas Ali on 8/12/16.
//  Copyright © 2016 dinosoftlabs. All rights reserved.
//

import Foundation
import UIKit
//import CVCalendar

//extension NSError {
//    convenience init(errorMessage:String) {
//        self.init(domain: appDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
//    }
//}

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
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
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

public extension UISearchBar {
    
    func setTextColor(_ color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
extension Dictionary {
    
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    
    func mapPairs<OutKey: Hashable, OutValue>( transform: (Element) throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    
}
public extension UITextField {
    
    func getCount() -> Int {
        return self.text?.count ?? 0
    }
    func isValidTextField() -> Bool {
        if self.text?.isEmpty == true {
            return false
        }
        return true
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func setBottomBorder() {
//        self.borderStyle = .none
//        self.layer.backgroundColor = UIColor.white.cgColor
//
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius = 0.0
        
//        let bottomLine = CALayer()
//
//        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:self.frame.height - 1 ), size: CGSize(width: self.frame.width, height:  1))
//        bottomLine.backgroundColor = UIColor(red: 0/255, green: 174/255, blue: 239/255, alpha: 1.0).cgColor
//        self.borderStyle = UITextBorderStyle.none
//        self.layer.addSublayer(bottomLine)
    }
}


extension UIImage {
//    public func urlToImage(urlString: String) -> UIImage{
//        
//        let url = NSURL(string: Variables.SERVER_IP + "/" + urlString)
//        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
//        return  UIImage(data: data!)!
//        
//    }
//    
//    public func absoluteURL(ImageUrl: String) -> NSURL{
//        
//        let profileImageUrl = Variables.SERVER_IP + "/" + ImageUrl
//        
//        return NSURL(string: profileImageUrl)!
//        
//    }
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        color1.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/2, size.width/2)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleToFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
//    func compressImage(imageUrl:String)-> UIImage {
//        let imagenew:UIImage = UIImage().urlToImage(imageUrl)
//        return UIImage.compressImage(imagenew, compressRatio:0.9)
//    }
    
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(CGRect(x:0, y:size.height, width:size.width,height:size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x:0, y:size.height - lineWidth, width:size.width, height:lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}
extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    var png: Data? { return UIImagePNGRepresentation(self) }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
}

func RBSquareImageTo(_ image: UIImage, size: CGSize) -> UIImage? {
    return RBResizeImage(RBSquareImage(image), targetSize: size)
}

func RBSquareImage(_ image: UIImage) -> UIImage? {
    let originalWidth  = image.size.width
    let originalHeight = image.size.height
    
    var edge: CGFloat
    if originalWidth > originalHeight {
        edge = originalHeight
    } else {
        edge = originalWidth
    }
    
    let posX = (originalWidth  - edge) / 2.0
    let posY = (originalHeight - edge) / 2.0
    
    let cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)
    
    let imageRef = image.cgImage?.cropping(to: cropSquare);
    return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: image.imageOrientation)
}

func RBResizeImage(_ image: UIImage?, targetSize: CGSize) -> UIImage? {
    if let image = image {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    } else {
        return nil
    }
}

extension String {
    
    func isValidEmail() -> Bool {
        do {
        let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            let range = NSMakeRange(0, self.count)
        return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:range) != nil
        } catch{return false}
    }

    
    func isEmail(_ text:String?) -> Bool
    {
        let EMAIL_REGEX = "^([^@\\s]+)@((?:[-a-z0-9]+\\.)+[a-z]{2,})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX)
        return predicate.evaluate(with: text)
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).uppercased()
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}



extension URL {
    
    func isEmpty(_ text:String?) -> Bool
    {
        if text == nil {return true}
        
        if text!.isEmpty == true {return true}
        
        //    if text?.lowercaseString == "null" {return true}
        
        return false
        
    }
    
    func isURLValid(_ urlString:String?) -> Bool
    {
        if isEmpty(urlString) {return false}
        
        let url =  URL(string: urlString!)
        if url == nil {return false}
        
        
        let request = URLRequest(url: url!)
        return NSURLConnection.canHandle(request)
        
    }
}

extension Date {
    //12:18 PM
    static func timeStringFromUnixTime(_ unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    static func dayStringFromTime(_ unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "dd-MMMM"
        return dateFormatter.string(from: date)
    }
    
    //2016-19-18 12:18 PM
    static func timeAndDateFromUnix(_ unixTime:Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "yyyy-dd-MM hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    static func yearFromUnixTime(_ unixTime:Double) -> Date {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "MM dd yyyy"
        let string = dateFormatter.string(from: date)
        return dateFormatter.date(from: string)!
    }
    
    static func yearStringFromUnixTime(_ unixTime:Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
//        return dateFormatter.dateFromString(string)!
    }
    
    static func dateFromStrings(_ stringDate:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "hh:mm:ss a"
//        dateFormatter.dateStyle = .NoStyle
//        dateFormatter.timeStyle = .ShortStyle
        let date = dateFormatter.date(from: stringDate)
        return date!
    }
    
    static func dateFromStringConvertToString(_ stringDate: String) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: stringDate)
        dateFormatter.dateFormat =  "hh:mm a"
        let  newTime =  dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: date!)
        return newDate + " " + newTime
    }
    
    static func dateFromStringConvertToStringInTuple(_ stringDate: String) -> (newDate:String,newTime:String)  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: stringDate)
        dateFormatter.dateFormat =  "hh:mm a"
        let  newTime =  dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: date!)
        return (newDate,newTime)
    }
    
    static func checkDate(_ date: Date) -> String {
        var returnedDate = ""
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            returnedDate = "Today"
        } else if calendar.isDateInYesterday(date) {
            returnedDate = "Yesterday"
        } else {
            returnedDate = "None"
        }
        return returnedDate
    }
    
}


extension Calendar {
    
}

extension UIImageView {
    func circulate(radius: CGFloat){
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

extension Float {
    var round: String {
        return String(format: "%.1f", self)
    }
    var string2: String {
        return String(format: "%.2f", self)
    }
}


//
//extension Double {
//    /// Rounds the double to decimal places value
//    func roundToPlaces(places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return (self * 5).rounded() / 5
//    }
//}

//extension CVAuxiliaryView {
//    
//    public func drawShadow() {
//        self.layer.shadowRadius = 8.0
//        self.layer.shadowColor = UIColor(hexString: "#5B75D9").cgColor
//        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        self.layer.shouldRasterize = true
//        self.layer.shadowOpacity = 1.0
//        self.fillColor = UIColor(hexString: "#A2BAD9")
//    }
//    
//}

extension CGSize {
    
    func resizeFill(toSize: CGSize) -> CGSize {
        
        let scale : CGFloat = (self.height / self.width) < (toSize.height / toSize.width) ? (self.height / toSize.height) : (self.width / toSize.width)
        return CGSize(width: (self.width / scale), height: (self.height / scale))
        
    }
}
extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> ()) {
        pushViewController(viewController, animated: animated)
        
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    func popViewController(animated: Bool, completion: @escaping () -> ()) {
        popViewController(animated: animated)
        
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
extension UIView {
    
    /** This is the function to get subViews of a view of a particular type
     */
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    
    /** This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
    func changeFont() {
        let allButtons = self.allSubViewsOf(type: UIButton.self)
        let allLabels =  self.allSubViewsOf(type: UILabel.self)
        let alltextFields =  self.allSubViewsOf(type: UITextField.self)
        let alltextViews =  self.allSubViewsOf(type: UITextView.self)
        for btn in allButtons {
            var isBold: Bool {
                return (btn.titleLabel?.font.fontDescriptor.symbolicTraits.contains(.traitBold))!
            }
            if isBold {
                if AppDelegate.shared().lang == "en" {
                    btn.titleLabel?.textAlignment = .left
                    btn.titleLabel?.font = UIFont(name: appFont_bold_en, size: (btn.titleLabel?.font.pointSize)!)
                    
                } else {
                    btn.titleLabel?.textAlignment = .right
                    btn.titleLabel?.font = UIFont(name: appFont_bold_ar, size: (btn.titleLabel?.font.pointSize)!)
                }
                
                
            } else {
                if AppDelegate.shared().lang == "en" {
                    btn.titleLabel?.textAlignment = .left
                    btn.titleLabel?.font = UIFont(name: appFont_regular_en, size: (btn.titleLabel?.font.pointSize)!)
                    
                } else {
                    btn.titleLabel?.textAlignment = .right
                    btn.titleLabel?.font = UIFont(name: appFont_regular_ar, size: (btn.titleLabel?.font.pointSize)!)
                }
                
            }
            
            
        }
        for txt in alltextFields {
            var isBold: Bool {
                return txt.font!.fontDescriptor.symbolicTraits.contains(.traitBold)
            }
            if isBold {
                
                if AppDelegate.shared().lang == "en" {
                    txt.textAlignment = .left
                    txt.font = UIFont(name: appFont_bold_en, size: txt.font!.pointSize)
                } else {
                    txt.textAlignment = .right
                    txt.font = UIFont(name: appFont_bold_ar, size: txt.font!.pointSize)
                }
                
                
            } else {
                if AppDelegate.shared().lang == "en" {
                    txt.textAlignment = .left
                    txt.font = UIFont(name: appFont_regular_en, size: txt.font!.pointSize)
                    
                } else {
                    txt.textAlignment = .right
                    txt.font = UIFont(name: appFont_regular_ar, size: txt.font!.pointSize)
                }
            }
            
        }
        for txt in alltextViews {
            var isBold: Bool {
                return txt.font!.fontDescriptor.symbolicTraits.contains(.traitBold)
            }
            if isBold {
                
                if AppDelegate.shared().lang == "en" {
                    txt.textAlignment = .left
                    txt.font = UIFont(name: appFont_bold_en, size: txt.font!.pointSize)
                    
                } else {
                    txt.textAlignment = .right
                    txt.font = UIFont(name: appFont_bold_ar, size: txt.font!.pointSize)
                }
                
                
            } else {
                if AppDelegate.shared().lang == "en" {
                    txt.textAlignment = .left
                    txt.font = UIFont(name: appFont_regular_en, size: txt.font!.pointSize)
                    
                } else {
                    txt.textAlignment = .right
                    txt.font = UIFont(name: appFont_regular_ar, size: txt.font!.pointSize)
                }
            }
            
        }
        for lbl in allLabels {
            var isBold: Bool {
                return lbl.font.fontDescriptor.symbolicTraits.contains(.traitBold)
            }
            if isBold {
                if AppDelegate.shared().lang == "en" {
                    lbl.textAlignment = .left
                    lbl.font = UIFont(name: appFont_bold_en, size: lbl.font.pointSize)
                    
                } else {
                    lbl.textAlignment = .right
                    lbl.font = UIFont(name: appFont_bold_ar, size: lbl.font.pointSize)
                }
                
            } else {
                if AppDelegate.shared().lang == "en" {
                    lbl.textAlignment = .left
                    lbl.font = UIFont(name: appFont_regular_en, size: lbl.font.pointSize)
                    
                } else {
                    lbl.textAlignment = .right
                    lbl.font = UIFont(name: appFont_regular_ar, size: lbl.font.pointSize)
                }
            }
            
        }
    }
}
extension UITableView {
    func hideExtraCells(){
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
    //Showing a message when no record is available
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

public extension UINavigationController {
    
    /**
     Pop current view controller to previous view controller.
     
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func pop(transitionType type: String = kCATransitionFade, transitionDirectionType direction: String = kCATransitionFromRight, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, transitionDirectionType: direction, duration: duration)
        self.popViewController(animated: false)
    }
    /**
     Push a new view controller on the view controllers's stack.
     
     - parameter vc:       view controller to push.
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func push(viewController vc: UIViewController, transitionType type: String = kCATransitionFade, transitionDirectionType direction: String = kCATransitionFromRight, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, transitionDirectionType: direction, duration: duration)
        self.pushViewController(vc, animated: false)
    }
//    func changeNavigationDirection(){
//        let transition = CATransition.init()
//        transition.duration = 0.45
//        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
//        transition.type = kCATransitionPush //Transition you want like Push, Reveal
//        transition.subtype = kCATransitionFromLeft // Direction like Left to Right, Right to Left
//        transition.delegate = self
//        self.view.window!.layer.add(transition, forKey: kCATransition)
//    }

    private func addTransition(transitionType type: String = kCATransitionFade, transitionDirectionType direction: String = kCATransitionFromRight, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        transition.type = type
        transition.subtype = direction
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
}
extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
   
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func navTitle(titel: String) {
        self.navigationItem.title = titel
    }
    
    func addBackbutton(title: String) {
        if let nav = self.navigationController,
            let item = nav.navigationBar.topItem {
            item.backBarButtonItem  = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action:
                #selector(self.backButtonAction))
        } else {
            if let nav = self.navigationController,
                let _ = nav.navigationBar.backItem {
                self.navigationController!.navigationBar.backItem!.title = title
            }
        }
    }
    func resignFields(){
        self.view.endEditing(true)
        self.view.endEditing(false)
    }
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        self.view.endEditing(false)
        
    }
    
    func setFont() {
        let allButtons = self.view.allSubViewsOf(type: UIButton.self)
        let allLabels =  self.view.allSubViewsOf(type: UILabel.self)
        let alltextFields =  self.view.allSubViewsOf(type: UITextField.self)
        let alltextViews =  self.view.allSubViewsOf(type: UITextView.self)
        for btn in allButtons {
            var isBold: Bool {
                return (btn.titleLabel?.font.fontDescriptor.symbolicTraits.contains(.traitBold))!
            }
            if isBold {
                if AppDelegate.shared().lang == "en" {
                    btn.titleLabel?.textAlignment = .left
                    btn.titleLabel?.font = UIFont(name: appFont_bold_en, size: (btn.titleLabel?.font.pointSize)!)
                    
                } else {
                    btn.titleLabel?.textAlignment = .right
                    btn.titleLabel?.font = UIFont(name: appFont_bold_ar, size: (btn.titleLabel?.font.pointSize)!)
                }
                
                
            } else {
                if AppDelegate.shared().lang == "en" {
                    btn.titleLabel?.textAlignment = .left
                    btn.titleLabel?.font = UIFont(name: appFont_regular_en, size: (btn.titleLabel?.font.pointSize)!)
                    
                } else {
                    btn.titleLabel?.textAlignment = .right
                    btn.titleLabel?.font = UIFont(name: appFont_regular_ar, size: (btn.titleLabel?.font.pointSize)!)
                }
                
            }
            
            
        }
        for txt in alltextFields {
            var isBold: Bool {
                return txt.font!.fontDescriptor.symbolicTraits.contains(.traitBold)
            }
            if !txt.isSecureTextEntry {
                if isBold {
                    
                    if AppDelegate.shared().lang == "en" {
                        txt.textAlignment = .left
                        txt.font = UIFont(name: appFont_bold_en, size: txt.font!.pointSize)
                        
                    } else {
                        txt.textAlignment = .right
                        txt.font = UIFont(name: appFont_bold_ar, size: txt.font!.pointSize)
                    }
                    
                    
                } else {
                    if AppDelegate.shared().lang == "en" {
                        txt.textAlignment = .left
                        txt.font = UIFont(name: appFont_regular_en, size: txt.font!.pointSize)
                        
                    } else {
                        txt.textAlignment = .right
                        txt.font = UIFont(name: appFont_regular_ar, size: txt.font!.pointSize)
                    }
                }
            }
            
            
        }
        for txt in alltextViews {
            var isBold: Bool {
                return txt.font!.fontDescriptor.symbolicTraits.contains(.traitBold)
            }
            if isBold {
                
                if AppDelegate.shared().lang == "en" {
                    txt.textAlignment = .left
                    txt.font = UIFont(name: appFont_bold_en, size: txt.font!.pointSize)
                    
                } else {
                    txt.textAlignment = .right
                    txt.font = UIFont(name: appFont_bold_ar, size: txt.font!.pointSize)
                }
                
                
            } else {
                if AppDelegate.shared().lang == "en" {
                    txt.textAlignment = .left
                    txt.font = UIFont(name: appFont_regular_en, size: txt.font!.pointSize)
                    
                } else {
                    txt.textAlignment = .right
                    txt.font = UIFont(name: appFont_regular_ar, size: txt.font!.pointSize)
                }
            }
            
        }
        for lbl in allLabels {
            var isBold: Bool {
                return lbl.font.fontDescriptor.symbolicTraits.contains(.traitBold)
            }
            if isBold {
                if AppDelegate.shared().lang == "en" {
                    lbl.textAlignment = .left
                    lbl.font = UIFont(name: appFont_bold_en, size: lbl.font.pointSize)
                    
                } else {
                    lbl.textAlignment = .right
                    lbl.font = UIFont(name: appFont_bold_ar, size: lbl.font.pointSize)
                }
                
            } else {
                if AppDelegate.shared().lang == "en" {
                    lbl.textAlignment = .left
                    lbl.font = UIFont(name: appFont_regular_en, size: lbl.font.pointSize)
                    
                } else {
                    lbl.textAlignment = .right
                    lbl.font = UIFont(name: appFont_regular_ar, size: lbl.font.pointSize)
                }
            }
            
        }
    }
    
}

//public extension UIStackView {
//    func addBackground(color: UIColor) {
//        let subView = UIView(frame: bounds)
//        subView.backgroundColor = color
//        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        insertSubview(subView, at: 0)
//    }
//}
