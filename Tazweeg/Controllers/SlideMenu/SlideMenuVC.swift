//  RightMenuVC.swift
//  Tazweeg
//  Created by Naveed ur Rehman on 04/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.

import UIKit
import MOLH
import StoreKit //IAP

class SlideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblStatesServesIn: UILabel!
    @IBOutlet weak var lblCopyRights: UILabel!
    @IBOutlet weak var lblVersionBuild: UILabel!
    
    var nameArr = [String]()
    var imgArry = [UIImage]()
    var imagePicker = UIImagePickerController()
    var dic = Dictionary<String,AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.circulate(radius: imgView.frame.size.height/2) //half then the size
        tblView.tableFooterView = UIView(frame: CGRect.zero)
        lblCopyRights.text = "copy_rights".localized;
        lblVersionBuild.text = Utility.getAppVersionAndBuild() 
//        print (UserDefaults.standard.integer(forKey: "currentUser"))
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue){//Member{
            self.lblStatesServesIn.isHidden = true
            self.navigationItem.title = "settings".localized
        }else if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
            UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue){//Consultant
            self.lblStatesServesIn.isHidden = false
        }
        if (Constants.loggedInMember == nil){
            Constants.loggedInMember = Utility.getLoggedInMember()
        }
//        print(Constants.loggedInMember)
        setMemberValues()
        imagePicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(btnLogin.frame.height/2)
        imgView.circulate(radius: imgView.frame.size.height/2) //half then the size
    }
    
    func setMemberValues()
    {
        if let imgPath = Constants.loggedInMember?.imagePath{
            let imgUrl = URL(string: imgPath)
            if imgUrl != nil {
                self.imgView.setImageWith(imgUrl!)
            }
        }
        self.lblName.text = Constants.loggedInMember?.fullName
        self.lblPhoneNumber.text = Constants.loggedInMember?.phone?.stringValue
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
            UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue)//Consultant
        {
            self.lblStatesServesIn.text = Constants.loggedInMember?.emirateServeIn
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Utility.isLoggedIn() {
            tblView.tableHeaderView?.frame.size = CGSize(width: tblView.frame.width, height: CGFloat(200))
            if UserDefaults.standard.object(forKey: "image") != nil {
                let imgURL = URL(string: UserDefaults.standard.object(forKey: "image") as! String)
                self.imgView.setImageWith(imgURL!)
            }
            
        } else {
            tblView.tableHeaderView?.frame.size = CGSize(width: tblView.frame.width, height: CGFloat(225))
            
        }
//        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue ){//Member
//            nameArr = [
//                "settings".localized
//                , "terms_and_condition".localized
//                , "faqs".localized
//                , "privacy_policy".localized
//                , "contactUs".localized
//                , "sign_out".localized
//            ]
//            imgArry = [#imageLiteral(resourceName: "settings"),#imageLiteral(resourceName: "terms_condition"),#imageLiteral(resourceName: "faq_icon"),#imageLiteral(resourceName: "privacy_policy"),#imageLiteral(resourceName: "contactus_icon"),#imageLiteral(resourceName: "sign_out")]
//        }else{
            nameArr = [
                "pendingMembers".localized
                ,"settings".localized
                , "terms_and_condition".localized
                , "faqs".localized
                , "privacy_policy".localized
                , "contactUs".localized
                , "sign_out".localized
            ]
            imgArry = [#imageLiteral(resourceName: "name_icon"),#imageLiteral(resourceName: "settings"),#imageLiteral(resourceName: "terms_condition"),#imageLiteral(resourceName: "faq_icon"),#imageLiteral(resourceName: "privacy_policy"),#imageLiteral(resourceName: "contactus_icon"),#imageLiteral(resourceName: "sign_out")]
//        }
        tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
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
        if MOLHLanguage.isRTLLanguage() {
            self.slideMenuController()?.closeRight()
        }else{
            self.slideMenuController()?.closeLeft()
        }
            let vc = self.slideMenuController()?.mainViewController as! UINavigationController
            if indexPath.row == 0 {
                if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
                    UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue){//consultant
                    let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .membersVC) as! MembersVC
                    viewController.pageType = .pendingMembers   //only show pending members
                    vc.pushViewController(viewController, animated: true)
                }
            }else if indexPath.row == 1 {
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .settingsVC) as! SettingsVC
                vc.pushViewController(viewController, animated: true)
            }else if indexPath.row == 2 {
                let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
                dvc.pageType = .term
                vc.pushViewController(dvc, animated: true)
            } else if indexPath.row == 3 {
                let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
                dvc.pageType = .faq
                vc.pushViewController(dvc, animated: true)
            }else if indexPath.row == 4 {
                let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .webViewVC) as! WebViewVC
                dvc.pageType = .privacy
                vc.pushViewController(dvc, animated: true)
            }else if indexPath.row == 5 { //Contact Us
                let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .contactUsVC) as! ContactUsVC
                vc.pushViewController(viewController, animated: true)
            }else if indexPath.row == 6 {
                Utility.showAlertWithOkCancel(title: "sign_out".localized, withMessage: "areYouSure".localized, withNavigation: self, withOkBlock: {
                    Utility.logout()
                }) {
                    
                }
            }
    }
    
    
    
    
    
    // MARK: - IBActions
   
    //    Added @objg to suppress the error "Argument of '#selector' refers to instance method 'usersSVTapped(sender:)' that is not exposed to Objective-C"
    //    and Because in Swift 4, functions are no longer implicitly exposed to Objective-C code, which is needed to be able to invoke it as a selector
//    @objc func imgAddPhotoTapped(sender: UITapGestureRecognizer){
//            // Create the action sheet
//            let myActionSheet = UIAlertController(title: "photo_selection".localized, message: "photo_selection_msg".localized, preferredStyle: UIAlertControllerStyle.actionSheet)
//
//            // blue action button
//            let cameraAction = UIAlertAction(title: "take_photo".localized, style: UIAlertActionStyle.default) { (action) in
//                if UIImagePickerController.isSourceTypeAvailable(.camera){
////                    print("Button capture")
//                    self.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
//                    self.imagePicker.sourceType = .camera
//                    self.imagePicker.allowsEditing = true
//                    self.present(self.imagePicker, animated: true, completion: nil)
//                }else{
//                    Utility.showAlertWithoutTitle(withMessage: "dontSupport".localized, withNavigation: self)
//                }
//            }
//
//            // red action button
//            let galleryAction = UIAlertAction(title: "choose_photo".localized, style: UIAlertActionStyle.default) { (action) in
//                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
////                    print("Button capture")
//                    self.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
//                    self.imagePicker.sourceType = .savedPhotosAlbum
//                    self.imagePicker.allowsEditing = true
//                    self.present(self.imagePicker, animated: true, completion: nil)
//                }else{
//                    Utility.showAlertWithoutTitle(withMessage: "dontSupport".localized, withNavigation: self)
//                }
//            }
//
//            // cancel action button
//            let cancelAction = UIAlertAction(title: "cancel".localized, style: UIAlertActionStyle.cancel) { (action) in
//                //                Utility.printToConsole(message:
//                print("Cancel action button tapped")
//            }
//
//            // add action buttons to action sheet
//            myActionSheet.addAction(cameraAction)
//            myActionSheet.addAction(galleryAction)
//            myActionSheet.addAction(cancelAction)
//
//            // support iPads (popover view)
//            myActionSheet.popoverPresentationController?.sourceView = self.imgAddPhoto
//            myActionSheet.popoverPresentationController?.sourceRect = self.imgAddPhoto.bounds
//
//            // present the action sheet
//            self.present(myActionSheet, animated: true, completion: nil)
//    }
//
//    //private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            self.imgView.contentMode = .scaleAspectFill
//            self.imgView.image = pickedImage
//        }
//        dismiss(animated: true, completion: nil)
//        //Signature
//        let imgData = UIImagePNGRepresentation(self.imgView.image!)
//        let strBase64 = imgData?.base64EncodedString(options: .lineLength64Characters)
//        self.dic["profilePic"] = strBase64 as AnyObject
//        //self.paramDic["profilePic"] = "asdfasdfasdfasdf" as AnyObject
//        self.dic["UserId"]  = Constants.loggedInMember?.userId as AnyObject
//        dic["deviceInfo"] = Utility.getDeviceInfo() as AnyObject
//        dic["appVersion"] = Utility.getAppVersion() as AnyObject
////        print(self.imgView.image?.size ?? "default value")
//        //print(self.paramDic)
//        Utility.shared.showSpinner()
//        ALFWebService.shared.doPostData(parameters: self.dic, method: Constants.apiUploadProfilePhoto, success: { (response) in
////            print(response)
//            Utility.shared.hideSpinner()
//            if let status = response["Status"] as? Int {
//                if status == 1 {
//                    //Success
//                } else if status == 3 {
//                    Utility.logout()
//                } else {
//                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: "failure".localized, withNavigation: self)
//                }
//            }else {
//                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
//            }
//        }) { (response) in
////            print(response)
//            Utility.shared.hideSpinner()
//            Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
    
}
