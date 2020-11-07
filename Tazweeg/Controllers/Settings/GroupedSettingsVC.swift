
//
//  SettingsVC.swift
//  Tazweeg
//
//  Created by iMac on 6/11/19.
//  Copyright © 2019 Tazweeg. All rights reserved.
//

import UIKit
import MOLH
import MessageUI

struct SectionRow{
    let rowTitle: String
    let rowImagePath : String
}

struct SectionData {
    let sectionTitle: String
    let sectionRows : [SectionRow]

    var numberOfItems: Int {
        return sectionRows.count
    }

    subscript(index: Int) -> SectionRow {
        return sectionRows[index]
    }
}

extension SectionData {
    //  Putting a new init method here means we can keep the original, memberwise initaliser.
    init(title: String, rows: SectionRow...) {
        self.sectionTitle = title
        self.sectionRows  = rows
    }
}

class GroupedSettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblCopyRights: UILabel!
    @IBOutlet weak var lblVersionBuild: UILabel!
    
    lazy var mySections: [SectionData] = {
        var section1Rows = [SectionRow]()
        section1Rows.append( SectionRow(rowTitle: "enableFaceID".localized, rowImagePath: "face_recognition"))
        section1Rows.append( SectionRow(rowTitle: "changePassword".localized, rowImagePath: "change_password"))
        section1Rows.append( SectionRow(rowTitle: "changeLanguage".localized, rowImagePath: "change_language"))
        section1Rows.append( SectionRow(rowTitle: "changeLaunchIcon".localized, rowImagePath: "change_launch"))
//        let section1 = SectionData(sectionTitle: "settings".localized, sectionRows:section1Rows)
        let section1 = SectionData(sectionTitle: " ", sectionRows:section1Rows)
        
        var section2Rows = [SectionRow]()
        section2Rows.append( SectionRow(rowTitle: "terms_and_condition".localized, rowImagePath: "terms_condition"))
        section2Rows.append( SectionRow(rowTitle: "privacy_policy".localized, rowImagePath: "privacy_policy"))
        section2Rows.append( SectionRow(rowTitle: "faqs".localized, rowImagePath: "faq_icon"))
//        let section2 = SectionData(sectionTitle: "terms_and_condition".localized, sectionRows:section2Rows)
        let section2 = SectionData(sectionTitle: " ", sectionRows:section2Rows)
        
        var section3Rows = [SectionRow]()
        section3Rows.append( SectionRow(rowTitle: "sign_out".localized, rowImagePath: "sign_out"))
        let section3 = SectionData(sectionTitle: " ", sectionRows:section3Rows)
        
        var section4Rows = [SectionRow]()
        section4Rows.append( SectionRow(rowTitle: " ", rowImagePath: "user"))
        let section4 = SectionData(sectionTitle: " ", sectionRows:section4Rows)
        
        var section5Rows = [SectionRow]()
        section5Rows.append( SectionRow(rowTitle: "office_address".localized, rowImagePath: "location_icon"))
        section5Rows.append( SectionRow(rowTitle: Constants.phone, rowImagePath: "phone_icon"))
        let section5 = SectionData(sectionTitle: " ", sectionRows:section5Rows)

        return [section1, section2, section3, section4, section5]
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage
        //Settings title
        self.navigationItem.title = "settings".localized
        //Setting copy right and app version and build info
        lblCopyRights.text = "copy_rights".localized;
        lblVersionBuild.text = Utility.getAppVersionAndBuild()
        //To hide black bar which appears below navigation bar
    //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
//    commenting local authentication (faceid) settings for now, as user can disable passcode or ios, so we have to handle this scenario
//        nameArr = [
//            "changePassword".localized
//            , "changeLanguage".localized
//            , "changeLaunchIcon".localized
//            ,"enableFaceID".localized
//        ]
//        imgArry = [#imageLiteral(resourceName: "password_icon"),#imageLiteral(resourceName: "change_language"),#imageLiteral(resourceName: "change_launch"),#imageLiteral(resourceName: "face_recognition")]
        tblView.reloadData()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySections[section].numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupedSettingsCell") as! GroupedSettingsCell
        
        if MOLHLanguage.isRTLLanguage() {
            cell.lblTitle.textAlignment = .right
        }else{
            cell.lblTitle.textAlignment = .left
        }
        //For Contact US showing svContactUs stackview while for other nomral view
        //if (indexPath.section == 3 && indexPath.row == 0){    //contact us
        if (indexPath.section == 3 ){    //contact us
            cell.svContactUs.isHidden = false
            cell.svSettings.isHidden = true
        }else{
            cell.lblTitle.text = mySections[indexPath.section][indexPath.row].rowTitle
            cell.imgView.image = UIImage(named: mySections[indexPath.section][indexPath.row].rowImagePath)
            cell.imgView.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        
            //enabling disabling faceID
            if (indexPath.section == 0 && indexPath.row == 0){//Unhiding for Faceid
                cell.switchIsEnabled.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
                cell.viewIsEnabled.isHidden = false
                if ((UserDefaults.standard.object(forKey: Constants.strIsFaceIDEnabled)) == nil || UserDefaults.standard.bool(forKey: Constants.strIsFaceIDEnabled) != false){
                     cell.switchIsEnabled.setOn(true, animated: true)
                }else{
                    cell.switchIsEnabled.setOn(false, animated: true)
                }
            }else{
                cell.viewIsEnabled.isHidden = true
                //showing right arrow for settings and terms and conditions sections ONLY
                if (indexPath.section == 0 || indexPath.section == 1 ){
                    cell.accessoryType = .disclosureIndicator
                }else{
                    cell.accessoryType = .none
                }
            }
            
            cell.svContactUs.isHidden = true
            cell.svSettings.isHidden = false
            if (indexPath.section == 4 ){    //address & Phone dont have left icon
                cell.imgView.isHidden = true
            }else{
                cell.imgView.isHidden = false
            }
        }
        
        
        return cell
    }
    
    @objc func switchValueChanged(_ sender:UISwitch){
        UserDefaults.standard.set(sender.isOn, forKey: Constants.strIsFaceIDEnabled)
        if (sender.isOn == true){
            print("UISwitch state is now ON")
        }
        else{
            print("UISwitch state is now Off")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && indexPath.row == 1) {    //change Password
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .changePassVC) as! ChangePassVC
            self.navigationController?.pushViewController(viewController, animated: true)

        }else if (indexPath.section == 0 && indexPath.row == 2) { //Change Language
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .changeLanguageVC) as! ChangeLanguageVC
            self.navigationController?.pushViewController(viewController, animated: true)

        }else if (indexPath.section == 0 && indexPath.row == 3) { //Change Launch Icon
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .changeLaunchIconVC) as! ChangeLaunchIconVC
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if (indexPath.section == 1 && indexPath.row == 0) { //Terms And Conditions
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            viewController.pageType = .term
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if (indexPath.section == 1 && indexPath.row == 1) { //Privacy Policy
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            viewController.pageType = .privacy
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if (indexPath.section == 1 && indexPath.row == 2) { //FAQs
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            viewController.pageType = .faq
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if (indexPath.section == 2 && indexPath.row == 0) { //signout
            Utility.showAlertWithOkCancel(title: "sign_out".localized, withMessage: "areYouSure".localized, withNavigation: self, withOkBlock: {
                Utility.logout()
            }) {}
        }else if (indexPath.section == 4 && indexPath.row == 1) { //Phone call
            Utility.makeAPhoneCall(strPhoneNumber: Constants.phone)
        }
    }
    
    @IBAction func btnContactUsTapped(_ sender: Any) {
        let button = sender as! UIButton
        contactUsTapped(tag: button.tag)
    }
    
    
    func contactUsTapped(tag: Int){
        if (tag == 0){  //facebook
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            viewController.pageType = .facebook
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if (tag == 1){    //instagram
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            viewController.pageType = .instagram
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if (tag == 2){    //twitter
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            viewController.pageType = .twitter
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if (tag == 3){    //telegram
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            viewController.pageType = .telegram
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if (tag == 4){    //pintrest
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            viewController.pageType = .pintrest
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if (tag == 5){    //email
            sendEmail()
        }
    }
    
    func sendEmail() {
        if !MFMailComposeViewController.canSendMail() {
            Utility.showAlertWithoutTitle( withMessage: "mailServiceNotAvailable".localized, withNavigation: self)
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients([Constants.emailToRecepients])
        composeVC.setSubject("emailSubject".localized)
        let emailBody : String = Utility.composeEmail()
        print(emailBody)
        composeVC.setMessageBody(emailBody, isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    //****************************************
    //When email composing client is dismissed
    //****************************************
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        //private func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            //                Utility.printToConsole(message:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            //                Utility.printToConsole(message:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            //                Utility.printToConsole(message:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            //                Utility.printToConsole(message:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
