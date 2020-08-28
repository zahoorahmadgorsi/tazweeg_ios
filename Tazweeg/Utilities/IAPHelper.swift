/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import StoreKit
import KeychainAccess

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelper: NSObject  {
    private let productIdentifiers: Set<ProductIdentifier>
    //  tracks which items have been purchased.
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    //  delegate to perform requests to Apple servers.
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    public init(productIds: Set<ProductIdentifier>) {
//        print("IAPHelper.init")
        productIdentifiers = productIds
//        for productIdentifier in productIds {
//            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
//            if purchased {
//                purchasedProductIdentifiers.insert(productIdentifier) //taken this code to isProductPurchased
//                print("Previously purchased: \(productIdentifier)")
//            } else {
//                print("Not purchased: \(productIdentifier)")
//            }
//        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - StoreKit API

extension IAPHelper {
    //  This code saves the user’s completion handler for future execution. It then creates and initiates a request to Apple via an SKProductsRequest object.
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
//        print("IAPHelper.requestProducts")
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    //This creates a payment object using an SKProduct (retrieved from the Apple server) to add to a payment queue. The code utilizes a singleton SKPaymentQueue object called default(). Boom! Money in the bank.
    public func buyProduct(_ product: SKProduct) {
//        print("IAPHelper.buyProduct Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    //******************************************************************************************
    //This method checks 4rm the keychain if this product is already purchased from apple or not
    //******************************************************************************************
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        let keychain = Keychain(service: Constants.keychain)
        let hasPurchased = try? keychain.get(productIdentifier)
        // if there is value correspond to the productIdentifier key in the keychain
        if (hasPurchased != nil && hasPurchased == Constants.purchased){
            // the product has been purchased previously, add it to the purchasedProductIdentifiers set
            purchasedProductIdentifiers.insert(productIdentifier)
        } else {
            // the product has not been purchased previously, do nothing
            print("Not purchased: \(productIdentifier)")
        }
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
//        print("IAPHelper.canMakePayments")
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
//        print("IAPHelper.restorePurchases")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate
//Delegations SKProductsRequestDelegate
//This extension is used to get a list of products, their titles, descriptions and prices from Apple’s servers by implementing the two methods required by the SKProductsRequestDelegate protocol.
extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            Utility.printToConsole(message: "Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("Failed to load list of products.")
//        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver
//SKPaymentTransactionObserver Payment verification is achieved by having the IAPHelper observe transactions happening on the SKPaymentQueue. Before setting up IAPHelper as an SKPaymentQueue transactions observer, the class must conform to the SKPaymentTransactionObserver protocol.
extension IAPHelper: SKPaymentTransactionObserver {
    
    //paymentQueue(_:updatedTransactions:) is the only method actually required by the protocol. It gets called when one or more transaction states change.
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
//        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
//        print("fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
//            print("Transaction Error: \(localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
        Utility.shared.hideSpinner()
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        purchasedProductIdentifiers.insert(identifier)
        //UserDefaults.standard.set(true, forKey: identifier) Dont store in userdefaults as its a security breach, instead use keychain
        // replace the keychain service name as you like
        let keychain = Keychain(service: Constants.keychain)
        // use the in-app product item identifier as key, and set its value to indicate user has purchased it
        do{
            try keychain.set(Constants.purchased, key: identifier)
        }
        catch let error {
//            print("setting keychain to purchased failed")
//            print(error)
        }
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
        Utility.shared.hideSpinner()
    }
}
