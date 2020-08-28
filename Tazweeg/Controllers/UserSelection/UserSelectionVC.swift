//
//  UserSelection.swift
//  Tazweeg
//
//  Created by Ahmed on 3/24/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH
import EAIntroView

class UserSelectionVC: UIViewController {
    //MARK:- Custom Vars
    var localize: Localize?
    var  myHeightFraction:CGFloat = 0.075   //7.5 % of height
    @IBOutlet weak var viewLanguage: WAView!
    @IBOutlet weak var lblAccountNeedTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var svSignUpTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var langViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgSnapChatTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgSnapBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var uiView: UIView!
    
    @IBOutlet weak var btnMember: UIButton!
    @IBOutlet weak var btnConsultant: UIButton!
    @IBOutlet weak var btnMemberSignup: UIButton!
    @IBOutlet weak var btnConsultantSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the background image of view controller
        self.view.layer.contents = UIImage(named: "bg-1")?.cgImage //#imageLiteral(resourceName: "bg").cgImage
        if (MOLHLanguage.isRTLLanguage()){
            btnMember.setBackgroundImage(UIImage(named: "member_button_ar"), for: .normal)
            btnConsultant.setBackgroundImage(UIImage(named: "consultant_button_ar"), for: .normal)
            btnMemberSignup.setBackgroundImage(UIImage(named: "member_sign up_ar"), for: .normal)
            btnConsultantSignup.setBackgroundImage(UIImage(named: "consultant_sign up_ar"), for: .normal)
        }
        //If user is not logged in then show the introduction
        if ( Utility.isLoggedIn() == false) {//Introduction start
            let page1 : EAIntroPage = EAIntroPage.init()
            let page2 : EAIntroPage = EAIntroPage.init()
            let page3 : EAIntroPage = EAIntroPage.init()
            let page4 : EAIntroPage = EAIntroPage.init()
            let page5 : EAIntroPage = EAIntroPage.init()
            let page6 : EAIntroPage = EAIntroPage.init()
            let page7 : EAIntroPage = EAIntroPage.init()
            let page8 : EAIntroPage = EAIntroPage.init()
            let page9 : EAIntroPage = EAIntroPage.init()
            let page10 : EAIntroPage = EAIntroPage.init()
            let page11 : EAIntroPage = EAIntroPage.init()
            let page12 : EAIntroPage = EAIntroPage.init()
            let page13 : EAIntroPage = EAIntroPage.init()
            let page14 : EAIntroPage = EAIntroPage.init()
            
            if(MOLHLanguage.currentAppleLanguage() == "ar"){
                page1.bgImage = UIImage(named: "intro_ar_01")
                page2.bgImage = UIImage(named: "intro_ar_02")
                page3.bgImage = UIImage(named: "intro_ar_03")
                page4.bgImage = UIImage(named: "intro_ar_04")
                page5.bgImage = UIImage(named: "intro_ar_05")
                page6.bgImage = UIImage(named: "intro_ar_06")
                page7.bgImage = UIImage(named: "intro_ar_07")
                page8.bgImage = UIImage(named: "intro_ar_08")
                page9.bgImage = UIImage(named: "intro_ar_09")
                page10.bgImage = UIImage(named: "intro_ar_10")
                page11.bgImage = UIImage(named: "intro_ar_11")
                page12.bgImage = UIImage(named: "intro_ar_12")
                page13.bgImage = UIImage(named: "intro_ar_13")
                page14.bgImage = UIImage(named: "intro_ar_14")
            }else{
                page1.bgImage = UIImage(named: "intro_en_01")
                page2.bgImage = UIImage(named: "intro_en_02")
                page3.bgImage = UIImage(named: "intro_en_03")
                page4.bgImage = UIImage(named: "intro_en_04")
                page5.bgImage = UIImage(named: "intro_en_05")
                page6.bgImage = UIImage(named: "intro_en_06")
                page7.bgImage = UIImage(named: "intro_en_07")
                page8.bgImage = UIImage(named: "intro_en_08")
                page9.bgImage = UIImage(named: "intro_en_09")
                page10.bgImage = UIImage(named: "intro_en_10")
                page11.bgImage = UIImage(named: "intro_en_11")
                page12.bgImage = UIImage(named: "intro_en_12")
                page13.bgImage = UIImage(named: "intro_en_13")
                page14.bgImage = UIImage(named: "intro_en_14")
        }
        
        let intro : EAIntroView = EAIntroView.init(frame: self.view.bounds, andPages: [page1,page2,page3,page4,page5,page6,page7,page8,page9,page10,page11,page12,page13,page14])
        intro.delegate = self as? EAIntroDelegate
        intro.bgViewContentMode = .scaleAspectFit
        intro.show(in: self.view, animateDuration: 0.0)  
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lblAccountNeedTopConstraint.constant = myHeightFraction * uiView.frame.height - 10
        svSignUpTopConstraint.constant = myHeightFraction * uiView.frame.height - 20
        langViewTopConstraint.constant = myHeightFraction * uiView.frame.height
        imgSnapChatTopConstraint.constant = myHeightFraction * uiView.frame.height
        imgSnapBottomConstraint.constant = myHeightFraction * uiView.frame.height
        viewLanguage.cornerRadius = viewLanguage.frame.height/2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    class func reloadController(){
    }
    
    @IBAction func btnLanguageTapped(_ sender: Any) {
        let btn = sender as! UIButton
        switch(btn.tag){
        case 0: //English
            if(MOLHLanguage.currentAppleLanguage() != "en")
            {
                MOLH.setLanguageTo("en")
                MOLH.reset()
            }
            break
        case 1: //Arabic
            if(MOLHLanguage.currentAppleLanguage() != "ar")
            {
                MOLH.setLanguageTo("ar")
                MOLH.reset()
            }
            break
        default:
            break
        }
    }
    
//    Added @objg to suppress the error "Argument of '#selector' refers to instance method 'usersSVTapped(sender:)' that is not exposed to Objective-C"
//    and Because in Swift 4, functions are no longer implicitly exposed to Objective-C code, which is needed to be able to invoke it as a selector
    
    @IBAction func btnUserTapped(_ sender: Any) {
        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .loginVC) as! LoginVC
        
        let sv = sender as! UIButton
        if (sv.tag == 0){
            UserDefaults.standard.set(UserType.member.rawValue, forKey: "currentUser")
        }
        else if (sv.tag == 1)
        {
            UserDefaults.standard.set(UserType.consultant.rawValue, forKey: "currentUser")
        }
        //Displaying modally
        let viewControllerNav = UINavigationController(rootViewController: viewController)
        self.present(viewControllerNav, animated:true, completion:nil)
    }
    
    @IBAction func btnSnapChatTapped(_ sender: Any) {
        guard let url = URL(string: Constants.urlSnapChat) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
        }
    }
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        let sv = sender as! UIButton
        if (sv.tag == 0){
        UserDefaults.standard.set(UserType.member.rawValue, forKey: "currentUser")
        }
        else if (sv.tag == 1){
            UserDefaults.standard.set(UserType.consultant.rawValue, forKey: "currentUser")
        }
        let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .phoneVC) as! PhoneVC
        let viewControllerNav = UINavigationController(rootViewController: viewController)
        self.present(viewControllerNav, animated:true, completion:nil)
    }
    
    
}

