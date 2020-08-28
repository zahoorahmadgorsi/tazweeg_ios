//
//  AppStoryboards.swift
//  Workshop2u
//
//  Created by Waqas Ali on 11/20/16.
//  Copyright © 2016 Dinosoftlabs. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    //MARK:- Generic Public/Instance Methods
    
    func loadViewController(withIdentifier identifier: viewControllers) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }
    
    //MARK:- Class Methods to load Storyboards
    
    class func storyBoard(withName name: storyboards) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue , bundle: Bundle.main)
    }
    
    class func storyBoard(withTextName name:String) -> UIStoryboard {
        return UIStoryboard(name: name , bundle: Bundle.main)
    }
    
}

enum storyboards : String {
    case main = "Main"
}

enum viewControllers: String {
    //Main Storyboard
    case
    loginVC = "LoginVC",
    phoneVC = "PhoneVC",
    countriesVC = "CountriesVC",
    slideMenuVC = "SlideMenuVC",
    profileDetailVC = "ProfileDetailVC",
    matchingMemberVC = "MatchingMemberVC",
    signUpVC1 = "SignUpVC1",
    signUpVC2 = "SignUpVC2",
    signUpVC3 = "SignUpVC3",
    signUpVC4 = "SignUpVC4",
    signUpVC5 = "SignUpVC5",
    signUpVC6 = "SignUpVC6",
    webViewVC = "WebViewVC",
    changePassVC = "ChangePassVC"
    ,userSelectionVC = "UserSelectionVC"
    ,profileVC = "ProfileVC"
    ,membersVC = "MembersVC"
    ,matchingsVC = "MatchingsVC"
    ,statesAndConsultantsVC = "StatesAndConsultantsVC"
    ,commonSignUpVC = "CommonSignUpVC"
    ,otpVerificationVC = "OTPVerificationVC"
    ,changeLanguageVC = "ChangeLanguageVC"
    ,changeLaunchIconVC = "ChangeLaunchIconVC"
    ,forgotPasswordVC = "ForgotPasswordVC"
    ,settingsVC = "SettingsVC"
    ,contactUsVC = "ContactUsVC"
    ,helpVC = "HelpVC"
    ,groupedSettingsVC = "GroupedSettingsVC"
}
