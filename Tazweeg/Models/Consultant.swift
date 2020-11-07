//
//  Consultant.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 30/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit

class Consultant: NSObject, NSCoding{
    
    var emiratesServesIn : String?
    var id : Int?
    var genderID : Int?
    var image : String?
    var name : String?
    var phoneNumber : NSNumber?
    var email : String?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        //Old Code Start
//        emiratesServesIn = dictionary["emirates_serves_in"] as? String
//        id = dictionary["id"] as? Int
//        if dictionary["image"] == nil || dictionary["image"] is NSNull  {
//            image = ""
//        } else {
//            image = dictionary["image"] as? String
//        }
//
//        name = dictionary["name"] as? String
//        phoneNumber = dictionary["phone_number"] as? String
        //Old Code End
        id = dictionary["consultantId"] as? Int
        genderID = dictionary["genderId"] as? Int
        email = dictionary["email"] as? String
        name = dictionary["fullName"] as? String
        phoneNumber = dictionary["phone"] as? NSNumber
        image = dictionary["imagePath"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if emiratesServesIn != nil{
            dictionary["emirates_serves_in"] = emiratesServesIn
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if name != nil{
            dictionary["name"] = name
        }
        if phoneNumber != nil{
            dictionary["phone_number"] = phoneNumber
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        emiratesServesIn = aDecoder.decodeObject(forKey: "emirates_serves_in") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        image = aDecoder.decodeObject(forKey: "image") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        //phoneNumber = aDecoder.decodeObject(forKey: "phone_number") as? String
        phoneNumber = aDecoder.decodeObject(forKey: "phone_number") as? NSNumber
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if emiratesServesIn != nil{
            aCoder.encode(emiratesServesIn, forKey: "emirates_serves_in")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if phoneNumber != nil{
            aCoder.encode(phoneNumber, forKey: "phone_number")
        }
        
    }
    
}
