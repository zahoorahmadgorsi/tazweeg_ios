//
//  LoginVC.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 30/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH
import SlideMenuControllerSwift
import TPKeyboardAvoiding

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: WAButton!
//    @IBOutlet weak var btnCancel: WAButton!
    @IBOutlet weak var btnSignUp: WAButton!
    
    @IBOutlet weak var lblLoginWelcome: UILabel!
    @IBOutlet weak var lblCopyRights: UILabel!
    @IBOutlet weak var lblVersionBuild: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        //Setting the cancel button at top right
        let rightBarButton = UIBarButtonItem(title: "cancel".localized, style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnCancelTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hexString: appColors.defaultColor.rawValue)
        self.navigationItem.title = "login".localized
        
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue ){//Member
            self.lblLoginWelcome.text = "member_login".localized
            //Member
            txtUserName.text = "Tazweeg_"
            
//            Demo Account @ Live Server
//            txtUserName.text = "Tazweeg_1606"
//            txtPassword.text = "tazweeg786"
            
//            txtUserName.text = "Tazweeg_1608" //Female
//            txtPassword.text = "tazweeg786"

//            txtUserName.text = "Tazweeg_1917"   //Male
//            txtPassword.text = "398981"
//            Mr Humaid
//            txtUserName.text = "Tazweeg_2"
//            txtPassword.text = "787796"
//            My User on ahsan local
//            txtUserName.text = "Tazweeg_1496"
//            txtPassword.text = "884460"
        }else{
            self.lblLoginWelcome.text = "consultant_login".localized
            //Test Data
//            Demo Account @ Demo Consultant
//            txtUserName.text = "Tazweeg_1605"
//            txtPassword.text = "tazweeg786"
            
//            txtUserName.text = "Tazweeg_1607"
//            txtPassword.text = "tazweeg786"
            
//            txtUserName.text = "Admin"
//            txtPassword.text = "admin786"
            
//            Mr humaid
//            txtUserName.text = "AUH3@Tazweeg.com"
//            txtPassword.text = "auh3654321"
            //            My User on ahsan local
//            txtUserName.text = "AUH3@tazweeg.com"
//            txtPassword.text = "auh3654321"
        }
        
//        if MOLHLanguage.isRTLLanguage() {
//            self.txtUserName.textAlignment = .right
//            self.txtPassword.textAlignment = .right
//        }
//        else{
//            self.txtUserName.textAlignment = .left
//            self.txtPassword.textAlignment = .left
//        }
        self.txtUserName.semanticContentAttribute = .forceLeftToRight
        self.txtPassword.semanticContentAttribute = .forceLeftToRight
        self.txtUserName.textAlignment = .left
        self.txtPassword.textAlignment = .left
        
        self.lblCopyRights.text = "copy_rights".localized
        lblVersionBuild.text = Utility.getAppVersionAndBuild()
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        //changing button login background color
        btnLogin.backgroundColor = UIColor(hexString: appColors.defaultColor.rawValue)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(btnLogin.frame.height/2)
        btnLogin.cornerRadius = btnLogin.frame.height/2
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
//    @IBAction func btnLoginTapped() {
        if txtUserName.text?.count == 0 || txtPassword.text?.count == 0 {
            Utility.showAlert(title: "validation".localized, withMessage: "all_fields_required".localized, withNavigation: self)
            return
        }
        //Perform login here
        var dic = Dictionary<String,AnyObject>()
        dic["email"] = txtUserName.text as AnyObject
        dic["password"] = txtPassword.text as AnyObject
        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
        dic["appVersion"] = Utility.getAppVersion() as AnyObject
//        print(dic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiLogin, success: { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let data = response["User"] as? Dictionary<String,AnyObject> {
                        let typeID = data["typeId"] as? Int
                        if (UserDefaults.standard.integer(forKey: "currentUser") == typeID || typeID == UserType.admin.rawValue){ //If logged in user is according to UserSelection as done at very first page OR logged in user is an admin
                            if (typeID == UserType.admin.rawValue){ //Storing current usertype as admin, because in user selection page we are only storing member or consultant
                                UserDefaults.standard.set(UserType.admin.rawValue, forKey: "currentUser")
                            }
                            //To store a custom object into userdefaults you have to encode it
                            let userArchivedData = NSKeyedArchiver.archivedData(withRootObject: Member.init(fromDictionary: data))
                            UserDefaults.standard.set(userArchivedData, forKey: "LoggedInUser") //Saving full user into shared preferences
                            UserDefaults.standard.set(true , forKey: "isLoggedIn")
                            Constants.loggedInMember = Utility.getLoggedInMember()
                            AppDelegate.shared().navigateAfterLogin()
                        }
                        else{
                            if (typeID == UserType.member.rawValue ){//Member
                                Utility.showAlertWithTitle(title: "verification".localized, withMessage: "invalid_user_member".localized, withNavigation: self)
                            }else if (typeID == UserType.consultant.rawValue ){
                                Utility.showAlertWithTitle(title: "verification".localized, withMessage: "invalid_user_consultant".localized, withNavigation: self)
                            }
                        }
                        //hiding keyboard
                        self.txtUserName.resignFirstResponder()
                        self.txtPassword.resignFirstResponder()
                    }
                } else {
                    Utility.showAlertWithTitle(title: "verification".localized, withMessage: "verification_failed".localized, withNavigation: self)
                }
            }else {
                Utility.showAlertWithTitle(title: "verification".localized, withMessage: "general_error".localized, withNavigation: self)
            }
        }) { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            Utility.showAlertWithTitle(title: "verification".localized, withMessage: "verification_failed".localized, withNavigation: self)
        }
    }
    
    @IBAction func btnSmartPassTapped(_ sender: Any) {
        Utility.showAlertWithTitle(title: "information".localized, withMessage: "feature_not_available".localized, withNavigation: self)
    }
    
    
    @objc func btnCancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    //No more used
//    @IBAction func btnSignUpTapped(_ sender: Any) {
//        txtUserName.resignFirstResponder()
//        txtPassword.resignFirstResponder()
//        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .countriesVC) as! CountriesVC
//        let viewControllerNav = UINavigationController(rootViewController: viewController)
//        self.present(viewControllerNav, animated:true, completion:nil)
//    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldEndEditing")
        view.endEditing(true) //To stop keyboard to open
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: Any) {
        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .forgotPasswordVC) as! ForgotPasswordVC
        //Displaying modally
        let viewControllerNav = UINavigationController(rootViewController: viewController)
        self.present(viewControllerNav, animated:true, completion:nil)
    }
    
    //String is the latest entry in the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // if logging in user is member, txtUsername is having text Tazweeg_ (length = 8) && user is trying to press back key then dont allow it
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue && txtUserName.text?.count == 8 && string == "") {
            return false
        }
        return true
    }

}
