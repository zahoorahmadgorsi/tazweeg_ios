//
//  Member.swift
//  Tazweeg
//
//  Created by iMac on 4/27/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit

class Member : NSObject, NSCoding{
    
    //Merging Start
    var userId : Int!
    //    Step 1
    var code : String!
    var fullName : String!
    var phone : NSNumber!
    var email : String!
    var address : String!
    
    var countryId : Int!
    var countryEN : String!
    var countryAR : String!
    
    var stateId :Int!
    var stateEN : String!
    var stateAR : String!
    
    var family : String!
    var isFamilyShow : Bool?
    var birthPlace : String!
    var birthDate : Date!
    
    var genderId: Int!
    var genderEN : String!
    var genderAR : String!
    
    var residenceTypeId: Int!
    var residenceTypeEN : String!
    var residenceTypeAR : String!
    
    var ethnicityId: Int!
    var ethnicityEN : String!
    var ethnicityAR : String!
    
    var motherNationalityId: Int!
    var motherNationalityEN : String!
    var motherNationalityAR : String!
    //    Step 2
    var isPolygamy : Bool?
    
    var isSmokeId : Int!
    var isSmokeEN : String!
    var isSmokeAR : String!
    
    var skinColorId : Int!
    var skinColorEN : String!
    var skinColorAR : String!
    
    var hairColorId : Int!
    var hairColorEN : String!
    var hairColorAR : String!
    
    var hairTypeId : Int!
    var hairTypeEN : String!
    var hairTypeAR : String!
    
    var eyeColorId : Int!
    var eyeColorEN : String!
    var eyeColorAR : String!
    
    var heightId : Int!
    var heightEN : String!
    var heightAR : String!
    
    var bodyTypeId : Int!
    var bodyTypeEN : String!
    var bodyTypeAR : String!
    
    var bodyWeightId : Int!
    var bodyWeightEN : String!
    var bodyWeightAR : String!
    
    var sectId : Int!
    var sectEN : String!
    var sectAR : String!
    
    var licenseId : Int!
    var licenseIdEN: String!
    var licenseIdAR: String!
    
    var educationLevelId : Int!
    var educationLevelEN : String!
    var educationLevelAR : String!
    
    var religionCommitmentId : Int!
    var religionCommitmentEN : String!
    var religionCommitmentAR : String!
    
    var financialStatusId : Int!
    var financialStatusEN : String!
    var financialStatusAR : String!
    
    var socialStatusId : Int!
    var socialStatusEN : String!
    var socialStatusAR : String!
    
    var hasChildId: Int!
    var hasChildIdEN: String!
    var hasChildIdAR: String!
    
    var numberOfChildrenId: Int!
    var numberOfChildrenIdEN: String!
    var numberOfChildrenIdAR: String!
    
    var reproductionId: Int!
    var reproductionIdEN: String!
    var reproductionIdAR: String!
    
    var isWorkingId : Int!
    var isWorkingEN : String!
    var isWorkingAR : String!
    
    var jobTypeId : Int!
    var jobTypeEN : String!
    var jobTypeAR : String!
    
    var occupation : String!
    var jobTitle : String!
    
    var annualIncomeId : Int!
    var annualIncomeEN : String!
    var annualIncomeAR : String!
    
    var isDiseaseId : Int!
    var isDiseaseEN : String!
    var isDiseaseAR : String!
    
    var diseaseName : String!
    //Step 4
    var sBrideArrangmentId : Int!
    var sBrideArrangmentEN : String!
    var sBrideArrangmentAR : String!
    
    var sCountryId : Int!
    var sCountryEN : String!
    var sCountryAR : String!
    
    var sSocialStatusId : Int!
    var sSocialStatusEN : String!
    var sSocialStatusAR : String!
    var acceptDMW : Bool!
    
    var sHasChildId: Int!
    var sHasChildIdEN: String!
    var sHasChildIdAR: String!
    
    var sNoOfChildrenId : Int!
    var sNoOfChildrenEN : String!
    var sNoOfChildrenAR : String!
    
    var sReproductionId : Int!
    var sReproductionEN : String!
    var sReproductionAR : String!
    
    var sAgeId : Int!
    var sAgeEN : String!
    var sAgeAR : String!
    
    var sHeightId : Int!
    var sHeightEN : String!
    var sHeightAR : String!
    
    var sBodyTypeId : Int!
    var sBodyTypeEN : String!
    var sBodyTypeAR : String!
    
    var sSkinColorId : Int!
    var sSkinColorEN : String!
    var sSkinColorAR : String!
    
    var sEducationLevelId : Int!
    var sEducationLevelEN : String!
    var sEducationLevelAR : String!
    
    var sIsWorkingId : Int!
    var sIsWorkingEN : String!
    var sIsWorkingAR : String!
    
    var sJobTypeId : Int!
    var sJobTypeEN : String!
    var sJobTypeAR : String!
    
    var sVeilId : Int!
    var sVeilEN : String!
    var sVeilAR : String!
    
    var sDrivingLicenseId : Int!
    var sDrivingLicenseEN : String!
    var sDrivingLicenseAR : String!
    
    
    var willPayToBrideId : Int!
    var willPayToBrideEN : String!
    var willPayToBrideAR : String!
    
    var spouseStateToLiveId : Int!
    var spouseStateToLiveEN : String!
    var spouseStateToLiveAR : String!
    var GCCMarriage : Bool!
    
    //Step 5
    var hasRefer : Bool!
    var nameRefer : String!
    var mobileRefer : String!
    
    var firstRelative : String!
    var firstRelativeNumber : String!
    
    var firstRelativeRelationId : Int!
    var firstRelativeRelationEN : String!
    var firstRelativeRelationAR : String!
    
    var secondRelative : String!
    var secondRelativeNumber : String!
    
    var secondRelativeRelationId : Int!
    var secondRelativeRelationEN : String!
    var secondRelativeRelationAR : String!
    
    var applicantDescription : String!
    var languageIds : String!
    var signature : String!
    
    var imagePath : String?
    var consultantId : Int!
    
    var profileStatusEN : String!   //Incomplete, complete, pending, finished
    var profileStatusAR : String!   //Incomplete, complete, pending, finished
    //Merging End
    
    var typeId : Int!
    var emiratesIdNumber : String!

//    var jobTitleId : Int!
    var lookingForId : Int!
    var profileStatusId : Int!
    var mobileStatus : Int!
    var updatedAt : Date!
    var userUpdateId : Int!
    var consultantName : String!
    var consulantLastName : String!
    var cMobile : NSNumber?
    var matchCount : Int!
    var consultantStates : String!  // when member is logged in
    var emirateServeIn : String!    // when consultant is logged in
    var veilId : Int!
    var age : String!
    var lookForEN : String!
    var lookForAR : String!
    var isViewed : Bool?
    var ConsultantNote : String?
    var priorityId : Int?           //used in  member matching priority
    var matchStatusId : Int?        //choosing,matching,accepted or rejected
    var refusalReason : String?
    var isAttemptCompleted : Bool?
    var attempts : Int?         //number of matching attempts which got refused
    var refusedBy : Int?        //Which member refused this member ... if user refused the proposal himself then his own ID would be here else other memberid
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        //STEP 1
        userId = dictionary["userId"] as? Int
        if let val = dictionary["code"] as? String{         //at login
            code = val
        }else if let val = dictionary["username"] as? String{ //when getMemberDetailByIdM
            code = val
        }else if let val = dictionary["userName"] as? String{ //when matchingMembersByMemberIdM
            code = val
        }
        email = dictionary["email"] as? String
        genderId = dictionary["genderId"] as? Int
        genderEN = dictionary["genderEN"] as? String
        genderAR = dictionary["genderAR"] as? String
        phone = dictionary["phone"] as? NSNumber
        
        
        if let val = dictionary["fullName"] as? String{         //at login
            fullName = val
        }else if let val = dictionary["memberName"] as? String{ //when membersByConsultantIdM
            fullName = val
        }
        stateId = dictionary["stateId"] as? Int
        stateId = dictionary["statesId"] as? Int
        if let val = dictionary["stateId"] as? Int{         //at login
            stateId = val
        }else if let val = dictionary["statesId"] as? Int{ //when getmemberdetailbyidM
            stateId = val
        }
        stateEN = dictionary["stateEN"] as? String
        stateAR = dictionary["stateAR"] as? String
        
        typeId = dictionary["typeId"] as? Int
        address = dictionary["address"] as? String
        emiratesIdNumber = dictionary["emirateId"] as? String
        family = dictionary["family"] as? String
        isFamilyShow = dictionary["isFamilyShow"] as? Bool
        if let val = dictionary["birthDate"] as? String{
            birthDate = Utility.stringToDate(val, format: dateTimeFormat.fromServer.rawValue)
        }
        birthPlace = dictionary["birthPlace"] as? String
        countryId = dictionary["countryId"] as? Int
        countryEN = dictionary["countryEN"] as? String
        countryAR = dictionary["countryAR"] as? String
        residenceTypeId = dictionary["residenceTypeId"] as? Int
        residenceTypeEN = dictionary["residenceTypeEN"] as? String
        residenceTypeAR = dictionary["residenceTypeAR"] as? String
        ethnicityId = dictionary["ethnicityId"] as? Int
        ethnicityEN = dictionary["ethnicityEN"] as? String
        ethnicityAR = dictionary["ethnicityAR"] as? String
        motherNationalityId = dictionary["motherNationalityId"] as? Int
        motherNationalityEN = dictionary["motherNationalityEN"] as? String
        motherNationalityAR = dictionary["motherNationalityAR"] as? String
        //STEP 2
            occupation = dictionary["memberWorking"] as? String
            isSmokeId = dictionary["isSmokingId"] as? Int
        if let val = dictionary["isSmokingId"] as? Int{         //at login
            isSmokeId = val
        }else if let val = dictionary["isSmokeId"] as? Int{ //when getmemberdetailbyidM
            isSmokeId = val
        }
        isSmokeEN = dictionary["isSmokeEN"] as? String
        isSmokeAR = dictionary["isSmokeAR"] as? String
            skinColorId = dictionary["skinColorId"] as? Int
        skinColorEN = dictionary["skinColorEN"] as? String
        skinColorAR = dictionary["skinColorAR"] as? String
            hairColorId = dictionary["hairColorId"] as? Int
        hairColorEN = dictionary["hairColorEN"] as? String
        hairColorAR = dictionary["hairColorAR"] as? String
            eyeColorId = dictionary["eyeColorId"] as? Int
        eyeColorEN = dictionary["eyeColorEN"] as? String
        eyeColorAR = dictionary["eyeColorAR"] as? String
            heightId = dictionary["heightId"] as? Int
        heightEN = dictionary["heightEN"] as? String
        heightAR = dictionary["heightAR"] as? String
        
        bodyTypeId = dictionary["bodyTypeId"] as? Int
        bodyTypeEN = dictionary["bodyTypeEN"] as? String
        bodyTypeAR = dictionary["bodyTypeAR"] as? String
        
        bodyWeightId = dictionary["memberWeightId"] as? Int
        bodyWeightEN = dictionary["memberWeightEN"] as? String
        bodyWeightAR = dictionary["memberWeightAR"] as? String
        
        sectId = dictionary["sectTypeId"] as? Int
        sectEN = dictionary["sectEN"] as? String
        sectAR = dictionary["sectAR"] as? String
        
            educationLevelId = dictionary["educationLevelId"] as? Int
        educationLevelEN = dictionary["educationLevelEN"] as? String
        educationLevelAR = dictionary["educationLevelAR"] as? String
            religionCommitmentId = dictionary["religionCommitmentId"] as? Int
        religionCommitmentEN = dictionary["religionCommitmentEN"] as? String
        religionCommitmentAR = dictionary["religionCommitmentAR"] as? String
            financialStatusId = dictionary["financialStatusId"] as? Int
        financialStatusEN = dictionary["financialStatusEN"] as? String
        financialStatusAR = dictionary["financialStatusAR"] as? String
            socialStatusId = dictionary["socialStatusId"] as? Int
        socialStatusEN = dictionary["socialStatusEN"] as? String
        socialStatusAR = dictionary["socialStatusAR"] as? String
        if let val = dictionary["isWorkingId"] as? Int{         //at login
            isWorkingId = val
        }else if let val = dictionary["workStatusId"] as? Int{ //when getmemberdetailbyidM
            isWorkingId = val
        }
        isWorkingEN = dictionary["workStatusEN"] as? String
        isWorkingAR = dictionary["workStatusAR"] as? String
            jobTypeId = dictionary["jobTypeId"] as? Int
        jobTypeEN = dictionary["jobTypeEN"] as? String
        jobTypeAR = dictionary["jobTypeAR"] as? String
        occupation = dictionary["memberWorking"] as? String
        jobTitle = dictionary["jobTitle"] as? String
//            jobTitleId = dictionary["jobTitleId"] as? Int
            annualIncomeId = dictionary["annualIncomeId"] as? Int
        annualIncomeEN = dictionary["annualIncomeEN"] as? String
        annualIncomeAR = dictionary["annualIncomeAR"] as? String
        if let val = dictionary["anyDiseaseId"] as? Int{         //at login
            isDiseaseId = val
        }else if let val = dictionary["isDiseaseId"] as? Int{         //at getmemberdetailbyidM
            isDiseaseId = val
        }
        isDiseaseEN = dictionary["isDiseaseEN"] as? String
        isDiseaseAR = dictionary["isDiseaseAR"] as? String
        
            diseaseName = dictionary["diseaseName"] as? String
            lookingForId = dictionary["lookingForId"] as? Int

        sBrideArrangmentId = dictionary["sbrideArrangmentId"] as? Int
        sBrideArrangmentEN = dictionary["sbrideArrangmentEN"] as? String
        sBrideArrangmentAR = dictionary["sbrideArrangmentAR"] as? String

        if let val = dictionary["sNationalityId"] as? Int{         //at login
            sCountryId = val
        }else if let val = dictionary["sCountryId"] as? Int{         //at getmemberdetailbyidM
            sCountryId = val
        }
        sCountryEN = dictionary["sCountryEN"] as? String
        sCountryAR = dictionary["sCountryAR"] as? String
            sSocialStatusId = dictionary["sSocialStatusId"] as? Int
        sSocialStatusEN = dictionary["sSocialStatusEN"] as? String
        sSocialStatusAR = dictionary["sSocialStatusAR"] as? String
            sHasChildId = dictionary["sHasChildId"] as? Int
        sHasChildIdEN = dictionary["sHasChildIdEN"] as? String
        sHasChildIdAR = dictionary["sHasChildIdAR"] as? String
        if let val = dictionary["noOfChildrenId"] as? Int{         //at login
            sNoOfChildrenId = val
        }else if let val = dictionary["snoOfChildrenId"] as? Int{         //at getmemberdetailbyidM
            sNoOfChildrenId = val
        }
        sNoOfChildrenEN = dictionary["sNoOfChildrenEN"] as? String
        sNoOfChildrenAR = dictionary["sNoOfChildrenAR"] as? String
        if let val = dictionary["sReproductionId"] as? Int{         //at login
            sReproductionId = val
        }else if let val = dictionary["reproductionStatusId"] as? Int{         //at getmemberdetailbyidM
            sReproductionId = val
        }
        sReproductionEN = dictionary["reproductionStatusEN"] as? String
        sReproductionAR = dictionary["reproductionStatusAR"] as? String
            sIsWorkingId = dictionary["sIsWorkingId"] as? Int
        sIsWorkingEN = dictionary["sIsWorkingEN"] as? String
        sIsWorkingAR = dictionary["sIsWorkingAR"] as? String
            sAgeId = dictionary["sAgeId"] as? Int
        sAgeEN = dictionary["sAgeEN"] as? String
        sAgeAR = dictionary["sAgeAR"] as? String
            sHeightId = dictionary["sHeightId"] as? Int
        sHeightEN = dictionary["sHeightEN"] as? String
        sHeightAR = dictionary["sHeightAR"] as? String
            sBodyTypeId = dictionary["sBodyTypeId"] as? Int
        sBodyTypeEN = dictionary["sBodyTypeEN"] as? String
        sBodyTypeAR = dictionary["sBodyTypeAR"] as? String

            sSkinColorId = dictionary["sSkinColorId"] as? Int
        sSkinColorEN = dictionary["sSkinColorEN"] as? String
        sSkinColorAR = dictionary["sSkinColorAR"] as? String
            sEducationLevelId = dictionary["sEducationLevelId"] as? Int
        sEducationLevelEN = dictionary["sEducationLevelEN"] as? String
        sEducationLevelAR = dictionary["sEducationLevelAR"] as? String
        if let val = dictionary["sJobTypeId"] as? Int{         //at login
            sJobTypeId = val
        }else if let val = dictionary["sOccuptionId"] as? Int{         //at getmemberdetailbyidM
            sJobTypeId = val
        }
        sJobTypeEN = dictionary["sOccuptionEN"] as? String
        sJobTypeAR = dictionary["sOccuptionAR"] as? String
            sVeilId = dictionary["sCondemnBrideId"] as? Int
        sVeilEN = dictionary["sCondemnBrideEN"] as? String
        sVeilAR = dictionary["sCondemnBrideAR"] as? String
            sDrivingLicenseId = dictionary["sDrivingLicenseId"] as? Int
        sDrivingLicenseEN = dictionary["sDrivingLicenseEN"] as? String
        sDrivingLicenseAR = dictionary["sDrivingLicenseAR"] as? String
            willPayToBrideId = dictionary["sWillPayToBrideId"] as? Int
        willPayToBrideEN = dictionary["willPayToBrideEN"] as? String
        willPayToBrideAR = dictionary["willPayToBrideAR"] as? String
        if let val = dictionary["sRequiredStateId"] as? Int{         //at login
            spouseStateToLiveId = val
        }else if let val = dictionary["spouseStateToLiveId"] as? Int{         //at getmemberdetailbyidM
            spouseStateToLiveId = val
        }
        spouseStateToLiveEN = dictionary["spouseStateToLiveEN"] as? String
        spouseStateToLiveAR = dictionary["spouseStateToLiveAR"] as? String
        
            firstRelative = dictionary["firstRelative"] as? String
            firstRelativeNumber = dictionary["firstRelativeNumber"] as? String
            firstRelativeRelationId = dictionary["firstRelativeRelationId"] as? Int
        firstRelativeRelationEN = dictionary["firstRelativeRelationEN"] as? String
        firstRelativeRelationAR = dictionary["firstRelativeRelationAR"] as? String
        
            secondRelative = dictionary["secondRelative"] as? String
            secondRelativeNumber = dictionary["secondRelativeNumber"] as? String
            secondRelativeRelationId = dictionary["secondRelativeRelationId"] as? Int
        secondRelativeRelationEN = dictionary["secondRelativeRelationEN"] as? String
        secondRelativeRelationAR = dictionary["secondRelativeRelationAR"] as? String
        
            applicantDescription = dictionary["applicantDescription"] as? String
            languageIds = dictionary["languagesId"] as? String
        
        signature = dictionary["signature"] as? String
        profileStatusId = dictionary["paymentStatusId"] as? Int
        mobileStatus = dictionary["mobileStatus"] as? Int
        if (mobileStatus == 5
            && dictionary["paymentStatusId"] as? Int == profileStatusType.paid.rawValue){
            //Since we introduced 6th step of payment so handling it here
            //if server is sending mobile status as 5 but payment is already made then setting its status to 6
            mobileStatus = 6
        }
        
            hairTypeId = dictionary["hairTypeId"] as? Int
        hairTypeEN = dictionary["hairTypeEN"] as? String
        hairTypeAR = dictionary["hairTypeAR"] as? String
            updatedAt = dictionary["updatedAt"] as? Date
            userUpdateId = dictionary["userUpdateId"] as? Int
        if let val = dictionary["consulantName"] as? String{                //at login
            consultantName = val
        }else if let val = dictionary["consultant"] as? String{             //at getMembersByConsultantIDM
            consultantName = val
        }else if let val = dictionary["consultantName"] as? String{         //at getMemberdetailbyidM
            consultantName = val
        }
            consulantLastName = dictionary["consulantLastName"] as? String
            cMobile = dictionary[""] as? NSNumber ?? 0
        if let val = dictionary["cMobile"] as? NSNumber{                    //at login
            cMobile = val
        }else if let val = dictionary["consultantPhone"] as? NSNumber{      //at getMembersByConsultantIDM
            cMobile = val
        }else if let val = dictionary["conPhone"] as? NSNumber{         //at getMemberdetailbyidM
            cMobile = val
        }

        
        
        if let val = dictionary["consultantId"] as? Int{         //at login
            consultantId = val
        }else if let val = dictionary["conId"] as? Int{         //at getMembersByConsultantIDM
            consultantId = val
        }else if let val = dictionary["conUserId"] as? Int{         //at getMembersByConsultantIDM
            consultantId = val
        }
        if let val = dictionary["imagePath"] as? String{         //at login
            imagePath = val
        }else if let val = dictionary["image"] as? String{         //at getMembersByConsultantIDM
            imagePath = val
        }
        if let val = dictionary["paymentStatusEN"] as? String{         //at login
            profileStatusEN = val
        }else if let val = dictionary["statusEN"] as? String{         //at getmemberdetailbyidM
            profileStatusEN = val
        }else if let val = dictionary["paymentEN"] as? String{         //at membersByConsultantIdM
            profileStatusEN = val
        }
        if let val = dictionary["paymentStatusAR"] as? String{         //at login
            profileStatusAR = val
        }else if let val = dictionary["statusAR"] as? String{         //at getmemberdetailbyidM
            profileStatusAR = val
        }else if let val = dictionary["paymentAR"] as? String{         //at membersByConsultantIdM
            profileStatusAR = val
        }
            matchCount = dictionary["matchCount"] as? Int
            consultantStates = dictionary["consultantStates"] as? String
            emirateServeIn  = dictionary["emirateServeIn"] as? String
        
//            memberBridePositionId = dictionary["memberBridePositionId"] as? Int
        licenseId = dictionary["memberLicenseId"] as? Int
        licenseIdEN = dictionary["memberLicenseIdEN"] as? String
        licenseIdAR = dictionary["memberLicenseIdAR"] as? String
        hasChildId = dictionary["memberHasChildId"] as? Int
        hasChildIdEN = dictionary["memberHasChildIdEN"] as? String
        hasChildIdAR = dictionary["memberHasChildIdAR"] as? String
        reproductionId = dictionary["memberReproductionId"] as? Int
        reproductionIdEN = dictionary["memberReproductionIdEN"] as? String
        reproductionIdAR = dictionary["memberReproductionIdAR"] as? String
            veilId = dictionary["memberCondemnId"] as? Int
            numberOfChildrenId = dictionary["memberNoOfChildrenId"] as? Int
        numberOfChildrenIdEN = dictionary["memberNoOfChildrenIdEN"] as? String
        numberOfChildrenIdAR = dictionary["memberNoOfChildrenIdAR"] as? String
            isPolygamy = dictionary["isPolygamy"] as? Bool
//        Below parameters are for membersByConsultantIdM
        age = (dictionary["age"] as? String ?? "0" ) + " " + "years".localized
        lookForEN = dictionary["lookForEN"] as? String
        lookForAR = dictionary["lookForAR"] as? String
        isViewed = dictionary["isViewed"] as? Bool
        GCCMarriage = dictionary["GCCMarriage"] as? Bool
        acceptDMW = dictionary["acceptDMW"] as? Bool
        ConsultantNote = dictionary["ConsultantNote"] as? String
        if let val = dictionary["priorityId"] as? Int{
            priorityId = ( val == 0 ? Int.max : val)
        }
        if (dictionary["nameRefer"] as? String) != nil{
            hasRefer = true
        }else{
            hasRefer = false
        }
        nameRefer = dictionary["nameRefer"] as? String
        mobileRefer = dictionary["mobileRefer"] as? String
        
        matchStatusId = dictionary["matchStatusId"] as? Int
        refusalReason = dictionary["refusalReason"] as? String
        
        isAttemptCompleted = dictionary["isAttemptCompleted"] as? Bool
        attempts = dictionary["attempts"] as? Int
        refusedBy  = dictionary["refusedBy"] as? Int
    }
    

    
    func encode(with aCoder: NSCoder) {
        //STEP 1
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if genderId != nil{
            aCoder.encode(genderId, forKey: "genderId")
        }
        if phone != nil{
            aCoder.encode(phone, forKey: "phone")
        }
        if fullName != nil{
            aCoder.encode(fullName, forKey: "fullName")
        }
        if stateId != nil{
            aCoder.encode(stateId, forKey: "stateId")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if typeId != nil{
            aCoder.encode(typeId, forKey: "typeId")
        }
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if emiratesIdNumber != nil{
            aCoder.encode(emiratesIdNumber, forKey: "emirateId")
        }
        if family != nil{
            aCoder.encode(family, forKey: "family")
        }
        if isFamilyShow != nil{
            aCoder.encode(isFamilyShow, forKey: "isFamilyShow")
        }
        if birthDate != nil{
            aCoder.encode(birthDate, forKey: "birthDate")
        }
        if birthPlace != nil{
            aCoder.encode(birthPlace, forKey: "birthPlace")
        }
        if countryId != nil{
            aCoder.encode(countryId, forKey: "countryId")
        }
        //STEP 2
        if occupation != nil{
            aCoder.encode(occupation, forKey: "memberWorking")
        }
        if isSmokeId != nil{
            aCoder.encode(isSmokeId, forKey: "isSmokingId")
        }
        if skinColorId != nil{
            aCoder.encode(skinColorId, forKey: "skinColorId")
        }
        if hairColorId != nil{
            aCoder.encode(hairColorId, forKey: "hairColorId")
        }
        if eyeColorId != nil{
            aCoder.encode(eyeColorId, forKey: "eyeColorId")
        }
        if heightId != nil{
            aCoder.encode(heightId, forKey: "heightId")
        }
        if  bodyTypeId != nil{
            aCoder.encode(bodyTypeId, forKey: "bodyTypeId")
        }
        if  bodyWeightId != nil{
            aCoder.encode(bodyWeightId, forKey: "bodyWeightId")
        }

        if educationLevelId != nil{
            aCoder.encode(educationLevelId, forKey: "educationLevelId")
        }
        if religionCommitmentId != nil{
            aCoder.encode(religionCommitmentId, forKey: "religionCommitmentId")
        }
        if financialStatusId != nil{
            aCoder.encode(financialStatusId, forKey: "financialStatusId")
        }
        if socialStatusId != nil{
            aCoder.encode(socialStatusId, forKey: "socialStatusId")
        }
        if isWorkingId != nil{
            aCoder.encode(isWorkingId, forKey: "isWorkingId")
        }
        if jobTypeId != nil{
            aCoder.encode(jobTypeId, forKey: "jobTypeId")
        }
        if jobTitle != nil{
            aCoder.encode(jobTitle, forKey: "jobTitle")
        }
        if annualIncomeId != nil{
            aCoder.encode(annualIncomeId, forKey: "annualIncomeId")
        }
        if isDiseaseId != nil{
            aCoder.encode(isDiseaseId, forKey: "anyDiseaseId")
        }
        if diseaseName != nil{
            aCoder.encode(diseaseName, forKey: "diseaseName")
        }
        if lookingForId != nil{
            aCoder.encode(lookingForId, forKey: "lookingForId")
        }
        if sBrideArrangmentId != nil{
            aCoder.encode(sBrideArrangmentId, forKey: "sbrideArrangmentId")
        }
        if sCountryId != nil{
            aCoder.encode(sCountryId, forKey: "sNationalityId")
        }
        
        if sHasChildId != nil{
            aCoder.encode(sHasChildId, forKey: "sHasChildId")
        }
        if sNoOfChildrenId != nil{
            aCoder.encode(sNoOfChildrenId, forKey: "sNoOfChildrenId")
        }
        if sReproductionId != nil{
            aCoder.encode(sReproductionId, forKey: "sReproductionId")
        }
        if sSocialStatusId != nil{
            aCoder.encode(sSocialStatusId, forKey: "sSocialStatusId")
        }
        if sIsWorkingId != nil{
            aCoder.encode(sIsWorkingId, forKey: "sIsWorkingId")
        }
        if sAgeId != nil{
            aCoder.encode(sAgeId, forKey: "sAgeId")
        }
        if sHeightId != nil{
            aCoder.encode(sHeightId, forKey: "sHeightId")
        }
        if sBodyTypeId != nil{
            aCoder.encode(sBodyTypeId, forKey: "sBodyTypeId")
        }
        if sSkinColorId != nil{
            aCoder.encode(sSkinColorId, forKey: "sSkinColorId")
        }
        if sEducationLevelId != nil{
            aCoder.encode(sEducationLevelId, forKey: "sEducationLevelId")
        }
        if sJobTypeId != nil{
            aCoder.encode(sJobTypeId, forKey: "sJobTypeId")
        }
        if sVeilId != nil{
            aCoder.encode(sVeilId, forKey: "sCondemnBrideId")
        }
        if sDrivingLicenseId != nil{
            aCoder.encode(sDrivingLicenseId, forKey: "sDrivingLicenseId")
        }
        if willPayToBrideId != nil{
            aCoder.encode(willPayToBrideId, forKey: "sWillPayToBrideId")
        }

        if spouseStateToLiveId != nil{
            aCoder.encode(spouseStateToLiveId, forKey: "sRequiredStateId")
        }
        if firstRelative != nil{
            aCoder.encode(firstRelative, forKey: "firstRelative")
        }
        if firstRelativeNumber != nil{
            aCoder.encode(firstRelativeNumber, forKey: "firstRelativeNumber")
        }
        if firstRelativeRelationId != nil{
            aCoder.encode(firstRelativeRelationId, forKey: "firstRelativeRelationId")
        }
        if secondRelative != nil{
            aCoder.encode(secondRelative, forKey: "secondRelative")
        }
        if secondRelativeNumber != nil{
            aCoder.encode(secondRelativeNumber, forKey: "secondRelativeNumber")
        }
        if secondRelativeRelationId != nil{
            aCoder.encode(secondRelativeRelationId, forKey: "secondRelativeRelationId")
        }
        if applicantDescription != nil{
            aCoder.encode(applicantDescription, forKey: "applicantDescription")
        }
        if languageIds != nil{
            aCoder.encode(languageIds, forKey: "languagesId")
        }
        if profileStatusId != nil{
            aCoder.encode(profileStatusId, forKey: "paymentStatusId")
        }
        if signature != nil{
            aCoder.encode(signature, forKey: "signature")
        }
        if mobileStatus != nil{
            aCoder.encode(mobileStatus, forKey: "mobileStatus")
        }
        if sectId != nil{
            aCoder.encode(sectId, forKey: "sectTypeId")
        }
        if hairTypeId != nil{
            aCoder.encode(hairTypeId, forKey: "hairTypeId")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        if userUpdateId != nil{
            aCoder.encode(userUpdateId, forKey: "userUpdateId")
        }
        if consultantName != nil{
            aCoder.encode(consultantName, forKey: "consulantName")
        }
        if consulantLastName != nil{
            aCoder.encode(consulantLastName, forKey: "consulantLastName")
        }
        if consultantId != nil{
            aCoder.encode(consultantId, forKey: "conUserId")
        }
        if cMobile != 0{
            aCoder.encode(cMobile, forKey: "cMobile")
        }
        if imagePath != nil{
            aCoder.encode(imagePath, forKey: "imagePath")
        }

        if profileStatusEN != nil{
            aCoder.encode(profileStatusEN, forKey: "statusEN")
        }
        if profileStatusAR != nil{
            aCoder.encode(profileStatusAR, forKey: "statusAR")
        }
        if matchCount != nil{
            aCoder.encode(matchCount, forKey: "matchCount")
        }
        if consultantStates != nil{
            aCoder.encode(consultantStates, forKey: "consultantStates")
        }

        if emirateServeIn != nil{
            aCoder.encode(emirateServeIn, forKey: "emirateServeIn")
        }
        if licenseId != nil{
            aCoder.encode(licenseId, forKey: "memberLicenseId")
        }
        if hasChildId != nil{
            aCoder.encode(hasChildId, forKey: "memberHasChildId")
        }
        if reproductionId != nil{
            aCoder.encode(reproductionId, forKey: "memberReproductionId")
        }
        if veilId != nil{
            aCoder.encode(veilId, forKey: "memberCondemnId")
        }
        if numberOfChildrenId != nil{
            aCoder.encode(numberOfChildrenId, forKey: "memberNoOfChildrenId")
        }
        if isPolygamy != nil{
            aCoder.encode(isPolygamy, forKey: "isPolygamy")
        }
        
        if residenceTypeId != nil{
            aCoder.encode(residenceTypeId, forKey: "residenceTypeId")
        }
        if ethnicityId != nil{
            aCoder.encode(ethnicityId, forKey: "ethnicityId")
        }
        if motherNationalityId != nil{
            aCoder.encode(motherNationalityId, forKey: "motherNationalityId")
        }
        
        if GCCMarriage != nil{
            aCoder.encode(GCCMarriage, forKey: "GCCMarriage")
        }
        if acceptDMW != nil{
           aCoder.encode(acceptDMW, forKey: "acceptDMW")
        }
        if ConsultantNote != nil{
            aCoder.encode(ConsultantNote, forKey: "ConsultantNote")
        }
        if priorityId != nil{
            aCoder.encode(priorityId, forKey: "priorityId")
        }
        if hasRefer != nil{
            aCoder.encode(hasRefer, forKey: "hasRefer")
        }
        if nameRefer != nil{
            aCoder.encode(nameRefer, forKey: "nameRefer")
        }
        if mobileRefer != nil{
            aCoder.encode(mobileRefer, forKey: "mobileRefer")
        }

        if matchStatusId != nil{
            aCoder.encode(matchStatusId, forKey: "matchStatusId")
        }
        if refusalReason != nil{
            aCoder.encode(refusalReason, forKey: "refusalReason")
        }
        if isAttemptCompleted != nil{
            aCoder.encode(isAttemptCompleted, forKey: "isAttemptCompleted")
        }
        if attempts != nil{
            aCoder.encode(attempts, forKey: "attempts")
        }
        if refusedBy != nil{
            aCoder.encode(refusedBy, forKey: "refusedBy")
        }
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */

    required init?(coder aDecoder: NSCoder) {
        userId = aDecoder.decodeObject(forKey: "userId") as? Int
        email = aDecoder.decodeObject(forKey: "email") as? String
        genderId = aDecoder.decodeObject(forKey: "genderId") as? Int
        phone = aDecoder.decodeObject(forKey: "phone") as? NSNumber
        fullName = aDecoder.decodeObject(forKey: "fullName") as? String
        stateId = aDecoder.decodeObject(forKey: "stateId") as? Int
        code = aDecoder.decodeObject(forKey: "code") as? String
        typeId = aDecoder.decodeObject(forKey: "typeId") as? Int
        address = aDecoder.decodeObject(forKey: "address") as? String
        emiratesIdNumber = aDecoder.decodeObject(forKey: "emirateId") as? String
        family = aDecoder.decodeObject(forKey: "family") as? String
        isFamilyShow = aDecoder.decodeObject(forKey: "isFamilyShow") as? Bool
        birthDate = aDecoder.decodeObject(forKey: "birthDate") as? Date
        birthPlace = aDecoder.decodeObject(forKey: "birthPlace") as? String
        countryId = aDecoder.decodeObject(forKey: "countryId") as? Int
        occupation = aDecoder.decodeObject(forKey: "memberWorking") as? String
        isSmokeId = aDecoder.decodeObject(forKey: "isSmokingId") as? Int
        skinColorId = aDecoder.decodeObject(forKey: "skinColorId") as? Int
        hairColorId = aDecoder.decodeObject(forKey: "hairColorId") as? Int
        eyeColorId = aDecoder.decodeObject(forKey: "eyeColorId") as? Int
        heightId = aDecoder.decodeObject(forKey: "heightId") as? Int
        bodyTypeId = aDecoder.decodeObject(forKey: "bodyTypeId") as? Int
        bodyWeightId = aDecoder.decodeObject(forKey: "bodyWeightId") as? Int
        educationLevelId = aDecoder.decodeObject(forKey: "educationLevelId") as? Int
        religionCommitmentId = aDecoder.decodeObject(forKey: "religionCommitmentId") as? Int
        financialStatusId = aDecoder.decodeObject(forKey: "financialStatusId") as? Int
        socialStatusId = aDecoder.decodeObject(forKey: "socialStatusId") as? Int
        isWorkingId = aDecoder.decodeObject(forKey: "isWorkingId") as? Int
        jobTypeId = aDecoder.decodeObject(forKey: "jobTypeId") as? Int
        jobTitle = aDecoder.decodeObject(forKey: "jobTitle") as? String
        annualIncomeId = aDecoder.decodeObject(forKey: "annualIncomeId") as? Int
        isDiseaseId = aDecoder.decodeObject(forKey: "anyDiseaseId") as? Int
        diseaseName = aDecoder.decodeObject(forKey: "diseaseName") as? String
        lookingForId = aDecoder.decodeObject(forKey: "lookingForId") as? Int
        sBrideArrangmentId = aDecoder.decodeObject(forKey: "sbrideArrangmentId") as? Int
        sCountryId = aDecoder.decodeObject(forKey: "sNationalityId") as? Int
        sHasChildId = aDecoder.decodeObject(forKey: "sHasChildId") as? Int
        sNoOfChildrenId = aDecoder.decodeObject(forKey: "sNoOfChildrenId") as? Int
        sReproductionId = aDecoder.decodeObject(forKey: "sReproductionId") as? Int
        sSocialStatusId = aDecoder.decodeObject(forKey: "sSocialStatusId") as? Int
        sIsWorkingId = aDecoder.decodeObject(forKey: "sIsWorkingId") as? Int
        sAgeId = aDecoder.decodeObject(forKey: "sAgeId") as? Int
        sHeightId = aDecoder.decodeObject(forKey: "sHeightId") as? Int
        sBodyTypeId = aDecoder.decodeObject(forKey: "sBodyTypeId") as? Int
        sSkinColorId = aDecoder.decodeObject(forKey: "sSkinColorId") as? Int
        sEducationLevelId = aDecoder.decodeObject(forKey: "sEducationLevelId") as? Int
        sJobTypeId = aDecoder.decodeObject(forKey: "sJobTypeId") as? Int
        sVeilId = aDecoder.decodeObject(forKey: "sCondemnBrideId") as? Int
        sDrivingLicenseId = aDecoder.decodeObject(forKey: "sDrivingLicenseId") as? Int
        willPayToBrideId = aDecoder.decodeObject(forKey: "sWillPayToBrideId") as? Int
        spouseStateToLiveId = aDecoder.decodeObject(forKey: "sRequiredStateId") as? Int
        firstRelative = aDecoder.decodeObject(forKey: "firstRelative") as? String
        firstRelativeNumber = aDecoder.decodeObject(forKey: "firstRelativeNumber") as? String
        firstRelativeRelationId = aDecoder.decodeObject(forKey: "firstRelativeRelationId") as? Int
        secondRelative = aDecoder.decodeObject(forKey: "secondRelative") as? String
        secondRelativeNumber = aDecoder.decodeObject(forKey: "secondRelativeNumber") as? String
        secondRelativeRelationId = aDecoder.decodeObject(forKey: "secondRelativeRelationId") as? Int
        applicantDescription = aDecoder.decodeObject(forKey: "applicantDescription") as? String
        languageIds = aDecoder.decodeObject(forKey: "languagesId") as? String
        profileStatusId = aDecoder.decodeObject(forKey: "paymentStatusId") as? Int
        signature = aDecoder.decodeObject(forKey: "signature") as? String
        mobileStatus = aDecoder.decodeObject(forKey: "mobileStatus") as? Int
        sectId = aDecoder.decodeObject(forKey: "sectTypeId") as? Int
        hairTypeId = aDecoder.decodeObject(forKey: "hairTypeId") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date
        userUpdateId = aDecoder.decodeObject(forKey: "userUpdateId") as? Int
        consultantName = aDecoder.decodeObject(forKey: "consulantName") as? String
        consulantLastName = aDecoder.decodeObject(forKey: "consulantLastName") as? String
        consultantId = aDecoder.decodeObject(forKey: "conUserId") as? Int
        cMobile = aDecoder.decodeObject(forKey: "cMobile") as? NSNumber ?? 0
        imagePath = aDecoder.decodeObject(forKey: "imagePath") as? String
        profileStatusEN = aDecoder.decodeObject(forKey: "statusEN") as? String
        profileStatusAR = aDecoder.decodeObject(forKey: "statusAR") as? String
        matchCount = aDecoder.decodeObject(forKey: "matchCount") as? Int
        consultantStates = aDecoder.decodeObject(forKey: "consultantStates") as? String //for  member. when member is logged in
        emirateServeIn = aDecoder.decodeObject(forKey: "emirateServeIn") as? String //for consultant. when consultant is logged in
        
//        memberBridePositionId = aDecoder.decodeObject(forKey: "memberBridePositionId") as? Int
        licenseId = aDecoder.decodeObject(forKey: "memberLicenseId") as? Int
        hasChildId = aDecoder.decodeObject(forKey: "memberHasChildId") as? Int
        reproductionId = aDecoder.decodeObject(forKey: "memberReproductionId") as? Int
        veilId = aDecoder.decodeObject(forKey: "memberCondemnId") as? Int
        numberOfChildrenId = aDecoder.decodeObject(forKey: "memberNoOfChildrenId") as? Int
        isPolygamy = aDecoder.decodeObject(forKey: "isPolygamy") as? Bool
    
        residenceTypeId = aDecoder.decodeObject(forKey: "residenceTypeId") as? Int
        ethnicityId = aDecoder.decodeObject(forKey: "ethnicityId") as? Int
        motherNationalityId = aDecoder.decodeObject(forKey: "motherNationalityId") as? Int
        GCCMarriage = aDecoder.decodeObject(forKey: "GCCMarriage") as? Bool
        acceptDMW = aDecoder.decodeObject(forKey: "acceptDMW") as? Bool
        ConsultantNote = aDecoder.decodeObject(forKey: "ConsultantNote") as? String
        priorityId = aDecoder.decodeObject(forKey: "priorityId") as? Int
        
        hasRefer = aDecoder.decodeObject(forKey: "hasRefer") as? Bool
        nameRefer = aDecoder.decodeObject(forKey: "nameRefer") as? String
        mobileRefer = aDecoder.decodeObject(forKey: "mobileRefer") as? String
        
        matchStatusId = aDecoder.decodeObject(forKey: "matchStatusId") as? Int
        refusalReason = aDecoder.decodeObject(forKey: "refusalReason") as? String
        isAttemptCompleted  = aDecoder.decodeObject(forKey: "isAttemptCompleted") as? Bool
        attempts = aDecoder.decodeObject(forKey: "attempts") as? Int
        refusedBy  = aDecoder.decodeObject(forKey: "refusedBy") as? Int
    }
}
