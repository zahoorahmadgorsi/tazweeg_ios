//
//  ChangeLanguageVC.swift
//  Tazweeg
//
//  Created by iMac on 5/5/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

//https://developerinsider.co/how-to-change-an-ios-application-icon-programmatically/
class ChangeLaunchIconVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nameArr = [String]()
    var imgArry = [UIImage]()
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "changeLaunchIcon".localized
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblView.tableHeaderView?.frame.size = CGSize(width: tblView.frame.width, height: CGFloat(200))
        nameArr = [
            "abu_dhabi".localized           //1
            ,"dubai".localized              //2
            ,"sharjha".localized            //3
            ,"um_mul_queen".localized       //4
            ,"ras_al_khaima".localized      //5
            ,"ajman".localized              //6
            ,"fujairah".localized           //7
            ,"al_ain".localized             //8
            ,"abu_dhabi_police".localized   //9
            ,"tazweeg".localized            //10
        ]
        imgArry = [#imageLiteral(resourceName: "abu dhabi-1"),#imageLiteral(resourceName: "dubai-1"),#imageLiteral(resourceName: "sharja"),#imageLiteral(resourceName: "uq_circle"),#imageLiteral(resourceName: "rak"),#imageLiteral(resourceName: "ajman-1"),#imageLiteral(resourceName: "fujairah"),#imageLiteral(resourceName: "abu dhabi-1"),#imageLiteral(resourceName: "AD_police_circle"),#imageLiteral(resourceName: "tazweeg_circle")]
        tblView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChangeLaunchIconCell
        if MOLHLanguage.isRTLLanguage() {
            cell.lbl.textAlignment = .right
        }else{
            cell.lbl.textAlignment = .left
        }
        cell.lbl.text = nameArr[indexPath.row]
        let img = imgArry[indexPath.row]
        cell.icon.image = img
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            changeIcon(to: "AppIconAlternate1") //"abudhabi.png"
            //changeIcon(to: "abu dhabi") //"abudhabi.png"
        } else if indexPath.row == 1 {
            changeIcon(to: "AppIconAlternate2" )    //"dubai@3x"
        }else if indexPath.row == 2 {
            changeIcon(to: "AppIconAlternate3" )    //"sharja@3x"
        }else if indexPath.row == 3 {
            changeIcon(to: "AppIconAlternate4" )    //"umm al quwain@3x"
        }else if indexPath.row == 4 {
            changeIcon(to: "AppIconAlternate5" )    //"ras al khaima@3x"
        }else if indexPath.row == 5 {
            changeIcon(to: "AppIconAlternate6" )    //"ajman@3x"
        }else if indexPath.row == 6 {
            changeIcon(to: "AppIconAlternate7" )    //"fujairah@3x"
        }else if indexPath.row == 7 {
            changeIcon(to: "AppIconAlternate1" )    //"abu dhabi@3x" Al Ain
        }else if indexPath.row == 8 {
            changeIcon(to: "AppIconAlternate8" )    //"AbuDhabi Police"
        }else if indexPath.row == 9 {
            changeIcon(to: "AppIconAlternate9" )    //"tazweeg"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func resetAppIconTapped() {
        //Set the icon name to nil, the app will display its primary icon.
        changeIcon(to: nil)
    }
    
    func changeIcon(to name: String?) {
        //Check if the app supports alternating icons
        guard UIApplication.shared.supportsAlternateIcons else {
            return;
        }
        
        //Change the icon to a specific image with given name
        UIApplication.shared.setAlternateIconName(name) { (error) in
            //After app icon changed, print our error or success message
            if let error = error {
                Utility.showAlertWithoutTitle(withMessage: "dontSupport".localized, withNavigation: self)
//                Utility.printToConsole(message:
                print("App icon failed to due to \(error.localizedDescription)")
            } else {
                //                Utility.printToConsole(message:
                print("App icon changed successfully.")
            }
        }
    }
}
