//
//  AssignMember.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 01/11/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit

class AssignMember: NSObject, NSCoding{
    
    var code : String!
    var gender : String!
    var id : Int!
    var image : String!
    var lookingFor : String!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        code = dictionary["code"] as? String
        gender = dictionary["gender"] as? String
        id = dictionary["id"] as? Int
        if dictionary["image"] == nil || dictionary["image"] is NSNull {
            image = ""
        } else {
            image = dictionary["image"] as? String
        }
        
        lookingFor = dictionary["looking_for"] as? String
        name = dictionary["name"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if code != nil{
            dictionary["code"] = code
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if lookingFor != nil{
            dictionary["looking_for"] = lookingFor
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObject(forKey: "code") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        image = aDecoder.decodeObject(forKey: "image") as? String
        lookingFor = aDecoder.decodeObject(forKey: "looking_for") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if lookingFor != nil{
            aCoder.encode(lookingFor, forKey: "looking_for")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}
