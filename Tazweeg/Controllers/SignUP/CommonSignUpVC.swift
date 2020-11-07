//
//  SignUpVC.swift
//  Tazweeg
//
//  Created by iMac on 3/28/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH
import ActionSheetPicker_3_0

class CommonSignUpVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    var selectedCountry : Country?
    @IBOutlet weak var svEmirates: UIStackView!
    @IBOutlet weak var collEmirates: UICollectionView!
    @IBOutlet weak var imgTermsAndCondition: UIImageView!
    @IBOutlet weak var btnTermsAndCondition: UIButton!
    @IBOutlet weak var btnSignup: WAButton!
    
    var selectedConsultant: Consultant?
    var states = [CountryState]()
    var selectedStateIDs = [String]() // This is selected cell Index array
    var isAcceptedTerms = false
//    var dropDowns: DropDownFileds? //For gender drop down
    var selectGenderID = -1
    var currentTextField : UITextField?
    var mobileNumber : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
//        self.txtMobile.keyboardType = .asciiCapableNumberPad   //disabling arabic keyboard
        //Test Data
//        self.txtName.text = "Zahoor Ahmad Gorsi Testing From iOS"
//        //self.txtMobile.text = "589108662"
//        self.txtMobile.text = "564143338"   //Saudi number of anwar bhai
//        self.txtEmail.text = "zahoor.gorsi@gmail.com"
        
        //Hiding keyboard whenever there is a click on the uiview
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        //defining and adding tap gesture on terms and condition check box
        let tapOnImgTermsAndCondition = UITapGestureRecognizer(target: self, action: #selector(imgTermsAndConditionTapped))
        tapOnImgTermsAndCondition.numberOfTapsRequired = 1
        tapOnImgTermsAndCondition.numberOfTouchesRequired = 1
        imgTermsAndCondition.isUserInteractionEnabled = true
        imgTermsAndCondition.addGestureRecognizer(tapOnImgTermsAndCondition)
        
        if MOLHLanguage.isRTLLanguage() {
            self.txtName.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtGender.textAlignment = .right
            //Setting up the back button
            let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "right arrow"), style: .plain, target: self, action: #selector(self.backTap(_:)))
            self.navigationItem.leftBarButtonItem = backBtn
        }
        else{
            self.txtName.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtGender.textAlignment = .left
            let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "left arrow"), style: .plain, target: self, action: #selector(self.backTap(_:)))
            self.navigationItem.leftBarButtonItem = backBtn
        }
        
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue && selectedConsultant != nil ){
            self.svEmirates.isHidden = true
        }
        self.navigationItem.title = "sign_up".localized
//        if let countryCode = selectedCountry?.code{
//            self.txtCountryCode.text = String(countryCode)
//        }
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        
        getDropDownsData()
        getListEmirates()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(btnSignup.frame.height/2)
        btnSignup.cornerRadius = btnSignup.frame.height/2
    }
    
//   Zahoor picker code end
    //***************************************
    //this Function loads all dropdown fields
    //***************************************
    func getDropDownsData(){
        Utility.shared.showSpinner()
        ALFWebService.shared.doGetData( method: Constants.apiGetType, success: { (response) in
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let pre_registration_info = response["Values"] as? [Dictionary<String,AnyObject>] {
                        Constants.dropDowns = DropDownFileds.init(fromDictionary: pre_registration_info)
                    }
                    self.setVals()
                } else {
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
                }
            }
        }) { (response) in
//            print(response)
            Utility.shared.hideSpinner()
        }
    }
    
    func setVals(){
        var text = ""
        if (Constants.dropDowns != nil ){
            if (Constants.dropDowns!.gender.count > 0){
                let val = Constants.dropDowns!.gender[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtGender.text = text
                self.txtGender.tag = (val["ValueId"] as? Int)!
            }
        }
    }
    
    @objc func backTap(_ btn: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
    
    //*******************************
    //Loading all emirates From server
    //*******************************
    func getListEmirates(){
        Utility.shared.showSpinner()
        let method = Constants.apiGetStates + "/\(selectedCountry?.countryId ?? 218)" //218 is for emirates
        ALFWebService.shared.doGetData( method: method, success: { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let states = response["States"] as? [Dictionary<String,AnyObject>] {
                        for em in states {
                                self.states.append(CountryState.init(fromDictionary: em))
                            }
                        if self.states.count != 0 {
                            //self.states.reverse()
                            self.collEmirates.reloadData() //reloading emirates collection
                            if MOLHLanguage.isRTLLanguage() {
                                self.collEmirates?.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: false)
                            }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSignupTapped(_ sender: Any) {
        if txtName.text?.count == 0 {
            Utility.showAlert(title: "validation".localized, withMessage: "name_is_missing".localized, withNavigation: self)
            return
        }else if txtName.text?.count ?? 0 < 4 {
            Utility.showAlert(title: "validation".localized, withMessage: "name_length_invalid".localized, withNavigation: self)
            return
        }
        // 20200611
        //trimming white spaces which appear in email address if picked from the suggestion bar of iPhone
        let strEmail = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (strEmail?.count ?? 0 > 0 && !(Utility.isValidEmail(emailToValidate: strEmail ?? ""))) {
            Utility.showAlert(title: "validation".localized, withMessage: "email_notValid".localized, withNavigation: self)
            return
        }
        //Consultant/Member Must select an emirate
        //print (selectedStateIDs)
        if (selectedStateIDs.count == 0 ) {
            Utility.showAlertWithTitle(title: "validation".localized, withMessage: "emirate_notValid".localized, withNavigation: self)
            return
        }
//      Member must select a consultant
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue && selectedConsultant!.id == nil ) {
            Utility.showAlertWithTitle(title: "validation".localized, withMessage: "consultant_notValid".localized, withNavigation: self)
            return
        }
        if isAcceptedTerms == false {
            Utility.showAlertWithOk(title: "validation".localized, withMessage: "terms_required".localized, withNavigation: self) {
            }
            return
        }
        //Web API call start
        var dic = Dictionary<String,AnyObject>()
        dic["fullName"] = txtName.text as AnyObject
        dic["email"] = strEmail as AnyObject
        dic["mobile"] = self.mobileNumber as AnyObject  //coming from previous viewcontroller
        dic["typeId"] = (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ? 3 : 4) as AnyObject // Consultant = 3, Member = 4
        dic["stateId"] = (selectedStateIDs.joined(separator:",")) as AnyObject
        dic["consultantId"] = (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ? 0 : selectedConsultant?.id) as AnyObject // ConsultantID = 0 if consultant is signing up
        dic["genderId"] = self.txtGender.tag as AnyObject // male = 7 and female = 8
        dic["setLang"] = MOLHLanguage.isRTLLanguage() == true ? 1 as AnyObject : 0 as AnyObject
        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
        dic["appVersion"] = Utility.getAppVersion() as AnyObject
//        print(dic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method:  Constants.apiSignup, success: { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if (response["Consultant"] as? Dictionary<String,AnyObject>) != nil {
                        var signupSuccessMSG = ""
                        if (self.selectedCountry?.countryId == countryType.KSA.rawValue){
                            if ( UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue ){
                                //adding consultant phone number for ONLY KSA member
                                signupSuccessMSG = "ksa_success_signup_msg".localized + (self.selectedConsultant?.phoneNumber ?? 0 ).stringValue
                            }else{
                                signupSuccessMSG = "ksa_success_signup_msg".localized
                            }
                        }else{
                            if ( UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue ){
                                 //adding consultant phone number for member
                                signupSuccessMSG = "member_success_signup_msg".localized
                            }else{
                                signupSuccessMSG = "consultant_success_signup_msg".localized
                            }
                            
                        }
                        Utility.showAlertWithOk(title: "verification".localized, withMessage: signupSuccessMSG, withNavigation: self, withOkBlock: {
                            AppDelegate.shared().loadUserSelectionVC()
                        })
                    }else {
                        Utility.showAlertWithTitle(title: "verification".localized, withMessage: "general_error".localized, withNavigation: self)
                    }
                }else if status == 2 {
                    Utility.showAlertWithOk(title: "information".localized, withMessage: "duplicateUser".localized, withNavigation: self, withOkBlock: {
                        self.dismiss(animated: true, completion: nil)
                    })
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

    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated:true, completion:nil)
    }
    
    //**************************************
    // MARK: - emirates collection Delegates
    //**************************************

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.states.count == 0 {
            self.collEmirates.setEmptyMessage("noData".localized)
        } else {
            self.collEmirates.restore()
        }
        return states.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emirateCell", for: indexPath) as! EmiratesCollCell
        if selectedStateIDs.contains(String(self.states[indexPath.row].stateId)) { // You need to check wether selected index array contain current index if yes then change the color
            cell.backView.layer.borderWidth = 1
            cell.backView.layer.borderColor = UIColor(hexString: appColors.defaultColor.rawValue).cgColor
            cell.backView.backgroundColor = UIColor.white
        }else{
            cell.backView.layer.borderWidth = 1
            cell.backView.layer.borderColor = UIColor.white.cgColor
            cell.backView.backgroundColor = UIColor.clear
        }
        cell.imgView.circulate(radius: cell.imgView.frame.size.height/2)//half then the height
        let imgUrl = URL(string: states[indexPath.item].imgPath ?? Constants.defaultImage)
        print(imgUrl as Any)
        if imgUrl != nil {
            cell.imgView.setImageWith(imgUrl!)
        }
        //Loading arabic/English
        if MOLHLanguage.isRTLLanguage() {
            cell.lblName.text = states[indexPath.item].stateAR
        }else{
            cell.lblName.text = states[indexPath.item].stateEN
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emirateID = self.states[indexPath.item].stateId
        if selectedStateIDs.contains(String(emirateID!)) {
            selectedStateIDs = selectedStateIDs.filter { $0 != String(emirateID!)}
        }
        else {
            selectedStateIDs.append(String(emirateID!))
        }
        self.collEmirates.reloadData()
    }
    
    @objc func imgTermsAndConditionTapped() {
        
        if isAcceptedTerms {
            isAcceptedTerms = false
            imgTermsAndCondition.image = #imageLiteral(resourceName: "uncheck")
        } else {
            imgTermsAndCondition.image = #imageLiteral(resourceName: "check")
            isAcceptedTerms = true
        }
    }
    
    @IBAction func btnTermsAndConditionTapped(_ sender: Any) {
        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
        viewController.pageType = .term
        viewController.isTerm = true;
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
        if (textField == self.txtGender){
            view.endEditing(true)
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.gender.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.gender {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.gender[index]
                        self.txtGender?.text = arr[index]
                        self.txtGender?.tag = (val["ValueId"] as? Int)!
                        self.txtGender?.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else{
            return true;
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
