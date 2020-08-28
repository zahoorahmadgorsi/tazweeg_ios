//
//  ForgotPasswordVC.swift
//  Tazweeg
//
//  Created by iMac on 5/22/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

class ForgotPasswordVC: UIViewController,UITextFieldDelegate {
    
//    @IBOutlet weak var svPhoneNumber: UIStackView!
    @IBOutlet weak var txtPhoneNumber: WATextField!
    
//    @IBOutlet weak var svEmail: UIStackView!
    @IBOutlet weak var txtEmail: WATextField!
    @IBOutlet weak var btnSubmit: WAButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "forgotPassword".localized
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        //Setting the cancel button at top right
        let rightBarButton = UIBarButtonItem(title: "cancel".localized, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backTap(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hexString: appColors.defaultColor.rawValue)
        
        self.txtPhoneNumber.keyboardType = .asciiCapableNumberPad   //disabling arabic keyboard
        if MOLHLanguage.isRTLLanguage() {
            self.txtPhoneNumber.textAlignment = .right
            self.txtEmail.textAlignment = .right
        }
        else{
            self.txtPhoneNumber.textAlignment = .left
            self.txtEmail.textAlignment = .left
        }
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        
        //Test Data
//        self.txtPhoneNumber.text = "971589108662"
//        self.txtEmail.text = "zahoor.gorsi@gmail.com"
    }
    
    @objc func backTap(_ btn: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(btnLogin.frame.height/2)
        btnSubmit.cornerRadius = btnSubmit.frame.height/2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldEndEditing")
        textField.resignFirstResponder() //To stop keyboard to open
        return true
    }
    //MARK:- custom Methods
    
    @IBAction func btnSubmitTap(_ sender: Any) {
        
        if ((txtPhoneNumber.getCount() == 0  && txtEmail.getCount() == 0) ||    //Both are empty 
            (txtPhoneNumber.getCount() > 0  && txtEmail.getCount() > 0)         //Both are filled
            )  {
            Utility.showAlertWithTitle(title: "validation".localized, withMessage: "one_is_required".localized, withNavigation: self)
            return
        }
//        else if (txtPhoneNumber.getCount() > 0  && txtEmail.getCount() > 0)  {
//            Utility.showAlertWithTitle(title: "validation".localized, withMessage: "one_is_required".localized, withNavigation: self)
//            return
//        }
    
        var dic = Dictionary<String,AnyObject>()
        if (txtPhoneNumber.getCount() > 0){
            dic["forgotType"] = "sms" as AnyObject
            dic["value"] = txtPhoneNumber.text as AnyObject
        }else{
            dic["forgotType"] = "email" as AnyObject
            dic["value"] = txtEmail.text as AnyObject
        }
        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
        dic["appVersion"] = Utility.getAppVersion() as AnyObject
//        print(dic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiForgotPassword, success: { (response) in
            Utility.shared.hideSpinner()
//            print(response)
            
            if let status = response["Status"] as? Int {
                if status == 1 {
                    Utility.showAlertWithOk(title: "verification".localized, withMessage: "check_phone_email".localized, withNavigation: self, withOkBlock: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }else if status == 3 { //Not Exisit
                    Utility.showAlertWithOk(title: "verification".localized, withMessage: "emailPhoneNotExist".localized, withNavigation: self, withOkBlock: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }else if status == 4 { //User is Inactive, redirect him to verification page
                    Utility.showAlertWithOk(title: "verification".localized, withMessage: "check_phone".localized, withNavigation: self, withOkBlock: {
                        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .otpVerificationVC) as! OTPVerificationVC
                        if (self.txtPhoneNumber.getCount() > 0){
                            viewController.mobileNumber = self.txtPhoneNumber.text
                        }else if let phoneNumber = response["Phone"] as? String { //Incase of forgot password via email
                            viewController.mobileNumber = phoneNumber
                        }
                        self.navigationController?.pushViewController(viewController, animated: true)
                    })
                }else {
                    Utility.showAlertWithTitle(title: "verification".localized, withMessage: "failure".localized, withNavigation: self)
                }
            }else {
                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
            }
            
        }) { (response) in
//            print(response)
            Utility.shared.hideSpinner()
        }

    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print(string)
//        var newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
//        print(newText)
//        newText = Utility.convertArabicNumberToEnglish(newText)
//        print(newText)
//          // You can use this new text
//        let allowedCharacters = CharacterSet.decimalDigits
//        let characterSet = CharacterSet(charactersIn: string)
//        return allowedCharacters.isSuperset(of: characterSet)
//    }
}
