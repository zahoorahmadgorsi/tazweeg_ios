//
//  SignUpVC.swift
//  Tazweeg
//
//  Created by iMac on 3/28/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

class ConsultantSignUpVC: UIViewController {
    
    @IBOutlet weak var btnSignup: WAButton!
    @IBOutlet weak var btnCancel: WAButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtEmirate: UITextField!
    @IBOutlet weak var svEmirates: UIStackView!
    
    var currentUser: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if MOLHLanguage.isRTL() {
            self.txtName.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtMobile.textAlignment = .right
            self.txtGender.textAlignment = .right
            self.txtEmirate.textAlignment = .right
        }
        else{
            self.txtEmail.textAlignment = .left
            self.txtName.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtMobile.textAlignment = .left
            self.txtGender.textAlignment = .left
            self.txtEmirate.textAlignment = .left
        }
//        if (currentUser == 0) //Member
//        {
//            self.svEmirates.isHidden = true
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSignupTapped(_ sender: Any) {
        if txtName.text?.count == 0 {
            //Utility.showAlertWithTitle(title: "alert".localized, withMessage: "name_is_missing".localized, withNavigation: self)
            
            Utility.showAlert(title: "alert".localized, withMessage: "name_is_missing".localized, withNavigation: self)
            return
        }
        if txtMobile.text?.count == 0 {
            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "phone_is_missing".localized, withNavigation: self)
            return
        }
        if !(Utility.isValidPhone(testStr: txtMobile.text!)) {
            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "phone_notValid".localized, withNavigation: self)
            return
        }
        
//        var dic = Dictionary<String,AnyObject>()
//        dic["name"] = txtName.text as AnyObject
//        dic["phone_number"] = txtMobile.text as AnyObject
//        //        dic["name"] = "" as AnyObject
//        let method = "registerVisitor"
//        Utility.shared.showSpinner()
//        ALFWebService.shared.doPostData(parameters: dic, method: method, success: { (response) in
//            print(response)
//            Utility.shared.hideSpinner()
//            if let status = response["status"] as? Int {
//                if status == 1 {
//                    let alertController = UIAlertController(title: "alert".localized, message: response["message"] as? String, preferredStyle: .alert)
//
//                    var myMutableString = NSMutableAttributedString()
//                    myMutableString = NSMutableAttributedString(string: "alert".localized, attributes: [NSAttributedStringKey.font : UIFont(name: "appFont".localized, size: 18)!,NSAttributedStringKey.foregroundColor : UIColor.blue])
//
//                    alertController.setValue(myMutableString, forKey: "attributedTitle")
//
//                    var messageMutableString = NSMutableAttributedString()
//                    messageMutableString = NSMutableAttributedString(string: response["message"] as! String, attributes: [NSAttributedStringKey.font : UIFont(name: "appFont".localized, size: 16)!])
//
//                    alertController.setValue(messageMutableString, forKey: "attributedMessage")
//
//
//                    alertController.addTextField { (textField : UITextField!) -> Void in
//                        textField.textAlignment = .right
//                    }
//                    let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: { alert -> Void in
//                        let firstTextField = alertController.textFields![0] as UITextField
//                        if firstTextField.text?.count == 0 {
//                            Utility.showAlertWithOK(title: "alert".localized, withMessage: "code_is_missing".localized, withNavigation: self, withOkBlock: {
//                                self.present(alertController, animated: true, completion: nil)
//                            })
//
//                        } else {
//                            self.verifyCode(code: firstTextField.text!, visiter_id: response["visitor_id"] as! Int)
//                        }
//                    })
//                    let cancelBtn = UIAlertAction(title: "cancel".localized, style: .cancel, handler: { alert -> Void in
//
//
//                    })
//                    let attributedText = NSMutableAttributedString(string: "ok".localized)
//
//                    let range = NSRange(location: 0, length: attributedText.length)
//                    attributedText.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: range)
//                    attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "appFont".localized, size: 18.0)!, range: range)
//
//                    let cancelAttributedText = NSMutableAttributedString(string: "cancel".localized)
//
//                    let cancelRange = NSRange(location: 0, length: cancelAttributedText.length)
//                    cancelAttributedText.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: cancelRange)
//                    cancelAttributedText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "appFont".localized, size: 18.0)!, range: cancelRange)
//
//
//                    alertController.addAction(okBtn)
//                    alertController.addAction(cancelBtn)
//
//                    self.present(alertController, animated: true, completion: nil)
//                    guard let cancelLbl = (cancelBtn.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
//                    cancelLbl.attributedText = cancelAttributedText
//                    guard let okLbl = (okBtn.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
//                    okLbl.attributedText = attributedText
//                } else {
//                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: response["message"] as! String, withNavigation: self)
//                }
//            }
//        }) { (response) in
//            print(response)
//            Utility.shared.hideSpinner()
//        }
    }
    
    func verifyCode(code: String, visiter_id: Int){
        var dic = Dictionary<String,AnyObject>()
        dic["visitor_id"] = visiter_id as AnyObject
        dic["verification_code"] = code as AnyObject
        
        let method = "verifyVisitor"
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utility.shared.hideSpinner()
            if let status = response["status"] as? Int {
                if status == 1 {
                    Utility.showAlertWithOK(title: "alert".localized, withMessage: response["message"] as! String, withNavigation: self, withOkBlock: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                } else {
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: response["message"] as! String, withNavigation: self)
                }
            }
        }) { (response) in
            print(response)
            Utility.shared.hideSpinner()
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        let loginVC = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .loginVC) as! LoginVC
        self.present(loginVC, animated:false, completion:nil)
    }
    
}
