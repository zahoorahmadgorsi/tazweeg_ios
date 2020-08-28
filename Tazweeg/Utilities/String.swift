//
//  +String.swift
//  Tazweeg
//
//  Created by iMac on 4/1/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//
import UIKit
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
