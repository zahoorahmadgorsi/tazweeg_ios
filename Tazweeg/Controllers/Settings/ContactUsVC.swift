//
//  ContactUsVC.swift
//  Tazweeg
//
//  Created by iMac on 6/12/19.
//  Copyright © 2019 Tazweeg. All rights reserved.
//


import UIKit
import MOLH
import MessageUI

class ContactUsVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tblView: UITableView!
    var nameArr = [String]()
    var imgArry = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "contactUs".localized
        
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameArr = [
            Constants.phone
            , Constants.emailToRecepients
            , "facebook".localized
            , "instagram".localized
            , "pinterest".localized
            , "telegram".localized
            , "twitter".localized
            , "office_address".localized //Location
        ]
        imgArry = [#imageLiteral(resourceName: "phone_icon"),#imageLiteral(resourceName: "email_icon"),#imageLiteral(resourceName: "facebook_icon"),#imageLiteral(resourceName: "instagram_icon"),#imageLiteral(resourceName: "pinterest_icon"),#imageLiteral(resourceName: "telegram_icon"),#imageLiteral(resourceName: "twitter_icon"),#imageLiteral(resourceName: "location_icon")]
        tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
        //return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SlideMenuCell
        if MOLHLanguage.isRTLLanguage() {
            cell.lblTitle.textAlignment = .right
        }else{
            cell.lblTitle.textAlignment = .left
        }
        cell.lblTitle.text = nameArr[indexPath.row]
        let img = imgArry[indexPath.row]
        
        cell.imgView.image = img
        cell.imgView.setImageColor(color: UIColor(hexString: appColors.defaultColor.rawValue))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {//Phone
            Utility.makeAPhoneCall(strPhoneNumber: Constants.phone)
        }else if indexPath.row == 1 { //Email
            sendEmail()
        }else if indexPath.row == 2 { //Facebook
            let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            dvc.pageType = .facebook
            self.navigationController?.pushViewController(dvc, animated: true)
        }
        else if indexPath.row == 3 { //Instagram
            let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            dvc.pageType = .instagram
            self.navigationController?.pushViewController(dvc, animated: true)
        }else if indexPath.row == 4 { //Pintrest
            let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            dvc.pageType = .pintrest
            self.navigationController?.pushViewController(dvc, animated: true)
        }else if indexPath.row == 5 { //Telegram
            let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            dvc.pageType = .telegram
            self.navigationController?.pushViewController(dvc, animated: true)
        }else if indexPath.row == 6 { //Twitter
            let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
            dvc.pageType = .twitter
            self.navigationController?.pushViewController(dvc, animated: true)
        }else if indexPath.row == 7 { //Address/location
            //            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .changeLaunchIconVC) as! ChangeLaunchIconVC
            //            vc.pushViewController(viewController, animated: true)
        }
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
    
}
