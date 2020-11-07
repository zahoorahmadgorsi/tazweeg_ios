//
//  MemberSignUpVC.swift
//  Tazweeg
//
//  Created by iMac on 4/2/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

//class MemberSignUpVC: UIViewController , UITableViewDelegate, UITableViewDataSource,ConsultantCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
class StatesAndConsultantsVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
//    @IBOutlet weak var collEmirates: UICollectionView!
    
    @IBOutlet weak var lblTitle: WALabel!
    @IBOutlet weak var tblView: UITableView!
    var selectedCountry : Country?
    var mobileNumber : String?
    var states = [CountryState]()
    var consultants = [Consultant]()
    var selectedStateID = 0
    var selectedTab = 0 //0 mean in tableview states are loaded
    private let refreshControl = UIRefreshControl() //Pull to refresh
    //Variables for member transfer start
    var pageType = PageType.signUp
    var userID : Int? //Used when one member is transferring to an other Consultant
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        //Backbutton
        if MOLHLanguage.isRTLLanguage() {
            let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "right arrow"), style: .plain, target: self, action: #selector(self.backTap(_:)))
            self.navigationItem.leftBarButtonItem = backBtn
        }
        else{
            let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "left arrow"), style: .plain, target: self, action: #selector(self.backTap(_:)))
            self.navigationItem.leftBarButtonItem = backBtn
        }
        
        if (pageType == PageType.signUp){
            self.navigationItem.title = "sign_up".localized
        }else if (pageType == PageType.transfer){
            self.navigationItem.title = "transfer".localized
        }
        getListEmirates(isPullDownToRefresh: false)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(lblTitle.frame.height/2)
        lblTitle.cornerRadius = lblTitle.frame.height/2
    }
    
    @objc func backTap(_ btn: UIBarButtonItem){
        if (selectedTab == 1){  //if user is pressing backbutton on consultant tab then load states
            selectedTab = 0 
            getListEmirates(isPullDownToRefresh: false)    //loading list of state silently
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func refreshTableviewData(_ sender: Any) {
        // Fetch tableview Data
        if (selectedTab == 0){  //TableView is having states data
            getListEmirates(isPullDownToRefresh: true)    //loading list of state openly (not silenlty)
        }else{
            self.getConsultantByEmirateID(id: self.selectedStateID , isRefresh : true)
        }
    }
    
    //*******************************
    //Loading all emirates From ahsan
    //*******************************
    func getListEmirates(isPullDownToRefresh : Bool){
        self.lblTitle.text = "select_state".localized
        //if not is refresh then show the spinnger else refreshing control has its own spinner
        if (!isPullDownToRefresh){
            Utility.shared.showSpinner()
        }
        let method = Constants.apiGetStates + "/\(selectedCountry?.countryId ?? 218)" //218 is for emirates
        ALFWebService.shared.doGetData( method: method, success: { (response) in
            if (isPullDownToRefresh){
                self.refreshControl.endRefreshing()
            }else{
                Utility.shared.hideSpinner()
            }
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let states = response["States"] as? [Dictionary<String,AnyObject>] {
                        self.states.removeAll()
                        for em in states {
                            self.states.append(CountryState.init(fromDictionary: em))
                        }
                        self.tblView.reloadData()
                    }
                }else {
                    self.consultants.removeAll()
                    self.tblView.reloadData()
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
    
    //**********************************************
    //Loading consultants on the base of emirates id
    //**********************************************
    func getConsultantByEmirateID(id: Int ,  isRefresh : Bool){
        self.lblTitle.text = "select_consultant".localized
        selectedTab = 1 //tableview is containing consultants data, if 0 then its containing states data
        let method = Constants.apiGetConsultantsByState + "/\(id)"
        if (!isRefresh){
            Utility.shared.showSpinner()
        }
//        ALFWebService.shared.doGetData(parameters: dic, method: method, success: { (response) in
        ALFWebService.shared.doGetData( method: method, success: { (response) in
//            print(response)
            if (isRefresh){
                self.refreshControl.endRefreshing()
            }else{
                Utility.shared.hideSpinner()
            }
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let consultant = response["User"] as? [Dictionary<String,AnyObject>] {
                        self.consultants.removeAll()
                        for con in consultant {
                            self.consultants.append(Consultant.init(fromDictionary: con))
                        }
                        self.tblView.reloadData()
                    }
                } else {
                    self.consultants.removeAll()
                    self.tblView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //*****************************************
    //Delegate function for UITableViewDelegate
    //*****************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (selectedTab == 0){  //TableView is having states data
            if self.states.count == 0 {
                self.tblView.setEmptyMessage("noData".localized)
            } else {
                self.tblView.restore()
            }
            return states.count
        }else if (selectedTab == 1){    //TableView is having consultants data
            if self.consultants.count == 0 {
                self.tblView.setEmptyMessage("noData".localized)
            } else {
                self.tblView.restore()
            }
            return consultants.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "consultantCell") as! ConsultantCell
        
        if (selectedTab == 0){  //TableView is having states data
            let model = states[indexPath.row]
            print(cell.usrImg.frame.size.height)
            cell.usrImg.circulate(radius: cell.usrImg.frame.size.height/2) //half then the height
            let imgUrl = URL(string: model.imgPath ?? Constants.defaultImage)
            if imgUrl != nil {
                cell.usrImg.setImageWith(imgUrl!)
            }
            cell.phone.isHidden = true
            cell.tag = indexPath.row
            if MOLHLanguage.isRTLLanguage() {
                cell.name.textAlignment = .right
                cell.phone.textAlignment = .right
                cell.name.text = model.stateAR
            }
            else{
                cell.name.textAlignment = .left
                cell.phone.textAlignment = .left
                cell.name.text = model.stateEN
            }
        }else if (selectedTab == 1){  //TableView is having consultant data
                let model = consultants[indexPath.row]
                cell.usrImg.circulate(radius: cell.usrImg.frame.size.height/2) //half then the height

                let imgUrl = URL(string: model.image ?? Constants.defaultImage)
                if imgUrl != nil {
                    cell.usrImg.setImageWith(imgUrl!)
                }
                cell.phone.isHidden = false
                cell.name.text = model.name
                //cell.city.text = model.emiratesServesIn
                cell.phone.text = model.phoneNumber?.stringValue
                cell.tag = indexPath.row
        //        cell.delegate = self
                if MOLHLanguage.isRTLLanguage() {
                    cell.name.textAlignment = .right
                    cell.phone.textAlignment = .right
                }
                else{
                    cell.name.textAlignment = .left
                    cell.phone.textAlignment = .left
                }
            }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (pageType == PageType.signUp){
            if (selectedTab == 0){  //TableView is having states data
                selectedStateID = self.states[indexPath.item].stateId
                self.getConsultantByEmirateID(id: selectedStateID, isRefresh: false)
            }else if (selectedTab == 1){  //TableView is having consultant data
                let selectedConsultant : Consultant = consultants[indexPath.row]
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .commonSignUpVC) as! CommonSignUpVC
                viewController.selectedConsultant = selectedConsultant
                viewController.selectedCountry = selectedCountry
                viewController.mobileNumber =  self.mobileNumber
                viewController.selectedStateIDs.append(String(selectedStateID))
//                self.navigationController?.pushViewController(viewController, animated: true)
                let viewControllerNav = UINavigationController(rootViewController: viewController)
                self.present(viewControllerNav, animated:true, completion:nil)
            }
        }else if (pageType == PageType.transfer){
            if (selectedTab == 0){  //TableView is having states data
                selectedStateID = self.states[indexPath.item].stateId
                self.getConsultantByEmirateID(id: selectedStateID, isRefresh: false)
            }else if (selectedTab == 1){  //TableView is having consultant data
                let selectedConsultant : Consultant = consultants[indexPath.row]
                Utility.showAlertWithOkCancel(title: "transfer".localized, withMessage: "areYouSureTransfer".localized, withNavigation: self, withOkBlock: {
                    var dic = Dictionary<String,AnyObject>()
                    dic["consultantId"] = selectedConsultant.id as AnyObject
                    dic["userId"] = self.userID as AnyObject
                    dic["userUpdateId"] =  Constants.loggedInMember?.userId as AnyObject
                    dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
                    dic["appVersion"] = Utility.getAppVersion() as AnyObject
//                    print(dict)
                    Utility.shared.showSpinner()
                    ALFWebService.shared.doPostData(parameters: dic, method: Constants.apiTransferMember, success: { (response) in
//                        print(response)
                        Utility.shared.hideSpinner()
                        if let status = response["Status"] as? Int {
                            if status == 1 {
                                self.showToast(message: "success".localized, font: .systemFont(ofSize: 14))
//                                For Presenting modally, it will jump to members view controller
                                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                            } else if status == 3 {
                                Utility.logout()
                            }
                            else {
                                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                            }
                        }else {
                            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                        }
                    }) { (response) in
//                        print(response)
                        Utility.shared.hideSpinner()
                        Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                    }
                }) {
                    
                }
            }
        }
    }
    
    /// pop back n viewcontroller
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
    
}
