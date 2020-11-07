//
//  VerificationCode.swift
//  Tazweeg
//
//  Created by iMac on 5/5/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

class OTPVerificationVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtVerificationCode: UITextField!
    @IBOutlet weak var btnSubmit: WAButton!
    @IBOutlet weak var lblOTPExpiry: UILabel!
    var selectedCountry : Country?
    var mobileNumber : String?
    var OTPExpiry:Int = 600 //default value is 10 minutes
    var OTP:Int?
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Backbutton
        if MOLHLanguage.isRTLLanguage() {
            let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "right arrow"), style: .plain, target: self, action: #selector(self.backTap(_:)))
            self.navigationItem.leftBarButtonItem = backBtn
        }
        else{
            let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "left arrow"), style: .plain, target: self, action: #selector(self.backTap(_:)))
            self.navigationItem.leftBarButtonItem = backBtn
        }

        self.navigationItem.title = "verification_code".localized
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(btnLogin.frame.height/2)
        btnSubmit.cornerRadius = btnSubmit.frame.height/2
    }
    
    @objc func updateCounter() {
//        print(OTPExpiry)
        //example functionality
        if OTPExpiry <= 0 {
            timer?.invalidate()
            timer = nil
            self.dismiss(animated: true, completion: nil)   //dismissing this page
        }else{ //if let otp = OTPExpiry {
            OTPExpiry -= 1
            let minutes = OTPExpiry / 60
            let seconds = OTPExpiry % 60
//            print(minutes,seconds)
            //string format like 00:00
            self.lblOTPExpiry.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
        }
    }
    
    @objc func backTap(_ btn: UIBarButtonItem){
        //        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        txtVerificationCode.resignFirstResponder()
        if let otpCode = OTP{
            if ( String(otpCode) == txtVerificationCode.text){
                //OTP verified locally
                timer?.invalidate()
                timer = nil
                //After OTP verification, send the member to select state and consultant and to consultant to common signup
                Utility.showAlertWithOk(title: "verification".localized, withMessage: "otp_verified".localized, withNavigation: self, withOkBlock: {
                    if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){//Member
                        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .statesAndConsultantsVC) as! StatesAndConsultantsVC
                        viewController.selectedCountry = self.selectedCountry
                        viewController.mobileNumber =  self.mobileNumber
                        viewController.pageType = .signUp   //verification code is always signup
                        self.navigationController?.pushViewController(viewController, animated: true)   // now user cant come back to OTPVerification page
                    }else if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue){//Consultant
                        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .commonSignUpVC) as! CommonSignUpVC
                        viewController.selectedCountry = self.selectedCountry
                        viewController.mobileNumber =  self.mobileNumber
                        self.navigationController?.pushViewController(viewController, animated: true)   // now user cant come back to OTPVerification page
                    }
                })
            }else{  //invalid OTP entered
                Utility.showAlertWithTitle(title: "verification".localized, withMessage: "invalid_verification_code".localized, withNavigation: self)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnResendOTPTapped(_ sender: Any) {
        //Web API call start
        var dic = Dictionary<String,AnyObject>()
        dic["mobile"] = mobileNumber as AnyObject
        dic["countryId"] = selectedCountry?.countryId as AnyObject
        print(dic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method:  Constants.apiSignupMobileVerification, success: { (response) in
            print(response)
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let data = response["Message"] as? Dictionary<String,AnyObject> {
                        if let OTP = data["pin"] as? Int {  //passing OTP to verification screen
                            self.OTP = OTP
                        }
                        if let OTPExpiry = data["otpExpiry"] as? Int {  //passing OTPExpiry to verification screen
                            self.OTPExpiry = OTPExpiry
//                            self.OTPExpiry = 10    //Testing
                        }else{
                            self.OTPExpiry = 600    //reset to default value
                        }
                        //resetting the timer
                        self.timer?.invalidate()
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
                    }
                }else if status == 2 {
                    Utility.showAlertWithOk(title: "information".localized, withMessage: "duplicateUser".localized, withNavigation: self, withOkBlock: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }else {
                    Utility.showAlertWithTitle(title: "sign_up".localized, withMessage: "failure".localized, withNavigation: self)
                }
            }else {
                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
            }
        }) { (response) in
            Utility.shared.hideSpinner()
            Utility.showAlert(title: "error".localized, withMessage: "general_error".localized, withNavigation: self)
        }
    }
    
}
