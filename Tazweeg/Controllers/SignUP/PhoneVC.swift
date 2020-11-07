//
//  PhoneVC.swift
//  Tazweeg
//
//  Created by iMac on 10/02/2020.
//  Copyright © 2020 Tazweeg. All rights reserved.
//

import UIKit
import MOLH

class PhoneVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var svPhoneNumber: UIStackView!
    @IBOutlet weak var btnCountryFlag: UIButton!
    @IBOutlet weak var txtCountryCode: WATextField!
    @IBOutlet weak var txtMobileNumber: WATextField!
    @IBOutlet weak var btnCheckUncheck: UIButton!
    @IBOutlet weak var btnNext: WAButton!
    
    var countries = [Country]()
    var selectedCountry : Country?
    var isAcceptedTerms = false
    override func viewDidLoad() {
       super.viewDidLoad()
        self.txtMobileNumber.keyboardType = .asciiCapableNumberPad   //disabling arabic keyboard
        //Setting the background image of view controller
       self.view.layer.contents = UIImage(named: "bg-1")?.cgImage
        
        //Setting the cancel button at top right
        let rightBarButton = UIBarButtonItem(title: "cancel".localized, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backTap(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hexString: appColors.defaultColor.rawValue)
        self.navigationItem.title = "sign_up".localized
        
        self.svPhoneNumber.semanticContentAttribute = .forceLeftToRight
        //Backbutton
        if MOLHLanguage.isRTLLanguage() {
            self.txtCountryCode.textAlignment = .left
            self.txtMobileNumber.textAlignment = .left
        }
        else{
            self.txtCountryCode.textAlignment = .left
            self.txtMobileNumber.textAlignment = .left
        }
        
        self.txtMobileNumber.delegate = self
        getCountries()
        //To hide black bar which appears below navigation bar
//        https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        //changing button login background color
        btnNext.backgroundColor = UIColor(hexString: appColors.defaultColor.rawValue)
    }
    
    @objc func backTap(_ btn: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(btnLogin.frame.height/2)
        btnNext.cornerRadius = btnNext.frame.height/2
    }
    
    //*******************************
    //Loading all emirates From ahsan
    //*******************************
    func getCountries(){
        ALFWebService.shared.doGetData( method: Constants.apiGetCountries, success: { (response) in
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let countries = response["Countries"] as? [Dictionary<String,AnyObject>] {
                        self.countries.removeAll()
                        for em in countries {
                            self.countries.append(Country.init(fromDictionary: em))
                        }
                        //by default country at 0th index is selected which is UAE
                        self.selectedCountry = self.countries[0]
                        if let country = self.selectedCountry{
                            self.setCountry(country: country )
                        }
                    }
                }else {
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
                }
            }else {
                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
            }
        }) { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            Utility.showAlert(title: "error".localized, withMessage: "general_error".localized, withNavigation: self)
        }
    }
    
    @IBAction func btnCountryTapped(_ sender: Any) {
        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .countriesVC) as! CountriesVC
        viewController.countries = self.countries
        let viewControllerNav = UINavigationController(rootViewController: viewController)
        self.present(viewControllerNav, animated:true, completion:nil)  //presenting modally because we are expecting selected country data back
    }
    
    @IBAction func btnCheckUncheckTapped(_ sender: Any) {
        if isAcceptedTerms {
            isAcceptedTerms = false
            btnCheckUncheck.setBackgroundImage(UIImage(named: "uncheck"), for: .normal)
        } else {
            btnCheckUncheck.setBackgroundImage(UIImage(named: "check"), for: .normal)
            isAcceptedTerms = true
        }
    }

    @IBAction func btnTermsAndConditionTapped(_ sender: Any) {
        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
        viewController.pageType = .term
        viewController.isTerm = true;
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setCountry(country:Country)
    {
        self.selectedCountry = country
//        print(self.selectedCountry?.countryId as Any,self.selectedCountry?.countryEN as Any)
        var strImage : String = "uae_flag"
        switch self.selectedCountry?.countryId {
            case countryType.BAHRAIN.rawValue:
                strImage = "bahrain_flag"
            break
            case countryType.KSA.rawValue:
                strImage = "saudi_flag"
            break
            case countryType.KUWAIT.rawValue:
                strImage = "kuwait_flag"
            break
            case countryType.OMAN.rawValue:
                strImage = "oman_flag"
            break
//            case countryType.UAE.rawValue:
//                strImage = "uae_flag"
//            break
            default:    //UAE is default
                strImage = "uae_flag"
            break
        }
        self.btnCountryFlag.setBackgroundImage(UIImage(named: strImage), for: .normal)
        if let code = self.selectedCountry?.code{
            self.txtCountryCode.text = String(code)
        }
        
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        let stringWithNoLeadingZero = (txtMobileNumber.text ?? "").replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
//        print(stringWithNoLeadingZero)
        let phoneNumber = (txtCountryCode.text ?? "")  + stringWithNoLeadingZero
        if stringWithNoLeadingZero.count != 9 {
            Utility.showAlertWithTitle(title: "validation".localized, withMessage: "phone_notValid".localized, withNavigation: self)
            return
        }else if !(Utility.isValidPhone(testStr: phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines))) { //\t  \n trimming
                Utility.showAlertWithTitle(title: "validation".localized, withMessage: "phone_notValid".localized, withNavigation: self)
                return
        }
        if isAcceptedTerms == false {
            Utility.showAlertWithOk(title: "validation".localized, withMessage: "terms_required".localized, withNavigation: self) {
            }
            return
        }
        //Web API call start
        var dic = Dictionary<String,AnyObject>()
        let mobileNumber = (txtCountryCode.text ?? "") + (txtMobileNumber.text ?? "")
        dic["mobile"] = mobileNumber as AnyObject
        dic["countryId"] = selectedCountry?.countryId as AnyObject
        print(dic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method:  Constants.apiSignupMobileVerification, success: { (response) in
            print(response)
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if (self.selectedCountry?.countryId == countryType.KSA.rawValue){//if member or constulant is from KSA
                        //NO OTP verification is required just send the member to select state and consultant and nanvigate consultant to common signup
                        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){//Member
                            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .statesAndConsultantsVC) as! StatesAndConsultantsVC
                            viewController.selectedCountry = self.selectedCountry
                            viewController.mobileNumber =  mobileNumber
                            viewController.pageType = .signUp   //verification code is always signup
                            let viewControllerNav = UINavigationController(rootViewController: viewController)
                            self.present(viewControllerNav, animated:true, completion:nil)
                        }else if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue){//Consultant
                            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .commonSignUpVC) as! CommonSignUpVC
                            viewController.selectedCountry = self.selectedCountry
                            viewController.mobileNumber =  mobileNumber
                            let viewControllerNav = UINavigationController(rootViewController: viewController)
                            self.present(viewControllerNav, animated:true, completion:nil)
                        }
//                        })
                    }else{//other than KSA
                        if let data = response["Message"] as? Dictionary<String,AnyObject> {
                            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .otpVerificationVC) as! OTPVerificationVC
                            viewController.mobileNumber = mobileNumber
                            viewController.selectedCountry = self.selectedCountry
                            if let OTP = data["pin"] as? Int {  //passing OTP to verification screen
                                viewController.OTP = OTP
                            }
                            if let OTPExpiry = data["otpExpiry"] as? Int {  //passing OTPExpiry to verification screen
                                viewController.OTPExpiry = OTPExpiry
                            }
                            let viewControllerNav = UINavigationController(rootViewController: viewController)
                            self.present(viewControllerNav, animated:true, completion:nil)
                        }
                    }
                }else if status == 2 {
                    Utility.showAlertWithOkCancel(title: "information".localized, withMessage: "duplicateUser".localized, withNavigation: self, withOkBlock: {
                        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .forgotPasswordVC) as! ForgotPasswordVC
                        let viewControllerNav = UINavigationController(rootViewController: viewController)
                        self.present(viewControllerNav, animated:true, completion:nil)
                    }) {
                            self.dismiss(animated: true, completion: nil)
                    }
                }else {
                    Utility.showAlertWithTitle(title: "sign_up".localized, withMessage: "failure".localized, withNavigation: self)
                }
            }else {
                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
            }
        }) { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            Utility.showAlert(title: "error".localized, withMessage: "general_error".localized, withNavigation: self)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
}
