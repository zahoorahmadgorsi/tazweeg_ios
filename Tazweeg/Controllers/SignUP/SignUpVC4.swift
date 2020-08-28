//  SignUpVC4.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 07/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.

import UIKit
import ActionSheetPicker_3_0
import MOLH

class SignUpVC4: UIViewController, UITextFieldDelegate, CAAnimationDelegate{
    
    @IBOutlet weak var lblSpouseData: UILabel!
    //MARK:- IBOutlets
    @IBOutlet weak var svSpouseArrangement: UIStackView!  // To Hide
    @IBOutlet weak var txtBrideArrangement: WATextField! // To Hide
    
    @IBOutlet weak var svIsMarryingInGCC: UIStackView!
    @IBOutlet weak var lblIsMarryingInGCC: UILabel!
    
    @IBOutlet weak var svNationality: UIStackView!
    @IBOutlet weak var txtNantionality: WATextField!
    
    
    @IBOutlet weak var svIsAcceptDMW: UIStackView!
    @IBOutlet weak var lblSocialStatusCheck: UILabel!
    
    @IBOutlet weak var svSocialStatus: UIStackView!
    @IBOutlet weak var txtSocialStatus: WATextField!
    
    @IBOutlet weak var svHasChildren: UIStackView!
    @IBOutlet weak var txtHasChildren: WATextField!
    
    @IBOutlet weak var svNoOfChildren: UIStackView!
    @IBOutlet weak var txtNoOfChildren: WATextField!
    
    @IBOutlet weak var svReproduction: UIStackView!
    @IBOutlet weak var txtReproduction: WATextField!
    

    @IBOutlet weak var txtAge: WATextField!
    @IBOutlet weak var txtHeight: WATextField!
    @IBOutlet weak var txtBodyType: WATextField!
    @IBOutlet weak var txtSkinColor: WATextField!
    @IBOutlet weak var txtEducationLevel: WATextField!
    @IBOutlet weak var txtIsWorking: WATextField!
    
    @IBOutlet weak var svJobType: UIStackView!
    @IBOutlet weak var txtJobType: WATextField!
    
    @IBOutlet weak var svSveil: UIStackView!  // To Hide
    @IBOutlet weak var txtSVeil: WATextField! // To Hide
    
    @IBOutlet weak var txtDrivingLicense: WATextField!
    
    @IBOutlet weak var svWillPayToBride: UIStackView!  // To Hide
    @IBOutlet weak var txtWillPayToBrideId: WATextField! // To Hide
    
    @IBOutlet weak var txtSpouseToLive: WATextField!
    
    @IBOutlet weak var lblTitle2: UILabel!
    
    @IBOutlet weak var imgStep1: UIImageView!
    @IBOutlet weak var imgStep2: UIImageView!
    @IBOutlet weak var imgStep3: UIImageView!
    @IBOutlet weak var imgStep4: UIImageView!
    
    @IBOutlet weak var imgIsAcceptDMW: UIImageView!
    @IBOutlet weak var imgIsMarryingInGCC: UIImageView!
    
    @IBOutlet weak var imgHasRefer: UIImageView!
    @IBOutlet weak var svNameRefer: UIStackView!
    
    @IBOutlet weak var lblHasRefer: UILabel!
    @IBOutlet weak var svHasRefer: UIStackView!
    @IBOutlet weak var txtReferName: WATextField!
    @IBOutlet weak var txtReferMobile: WATextField!
    
    var currentMember : Member?
    var memberID : Int? //if user is coming for edit
    var isMarryingInGCC : Bool = false
    var isAcceptDMW : Bool = false
    var hasRefer : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "step4".localized
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        //Setting image and label color to our theme color
        self.imgStep1.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        self.imgStep2.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        self.imgStep3.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        self.imgStep4.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        
        //defining and adding tap gesture on terms and condition check box
        let tapOnIsMarryingInGCC = UITapGestureRecognizer(target: self, action: #selector(imgIsMarryingInGCCTapped))
        tapOnIsMarryingInGCC.numberOfTapsRequired = 1
        tapOnIsMarryingInGCC.numberOfTouchesRequired = 1
        imgIsMarryingInGCC.isUserInteractionEnabled = true
        imgIsMarryingInGCC.addGestureRecognizer(tapOnIsMarryingInGCC)
        
        //defining and adding tap gesture on terms and condition check box
        let tapOnIsAcceptDMW = UITapGestureRecognizer(target: self, action: #selector(imgIsAcceptDMWTapped))
        tapOnIsAcceptDMW.numberOfTapsRequired = 1
        tapOnIsAcceptDMW.numberOfTouchesRequired = 1
        imgIsAcceptDMW.isUserInteractionEnabled = true
        imgIsAcceptDMW.addGestureRecognizer(tapOnIsAcceptDMW)
        
        //defining and adding tap gesture on terms and condition check box
        let tapOnImgHasRefer = UITapGestureRecognizer(target: self, action: #selector(imgHasReferTapped))
        tapOnImgHasRefer.numberOfTapsRequired = 1
        tapOnImgHasRefer.numberOfTouchesRequired = 1
        imgHasRefer.isUserInteractionEnabled = true
        imgHasRefer.addGestureRecognizer(tapOnImgHasRefer)
        
        let alltextFields =  self.view.allSubViewsOf(type: UITextField.self)
        for txt in alltextFields {
            txt.setLeftPaddingPoints(7)
            txt.setRightPaddingPoints(7)
        }
        if MOLHLanguage.isRTLLanguage() {
            self.lblIsMarryingInGCC.textAlignment = .right
            self.txtBrideArrangement.textAlignment = .right
            self.txtNantionality.textAlignment = .right
            self.lblSocialStatusCheck.textAlignment = .right
            self.txtSocialStatus.textAlignment = .right
            self.txtHasChildren.textAlignment = .right
            self.txtNoOfChildren.textAlignment = .right
            self.txtReproduction.textAlignment = .right
            self.txtAge.textAlignment = .right
            self.txtHeight.textAlignment = .right
            self.txtBodyType.textAlignment = .right
            self.txtSkinColor.textAlignment = .right
            self.txtEducationLevel.textAlignment = .right
            self.txtIsWorking.textAlignment = .right
            self.txtJobType.textAlignment = .right
            self.txtSVeil.textAlignment = .right
            self.txtDrivingLicense.textAlignment = .right
            self.txtWillPayToBrideId.textAlignment = .right
            self.txtSpouseToLive.textAlignment = .right
            self.lblHasRefer.textAlignment = .right
            self.txtReferName.textAlignment = .right
            self.txtReferMobile.textAlignment = .right
        }
        else{
            self.lblIsMarryingInGCC.textAlignment = .left
            self.txtBrideArrangement.textAlignment = .left
            self.txtNantionality.textAlignment = .left
            self.lblSocialStatusCheck.textAlignment = .left
            self.txtSocialStatus.textAlignment = .left
            self.txtHasChildren.textAlignment = .left
            self.txtNoOfChildren.textAlignment = .left
            self.txtReproduction.textAlignment = .left
            self.txtAge.textAlignment = .left
            self.txtHeight.textAlignment = .left
            self.txtBodyType.textAlignment = .left
            self.txtSkinColor.textAlignment = .left
            self.txtEducationLevel.textAlignment = .left
            self.txtIsWorking.textAlignment = .left
            self.txtJobType.textAlignment = .left
            self.txtSVeil.textAlignment = .left
            self.txtDrivingLicense.textAlignment = .left
            self.txtWillPayToBrideId.textAlignment = .left
            self.txtSpouseToLive.textAlignment = .left
            self.lblHasRefer.textAlignment = .left
            self.txtReferName.textAlignment = .left
            self.txtReferMobile.textAlignment = .left
        }
        // For female its hidden on step 4
        // For male its visible on step 4
        // If logged in user is a member and she is female OR if logged in user is a consultant and consultant is editing a female
        if (Constants.loggedInMember?.genderId == genderType.female.rawValue && UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue) ||
            (self.currentMember?.genderId == genderType.female.rawValue && ( UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
                UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue)){
            self.svSpouseArrangement.isHidden = true
            self.svSveil.isHidden = true
            self.svWillPayToBride.isHidden = true
            lblSpouseData.text = "groom_data".localized;
            lblSocialStatusCheck.text = "female_social_status_check".localized
        }else{
            lblSpouseData.text = "bride_data".localized;
            lblSocialStatusCheck.text = "male_social_status_check".localized
        }
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        
        loadDropDowns()
        //Loading current member details from localStorage where it was stored after login as well as after step 1
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue && Constants.loggedInMember != nil){//Member
            self.currentMember = Constants.loggedInMember
        }
        setMemberVals()
    }
    
    //******************
    //In case of Editing
    //******************
    func setMemberVals() {
        selectBrideArrangementById(Id: self.currentMember?.sBrideArrangmentId)
        selectNationalityById(Id: self.currentMember?.sCountryId)
        isAcceptDMW = self.currentMember?.acceptDMW ?? false
        isAcceptDMW = !isAcceptDMW //Incase of edit reversing it because in the function we will reverse it again
        imgIsAcceptDMWTapped()
        
        selectSocialStatusById(Id: self.currentMember?.sSocialStatusId)
        selectHasChildById(Id: self.currentMember?.sHasChildId)
        selectNumberOfChildrenById(Id: self.currentMember?.sNoOfChildrenId)
        selectReproductionById(Id: self.currentMember?.sReproductionId)
        selectAgeById(Id: self.currentMember?.sAgeId)
        selectHeightById(Id: self.currentMember?.sHeightId)
        selectBodyTypeById(Id: self.currentMember?.sBodyTypeId)
        selectSkinColorById(Id: self.currentMember?.sSkinColorId)
        selectEducationLeveId(Id: self.currentMember?.sEducationLevelId)
        selectIsWorkingById(Id: self.currentMember?.sIsWorkingId)
        selectJobTypeById(Id: self.currentMember?.sJobTypeId)
        selectVeilById(Id: self.currentMember?.sVeilId)
        selectLicenseById(Id: self.currentMember?.sDrivingLicenseId)
        selectWillPayToBrideById(Id: self.currentMember?.willPayToBrideId)
        selectSpouseStateToLiveById(Id: self.currentMember?.spouseStateToLiveId)
        isMarryingInGCC = self.currentMember?.GCCMarriage ?? false
        isMarryingInGCC = !isMarryingInGCC //Incase of edit reversing it because in the function we will reverse it again
        imgIsMarryingInGCCTapped()
        
        hasRefer = self.currentMember?.hasRefer ?? false
        hasRefer = !hasRefer //Incase of edit reversing it because in the function we will reverse it again
        imgHasReferTapped()
        self.txtReferName.text = self.currentMember?.nameRefer
        self.txtReferMobile.text = self.currentMember?.mobileRefer
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
    func selectNationalityById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.countries , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.countries[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtNantionality.text = text
            self.txtNantionality.tag = val["ValueId"] as? Int ?? 0
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
    func selectAgeById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.requiredAge , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.requiredAge[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtAge.text = text
            self.txtAge.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectHeightById( Id : Int?)
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
    func selectBodyTypeById( Id : Int?)
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
    func selectSkinColorById( Id : Int?)
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
    func selectEducationLeveId( Id : Int?)
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
            }else{
                svJobType.isHidden = true
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
    func selectVeilById( Id : Int?)
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
            self.txtSVeil.text = text
            self.txtSVeil.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectLicenseById( Id : Int?)
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
            self.txtDrivingLicense.text = text
            self.txtDrivingLicense.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectWillPayToBrideById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.willPayToBride , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.willPayToBride[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtWillPayToBrideId.text = text
            self.txtWillPayToBrideId.tag = val["ValueId"] as? Int ?? 0
        }
    }
    //**************************************
    //Select passed value from the drop down
    //**************************************
    func selectSpouseStateToLiveById( Id : Int?)
    {
        var text = ""
        if let Id = Id{
            let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.states , ID: Id)
            if index < 0{
                return
            }
            let val = Constants.dropDowns!.states[index]
            if MOLHLanguage.isRTLLanguage() {
                text = (val["ValueAR"] as? String)!
            }else{
                text = (val["ValueEN"] as? String)!
            }
            self.txtSpouseToLive.text = text
            self.txtSpouseToLive.tag = val["ValueId"] as? Int ?? 0
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
            if (Constants.dropDowns!.countries.count > 0){
                let index : Int = Utility.getIndexByID(dict: Constants.dropDowns!.countries , ID: countryType.UAE.rawValue) //UAE has 218 ID
                let val = Constants.dropDowns!.countries[index]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtNantionality.text = text
                self.txtNantionality.tag = (val["ValueId"] as? Int)!
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
                self.txtNoOfChildren.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.reproduction.count > 0){
                let val = Constants.dropDowns!.reproduction[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtReproduction.text = text
                self.txtReproduction.tag = (val["ValueId"] as? Int)!
            }
            
            if (Constants.dropDowns!.requiredAge.count > 0){
                let val = Constants.dropDowns!.requiredAge[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtAge.text = text
                self.txtAge.tag = (val["ValueId"] as? Int)!
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
            if (Constants.dropDowns!.isWorking.count > 0){
                let val = Constants.dropDowns!.isWorking[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtIsWorking.text = text
                self.txtIsWorking.tag = (val["ValueId"] as? Int)!
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
            if (Constants.dropDowns!.veil.count > 0){
                let val = Constants.dropDowns!.veil[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtSVeil.text = text
                self.txtSVeil.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.hasLicense.count > 0){
                let val = Constants.dropDowns!.hasLicense[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtDrivingLicense.text = text
                self.txtDrivingLicense.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.willPayToBride.count > 0){
                let val = Constants.dropDowns!.willPayToBride[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtWillPayToBrideId.text = text
                self.txtWillPayToBrideId.tag = (val["ValueId"] as? Int)!
            }
            if (Constants.dropDowns!.states.count > 0){
                let val = Constants.dropDowns!.states[0]
                if MOLHLanguage.isRTLLanguage() {
                    text = (val["ValueAR"] as? String)!
                }else{
                    text = (val["ValueEN"] as? String)!
                }
                self.txtSpouseToLive.text = text
                self.txtSpouseToLive.tag = (val["ValueId"] as? Int)!
            }
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
        //To stop keyboard to open
        self.view.endEditing(true)
        if (textField == self.txtBrideArrangement){
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
        else if (textField == self.txtNantionality){
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
                        //For male, step 4 is of female so male cant marry a married female so hide married
//                        if (((  UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue        && Constants.loggedInMember?.genderId == genderType.male.rawValue ) ||
//                            ((   UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
//                                UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue)   && self.currentMember?.genderId == genderType.male.rawValue )) &&
//                            id == socialStatusCode.married.rawValue){ // 57 is married
                        if (self.currentMember?.genderId == genderType.male.rawValue && id == socialStatusCode.married.rawValue){ // 57 is married
                            continue;
                        }
                        //self.socialStatusID = dict["ValueId"] as? Int ?? 0
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let valIndex : Int = Utility.getIndexByValue(dict: Constants.dropDowns!.socialStatus, value: val as? String ?? "") //because we might skipped married social status
                        let val = Constants.dropDowns!.socialStatus[valIndex]
                        textField.text = arr[index] //It contains depending on MOLH
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
                        textField.tag = (val["ValueId"] as? Int)!
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
        
        else if (textField == self.txtAge){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.requiredAge.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.requiredAge {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }
                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.requiredAge[index]
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
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtEducationLevel){
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
                        if (textField.tag != isWorkingCode.working.rawValue) //Working
                        {
                            self.svJobType.isHidden = true
                        }else{
                            self.svJobType.isHidden = false
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
        else if (textField == self.txtSVeil){
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
        else if (textField == self.txtDrivingLicense){
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
        else if (textField == self.txtWillPayToBrideId){
            if (Constants.dropDowns != nil ){
                if (Constants.dropDowns!.willPayToBride.count > 0){
                    var arr = [String]()
                    for dict in Constants.dropDowns!.willPayToBride {
                        var text = ""
                        if MOLHLanguage.isRTLLanguage() {
                            text = (dict["ValueAR"] as? String)!
                        }else{
                            text = (dict["ValueEN"] as? String)!
                        }
                        arr.append(text)
                    }

                    ActionSheetStringPicker(title: "select_one".localized, rows: arr, initialSelection: 0, doneBlock: { (pick, index, val) in
                        let val = Constants.dropDowns!.willPayToBride[index]
                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }
        else if (textField == self.txtSpouseToLive){
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
        else{
            return true;    // UnHide both keyboard and blinking cursor.
        }
    }
    
    
    @IBAction func nextTap(_ sender: UIButton) {
        let alltextFields =  self.view.allSubViewsOf(type: UITextField.self)
        var emptyTxtCount = 0
        var dic = Dictionary<String,AnyObject>()
        
        for txt in alltextFields {
            if txt.text?.count == 0 && txt.superview?.isHidden == false {
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
        // For female its hidden on step 4
        // For male its visible on step 4
        // If logged in user is a member and he is male OR if logged in user is a consultant and consultant is editing a male
        if (Constants.loggedInMember?.genderId == genderType.male.rawValue && UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue) ||
            (self.currentMember?.genderId == genderType.male.rawValue && ( UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
                UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue)){
            dic["sBrideArrangmentId"] = txtBrideArrangement.tag as AnyObject
            dic["sCondemnBrideId"] = txtSVeil.tag as AnyObject
            dic["sWillPayToBrideId"] = txtWillPayToBrideId.tag as AnyObject
        }
        
        dic["acceptDMW"] = (isAcceptDMW == true ?  "true" : "false" ) as AnyObject
        dic["sSocialStatusId"] = txtSocialStatus.tag as AnyObject
        
        if (txtSocialStatus.tag != socialStatusCode.single.rawValue){ //56 is Single, 57 is Married, 58 is Divorced and 59 is Widowed
            dic["sHasChildId"] = txtHasChildren.tag as AnyObject
            if (txtHasChildren.tag == isSmokingCode.no.rawValue){ //12 is NO, 13 is yes (using is smoking as we dont have has children)
                dic["sReproductionId"] = txtReproduction.tag as AnyObject
            }else{
                dic["sNoOfChildrenId"] = txtNoOfChildren.tag as AnyObject
            }
        }
        dic["GCCMarriage"] = (isMarryingInGCC == true ?  "true" : "false" ) as AnyObject
        dic["sNationalityId"] = txtNantionality.tag as AnyObject
        
        dic["sAgeId"] = txtAge.tag as AnyObject
        dic["sHeightId"] = txtHeight.tag as AnyObject
        dic["sBodyTypeId"] = txtBodyType.tag as AnyObject
        dic["sSkinColorId"] = txtSkinColor.tag as AnyObject
        dic["sEducationLevelId"] = txtEducationLevel.tag as AnyObject
        dic["sIsWorkingId"] = txtIsWorking.tag as AnyObject
        if (txtIsWorking.tag == isWorkingCode.working.rawValue){ //Is Working = yes
            dic["sJobTypeId"] = txtJobType.tag as AnyObject
        }
        dic["sDrivingLicenseId"] = txtDrivingLicense.tag as AnyObject
        dic["sRequiredStateId"] = txtSpouseToLive.tag as AnyObject
        dic["userUpdateId"]  = Constants.loggedInMember?.userId as AnyObject
        
        if(hasRefer == true){
    //        dic["hasRefer"] = (hasRefer == true ?  "true" : "false" ) as AnyObject
            dic["nameRefer"] = txtReferName.text as AnyObject
            dic["mobileRefer"] = txtReferMobile.text as AnyObject
        }
        
        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
        dic["appVersion"] = Utility.getAppVersion() as AnyObject
        print(dic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiStep4, success: { (response) in
            print(response)
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
                    let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC5) as! SignUpVC5
                    viewController.currentMember = self.currentMember
                    self.navigationController?.pushViewController(viewController, animated: true)
                    //                    self.navigationController?.push(viewController: viewController, transitionType: kCATransitionFade, transitionDirectionType: kCATransitionFromLeft, duration: 0.4)
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
    
    //***************************************************************************
    //When user will tap on T&C check box, and when consultant is coming for edit
    //***************************************************************************
    @objc func imgIsMarryingInGCCTapped() {
        isMarryingInGCC = !isMarryingInGCC
        if isMarryingInGCC { //if true then make ticked check box
            imgIsMarryingInGCC.image = #imageLiteral(resourceName: "check")
            svNationality.isHidden = true
        } else {
            imgIsMarryingInGCC.image = #imageLiteral(resourceName: "uncheck")
            svNationality.isHidden = false
        }
    }
    
    //***************************************************************************
    //When user will tap on T&C check box, and when consultant is coming for edit
    //***************************************************************************
    @objc func imgIsAcceptDMWTapped() {
        isAcceptDMW = !isAcceptDMW
        if isAcceptDMW { //if true then make ticked check box
            imgIsAcceptDMW.image = #imageLiteral(resourceName: "check")
            svSocialStatus.isHidden = true
        } else {
            imgIsAcceptDMW.image = #imageLiteral(resourceName: "uncheck")
            svSocialStatus.isHidden = false
        }
    }
    
    //***************************************************************************
    //When user will tap on T&C check box, and when consultant is coming for edit
    //***************************************************************************
    @objc func imgHasReferTapped() {
        hasRefer = !hasRefer
        if hasRefer { //if true then make ticked check box
            imgHasRefer.image = #imageLiteral(resourceName: "check")
            svNameRefer.isHidden = false
            svHasRefer.isHidden = false
        } else {
            imgHasRefer.image = #imageLiteral(resourceName: "uncheck")
            svNameRefer.isHidden = true
            svHasRefer.isHidden = true
        }
    }
}
