//
//  State.swift
//  Tazweeg
//
//  Created by iMac on 4/16/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
class CountryState: NSObject, NSCoding{
    
    var stateId : Int!
    var imgPath : String?
    var stateEN : String!
    var stateAR : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        stateId = dictionary["stateId"] as? Int
        imgPath = dictionary["imgPath"] as? String
        stateEN = dictionary["stateEN"] as? String
        stateAR = dictionary["stateAR"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if stateId != nil{
            dictionary["stateId"] = stateId
        }
        if imgPath != nil{
            dictionary["imgPath"] = imgPath
        }
        if stateEN != nil{
            dictionary["stateEN"] = stateEN
        }
        if stateAR != nil{
            dictionary["stateAR"] = stateAR
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        stateId = aDecoder.decodeObject(forKey: "stateId") as? Int
        imgPath = aDecoder.decodeObject(forKey: "imgPath") as? String
        stateEN = aDecoder.decodeObject(forKey: "stateEN") as? String
        stateAR = aDecoder.decodeObject(forKey: "stateAR") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if stateId != nil{
            aCoder.encode(stateId, forKey: "stateId")
        }
        if imgPath != nil{
            aCoder.encode(imgPath, forKey: "imgPath")
        }
        if stateEN != nil{
            aCoder.encode(stateEN, forKey: "stateEN")
        }
        if stateAR != nil{
            aCoder.encode(stateAR, forKey: "stateAR")
        }
    }
    
}
