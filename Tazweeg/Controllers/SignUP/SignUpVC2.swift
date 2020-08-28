//
//  SignUpVC2.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 07/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import MOLH



class SignUpVC2: UIViewController, UITextFieldDelegate,CAAnimationDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var svBrideArrangement: UIStackView!
    @IBOutlet weak var txtBrideArrangement: WATextField!
    @IBOutlet weak var txtIsSmoking: WATextField!
    @IBOutlet weak var txtSkinColor: WATextField!
    @IBOutlet weak var txtHairColor: WATextField!
    @IBOutlet weak var txtHairType: WATextField!
    @IBOutlet weak var txtEyeColor: WATextField!
    @IBOutlet weak var txtSectType: WATextField!
    @IBOutlet weak var txtHeight: WATextField!
    @IBOutlet weak var txtBodyType: WATextField!
    @IBOutlet weak var txtBodyWeight: WATextField!
    
    @IBOutlet weak var svVeil: UIStackView!
    @IBOutlet weak var txtVeil: WATextField!
    
    @IBOutlet weak var svPolygamy: UIStackView!
    @IBOutlet weak var imgPolygamy: UIImageView!
    
    @IBOutlet weak var txtHasLicense: WATextField!
    
    @IBOutlet weak var imgStep1: UIImageView!
    @IBOutlet weak var imgStep2: UIImageView!
    
//    MARK:- Custom Vars
    var countryID = 0
    var emirateID = 0
    var currentMember : Member?
    var isPolygamy : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "step2".localized
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        
        //Setting image and label color to our theme color
        self.imgStep1.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        self.imgStep2.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        //defining and adding tap gesture on terms and condition check box
        let tapOnImgIsPolygammy = UITapGestureRecognizer(target: self, action: #selector(imgIsPolygammyTapped))
        tapOnImgIsPolygammy.numberOfTapsRequired = 1
        tapOnImgIsPolygammy.numberOfTouchesRequired = 1
        imgPolygamy.isUserInteractionEnabled = true
        imgPolygamy.addGestureRecognizer(tapOnImgIsPolygammy)
        
        let alltextFields =  self.view.allSubViewsOf(type: UITextField.self)
        for txt in alltextFields {
            txt.setLeftPaddingPoints(7)
            txt.setRightPaddingPoints(7)
        }
        if MOLHLanguage.isRTLLanguage() {
            self.txtSectType.textAlignment = .right
            self.txtIsSmoking.textAlignment = .right
            self.txtSkinColor.textAlignment = .right
            self.txtHairColor.textAlignment = .right
            self.txtHairType.textAlignment = .right
            self.txtEyeColor.textAlignment = .right
            self.txtHeight.textAlignment = .right
            self.txtBodyType.textAlignment = .right
            self.txtBodyWeight.textAlignment = .right
            self.txtBrideArrangement.textAlignment = .right
            self.txtVeil.textAlignment = .right
            self.txtHasLicense.textAlignment = .right
        }
        else{
            self.txtSectType.textAlignment = .left
            self.txtIsSmoking.textAlignment = .left
            self.txtSkinColor.textAlignment = .left
            self.txtHairColor.textAlignment = .left
            self.txtHairType.textAlignment = .left
            self.txtEyeColor.textAlignment = .left
            self.txtHeight.textAlignment = .left
            self.txtBodyType.textAlignment = .left
            self.txtBodyWeight.textAlignment = .left
            self.txtBrideArrangement.textAlignment = .left
            self.txtVeil.textAlignment = .left
            self.txtHasLicense.textAlignment = .left
        }
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        
        loadDropDowns()
        //Loading current member details from localStorage where it was stored after login as well as after step 1
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue && Constants.loggedInMember != nil){//Member
            self.currentMember = Constants.loggedInMember
        }
        setMemberValues()   //call this method before checking if current person is male/female
        // For Female its visible on step 2
        // For male its hidden on step 2
        // If logged in user is a member and he is male OR if logged in user is a consultant and consultant is editing a male
        if ( (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue && Constants.loggedInMember?.genderId == genderType.male.rawValue) ||
            ((UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue || UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue )  &&
                self.currentMember?.genderId == genderType.male.rawValue)){
            self.svBrideArrangement.isHidden = true
            self.svVeil.isHidden = true
            self.svPolygamy.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //****************************************************************
    //In case of both Editing/Adding this object is passed from step 1
    //****************************************************************
    func setMemberValues() {
        selectBrideArrangementById(Id: self.currentMember?.sBrideArrangmentId)
        isPolygamy = self.currentMember?.isPolygamy ?? false
        //no need to apply this check as now member and consultant both can edit
//        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue){//consultant coming for edit
            isPolygamy = !isPolygamy //Incase of edit reversing it because in the function we will reverse it again
            imgIsPolygammyTapped()
//        }
        selectIsSmokingId(Id: self.currentMember?.isSmokeId)
        selectSkinColorId(Id: self.currentMember?.skinColorId)
        selectHairColorId(Id: self.currentMember?.hairColorId)
        selectHairTypeId(Id: self.currentMember?.hairTypeId)
        selectEyeColorId(Id: self.currentMember?.eyeColorId)
        selectHeightId(Id: self.currentMember?.heightId)
        selectBodyTypeId(Id: self.currentMember?.bodyTypeId)
        selectBodyWeightId(Id: self.currentMember?.bodyWeightId)
        selectSectTypeId(Id: self.currentMember?.sectId)
        selectVeilId(Id: self.currentMember?.sVeilId)
        selectLicenseId(Id: self.currentMember?.licenseId)
    }
    
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectBrideArrangementById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.brideArrangement , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.brideArrangement[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtBrideArrangement.text = text
            self.txtBrideArrangement.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectIsSmokingId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.isSmoking , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.isSmoking[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtIsSmoking.text = text
            self.txtIsSmoking.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectSkinColorId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.skinColor , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.skinColor[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtSkinColor.text = text
            self.txtSkinColor.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectHairColorId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.hairColor , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.hairColor[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtHairColor.text = text
            self.txtHairColor.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectHairTypeId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.hairType , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.hairType[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtHairType.text = text
            self.txtHairType.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectEyeColorId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.eyeColor , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.eyeColor[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtEyeColor.text = text
            self.txtEyeColor.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectHeightId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.height , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.height[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtHeight.text = text
            self.txtHeight.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectBodyTypeId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.bodyType , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.bodyType[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtBodyType.text = text
            self.txtBodyType.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectBodyWeightId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.bodyWeight , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.bodyWeight[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtBodyWeight.text = text
            self.txtBodyWeight.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectSectTypeId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.sectType , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.sectType[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtSectType.text = text
            self.txtSectType.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectVeilId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.veil , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.veil[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtVeil.text = text
            self.txtVeil.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectLicenseId( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.hasLicense , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.hasLicense[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtHasLicense.text = text
            self.txtHasLicense.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //MARK:- textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK:- custom Methods
    @objc func backBtnTap(_ btn: UIBarButtonItem){
        self.navigationController?.pop(transitionType: kCATransitionFade, transitionDirectionType: kCATransitionFromRight, duration: 0.4)
    }
    
    //************************************************
    //It sets the first drop down value into textField
    //************************************************
    func loadDropDowns(){
        var text = ""
        if (Constants.dropDowns != nil ){
            if (Constants.dropDowns!.isSmoking.count > 0){
                let val = Constants.dropDowns!.isSmoking[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtIsSmoking.text = text
                self.txtIsSmoking.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.skinColor.count > 0){
                let val = Constants.dropDowns!.skinColor[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtSkinColor.text = text
                self.txtSkinColor.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.hairColor.count > 0){
                let val = Constants.dropDowns!.hairColor[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtHairColor.text = text
                self.txtHairColor.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.hairType.count > 0){
                let val = Constants.dropDowns!.hairType[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtHairType.text = text
                self.txtHairType.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.eyeColor.count > 0){
                let val = Constants.dropDowns!.eyeColor[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtEyeColor.text = text
                self.txtEyeColor.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.sectType.count > 0){
                let val = Constants.dropDowns!.sectType[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtSectType.text = text
                self.txtSectType.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.height.count > 0){
                let val = Constants.dropDowns!.height[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtHeight.text = text
                self.txtHeight.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.bodyType.count > 0){
                let val = Constants.dropDowns!.bodyType[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtBodyType.text = text
                self.txtBodyType.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.bodyWeight.count > 0){
                let val = Constants.dropDowns!.bodyWeight[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtBodyWeight.text = text
                self.txtBodyWeight.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.brideArrangement.count > 0){
                let val = Constants.dropDowns!.brideArrangement[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtBrideArrangement.text = text
                self.txtBrideArrangement.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.veil.count > 0){
                let val = Constants.dropDowns!.veil[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtVeil.text = text
                self.txtVeil.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.hasLicense.count > 0){
                let val = Constants.dropDowns!.hasLicense[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtHasLicense.text = text
                self.txtHasLicense.tag = (val["ValueId"] as? Int)!
            }
        }

    }
    

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
        view.endEditing(true)
        if (textField == self.txtIsSmoking){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.isSmoking.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.isSmoking {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.isSmoking[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtSkinColor){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.skinColor.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.skinColor {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.skinColor[index]
                        self.txtSkinColor?.text = arr[index]
                        self.txtSkinColor?.tag = (val["ValueId"] as? Int)!
                        self.txtSkinColor?.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtHairColor){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.hairColor.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.hairColor {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.hairColor[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtHairType){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.hairType.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.hairType {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.hairType[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtEyeColor){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.eyeColor.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.eyeColor {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.eyeColor[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtSectType){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.sectType.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.sectType {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.sectType[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtHeight){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.height.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.height {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.height[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtBodyType){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.bodyType.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.bodyType {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.bodyType[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }else if (textField == self.txtBodyWeight){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.bodyWeight.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.bodyWeight {
                        var text = ""
//                        print(dict["ValueId"] as? Int ?? -1)
                        if MOLHLanguage.isRTLLanguage() {
                            text = dict["ValueAR"] as? String ?? ""
                        }else{
                            text = dict["ValueEN"] as? String ?? ""
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.bodyWeight[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
            
        else if (textField == self.txtBrideArrangement){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.brideArrangement.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.brideArrangement {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.brideArrangement[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
            
        else if (textField == self.txtVeil){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.veil.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.veil {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.veil[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
            
        else if (textField == self.txtHasLicense){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.hasLicense.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.hasLicense {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.hasLicense[index]
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
            return true;    // UnHide both keyboard and blinking cursor.
        }
    }

    @IBAction func nextTap(_ sender: Any) {
        let alltextFields =  self.view.allSubViewsOf(type: UITextField.self)
        var emptyTxtCount = 0
        var dic = Dictionary<String,AnyObject>()
        
        for txt in alltextFields {
            if txt.text?.count == 0 && txt.superview?.isHidden == false{
                emptyTxtCount = emptyTxtCount + 1
            }
        }
        if emptyTxtCount != 0 {
            emptyTxtCount = 0
            Utility.showAlert(title: "validation".localized, withMessage: "all_fields_required".localized, withNavigation: self)
            return
        }
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
            dic["userId"] = Constants.loggedInMember?.userId as AnyObject //It should be current user id
        }else{
            dic["userId"] = self.currentMember?.userId as AnyObject //It should be current user id
        }
        dic["isSmokingId"] = txtIsSmoking.tag as AnyObject
        dic["skinColorId"] = txtSkinColor.tag as AnyObject
        dic["hairColorId"] = txtHairColor.tag as AnyObject
        dic["eyeColorId"] = txtEyeColor.tag as AnyObject
        dic["hairTypeId"] = txtHairType.tag as AnyObject
        dic["heightId"] = txtHeight.tag as AnyObject
        dic["bodyTypeId"] = txtBodyType.tag as AnyObject
        dic["memberWeightId"] = txtBodyWeight.tag as AnyObject
        dic["sectTypeId"] = txtSectType.tag as AnyObject
        // For Female its visible on step 2
        // For male its hidden on step 2
        // If logged in user is a member and she is female OR if logged in user is a consultant and consultant is editing a female
        if (Constants.loggedInMember?.genderId == genderType.female.rawValue && UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue) ||
            (self.currentMember?.genderId == genderType.female.rawValue && ( UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
                UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue)){
            dic["sBrideArrangmentId"] = txtBrideArrangement.tag as AnyObject
            dic["sCondemnBrideId"] = txtVeil.tag as AnyObject
        }
        dic["isPolygamy"] = (isPolygamy == true ?  "true" : "false" ) as AnyObject
        dic["memberLicenseId"] = txtHasLicense.tag as AnyObject
        dic["userUpdateId"]  = Constants.loggedInMember?.userId as AnyObject
        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
        dic["appVersion"] = Utility.getAppVersion() as AnyObject
//        print(self.paramDic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiStep2, success: { (response) in
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
                    let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC3) as! SignUpVC3
                    viewController.currentMember = self.currentMember
                    self.navigationController?.pushViewController(viewController, animated: true)
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
    
    //***************************************************************************
    //When user will tap on T&C check box, and when consultant is coming for edit
    //***************************************************************************
    @objc func imgIsPolygammyTapped() {
        isPolygamy = !isPolygamy
        if isPolygamy { //if true then make ticked check box
            imgPolygamy.image = #imageLiteral(resourceName: "check")
            svBrideArrangement.isHidden = true
        } else {
            imgPolygamy.image = #imageLiteral(resourceName: "uncheck")
            svBrideArrangement.isHidden = false
        }
    }
}
