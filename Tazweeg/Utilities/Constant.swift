//
//  Constant.swift
//  Tazweeg
//
//  Created by iMac on 4/1/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit

struct Constants{
    static var dropDowns: DropDownFileds?
    static var loggedInMember : Member?
    //    static let apiSignup: String = "signupM"  //old
    //    static let apiGetStates: String = "statesM"
    static let apiGetCountries: String = "stateM/countryM"
    static let apiGetStates: String = "stateByID"
    static let apiSignup: String = "signupM/signUpNew"  //New
    static let apiSignupMobileVerification: String = "signupM/mobileVerification"
    static let apiCodeVerification: String = "signupM/1"
    static let apiLogin: String = "login"
    static let apiGetType: String = "type"
    static let apiGetConsultantsByState: String = "consultantByStateM"
    static let apiStep1: String = "memberMobile/1"
    static let apiStep2: String = "memberMobile/2"
    static let apiStep3: String = "memberMobile/3"
    static let apiStep4: String = "memberMobile/4"
    static let apiStep5: String = "memberMobile/5"
    static let apiStep6: String = "paymentM/"
    static let apiGetMatchings: String = "getData/matchingMembersByMemberIdM/"
    static let apiUploadProfilePhoto: String = "update/picMemberByIdM"
    static let apiGetMemberDetails: String = "getData/getMemberDetailByIdM/"
    static let apiChangePassword: String = "signupM/changePassword"
    static let apiGetConsultantMembers: String = "getData/membersByConsultantIdM/"
    static let apiForgotPassword: String = "forgotM"
    static let apiUpdateProfileStatus: String = "update/updateStatusM"
    static let apiTransferMember: String = "update/changeMembersConsultant"
    static let apiGetPaymentURL: String = "paymentM/"
    static let apiGetPaymentStatus: String = "paymentStatusM/"
    static let apiComment: String = "member/noteM"
    static let apiChangeMatchingsOrder: String = "update/memberPriority"
    static let apiDeleteMatching: String = "delete/memberPriority"
    static let apiSubmitMatching: String = "saveMemberChooseM"
    static let apiApproveMatching: String = "updateMemberAcceptedM"
    static let apiRefuseMatching: String = "updateMemberRefusalM"
    static let urlTermsAndConditionsEN: String = "https://www.tazweeg.ae/termsEN.html"
    static let urlTermsAndConditionsAR: String = "https://www.tazweeg.ae/termsAR.html"
    static let urlPrivacyPolicyEN: String = "https://www.tazweeg.ae/policyEN.html"
    static let urlPrivacyPolicyAR: String = "https://www.tazweeg.ae/policyAR.html"
    static let urlFrequentylAskedQuestionsEN: String = "https://www.tazweeg.ae/faqsEN.html"
    static let urlFrequentylAskedQuestionsAR: String = "https://www.tazweeg.ae/faqsAR.html"
    static let urlSnapChat: String  = "https://www.snapchat.com/add/bulahij"
    static let emailToRecepients: String = "app@tazweeg.com"
    static let phone: String = "+97126225889"
    static let urlFacebook: String = "https://www.facebook.com/tazweeguae/"
    static let urlTwitter: String = "https://twitter.com/tazweeg"
    static let urlPintrest: String = "https://www.pinterest.com/tazweeg/"
    static let urlInstagram: String = "https://www.instagram.com/tazweeg/"
    static let urlTelegram: String = "https://t.me/tazweeg"
    static let urlPaymentRedirect: String = "http://www.tazweeg.ae/matching/?ref="
    static let strIsFaceIDEnabled: String = "IsFaceIDEnabled"
    static let matchingList = "com.tazweeg.MatchingList"
    static let keychain = "com.tazweeg.tazweeg.matchingList" //remove digit while deploying
    static let purchased = "purchased"
    static let inAppProducts = "iAPProducts"    //used to store in user defaults
    static let defaultImage = "https://www.tazweeg.ae//assets/gender/office.png"
    static let pathCountriesFlag = "https://www.tazweeg.ae/assets/img/gcc/flags/"
}
