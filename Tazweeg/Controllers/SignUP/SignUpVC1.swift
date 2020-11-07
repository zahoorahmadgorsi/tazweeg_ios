//  SignUpVC.swift
//  Coffee & Go
//
//  Created by Naveed ur Rehman on 04/09/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.

import UIKit
import ActionSheetPicker_3_0
import MOLH

class SignUpVC1: UIViewController, UITextFieldDelegate,CAAnimationDelegate{

    //MARK:- IBOutlets
    @IBOutlet weak var imgStep1: UIImageView!
    @IBOutlet weak var txtName: WATextField!
    @IBOutlet weak var txtMobileNumber: WATextField!
    @IBOutlet weak var txtEmail: WATextField!
    @IBOutlet weak var txtEmiratesIdNumber: WATextField!
    @IBOutlet weak var txtTribe: WATextField!
    @IBOutlet weak var imgTribe: UIImageView!
    @IBOutlet weak var txtDOB: WATextField!
    @IBOutlet weak var txtPlaceOfBirth: WATextField!
    @IBOutlet weak var txtCountry: WATextField!
    @IBOutlet weak var txtEmirate: WATextField!
    @IBOutlet weak var txtAddress: WATextField!
    @IBOutlet weak var txtResidence: WATextField!
    @IBOutlet weak var svEthnicity: UIStackView!
    @IBOutlet weak var txtEthnicity: WATextField!
    @IBOutlet weak var txtMotherNationality: WATextField!
    
    //MARK:- Custom Vars
//    var dropDowns: DropDownFileds?
    
    var consultantId = 0
    var emiratesIDLength = 15 + 3 //3 for old data i.e. hyphons
    var memberID : Int? //if user is coming for edit
    var currentMember : Member?
    var isFamilyShow : Bool = true //by default it will be true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "step1".localized
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        
        self.txtEmiratesIdNumber.keyboardType = .asciiCapableNumberPad   //disabling arabic keyboard

        let alltextFields =  self.view.allSubViewsOf(type: UITextField.self)
        for txt in alltextFields {
            txt.setLeftPaddingPoints(7)
            txt.setRightPaddingPoints(7)
        }

        //Setting first image color to our theme color
        self.imgStep1.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        //defining and adding tap gesture on terms and condition check box
        let tapOnIsTribeVisible = UITapGestureRecognizer(target: self, action: #selector(imgTribeVisibleTapped))
        tapOnIsTribeVisible.numberOfTapsRequired = 1
        tapOnIsTribeVisible.numberOfTouchesRequired = 1
        imgTribe.isUserInteractionEnabled = true
        imgTribe.addGestureRecognizer(tapOnIsTribeVisible)

        if MOLHLanguage.isRTLLanguage() {
            self.txtName.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtMobileNumber.textAlignment = .right
            self.txtEmiratesIdNumber.textAlignment = .right
            self.txtAddress.textAlignment = .right
            self.txtTribe.textAlignment = .right
            self.txtDOB.textAlignment = .right
            self.txtPlaceOfBirth.textAlignment = .right
            self.txtCountry.textAlignment = .right
            self.txtEmirate.textAlignment = .right
            self.txtResidence.textAlignment = .right
            self.txtEthnicity.textAlignment = .right
            self.txtMotherNationality.textAlignment = .right
        }
        else{
            self.txtName.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtMobileNumber.textAlignment = .left
            self.txtEmiratesIdNumber.textAlignment = .left
            self.txtAddress.textAlignment = .left
            self.txtTribe.textAlignment = .left
            self.txtDOB.textAlignment = .left
            self.txtPlaceOfBirth.textAlignment = .left
            self.txtCountry.textAlignment = .left
            self.txtEmirate.textAlignment = .left
            self.txtResidence.textAlignment = .left
            self.txtEthnicity.textAlignment = .left
            self.txtMotherNationality.textAlignment = .left
        }
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        loadDropDowns()
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){//Member
            self.svEthnicity.isHidden = true //hidden for member
            if Constants.loggedInMember != nil{
                self.currentMember = Constants.loggedInMember
                setMemberValues()
            }
        }else if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
            UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue){//consultant coming for edit
            self.svEthnicity.isHidden = false //hidden for member
            getMemberDetail(isRefresh: false)
        }
        //Setting up the delegate
        txtEmiratesIdNumber.delegate = self
        txtDOB.delegate = self
        txtCountry.delegate = self
        txtEmirate.delegate = self
        txtResidence.delegate = self
        txtEthnicity.delegate = self
        txtMotherNationality.delegate = self
//        //Test Data
//        txtEmail.text = "zahoor.gorsi@gmail.com"
//        txtEmiratesIdNumber.text = "784-1983-7504292-0"
//        txtDOB.text = "18-APR-1983"
//        txtTribe.text = "Gujjar"
//        txtPlaceOfBirth.text = "Yanbu"
//        txtAddress.text =  "18 MET 2"
    }
    
    func getMemberDetail(isRefresh : Bool){
        if let memberId = memberID{
//            let method = Constants.apiGetMemberDetails + String(memberId)
//            //if not is refresh then show the spinnger else refreshing control has its own spinner
//            if (!isRefresh){
//                Utility.shared.showSpinner()
//            }
//            ALFWebService.shared.doGetData( method: method, success: { (response) in
            var dic = Dictionary<String,AnyObject>()
            dic["memberId"] = memberId as AnyObject
            //If loggedin member is a consultant, and he is viewing the profile of his own member then send consultant ID
            if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue  && Constants.loggedInMember?.userId == currentMember?.consultantId){ //
                dic["conId"] = Constants.loggedInMember?.userId as AnyObject    //you can send any thing here, but it should not be zero
            }else{  //incase of member just send 0
                dic["conId"] = 0 as AnyObject   //// be default, its mean some member, admin or some other consultant is trying to view the profile of a member, hence is viewed must remain false
            }
            dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
            dic["appVersion"] = Utility.getAppVersion() as AnyObject
            //if not is refresh then show the spinnger else refreshing control has its own spinner
            if (!isRefresh){
                Utility.shared.showSpinner()
            }
            print(dic)
            ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiGetMemberDetails, success: { (response) in
            Utility.shared.hideSpinner()
                if let status = response["Status"] as? Int {
                    if status == 1 {
                        if let data = response["User"] as? Dictionary<String,AnyObject> {
                            //To store a custom object into userdefaults you have to encode it
                            self.currentMember = Member.init(fromDictionary: data)
                            self.setMemberValues()
                        }
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
    
    //*************************************************************************************************************************************************************
    //populating all textfields
    //if consultant is editing then it will be called from getMemberDetail() to set the values of the member which is fetched from server
    //if Member is editing then it will be called from viewDidLoad to set the values of the member which is loaded from localStorage i.e. got at the time of login.
    //*************************************************************************************************************************************************************
    func setMemberValues() {
        self.txtName.text = self.currentMember?.fullName
        self.txtMobileNumber.text = self.currentMember?.phone?.stringValue
        self.txtEmail.text = self.currentMember?.email
        self.txtEmiratesIdNumber.text = self.currentMember?.emiratesIdNumber
        //If valid emirates ID exist (length >= 18) and logged in user is a member then Txt emiratesID is not editable
        if (self.txtEmiratesIdNumber.text?.count ?? 0 >= emiratesIDLength && UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){// //if emirates ID Exist
            self.txtEmiratesIdNumber.isEnabled = false
        }
        self.txtTribe.text = self.currentMember?.family
        isFamilyShow = self.currentMember?.isFamilyShow ?? false
        isFamilyShow = !isFamilyShow //Incase of edit reversing it because in the function we will reverse it again
        imgTribeVisibleTapped()
        if let date = self.currentMember?.birthDate{
            self.txtDOB.text = Utility.stringFromDateWithFormat(date, format: dateTimeFormat.onDevice.rawValue) //"dd-MMM-yyyy"
        }
        self.txtPlaceOfBirth.text = self.currentMember?.birthPlace
        selectCountryByID(Id: self.currentMember?.countryId)
        selectStateByID(Id: self.currentMember?.stateId)
        self.txtAddress.text = self.currentMember?.address
        selecResidenceById(Id: self.currentMember?.residenceTypeId)
        selectEthnicityById(Id: self.currentMember?.ethnicityId)
        selectMotherNationalityByID(Id: self.currentMember?.motherNationalityId)
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
    
    //MARK:- custom Methods
    @objc func backTap(_ btn: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    //************************************************
    //It sets the first drop down value into textField
    //************************************************
    func loadDropDowns(){
        var text = ""
        if (Constants.dropDowns != nil ){
            if (Constants.dropDowns!.countries.count > 0){
                selectCountryByID( Id: countryType.UAE.rawValue)
            }
            if (Constants.dropDowns!.states.count > 0){
                let val = Constants.dropDowns!.states[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtEmirate.text = text
                self.txtEmirate.tag = (val["ValueId"] as? Int)!
            }
            //residence
            if (Constants.dropDowns!.residenceType.count > 0){
                let val = Constants.dropDowns!.residenceType[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtResidence.text = text
                self.txtResidence.tag = (val["ValueId"] as? Int)!
            }
            //ethnicity
            if (Constants.dropDowns!.ethnicity.count > 0){
                let val = Constants.dropDowns!.ethnicity[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtEthnicity.text = text
                self.txtEthnicity.tag = (val["ValueId"] as? Int)!
            }
            //Mother Nationality
            if (Constants.dropDowns!.countries.count > 0){
                selectMotherNationalityByID( Id: countryType.UAE.rawValue)
            }
        }
    }
    
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectCountryByID( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.countries , ID: Id) //UAE has 218 ID
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.countries[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtCountry.text = text
            self.txtCountry.tag = val["ValueId"] as? Int ?? 0
        }
    }
    
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectStateByID( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            var index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.states , ID: Id)
            if index < 0{
                if Constants.dropDowns!.states.count > 0{
                    index = Constants.dropDowns!.states.count - 1   // if state doesnt exist in the list then set index to state OTHERS, and continue to the next line of code
                }else{
                    return  //no need to continue to the next line of code just return
                }
            }
            let val = Constants.dropDowns!.states[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtEmirate.text = text
            self.txtEmirate.tag = (val["ValueId"] as? Int)!
        }
    }
    
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selecResidenceById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.residenceType , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.residenceType[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtResidence.text = text
            self.txtResidence.tag = val["ValueId"] as? Int ?? 0
        }
    }
    
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectEthnicityById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.ethnicity , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.ethnicity[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtEthnicity.text = text
            self.txtEthnicity.tag = val["ValueId"] as? Int ?? 0
        }
    }
    
    //**************************************
    //Select mother nationality from the drop down
    //**************************************
    func selectMotherNationalityByID( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.countries , ID: Id) //UAE has 218 ID
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.countries[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtMotherNationality.text = text
            self.txtMotherNationality.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //MARK:- IBActions
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
        view.endEditing(true) //To stop keyboard to open
        if (textField == self.txtCountry){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.countries.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.countries {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.countries[index]
                        textField.text = arr[index]
                        textField.tag = val["ValueId"] as? Int ?? 0
                        textField.resignFirstResponder()
                        if (textField.tag != countryType.UAE.rawValue){ //If selected Value is other then UAE then state should display others
                            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.states , ID: stateCode.others.rawValue) //UAE has 218 ID
                            let val = Constants.dropDowns!.states[index] //Val will have others now
                            var text = ""
                            if MOLHLanguage.isRTLLanguage() {
                                text = (val["ValueAR"] as? String)!
                            }else{
                                text = (val["ValueEN"] as? String)!
                            }
                            self.txtEmirate.text = text
                            self.txtEmirate.tag = (val["ValueId"] as? Int)!
                            self.txtEmirate.isEnabled = false //Forcing user to pick others in case of non UAE
                        }else{
                            self.txtEmirate.isEnabled = true
                        }
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtEmirate){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.states.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.states {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.states[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtDOB){
            print (Date())
            let maxDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
            let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.date, selectedDate: Date() as Date?, doneBlock: {
                picker, value, index in
//                print(value ?? "default vaue")
                var selectedDate = value as! Date
//                print(selectedDate,maxDate as Any)
                if selectedDate > maxDate!
                {
                    print(selectedDate,maxDate as Any)
                    selectedDate = maxDate!
                }
                let dateString = Utility.stringFromDateWithFormat(selectedDate, format: dateTimeFormat.onDevice.rawValue) //"dd-MMM-yyyy"
//                print(dateString)
                textField.text = dateString
                textField.resignFirstResponder()
            }, cancel: {ActionMultipleStringCancelBlock in return}, origin: textField as UIView)
            datePicker?.maximumDate = maxDate
            //datePicker?.timeZone = NSTimeZone.local
//            datePicker?.timeZone = NSTimeZone.init(forSecondsFromGMT: 4*60*60) as TimeZone 
            datePicker?.show()
            return false;  // Hide both keyboard and blinking cursor.
        }else if (textField == self.txtResidence){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.residenceType.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.residenceType {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.residenceType[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }else if (textField == self.txtEthnicity){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.ethnicity.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.ethnicity {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.ethnicity[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }else if (textField == self.txtMotherNationality){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.countries.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.countries {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.countries[index]
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
    
    //String is the latest entry in the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Always allow a backspace
        if ( string == "") {
            return true
        }
        if (textField == txtEmiratesIdNumber && txtEmiratesIdNumber.text?.count ?? 0 > emiratesIDLength){//max 18 characters are allowed
            return false
        }
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
        //This code is not handlig editing of emirates id from the centre.
        if (textField == txtEmiratesIdNumber && currentMember?.countryId == countryType.UAE.rawValue){
            //start
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if newString.count > emiratesIDLength{
                return false
            }
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            let strWithoutHyphens = components.joined(separator: "") as NSString
            let length = strWithoutHyphens.length
//            if length > emiratesIDLength{
//                return false
//            }
            var index = 0 as Int
            var hyphenCount = 0 as Int
            let formattedString = NSMutableString()

            if length - index > 3 {
                let prefix = strWithoutHyphens.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
                hyphenCount += 1
            }
            if length - index > 4 {
                let prefix = strWithoutHyphens.substring(with: NSMakeRange(index, 4))
                formattedString.appendFormat("%@-", prefix)
                index += 4
                hyphenCount += 1
            }
            if length - index > 7 {
                let prefix = strWithoutHyphens.substring(with: NSMakeRange(index, 7))
                formattedString.appendFormat("%@-", prefix)
                index += 7
                hyphenCount += 1
            }
            let remainder = strWithoutHyphens.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String

            return false
            //end
 
        }else{
            return true
        }
    }
    
//    -(bool) range:(NSRange) range ContainsLocation:(NSInteger) location
    func ContainsLocation (range: NSRange, location:Int) -> Bool
    {
        if(range.location <= location && range.location+range.length >= location){
            return true;
        }
        return false;
    }
    
    //***************************************************************************
    //When user will tap on T&C check box, and when consultant is coming for edit
    //***************************************************************************
    @objc func imgTribeVisibleTapped() {
        isFamilyShow = !isFamilyShow
        if isFamilyShow { //if true then make ticked check box
            imgTribe.image = #imageLiteral(resourceName: "check")
        } else {
           imgTribe.image = #imageLiteral(resourceName: "uncheck")
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
        // 20200611
        //trimming white spaces which appear in email address if picked from the suggestion bar of iPhone
        let strEmail = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if !(Utility.isValidEmail(emailToValidate: strEmail ?? "")) {
            Utility.showAlert(title: "validation".localized, withMessage: "email_notValid".localized, withNavigation: self)
            return
        }
        print (currentMember?.countryId ?? "Default",countryType.UAE.rawValue)
        print (txtEmiratesIdNumber.text!.count,emiratesIDLength)
        //if country is UAE and emirates ID length is more than 18 OR less than 15 (to handle legacy data)
        if ((currentMember?.countryId == countryType.UAE.rawValue && (txtEmiratesIdNumber.text!.count < emiratesIDLength - 3 ||  //without dashes, to handle legacy data
            txtEmiratesIdNumber.text!.count > emiratesIDLength)  ) ||
            (currentMember?.countryId != countryType.UAE.rawValue && txtEmiratesIdNumber.text!.count < 9)   //9 is min national ID length for bahrain, KSA = 10 , Kuwait=12
        ) {
            Utility.showAlert(title: "validation".localized, withMessage: "emirate_id_notValid".localized, withNavigation: self)
            return
        }
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
            dic["userId"] = Constants.loggedInMember?.userId as AnyObject //It should be current user id
        }else{
            dic["userId"] = self.currentMember?.userId as AnyObject //It should be current user id
            dic["ethnicityId"] = txtEthnicity.tag as AnyObject
        }
        dic["email"] = txtEmail.text as AnyObject
        dic["emirateId"] = txtEmiratesIdNumber.text as AnyObject
        dic["family"] = txtTribe.text as AnyObject
        dic["isFamilyShow"] = (isFamilyShow == true ?  "true" : "false") as AnyObject //if true then send false and vice versa
        if let dob = txtDOB.text{
            let standardDateFormat = Utility.stringToDate(dob, format: dateTimeFormat.onDevice.rawValue)
            let serverDateString = Utility.stringFromDateWithFormat(standardDateFormat, format: dateTimeFormat.toServer.rawValue) //"MM-dd-yyyy"
            dic["birthDate"] = serverDateString as AnyObject
        }
        dic["birthPlace"] = txtPlaceOfBirth.text as AnyObject
        dic["countryId"] = txtCountry.tag as AnyObject
        dic["stateId"] = txtEmirate.tag as AnyObject
        dic["address"] = txtAddress.text as AnyObject
        dic["residenceTypeId"] = txtResidence.tag as AnyObject
//        self.paramDic["ethnicityId"] = txtEthnicity.tag as AnyObject added in the check at the top of this function that its only allowed to enter to non member
        dic["motherNationalityId"] = txtMotherNationality.tag as AnyObject
        
        dic["userUpdateId"]  = Constants.loggedInMember?.userId as AnyObject
        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
        dic["appVersion"] = Utility.getAppVersion() as AnyObject
//        print(dic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiStep1, success: { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let data = response["Data"] as? Dictionary<String,AnyObject> {
                        self.currentMember = Member.init(fromDictionary: data)
//                        print(self.currentMember?.age as Any)
                        //if logged in user is a member then save a custom object into userdefaults you have to encode it
                        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){//Member
                            let userArchivedData = NSKeyedArchiver.archivedData(withRootObject: self.currentMember as Any)
                            UserDefaults.standard.set(userArchivedData, forKey: "LoggedInUser") //Saving full user into shared preferences
                            Constants.loggedInMember = Utility.getLoggedInMember() //populating global variable with update values if any (in case of edit)
                            self.currentMember = Constants.loggedInMember //Current member is also logged in member, on next step self.memberDetail will be used to edit
                        }
                    }
                    let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC2) as! SignUpVC2
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
}
