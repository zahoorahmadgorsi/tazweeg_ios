//
//  ChangePassVC.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 15/01/2019.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

class ChangePassVC: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var txtOldPassword: WATextField!
    @IBOutlet weak var txtNewPassword: WATextField!
    @IBOutlet weak var txtConfirmNewPassword: WATextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "changePassword".localized
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        if MOLHLanguage.isRTLLanguage() {
            self.txtOldPassword.textAlignment = .right
            self.txtNewPassword.textAlignment = .right
            self.txtConfirmNewPassword.textAlignment = .right
        }
        else{
            self.txtOldPassword.textAlignment = .left
            self.txtNewPassword.textAlignment = .left
            self.txtConfirmNewPassword.textAlignment = .left
        }
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        
//        self.txtOldPassword.text = "asdfasdf"
//        self.txtNewPassword.text = "asdfasdf"
//        self.txtConfirmNewPassword.text = "asdfasdf"
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.view = nil
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
    
    @IBAction func changeTap(_ sender: Any) {
        if txtOldPassword.text?.count == 0 {
            Utility.showAlertWithTitle(title: "validation".localized, withMessage: "old_pass_missing".localized, withNavigation: self)
            return
        }
        if txtNewPassword.text?.count == 0 {
            Utility.showAlertWithTitle(title: "validation".localized, withMessage: "new_pass_missing".localized, withNavigation: self)
            return
        }
        
        if (txtNewPassword.text?.count)! < 6 {
            Utility.showAlertWithTitle(title: "validation".localized, withMessage: "new_pass_length".localized, withNavigation: self)
            return
        }
        if txtNewPassword.text != txtConfirmNewPassword.text {
            Utility.showAlertWithTitle(title: "validation".localized, withMessage: "passwords_not_match".localized, withNavigation: self)
            return
        }
        if (Constants.loggedInMember != nil ){
            var dic = Dictionary<String,AnyObject>()
            dic["id"] = Constants.loggedInMember?.userId as AnyObject
            dic["password"] = txtNewPassword.text as AnyObject
            dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
            dic["appVersion"] = Utility.getAppVersion() as AnyObject
            print(dic)
            Utility.shared.showSpinner()
            ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiChangePassword, success: { (response) in
                Utility.shared.hideSpinner()
                print(response)
                if let status = response["Status"] as? Int {
                    if status == 1 {
                        Utility.showAlertWithOk(title: "success".localized, withMessage: "changePasswordSuccess".localized, withNavigation: self, withOkBlock: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    } else if status == 3 {
                        Utility.showAlertWithOk(title: "verification".localized, withMessage: "passwordIsMisMatched".localized, withNavigation: self, withOkBlock: {
                            Utility.logout()
                        })
                    }  else {
                        Utility.showAlertWithTitle(title: "verification".localized, withMessage: "failure".localized, withNavigation: self)
                    }
                }else {
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                }
                
            }) { (response) in
//                print(response)
                Utility.shared.hideSpinner()
            }
        }
    }
    

}
