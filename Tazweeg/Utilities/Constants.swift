//
//  Constants.swift
//  Nouht
//
//  Created by Aplus on 16/02/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit
struct AppColors {
    static var green : UIColor {
        return UIColor.init(netHex: 0x619604)
    }
    static var red : UIColor {
        return UIColor.init(netHex: 0xc80000)
    }
    static var yellow : UIColor {
        return UIColor.init(netHex: 0xe2f000)
    }
    static var grey : UIColor {
        return UIColor.init(netHex: 0xE0DCDB)
    }
    
}

struct App{
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let storyBoardMain = UIStoryboard(name: "Main", bundle: nil)
}

