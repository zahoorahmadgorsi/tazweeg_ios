//
//  SettingsVC.swift
//  Tazweeg
//
//  Created by iMac on 6/11/19.
//  Copyright © 2019 Tazweeg. All rights reserved.
//

import UIKit
import MOLH

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    var nameArr = [String]()
    var imgArry = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "settings".localized
        //To hide black bar which appears below navigation bar
       
        //Making tableview cell height dynamic
        tblView.estimatedRowHeight = 60.0
        tblView.rowHeight = UITableViewAutomaticDimension
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
//    commenting local authentication (faceid) settings for now, as user can disable passcode or ios, so we have to handle this scenario
        nameArr = [
            "changePassword".localized
            , "changeLanguage".localized
            , "changeLaunchIcon".localized
            ,"enableFaceID".localized
        ]
        imgArry = [#imageLiteral(resourceName: "password_icon"),#imageLiteral(resourceName: "change_language"),#imageLiteral(resourceName: "change_launch"),#imageLiteral(resourceName: "face_recognition")]
        tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
        if indexPath.row == 3{//Unhiding for Faceid
            cell.switchIsEnabled.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.viewIsEnabled.isHidden = false
            if ((UserDefaults.standard.object(forKey: Constants.strIsFaceIDEnabled)) == nil || UserDefaults.standard.bool(forKey: Constants.strIsFaceIDEnabled) != false){
                cell.switchIsEnabled.setOn(true, animated: true)
            }else{
                cell.switchIsEnabled.setOn(false, animated: true)
            }
        }else{
            cell.viewIsEnabled.isHidden = true
        }
        return cell
    }
    
    @objc func switchValueChanged(_ sender:UISwitch){
        UserDefaults.standard.set(sender.isOn, forKey: Constants.strIsFaceIDEnabled)
        if (sender.isOn == true){
            //                Utility.printToConsole(message:
            print("UISwitch state is now ON")
        }
        else{
            //                Utility.printToConsole(message:
            print("UISwitch state is now Off")
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if MOLHLanguage.isRTLLanguage() {
            self.slideMenuController()?.closeRight()
        }else{
            self.slideMenuController()?.closeLeft()
        }
        
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue ){//Member
//            print("Member dont have slide menu but bottom tab bar")
            if indexPath.row == 0 {
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .changePassVC) as! ChangePassVC
                self.navigationController?.pushViewController(viewController, animated: true)
            }else if indexPath.row == 1 { //Change Language
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .changeLanguageVC) as! ChangeLanguageVC
                self.navigationController?.pushViewController(viewController, animated: true)
            }else if indexPath.row == 2 { //Change Launch Icon
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .changeLaunchIconVC) as! ChangeLaunchIconVC
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }else{
            let vc = self.slideMenuController()?.mainViewController as! UINavigationController
            if indexPath.row == 0 {
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .changePassVC) as! ChangePassVC
                vc.pushViewController(viewController, animated: true)

            }else if indexPath.row == 1 { //Change Language
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .changeLanguageVC) as! ChangeLanguageVC
                vc.pushViewController(viewController, animated: true)
                
            }else if indexPath.row == 2 { //Change Launch Icon
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .changeLaunchIconVC) as! ChangeLaunchIconVC
                vc.pushViewController(viewController, animated: true)
            }
        }
    }
    
}
