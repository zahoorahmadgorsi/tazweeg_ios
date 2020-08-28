//
//  MemberSignUpVC.swift
//  Tazweeg
//
//  Created by iMac on 4/2/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

class CountriesVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    var countries = [Country]()
//    var selectedID = 0
    private let refreshControlCollection = UIRefreshControl() //Pull to refresh
    //Variables for member transfer start
    var pageType = PageType.signUp
    var userID : Int? //Used when one member is transferring to an other Consultant

    @IBOutlet weak var lblTitle: WALabel!
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        if (pageType == PageType.signUp){
            self.navigationItem.title = "country".localized
        }else if (pageType == PageType.transfer){
            self.navigationItem.title = "transfer".localized
        }
        if (self.countries.count > 0){  //self.countries will have data if user is coming for signup
            getCountries(isRefresh: true)
            self.tblView.reloadData()
        }else{
            getCountries(isRefresh: false)
        }
        
        // Configure Refresh Control / The action is triggered when the valueChanged event occurs, that is, when the user pulls and releases the table view.
        refreshControlCollection.addTarget(self, action: #selector(refreshCollectionData(_:)), for: .valueChanged)
        refreshControlCollection.tintColor = UIColor(hexString: appColors.defaultColor.rawValue)
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(btnLogin.frame.height/2)
        lblTitle.cornerRadius = lblTitle.frame.height/2
    }
    
    
    @objc func backTap(_ btn: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }

    @objc private func refreshCollectionData(_ sender: Any) {
        // Fetch tableview Data
        getCountries(isRefresh: true)
    }
    
    //*******************************
    //Loading all emirates From ahsan
    //*******************************
    func getCountries(isRefresh : Bool){
        //if not is refresh then show the spinnger else refreshing control has its own spinner
        if (!isRefresh){
            Utility.shared.showSpinner()
        }
        ALFWebService.shared.doGetData( method: Constants.apiGetCountries, success: { (response) in
            if (isRefresh){
                self.refreshControlCollection.endRefreshing()
            }else{
                Utility.shared.hideSpinner()
            }
            if let status = response["Status"] as? Int {
                if status == 1 {
                    if let countries = response["Countries"] as? [Dictionary<String,AnyObject>] {
                        self.countries.removeAll()
                        for em in countries {
                            self.countries.append(Country.init(fromDictionary: em))
                        }
                        self.tblView.reloadData()
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry:Country = self.countries[indexPath.item]
            if (self.pageType == .signUp){
                if let controller =  presentingViewController as? UINavigationController{
                    print(controller.viewControllers.first as Any)
                    if let presenter = controller.viewControllers.first as? PhoneVC {
                        presenter.setCountry(country: selectedCountry )
                    }
                }
                dismiss(animated: true, completion: nil)    //passing selected country back
            }
//            if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue || UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue ){//Member or admin is transferring
            else if (self.pageType == .transfer){
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .statesAndConsultantsVC) as! StatesAndConsultantsVC
                viewController.selectedCountry = selectedCountry
                viewController.userID = self.userID //it will have value in case of transfer
                viewController.pageType = self.pageType
                let viewControllerNav = UINavigationController(rootViewController: viewController)
                self.present(viewControllerNav, animated:true, completion:nil)
            }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.countries.count == 0 {
            self.tblView.setEmptyMessage("noData".localized)
        }else{
            self.tblView.setEmptyMessage("")
        }
        return countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell") as! CountryCell
        let model = countries[indexPath.row]
        cell.imgView.circulate(radius: cell.imgView.frame.size.height/2)
        var url:String
        url = Constants.pathCountriesFlag + countries[indexPath.item].imgUrl
        let imgUrl = URL(string: url)
        if imgUrl != nil {
            cell.imgView.setImageWith(imgUrl!)
        }
        cell.tag = indexPath.row
        if let countrCode = model.code{
            cell.lblCountryCode.text = "+" + String(countrCode)
        }
        if MOLHLanguage.isRTLLanguage() {
            cell.lblCountryName.textAlignment = .right
            cell.lblCountryCode.textAlignment = .left
            cell.lblCountryName.text = model.countryAR
        }
        else{
            cell.lblCountryName.textAlignment = .left
            cell.lblCountryCode.textAlignment = .right
            cell.lblCountryName.text = model.countryEN
        }
        self.tblView.separatorStyle = .singleLine
//                self.tblView.separatorColor = .red
        return cell
    }
}
