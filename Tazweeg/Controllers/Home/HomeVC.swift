//  MemberHomeVC.swift
//  Tazweeg
//  Created by iMac on 4/10/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.

import Foundation
import MOLH
import StoreKit //IAP

class HomeVC: UIViewController {
    @IBOutlet weak var imgPercentComplete: UIImageView!
    @IBOutlet weak var lblPercentComplete: UILabel!
    @IBOutlet weak var imgRightArrow: UIImageView!
    @IBOutlet weak var svProfile: UIStackView!
    @IBOutlet weak var svConsultant: UIStackView!
    @IBOutlet weak var viewCompleteYouProfile: UIView!
    
    @IBOutlet weak var lblProfile: WALabel!
    @IBOutlet weak var lblMemberName: UILabel!
    @IBOutlet weak var lblMemberCode: UILabel!
    @IBOutlet weak var lblProfileStatus: UILabel!
    
    @IBOutlet weak var lblConsultant: WALabel!
    @IBOutlet weak var lblConsultantName: UILabel!
    @IBOutlet weak var btnConsultantNumber: UIButton!
    @IBOutlet weak var lblConsultantStates: UILabel!
    
    @IBOutlet weak var imgMatchCount: UIImageView!
    @IBOutlet weak var lblMatchCount: UILabel!
    var profilePercentComplete : Int!
    //placeholder reference to the IAP product you created
    var iAPProducts: [SKProduct] = []
    var tabBarItemProfile: UITabBarItem = UITabBarItem()
    var tabBarItemMatching: UITabBarItem = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        
        //defining and adding tap gesture on viewCompleteYouProfile
        let tapGestureOnviewCompleteYouProfile = UITapGestureRecognizer(target: self, action: #selector(viewCompleteProfileTapped))
        tapGestureOnviewCompleteYouProfile.numberOfTapsRequired = 1
        tapGestureOnviewCompleteYouProfile.numberOfTouchesRequired = 1
        viewCompleteYouProfile.isUserInteractionEnabled = true
        viewCompleteYouProfile.addGestureRecognizer(tapGestureOnviewCompleteYouProfile)

        //defining and adding tap gesture on ImgMatchCount
        let tapGestureOnImgMatchCount = UITapGestureRecognizer(target: self, action: #selector(imgMatchingCountTapped))
        tapGestureOnImgMatchCount.numberOfTapsRequired = 1
        tapGestureOnImgMatchCount.numberOfTouchesRequired = 1
        imgMatchCount.isUserInteractionEnabled = true
        imgMatchCount.addGestureRecognizer(tapGestureOnImgMatchCount)
        
        if MOLHLanguage.isRTLLanguage() {
            imgRightArrow.image = UIImage(named: "left arrow")!
        }
        else{
            imgRightArrow.image = UIImage(named: "right arrow")!
        }
        self.navigationItem.title = "home".localized
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        
        loadIAPProducts()
        getDropDownsData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(btnLogin.frame.height/2)
        lblProfile.cornerRadius = lblProfile.frame.height/2
        lblConsultant.cornerRadius = lblProfile.frame.height/2
    }
    
    //**************************************************************
    //this function loads the in app products which is only 1 so far
    //**************************************************************
    func loadIAPProducts() {
        iAPProducts = []
        iAPProduct.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.iAPProducts = products!
            }
        }
    }

    //***************************************
    //this Function loads all dropdown fields
    //***************************************
    func getDropDownsData(){
//        let dic = Dictionary<String,AnyObject>()
        Utility.shared.showSpinner()
        ALFWebService.shared.doGetData( method: Constants.apiGetType, success: { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let pre_registration_info = response["Values"] as? [Dictionary<String,AnyObject>] {
                        Constants.dropDowns = DropDownFileds.init(fromDictionary: pre_registration_info)
                    }
                } else {
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
                }
            }else {
                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
            }
        }) { (response) in
//            print(response)
            Utility.shared.hideSpinner()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        Constants.loggedInMember =  Utility.getLoggedInMember()
        if(Constants.loggedInMember != nil){
            setMemberValues()
        }
    }

    
    func setMemberValues()
    {
        if let mobileStatus = Constants.loggedInMember?.mobileStatus{
            profilePercentComplete = mobileStatus * 20
            switch mobileStatus{
            case 0:
                self.imgPercentComplete.image = UIImage(named: "0%")
                break
            case 1:
                self.imgPercentComplete.image = UIImage(named: "20%")
                self.imgPercentComplete.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
                break
            case 2:
                self.imgPercentComplete.image = UIImage(named: "40%")
                self.imgPercentComplete.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
                break
            case 3:
                self.imgPercentComplete.image = UIImage(named: "60%")
                self.imgPercentComplete.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
                break
            case 4:
                self.imgPercentComplete.image = UIImage(named: "80%")
                self.imgPercentComplete.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
                break
            case 5:
                self.imgPercentComplete.image = UIImage(named: "90%")
                self.imgPercentComplete.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
                profilePercentComplete = 90
            case 6:
                self.imgPercentComplete.image = UIImage(named: "100%")
                self.imgPercentComplete.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
                profilePercentComplete = 100
                break
            default:
                self.imgPercentComplete.image = UIImage(named: "0%")
            }
        }
        else{
            profilePercentComplete = 0
            self.imgPercentComplete.image = UIImage(named: "0%")
        }
        //By passing all steps logic if user has paid.... because paid mean all 5 steps are completed.
        if let paymentStatus = Constants.loggedInMember?.profileStatusId{
            if(paymentStatus == profileStatusType.paid.rawValue)
            {
                self.imgPercentComplete.image = UIImage(named: "100%")
                self.imgPercentComplete.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
                profilePercentComplete = 100
            }
        }
        self.lblPercentComplete.text =  String(profilePercentComplete) + "percentage_complete".localized
        self.lblMemberName.text = Constants.loggedInMember?.fullName
        self.lblMemberCode.text = Constants.loggedInMember?.code
        if MOLHLanguage.isRTLLanguage() {
            self.lblProfileStatus.text = Constants.loggedInMember?.profileStatusAR
        }
        else{
            self.lblProfileStatus.text = Constants.loggedInMember?.profileStatusEN
        }
        
        self.lblConsultantName.text = Constants.loggedInMember?.consultantName
        self.btnConsultantNumber.setTitle(Constants.loggedInMember?.cMobile?.stringValue, for: .normal)
        self.lblConsultantStates.text = Constants.loggedInMember?.consultantStates
        self.lblMatchCount.text = String(Constants.loggedInMember?.choosingCount ?? 0)
        
        self.lblPercentComplete.textColor = UIColor(hexString: appColors.defaultColor.rawValue)
        self.imgMatchCount.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        
        //if user has been married or have consumed 3 attempts then disabling profile and matching tab
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        if let tabArray = tabBarControllerItems {
            tabBarItemProfile = tabArray[1]
            tabBarItemMatching = tabArray[2]
            //if user has been married/finished or has used his 3 attempts
            if(Constants.loggedInMember?.profileStatusId == profileStatusType.finished.rawValue || Constants.loggedInMember?.isAttemptCompleted == true){
                tabBarItemProfile.isEnabled = false
                tabBarItemMatching.isEnabled = false
            }else{
                tabBarItemProfile.isEnabled = true
                tabBarItemMatching.isEnabled = true
            }
        }
        
        

        
    }
    
    @objc func backTap(_ btn: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Method
    @objc func menuTap(_ btn: UIBarButtonItem){
        if MOLHLanguage.isRTLLanguage() {
            self.slideMenuController()?.toggleRight()
        }
        else{
            self.slideMenuController()?.toggleLeft()
        }
    }
    
    //This method will always be called for memberΩΩ
    //This method decides on which UI to navigate, depending on % of profile complete
//    @objc func viewCompleteProfileTapped(sender: UITapGestureRecognizer) {
    @objc func viewCompleteProfileTapped() {
        //if user has been married/finished or has used his 3 attempts
        if(Constants.loggedInMember?.profileStatusId == profileStatusType.finished.rawValue || Constants.loggedInMember?.isAttemptCompleted == true){
            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "profile_finished".localized, withNavigation: self)
            return
        }
        switch profilePercentComplete {
//        case 0: //Default
//            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC1) as! SignUpVC1
//            self.navigationController?.pushViewController(viewController, animated: true)
//            break
        case 20:
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC2) as! SignUpVC2
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        case 40:
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC3) as! SignUpVC3
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        case 60:
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC4) as! SignUpVC4
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        case 80:
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC5) as! SignUpVC5
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        case 90:
            let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            dvc.pageType = .payment
            dvc.currentMember = Constants.loggedInMember //it will be a member and can not be a consultant as
            self.navigationController?.pushViewController(dvc, animated: true)
            break
        case 100:
            self.tabBarController?.selectedIndex = 1
            break
        default:
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC1) as! SignUpVC1
            self.navigationController?.pushViewController(viewController, animated: true)
//            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC4) as! SignUpVC4
//            self.navigationController?.pushViewController(viewController, animated: true)
            break
        }
    }
    
    
    
    //    Added @objg to suppress the error "Argument of '#selector' refers to instance method 'usersSVTapped(sender:)' that is not exposed to Objective-C"
    //    and Because in Swift 4, functions are no longer implicitly exposed to Objective-C code, which is needed to be able to invoke it as a selector
    @objc func imgMatchingCountTapped(sender: UITapGestureRecognizer){
        //if user has been married/finished or has used his 3 attempts
        if(Constants.loggedInMember?.profileStatusId == profileStatusType.finished.rawValue || Constants.loggedInMember?.isAttemptCompleted == true){
            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "profile_finished".localized, withNavigation: self)
            return
        }
        if let profileStatusId = Constants.loggedInMember?.profileStatusId{
            if (profileStatusId == profileStatusType.paid.rawValue){  //paid the fee(profile completed)
                self.tabBarController?.selectedIndex = 2
            }else {    //profile is incomplete
                Utility.showAlertWithOkCancel(title: "confirm".localized, withMessage: "incomplete_profile".localized, withNavigation: self, withOkBlock: {
                    //Ok Block
                    self.viewCompleteProfileTapped() //it will navigate to payment Gateway
                }) {
                    //Cancel Block
                }
            }
        }else{
            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
        }
    }
    
    @IBAction func btnConsultantNumberTapped(_ sender: Any) {
        //if user has been married/finished or has used his 3 attempts
        if(Constants.loggedInMember?.profileStatusId == profileStatusType.finished.rawValue || Constants.loggedInMember?.isAttemptCompleted == true){
            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "profile_finished".localized, withNavigation: self)
            return
        }
        Utility.makeAPhoneCall(strPhoneNumber: btnConsultantNumber?.titleLabel?.text ?? Constants.phone)
    }
    
    @IBAction func btnWhatsAppTapped(_ sender: Any) {
        //if user has been married/finished or has used his 3 attempts
        if(Constants.loggedInMember?.profileStatusId == profileStatusType.finished.rawValue || Constants.loggedInMember?.isAttemptCompleted == true){
            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "profile_finished".localized, withNavigation: self)
            return
        }
        Utility.openWhatsapp(phoneNumber: btnConsultantNumber?.titleLabel?.text ?? Constants.phone, viewController: self)
    }
}
