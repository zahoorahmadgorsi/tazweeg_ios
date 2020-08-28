//
//  SignUpVC3.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 07/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import MOLH


class SignUpVC3: UIViewController, UITextFieldDelegate, CAAnimationDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var txtEducationLevel: WATextField!
    @IBOutlet weak var txtReligionCommitment: WATextField!
    @IBOutlet weak var txtFinancialStatus: WATextField!
    @IBOutlet weak var txtSocialStatus: WATextField!
    
    @IBOutlet weak var svHasChildren: UIStackView!
    @IBOutlet weak var txtHasChildren: WATextField!
    
    @IBOutlet weak var svNoOfChildren: UIStackView!
    @IBOutlet weak var txtNoOfChildren: WATextField!
    
    @IBOutlet weak var svReproduction: UIStackView!
    @IBOutlet weak var txtReproduction: WATextField!
    
    @IBOutlet weak var txtIsWorking: WATextField!
    
    @IBOutlet weak var svOccupation: UIStackView!
    @IBOutlet weak var txtOccupation: WATextField!
    
    @IBOutlet weak var svJobType: UIStackView!
    @IBOutlet weak var txtJobType: WATextField!
    
    @IBOutlet weak var svJobTitle: UIStackView!
    @IBOutlet weak var txtJobTitle: WATextField!
    
    @IBOutlet weak var txtAnnualIncome: WATextField!
    @IBOutlet weak var txtAnyDisease: WATextField!
    
    @IBOutlet weak var svDisease: UIStackView!
    @IBOutlet weak var txtDiseaseName: WATextField!
    
    @IBOutlet weak var lblDoHaveDisease: UILabel!
    @IBOutlet weak var imgStep1: UIImageView!
    @IBOutlet weak var imgStep2: UIImageView!
    @IBOutlet weak var imgStep3: UIImageView!
    
    //MARK:- Custom Vars
    var currentMember : Member?
    var memberID : Int? //if user is coming for edit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "step3".localized
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        
        //Setting image and label color to our theme color
        self.imgStep1.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        self.imgStep2.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        self.imgStep3.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        
        let alltextFields =  self.view.allSubViewsOf(type: UITextField.self)
        for txt in alltextFields {
            txt.setLeftPaddingPoints(7)
            txt.setRightPaddingPoints(7)
        }
        if MOLHLanguage.isRTLLanguage() {
            
            self.txtEducationLevel.textAlignment = .right
            self.txtReligionCommitment.textAlignment = .right
            self.txtFinancialStatus.textAlignment = .right
            self.txtSocialStatus.textAlignment = .right
            
            self.txtHasChildren.textAlignment = .right
            self.txtNoOfChildren.textAlignment = .right
            self.txtReproduction.textAlignment = .right
            
            self.txtOccupation.textAlignment = .right
            self.txtIsWorking.textAlignment = .right
            self.txtJobType.textAlignment = .right
            self.txtAnnualIncome.textAlignment = .right
            self.lblDoHaveDisease.textAlignment = .right
            self.txtAnyDisease.textAlignment = .right
            self.txtJobTitle.textAlignment = .right
            self.txtDiseaseName.textAlignment = .right
        }
        else{
            
            self.txtEducationLevel.textAlignment = .left
            self.txtReligionCommitment.textAlignment = .left
            self.txtFinancialStatus.textAlignment = .left
            self.txtSocialStatus.textAlignment = .left
            
            self.txtHasChildren.textAlignment = .left
            self.txtNoOfChildren.textAlignment = .left
            self.txtReproduction.textAlignment = .left
            
            self.txtOccupation.textAlignment = .left
            self.txtIsWorking.textAlignment = .left
            self.txtJobType.textAlignment = .left
            self.txtAnnualIncome.textAlignment = .left
            self.lblDoHaveDisease.textAlignment = .left
            self.txtAnyDisease.textAlignment = .left
            self.txtJobTitle.textAlignment = .left
            self.txtDiseaseName.textAlignment = .left
        }
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        
        loadDropDowns()
        //Loading current member details from localStorage where it was stored after login as well as after step 1
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue && Constants.loggedInMember != nil){//Member
            self.currentMember = Constants.loggedInMember
        }
        setMemberValues()
        
        //Test Data
//        self.txtOccupation.text = "Occupation: Software Engineering"
//        self.txtJobTitle.text = "Job title: Sr. Mobile Application Developer"
    }
    
    //******************
    //In Case Of Editing
    //******************
    func setMemberValues() {
        selectEducationLevelById(Id: self.currentMember?.educationLevelId)
        selectReligionCommitmentById(Id: self.currentMember?.religionCommitmentId)
        selectFinancialStatusById(Id: self.currentMember?.financialStatusId)
        selectSocialStatusById(Id: self.currentMember?.socialStatusId)
        selectHasChildById(Id: self.currentMember?.hasChildId)
        selectNumberOfChildrenById(Id: self.currentMember?.numberOfChildrenId)
        selectReproductionById(Id: self.currentMember?.reproductionId)
        selectIsWorkingById(Id: self.currentMember?.isWorkingId)
        selectJobTypeById(Id: self.currentMember?.jobTypeId)
        self.txtOccupation.text = self.currentMember?.occupation
        self.txtJobTitle.text = self.currentMember?.jobTitle
        selectAnnualIncomeById(Id: self.currentMember?.annualIncomeId)
        selectIsDiseaseById(Id: self.currentMember?.isDiseaseId)
        self.txtDiseaseName.text = self.currentMember?.diseaseName
    }
    
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectEducationLevelById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.educationLevel , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.educationLevel[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtEducationLevel.text = text
            self.txtEducationLevel.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectReligionCommitmentById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.religionCommitment , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.religionCommitment[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtReligionCommitment.text = text
            self.txtReligionCommitment.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectFinancialStatusById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.financialCondition , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.financialCondition[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtFinancialStatus.text = text
            self.txtFinancialStatus.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectSocialStatusById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.socialStatus , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.socialStatus[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtSocialStatus.text = text
            self.txtSocialStatus.tag = val["ValueId"] as? Int ?? 0
            if (self.txtSocialStatus.tag != socialStatusCode.single.rawValue) //56 is Single, 57 is Married, 58 is Divorced and 59 is Widowed
            {
                self.svHasChildren.isHidden = false
                self.svReproduction.isHidden = false
            }else{
                self.svHasChildren.isHidden = true
                self.svNoOfChildren.isHidden = true
                self.svReproduction.isHidden = true
            }
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectHasChildById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.hasChildren , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.hasChildren[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtHasChildren.text = text
            self.txtHasChildren.tag = val["ValueId"] as? Int ?? 0
            if (self.txtHasChildren.tag == isSmokingCode.no.rawValue) //12 is NO, 13 is yes (using is smoking as we dont have has children)
            {
                self.svNoOfChildren.isHidden = true
                self.svReproduction.isHidden = false //if has children its mean not bhanjh
            }else{
                self.svNoOfChildren.isHidden = false
                self.svReproduction.isHidden = true
            }
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectNumberOfChildrenById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.numberOfChildren , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.numberOfChildren[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtNoOfChildren.text = text
            self.txtNoOfChildren.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectReproductionById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.reproduction , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.reproduction[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtReproduction.text = text
            self.txtReproduction.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectIsWorkingById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.isWorking , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.isWorking[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtIsWorking.text = text
            let isWorkingID = val["ValueId"] as? Int ?? 0
            self.txtIsWorking.tag = isWorkingID
            if (isWorkingID == isWorkingCode.working.rawValue){
                svJobType.isHidden = false
                svJobTitle.isHidden = false
                svOccupation.isHidden = false
            }else{
                svJobType.isHidden = true
                svJobTitle.isHidden = true
                svOccupation.isHidden = true
            }
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectJobTypeById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.jobType , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.jobType[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtJobType.text = text
            self.txtJobType.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectAnnualIncomeById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.annualIncome , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.annualIncome[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtAnnualIncome.text = text
            self.txtAnnualIncome.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectIsDiseaseById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.anyDisease , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.anyDisease[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtAnyDisease.text = text
            let diseaseID = val["ValueId"] as? Int ?? 0
            self.txtAnyDisease.tag = diseaseID
            if (diseaseID == isSmokingCode.yes.rawValue){
                self.svDisease.isHidden = false
            }else{
                self.svDisease.isHidden = true
            }
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
            
            if (Constants.dropDowns!.educationLevel.count > 0){
                let val = Constants.dropDowns!.educationLevel[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtEducationLevel.text = text
                self.txtEducationLevel.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.religionCommitment.count > 0){
                let val = Constants.dropDowns!.religionCommitment[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtReligionCommitment.text = text
                self.txtReligionCommitment.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.financialCondition.count > 0){
                let val = Constants.dropDowns!.financialCondition[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtFinancialStatus.text = text
                self.txtFinancialStatus.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.socialStatus.count > 0){
                let val = Constants.dropDowns!.socialStatus[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtSocialStatus.text = text
                self.txtSocialStatus.tag = val["ValueId"] as? Int ?? 0
            }
            if (Constants.dropDowns!.hasChildren.count > 0){
                let val = Constants.dropDowns!.hasChildren[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtHasChildren.text = text
                self.txtHasChildren.tag = val["ValueId"] as? Int ?? 0
            }
            if (Constants.dropDowns!.numberOfChildren.count > 0){
                let val = Constants.dropDowns!.numberOfChildren[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtNoOfChildren.text = text
                self.txtNoOfChildren.tag = val["ValueId"] as? Int ?? 0
            }
            if (Constants.dropDowns!.reproduction.count > 0){
                let val = Constants.dropDowns!.reproduction[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtReproduction.text = text
                self.txtReproduction.tag = val["ValueId"] as? Int ?? 0
            }
            if (Constants.dropDowns!.isWorking.count > 0){
                let val = Constants.dropDowns!.isWorking[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtIsWorking.text = text
                self.txtIsWorking.tag = val["ValueId"] as? Int ?? 0
            }
            if (Constants.dropDowns!.jobType.count > 0){
                let val = Constants.dropDowns!.jobType[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtJobType.text = text
                self.txtJobType.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.annualIncome.count > 0){
                let val = Constants.dropDowns!.annualIncome[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtAnnualIncome.text = text
                self.txtAnnualIncome.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.anyDisease.count > 0){
                let val = Constants.dropDowns!.anyDisease[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtAnyDisease.text = text
                self.txtAnyDisease.tag = val["ValueId"] as? Int ?? 0
            }
        }
    }
   
    //MARK:- IBActions
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
        //To stop keyboard to open
        self.view.endEditing(true)
        
         if (textField == self.txtEducationLevel){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.educationLevel.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.educationLevel {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.educationLevel[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtReligionCommitment){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.religionCommitment.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.religionCommitment {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.religionCommitment[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtFinancialStatus){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.financialCondition.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.financialCondition {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.financialCondition[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtSocialStatus){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.socialStatus.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.socialStatus {
                        var text = ""
                        let id = dict["ValueId"] as? Int ?? 0
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        //For female, step 3 having female data, and a married woman should not be part of tazweeg
//                        if (((  UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue        && Constants.loggedInMember?.genderId == genderType.female.rawValue ) ||
//                            ((  UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
//                                UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue)    && self.currentMember?.genderId == genderType.female.rawValue )) &&
//                            id == socialStatusCode.married.rawValue){ // 57 is married
                        if (self.currentMember?.genderId == genderType.female.rawValue &&
                            id == socialStatusCode.married.rawValue){ // 57 is married
                            continue;
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let valIndex : Int = Utility.getIndexByValue(dict: Constants.dropDowns!.socialStatus, value: val as? String ?? "") //because we might skipped married social status
                        let val = Constants.dropDowns!.socialStatus[valIndex]
                        textField.text = arr[index] //It contains string depending on MOLH
                        textField.tag = val["ValueId"] as? Int ?? 0
                        if (textField.tag != socialStatusCode.single.rawValue) //56 is Single, 57 is Married, 58 is Divorced and 59 is Widowed
                        {
                            self.svHasChildren.isHidden = false
                            self.svReproduction.isHidden = false
                        }else{
                            self.svHasChildren.isHidden = true
                            self.svNoOfChildren.isHidden = true
                            self.svReproduction.isHidden = true
                        }
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
         }
         else if (textField == self.txtHasChildren){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.hasChildren.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.hasChildren {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.hasChildren[index]
                        textField.text = arr[index]
                        textField.tag = val["ValueId"] as? Int ?? 0
                        if (textField.tag == isSmokingCode.no.rawValue) //12 is NO, 13 is yes (using is smoking as we dont have has children)
                        {
                            self.svNoOfChildren.isHidden = true
                            self.svReproduction.isHidden = false //if has children its mean not bhanjh
                        }else{
                            self.svNoOfChildren.isHidden = false
                            self.svReproduction.isHidden = true
                        }
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
         }
         else if (textField == self.txtNoOfChildren){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.numberOfChildren.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.numberOfChildren {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.numberOfChildren[index]
                        textField.text = arr[index]
                        textField.tag = val["ValueId"] as? Int ?? 0
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
         }
         else if (textField == self.txtReproduction){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.reproduction.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.reproduction {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.reproduction[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
         }
        else if (textField == self.txtIsWorking){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.isWorking.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.isWorking {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.isWorking[index]
                        textField.text = arr[index]
                        textField.tag = val["ValueId"] as? Int ?? 0
                        if (textField.tag != isWorkingCode.working.rawValue)
                        {
                            self.svOccupation.isHidden = true
                            self.svJobType.isHidden = true
                            self.svJobTitle.isHidden = true
                        }else{
                            self.svOccupation.isHidden = false
                            self.svJobType.isHidden = false
                            self.svJobTitle.isHidden = false
                        }
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
         }
        else if (textField == self.txtJobType){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.jobType.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.jobType {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.jobType[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtAnnualIncome){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.annualIncome.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.annualIncome {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.annualIncome[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtAnyDisease){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.anyDisease.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.anyDisease {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.anyDisease[index]
                        textField.text = arr[index]
                        textField.tag = val["ValueId"] as? Int ?? 0
                        if (textField.tag == isSmokingCode.no.rawValue) //12 is no, 13 is yes
                        {
                            self.svDisease.isHidden = true
                        }else{
                            self.svDisease.isHidden = false
                        }
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
    
    @IBAction func nextTap(_ sender: UIButton) {
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
        dic["educationLevelId"] = txtEducationLevel.tag as AnyObject
        dic["religionCommitmentId"] = txtReligionCommitment.tag as AnyObject
        dic["financialStatusId"] = txtFinancialStatus.tag as AnyObject
        // For Female its visible on step 3
        // For male its hidden on step 3
        dic["socialStatusId"] = self.txtSocialStatus.tag as AnyObject
        if (self.txtSocialStatus.tag != socialStatusCode.single.rawValue) //56 is Single, 57 is Married, 58 is Divorced and 59 is Widowed
        {
            dic["memberHasChildId"] = self.txtHasChildren.tag as AnyObject
            if (self.txtHasChildren.tag == isSmokingCode.no.rawValue) //12 is NO, 13 is yes (using is smoking as we dont have has children)
            {
                dic["memberReproductionId"] = txtReproduction.tag as AnyObject
                
            }else{
                dic["memberNoOfChildrenId"] = txtNoOfChildren.tag as AnyObject
            }
        }
        dic["isWorkingId"] = txtIsWorking.tag as AnyObject
        if (txtIsWorking.tag == isWorkingCode.working.rawValue) //60 is working, 61 is not working, 62 is doesnt matter
        {
            dic["memberWorking"] = txtOccupation.text as AnyObject
            dic["jobTypeId"] = txtJobType.tag as AnyObject
            dic["jobTitle"] = txtJobTitle.text as AnyObject
        }
        dic["annualIncomeId"] = txtAnnualIncome.tag as AnyObject
        dic["isDiseaseId"] = self.txtAnyDisease.tag as AnyObject
        if (self.txtAnyDisease.tag == isSmokingCode.yes.rawValue) //12 is no, 13 is yes
        {
            dic["diseaseName"] = txtDiseaseName.text as AnyObject
        }
        
        dic["userUpdateId"]  = Constants.loggedInMember?.userId as AnyObject
        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
        dic["appVersion"] = Utility.getAppVersion() as AnyObject
//        print(self.paramDic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiStep3, success: { (response) in
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
                    let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC4) as! SignUpVC4
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
    @IBAction func backTap(_ sender: UIButton) {
        self.navigationController?.pop(transitionType: kCATransitionFade, transitionDirectionType: kCATransitionFromRight, duration: 0.4)
    }

}
