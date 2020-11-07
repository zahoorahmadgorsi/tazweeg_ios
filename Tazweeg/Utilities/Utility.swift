import UIKit
import Photos
import MOLH
import SystemConfiguration
import MessageUI
import CoreTelephony

typealias OkBlock = () -> Void
typealias cancelBlock = () -> Void

enum PageType {
    case term
    case privacy
    case faq
    case facebook
    case instagram
    case pintrest
    case telegram
    case twitter
    case signUp
    case transfer
    case allMembers
    case pendingMembers
    case payment
    case profile
    case choosings
}

enum dateTimeFormat:String {
    case onDevice = "dd-MMM-yyyy"
    case toServer = "MM/dd/yyyy"
    case fromServer = "yyyy-MM-dd'T'HH:mm:ss"
}

enum appColors:String {
    case lightBlueBackground = "#F4F9FD"
    case defaultColor = "#00AEEF"
//    case defaultColor = "#0050FF"
    case lightGray = "#EAEDEE"
    case whiteColor = "#FFFFFF"
    case blackColor =  "#000000"
}

enum socialStatusCode:Int {
    case single = 56
    case married = 57
    case divorced = 58
    case window = 59
    case dontMatter = 842
}

enum isSmokingCode:Int {
    case no = 12
    case yes = 13
}

enum isWorkingCode:Int{
    case working = 60
    case notWorking = 61
    case dontMatter = 62
}

enum genderType:Int {
    case both = 0
    case male = 7
    case female = 8
}

enum profileStatusType:Int {
    case incomplete = 837   //pending
    case notPaid = 9        //Completed
    case paid = 10          //Choosing
    case matching = -1       //Matching
    case finished = 857     //married
    case cancelled = 11     //cancelled
}

enum matchStatusType:Int {
    case choosing = 0       //unselected
    case matching = 1       //selected
    case refused = 2       //refused
    case married = 3        //accepted
}

//By default member  = 4 and consultant = 3
enum UserType:Int {
    case admin = 2
    case consultant = 3
    case member = 4
}

enum countryType:Int {
    case UAE = 218
    case KSA = 181
    case OMAN = 157
    case KUWAIT = 110
    case BAHRAIN = 17
}

enum stateCode:Int {
    case others = 10
}

enum paymentType:Int {
    case choosing = 10
    case matching = 1092
}



class Utility: NSObject
{
    static let shared = Utility()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
//    var strColor = "#00AEEF" //spinner color
    
    class func isValidEmail(emailToValidate:String) -> Bool
    {
        print("validate calendar: \(emailToValidate)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailToValidate)
    }
    
    class func isValidPhone(testStr:String) -> Bool
    {
        //commenting this because now we have implemented GCC
        let phoneRegEx = "^(?:971|966|968|965|973)(?:1|2|3|4|5|6|7|8|9)[0-9]{8}$"   //Count code then 1-9 and then 8 digit phone number

        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        let isMatched = phoneTest.evaluate(with: testStr)
        return isMatched
    }
    
    class func isLoggedIn() -> Bool {
        if (UserDefaults.standard.bool(forKey: "isLoggedIn") == true) {
            // perform your task here
            return true
        }else  {
            return false
        }
        
    }
    
    class func getLoggedInMember() -> Member? {
        var loggedInMember : Member?
        if let loggedInUser = UserDefaults.standard.object(forKey: "LoggedInUser") as? Data
        {
            loggedInMember = NSKeyedUnarchiver.unarchiveObject(with: loggedInUser) as? Member
        }
        return loggedInMember
    }
    
    class func logout() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        AppDelegate.shared().isAlreadyLoggedIn(isLanguageResetOrSignedOut: true)
    }
    
//    class func calculateAge(date:Date) -> Int{
//        let now = Date()
////        print(date , now)
//        let calendar = Calendar.current
//        let ageComponents = calendar.dateComponents([.year,.month,.day], from: date, to: now)
//        let age = ageComponents.year!
////        print("\(ageComponents.year ?? 0) Year, \(ageComponents.month ?? 0) Month, \(ageComponents.day ?? 0) Day")
//        return age
//    }
    
    class func calculateAge(date:Date) -> DateComponents{
        let now = Date()
//        print(date , now)
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year,.month,.day], from: date, to: now)
//        let age = ageComponents.year!
////        print("\(ageComponents.year ?? 0) Year, \(ageComponents.month ?? 0) Month, \(ageComponents.day ?? 0) Day")
//        return age
        return ageComponents
    }
    
    public func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
//        manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
//            thumbnail = result!
//        })
        manager.requestImageData(for: asset, options: option) { data, str, _, _ in

            if let data = data {
                thumbnail = UIImage(data: data)!
            }
        }
        return thumbnail
    }
    
    public func showActivityIndicatory(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        //        container.backgroundColor = UIColor.init(netHex: 0xffffff).withAlphaComponent(0.3) //UIColorFromHex(0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //        activityIndicator.activityIndicatorViewStyle =
        //            UIActivityIndicatorViewStyle.white
        activityIndicator.color = UIColor(hexString: "#555555")
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,y :loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        uiView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    public func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        uiView.isUserInteractionEnabled = true
        container.removeFromSuperview()
    }
    
    private func setSpinner() {
        let window = UIApplication.shared.keyWindow!
        
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        loadingView.backgroundColor = UIColor(hexString: "#F0F0F0").withAlphaComponent(0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        //activityIndicator.color = UIColor(hexString: "#E2A340")
        activityIndicator.color = UIColor(hexString: appColors.defaultColor.rawValue)
        activityIndicator.tintColor = UIColor(hexString: "#E2A340")
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,y :loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        loadingView.center = window.center
        window.addSubview(loadingView)
        
        window.isUserInteractionEnabled = false
        //        container.addSubview(loadingView)
        //        uiView.addSubview(container)
        //        uiView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    public func showSpinner() {
        DispatchQueue.main.async {
            self.setSpinner()
        }
    }
    
    public func hideSpinner() {
        DispatchQueue.main.async {
            self.removeSpinner()
        }
    }
    
    private func removeSpinner() {
        let window = UIApplication.shared.keyWindow!
        
        activityIndicator.stopAnimating()
        window.isUserInteractionEnabled = true
        //        uiView.isUserInteractionEnabled = true
        loadingView.removeFromSuperview()
    }
    
    class func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        var components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
//        print(components)
        components.hour = components.hour! - 5
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    
    class func isConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
            
        }) else {
            
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
//    class func dateFromStringConvertToString(_ stringDate: String) -> String  {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        //        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let date = dateFormatter.date(from: stringDate)
//        //        dateFormatter.dateFormat =  "hh:mm a"
//        //        let  newTime =  dateFormatter.string(from: date!)
//        dateFormatter.dateFormat = "d MMM, yyyy"
//        let newDate = dateFormatter.string(from: date!)
//        return newDate
//    }
    
    class func stringFromDateWithFormat(_ date: Date, format: String) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") //Other wise dateFormatter.date wil convert to arabic if local is arabic ,  en_US_POSIX
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
//        print(date)
//        if MOLHLanguage.isRTLLanguage() {
//            //If you change localeIdentifier above from "ar_DZ" to "ar", also numeric values gets written in arabic characters
//            dateFormatter.locale = Locale(identifier: "ar_DZ")
//        }else{
//            dateFormatter.locale = Locale(identifier: "en_US")
//        }
        let dateString = dateFormatter.string(from: date)
//        print(dateString)
        return dateString
    }
    
    class func stringToDate(_ stringDate: String, format: String) -> Date  {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") //Other wise dateFormatter.date wil convert to arabic if local is arabic ,  en_US_POSIX
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
//        print(stringDate)
        let date = dateFormatter.date(from: stringDate) ?? Date.init()  // If you will use "ar_DZ" in above function stringFromDateWithFormat then this line will convert arabic date like 1983-نوفمبر-02 to nil and default date of todays date would be used

//        print(date)
        return date
    }
    
    class func timeDtringFromDate(_ date: Date) -> String  {
//        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func showAlertWithOkCancel(title: String, withMessage: String, withNavigation: UIViewController, withOkBlock:@escaping OkBlock, withCancelBlock:@escaping cancelBlock) {

        let alertController : UIAlertController = UIAlertController(title: title, message: withMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction : UIAlertAction = UIAlertAction(title: "ok".localized, style: .default){
            ACTION -> Void in
            withOkBlock()
        }
        let cancelAction : UIAlertAction = UIAlertAction(title: "cancel".localized, style: .cancel){
            ACTION -> Void in
            withCancelBlock()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
//        print(alertController.view.subviews)
        
        withNavigation.present(alertController, animated: true, completion: nil)
        
    }
    
    class func showAlertWithCustomButtontitles(btnOktitle: String, btnCanceltitle: String,title: String, withMessage: String, withNavigation: UIViewController, withOkBlock:@escaping OkBlock, withCancelBlock:@escaping cancelBlock) {
        
        let alertController : UIAlertController = UIAlertController(title: title, message: withMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction : UIAlertAction = UIAlertAction(title: btnOktitle, style: .cancel){
            ACTION -> Void in
            withOkBlock()
        }
        let cancelAction : UIAlertAction = UIAlertAction(title: btnCanceltitle, style: .default){
            ACTION -> Void in
            withCancelBlock()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
//        print(alertController.view.subviews)
        
        withNavigation.present(alertController, animated: true, completion: nil)
        
    }
    
    public class func showAlert(title: String, withMessage: String, withNavigation: UIViewController) {
        let alert = UIAlertController(title: title, message: withMessage, preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "ok".localized, style: .default){
            ACTION -> Void in
        }
        alert.addAction(okAction)
        withNavigation.present(alert, animated: true, completion: nil)
    }
    
    class func showActionSheet(title: String, withMessage: String, withNavigation: UIViewController, withCamBlock:@escaping OkBlock, withGalleryBlock:@escaping OkBlock, withCancelBlock:@escaping cancelBlock) {
        let localize = Localize()
        let alertController : UIAlertController = UIAlertController(title: title, message: withMessage, preferredStyle: UIAlertControllerStyle.actionSheet)
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: title, attributes: [NSAttributedStringKey.font : UIFont(name: appFont_regular_ar, size: 18)!,NSAttributedStringKey.foregroundColor : UIColor.white])
        
        alertController.setValue(myMutableString, forKey: "attributedTitle")
        
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: withMessage, attributes: [NSAttributedStringKey.font : UIFont(name: localize.appFont, size: 16)!])
        
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        let camAction : UIAlertAction = UIAlertAction(title: localize.camera, style: .default){
            ACTION -> Void in
            
            
            withCamBlock()
        }
        let galleryAction : UIAlertAction = UIAlertAction(title: localize.gallery, style: .default){
            ACTION -> Void in
            
            withGalleryBlock()
        }
        let cancelAction : UIAlertAction = UIAlertAction(title: localize.cancel, style: .cancel){
            ACTION -> Void in
            
            
            withCancelBlock()
        }
        let attributedText = NSMutableAttributedString(string: localize.camera)
        
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: range)
        attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: localize.appFont, size: 18.0)!, range: range)
        
        
        let galleryAttributedText = NSMutableAttributedString(string: localize.gallery)
        
        let gallRange = NSRange(location: 0, length: galleryAttributedText.length)
        galleryAttributedText.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: gallRange)
        galleryAttributedText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: localize.appFont, size: 18.0)!, range: gallRange)
        
        let cancelAttributedText = NSMutableAttributedString(string: localize.cancel)
        
        let cancelRange = NSRange(location: 0, length: cancelAttributedText.length)
        cancelAttributedText.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: cancelRange)
        cancelAttributedText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: localize.appFont, size: 18.0)!, range: cancelRange)
        
        
        alertController.addAction(camAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
//        print(alertController.view.subviews)
        
        withNavigation.present(alertController, animated: true, completion: nil)
        guard let galleryLbl = (galleryAction.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
        galleryLbl.attributedText = cancelAttributedText
        guard let camLbl = (camAction.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
        camLbl.attributedText = attributedText
        guard let galLbl = (galleryAction.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
        galLbl.attributedText = galleryAttributedText
        
    }
//    class func showAlertWithOK(title: String, withMessage: String, withNavigation: UIViewController, withOkBlock:@escaping OkBlock) {
//        let localize = Localize()
//        let alertController : UIAlertController = UIAlertController(title: title, message: withMessage, preferredStyle: UIAlertControllerStyle.alert)
//        var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string: title, attributes: [NSAttributedStringKey.font : UIFont(name: appFont_regular_ar, size: 18)!,NSAttributedStringKey.foregroundColor : UIColor.blue])
//
//        alertController.setValue(myMutableString, forKey: "attributedTitle")
//
//        var messageMutableString = NSMutableAttributedString()
//        messageMutableString = NSMutableAttributedString(string: withMessage, attributes: [NSAttributedStringKey.font : UIFont(name: localize.appFont, size: 16)!])
//
//        alertController.setValue(messageMutableString, forKey: "attributedMessage")
//        let okAction : UIAlertAction = UIAlertAction(title: localize.ok, style: .default){
//            ACTION -> Void in
//
//            withOkBlock()
//        }
//
//        let attributedText = NSMutableAttributedString(string: localize.ok)
//
//        let range = NSRange(location: 0, length: attributedText.length)
//        attributedText.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: range)
//        attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: localize.appFont, size: 18.0)!, range: range)
//
//        alertController.addAction(okAction)
//        print(alertController.view.subviews)
//
//        withNavigation.present(alertController, animated: true, completion: nil)
//
//        guard let okLbl = (okAction.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
//        okLbl.attributedText = attributedText
//    }
    
    class func showAlertWithOk(title: String, withMessage: String, withNavigation: UIViewController, withOkBlock:@escaping OkBlock) {
        let alertController : UIAlertController = UIAlertController(title: title, message: withMessage, preferredStyle: UIAlertControllerStyle.alert)

        let okAction : UIAlertAction = UIAlertAction(title: "ok".localized, style: .default){
            ACTION -> Void in
            withOkBlock()
        }
        alertController.addAction(okAction)
        withNavigation.present(alertController, animated: true, completion: nil)
    }
    
//    class func showAlertWithTitle(title: String, withMessage: String, withNavigation: UIViewController) {
//        let localize = Localize()
//        let alert = UIAlertController(title: title, message: withMessage, preferredStyle: .alert)
//
//        var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string: title, attributes: [NSAttributedStringKey.font : UIFont(name: appFont_regular_ar, size: 18)!,NSAttributedStringKey.foregroundColor : UIColor.blue])
//
//        alert.setValue(myMutableString, forKey: "attributedTitle")
//
//        var messageMutableString = NSMutableAttributedString()
//        messageMutableString = NSMutableAttributedString(string: withMessage, attributes: [NSAttributedStringKey.font : UIFont(name: localize.appFont, size: 16)!])
//
//        alert.setValue(messageMutableString, forKey: "attributedMessage")
//        let okAction : UIAlertAction = UIAlertAction(title: "ok".localized, style: .default){
//            ACTION -> Void in
//
//
//        }
//        let attributedText = NSMutableAttributedString(string: "ok".localized)
//
//        let range = NSRange(location: 0, length: attributedText.length)
//        attributedText.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: range)
//        attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: localize.appFont, size: 18.0)!, range: range)
//
//        var btnMutableString = NSMutableAttributedString()
//        btnMutableString = NSMutableAttributedString(string: withMessage, attributes: [NSAttributedStringKey.font : UIFont(name: localize.appFont, size: 18)!])
//
//
//        okAction.setValue(btnMutableString, forKey: "titleTextColor")
//        alert.addAction(okAction)
//
//        withNavigation.present(alert, animated: true, completion: nil)
//        guard let okLbl = (okAction.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
//        okLbl.attributedText = attributedText
//    }

    class func showAlertWithTitle(title: String, withMessage: String, withNavigation: UIViewController) {
        let alert = UIAlertController(title: title, message: withMessage, preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "ok".localized, style: .default){
            ACTION -> Void in
        }
        alert.addAction(okAction)
        withNavigation.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertWithoutTitle( withMessage: String, withNavigation: UIViewController) {
        let alert = UIAlertController(title: nil, message: withMessage, preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "ok".localized, style: .default){
            ACTION -> Void in
        }
        alert.addAction(okAction)
        withNavigation.present(alert, animated: true, completion: nil)
    }
    

    
    //    class func downloadImageForImageView(imageView: UIImageView, url: String) -> Void
    //    {
    //        let imageRequest = NSURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
    //
    //        imageView.setImageWith(imageRequest as URLRequest, placeholderImage: UIImage(named: "user-3"), success: nil, failure: nil)
    //    }
    //
    //    class func downloadImageForButton(button: UIButton, url: String) -> Void
    //    {
    //        let imageRequest = NSURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
    //
    //        button.setBackgroundImageFor(.normal, with: imageRequest as URLRequest, placeholderImage: UIImage(named: "user-3"), success: nil, failure: nil)
    //    }
    static let numberFormater: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .default
        return formatter
    }()
    
    
    class func getIndexByID(dict: [Dictionary<String,AnyObject>] , ID:Int) -> Int{
        
        var index : Int = 0
        for val in dict{
            if let valId = val["ValueId"] as? Int {
                if  valId == ID{
                    return index
                }
            }
            index += 1
        }
        return -1 //it should be -1 but for app stability making it 0
    }
    
    class func getIndexByValue(dict: [Dictionary<String,AnyObject>] , value:String) -> Int{
        var index : Int = 0
        for val in dict{
//            print(val)
            var stringVal = val["ValueEN"] as? String
            if (MOLHLanguage.isRTLLanguage()){
                stringVal = val["ValueAR"] as? String
            }
            if  stringVal == value{
                return index
            }
            index += 1
        }
        return -1
    }
    
    class func getAppVersionAndBuild() -> String {
        let dictionary = Bundle.main.infoDictionary!
//        let strVersion = dictionary["CFBundleShortVersionString"] as? String
        let strBuild = dictionary["CFBundleVersion"] as? String
//        return "Version: \(strVersion ?? "") Build: \(strBuild ?? "")"
        return getAppVersion() + " Build: \(strBuild ?? "")"
    }
    
    class func getAppVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let strVersion = dictionary["CFBundleShortVersionString"] as? String
        return "Version: \(strVersion ?? "")"
    }
    
    class func makeAPhoneCall( strPhoneNumber:String)
    {
        if strPhoneNumber.count != 0 {
            if let url = URL(string: "tel://\(strPhoneNumber)"),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                // add error message here
                print("Error in calling a phone number")
            }
        }
    }
    
    class func composeEmail() -> String {
        var emailBody : String = "\n\nUser Information:\n"
        if let userCode = Constants.loggedInMember?.code{
            emailBody += "User Code: " + userCode + "\n"
        }
        if let phoneNumber = Constants.loggedInMember?.phone{
            emailBody += "Phone Number: " + phoneNumber.stringValue + "\n"
        }
        emailBody += "\nApp Information:\n"
        emailBody += Utility.getAppVersionAndBuild() + "\n"
        emailBody += "\nDevice Information:\n"
        emailBody += "Device: " + UIDevice.modelName + "\n"
        emailBody += "IOS Version: " + UIDevice.current.systemVersion + "\n"
        if let strLang = Locale.current.languageCode{
            emailBody += "Device Language: " + strLang + "\n"
        }
        emailBody += "Application Language: " + Locale.preferredLanguages[0] + "\n"
        // Setup the Network Info and create a CTCarrier object
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        if let strCarrierName = carrier?.carrierName{
            emailBody += "Carrier: " + strCarrierName + "\n"
        }
        //timeZone
        if let strTimeZone = TimeZone.current.abbreviation(){
            emailBody += "TimeZone: " + strTimeZone + "\n"
        }
        //Network Status i.e. Wifi
        let networkString = networkInfo.currentRadioAccessTechnology
        //        print (networkString as Any)
        var strNetwork : String = ""
        if networkString == CTRadioAccessTechnologyLTE{
            strNetwork = "LTE (4G)"
        }else if networkString == CTRadioAccessTechnologyWCDMA{
            strNetwork = "3G"
        }else if networkString == CTRadioAccessTechnologyEdge{
            strNetwork = "EDGE (2G)"
        }
        emailBody += "Connection Status: " + strNetwork + "\n"
        print(emailBody)
        
        return emailBody
        
    }
    
    class func printToConsole(message : String) {
        #if DEBUG
            print(message)
        #endif
    }
    
    class func getDeviceInfo()-> String {
        var deviceInfo : String = Utility.getAppVersionAndBuild() + " "
        deviceInfo += "Device:" + UIDevice.modelName + " "
        deviceInfo += "IOS:" + UIDevice.current.systemVersion + " "
        //timeZone
        if let strTimeZone = TimeZone.current.abbreviation(){
            deviceInfo += "TimeZone:" + strTimeZone
        }
        return deviceInfo
    }
    
    class func openWhatsapp(phoneNumber:String, viewController: UIViewController){
        let urlWhats = "whatsapp://send?phone=" + phoneNumber
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
//                    (title: String, withMessage: String, withNavigation: UIViewController)
                    self.showAlert(title: "missing_whats_app".localized, withMessage:"install_whats_app".localized, withNavigation: viewController)
                }
            }
        }
    }
    
//    class func hexStringToUIColor (hex:String) -> UIColor {
//       var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//       if (cString.hasPrefix("#")) {
//           cString.remove(at: cString.startIndex)
//       }
//       if ((cString.count) != 6) {
//           return UIColor.gray
//       }
//       var rgbValue:UInt32 = 0
//       Scanner(string: cString).scanHexInt32(&rgbValue)
//       return UIColor(
//           red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//           green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//           blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//           alpha: CGFloat(1.0)
//       )
//   }
}

