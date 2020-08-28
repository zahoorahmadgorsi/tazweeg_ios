//  MembersVC.swift
//  Tazweeg
//
//  Created by iMac on 4/21/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.

import UIKit
import MOLH
import ActionSheetPicker_3_0

//The first screen a consultant sees after login.
class MembersVC : UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UITextFieldDelegate
{
    var memberDetail : Member?
    //The tableData property will hold the items of the Table View, where the filteredTableData property will contain the result from the search query. The Search Controller manages the results of the search.
    var tableData = [Member]()
    var filteredTableData = [Member]()
    var searchController = UISearchController()
    var pageType = PageType.allMembers
    
    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var txtEmirates: UITextField!
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var viewMales: UIView!
    @IBOutlet weak var viewFemales: UIView!
    
    @IBOutlet weak var lblTotalCount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblMalesCount: UILabel!
    @IBOutlet weak var lblMales: UILabel!
    
    @IBOutlet weak var lblFemalesCount: UILabel!
    @IBOutlet weak var lblFemales: UILabel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var blurEffectView : UIView!
    var selectedProfileStatus : Int = 0
    var selectedGender : Int = 0
    var totalCount: Int = 0
    var maleCount: Int = 0
    var femaleCount:Int = 0
    private let refreshControl = UIRefreshControl() //Pull to refresh
//    var dropDowns: DropDownFileds?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        if MOLHLanguage.isRTLLanguage() {
            self.txtAge.textAlignment = .right
            self.txtEmirates.textAlignment = .right
        }
        else{
            self.txtAge.textAlignment = .left
            self.txtEmirates.textAlignment = .left
        }
        
        //defining and adding tap gesture on viewTotal
        let tapGestureOnViewTotal = UITapGestureRecognizer(target: self, action: #selector(viewTotalTapped))
        tapGestureOnViewTotal.numberOfTapsRequired = 1
        tapGestureOnViewTotal.numberOfTouchesRequired = 1
        viewTotal.isUserInteractionEnabled = true
        viewTotal.addGestureRecognizer(tapGestureOnViewTotal)
        //defining and adding tap gesture on viewMales
        let tapGestureOnViewMales = UITapGestureRecognizer(target: self, action: #selector(viewMalesTapped))
        tapGestureOnViewMales.numberOfTapsRequired = 1
        tapGestureOnViewMales.numberOfTouchesRequired = 1
        viewMales.isUserInteractionEnabled = true
        viewMales.addGestureRecognizer(tapGestureOnViewMales)
        //defining and adding tap gesture on viewFemales
        let tapGestureOnViewFemales = UITapGestureRecognizer(target: self, action: #selector(viewFemalesTapped))
        tapGestureOnViewFemales.numberOfTapsRequired = 1
        tapGestureOnViewFemales.numberOfTouchesRequired = 1
        viewFemales.isUserInteractionEnabled = true
        viewFemales.addGestureRecognizer(tapGestureOnViewFemales)
        
        //Setting up the views corder radius
        viewTotal.layer.cornerRadius = 12
        viewTotal.layer.borderColor = UIColor(hexString: appColors.defaultColor.rawValue).cgColor
        viewTotal.layer.borderWidth = 1.0
        
        viewMales.layer.cornerRadius = 12
        viewMales.layer.borderColor = UIColor(hexString: appColors.defaultColor.rawValue).cgColor
        viewMales.layer.borderWidth = 1.0
        
        viewFemales.layer.cornerRadius = 12
        viewFemales.layer.borderColor = UIColor(hexString: appColors.defaultColor.rawValue).cgColor
        viewFemales.layer.borderWidth = 1.0
        
        //Setting up uisegment control
        self.segmentControl.setTitle("all".localized, forSegmentAt: 0)
        self.segmentControl.setTitle("pending".localized, forSegmentAt: 1)
        self.segmentControl.setTitle("completed".localized, forSegmentAt: 2)
        self.segmentControl.setTitle("choosing".localized, forSegmentAt: 3)
        self.segmentControl.setTitle("matching".localized, forSegmentAt: 4)
        self.segmentControl.setTitle("married".localized, forSegmentAt: 5)
        
        if (pageType == PageType.allMembers){
            self.segmentControl.setWidth(0.1 , forSegmentAt: 1)
            self.segmentControl.setEnabled(false, forSegmentAt: 1)
            //MenuBarButton
            let menuBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(self.menuTap(_:)))
            self.navigationItem.leftBarButtonItem = menuBtn //For english it will become left and right for arabic
            self.navigationItem.title = "members".localized
        }else if (pageType == PageType.pendingMembers){
            self.segmentControl.isHidden = true
            self.navigationItem.title = "pendingMembers".localized
        }

        //Changing font for different device
        if UIDevice.current.userInterfaceIdiom == .phone {
           let font = UIFont.systemFont(ofSize: 12) //max font allowed for ios 8 with good visibility
           self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }else{
            let font = UIFont.systemFont(ofSize: 22)
            self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        
//        A closure is used which is assigned to the resultSearchController.
        searchController = ({
            //The results of the search will be presented in the current Table View, so the searchResultsController parameter of the UISearchController init method is set to nil.
            let controller = UISearchController(searchResultsController: nil)
            //the searchResultsUpdater property is set to the current Table View Controller
            controller.searchResultsUpdater = self
            //the background dimming is set to false.
            controller.dimsBackgroundDuringPresentation = false
            //The searchable is added to the Table View
            controller.searchBar.sizeToFit()
            return controller
        })()
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tblView.tableHeaderView = searchController.searchBar
        }
        //To dismiss uiSearchController
        self.definesPresentationContext = true
        //Since iOS 10, the UITableView and UICollectionView classes have a refreshControl property.
        tblView.refreshControl = refreshControl
        // Configure Refresh Control / The action is triggered when the valueChanged event occurs, that is, when the user pulls and releases the table view.
        refreshControl.addTarget(self, action: #selector(refreshTableviewData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(hexString: appColors.defaultColor.rawValue)
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        
        getDropDownsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.tableData.count == 0){
            Constants.loggedInMember =  Utility.getLoggedInMember()
            getMembers(isRefresh: false)
        }
        else{
            getMembers(isRefresh: true) //So that list may refresh silently after Edit, Pay, Transfer
        }
    }
    
    //************************************************
    //this Function loads all dropdown fields SILENTLY
    //************************************************
    func getDropDownsData(){
        ALFWebService.shared.doGetData( method: Constants.apiGetType, success: { (response) in
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let pre_registration_info = response["Values"] as? [Dictionary<String,AnyObject>] {
                        Constants.dropDowns = DropDownFileds.init(fromDictionary: pre_registration_info)
                    }
                }
            }
        }) { (response) in
//            print(response)
            Utility.shared.hideSpinner()
        }
    }
    
    @objc private func refreshTableviewData(_ sender: Any) {
        // Fetch tableview Data
        getMembers(isRefresh: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
        view.endEditing(true) //To stop keyboard to open
        if (textField == self.txtAge){
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
//                        textField.text = arr[index]
                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }else if (textField == self.txtEmirates){
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
                        self.searchController.searchBar.text = arr[index]
//                        let val = Constants.dropDowns!.states[index]
//                        textField.text = arr[index]
//                        textField.tag = (val["ValueId"] as? Int)!
                        textField.resignFirstResponder()
                    }, cancel: { (picker) in
                    }, origin: textField).show()
                }
            }
            return false;  // Hide both keyboard and blinking cursor.
        }else{
            return true
        }
    }
    
    //*******************************
    //Loading all Members,
    //isRefresh true mean silent refresh
    //*******************************
    func getMembers(isRefresh : Bool){
        //if not is refresh then show the spinnger else refreshing control has its own spinner
        if (!isRefresh){
            Utility.shared.showSpinner()
        }
        if let userId = Constants.loggedInMember?.userId{
            let method = Constants.apiGetConsultantMembers + String(userId)
            ALFWebService.shared.doGetData( method: method, success: { (response) in
                if (isRefresh){
                    self.refreshControl.endRefreshing()
                }else{
                    Utility.shared.hideSpinner()
                }
                if let status = response["Status"] as? Int {
                    if status == 1 {
                        if let items = response["MatchMemberList"] as? [Dictionary<String,AnyObject>] {
                            //Resetting the count
                            self.totalCount = 0
                            self.maleCount = 0
                            self.femaleCount = 0
                            self.tableData.removeAll()
                            self.filteredTableData.removeAll()
                            if items.count == 0 {
                                Utility.showAlertWithOk(title: "alert".localized, withMessage: "no_member_found".localized, withNavigation: self, withOkBlock: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                                return
                            }
                            //TempData contains all records sent by web API
                            var tempData = [Member]()
                            for match in items {
                                //Adds a new element at the end of the array.
                                tempData.append(Member.init(fromDictionary: match))
                            }
                            
                            //If this page is shown at "Pending Members" click then tableData will contain all pending members, else it will contain all members expect pending
                            if (self.pageType == PageType.allMembers){
                                self.tableData = tempData.filter {
                                    $0.profileStatusId != profileStatusType.incomplete.rawValue //not equal to pending
                                }
                            }else{ //Only show pending (incomplete) profiles
                                self.tableData = tempData.filter {
                                    $0.profileStatusId == profileStatusType.incomplete.rawValue //not equal to pending
                                }
                            }
                            //Counting Total/Males/Females from tableData (tableData got filtered on the base of pageType i.e. from where this page was called i.e. slidebar or right after login)
                            for item in self.tableData {
                                if (item.genderId == genderType.male.rawValue){
                                    self.maleCount += 1
                                }else if (item.genderId == genderType.female.rawValue){
                                    self.femaleCount += 1
                                }
                                self.totalCount += 1
                            }

                            self.filteredTableData = self.tableData //initially all data (filtered on the base of page type) is in filtered data
                            self.lblTotalCount.text = String(self.totalCount)
                            self.lblMalesCount.text = String(self.maleCount)
                            self.lblFemalesCount.text = String(self.femaleCount)
                            if self.tableData.count != 0 {
                                self.tblView.reloadData()
                                self.filterContentForSearchText()
                            }else{
                                self.tblView.reloadData() // it will empty the grid because self.tableData.count = 0
                            }
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
    //Changing foreground and background and text color
    @objc func viewTotalTapped(sender: UITapGestureRecognizer) {
        selectedGender = genderType.both.rawValue
        //Views
        self.viewTotal.backgroundColor =  UIColor(hexString: appColors.defaultColor.rawValue)
        self.viewMales.backgroundColor =  UIColor(hexString: appColors.lightGray.rawValue)
        self.viewFemales.backgroundColor =  UIColor(hexString: appColors.lightGray.rawValue)
        //total
        self.lblTotalCount.textColor =  UIColor(hexString: appColors.whiteColor.rawValue)
        self.lblTotal.textColor =  UIColor(hexString: appColors.blackColor.rawValue)
        //Males
        self.lblMalesCount.textColor =  UIColor(hexString: appColors.blackColor.rawValue)
        self.lblMales.textColor =  UIColor(hexString: appColors.defaultColor.rawValue)
        //Females
        self.lblFemalesCount.textColor =  UIColor(hexString: appColors.blackColor.rawValue)
        self.lblFemales.textColor =  UIColor(hexString: appColors.defaultColor.rawValue)
        
        //Re Loading tableview
        filterContentForSearchText()
    }
    
    @objc func viewMalesTapped(sender: UITapGestureRecognizer) {
        selectedGender = genderType.male.rawValue
        //Views
        self.viewTotal.backgroundColor =  UIColor(hexString: appColors.lightGray.rawValue)
        self.viewMales.backgroundColor =  UIColor(hexString: appColors.defaultColor.rawValue)
        self.viewFemales.backgroundColor =  UIColor(hexString: appColors.lightGray.rawValue)
        //total
        self.lblTotalCount.textColor =  UIColor(hexString: appColors.blackColor.rawValue)
        self.lblTotal.textColor =  UIColor(hexString: appColors.defaultColor.rawValue)
        //Males
        self.lblMalesCount.textColor =  UIColor(hexString: appColors.whiteColor.rawValue)
        self.lblMales.textColor =  UIColor(hexString: appColors.blackColor.rawValue)
        //Females
        self.lblFemalesCount.textColor =  UIColor(hexString: appColors.blackColor.rawValue)
        self.lblFemales.textColor =  UIColor(hexString: appColors.defaultColor.rawValue)
        
        //Re Loading tableview
        filterContentForSearchText()
    }
    
    @objc func viewFemalesTapped(sender: UITapGestureRecognizer) {
        selectedGender = genderType.female.rawValue
        //Views
        self.viewTotal.backgroundColor =  UIColor(hexString: appColors.lightGray.rawValue)
        self.viewMales.backgroundColor =  UIColor(hexString: appColors.lightGray.rawValue)
        self.viewFemales.backgroundColor =  UIColor(hexString: appColors.defaultColor.rawValue)
        //total
        self.lblTotalCount.textColor =  UIColor(hexString: appColors.blackColor.rawValue)
        self.lblTotal.textColor =  UIColor(hexString: appColors.defaultColor.rawValue)
        //Males
        self.lblMalesCount.textColor =  UIColor(hexString: appColors.blackColor.rawValue)
        self.lblMales.textColor =  UIColor(hexString: appColors.defaultColor.rawValue)
        //Females
        self.lblFemalesCount.textColor =  UIColor(hexString: appColors.whiteColor.rawValue)
        self.lblFemales.textColor =  UIColor(hexString: appColors.blackColor.rawValue)
        
        //Re Loading tableview
        filterContentForSearchText()
    }
    
//    // MARK: - Custom Method
    
    @objc func menuTap(_ btn: UIBarButtonItem){
        if MOLHLanguage.isRTLLanguage() {
            self.slideMenuController()?.toggleRight()
        }
        else{
            self.slideMenuController()?.toggleLeft()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 1
        // return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filteredTableData.count == 0 {
            self.tblView.setEmptyMessage("noData".localized)
        } else {
            self.tblView.restore()
//            self.showToast(message: "numberOfRecords".localized + String(self.filteredTableData.count), font: .systemFont(ofSize: 14))
        }
        return filteredTableData.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30.0))
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
//        label.backgroundColor = UIColor(hexString: colors.lightBlueBackground.rawValue)
        //UIColor(hexString: colors.lightBlueBackground.rawValue)
        label.backgroundColor =  UIColor(hexString: appColors.lightGray.rawValue)
//        label.textColor = UIColor(hexString: strWhiteColor)
        label.textAlignment = .center
        //        label.text =  "Total \(Shared.instance.employees.count) rows"
        label.text = "numberOfRecords".localized + String(self.filteredTableData.count)
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MemberCell
        let model = self.filteredTableData[indexPath.row]
        if let imgUrl = URL(string: model.imagePath ?? "") {
            cell.imgMember.setImageWith(imgUrl)
        }
        
        //Changing color of match count view to green for completed members && if this member is still unviewed
        //if (model.profileStatusId != profileStatusType.incomplete.rawValue && model.isViewed == false){
        if (model.isViewed == false){
            cell.imgMatchCount.image = #imageLiteral(resourceName: "matching count green")
        }else{
            cell.imgMatchCount.image = #imageLiteral(resourceName: "matching count")
        }
        
        cell.lblMemberCode.text = model.code
        if (model.matchCount > 0){
            cell.lblMemberMatchCount.text = String(model.matchCount)
            cell.viewMatchCount.isHidden = false
        }else{
            cell.viewMatchCount.isHidden = true
        }
        
        cell.lblMemberName.text = model.fullName
        cell.lblMemberPhoneNumber.text = model.phone.stringValue
        cell.lblMemberAge.text = model.age
        cell.lblMemberConsultant.text = model.consultantName
        cell.userID = model.userId
        cell.imgMatchCount.tag = indexPath.row
        //defining and adding tap gesture on snapchat
        let tapGestureOnMatchCount = UITapGestureRecognizer(target: self, action: #selector(imgMatchCountTapped))
        tapGestureOnMatchCount.numberOfTapsRequired = 1
        tapGestureOnMatchCount.numberOfTouchesRequired = 1
        cell.imgMatchCount.isUserInteractionEnabled = true
        cell.imgMatchCount.addGestureRecognizer(tapGestureOnMatchCount)
        
        if MOLHLanguage.isRTLLanguage() {
            cell.lblMemberCode.textAlignment = .right
            cell.lblMemberMatchCount.textAlignment = .right
            cell.lblMemberName.textAlignment = .right
            cell.lblMemberPhoneNumber.textAlignment = .right
            cell.lblMemberAge.textAlignment = .left
            cell.lblMemberEmirate.text = model.stateAR
            cell.lblMemberEmirate.textAlignment = .right
            cell.lblMemberConsultant.textAlignment = .left
        }
        else{
            cell.lblMemberCode.textAlignment = .left
            cell.lblMemberMatchCount.textAlignment = .left
            cell.lblMemberName.textAlignment = .left
            cell.lblMemberPhoneNumber.textAlignment = .left
            cell.lblMemberAge.textAlignment = .right
            cell.lblMemberEmirate.text = model.stateEN
            cell.lblMemberEmirate.textAlignment = .left
            cell.lblMemberConsultant.textAlignment = .right
        }
        return cell
    }
    
    //The updateSearchResults(for:_) method is called when the user updates the Search bar with input. In this method we will handle the search filtering of our search term.
    func updateSearchResults(for searchController: UISearchController) {
//        print(updateSearchResults)
        filterContentForSearchText()
    }
    
    //***************************
    // When tapped on match count
    //***************************
    @objc func imgMatchCountTapped(gesture : UITapGestureRecognizer) {
//        print(" imgMatchCountTapped ")
        let view = gesture.view!
        let member = self.filteredTableData[view.tag]
        if let number = member.matchCount {
            if (number <= 0){
                Utility.showAlert(title: "information".localized, withMessage: "no_member_found".localized, withNavigation: self)
            }
            else{
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .profileDetailVC) as! ProfileDetailVC
                viewController.memberDetail = member
                viewController.infoType = .matching //Open matching tab
//                viewController.iAPProducts = self.iAPProducts
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }else{
            Utility.showAlert(title: "information".localized, withMessage: "no_member_found".localized, withNavigation: self)
        }
    }
    //***************************
    // When tapped on cell
    //***************************
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
            UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue){//Consultant
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .profileDetailVC) as! ProfileDetailVC
            let model = self.filteredTableData[indexPath.row]
            viewController.memberDetail = model
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    //******************************************************
    //When user click on All, Pending, Completed, paid, finished
    //******************************************************
    @IBAction func segmentIndexChanged(_ sender: Any) {
//        print("Selected Segment Index = " + String(self.segmentControl.selectedSegmentIndex))
        switch self.segmentControl.selectedSegmentIndex
        {
            case 0:
                selectedProfileStatus = 0                                       //all
                break
            case 1:
                selectedProfileStatus = profileStatusType.incomplete.rawValue   //Pending
                break
            case 2:
                selectedProfileStatus = profileStatusType.notPaid.rawValue      //Completed
                break
            case 3:
                selectedProfileStatus = profileStatusType.paid.rawValue         //choosing
                break
            case 4:
                selectedProfileStatus = profileStatusType.matching.rawValue     //matching
                break
            case 5:
                selectedProfileStatus = profileStatusType.finished.rawValue     //married
                break
            default:
                break
        }
        filterContentForSearchText()
        
    }
    //*******************************************************************
    //Filter the table view on the base of text, Gender and profileStatus
    //*******************************************************************
    func filterContentForSearchText() {
        filteredTableData.removeAll(keepingCapacity: false)
        let textToSearch : String = searchController.searchBar.text?.lowercased() ?? ""
        let filteredArray = tableData.filter {
            if searchBarIsEmpty() {
                if (selectedGender == genderType.both.rawValue && selectedProfileStatus == 0){          //No filter on Gender and profileStatus
                    return true
                }else if (selectedGender == genderType.both.rawValue && selectedProfileStatus != 0){    //No filter on Gender but profileStatus
                    return $0.profileStatusId == selectedProfileStatus
                }else if (selectedGender != genderType.both.rawValue && selectedProfileStatus == 0){    //filter on gender but profileStatus
                    return $0.genderId == selectedGender
                }else{                                                                                  //filter on both gender & profileStatus
                    return $0.profileStatusId == selectedProfileStatus && $0.genderId == selectedGender
                }
            }else{
                if (selectedGender == genderType.both.rawValue && selectedProfileStatus == 0){          //No filter on Gender and profileStatus
//                    print($0.code)
                   return String(describing:$0.code?.lowercased()) .contains(textToSearch.lowercased())
                        || String(describing: $0.fullName?.lowercased()).contains(textToSearch.lowercased())
                        || String(describing: $0.phone).contains(textToSearch.lowercased())
                        || String(describing: $0.age?.lowercased()).contains(textToSearch.lowercased())
                        || String(describing: $0.stateEN?.lowercased()).contains(textToSearch.lowercased())
                        || String(describing: $0.stateAR?.lowercased()).contains(textToSearch.lowercased())
                        || String(describing: $0.consultantName?.lowercased()).contains(textToSearch.lowercased())
                }else if (selectedGender == genderType.both.rawValue && selectedProfileStatus != 0){    //No filter on Gender but profileStatus
                    return $0.profileStatusId == selectedProfileStatus && (
                        String(describing:$0.code?.lowercased()) .contains(textToSearch.lowercased())
                            || String(describing: $0.fullName?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.phone).contains(textToSearch.lowercased())
                            || String(describing: $0.age?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.stateEN?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.stateAR?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.consultantName?.lowercased()).contains(textToSearch.lowercased()))
                }else if (selectedGender != genderType.both.rawValue && selectedProfileStatus == 0){    //filter on gender but profileStatus
                    return $0.genderId == selectedGender && (
                        String(describing:$0.code?.lowercased()) .contains(textToSearch.lowercased())
                            || String(describing: $0.fullName?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.phone).contains(textToSearch.lowercased())
                            || String(describing: $0.age?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.stateEN?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.stateAR?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.consultantName?.lowercased()).contains(textToSearch.lowercased()))
                }else{                                                                                  //filter on both gender & profileStatus
                    return $0.profileStatusId == selectedProfileStatus && $0.genderId == selectedGender && (
                        String(describing:$0.code?.lowercased()) .contains(textToSearch.lowercased())
                            || String(describing: $0.fullName?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.phone).contains(textToSearch.lowercased())
                            || String(describing: $0.age?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.stateEN?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.stateAR?.lowercased()).contains(textToSearch.lowercased())
                            || String(describing: $0.consultantName?.lowercased()).contains(textToSearch.lowercased()))
                }
            }
        }
        //The results are then assigned to the filteredTableData array and the Table View is reloaded.
        filteredTableData = filteredArray
        tblView.reloadData()
    }

    //******************************************************
    //Swiping left-to-right (when local language is english)
    //******************************************************
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let swipedMember = self.filteredTableData[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title:  "edit".localized, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            print("Edit")
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC1) as! SignUpVC1
            viewController.memberID = swipedMember.userId
            self.navigationController?.pushViewController(viewController, animated: true)
            success(true)
        })
        editAction.backgroundColor = .orange
        
        let payAction = UIContextualAction(style: .normal, title:  "pay".localized, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if let age = swipedMember.age{
                let ageArray = age.split(separator: " ")  //Age is contain digit and text i.e. 36 years
                if(ageArray.count > 1){
                    swipedMember.age = String(ageArray[0])
                }
            }
            Utility.printToConsole(message: swipedMember.age)
            //if swiped member age is not nill AND its greater then equal to 35 AND its gender is female && swiping member is not an admin THEN show apply age check
            if (swipedMember.age != nil && Int(swipedMember.age) ?? 36 >= 35 && swipedMember.genderId == genderType.female.rawValue
                && Constants.loggedInMember?.typeId != UserType.admin.rawValue){
                Utility.showAlertWithOk(title: "pay".localized, withMessage: "age_check".localized, withNavigation: self, withOkBlock: {
                    self.navigationController?.popViewController(animated: true)
                })
            }else{  //admin can change a girl status to "PAY" who is more than 35 year of age
                Utility.showAlertWithOkCancel(title: "pay".localized, withMessage: "areYouSurePay".localized, withNavigation: self, withOkBlock: {
                    self.updateProfileStatus(userId: swipedMember.userId, profileStatus: profileStatusType.paid.rawValue)
                }) {
                }
            }
            success(true)
        })
        payAction.backgroundColor = UIColor(hexString: "#008000")//Green
        
        let finishedAction = UIContextualAction(style: .normal, title:  "finish".localized, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            Utility.showAlertWithOkCancel(title: "finish".localized, withMessage: "areYouSureFinish".localized, withNavigation: self, withOkBlock: {
                self.updateProfileStatus(userId: swipedMember.userId,profileStatus: profileStatusType.finished.rawValue)
            }) {
                
            }
            
            success(true)
        })
        finishedAction.backgroundColor = .blue
        var swipeAction = UISwipeActionsConfiguration(actions: [])
        let swipedRecord = self.filteredTableData[indexPath.row]
        if (swipedRecord.profileStatusId == profileStatusType.incomplete.rawValue){     // show edit only incase of incomplete(pending)
            swipeAction = UISwipeActionsConfiguration(actions: [editAction])
        }else if (swipedRecord.profileStatusId == profileStatusType.notPaid.rawValue){  // show edit only incase of complete(notpaid)
            swipeAction = UISwipeActionsConfiguration(actions: [editAction,payAction])
        }else if (swipedRecord.profileStatusId == profileStatusType.paid.rawValue){     // show edit only incase of complete(paid)
            swipeAction = UISwipeActionsConfiguration(actions: [editAction,finishedAction])
        }else{
            //Nothing on swipe right
        }
        swipeAction.performsFirstActionWithFullSwipe = false // This is the line which disables full swipe
        return swipeAction
    }
    //******************************************************
    //Swiping right-to-left (when local language is english)
    //******************************************************
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let swipedMember = self.filteredTableData[indexPath.row]
        let cancelAction = UIContextualAction(style: .normal, title:  "cancel".localized, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            Utility.showAlertWithOkCancel(title: "cancel".localized, withMessage: "areYouSureCancel".localized, withNavigation: self, withOkBlock: {
                self.updateProfileStatus(userId: swipedMember.userId,profileStatus: profileStatusType.cancelled.rawValue)
            }) {
            }
            success(true)
        })
        cancelAction.backgroundColor = .red
        
        let transferAction = UIContextualAction(style: .normal, title:  "transfer".localized, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .memberSignUpVC) as! MemberSignUpVC
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .countriesVC) as! CountriesVC
            viewController.userID = swipedMember.userId
            viewController.pageType = PageType.transfer
            let viewControllerNav = UINavigationController(rootViewController: viewController)
            self.present(viewControllerNav, animated:true, completion:nil)
            success(true)
        })
        transferAction.backgroundColor = .gray
        
        var swipeAction = UISwipeActionsConfiguration(actions: [])
        // Transfer button is to be shown for all users as per change asked by ahmad on 11-JAN-2020
//        let swipedRecord = self.filteredTableData[indexPath.row]
//        if (swipedRecord.profileStatusId == profileStatusType.incomplete.rawValue){ // show cancel only incase of incomplete(pending)
//            swipeAction =  UISwipeActionsConfiguration(actions: [cancelAction])
//        }else if (swipedRecord.profileStatusId == profileStatusType.notPaid.rawValue || swipedRecord.profileStatusId == profileStatusType.paid.rawValue ){ // show cancel and transfer only if profile is complete either paid or not paid doesnt matter
            if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue){
                swipeAction =  UISwipeActionsConfiguration(actions: [cancelAction,transferAction])
            }
            else{
                swipeAction =  UISwipeActionsConfiguration(actions: [cancelAction])
            }
//        }else{
//            //Nothing on swipe right
//        }
        swipeAction.performsFirstActionWithFullSwipe = false // This is the line which disables full swipe
        return swipeAction
    }
    
    //*************************************************
    //Updates the profile status to Pay, Cancel, Finish
    //*************************************************
    func updateProfileStatus(userId:Int, profileStatus:Int) {
        var dict = Dictionary<String,AnyObject>()
        dict["paymentStatusId"] = profileStatus as AnyObject
        dict["userId"] = userId as AnyObject
        dict["userUpdateId"] =  Constants.loggedInMember?.userId as AnyObject
//        print(dict)
        Utility.shared.showSpinner()
        ALFWebService.shared.doPostData(parameters: dict, method: Constants.apiUpdateProfileStatus, success: { (response) in
//            print(response)
            Utility.shared.hideSpinner()
            if let status = response["Status"] as? Int {
                if status == 1 {
                    self.showToast(message: "success".localized, font: .systemFont(ofSize: 14))
                    self.getMembers(isRefresh: false) //reloading all members data
                } else if status == 3 {
                    Utility.logout()
                }else {
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
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
