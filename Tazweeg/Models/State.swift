//
//  State.swift
//  Tazweeg
//
//  Created by iMac on 4/16/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import Foundation
class CountryState: NSObject, NSCoding{
    
    var stateId : Int!
    var imgUrl : String!
    var stateEN : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        stateId = dictionary["stateId"] as? Int
        imgUrl = dictionary["imgUrl"] as? String
        stateEN = dictionary["stateEN"] as? String
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
        if imgUrl != nil{
            dictionary["imgUrl"] = imgUrl
        }
        if stateEN != nil{
            dictionary["stateEN"] = stateEN
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
        imgUrl = aDecoder.decodeObject(forKey: "imgUrl") as? String
        stateEN = aDecoder.decodeObject(forKey: "stateEN") as? String
        
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
        if imgUrl != nil{
            aCoder.encode(imgUrl, forKey: "imgUrl")
        }
        if stateEN != nil{
            aCoder.encode(stateEN, forKey: "stateEN")
        }
        
    }
    
}
