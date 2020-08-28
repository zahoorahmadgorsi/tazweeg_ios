//
//  Country.swift
//  Tazweeg
//
//  Created by iMac on 10/15/19.
//  Copyright © 2019 Tazweeg. All rights reserved.
//

import UIKit
class Country: NSObject, NSCoding{
    
    var countryId : Int!
    var imgUrl : String!
    var countryEN : String!
    var countryAR : String!
    var code :Int?
    var show :Bool?
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        countryId = dictionary["countryId"] as? Int
        imgUrl = dictionary["img"] as? String
        countryEN = dictionary["countryEN"] as? String
        countryAR = dictionary["countryAR"] as? String
        code = dictionary["code"] as? Int
        show = dictionary["show"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if countryId != nil{
            dictionary["countryId"] = countryId
        }
        if imgUrl != nil{
            dictionary["img"] = imgUrl
        }
        if countryEN != nil{
            dictionary["countryEN"] = countryEN
        }
        if countryAR != nil{
            dictionary["stateAR"] = countryAR
        }
        if code != nil{
            dictionary["code"] = code
        }
        if show != nil{
            dictionary["show"] = show
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        countryId = aDecoder.decodeObject(forKey: "countryId") as? Int
        imgUrl = aDecoder.decodeObject(forKey: "img") as? String
        countryEN = aDecoder.decodeObject(forKey: "countryEN") as? String
        countryAR = aDecoder.decodeObject(forKey: "countryAR") as? String
        code = aDecoder.decodeObject(forKey: "code") as? Int
        show = aDecoder.decodeObject(forKey: "show") as? Bool
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if countryId != nil{
            aCoder.encode(countryId, forKey: "stateId")
        }
        if imgUrl != nil{
            aCoder.encode(imgUrl, forKey: "imgUrl")
        }
        if countryEN != nil{
            aCoder.encode(countryEN, forKey: "stateEN")
        }
        if countryAR != nil{
            aCoder.encode(countryAR, forKey: "countryAR")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if show != nil{
            aCoder.encode(show, forKey: "show")
        }
    }
    
}

