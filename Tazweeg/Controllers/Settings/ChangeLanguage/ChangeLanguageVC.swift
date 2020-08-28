//
//  ChangeLanguageVC.swift
//  Tazweeg
//
//  Created by iMac on 5/5/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

class ChangeLanguageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nameArr = [String]()
    var imgArry = [UIImage]()
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "changeLanguage".localized
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage
        //To hide black bar which appears below navigation bar
        //https://stackoverflow.com/questions/46437160/ios-11-black-bar-appears-on-navigation-bar-when-pushing-view-controller?rq=1
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblView.tableHeaderView?.frame.size = CGSize(width: tblView.frame.width, height: CGFloat(200))
        nameArr = [
        "English"
        , " العربية "
        ]
        imgArry = [#imageLiteral(resourceName: "ENGLISH FLAG"),#imageLiteral(resourceName: "ARABIC FLAG")]
        tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChangeLanguageCell
        if MOLHLanguage.isRTLLanguage() {
            cell.lbl.textAlignment = .right
        }else{
            cell.lbl.textAlignment = .left
        }
        //Highlighting the selcted language
        if indexPath.row == 0 && !MOLHLanguage.isRTLLanguage() {
            cell.imgSelected.image = #imageLiteral(resourceName: "tick icon")
        }
        else if indexPath.row == 1 && MOLHLanguage.isRTLLanguage() {
            cell.imgSelected.image = #imageLiteral(resourceName: "tick icon")
        }
        else
        {
            cell.imgSelected.image = nil
        }
        cell.lbl.text = nameArr[indexPath.row]
        let img = imgArry[indexPath.row]
        cell.icon.image = img
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if(MOLHLanguage.currentAppleLanguage() != "en")
            {
                MOLH.setLanguageTo("en")
                MOLH.reset()
                //MOLH.reset(transition: .transitionCrossDissolve)
            }
        } else if indexPath.row == 1 {
            if(MOLHLanguage.currentAppleLanguage() != "ar")
            {
                MOLH.setLanguageTo("ar")
                MOLH.reset()
                //MOLH.reset(transition: .transitionCrossDissolve)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
}
