//
//  MembersVC.swift
//  Tazweeg
//
//  Created by iMac on 4/21/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

class MatchingsVC : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var matchings = [MemberMatch]()
    var matchingsOfMemberID : Int?
    var loggedInMember : Member?
    @IBOutlet weak var btnCallYourConsultant: WAButton!
    private let refreshControl = UIRefreshControl() //Pull to refresh
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "matchings".localized
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
            btnCallYourConsultant.isHidden = false
        }else{
            btnCallYourConsultant.isHidden = true
        }
        getMatchings(isRefresh: false)
        //Since iOS 10, the UITableView and UICollectionView classes have a refreshControl property.
        tblView.refreshControl = refreshControl
        // Configure Refresh Control / The action is triggered when the valueChanged event occurs, that is, when the user pulls and releases the table view.
        refreshControl.addTarget(self, action: #selector(refreshTableviewData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(hexString: colors.defaultColor.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loggedInMember =  Utility.getLoggedInMember()
    }
    
    @objc private func refreshTableviewData(_ sender: Any) {
        // Fetch tableview Data
        getMatchings(isRefresh: true)
    }
    
    //*******************************
    //Loading all matchings
    //*******************************
    func getMatchings(isRefresh: Bool){
        //if not is refresh then show the spinnger else refreshing control has its own spinner
        if (!isRefresh){
            Utility.shared.showSpinner()
        }
        if let memberId = matchingsOfMemberID{
            let method = Constants.apiGetMatchings + String(memberId)
            ALFWebService.shared.doGetData( method: method, success: { (response) in
//                print(response)
                if (isRefresh){
                    self.refreshControl.endRefreshing()
                }else{
                    Utility.shared.hideSpinner()
                }
                if let status = response["Status"] as? Int {
                    if status == 1 {
                        if let matchings = response["MatchMemberList"] as? [Dictionary<String,AnyObject>] {
                            if matchings.count == 0 {
                                Utility.showAlertWithOk(title: "alert".localized, withMessage: "no_match_found".localized, withNavigation: self, withOkBlock: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                                return
                            }
                            self.matchings.removeAll()
                            for match in matchings {
                                self.matchings.append(MemberMatch.init(fromDictionary: match))
                            }
                            if self.matchings.count != 0 {
                                self.tblView.reloadData()
                            }
                        }
                    }else {
                        Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
                    }
                }else {
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
                }
            }) { (response) in
                print(response)
                Utility.shared.hideSpinner()
                Utility.showAlert(title: "error".localized, withMessage: "general_error".localized, withNavigation: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MatchingCell
        let model = self.matchings[indexPath.row]
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){
            //Hide Consultant name and phone image for member
            cell.lblConsultantName.isHidden = true
            cell.imgPhone.isHidden = true
        }else{
            cell.lblConsultantName.isHidden = false
            cell.imgPhone.isHidden = false
        }
        cell.lblUserCode.text = model.code
        if let phoneNumber = model.consultantPhoneNumber{
            cell.lblConsultantNumber.text = phoneNumber.stringValue
        }
        cell.lblConsultantName.text = model.consultantName
        cell.tag = indexPath.row
        if MOLHLanguage.isRTLLanguage() {
            cell.lblUserCode.textAlignment = .right
            cell.lblConsultantNumber.textAlignment = .right
            cell.lblConsultantName.textAlignment = .right
        }
        else{
            cell.lblUserCode.textAlignment = .left
            cell.lblConsultantNumber.textAlignment = .left
            cell.lblConsultantName.textAlignment = .left
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.matchings[indexPath.row]
        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .memberDetailVC) as! MemberDetailVC
        viewController.memberID = model.userId
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnCallYourConsultantTapped(_ sender: Any) {
        print("btnCallYourConsultantTapped")
        let number = loggedInMember?.cMobile
        if let phoneNumber = number {
            Utility.makeAPhoneCall(strPhoneNumber: phoneNumber.stringValue)
        }
    }
    
}
