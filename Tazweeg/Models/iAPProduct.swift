//
//  IAPProduct.swift
//  Tazweeg
//
//  Created by iMac on 7/6/19.
//  Copyright © 2019 Tazweeg. All rights reserved.
//

import Foundation
public struct iAPProduct {
    public static let swiftShopping = "com.tazweeg.MatchingList"
    private static let productIdentifiers: Set<ProductIdentifier> = [iAPProduct.swiftShopping]
    //this object interacts with the StoreKit API to list and perform purchases.
    public static let store = IAPHelper(productIds: iAPProduct.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
