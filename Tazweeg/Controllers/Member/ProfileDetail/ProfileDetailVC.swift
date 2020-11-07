//  MemberDetailVC.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 07/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.

import UIKit
import MOLH
import StoreKit //IAP

struct matchingsData {
    let sectionTitle: String
    let sectionRows : [Member]

    var numberOfItems: Int {
        return sectionRows.count
    }

    subscript(index: Int) -> Member {
        return sectionRows[index]
    }
}

//extension matchingsData {
//    //  Putting a new init method here means we can keep the original, memberwise initaliser.
//    init(title: String, rows: Member...) {
//        self.sectionTitle = title
//        self.sectionRows  = rows
//    }
//}

class ProfileDetailVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    //MARK: - IBOutlets
//    @IBOutlet weak var btnCallYourConsultant: WAButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnComments: WAButton!
    
    //    var memberID : Int?
    var memberDetail : Member?
    var choosings = [Member]()
    var matchings = [matchingsData]()
    var married = [Member]()
    //var matchingsSections = [String]()
    //MARK: - Custom Vars
    var memId = 0
    enum InfoType {
        case required
        case profile
        case choosing
        case matching
        case married
    }
    var infoType = InfoType.profile
    var profileInfoKeys = [String]()
    var profileInfoValues = [String]()
    var requiredInfoKeys = [String]()
    var requiredInfoValues = [String]()
    var toShowLimitedProfile : Bool = true
    private let refreshControl = UIRefreshControl() //Pull to refresh
    //placeholder reference to the IAP product you created
    var iAPProducts: [SKProduct] = []
    var btnEdit : UIBarButtonItem?
    var btnCallConsultant : UIBarButtonItem?
    var pageType:PageType = .profile

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        
        //hiding key board when tapped any where on the UI
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tap) )
        tapGestureReconizer.cancelsTouchesInView = false
        tblView.addGestureRecognizer(tapGestureReconizer)
        //Adding edit button at top right
        let rightImage = UIImage(named: "edit_icon")
        self.btnEdit = UIBarButtonItem(image: rightImage, landscapeImagePhone: rightImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(editTapped))
        self.btnEdit?.tintColor = UIColor(hexString: appColors.defaultColor.rawValue)
        self.navigationItem.rightBarButtonItem = self.btnEdit
        
        self.navigationItem.title = "complete_profile".localized
        //Setting up uisegment control
        self.segmentControl.setTitle("member_information".localized, forSegmentAt: 0)
        self.segmentControl.setTitle("required_information".localized, forSegmentAt: 1)
        self.segmentControl.setTitle("choosing".localized, forSegmentAt: 2)
        self.segmentControl.setTitle("matching".localized, forSegmentAt: 3)
        self.segmentControl.setTitle("married".localized, forSegmentAt: 4)
        
        //Changing font for different device
        if UIDevice.current.userInterfaceIdiom == .phone {
            if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
                let font = UIFont.systemFont(ofSize: 16)
                self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
            }else{
                let font = UIFont.systemFont(ofSize: 12)
                self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
            }
        }else{
            let font = UIFont.systemFont(ofSize: 26)
            self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        
        getMemberDetail(isRefresh: false)
        //Since iOS 10, the UITableView and UICollectionView classes have a refreshControl property.
        tblView.refreshControl = refreshControl
        // Configure Refresh Control / The action is triggered when the valueChanged event occurs, that is, when the user pulls and releases the table view.
        refreshControl.addTarget(self, action: #selector(refreshTableviewData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(hexString: appColors.defaultColor.rawValue)
        //Making tableview cell height dynamic
        tblView.estimatedRowHeight = 60.0
        tblView.rowHeight = UITableViewAutomaticDimension
        //Adding notification of iAP
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
        if (infoType == .matching){ //Coming from Profile to check the matching
            self.segmentControl.selectedSegmentIndex = 2
            self.segmentControl.sendActions(for: UIControlEvents.valueChanged)
        }
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        //applying theme
//        btnCallYourConsultant.borderColor = UIColor(hexString: appColors.whiteColor.rawValue)
//        btnCallYourConsultant.setTitleColor(UIColor(hexString: appColors.defaultColor.rawValue), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //**************************************************************
        //this loads the in app products which is only 1 so far
        //**************************************************************
        if (self.iAPProducts.count == 0){
            iAPProduct.store.requestProducts{ [weak self] success, products in
                guard let self = self else { return }
                if success {
                    self.iAPProducts = products!
                }
            }
        }
        //changing selected index of uisegmentcontrol and uitabbar to the right one
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
            self.btnComments.isHidden = true //hiding button consultants comments
            if (pageType == .profile){
                self.navigationItem.title = "profile".localized
                //cant hide any segment, so making it width very small and disabling it
                self.segmentControl.setWidth(0.01, forSegmentAt: 2)
                self.segmentControl.setEnabled(false, forSegmentAt: 2)
                
                self.segmentControl.setWidth(0.01, forSegmentAt: 3)
                self.segmentControl.setEnabled(false, forSegmentAt: 3)
                
                self.segmentControl.setWidth(0.01, forSegmentAt: 4)
                self.segmentControl.setEnabled(false, forSegmentAt: 4)
                
                //Making 1st segment (profile) selected by default
                self.segmentControl.selectedSegmentIndex = 0
                self.segmentControl.sendActions(for: UIControlEvents.valueChanged)
                
            }else if(pageType == .choosings){
                self.navigationItem.title = "matchings".localized
                //cant hide any segment, so making it width very small and disabling it
                self.segmentControl.setWidth(0.01, forSegmentAt: 0)
                self.segmentControl.setEnabled(false, forSegmentAt: 0)
                
                self.segmentControl.setWidth(0.01, forSegmentAt: 1)
                self.segmentControl.setEnabled(false, forSegmentAt: 1)
                //Making 3rd segment (choosing) selected by default
                self.segmentControl.selectedSegmentIndex = 2
                self.segmentControl.sendActions(for: UIControlEvents.valueChanged)
            }
        }else if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue ||
            Constants.loggedInMember?.userId == memberDetail?.consultantId){ //only admin or member's on consultant can see comment button
            self.btnComments.isHidden = false
        }else{
            self.btnComments.isHidden = true
        }
        //If current user is a member and he is using his own profile then make it consistent else dont persist
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue &&
            Constants.loggedInMember?.userId == self.memberDetail?.userId){//Member
//            print(self.memberDetail?.attempts as Any)
            self.memberDetail = Utility.getLoggedInMember() //Reloading MemberDetails because since we have introduce bottom navigation bar , if user has refreshed its data at profile tab, and then comes to matchings tab , at matching tab user must say latest data which was stored in UserDefaults. so re loading it. this is particularly was required to implement blue line linkage with the number of refusals.
//            print(self.memberDetail?.attempts as Any)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
//        btnCallYourConsultant.cornerRadius = btnCallYourConsultant.frame.height/2
        btnComments.cornerRadius = btnComments.frame.height/2
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
//     // or use
//     noteTextView.resignFirstResponder()
//     // or use
//     view.super().endEditing(true)
//     // or use
//     view.keyboardDismissMode = .onDrag
    }
    
    //****************************************************************
    //This method is called when there is a successful purchase of iAP
    //****************************************************************
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard
            let productID = notification.object as? String,
            let index = iAPProducts.index(where: { product -> Bool in
                product.productIdentifier == productID
            })
            else { return }
        if (index >= 0){
            getChoosingsMatchingsMarried(isRefresh: false) //Refreshing non silently
        }else{
            //hide the busy cursor
        }
    }
    
    @objc private func refreshTableviewData(_ sender: Any) {
        // Fetch tableview Data
        if infoType == .profile || infoType == .required {
            getMemberDetail(isRefresh: true)
        } else if infoType == .choosing || infoType == .matching || infoType == .married {
            getChoosingsMatchingsMarried(isRefresh: true)
        }
        else   {
            self.refreshControl.endRefreshing()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- custom Methods
    @objc func backTap(_ btn: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getMemberDetail(isRefresh : Bool){
        if let memberId = memberDetail?.userId{
            var dic = Dictionary<String,AnyObject>()
            dic["memberId"] = memberId as AnyObject
            //If loggedin member is a consultant, and he is viewing the profile of his own member then send consultant ID
            if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue  && Constants.loggedInMember?.userId == memberDetail?.consultantId){ //
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
//            print(dic)
            ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiGetMemberDetails, success: { (response) in
//                print(response)
                if (isRefresh){
                    self.refreshControl.endRefreshing()
                }else{
                    Utility.shared.hideSpinner()
                }
                if let status = response["Status"] as? Int {
                    if status == 1 {
                        if let data = response["User"] as? Dictionary<String,AnyObject> {
                            //To store a custom object into userdefaults you have to encode it
                            let tempMember : Member = Member.init(fromDictionary: data)
                            self.memberDetail = tempMember
                            //To store latest object into userdefaults, so that if member want to edit, it should have latest values
                            //If current user is a member and he is using his own profile then make it consistent else dont persist
                            if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue &&
                                Constants.loggedInMember?.userId == self.memberDetail?.userId){//Memberrr
                                let userArchivedData = NSKeyedArchiver.archivedData(withRootObject: tempMember )
                                UserDefaults.standard.set(userArchivedData, forKey: "LoggedInUser") //Saving full user into shared preferences
                                Constants.loggedInMember = Utility.getLoggedInMember()
                                print(self.memberDetail?.attempts as Any)
                            }
                            //If user want to see his own profile OR consultant want to see his own members profile OR logged in user is an Admin
                            if (    Constants.loggedInMember?.userId == self.memberDetail?.userId ||
                                    Constants.loggedInMember?.userId == self.memberDetail?.consultantId ||
                                    Constants.loggedInMember?.typeId == UserType.admin.rawValue
                                ){
                                self.segmentControl.isHidden = false
                                self.toShowLimitedProfile = false
                                
                            }else{
                                self.segmentControl.isHidden = true
                                self.toShowLimitedProfile = true
                                self.navigationItem.rightBarButtonItem = nil //hiding
                            }
                            self.populateProfileAndRequiredArrays()
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
    
    func populateProfileAndRequiredArrays() {
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
            if (pageType == .profile){
                if let genderID = self.memberDetail?.genderId{
                    if (toShowLimitedProfile){  //show gender icon to the right side
                        if (genderID == genderType.female.rawValue){
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: UIImageView(image: UIImage(named: "female")))
                        }else{
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: UIImageView(image: UIImage(named: "male")))
                        }
                        
                    }else{  //if not showing limited profile then she gnder icon to the left
                        if (genderID == genderType.female.rawValue){
                            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: UIImageView(image: UIImage(named: "female")))
                        }else{
                            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: UIImageView(image: UIImage(named: "male")))
                        }
                    }
                }
            }else if (pageType == .choosings){
                //Adding edit button at top left, right side already have edit button
                let leftImage = UIImage(named: "call_icon")
                self.btnCallConsultant = UIBarButtonItem(image: leftImage, landscapeImagePhone: leftImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnCallYourConsultantTapped))
                self.btnCallConsultant?.tintColor = UIColor(hexString: appColors.defaultColor.rawValue)
                self.navigationItem.leftBarButtonItem = self.btnCallConsultant
            }
        }
        //Clearing the old entries if any (it wil have entries after pull to down refresh)
        profileInfoKeys.removeAll()
        profileInfoValues.removeAll()
        requiredInfoKeys.removeAll()
        requiredInfoValues.removeAll()
        
        profileInfoKeys.append("username".localized)
        profileInfoValues.append(self.memberDetail?.code ?? "notAvailable".localized )
        
        //this information can only be seen by consultant of his own member and if current user is looking at his own profile
        if (!toShowLimitedProfile){
            profileInfoKeys.append("fullName".localized)
            profileInfoValues.append(self.memberDetail?.fullName ?? "notAvailable".localized )

            profileInfoKeys.append("phone".localized)
            profileInfoValues.append(self.memberDetail?.phone?.stringValue ?? "notAvailable".localized )

            profileInfoKeys.append("email".localized)
            profileInfoValues.append(self.memberDetail?.email ?? "notAvailable".localized )

            //Emirates ID Number
            profileInfoKeys.append("emirateId".localized)
            profileInfoValues.append(self.memberDetail?.emiratesIdNumber ?? "notAvailable".localized )
        }
        //Tribe can only be seen by consultants/Admin and a member of his/her own.
        if (    UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
                UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue ||
                Constants.loggedInMember?.userId == self.memberDetail?.userId ||
                self.memberDetail?.isFamilyShow == true
            ){
            profileInfoKeys.append("family".localized)
            profileInfoValues.append(self.memberDetail?.family ?? "notAvailable".localized )
            
            profileInfoKeys.append("family_name_to_show".localized)
            profileInfoValues.append(self.memberDetail?.isFamilyShow == true ? "yes".localized : "no".localized )
        }
        //this information can only be seen by consultant of his own member and if current user is looking at his own profile
        if (!toShowLimitedProfile){
            profileInfoKeys.append("birthPlace".localized)
            profileInfoValues.append(self.memberDetail?.birthPlace ?? "notAvailable".localized )
        }
        
        if let dob = self.memberDetail?.birthDate{
            profileInfoKeys.append("age".localized)
//            let age = Utility.calculateAge(date: dob)
//            profileInfoValues.append( String(age) )
            let ageComponents = Utility.calculateAge(date: dob)
            let completeAge : String =  String(ageComponents.year ?? 0) + " " + "years".localized + ", "
                                        + String(ageComponents.month ?? 0) + " "  + "months".localized + " & "
                                        + String(ageComponents.day ?? 0) + " "  + "days".localized
//                \(ageComponents.year ?? 0)" + "years".localized, \(ageComponents.month ?? 0)," + "months".localized, \(ageComponents.day ?? 0)" + "days".localized

            profileInfoValues.append(completeAge )
            
        }else{
            profileInfoKeys.append("age".localized)
            profileInfoValues.append("notAvailable".localized  )
        }

        //this information can only be seen by consultant of his own member and if current user is looking at his own profile
        if (!toShowLimitedProfile){
            profileInfoKeys.append("address".localized)
            profileInfoValues.append(self.memberDetail?.address ?? "notAvailable".localized )
        }

        if MOLHLanguage.isRTLLanguage() {
            //Step 1
            profileInfoKeys.append("country".localized)
            profileInfoValues.append(self.memberDetail?.countryAR ?? "notAvailable".localized )
            
            profileInfoKeys.append("state".localized)
            profileInfoValues.append(self.memberDetail?.stateAR ?? "notAvailable".localized )
            
            profileInfoKeys.append("residence".localized)
            profileInfoValues.append(self.memberDetail?.residenceTypeAR ?? "notAvailable".localized )
            //Consultant and Admin can see the ethnicity only
            if (UserDefaults.standard.integer(forKey: "currentUser") != UserType.member.rawValue){
                profileInfoKeys.append("ethnicity".localized)
                profileInfoValues.append(self.memberDetail?.ethnicityAR ?? "notAvailable".localized )
            }
            profileInfoKeys.append("motherNationality".localized)
            profileInfoValues.append(self.memberDetail?.motherNationalityAR ?? "notAvailable".localized )
            
            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                //Showing this field on step 2 only for females
                if(self.memberDetail?.genderId == genderType.female.rawValue){
                    profileInfoKeys.append("accepting_polygamy".localized)
                    profileInfoValues.append(self.memberDetail?.isPolygamy == true ? "yes".localized : "no".localized )
                    if (self.memberDetail?.isPolygamy == false){
                        profileInfoKeys.append("brideArrangment".localized)
                        profileInfoValues.append(self.memberDetail?.sBrideArrangmentAR ?? "notAvailable".localized )
                    }
                }
                profileInfoKeys.append("gender".localized)
                profileInfoValues.append(self.memberDetail?.genderAR ?? "notAvailable".localized )
                ////Step 2
                profileInfoKeys.append("isSmoke".localized)
                profileInfoValues.append(self.memberDetail?.isSmokeAR ?? "notAvailable".localized )
            }
            
            profileInfoKeys.append("skinColor".localized)
            profileInfoValues.append(self.memberDetail?.skinColorAR ?? "notAvailable".localized )

            profileInfoKeys.append("hairColor".localized)
            profileInfoValues.append(self.memberDetail?.hairColorAR ?? "notAvailable".localized )

            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                profileInfoKeys.append("hairType".localized)
                profileInfoValues.append(self.memberDetail?.hairTypeAR ?? "notAvailable".localized )

                profileInfoKeys.append("eyeColor".localized)
                profileInfoValues.append(self.memberDetail?.eyeColorAR ?? "notAvailable".localized )
            }

            profileInfoKeys.append("height".localized)
            profileInfoValues.append(self.memberDetail?.heightAR ?? "notAvailable".localized )
            
            profileInfoKeys.append("bodyType".localized)
            profileInfoValues.append(self.memberDetail?.bodyTypeAR ?? "notAvailable".localized )

            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                profileInfoKeys.append("bodyWeight".localized)
                profileInfoValues.append(self.memberDetail?.bodyWeightAR ?? "notAvailable".localized )

                profileInfoKeys.append("sect".localized)
                profileInfoValues.append(self.memberDetail?.sectAR ?? "notAvailable".localized )
                
                //Showing this field on step 2 only for females
                if(self.memberDetail?.genderId == genderType.female.rawValue){
                    profileInfoKeys.append("condemnBride".localized)
                    profileInfoValues.append(self.memberDetail?.sVeilAR ?? "notAvailable".localized )
                }
            }
            
            profileInfoKeys.append("drivingLicense".localized)
            profileInfoValues.append(self.memberDetail?.licenseIdAR ?? "notAvailable".localized )
            
            profileInfoKeys.append("educationLevel".localized)
            profileInfoValues.append(self.memberDetail?.educationLevelAR ?? "notAvailable".localized )
            
            //Step 3
            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                

                profileInfoKeys.append("religionCommitment".localized)
                profileInfoValues.append(self.memberDetail?.religionCommitmentAR ?? "notAvailable".localized )

                profileInfoKeys.append("financialStatus".localized)
                profileInfoValues.append(self.memberDetail?.financialStatusAR ?? "notAvailable".localized )
            }
            profileInfoKeys.append("socialStatus".localized)
            profileInfoValues.append(self.memberDetail?.socialStatusAR ?? "notAvailable".localized )

            profileInfoKeys.append("isWorking".localized)
            profileInfoValues.append(self.memberDetail?.isWorkingAR ?? "notAvailable".localized )

            profileInfoKeys.append("isDisease".localized)
            profileInfoValues.append(self.memberDetail?.isDiseaseAR ?? "notAvailable".localized )

            profileInfoKeys.append("diseaseName".localized)
            profileInfoValues.append(self.memberDetail?.diseaseName ?? "notAvailable".localized )
            
            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                //If social status is not equal to single then ask or haschildren, numberOfChildren and reproductions
                if (self.memberDetail?.socialStatusId != nil && self.memberDetail?.socialStatusId != socialStatusCode.single.rawValue){
                    profileInfoKeys.append("hasChildren".localized)
                    profileInfoValues.append(self.memberDetail?.hasChildIdAR ?? "notAvailable".localized )
                    if ( self.memberDetail?.hasChildId != nil ){
                        //If member has childs then ask for number of child else ask for reproduction
                        if (self.memberDetail?.hasChildId == isSmokingCode.yes.rawValue){
                            profileInfoKeys.append("noOfChildren".localized)
                            profileInfoValues.append(self.memberDetail?.numberOfChildrenIdAR ?? "notAvailable".localized )
                        }else{
                            profileInfoKeys.append("reproductionStatus".localized) //Is Working
                            profileInfoValues.append(self.memberDetail?.reproductionIdAR ?? "notAvailable".localized )
                        }
                    }
                }
                //if a person is not working then hide its occupation , jobtype and jobTitle
                if (self.memberDetail?.isWorkingId != nil && self.memberDetail?.isWorkingId == isWorkingCode.working.rawValue){
                    profileInfoKeys.append("occuption".localized)
                    profileInfoValues.append(self.memberDetail?.occupation ?? "notAvailable".localized )

                    profileInfoKeys.append("jobType".localized)
                    profileInfoValues.append(self.memberDetail?.jobTypeAR ?? "notAvailable".localized )

                    profileInfoKeys.append("jobTitle".localized)
                    profileInfoValues.append(self.memberDetail?.jobTitle ?? "notAvailable".localized )
                }
                profileInfoKeys.append("annualIncome".localized)
                profileInfoValues.append(self.memberDetail?.annualIncomeAR ?? "notAvailable".localized )

                // Step 4
                //Showing this field on step 4 only for males
                if(self.memberDetail?.genderId == genderType.male.rawValue){
                    requiredInfoKeys.append("brideArrangment".localized)
                    requiredInfoValues.append(self.memberDetail?.sBrideArrangmentAR ?? "notAvailable".localized )
                }
                
                requiredInfoKeys.append("willMarryInGCC".localized)
                if (self.memberDetail?.GCCMarriage == true){
                    requiredInfoValues.append("yes".localized)
                }else{
                    requiredInfoValues.append("no".localized)
                }
                
                if (self.memberDetail?.GCCMarriage == false){
                    requiredInfoKeys.append("country".localized)
                    requiredInfoValues.append(self.memberDetail?.sCountryAR ?? "notAvailable".localized )
                }
                
                requiredInfoKeys.append(self.memberDetail?.genderId == genderType.male.rawValue ?  "male_social_status_check".localized : "female_social_status_check".localized )
                if (self.memberDetail?.acceptDMW == true){
                    requiredInfoValues.append("yes".localized)
                }else{
                    requiredInfoValues.append("no".localized)
                }
                if (self.memberDetail?.acceptDMW == false){
                    requiredInfoKeys.append("socialStatus".localized)
                    requiredInfoValues.append(self.memberDetail?.sSocialStatusAR ?? "notAvailable".localized )
                }
                //If social status is not equal to single then ask or haschildren, numberOfChildren and reproductions
                if (self.memberDetail?.sSocialStatusId != nil && self.memberDetail?.sSocialStatusId != socialStatusCode.single.rawValue){
                    requiredInfoKeys.append("hasChildren".localized)
                    requiredInfoValues.append(self.memberDetail?.sHasChildIdAR ?? "notAvailable".localized )
                    if (self.memberDetail?.sHasChildId != nil){
                        //If member has childs then ask for number of child else ask for reproduction
                        if (self.memberDetail?.sHasChildId == isSmokingCode.yes.rawValue){
                            requiredInfoKeys.append("noOfChildren".localized)
                            requiredInfoValues.append(self.memberDetail?.sNoOfChildrenAR ?? "notAvailable".localized )
                        }else{
                            requiredInfoKeys.append("reproductionStatus".localized)
                            requiredInfoValues.append(self.memberDetail?.sReproductionAR ?? "notAvailable".localized )
                        }
                    }
                }
                requiredInfoKeys.append("age".localized)
                requiredInfoValues.append(self.memberDetail?.sAgeAR ?? "notAvailable".localized )

                requiredInfoKeys.append("height".localized)
                requiredInfoValues.append(self.memberDetail?.sHeightAR ?? "notAvailable".localized )

                requiredInfoKeys.append("bodyType".localized)
                requiredInfoValues.append(self.memberDetail?.sBodyTypeAR ?? "notAvailable".localized )

    //            requiredInfoKeys.append("skin".localized) //Skin Type
    //            requiredInfoValues.append(self.memberDetail?.sSkinAR ?? "notAvailable".localized )

                requiredInfoKeys.append("skinColor".localized)
                requiredInfoValues.append(self.memberDetail?.sSkinColorAR ?? "notAvailable".localized )

                requiredInfoKeys.append("educationLevel".localized)
                requiredInfoValues.append(self.memberDetail?.sEducationLevelAR ?? "notAvailable".localized )

                requiredInfoKeys.append("isWorking".localized)
                requiredInfoValues.append(self.memberDetail?.sIsWorkingAR ?? "notAvailable".localized )
                
                //if a person is not working then hide its jobtype
                if (self.memberDetail?.sIsWorkingId != nil && self.memberDetail?.sIsWorkingId == isWorkingCode.working.rawValue){
                    requiredInfoKeys.append("jobType".localized)
                    requiredInfoValues.append(self.memberDetail?.sJobTypeAR ?? "notAvailable".localized )
                }
                requiredInfoKeys.append("requiredState".localized)
                requiredInfoValues.append(self.memberDetail?.spouseStateToLiveAR ?? "notAvailable".localized )
            }
            //Showing this field on step 4 only for males
            if(self.memberDetail?.genderId == genderType.male.rawValue){
                requiredInfoKeys.append("condemnBride".localized)
                requiredInfoValues.append(self.memberDetail?.sVeilAR ?? "notAvailable".localized )
            }
            requiredInfoKeys.append("drivingLicense".localized)
            requiredInfoValues.append(self.memberDetail?.sDrivingLicenseAR ?? "notAvailable".localized )

            requiredInfoKeys.append("has_person_refer".localized)
            print(self.memberDetail?.nameRefer as Any)
            if (self.memberDetail?.nameRefer != nil){
                requiredInfoValues.append("yes".localized)
                requiredInfoKeys.append("refer_name".localized)
                requiredInfoValues.append(self.memberDetail?.nameRefer ?? "notAvailable".localized )
                
                requiredInfoKeys.append("refer_number".localized)
                requiredInfoValues.append(self.memberDetail?.mobileRefer ?? "notAvailable".localized )
            }else{
                requiredInfoValues.append("no".localized)
            }
            
            
            
            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                //Showing this field on step 4 only for males
                if(self.memberDetail?.genderId == genderType.male.rawValue){
                    requiredInfoKeys.append("willPayToBride".localized)
                    requiredInfoValues.append(self.memberDetail?.willPayToBrideAR ?? "notAvailable".localized )
                }
                //Step 5
                profileInfoKeys.append("firstRelative".localized)
                profileInfoValues.append(self.memberDetail?.firstRelative ?? "notAvailable".localized )

                profileInfoKeys.append("firstRelativeNumber".localized)
                profileInfoValues.append(self.memberDetail?.firstRelativeNumber ?? "notAvailable".localized )

                profileInfoKeys.append("firstRelativeRelation".localized)
                profileInfoValues.append(self.memberDetail?.firstRelativeRelationAR ?? "notAvailable".localized )

                profileInfoKeys.append("secondRelative".localized)
                profileInfoValues.append(self.memberDetail?.secondRelative ?? "notAvailable".localized )

                profileInfoKeys.append("secondRelativeNumber".localized)
                profileInfoValues.append(self.memberDetail?.secondRelativeNumber ?? "notAvailable".localized )

                profileInfoKeys.append("secondRelativeRelation".localized)
                profileInfoValues.append(self.memberDetail?.secondRelativeRelationAR ?? "notAvailable".localized )

                profileInfoKeys.append("applicantDescription".localized)
                profileInfoValues.append(self.memberDetail?.applicantDescription ?? "notAvailable".localized )

                //Extra
                profileInfoKeys.append("paymentStatus".localized)
                profileInfoValues.append(self.memberDetail?.profileStatusAR ?? "notAvailable".localized )
            }
        }else{ //ENGLISH
            //Step 1
            profileInfoKeys.append("country".localized)
            profileInfoValues.append(self.memberDetail?.countryEN ?? "notAvailable".localized )

            profileInfoKeys.append("state".localized)
            profileInfoValues.append(self.memberDetail?.stateEN ?? "notAvailable".localized )
            
            profileInfoKeys.append("residence".localized)
            profileInfoValues.append(self.memberDetail?.residenceTypeEN ?? "notAvailable".localized )
            //Consultant and Admin can see the ethnicity only
            if (UserDefaults.standard.integer(forKey: "currentUser") != UserType.member.rawValue){
                profileInfoKeys.append("ethnicity".localized)
                profileInfoValues.append(self.memberDetail?.ethnicityEN ?? "notAvailable".localized )
            }
            profileInfoKeys.append("motherNationality".localized)
            profileInfoValues.append(self.memberDetail?.motherNationalityEN ?? "notAvailable".localized )
            
            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                profileInfoKeys.append("gender".localized)
                profileInfoValues.append(self.memberDetail?.genderEN ?? "notAvailable".localized )
                
                //Showing this field on step 2 only for females
                if(self.memberDetail?.genderId == genderType.female.rawValue){
                    profileInfoKeys.append("accepting_polygamy".localized)
                    profileInfoValues.append(self.memberDetail?.isPolygamy == true ? "yes".localized : "no".localized )
                    if (self.memberDetail?.isPolygamy == false){
                        profileInfoKeys.append("brideArrangment".localized)
                        profileInfoValues.append(self.memberDetail?.sBrideArrangmentEN ?? "notAvailable".localized )
                    }
                }
                //Step 2
                profileInfoKeys.append("isSmoke".localized)
                profileInfoValues.append(self.memberDetail?.isSmokeEN ?? "notAvailable".localized )
                
            }
            profileInfoKeys.append("skinColor".localized)
            profileInfoValues.append(self.memberDetail?.skinColorEN ?? "notAvailable".localized )

            profileInfoKeys.append("hairColor".localized)
            profileInfoValues.append(self.memberDetail?.hairColorEN ?? "notAvailable".localized )

            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                profileInfoKeys.append("hairType".localized)
                profileInfoValues.append(self.memberDetail?.hairTypeEN ?? "notAvailable".localized )

                profileInfoKeys.append("eyeColor".localized)
                profileInfoValues.append(self.memberDetail?.eyeColorEN ?? "notAvailable".localized )
            }

            profileInfoKeys.append("height".localized)
            profileInfoValues.append(self.memberDetail?.heightEN ?? "notAvailable".localized )
            
            profileInfoKeys.append("bodyType".localized)
            profileInfoValues.append(self.memberDetail?.bodyTypeEN ?? "notAvailable".localized )
            
            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                profileInfoKeys.append("bodyWeight".localized)
                profileInfoValues.append(self.memberDetail?.bodyWeightEN ?? "notAvailable".localized )
                
                profileInfoKeys.append("sect".localized)
                profileInfoValues.append(self.memberDetail?.sectEN ?? "notAvailable".localized )
                
                //Showing this field on step 2 only for females
                if(self.memberDetail?.genderId == genderType.female.rawValue){
                    profileInfoKeys.append("condemnBride".localized)
                    profileInfoValues.append(self.memberDetail?.sVeilEN ?? "notAvailable".localized )
                }
            }
            profileInfoKeys.append("drivingLicense".localized)
            profileInfoValues.append(self.memberDetail?.licenseIdEN ?? "notAvailable".localized )
            //Step 3
            profileInfoKeys.append("educationLevel".localized)
            profileInfoValues.append(self.memberDetail?.educationLevelEN ?? "notAvailable".localized )

            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                profileInfoKeys.append("religionCommitment".localized)
                profileInfoValues.append(self.memberDetail?.religionCommitmentEN ?? "notAvailable".localized )

                profileInfoKeys.append("financialStatus".localized)
                profileInfoValues.append(self.memberDetail?.financialStatusEN ?? "notAvailable".localized )
            }

            profileInfoKeys.append("socialStatus".localized)
            profileInfoValues.append(self.memberDetail?.socialStatusEN ?? "notAvailable".localized )

            profileInfoKeys.append("isWorking".localized)
            profileInfoValues.append(self.memberDetail?.isWorkingEN ?? "notAvailable".localized )

            profileInfoKeys.append("isDisease".localized)
            profileInfoValues.append(self.memberDetail?.isDiseaseEN ?? "notAvailable".localized )

            profileInfoKeys.append("diseaseName".localized)
            profileInfoValues.append(( self.memberDetail?.diseaseName ) ?? "notAvailable".localized )
            
            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                //If social status is not equal to single then ask or haschildren, numberOfChildren and reproductions
                if (self.memberDetail?.socialStatusId != nil && self.memberDetail?.socialStatusId != socialStatusCode.single.rawValue){
                    profileInfoKeys.append("hasChildren".localized)
                    profileInfoValues.append(self.memberDetail?.hasChildIdEN ?? "notAvailable".localized )
                    if ( self.memberDetail?.hasChildId != nil ){
                        //If member has childs then ask for number of child else ask for reproduction
                        if (self.memberDetail?.hasChildId == isSmokingCode.yes.rawValue){
                            profileInfoKeys.append("noOfChildren".localized)
                            profileInfoValues.append(self.memberDetail?.numberOfChildrenIdEN ?? "notAvailable".localized )
                        }else{
                            profileInfoKeys.append("reproductionStatus".localized)
                            profileInfoValues.append(self.memberDetail?.reproductionIdEN ?? "notAvailable".localized )
                        }
                    }
                }
                //if a person is not working then hide its occupation , jobtype and jobTitle
                if (self.memberDetail?.isWorkingId != nil && self.memberDetail?.isWorkingId == isWorkingCode.working.rawValue){
                    profileInfoKeys.append("occuption".localized)
                    profileInfoValues.append(self.memberDetail?.occupation ?? "notAvailable".localized )

                    profileInfoKeys.append("jobType".localized)
                    profileInfoValues.append(self.memberDetail?.jobTypeEN ?? "notAvailable".localized )

                    profileInfoKeys.append("jobTitle".localized)
                    profileInfoValues.append(self.memberDetail?.jobTitle ?? "notAvailable".localized )
                }
                profileInfoKeys.append("annualIncome".localized)
                profileInfoValues.append(self.memberDetail?.annualIncomeEN ?? "notAvailable".localized )

                // Step 4
                //Showing this field on step 4 only for males
                if(self.memberDetail?.genderId == genderType.male.rawValue){
                    requiredInfoKeys.append("brideArrangment".localized)
                    requiredInfoValues.append(self.memberDetail?.sBrideArrangmentEN ?? "notAvailable".localized )
                }
                requiredInfoKeys.append("willMarryInGCC".localized)
                if (self.memberDetail?.GCCMarriage == true){
                    requiredInfoValues.append("yes".localized)
                }else{
                    requiredInfoValues.append("no".localized)
                }
                if (self.memberDetail?.GCCMarriage == false){
                    requiredInfoKeys.append("country".localized)
                    requiredInfoValues.append(self.memberDetail?.sCountryEN ?? "notAvailable".localized )
                }
                
                requiredInfoKeys.append(self.memberDetail?.genderId == genderType.male.rawValue ?  "male_social_status_check".localized : "female_social_status_check".localized )
                if (self.memberDetail?.acceptDMW == true){
                    requiredInfoValues.append("yes".localized)
                }else{
                    requiredInfoValues.append("no".localized)
                }
                if (self.memberDetail?.acceptDMW == false){
                    requiredInfoKeys.append("socialStatus".localized)
                    requiredInfoValues.append(self.memberDetail?.sSocialStatusEN ?? "notAvailable".localized )
                }
                //If social status is not equal to single then ask or haschildren, numberOfChildren and reproductions
                if (self.memberDetail?.sSocialStatusId != nil && self.memberDetail?.sSocialStatusId != socialStatusCode.single.rawValue){
                    requiredInfoKeys.append("hasChildren".localized)
                    requiredInfoValues.append(self.memberDetail?.sHasChildIdEN ?? "notAvailable".localized )
                    //If member has childs then ask for number of child else ask for reproduction
                    if (self.memberDetail?.sHasChildId == isSmokingCode.yes.rawValue){
                        requiredInfoKeys.append("noOfChildren".localized)
                        requiredInfoValues.append(self.memberDetail?.sNoOfChildrenEN ?? "notAvailable".localized )
                    }else{
                        requiredInfoKeys.append("reproductionStatus".localized)
                        requiredInfoValues.append(self.memberDetail?.sReproductionEN ?? "notAvailable".localized )
                    }
                }
                
                requiredInfoKeys.append("age".localized)
                requiredInfoValues.append(self.memberDetail?.sAgeEN ?? "notAvailable".localized )

                requiredInfoKeys.append("height".localized)
                requiredInfoValues.append(self.memberDetail?.sHeightEN ?? "notAvailable".localized )

                requiredInfoKeys.append("bodyType".localized)
                requiredInfoValues.append(self.memberDetail?.sBodyTypeEN ?? "notAvailable".localized )

    //            requiredInfoKeys.append("skin".localized)   //Skin Type
    //            requiredInfoValues.append(self.memberDetail?.sSkinEN ?? "notAvailable".localized )

                requiredInfoKeys.append("skinColor".localized)
                requiredInfoValues.append(self.memberDetail?.sSkinColorEN ?? "notAvailable".localized )

                requiredInfoKeys.append("educationLevel".localized)
                requiredInfoValues.append(self.memberDetail?.sEducationLevelEN ?? "notAvailable".localized )

                requiredInfoKeys.append("isWorking".localized)
                requiredInfoValues.append(self.memberDetail?.sIsWorkingEN ?? "notAvailable".localized )
                
                //if a person is not working then hide its jobtype
                if (self.memberDetail?.sIsWorkingId != nil && self.memberDetail?.sIsWorkingId == isWorkingCode.working.rawValue){
                    requiredInfoKeys.append("jobType".localized)
                    requiredInfoValues.append(self.memberDetail?.sJobTypeEN ?? "notAvailable".localized )
                }
                requiredInfoKeys.append("requiredState".localized)
                requiredInfoValues.append(self.memberDetail?.spouseStateToLiveEN ?? "notAvailable".localized )
                
                
            }
            //Showing this field on step 4 only for males
            if(self.memberDetail?.genderId == genderType.male.rawValue){
                requiredInfoKeys.append("condemnBride".localized)
                requiredInfoValues.append(self.memberDetail?.sVeilEN ?? "notAvailable".localized )
            }
            requiredInfoKeys.append("drivingLicense".localized)
            requiredInfoValues.append(self.memberDetail?.sDrivingLicenseEN ?? "notAvailable".localized )
            
            requiredInfoKeys.append("has_person_refer".localized)
            print(self.memberDetail?.nameRefer as Any)
            if (self.memberDetail?.nameRefer != nil){
                requiredInfoValues.append("yes".localized)
                requiredInfoKeys.append("refer_name".localized)
                requiredInfoValues.append(self.memberDetail?.nameRefer ?? "notAvailable".localized )
                
                requiredInfoKeys.append("refer_number".localized)
                requiredInfoValues.append(self.memberDetail?.mobileRefer ?? "notAvailable".localized )
            }else{
                requiredInfoValues.append("no".localized)
            }
            
            //this information can only be seen by consultant of his own member and if current user is looking at his own profile
            if (!toShowLimitedProfile){
                //Showing this field on step 4 only for males
                if(self.memberDetail?.genderId == genderType.male.rawValue){
                    requiredInfoKeys.append("willPayToBride".localized)
                    requiredInfoValues.append(self.memberDetail?.willPayToBrideEN ?? "notAvailable".localized )
                }
                // Step 5
                profileInfoKeys.append("firstRelative".localized)
                profileInfoValues.append(self.memberDetail?.firstRelative ?? "notAvailable".localized )

                profileInfoKeys.append("firstRelativeNumber".localized)
                profileInfoValues.append(self.memberDetail?.firstRelativeNumber ?? "notAvailable".localized )

                profileInfoKeys.append("firstRelativeRelation".localized)
                profileInfoValues.append(self.memberDetail?.firstRelativeRelationEN ?? "notAvailable".localized )

                profileInfoKeys.append("secondRelative".localized)
                profileInfoValues.append(self.memberDetail?.secondRelative ?? "notAvailable".localized )

                profileInfoKeys.append("secondRelativeNumber".localized)
                profileInfoValues.append(self.memberDetail?.secondRelativeNumber ?? "notAvailable".localized )

                profileInfoKeys.append("secondRelativeRelation".localized)
                profileInfoValues.append(self.memberDetail?.secondRelativeRelationEN ?? "notAvailable".localized )

                profileInfoKeys.append("applicantDescription".localized)
                profileInfoValues.append(self.memberDetail?.applicantDescription ?? "notAvailable".localized )

                //Extra
                profileInfoKeys.append("paymentStatus".localized)
                profileInfoValues.append(self.memberDetail?.profileStatusEN ?? "notAvailable".localized )
            }
//
        }
        //Consultant and Admin can see the notes added by consultant or admin
        if (UserDefaults.standard.integer(forKey: "currentUser") != UserType.member.rawValue){
            profileInfoKeys.append("comments".localized)
            profileInfoValues.append(self.memberDetail?.ConsultantNote ?? "notAvailable".localized )
        }
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .profileDetailVC) as! ProfileDetailVC
        //keep this if else like this
        if infoType == .choosing && self.choosings.count > 0{
            let model = self.choosings[indexPath.row]
            viewController.memberDetail = model
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if infoType == .matching && matchings[indexPath.section].numberOfItems > 0 {
            let model = self.matchings[indexPath.section][indexPath.row]
            viewController.memberDetail = model
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if infoType == .married && self.married.count > 0{
            let model = self.married[indexPath.row]
            viewController.memberDetail = model
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        //commenting below line because we dont need to navigate to profileDetail when infoType is .profile or .required
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MemberDetailCell
        cell.viewSeperator.isHidden = true  //hidden for all , initially, later we will un hide
        
        if (profileInfoKeys.count != profileInfoValues.count || requiredInfoKeys.count != requiredInfoValues.count){
            print("Invalid Data Count")
        }
        if MOLHLanguage.isRTLLanguage() {
            cell.lblTitle.textAlignment = .right
            cell.lblDetails.textAlignment = .right
        }else{
            cell.lblTitle.textAlignment = .left
            cell.lblDetails.textAlignment = .left
        }

        if infoType == .profile  {
            cell.lblTitle.text = profileInfoKeys[indexPath.row]
            cell.lblDetails.text = profileInfoValues[indexPath.row]
            //Hiding UnHiding
            cell.lblSerialNumber.isHidden = true  //hide it if serial number is not required for this tab personal
            cell.lblDetails.isHidden = false //unhiding consultant name for personal and required tab
            cell.imgPhone.isHidden = true //hiding phone for personal and required tabs
        } else if infoType == .required{
            cell.lblTitle.text = requiredInfoKeys[indexPath.row]
            cell.lblDetails.text = requiredInfoValues[indexPath.row]
            //Hiding UnHiding
            cell.lblSerialNumber.isHidden = true  //hide it if serial number is not required for this tab required
            cell.lblDetails.isHidden = false //unhiding consultant name for personal and required tab
            cell.imgPhone.isHidden = true //hiding phone for personal and required tabs
        }else if infoType == .choosing && self.choosings.count > 0{
            //if (indexPath.row == 2){
            print(self.memberDetail?.attempts ?? 4)
            if (indexPath.row == (self.memberDetail?.attempts ?? 2) - 1){ //linking blue line with number of remaining attempts to match
                cell.viewSeperator.isHidden = false
            }else{
                cell.viewSeperator.isHidden = true
            }
            cell.lblSerialNumber.isHidden = false
            cell.lblSerialNumber.text = String(indexPath.row + 1)
            let model = self.choosings[indexPath.row]
            if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
                //Hide Consultant name and phone image for member
                cell.lblDetails.isHidden = true       // it will have consultant name
                cell.imgPhone.isHidden = true  // phone image
            }else{
                //Unhide all three title/val/image for consultant
                cell.lblDetails.isHidden = false       // it will have consultant name
                cell.imgPhone.isHidden = false  // phone image
            }
            cell.lblTitle.text = model.code
            cell.lblDetails.text = model.consultantName
            cell.tag = indexPath.row
            if let phoneNumber = model.cMobile{
                cell.lblConsultantNumber.text = phoneNumber.stringValue
            }
        }else if infoType == .matching && self.matchings[indexPath.section].numberOfItems > 0{
            let model = self.matchings[indexPath.section][indexPath.row]
            cell.lblSerialNumber.isHidden = false
            cell.lblSerialNumber.text = String(indexPath.row + 1)
            
            if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
                //Hide Consultant name and phone image for member
                cell.lblDetails.isHidden = true       // it will have consultant name
                cell.imgPhone.isHidden = true  // phone image
            }else{
                //Unhide all three title/val/image for consultant
                cell.lblDetails.isHidden = false       // it will have consultant name
                cell.imgPhone.isHidden = false  // phone image
            }
            cell.lblTitle.text = model.code
            cell.lblDetails.text = model.consultantName
            cell.tag = indexPath.row
            if let phoneNumber = model.cMobile{
                cell.lblConsultantNumber.text = phoneNumber.stringValue
            }
        }else if infoType == .married && self.married.count > 0{
            cell.lblSerialNumber.isHidden = false
            cell.lblSerialNumber.text = String(indexPath.row + 1)
            let model = self.married[indexPath.row]
            if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
                //Hide Consultant name and phone image for member
                cell.lblDetails.isHidden = true       // it will have consultant name
                cell.imgPhone.isHidden = true  // phone image
            }else{
                //Unhide all three title/val/image for consultant
                cell.lblDetails.isHidden = false       // it will have consultant name
                cell.imgPhone.isHidden = false  // phone image
            }
            cell.lblTitle.text = model.code
            cell.lblDetails.text = model.consultantName
            cell.tag = indexPath.row
            if let phoneNumber = model.cMobile{
                cell.lblConsultantNumber.text = phoneNumber.stringValue
            }
        }        
        //changing text color of key has_person_refer to red and rest to black
        //Highlighting has_person_refer,refer_name and refer_number
        if (cell.lblTitle.text?.elementsEqual("has_person_refer".localized) ?? false){
            cell.lblTitle.textColor = UIColor.red
            cell.lblDetails.textColor = UIColor.red
        }else{
            cell.lblTitle.textColor = UIColor.black
            cell.lblDetails.textColor = UIColor.black
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch self.segmentControl.selectedSegmentIndex
        {
            case 2:
                return true
            case 3:
                if UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue{ //disabling delete(refuse for member) for matching tab i.e. swipe left or right
                    return false
                }
                return true
//            case 4:   //married tab cant be edited i.e. swipe left or right
//                return true
            default:
                return false
        }
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if (infoType == .matching){
            return "refuse".localized
        }else{
            return "cancel".localized
        }
    }
    
    //******************************************************
    //Swiping left-to-right (when local language is english)
    //******************************************************
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        var swipeAction = UISwipeActionsConfiguration(actions: [])
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue || //consultant
            UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue){      //Admin
            if (infoType == .choosing || infoType == .matching){
                var swipedRecord = self.choosings[indexPath.row]
                var actionButtonTitle = "approve".localized
                if infoType == .matching{
                    swipedRecord = self.matchings[indexPath.section][indexPath.row]
                    actionButtonTitle = "finish".localized
                }
                //no swiping action required on right or left for married
    //            else if infoType == .married{}
                if self.infoType == .choosing{
                    let chooseAction = UIContextualAction(style: .normal, title: actionButtonTitle , handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                        // ***************************
                        // call Choosing web API here*
                        // ***************************
                        var dic = Dictionary<String,AnyObject>()
                        dic["userId"] = self.memberDetail?.userId as AnyObject
                        dic["id"] = swipedRecord.userId as AnyObject
                        dic["updateUserId"]  = Constants.loggedInMember?.userId as AnyObject
                        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
                        dic["appVersion"] = Utility.getAppVersion() as AnyObject
                        print(dic)
                        Utility.shared.showSpinner()
                        ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiSubmitMatching, success: { (response) in
                            print(response)
                            Utility.shared.hideSpinner()    //dont hide here as we are going to call an other webAPI to load matchings
                            if let status = response["Status"] as? Int {
                                if status == 1 {
                                    if let attempts = response["Attempts"] as? Int {    //take the fresh value of number of refuse/approve attempts of the user
                                        self.memberDetail?.attempts = attempts
                                    }
                                    self.segmentControl.selectedSegmentIndex = 3
                                    self.segmentControl.sendActions(for: UIControlEvents.valueChanged)
                                } else if status == 3 {
                                    Utility.logout()
                                } else if status == 5 {
                                    self.showToast(message: "approval_attempts_expired".localized, font: .systemFont(ofSize: 16))
                                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "approval_attempts_expired".localized, withNavigation: self)
                                } else {
                                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
                                }
                            }else {
                                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                            }
                        }) { (response) in
                            Utility.shared.hideSpinner()
                            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                        }
                    })
                    chooseAction.backgroundColor = UIColor(hexString: "#008000")//Green
                    swipeAction = UISwipeActionsConfiguration(actions: [chooseAction])
                }

                //if self.infoType == .matching && swipedRecord.matchStatusId != matchStatusType.refused.rawValue{  //no right swiping on refused record
                if self.infoType == .matching{
                    let chooseAction = UIContextualAction(style: .normal, title: actionButtonTitle , handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                        // ***************************
                        // call matching web API here*
                        // ***************************
                        var dic = Dictionary<String,AnyObject>()
                        dic["userId"] = self.memberDetail?.userId as AnyObject
                        dic["id"] = swipedRecord.userId as AnyObject
                        dic["updateUserId"]  = Constants.loggedInMember?.userId as AnyObject
                        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
                        dic["appVersion"] = Utility.getAppVersion() as AnyObject
//                        print(dic)
                        Utility.shared.showSpinner()
                        ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiApproveMatching, success: { (response) in
//                            print(response)
                            Utility.shared.hideSpinner()    //dont hide here as we are going to call an other webAPI to load matchings
                            if let status = response["Status"] as? Int {
                                if status == 1 {
                                    if let attempts = response["Attempts"] as? Int {    //take the fresh value of number of refuse/approve attempts of the user
                                        self.memberDetail?.attempts = attempts
                                    }
                                    self.segmentControl.selectedSegmentIndex = 4
                                    self.segmentControl.sendActions(for: UIControlEvents.valueChanged)
                                } else if status == 3 {
                                    Utility.logout()
                                }else if status == 6 {
                                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "marriage_attempts_expired".localized, withNavigation: self)
                                }
                                else {
                                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
                                }
                            }else {
                                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                            }
                        }) { (response) in
                            Utility.shared.hideSpinner()
                            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                        }
                    })
                    chooseAction.backgroundColor = UIColor(hexString: "#008000")//Green
                    swipeAction = UISwipeActionsConfiguration(actions: [chooseAction])
                }
            }
        }
        swipeAction.performsFirstActionWithFullSwipe = false // This is the line which disables full swipe
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            if (infoType == .choosing || infoType == .matching){
                var swipedRecord: Member?
                if infoType == .choosing{
                    swipedRecord = self.choosings[indexPath.row]
                }
                else if infoType == .matching{
                    swipedRecord = self.matchings[indexPath.section][indexPath.row]
                }
                if self.infoType == .choosing{
                    // ***************************
                    // call Choosing web API here*
                    // ***************************
                    var dic = Dictionary<String,AnyObject>()
                    dic["userId"] = memberDetail?.userId as AnyObject
                    dic["memberId"] = swipedRecord?.userId as AnyObject
                    dic["userUpdateId"]  = Constants.loggedInMember?.userId as AnyObject
                    dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
                    dic["appVersion"] = Utility.getAppVersion() as AnyObject
//                    print(dic)
                    Utility.shared.showSpinner()
                    ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiDeleteMatching, success: { (response) in
//                        print(response)
                        Utility.shared.hideSpinner()
                        if let status = response["Status"] as? Int {
                            if status == 1 {
                                self.choosings.remove(at: indexPath.row)
                                self.tblView.deleteRows(at: [indexPath], with: .fade)
                                self.tblView.reloadData()
                            } else if status == 3 {
                                Utility.logout()
                            } else {
                                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
                            }
                        }else {
                            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                        }
                    }) { (response) in
                        Utility.shared.hideSpinner()
                        Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                    }
                }else if self.infoType == .matching{
                    // ***************************
                    // call matching web API here*
                    // ***************************
                    var dic = Dictionary<String,AnyObject>()
                    dic["userId"] = self.memberDetail?.userId as AnyObject
                    dic["id"] = swipedRecord?.userId as AnyObject
                    dic["updateUserId"]  = Constants.loggedInMember?.userId as AnyObject
                    dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
                    dic["appVersion"] = Utility.getAppVersion() as AnyObject
//                    print(dic)
                    Utility.shared.showSpinner()
                    ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiRefuseMatching, success: { (response) in
//                        print(response)
                            Utility.shared.hideSpinner()    //dont hide here as we are going to call an other webAPI to load matchings
                        if let status = response["Status"] as? Int {
                            if status == 1 {
                                if let attempts = response["Attempts"] as? Int {    //take the fresh value of number of refuse/approve attempts of the user
                                    self.memberDetail?.attempts = attempts
                                }
                                self.loadChoosingMatchingsMarried(isRefresh: false)
                            } else if status == 3 {
                                Utility.logout()
                            } else {
                                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
                            }
                        }else {
                            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                        }
                    }) { (response) in
                        Utility.shared.hideSpinner()
                        Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(String(sourceIndexPath.row) + " to " + String(destinationIndexPath.row))
        let sourceObject = self.choosings[sourceIndexPath.row]
        let destinationObject = self.choosings[destinationIndexPath.row]
        var dic = Dictionary<String,AnyObject>()
        dic["userId"] = memberDetail?.userId as AnyObject
        dic["memberId"] = sourceObject.userId as AnyObject
        dic["priorityId"] = destinationIndexPath.row + 1  as AnyObject
        dic["memberIdShift"] = destinationObject.userId as AnyObject
        dic["priorityIdShift"] = sourceIndexPath.row + 1  as AnyObject
        dic["userUpdateId"]  = Constants.loggedInMember?.userId as AnyObject
        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
        dic["appVersion"] = Utility.getAppVersion() as AnyObject
//        print(dic)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiChangeMatchingsOrder, success: { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    //Swapping
                    self.choosings.swapAt(sourceIndexPath.row, destinationIndexPath.row)
                    self.tblView.reloadData()
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
    
    //*******************************************************
    //checking iAP and then Loading all matchings from server
    //*******************************************************
    func getChoosingsMatchingsMarried(isRefresh: Bool){
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue || //consultant
            UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue) ||     //Adming
            //OR a member with a paid profile, dont need to check IAP
            (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue &&
                Constants.loggedInMember?.profileStatusId == profileStatusType.paid.rawValue || Constants.loggedInMember?.profileStatusId == profileStatusType.finished.rawValue)
        {
            loadChoosingMatchingsMarried(isRefresh: isRefresh) //Directly load matching no need to check IAP
        }else if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue ){//Member
            if (Constants.loggedInMember?.choosingCount ?? 0 <= 0 && isRefresh != true){ //if its not a refresh call then just check matching count from the persist
                Utility.showAlertWithOk(title: "information".localized, withMessage: "no_match_found".localized, withNavigation: self) {
                    if (isRefresh){ //if this is called from grid refreshing
                        self.refreshControl.endRefreshing()
                    }
                }
                self.tblView.reloadData() //empty all data
            }else{
                if (self.iAPProducts.count > 0){
                    let product = self.iAPProducts[0] //Since we have only one iAP product
//                    print(Constants.loggedInMember?.profileStatusId as Any)
                    if ((UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue) &&   //logged in member is a member &&
                        (Constants.loggedInMember?.profileStatusId != profileStatusType.paid.rawValue || Constants.loggedInMember?.profileStatusId != profileStatusType.finished.rawValue) &&       //profile status is not paid or finished
                        (iAPProduct.store.isProductPurchased(product.productIdentifier) == false)               //In app purchasing hasnt done yet
                        )
                    {//member
                        if IAPHelper.canMakePayments(){
                            Utility.showAlertWithOkCancel(title: "confirm".localized, withMessage: "unpaid_profile".localized, withNavigation: self, withOkBlock: {
                                if (isRefresh){ //if this is called from grid refreshing
                                    self.refreshControl.endRefreshing()
                                }
                                if (self.iAPProducts.count > 0 ){
                                    Utility.shared.showSpinner()
                                    iAPProduct.store.buyProduct(product) //Once iAP is purchased, notification is called (handlePurchaseNotification)
                                }
                            }) {
                                //Cancel Block
                                if (isRefresh){ //if this is called from grid refreshing
                                    self.refreshControl.endRefreshing()
                                }
                            }
                        }else{
                            if (isRefresh){ //if this is called from grid refreshing
                                self.refreshControl.endRefreshing()
                            }
                            Utility.showAlert(title: "information".localized, withMessage: "iAPNotAvailable".localized, withNavigation: self)
                        }
                    }else{
                        loadChoosingMatchingsMarried(isRefresh: isRefresh)
                    }
                }else{
                    if (isRefresh){ //if this is called from grid refreshing
                        self.refreshControl.endRefreshing()
                    }
                    Utility.showAlert(title: "information".localized, withMessage: "iAPNotDownloaded".localized, withNavigation: self)
                }
                self.tblView.reloadData() //empty other tabs data
            }
        }
    }
    //*******************************
    //Loading all matchings from server
    //*******************************
    func loadChoosingMatchingsMarried(isRefresh: Bool){
        //if not is refresh then show the spinnger else refreshing control has its own spinner
        if let memberId = self.memberDetail?.userId{
            let method = Constants.apiGetMatchings + String(memberId)
            //if not is refresh then show the spinnger else refreshing control has its own spinner
            if (!isRefresh){
                Utility.shared.showSpinner()
            }
            ALFWebService.shared.doGetData( method: method, success: { (response) in
//                print(response)
                if (isRefresh){ //if this is called from grid refreshing
                    self.refreshControl.endRefreshing()
                }else{
                    Utility.shared.hideSpinner()
                }
                if let status = response["Status"] as? Int {
                    if status == 1 {
                        if let attempts = response["Attempts"] as? Int {    //take the fresh value of number of refuse/approve attempts of the user
                            self.memberDetail?.attempts = attempts
                        }
                        if let matchings = response["MatchMemberList"] as? [Dictionary<String,AnyObject>] {
                            if matchings.count == 0 {
                                Utility.showAlert(title: "alert".localized, withMessage: "no_match_found".localized, withNavigation: self)
                            }
                            var allMatchings = [Member]()
                            for match in matchings {
                                //self.choosings.append(Member.init(fromDictionary: match))
                                allMatchings.append(Member.init(fromDictionary: match))
                            }
                            allMatchings = allMatchings.sorted(by: { ($0.priorityId ?? Int.max) < ($1.priorityId ?? Int.max)})      //first sorting on the base of priority
                            self.choosings = allMatchings.filter{return $0.matchStatusId == matchStatusType.choosing.rawValue}  //filtering choosing member out
                            let potentialMatchings : [Member] = allMatchings.filter{return $0.matchStatusId == matchStatusType.matching.rawValue }
                            let refusedByUser : [Member] = allMatchings.filter{return $0.matchStatusId == matchStatusType.refused.rawValue && $0.refusedBy == memberId }
                            let refusedByOtherUser : [Member] = allMatchings.filter{return $0.matchStatusId == matchStatusType.refused.rawValue && $0.refusedBy != memberId }
                            self.matchings.removeAll()
//                            if (potentialMatchings.count > 0){
                                self.matchings.append(matchingsData(sectionTitle: "match".localized, sectionRows: potentialMatchings))
//                            }
                            if(refusedByUser.count > 0){
                                self.matchings.append(matchingsData(sectionTitle: "refusedByMember".localized, sectionRows: refusedByUser))
                            }
                            if(refusedByOtherUser.count > 0){
                                self.matchings.append(matchingsData(sectionTitle: "refusedByOtherMember".localized, sectionRows: refusedByOtherUser))
                            }
                            self.married = allMatchings.filter{return $0.matchStatusId == matchStatusType.married.rawValue}     //filtering married members out
                            self.tblView.reloadData()
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
    
    @IBAction func selectedIndexChanged(_ sender: Any) {
        //becuase it changing to done at tab 3, so changing it back to edit once tab is changed
        changeRightBarButton(title: "edit".localized)
        self.tblView.isEditing = false   //it will disable re-ordering
    
        switch self.segmentControl.selectedSegmentIndex
        {
            case 0:
                infoType = .profile
                tblView.reloadData()
                break;
            case 1:
                infoType = .required
                tblView.reloadData()
                break;
            case 2,3,4:
                if (self.segmentControl.selectedSegmentIndex == 2){
                    self.infoType = .choosing
                }else if (self.segmentControl.selectedSegmentIndex == 3){
                    infoType = .matching
                }else if (self.segmentControl.selectedSegmentIndex == 4){
                    infoType = .married
                }
                if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
                    if let profileStatusId = Constants.loggedInMember?.profileStatusId{ //only paid member can see the choosing, matching and married tab info
                        if (profileStatusId == profileStatusType.paid.rawValue){  //paid the fee(profile completed)
                            if ((self.choosings.count + self.matchings.count + self.married.count) > 0){
                                tblView.reloadData()    //reload cachedand then refetch new data
                                getChoosingsMatchingsMarried(isRefresh: true) //Refreshing silently
                            }else{
                                getChoosingsMatchingsMarried(isRefresh: false) //Refreshing non silently
                            }
                        }else {    //profile is in-complete
                            Utility.showAlertWithOkCancel(title: "confirm".localized, withMessage: "incomplete_profile".localized, withNavigation: self, withOkBlock: {
                                //Ok Block
                                self.viewCompleteProfileTapped() //it will navigate to payment Gateway
                            }) {
                                //since profile is incomplete so clear all arrays
                                self.choosings.removeAll()
                                self.matchings.removeAll()
                                self.married.removeAll()
                                self.tblView.reloadData()
                            }
                        }
                    }else{
                        Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                    }
                }else{//current logged in member is admin or consultant
                    if ((self.choosings.count + self.matchings.count + self.married.count) > 0){
                        tblView.reloadData()    //reload cached
                        getChoosingsMatchingsMarried(isRefresh: true) //Refreshing silently
                    }else{
                        getChoosingsMatchingsMarried(isRefresh: false) //Refreshing non silently
                    }
                }
                break;
            default:
                break
        }
    }
    //this is same method as on profile viewcontroller
    @objc func viewCompleteProfileTapped() {
        var profilePercentComplete = 0
        if let mobileStatus = Constants.loggedInMember?.mobileStatus{
            profilePercentComplete = mobileStatus * 20
            switch mobileStatus{    //case 0,1,2,3,4 are not required
            case 5:
                profilePercentComplete = 90
                break
            case 6:
                profilePercentComplete = 100
                break
            default:
                break
            }
        }
        else{
            profilePercentComplete = 0
        }
        //By passing all steps logic if user has paid.... because paid mean all 5 steps are completed.
        if let paymentStatus = Constants.loggedInMember?.profileStatusId{
            if(paymentStatus == profileStatusType.paid.rawValue){
                profilePercentComplete = 100
            }
        }
        switch profilePercentComplete {
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
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .profileDetailVC) as! ProfileDetailVC
                viewController.memberDetail = Constants.loggedInMember
                viewController.iAPProducts = self.iAPProducts
                self.navigationController?.pushViewController(viewController, animated: true)
                break
            default:
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC1) as! SignUpVC1
                self.navigationController?.pushViewController(viewController, animated: true)
                break
        }
    }
    
    @objc func btnCallYourConsultantTapped() {
//        print("btnCallYourConsultantTapped")
        let number = Constants.loggedInMember?.cMobile
        if let phoneNumber = number {
            Utility.makeAPhoneCall(strPhoneNumber: phoneNumber.stringValue)
        }
    }

    
    //When user will click on edit button at top right
    @objc func editTapped()
    {
        switch self.segmentControl.selectedSegmentIndex
        {
            case 2: //tab choosing
                if (self.choosings.count > 0 ){ //if mathings exist only then can reOrder
                    let button:UIBarButtonItem = self.navigationItem.rightBarButtonItem!
                    print(button.title as Any)
                    if (button.title?.elementsEqual("edit".localized) ?? true){  //edit
                        self.tblView.isEditing = true   //it will enable re-ordering
                        changeRightBarButton(title: "done".localized)
                    }else{  //done
                        self.tblView.isEditing = false   //it will enable re-ordering
                        changeRightBarButton(title: "edit".localized)
                    }
                }
                break
            default:
                //If user want to see his own profile OR consultant want to see his own members profile OR logged in user is an Admin
                if (Constants.loggedInMember?.userId == self.memberDetail?.userId ||
                    Constants.loggedInMember?.userId == self.memberDetail?.consultantId ||
                    Constants.loggedInMember?.typeId == UserType.admin.rawValue
                    ){
                    let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC1) as! SignUpVC1
                    viewController.memberID = self.memberDetail?.userId
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                break;
        }
    }
    
    func changeRightBarButton(title:String){
        if let button = self.navigationItem.rightBarButtonItem{
            button.title = title    //title is hidden
            if (button.title?.elementsEqual("edit".localized) ?? true){  //edit
                button.image = UIImage(named: "edit_icon")
            }else{
                button.image = UIImage(named: "done_icon")
            }
        }
    }
    
    @IBAction func btnCommentsTapped(_ sender: Any) {
        //Step : 1
        let alert = UIAlertController(title: "comments".localized, message: "add_comments".localized, preferredStyle: UIAlertController.Style.alert )
        //Step : 2
        let save = UIAlertAction(title: "submit".localized, style: .default) { (alertAction) in
            let txtComments = alert.textFields![0] as UITextField
            if MOLHLanguage.isRTLLanguage() {
                txtComments.textAlignment = .right
            }
            else{
                txtComments.textAlignment = .left
            }
            if txtComments.text != "" {
                var dic = Dictionary<String,AnyObject>()
                if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
                        dic["userId"] = Constants.loggedInMember?.userId as AnyObject //It should be current user id
                    }else{
                        dic["userId"] = self.memberDetail?.userId as AnyObject //It should be current user id
                    }
                    dic["ConsultantNote"] = txtComments.text as AnyObject
                    dic["userUpdateId"]  = Constants.loggedInMember?.userId as AnyObject
                    dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
                    dic["appVersion"] = Utility.getAppVersion() as AnyObject
                    print(dic)
                    Utility.shared.showSpinner()
                    ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiComment, success: { (response) in
                        print(response)
                        Utility.shared.hideSpinner()
                        if let status = response["Status"] as? Int {
                            if status == 1 {
                                //Causes the view to resign from the status of first responder.
                                self.view.endEditing(true)
                                self.getMemberDetail(isRefresh: true)   //Reloading silently
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
            } else {
                print("TF 1 is Empty...")
            }
        }

        //Step : 3
        //For first TF
        alert.addTextField { (textField) in
            textField.placeholder = "comments".localized
//            textField.textColor = .red
        }

        //Step : 4
        alert.addAction(save)
        //Cancel action
        let cancel = UIAlertAction(title: "cancel".localized, style: .default) { (alertAction) in }
        alert.addAction(cancel)
        //OR single line action
        //alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })

        self.present(alert, animated:true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if infoType == .profile {
            self.tblView.restore() //hiding no data found message
            return profileInfoValues.count
        } else if infoType == .required {
            self.tblView.restore() //hiding no data found message
            return requiredInfoValues.count
        }else if (infoType == .choosing ){
            if self.choosings.count == 0 {
                self.tblView.setEmptyMessage("noData".localized)
            } else {
                self.tblView.restore()
            }
            return self.choosings.count
        }else if (infoType == .matching ){
            if self.matchings[section].numberOfItems == 0 {
                self.tblView.setEmptyMessage("noData".localized)
            } else {
                self.tblView.restore()
            }
            return self.matchings[section].numberOfItems
        }else if (infoType == .married ){
            if self.married.count == 0 {
                self.tblView.setEmptyMessage("noData".localized)
            } else {
                self.tblView.restore()
            }
            return self.married.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30.0))
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.backgroundColor =  UIColor(hexString: appColors.lightGray.rawValue)
        label.textAlignment = .center
        if (infoType == .choosing){
            label.text = "numberOfRecords".localized + String(self.choosings.count)
        }else if (infoType == .matching){
            label.text = "numberOfRecords".localized + String(self.matchings[section].numberOfItems)
        }else if (infoType == .married){
            label.text = "numberOfRecords".localized + String(self.married.count)
        }else{//rows count would be shown only on choosing,matching
            label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.0))
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30.0))
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.backgroundColor =  UIColor(hexString: appColors.lightBlueBackground.rawValue)
        if (MOLHLanguage.isRTLLanguage()){
            label.textAlignment = .right
        }else{
            label.textAlignment = .left
        }
        
        if (infoType == .matching && self.matchings[section].numberOfItems > 0 ){
            label.text = self.matchings[section].sectionTitle
        }
        else{//rows count would be shown only on choosing,matching
            label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.0))
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (infoType == .matching && self.matchings[section].numberOfItems > 0){
            return 30
        }else{
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (infoType == .matching){
            return self.matchings.count
        }else{
            return 1
        }
    }
}
