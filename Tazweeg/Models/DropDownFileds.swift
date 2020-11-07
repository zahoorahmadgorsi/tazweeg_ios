//
//  DropDownFileds.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 31/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit

class DropDownFileds: NSObject, NSCoding{
    //Signup
    var gender = [Dictionary<String,AnyObject>]()   //Used on common signup
    //Step 1
    var title = [Dictionary<String,AnyObject>]()    //no more used
    var countries = [Dictionary<String,AnyObject>]()
    var states = [Dictionary<String,AnyObject>]()
    var residenceType = [Dictionary<String,AnyObject>]()
    var ethnicity = [Dictionary<String,AnyObject>]()
    //Step 2
    var sectType = [Dictionary<String,AnyObject>]()
    var isSmoking = [Dictionary<String,AnyObject>]()    //Used on Step2
    var skinColor = [Dictionary<String,AnyObject>]()    //Used on Step2
    var hairColor = [Dictionary<String,AnyObject>]()    //Used on Step2
    var eyeColor = [Dictionary<String,AnyObject>]()    //Used on Step2
    var height = [Dictionary<String,AnyObject>]()
    var bodyType = [Dictionary<String,AnyObject>]()
    var bodyWeight = [Dictionary<String,AnyObject>]()
    var hairType = [Dictionary<String,AnyObject>]()    //Used on Step2
    var brideArrangement = [Dictionary<String,AnyObject>]()
    var veil = [Dictionary<String,AnyObject>]()
    var hasLicense = [Dictionary<String,AnyObject>]()    //Used on Step2
    //Step 3
    
    var educationLevel = [Dictionary<String,AnyObject>]()
    var religionCommitment = [Dictionary<String,AnyObject>]()
    var financialCondition = [Dictionary<String,AnyObject>]()
    var socialStatus = [Dictionary<String,AnyObject>]()
    var hasChildren = [Dictionary<String,AnyObject>]()
    var numberOfChildren = [Dictionary<String,AnyObject>]()
    var reproduction = [Dictionary<String,AnyObject>]()
//    var occupation = [Dictionary<String,AnyObject>]()
    var isWorking = [Dictionary<String,AnyObject>]()
    var jobType = [Dictionary<String,AnyObject>]()
//    var jobTitle = [Dictionary<String,AnyObject>]()
    var annualIncome = [Dictionary<String,AnyObject>]()
    var anyDisease = [Dictionary<String,AnyObject>]()
    
    //Step 4
    var requiredAge = [Dictionary<String,AnyObject>]()
    var willPayToBride = [Dictionary<String,AnyObject>]()
    //Step 5
    var languages = [Dictionary<String,AnyObject>]()
    var relationship = [Dictionary<String,AnyObject>]()
//    var lookingFor = [Dictionary<String,AnyObject>]()
    
    
    
    
    var brideDowry = [Dictionary<String,AnyObject>]()
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [Dictionary<String,AnyObject>]){
        for dict in dictionary {
            // SignUp
            if let val = dict["Gender_Type"] {
                gender = (val as? [Dictionary<String,AnyObject>])!
            }
            // Step 1
            else if let val = dict["Title"] {
                title = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Countries"] {
                countries = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["States"] {
                states = (val as? [Dictionary<String,AnyObject>])!
            }
            // Step 2
            else if let val = dict["Sect_Type"] {
                sectType = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Is_Smoking"] {
                isSmoking = (val as? [Dictionary<String,AnyObject>])!
                hasLicense = (val as? [Dictionary<String,AnyObject>])!
                hasChildren = (val as? [Dictionary<String,AnyObject>])!
                anyDisease = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Skin_Color"] {
                skinColor = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Hair_Color"] {
                hairColor = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Eye_Color"] {
                eyeColor = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Hair_Type"] {
                hairType = (val as? [Dictionary<String,AnyObject>])!
            }
            // Step 3
            else if let val = dict["Height"] {
                height = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Body_Type"] {
                bodyType = (val as? [Dictionary<String,AnyObject>])!
            }else if let val = dict["weight"] {
                bodyWeight = (val as? [Dictionary<String,AnyObject>])!
            }else if let val = dict["Education_Level"] {
                educationLevel = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Religion_Commitment"] {
                religionCommitment = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Financial_Condition"] {
                financialCondition = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Social_Status"] {
                socialStatus = (val as? [Dictionary<String,AnyObject>])!
            }
//            else if let val = dict["Working"] {
//                occupation = (val as? [Dictionary<String,AnyObject>])!
//            }
            else if let val = dict["Is_Working"] {
                isWorking = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Job_Type"] {
                jobType = (val as? [Dictionary<String,AnyObject>])!
            }
//            else if let val = dict["Job_Title"] {
//                jobTitle = (val as? [Dictionary<String,AnyObject>])!
//            }
            else if let val = dict["Annual_Income"] {
                annualIncome = (val as? [Dictionary<String,AnyObject>])!
            }
//            else if let val = dict["Disease_Name"] {
//                anyDisease = (val as? [Dictionary<String,AnyObject>])!
//            }
            else if let val = dict["Bride_Arrangement"] {
                brideArrangement = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["NoOfChildren"] {
                numberOfChildren = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Infertility"] {
                reproduction = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Age"] {
                requiredAge = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["CondemningBride"] {
                veil = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["License"] {
                hasLicense = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["willPayToBride"] {
                willPayToBride = (val as? [Dictionary<String,AnyObject>])!
            }
            //Step 5
            else if let val = dict["Relation"] {
                relationship = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["Languages"] {
                languages = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["residenceType"] {
                residenceType = (val as? [Dictionary<String,AnyObject>])!
            }
            else if let val = dict["ethnicity"] {
                ethnicity = (val as? [Dictionary<String,AnyObject>])!
            }
        }
    }
    

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if annualIncome.count == 0 {
            dictionary["annual_income"] = annualIncome
        }
        if anyDisease.count == 0 {
            dictionary["any_disease"] = anyDisease
        }
        if height.count == 0 {
            dictionary["body_height"] = height
        }
        if bodyType.count == 0 {
            dictionary["body_type"] = bodyType
        }
        if bodyWeight.count == 0 {
            dictionary["weight"] = bodyWeight
        }
        if brideDowry.count == 0 {
            dictionary["bride_dowry"] = brideDowry
        }
        if brideArrangement.count == 0 {
            dictionary["bride_position"] = brideArrangement
        }
        if veil.count == 0 {
            dictionary["condemning_bride"] = veil
        }
        if countries.count == 0 {
            dictionary["countries"] = countries
        }
        if hasLicense.count == 0 {
            dictionary["driver_license"] = hasLicense
        }
        if educationLevel.count == 0 {
            dictionary["education_level"] = educationLevel
        }
        if states.count == 0 {
            dictionary["states"] = states
        }
        if eyeColor.count == 0 {
            dictionary["eye_color"] = eyeColor
        }
        if financialCondition.count == 0 {
            dictionary["financial_condition"] = financialCondition
        }
        if gender.count == 0 {
            dictionary["gender"] = gender
        }
        if hairColor.count == 0 {
            dictionary["hair_color"] = hairColor
        }
        if hairType.count == 0 {
            dictionary["hair_type"] = hairType
        }
        
        if isSmoking.count == 0 {
            dictionary["is_smoking"] = isSmoking
        }
//        if occupation.count == 0 {
//            dictionary["Working"] = occupation
//        }
        if jobType.count == 0 {
            dictionary["job_type"] = jobType
        }
        if languages.count == 0 {
            dictionary["languages"] = languages
        }
//        if lookingFor.count == 0 {
//            dictionary["looking_for"] = lookingFor
//        }
        if numberOfChildren.count == 0 {
            dictionary["no_of_children"] = numberOfChildren
        }
//        //Bride Postion
//        if noOfWives.count == 0 {
//            dictionary["no_of_wives"] = noOfWives
//        }
        if religionCommitment.count == 0 {
            dictionary["religion_commitment"] = religionCommitment
        }
        if reproduction.count == 0 {
            dictionary["reproduction"] = reproduction
        }
        if requiredAge.count == 0 {
            dictionary["required_age"] = requiredAge
        }
        if height.count == 0 {
            dictionary["required_body_height"] = height
        }
        if educationLevel.count == 0 {
            dictionary["required_education_level"] = educationLevel
        }
        if socialStatus.count == 0 {
            dictionary["required_social_status"] = socialStatus
        }
        if skinColor.count == 0 {
            dictionary["skin_color"] = skinColor
        }
        if socialStatus.count == 0 {
            dictionary["social_status"] = socialStatus
        }
        if residenceType.count == 0 {
            dictionary["residenceType"] = socialStatus
        }
        if ethnicity.count == 0 {
            dictionary["ethnicity"] = socialStatus
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
//        //Signup
//        gender = aDecoder.decodeObject(forKey: "gender") as! [Dictionary<String,AnyObject>]
//        //Step 1
//        title = aDecoder.decodeObject(forKey: "title") as! [Dictionary<String,AnyObject>]
//        countries = aDecoder.decodeObject(forKey: "countries") as! [Dictionary<String,AnyObject>]
//        states = aDecoder.decodeObject(forKey: "states") as! [Dictionary<String,AnyObject>]
//        residenceType = aDecoder.decodeObject(forKey: "residenceType") as! [Dictionary<String,AnyObject>]
//        ethnicity = aDecoder.decodeObject(forKey: "ethnicity") as! [Dictionary<String,AnyObject>]
//        //Step 2
//        sectType = aDecoder.decodeObject(forKey: "Sect_Type") as! [Dictionary<String,AnyObject>]
//        isSmoking = aDecoder.decodeObject(forKey: "isSmoking") as! [Dictionary<String,AnyObject>]
//        skinColor = aDecoder.decodeObject(forKey: "skinColor") as! [Dictionary<String,AnyObject>]
//        hairColor = aDecoder.decodeObject(forKey: "hairColor") as! [Dictionary<String,AnyObject>]
//        eyeColor = aDecoder.decodeObject(forKey: "eyeColor") as! [Dictionary<String,AnyObject>]
//        hairType = aDecoder.decodeObject(forKey: "hair_type") as! [Dictionary<String,AnyObject>]
    }
    
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
//        if gender.count == 0{
//            aCoder.encode(gender, forKey: "gender")
//        }
//        if title.count == 0{
//            aCoder.encode(title, forKey: "title")
//        }
//        if countries.count == 0{
//            aCoder.encode(countries, forKey: "countries")
//        }
//        if states.count == 0{
//            aCoder.encode(states, forKey: "states")
//        }
//        if sectType.count == 0{
//            aCoder.encode(isSmoking, forKey: "Sect_Type")
//        }
//        if gender.count == 0{
//            aCoder.encode(isSmoking, forKey: "isSmoking")
//        }
//        if title.count == 0{
//            aCoder.encode(skinColor, forKey: "skinColor")
//        }
//        if gender.count == 0{
//            aCoder.encode(hairColor, forKey: "hairColor")
//        }
//        if title.count == 0{
//            aCoder.encode(eyeColor, forKey: "eyeColor")
//        }
//        if hairType.count == 0{
//            aCoder.encode(hairType, forKey: "hair_type")
//        }
//
//        if annualIncome.count == 0{
//            aCoder.encode(annualIncome, forKey: "annual_income")
//        }
//        if anyDisease.count == 0{
//            aCoder.encode(anyDisease, forKey: "any_disease")
//        }
//        if height.count == 0{
//            aCoder.encode(height, forKey: "body_height")
//        }
//        if bodyType.count == 0{
//            aCoder.encode(bodyType, forKey: "body_type")
//        }
//        if brideDowry.count == 0{
//            aCoder.encode(brideDowry, forKey: "bride_dowry")
//        }
//        if brideArrangement.count == 0{
//            aCoder.encode(brideArrangement, forKey: "bride_position")
//        }
//        if veil.count == 0{
//            aCoder.encode(veil, forKey: "condemning_bride")
//        }
//        if hasLicense.count == 0{
//            aCoder.encode(hasLicense, forKey: "driver_license")
//        }
//        if educationLevel.count == 0{
//            aCoder.encode(educationLevel, forKey: "education_level")
//        }
//        if financialCondition.count == 0{
//            aCoder.encode(financialCondition, forKey: "financial_condition")
//        }
////        if occupation.count == 0{
////            aCoder.encode(occupation, forKey: "Working")
////        }
//        if jobType.count == 0{
//            aCoder.encode(jobType, forKey: "job_type")
//        }
//        if languages.count == 0{
//            aCoder.encode(languages, forKey: "languages")
//        }
//        if numberOfChildren.count == 0{
//            aCoder.encode(numberOfChildren, forKey: "no_of_children")
//        }
////        //Bride ArrangementPostion
////        if noOfWives.count == 0{
////            aCoder.encode(noOfWives, forKey: "no_of_wives")
////        }
//        if religionCommitment.count == 0{
//            aCoder.encode(religionCommitment, forKey: "religion_commitment")
//        }
//        if reproduction.count == 0{
//            aCoder.encode(reproduction, forKey: "reproduction")
//        }
//        if requiredAge.count == 0{
//            aCoder.encode(requiredAge, forKey: "required_age")
//        }
//        if height.count == 0{
//            aCoder.encode(height, forKey: "required_body_height")
//        }
//        if educationLevel.count == 0{
//            aCoder.encode(educationLevel, forKey: "required_education_level")
//        }
//        if socialStatus.count == 0{
//            aCoder.encode(socialStatus, forKey: "required_social_status")
//        }
//
//        if socialStatus.count == 0{
//            aCoder.encode(socialStatus, forKey: "social_status")
//        }
    }
}
