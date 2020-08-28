//
//  SignUpVC5.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 07/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import ActionSheetPicker_3_0
import MOLH
class SignUpVC5: UIViewController, UITextFieldDelegate,UITextViewDelegate, YPSignatureDelegate, SignatureViewDelegate{
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFirstRelativeName: WATextField!
    @IBOutlet weak var txtFirstRelativePhone: WATextField!
    @IBOutlet weak var txtFirstRelativeRelation: WATextField!
    @IBOutlet weak var txtSecondRelativeName: WATextField!
    @IBOutlet weak var txtSecondRelativePhone: WATextField!
    @IBOutlet weak var txtSecondRelativeRelation: WATextField!
    @IBOutlet weak var txtApplicantDescription: WATextView!
    @IBOutlet var langSelectedIcons: [UIImageView]!
    @IBOutlet weak var imgTermsAndCondition: UIImageView!
    
    @IBOutlet weak var imgArabic: UIImageView!
    @IBOutlet weak var lblArabic: UILabel!
    @IBOutlet weak var imgEnglish: UIImageView!
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var imgOthers: UIImageView!
    @IBOutlet weak var lblOthers: UILabel!
    
    @IBOutlet weak var signImg: UIImageView!
    @IBOutlet weak var putSignView: UIView!
    @IBOutlet weak var putSignLbl: UILabel!
    
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var imgStep1: UIImageView!
    @IBOutlet weak var imgStep2: UIImageView!
    @IBOutlet weak var imgStep3: UIImageView!
    @IBOutlet weak var imgStep4: UIImageView!
    @IBOutlet weak var imgStep5: UIImageView!
    
    //MARK:- Custom Vars
    var blurEffectView : UIView!
    var signView: SignatureView!

//    var dropDowns: DropDownFileds?
    var isAcceptedTerms = false
    var isLanguage1 = true  //by default arabic is selected
    var isLanguage2 = false
    var isLanguage3 = false
    var eng = ""
    var arb = "arabic"
    var oth = ""
//    var signatureImg: UIImage?
    var currentMember : Member?
    var memberID : Int? //if user is coming for edit

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //defining and adding tap gesture on firstLanguage check box
        let tapOnLanguage1 = UITapGestureRecognizer(target: self, action: #selector(imgArabicLanguageTapped))
        tapOnLanguage1.numberOfTapsRequired = 1
        tapOnLanguage1.numberOfTouchesRequired = 1
        imgArabic.isUserInteractionEnabled = true
        imgArabic.addGestureRecognizer(tapOnLanguage1)
        //defining and adding tap gesture on secondLanguage check box
        let tapOnLanguage2 = UITapGestureRecognizer(target: self, action: #selector(imgEnglishLanguageTapped))
        tapOnLanguage2.numberOfTapsRequired = 1
        tapOnLanguage2.numberOfTouchesRequired = 1
        imgEnglish.isUserInteractionEnabled = true
        imgEnglish.addGestureRecognizer(tapOnLanguage2)
        //defining and adding tap gesture on thirddLanguage check box
        let tapOnLanguage3 = UITapGestureRecognizer(target: self, action: #selector(imgOthersLanguageTapped))
        tapOnLanguage3.numberOfTapsRequired = 1
        tapOnLanguage3.numberOfTouchesRequired = 1
        imgOthers.isUserInteractionEnabled = true
        imgOthers.addGestureRecognizer(tapOnLanguage3)
        //defining and adding tap gesture on terms and condition check box
        let tapOnImgTermsAndCondition = UITapGestureRecognizer(target: self, action: #selector(imgTermsAndConditionTapped))
        tapOnImgTermsAndCondition.numberOfTapsRequired = 1
        tapOnImgTermsAndCondition.numberOfTouchesRequired = 1
        imgTermsAndCondition.isUserInteractionEnabled = true
        imgTermsAndCondition.addGestureRecognizer(tapOnImgTermsAndCondition)

//        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "step5".localized
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        //Setting image and label color to our theme color
        self.imgStep1.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        self.imgStep2.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        self.imgStep3.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        self.imgStep4.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        self.imgStep5.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        
        putSignView.layer.cornerRadius = 2
        putSignView.layer.borderColor = UIColor.black.cgColor
        putSignView.layer.borderWidth = 1
        
        let alltextFields =  self.view.allSubViewsOf(type: UITextField.self)
        for txt in alltextFields {
            txt.setLeftPaddingPoints(7)
            txt.setRightPaddingPoints(7)
        }
        
        if MOLHLanguage.isRTLLanguage() {
            self.txtFirstRelativeName.textAlignment = .right
            self.txtFirstRelativePhone.textAlignment = .right
            self.txtFirstRelativeRelation.textAlignment = .right
            self.txtSecondRelativeName.textAlignment = .right
            self.txtSecondRelativePhone.textAlignment = .right
            self.txtSecondRelativeRelation.textAlignment = .right
            self.txtApplicantDescription.textAlignment = .right
        }
        else{
            self.txtFirstRelativeName.textAlignment = .left
            self.txtFirstRelativePhone.textAlignment = .left
            self.txtFirstRelativeRelation.textAlignment = .left
            self.txtSecondRelativeName.textAlignment = .left
            self.txtSecondRelativePhone.textAlignment = .left
            self.txtSecondRelativeRelation.textAlignment = .left
            self.txtApplicantDescription.textAlignment = .left
        }
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        
        loadDropDowns()
        //Loading current member details from localStorage where it was stored after login as well as after step 1
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue && Constants.loggedInMember != nil){//Member
            self.currentMember = Constants.loggedInMember
        }
        setVals()
//        //Test Data
//        txtFirstRelativeName.text = "Zahoor"
//        txtFirstRelativePhone.text = "971589108662"
//        txtSecondRelativeName.text = "Ahmad"
//        txtSecondRelativePhone.text = "971589108663"
//        txtApplicantDescription.text = "Hi i am zahoor ahmad gorsi. I was born genius but software engineering ruined me. This is my short description, for further information please call me at +971589108662"
    }

    //******************
    //In case of Editing
    //******************
    func setVals() {
        
        
        self.txtFirstRelativeName.text = self.currentMember?.firstRelative
        self.txtFirstRelativePhone.text = self.currentMember?.firstRelativeNumber
        selectRelationshipById(textField:self.txtFirstRelativeRelation , Id: self.currentMember?.firstRelativeRelationId)
        self.txtSecondRelativeName.text = self.currentMember?.secondRelative
        self.txtSecondRelativePhone.text = self.currentMember?.secondRelativeNumber
        selectRelationshipById(textField:self.txtFirstRelativeRelation, Id: self.currentMember?.secondRelativeRelationId)
        self.txtApplicantDescription.text = self.currentMember?.applicantDescription
        // because by default language arabic is checked
        imgArabicLanguageTapped() //Unchecking for edit
        if let languages = self.currentMember?.languageIds{
            let languagesArray = languages.split(separator: ",")
            for language in languagesArray{
                var val = Constants.dropDowns!.languages[0]  //English
                var langID = val["ValueId"] as? Int ?? 0
                if Int(language) == langID {
                    imgEnglishLanguageTapped()
                    continue
                }
                val = Constants.dropDowns!.languages[1]      //Arabic
                langID = val["ValueId"] as? Int ?? 0
                if Int(language) == langID {
                    imgArabicLanguageTapped()
                    continue
                }
                val = Constants.dropDowns!.languages[2]      //Others
                langID = val["ValueId"] as? Int ?? 0
                if Int(language) == langID {
                    imgOthersLanguageTapped()
                    continue
                }
            }
        }
        if let signature = self.currentMember?.signature{
            guard let signatureData : Data = Data(base64Encoded: signature, options: .ignoreUnknownCharacters) else { return }
            guard let signatureImage:UIImage = UIImage(data: signatureData) else { return }
//            print(signatureImage)
            self.signImg.image = signatureImage
            //hiding label showing "Put your sign here"
            self.putSignLbl.isHidden = true
            
        }
    }
    
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectRelationshipById(textField:UITextField , Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.relationship , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.relationship[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            textField.text = text
            textField.tag = val["ValueId"] as? Int ?? 0
        }
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
    
    //MARK:- textView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return true
        }
        return true
    }
    
    //MARK:- custom Methods
    @objc func backBtnTap(_ btn: UIBarButtonItem){
        self.navigationController?.pop(transitionType: kCATransitionFade, transitionDirectionType: kCATransitionFromLeft, duration: 0.4)
    }
    
    //************************************************
    //It sets the first drop down value into textField
    //************************************************
    func loadDropDowns(){
        var text = ""
        if (Constants.dropDowns != nil ){
            if (Constants.dropDowns!.relationship.count > 0){
                let val = Constants.dropDowns!.relationship[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtFirstRelativeRelation.text = text
                self.txtFirstRelativeRelation.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.relationship.count > 1){
                let val = Constants.dropDowns!.relationship[1]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtSecondRelativeRelation.text = text
                self.txtSecondRelativeRelation.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.languages.count > 0){
                let val = Constants.dropDowns!.languages[0]  //English
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.imgEnglish.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.languages.count > 1){
                let val = Constants.dropDowns!.languages[1]  //Arabic
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.imgArabic.tag = (val["ValueId"] as? Int)!
                
            }
            if (Constants.dropDowns!.languages.count > 2){
                let val = Constants.dropDowns!.languages[2]  //Others
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.imgOthers.tag = (val["ValueId"] as? Int)!
            }
        }
        
    }
    
    
    //MARK:- YPSignatureDelegate
    func didStart(_ view: YPDrawSignatureView) {
//        print("Started Drawing")
        scroll.isScrollEnabled = false
    }
    
    func didFinish(_ view: YPDrawSignatureView) {
//        print("Finished Drawing")
        scroll.isScrollEnabled = true
    }
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        
        putSignLbl.isHidden = false
        signView.removeFromSuperview()
        blurEffectView.removeFromSuperview()
        
    }
    
    //Tap on signature control
    func didTapSubmit() {
//        scale
//        The scale factor to apply to the bitmap. If you specify a value of 0.0, the scale factor is set to the scale factor of the device’s main screen.
        if let signatureImage = self.signView.signView.getSignature(scale: 10.0) {
            self.signImg.image = signatureImage
            putSignLbl.isHidden = true
        }else{
            self.signImg.image = nil //clearing the image if any
        }
        signView.removeFromSuperview()
        blurEffectView.removeFromSuperview()
    }
    
    //Clearing signature
    func didTapClear() {
        self.signView.signView.clear()
    }
    
    func didTapCancel() {
        if self.signImg.image != nil {
            putSignLbl.isHidden = true
        } else {
            putSignLbl.isHidden = false
        }
        
        signView.removeFromSuperview()
        blurEffectView.removeFromSuperview()
    }
    
    //MARK:- IBActions
    //Loading signature control
    @IBAction func putSignBtnTap(_ sender: Any) {
        let height = self.view.bounds.size.height
        let width = self.view.bounds.size.width
        let signatureHeight = height / 3
        let signatureWidth = width / 1.25

        self.signView = SignatureView.init(frame: CGRect(x: (width/2 - signatureWidth/2), y: (height/2 - signatureHeight/2) , width: signatureWidth, height: signatureHeight))
        self.signView.delegate = self
        self.signView.signView.layer.borderColor = UIColor(hexString: appColors.defaultColor.rawValue).cgColor
        self.signView.signView.layer.borderWidth = 1
        
        self.blurEffectView = UIView(frame: self.view.frame)
        self.blurEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGesture)
        
        self.signView.blurrView = self.blurEffectView
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.parent?.view.addSubview(self.blurEffectView)
        } else {
            
        }
        self.parent?.view.addSubview(self.signView)
    }


    
    //******************************************
    //When user will tap on language check box 1
    //******************************************
    @objc func imgArabicLanguageTapped() {
        if isLanguage1 {
            isLanguage1 = false
            imgArabic.image = #imageLiteral(resourceName: "uncheck")
        } else {
            imgArabic.image = #imageLiteral(resourceName: "check")
            isLanguage1 = true
        }
    }
    //******************************************
    //When user will tap on language check box 2
    //******************************************
    @objc func imgEnglishLanguageTapped() {
        if isLanguage2 {
            isLanguage2 = false
            imgEnglish.image = #imageLiteral(resourceName: "uncheck")
        } else {
            imgEnglish.image = #imageLiteral(resourceName: "check")
            isLanguage2 = true
        }
    }
    //******************************************
    //When user will tap on language check box 3
    //******************************************
    @objc func imgOthersLanguageTapped() {
        if isLanguage3 {
            isLanguage3 = false
            imgOthers.image = #imageLiteral(resourceName: "uncheck")
        } else {
            imgOthers.image = #imageLiteral(resourceName: "check")
            isLanguage3 = true
        }
    }
    //***********************************
    //When user will tap on T&C check box
    //***********************************
    @objc func imgTermsAndConditionTapped() {
        if isAcceptedTerms {
            isAcceptedTerms = false
            imgTermsAndCondition.image = #imageLiteral(resourceName: "uncheck")
        } else {
            imgTermsAndCondition.image = #imageLiteral(resourceName: "check")
            isAcceptedTerms = true
        }
    }
    
    @IBAction func nextTap(_ sender: Any) {
        var dic = Dictionary<String,AnyObject>()
        
        if ((isLanguage1 == false && isLanguage2 == false && isLanguage3 == false) )
        {
            Utility.showAlertWithOk(title: "validation".localized, withMessage: "language_required".localized, withNavigation: self) {
            }
            return
        }
        if signImg.image == nil {
            Utility.showAlertWithOk(title: "validation".localized, withMessage: "sign_required".localized, withNavigation: self) {
            }
            return
        }
        if isAcceptedTerms == false {
            Utility.showAlertWithOk(title: "validation".localized, withMessage: "terms_required".localized, withNavigation: self) {
            }
            return
        }
        
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
            dic["userId"] = Constants.loggedInMember?.userId as AnyObject //It should be current user id
        }else{
            dic["userId"] = self.currentMember?.userId as AnyObject //It should be current user id
        }
        
        dic["firstRelative"] = txtFirstRelativeName.text as AnyObject
        dic["firstRelativeNumber"] = txtFirstRelativePhone.text as AnyObject
        dic["firstRelativeRelationId"] = txtFirstRelativeRelation.tag as AnyObject
        dic["secondRelative"] = txtSecondRelativeName.text as AnyObject
        dic["secondRelativeNumber"] = txtSecondRelativePhone.text as AnyObject
        dic["secondRelativeRelationId"] = txtSecondRelativeRelation.tag as AnyObject
        dic["applicantDescription"] = txtApplicantDescription.text as AnyObject
        //Language
        var arrselectedLanguage = [String]()
        if(isLanguage1){ //If language 1 is ticked
            arrselectedLanguage.append( String(imgArabic!.tag) )
        }
        if(isLanguage2){ //If language 2 is ticked
            arrselectedLanguage.append( String(imgEnglish!.tag) )
        }
        if(isLanguage3){ //If language 3 is ticked
            arrselectedLanguage.append( String(imgOthers!.tag) )
        }
        dic["languagesId"] = (arrselectedLanguage.joined(separator:",")) as AnyObject
        //Signature
        let signImgeData = UIImagePNGRepresentation(signImg.image!)
        let strBase64 = signImgeData?.base64EncodedString(options: .lineLength64Characters)
        dic["signature"] = strBase64 as AnyObject
        dic["userUpdateId"]  = Constants.loggedInMember?.userId as AnyObject
        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
        dic["appVersion"] = Utility.getAppVersion() as AnyObject
//        print(self.paramDic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiStep5, success: { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let data = response["Data"] as? Dictionary<String,AnyObject> {
                        self.currentMember = Member.init(fromDictionary: data)
                        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){//Member
                            //To store a custom object into userdefaults you have to encode it
                            let userArchivedData = NSKeyedArchiver.archivedData(withRootObject: self.currentMember as Any)
                            UserDefaults.standard.set(userArchivedData, forKey: "LoggedInUser") //Saving full user into shared preferences
                            Constants.loggedInMember = Utility.getLoggedInMember() //populating global variable with update values if any (in case of edit)
                            self.currentMember = Constants.loggedInMember //Current member is also logged in member, on next step self.memberDetail will be used to edit
                        }
                    }
                    //If profile status is neither paid nor finished, meaning user yet to pay the fee
                    if (self.currentMember?.profileStatusId != profileStatusType.paid.rawValue &&
                        self.currentMember?.profileStatusId != profileStatusType.finished.rawValue){
                        Utility.showAlertWithCustomButtontitles(btnOktitle: "pay_now".localized, btnCanceltitle: "pay_later".localized, title: "payment".localized, withMessage: "payment_message".localized, withNavigation: self, withOkBlock: {
                            // Create the action sheet
                            let myActionSheet = UIAlertController(title: "payment_selection".localized, message: "payment_selection_msg".localized, preferredStyle: UIAlertControllerStyle.actionSheet)
                            
                            // Credit Card or debit card
                            let cardAction = UIAlertAction(title: "credit_debit_card".localized, style: UIAlertActionStyle.default) { (action) in
//                                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC6) as! SignUpVC6
//                                viewController.currentMember = self.currentMember
//                                viewController.thisPaymentType = paymentType.choosing //paying first 2500 for choosing
//                                self.navigationController?.pushViewController(viewController, animated: true)
                                let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
                                dvc.pageType = .payment
                                dvc.currentMember = self.currentMember
                                self.navigationController?.pushViewController(dvc, animated: true)
                            }
                            
                            // cancel action button
                            let cancelAction = UIAlertAction(title: "cancel".localized, style: UIAlertActionStyle.cancel) { (action) in
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            
                            // add action buttons to action sheet
                            myActionSheet.addAction(cardAction)
                            myActionSheet.addAction(cancelAction)
                            
                            // present the action sheet
                            self.present(myActionSheet, animated: true, completion: nil)
                        }, withCancelBlock: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }else{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else if status == 3 {
                    Utility.logout()
                } else {
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
                }
            }else {
                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
            }
        }) { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
        }
    }
    @IBAction func backTap(_ sender: Any) {
        self.navigationController?.pop(transitionType: kCATransitionFade, transitionDirectionType: kCATransitionFromRight, duration: 0.4)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
        view.endEditing(true)
        if (textField == self.txtFirstRelativeRelation || textField == self.txtSecondRelativeRelation ){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.relationship.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.relationship {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.relationship[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
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
    
    @IBAction func btnTermsAndConditionTapped(_ sender: Any) {
        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
        viewController.pageType = .term
        viewController.isTerm = true;
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
}
