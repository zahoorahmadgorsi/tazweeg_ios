//
//  PesonalInfo.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 05/11/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit

class PersonalInfo: NSObject, NSCoding{
    
    var annualIncome : String!
    var anyDisease : String!
    var applicantDescription : String!
    var bodyHeight : String!
    var bodyType : String!
    var code : String!
    var country : String!
    var dateOfBirth : String!
    var diseaseName : String!
    var educationLevel : String!
    var email : String!
    var emirate : String!
    var emiratesIdCard : String!
    var eyeColor : String!
    var family : String!
    var financialCondition : String!
    var gender : String!
    var hairColor : String!
    var hairType : String!
    var id : Int!
    var isSmoking : String!
    var isWorking : String!
    var istRelative : String!
    var istRelativePhoneNumber : String!
    var istRelativeRelation : String!
    var jobTitle : String!
    var jobType : String!
    var languages : String!
    var lookingFor : String!
    var name : String!
    var noOfChildren : String!
    var paymentStatus : String!
    var phoneNumber : String!
    var placeOfBirth : String!
    var religionCommitment : String!
    var reproduction : String!
    var secondRelative : String!
    var secondRelativePhoneNumber : String!
    var secondRelativeRelation : String!
    var signature : String!
    var skinColor : String!
    var socialStatus : String!
    var thirdRelative : String!
    var thirdRelativePhoneNumber : String!
    var thirdRelativeRelation : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        annualIncome = dictionary["annual_income"] as? String
        anyDisease = dictionary["any_disease"] as? String
        applicantDescription = dictionary["applicant_description"] as? String
        bodyHeight = dictionary["body_height"] as? String
        bodyType = dictionary["body_type"] as? String
        code = dictionary["code"] as? String
        country = dictionary["country"] as? String
        dateOfBirth = dictionary["date_of_birth"] as? String
        diseaseName = dictionary["disease_name"] as? String
        educationLevel = dictionary["education_level"] as? String
        email = dictionary["email"] as? String
        emirate = dictionary["emirate"] as? String
        emiratesIdCard = dictionary["emirates_id_card"] as? String
        eyeColor = dictionary["eye_color"] as? String
        family = dictionary["family"] as? String
        financialCondition = dictionary["financial_condition"] as? String
        gender = dictionary["gender"] as? String
        hairColor = dictionary["hair_color"] as? String
        hairType = dictionary["hair_type"] as? String
        id = dictionary["id"] as? Int
        isSmoking = dictionary["is_smoking"] as? String
        isWorking = dictionary["is_working"] as? String
        istRelative = dictionary["ist_relative"] as? String
        istRelativePhoneNumber = dictionary["ist_relative_phone_number"] as? String
        istRelativeRelation = dictionary["ist_relative_relation"] as? String
        jobTitle = dictionary["job_title"] as? String
        jobType = dictionary["job_type"] as? String
        languages = dictionary["languages"] as? String
        lookingFor = dictionary["looking_for"] as? String
        name = dictionary["name"] as? String
        noOfChildren = dictionary["no_of_children"] as? String
        paymentStatus = dictionary["payment_status"] as? String
        phoneNumber = dictionary["phone_number"] as? String
        placeOfBirth = dictionary["place_of_birth"] as? String
        religionCommitment = dictionary["religion_commitment"] as? String
        reproduction = dictionary["reproduction"] as? String
        secondRelative = dictionary["second_relative"] as? String
        secondRelativePhoneNumber = dictionary["second_relative_phone_number"] as? String
        secondRelativeRelation = dictionary["second_relative_relation"] as? String
        signature = dictionary["signature"] as? String
        skinColor = dictionary["skin_color"] as? String
        socialStatus = dictionary["social_status"] as? String
        thirdRelative = dictionary["third_relative"] as? String
        thirdRelativePhoneNumber = dictionary["third_relative_phone_number"] as? String
        thirdRelativeRelation = dictionary["third_relative_relation"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if annualIncome != nil{
            dictionary["annual_income"] = annualIncome
        }
        if anyDisease != nil{
            dictionary["any_disease"] = anyDisease
        }
        if applicantDescription != nil{
            dictionary["applicant_description"] = applicantDescription
        }
        if bodyHeight != nil{
            dictionary["body_height"] = bodyHeight
        }
        if bodyType != nil{
            dictionary["body_type"] = bodyType
        }
        if code != nil{
            dictionary["code"] = code
        }
        if country != nil{
            dictionary["country"] = country
        }
        if dateOfBirth != nil{
            dictionary["date_of_birth"] = dateOfBirth
        }
        if diseaseName != nil{
            dictionary["disease_name"] = diseaseName
        }
        if educationLevel != nil{
            dictionary["education_level"] = educationLevel
        }
        if email != nil{
            dictionary["email"] = email
        }
        if emirate != nil{
            dictionary["emirate"] = emirate
        }
        if emiratesIdCard != nil{
            dictionary["emirates_id_card"] = emiratesIdCard
        }
        if eyeColor != nil{
            dictionary["eye_color"] = eyeColor
        }
        if family != nil{
            dictionary["family"] = family
        }
        if financialCondition != nil{
            dictionary["financial_condition"] = financialCondition
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if hairColor != nil{
            dictionary["hair_color"] = hairColor
        }
        if hairType != nil{
            dictionary["hair_type"] = hairType
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isSmoking != nil{
            dictionary["is_smoking"] = isSmoking
        }
        if isWorking != nil{
            dictionary["is_working"] = isWorking
        }
        if istRelative != nil{
            dictionary["ist_relative"] = istRelative
        }
        if istRelativePhoneNumber != nil{
            dictionary["ist_relative_phone_number"] = istRelativePhoneNumber
        }
        if istRelativeRelation != nil{
            dictionary["ist_relative_relation"] = istRelativeRelation
        }
        if jobTitle != nil{
            dictionary["job_title"] = jobTitle
        }
        if jobType != nil{
            dictionary["job_type"] = jobType
        }
        if languages != nil{
            dictionary["languages"] = languages
        }
        if lookingFor != nil{
            dictionary["looking_for"] = lookingFor
        }
        if name != nil{
            dictionary["name"] = name
        }
        if noOfChildren != nil{
            dictionary["no_of_children"] = noOfChildren
        }
        if paymentStatus != nil{
            dictionary["payment_status"] = paymentStatus
        }
        if phoneNumber != nil{
            dictionary["phone_number"] = phoneNumber
        }
        if placeOfBirth != nil{
            dictionary["place_of_birth"] = placeOfBirth
        }
        if religionCommitment != nil{
            dictionary["religion_commitment"] = religionCommitment
        }
        if reproduction != nil{
            dictionary["reproduction"] = reproduction
        }
        if secondRelative != nil{
            dictionary["second_relative"] = secondRelative
        }
        if secondRelativePhoneNumber != nil{
            dictionary["second_relative_phone_number"] = secondRelativePhoneNumber
        }
        if secondRelativeRelation != nil{
            dictionary["second_relative_relation"] = secondRelativeRelation
        }
        if signature != nil{
            dictionary["signature"] = signature
        }
        if skinColor != nil{
            dictionary["skin_color"] = skinColor
        }
        if socialStatus != nil{
            dictionary["social_status"] = socialStatus
        }
        if thirdRelative != nil{
            dictionary["third_relative"] = thirdRelative
        }
        if thirdRelativePhoneNumber != nil{
            dictionary["third_relative_phone_number"] = thirdRelativePhoneNumber
        }
        if thirdRelativeRelation != nil{
            dictionary["third_relative_relation"] = thirdRelativeRelation
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        annualIncome = aDecoder.decodeObject(forKey: "annual_income") as? String
        anyDisease = aDecoder.decodeObject(forKey: "any_disease") as? String
        applicantDescription = aDecoder.decodeObject(forKey: "applicant_description") as? String
        bodyHeight = aDecoder.decodeObject(forKey: "body_height") as? String
        bodyType = aDecoder.decodeObject(forKey: "body_type") as? String
        code = aDecoder.decodeObject(forKey: "code") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        dateOfBirth = aDecoder.decodeObject(forKey: "date_of_birth") as? String
        diseaseName = aDecoder.decodeObject(forKey: "disease_name") as? String
        educationLevel = aDecoder.decodeObject(forKey: "education_level") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        emirate = aDecoder.decodeObject(forKey: "emirate") as? String
        emiratesIdCard = aDecoder.decodeObject(forKey: "emirates_id_card") as? String
        eyeColor = aDecoder.decodeObject(forKey: "eye_color") as? String
        family = aDecoder.decodeObject(forKey: "family") as? String
        financialCondition = aDecoder.decodeObject(forKey: "financial_condition") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        hairColor = aDecoder.decodeObject(forKey: "hair_color") as? String
        hairType = aDecoder.decodeObject(forKey: "hair_type") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        isSmoking = aDecoder.decodeObject(forKey: "is_smoking") as? String
        isWorking = aDecoder.decodeObject(forKey: "is_working") as? String
        istRelative = aDecoder.decodeObject(forKey: "ist_relative") as? String
        istRelativePhoneNumber = aDecoder.decodeObject(forKey: "ist_relative_phone_number") as? String
        istRelativeRelation = aDecoder.decodeObject(forKey: "ist_relative_relation") as? String
        jobTitle = aDecoder.decodeObject(forKey: "job_title") as? String
        jobType = aDecoder.decodeObject(forKey: "job_type") as? String
        languages = aDecoder.decodeObject(forKey: "languages") as? String
        lookingFor = aDecoder.decodeObject(forKey: "looking_for") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        noOfChildren = aDecoder.decodeObject(forKey: "no_of_children") as? String
        paymentStatus = aDecoder.decodeObject(forKey: "payment_status") as? String
        phoneNumber = aDecoder.decodeObject(forKey: "phone_number") as? String
        placeOfBirth = aDecoder.decodeObject(forKey: "place_of_birth") as? String
        religionCommitment = aDecoder.decodeObject(forKey: "religion_commitment") as? String
        reproduction = aDecoder.decodeObject(forKey: "reproduction") as? String
        secondRelative = aDecoder.decodeObject(forKey: "second_relative") as? String
        secondRelativePhoneNumber = aDecoder.decodeObject(forKey: "second_relative_phone_number") as? String
        secondRelativeRelation = aDecoder.decodeObject(forKey: "second_relative_relation") as? String
        signature = aDecoder.decodeObject(forKey: "signature") as? String
        skinColor = aDecoder.decodeObject(forKey: "skin_color") as? String
        socialStatus = aDecoder.decodeObject(forKey: "social_status") as? String
        thirdRelative = aDecoder.decodeObject(forKey: "third_relative") as? String
        thirdRelativePhoneNumber = aDecoder.decodeObject(forKey: "third_relative_phone_number") as? String
        thirdRelativeRelation = aDecoder.decodeObject(forKey: "third_relative_relation") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if annualIncome != nil{
            aCoder.encode(annualIncome, forKey: "annual_income")
        }
        if anyDisease != nil{
            aCoder.encode(anyDisease, forKey: "any_disease")
        }
        if applicantDescription != nil{
            aCoder.encode(applicantDescription, forKey: "applicant_description")
        }
        if bodyHeight != nil{
            aCoder.encode(bodyHeight, forKey: "body_height")
        }
        if bodyType != nil{
            aCoder.encode(bodyType, forKey: "body_type")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if dateOfBirth != nil{
            aCoder.encode(dateOfBirth, forKey: "date_of_birth")
        }
        if diseaseName != nil{
            aCoder.encode(diseaseName, forKey: "disease_name")
        }
        if educationLevel != nil{
            aCoder.encode(educationLevel, forKey: "education_level")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if emirate != nil{
            aCoder.encode(emirate, forKey: "emirate")
        }
        if emiratesIdCard != nil{
            aCoder.encode(emiratesIdCard, forKey: "emirates_id_card")
        }
        if eyeColor != nil{
            aCoder.encode(eyeColor, forKey: "eye_color")
        }
        if family != nil{
            aCoder.encode(family, forKey: "family")
        }
        if financialCondition != nil{
            aCoder.encode(financialCondition, forKey: "financial_condition")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if hairColor != nil{
            aCoder.encode(hairColor, forKey: "hair_color")
        }
        if hairType != nil{
            aCoder.encode(hairType, forKey: "hair_type")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isSmoking != nil{
            aCoder.encode(isSmoking, forKey: "is_smoking")
        }
        if isWorking != nil{
            aCoder.encode(isWorking, forKey: "is_working")
        }
        if istRelative != nil{
            aCoder.encode(istRelative, forKey: "ist_relative")
        }
        if istRelativePhoneNumber != nil{
            aCoder.encode(istRelativePhoneNumber, forKey: "ist_relative_phone_number")
        }
        if istRelativeRelation != nil{
            aCoder.encode(istRelativeRelation, forKey: "ist_relative_relation")
        }
        if jobTitle != nil{
            aCoder.encode(jobTitle, forKey: "job_title")
        }
        if jobType != nil{
            aCoder.encode(jobType, forKey: "job_type")
        }
        if languages != nil{
            aCoder.encode(languages, forKey: "languages")
        }
        if lookingFor != nil{
            aCoder.encode(lookingFor, forKey: "looking_for")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if noOfChildren != nil{
            aCoder.encode(noOfChildren, forKey: "no_of_children")
        }
        if paymentStatus != nil{
            aCoder.encode(paymentStatus, forKey: "payment_status")
        }
        if phoneNumber != nil{
            aCoder.encode(phoneNumber, forKey: "phone_number")
        }
        if placeOfBirth != nil{
            aCoder.encode(placeOfBirth, forKey: "place_of_birth")
        }
        if religionCommitment != nil{
            aCoder.encode(religionCommitment, forKey: "religion_commitment")
        }
        if reproduction != nil{
            aCoder.encode(reproduction, forKey: "reproduction")
        }
        if secondRelative != nil{
            aCoder.encode(secondRelative, forKey: "second_relative")
        }
        if secondRelativePhoneNumber != nil{
            aCoder.encode(secondRelativePhoneNumber, forKey: "second_relative_phone_number")
        }
        if secondRelativeRelation != nil{
            aCoder.encode(secondRelativeRelation, forKey: "second_relative_relation")
        }
        if signature != nil{
            aCoder.encode(signature, forKey: "signature")
        }
        if skinColor != nil{
            aCoder.encode(skinColor, forKey: "skin_color")
        }
        if socialStatus != nil{
            aCoder.encode(socialStatus, forKey: "social_status")
        }
        if thirdRelative != nil{
            aCoder.encode(thirdRelative, forKey: "third_relative")
        }
        if thirdRelativePhoneNumber != nil{
            aCoder.encode(thirdRelativePhoneNumber, forKey: "third_relative_phone_number")
        }
        if thirdRelativeRelation != nil{
            aCoder.encode(thirdRelativeRelation, forKey: "third_relative_relation")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        
    }
    
}
