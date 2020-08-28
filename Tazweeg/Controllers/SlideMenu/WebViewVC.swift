//
//  TermPrivacyVC.swift
//  Pedia Club
//
//  Created by zahoor ahmad gorsi on 1/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH
import WebKit

class WebViewVC: UIViewController , WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    var isTerm = false
    var pageType = PageType.term
    var currentMember : Member?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.shared.showSpinner()
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.view = webView
        webView.navigationDelegate = self
        
        var url : String = ""
        if pageType == .term {
            if MOLHLanguage.isRTLLanguage() {
                url = Constants.urlTermsAndConditionsAR
            }else{
                url = Constants.urlTermsAndConditionsEN
            }
            let url = URL(string: url)
            webView.load(URLRequest(url: url!))
            self.navigationItem.title = "terms_and_condition".localized
        } else if pageType == .privacy {
            if MOLHLanguage.isRTLLanguage() {
                url = Constants.urlPrivacyPolicyAR
            }else{
                url = Constants.urlPrivacyPolicyEN
            }
            let url = URL(string: url)
            webView.load(URLRequest(url: url!))
            self.navigationItem.title = "privacy_policy".localized
        } else if pageType == .faq {
            if MOLHLanguage.isRTLLanguage() {
                url = Constants.urlFrequentylAskedQuestionsAR
            }else{
                url = Constants.urlFrequentylAskedQuestionsEN
            }
            let url = URL(string: url)
            webView.load(URLRequest(url: url!))
            self.navigationItem.title = "faqs".localized
        }else if pageType == .facebook {
            let url = URL(string: Constants.urlFacebook)
            webView.load(URLRequest(url: url!))
            self.navigationItem.title = "facebook".localized
        }else if pageType == .instagram {
            let url = URL(string: Constants.urlInstagram)
            webView.load(URLRequest(url: url!))
            self.navigationItem.title = "instagram".localized
        }else if pageType == .pintrest {
            let url = URL(string: Constants.urlPintrest)
            webView.load(URLRequest(url: url!))
            self.navigationItem.title = "pinterest".localized
        }else if pageType == .telegram {
            let url = URL(string: Constants.urlTelegram)
            webView.load(URLRequest(url: url!))
            self.navigationItem.title = "telegram".localized
        }else if pageType == .twitter {
            let url = URL(string: Constants.urlTwitter)
            webView.load(URLRequest(url: url!))
            self.navigationItem.title = "twitter".localized
        }else if pageType == .payment {
            self.navigationItem.title = "payment".localized
            if let member = self.currentMember{
                var age:Int = 0
                if (member.age == nil){ //if age is nill then calculate it from DOB
                    if let dob = member.birthDate{
                        age = Utility.calculateAge(date: dob).year ?? 0
                        member.age = String(age)
                    }
                }
                print(member.age)
                //if swiped member age is not nill AND its greater then equal to 35 AND its gender is female && swiping member is not an admin THEN show apply age check
                if (member.age != nil && Int(member.age) ?? 36 >= 35 && member.genderId == genderType.female.rawValue && Constants.loggedInMember?.typeId != UserType.admin.rawValue){
                    Utility.shared.hideSpinner()
                    Utility.showAlertWithOk(title: "payment".localized, withMessage: "age_check".localized, withNavigation: self, withOkBlock: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    getPaymentURL()
                }
            }
        }
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func getPaymentURL(){
        if let member = self.currentMember{
            var dic = Dictionary<String,AnyObject>()
            dic["emailAddress"] = (String(member.userId) + "@tazweeg.com") as AnyObject //member.email as AnyObject
            dic["paymentType"] = paymentType.choosing.rawValue as AnyObject
            dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
            dic["appVersion"] = Utility.getAppVersion() as AnyObject
            let method = Constants.apiGetPaymentURL + String(member.userId)
            Utility.shared.showSpinner()
//            print(dic)
            ALFWebService.shared.doPostData(parameters: dic, method: method, success: { (response) in
//                print(response)
                Utility.shared.hideSpinner()
                if let status = response["Status"] as? Int {
                    if status == 1 {
                        if let paymentGatewayURL = response["getUrl"] as? String{
                            let url = URL(string: paymentGatewayURL)
                            self.webView.load(URLRequest(url: url!))
                        }
                    }else if status == 2 {
                        Utility.showAlertWithOk(title: "payment".localized, withMessage: "already_paid".localized, withNavigation: self, withOkBlock: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    } else if status == 3 {
                        Utility.logout()
                    }else {
                        Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
                    }
                }else {
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                }
            }) { (response) in
//                print(response)
                Utility.shared.hideSpinner()
                Utility.showAlert(title: "error".localized, withMessage: "general_error".localized, withNavigation: self)
            }
        }
    }
    
    func getPaymentConfirmation(referenceNumber:String){
        if Constants.loggedInMember != nil{
            if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue ){ //
                var dic = Dictionary<String,AnyObject>()
                dic["refNo"] = referenceNumber as AnyObject
                dic["userId"] = self.currentMember?.userId as AnyObject
                dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
                dic["appVersion"] = Utility.getAppVersion() as AnyObject
                let method = Constants.apiGetPaymentStatus
                Utility.shared.showSpinner()
                ALFWebService.shared.doPostData(parameters: dic, method: method, success: { (response) in
                    Utility.shared.hideSpinner()
                    if let status = response["Status"] as? Int {
                        if status == 1 {    //Captured
                            if let data = response["Data"] as? Dictionary<String,AnyObject> {
                                //To store a custom object into userdefaults you have to encode it
                                let tempMember : Member = Member.init(fromDictionary: data)
                                self.currentMember = tempMember
                                //To store latest object into userdefaults, so that if member want to edit, it should have latest values
                                //If current user is a member and he is using his own profile then make it consistent else dont persist
                                if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue &&
                                    Constants.loggedInMember?.userId == self.currentMember?.userId){//Member
                                    let userArchivedData = NSKeyedArchiver.archivedData(withRootObject: tempMember )
                                    UserDefaults.standard.set(userArchivedData, forKey: "LoggedInUser") //Saving full user into shared preferences
                                    Constants.loggedInMember = Utility.getLoggedInMember()
                                }
                            }
                            Utility.showAlertWithOk(title: "payment".localized, withMessage: "profile_completed".localized, withNavigation: self, withOkBlock: {
                                self.navigationController?.popToRootViewController(animated: true)  //it will take to the profile screen
//                                 It will take to matching screen with no navigation back to payment
//                                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .memberDetailVC) as! MemberDetailVC
//                                //viewController.memberID = Constants.loggedInMember?.userId
//                                viewController.memberDetail = Constants.loggedInMember
//                                viewController.infoTyp = .matching //Open matching tab
//                                self.navigationController?.setViewControllers(viewController, animated: true)
                            })
                        }else {
                            Utility.showAlertWithOk(title: "payment".localized, withMessage: "payment_failure".localized, withNavigation: self, withOkBlock: {
                                self.navigationController?.popViewController(animated: true)
                            })
                            
                        }
                    }else {
                        Utility.showAlertWithOk(title: "payment".localized, withMessage: "general_error".localized, withNavigation: self, withOkBlock: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }) { (response) in
//                    print(response)
                    Utility.shared.hideSpinner()
                    Utility.showAlert(title: "error".localized, withMessage: "general_error".localized, withNavigation: self)
                }
            
            }
        }
    }
    
    func webViewDidStartLoad(_ : WKWebView) {
        Utility.shared.hideSpinner()
    }

    func webViewDidFinishLoad(_ : WKWebView) {
        Utility.shared.hideSpinner()
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)
    {
//        print("navigationAction.navigationType = " + String (navigationAction.navigationType.rawValue))
        let redirectURL = navigationAction.request.url?.absoluteString ?? "Nothing"
//        print("navigationAction.request.url = " + redirectURL)
        if(navigationAction.navigationType == .other)
        {
            //At payment a URL is received like this
            //http://www.tazweeg.ae/matching/?ref=52a1789f-7234-44eb-8fef-ece77f209c9e
            if redirectURL.contains(Constants.urlPaymentRedirect)
            {
                let splittedArray = redirectURL.characters.split{$0 == "="}.map(String.init)
                if (splittedArray.count > 0){//miniumum one entry should be there
                    var referenceNumber = ""
                    referenceNumber = splittedArray[splittedArray.count - 1]
//                    Confirm the payment status again this reference number
//                    referenceNumber = "52a1789f-7234-44eb-8fef-ece77f209c9e" // captured
//                    referenceNumber = "41bd4796-edae-49f1-bb50-31ce9a59bf6b" // captured
                    getPaymentConfirmation(referenceNumber: referenceNumber)
                }
                //do what you need with url
//                self.delegate?.openURL(url: navigationAction.request.url!)
                decisionHandler(.cancel)
                return
            }
            
        }
        decisionHandler(.allow)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- custom Methods
    @objc func backTap(_ btn: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
//        print("Finish Loading")
        Utility.shared.hideSpinner()
    }

}
