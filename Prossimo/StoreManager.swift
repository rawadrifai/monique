//
//  StoreManager.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/29/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation
import StoreKit

class StoreManager:NSObject {
    
    
    static var shared:StoreManager = {
        return StoreManager()
    }()
    
    let purchasableProductIds:Set<String> =
        ["rifai.prossimo.ios.ppmonthly",
         "rifai.prossimo.ios.ppannual",
         "rifai.prossimo.ios.pp",
         "rifai.prossimo.ios.pp00",
         "rifai.prossimo.ios.pp50",
         "rifai.prossimo.ios.pp70"]
    
    var productsFromStore = [SKProduct]()
    var productsMap = [String:SKProduct]()
    
    var registeredLocally = false
    var registeredInFirebase = false

    // instantiate an object of receipt manager
    var receiptManager:ReceiptManager = ReceiptManager()
    
    func setup() {
     
        // request products
        self.requestProducts(ids: self.purchasableProductIds)
        
        // become the delegate for SKpaymentTransaction
        SKPaymentQueue.default().add(self)
        
    }
    
    func requestProducts(ids:Set<String>) {
        
        if(SKPaymentQueue.canMakePayments()) {
            
            print("Loading products")
            
            let request = SKProductsRequest(productIdentifiers: ids)
            request.delegate = self
            request.start()
            
        } else {
            print("User cannot make payments")
        }
        
        
        
    }
}

extension StoreManager:SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            
            switch transaction.transactionState {
                
            case .purchased:
                self.purchaseCompleted(transaction: transaction)
                break
                
            case .restored:
                self.purchaseRestored(transaction: transaction)
                break
                
            case .failed:
                self.purchaseFailed(transaction: transaction)
                break
            
            case .deferred:
                print("pending")
                
            default:
                break
            }
        }
    }
    
    func purchaseCompleted(transaction:SKPaymentTransaction) {
        
        // get product id and create a SKProduct object to send in the notification
        let purchasedProductId = transaction.payment.productIdentifier
        guard let purchasedProduct = productsMap[purchasedProductId] else {
            return
        }
        
        // wrap product with a dictionary object and post in a notification
        let productDict:[String: SKProduct] = ["product": purchasedProduct]
        
        // register product locally in user defaults
        registerProductPurchasedLocally(product: purchasedProduct)
        
        NotificationCenter.default.post(name: NSNotification.Name.init("SKProductPurchased"), object: nil, userInfo: productDict)
        
        // tell itunes that transaction is finished
        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
    
    func purchaseRestored(transaction:SKPaymentTransaction) {
        
        // get product id and create a SKProduct object to send in the notification
        let purchasedProductId = transaction.payment.productIdentifier
        guard let purchasedProduct = productsMap[purchasedProductId] else {
            return
        }
        
        // wrap product with a dictionary object and post in a notification
        let productDict:[String: SKProduct] = ["product": purchasedProduct]
        
        NotificationCenter.default.post(name: NSNotification.Name.init("SKProductRestored"), object: nil, userInfo: productDict)
        
        // tell itunes that transaction is finished
        SKPaymentQueue.default().finishTransaction(transaction)
        
        print("identifier: " + transaction.payment.productIdentifier)
    }
    
    func purchaseFailed(transaction:SKPaymentTransaction) {
        
        if let error = transaction.error as? SKError {
            
            switch error {
            case SKError.clientInvalid:
                print("client cannot make purchase")
            
            case SKError.unknown:
                print("unknown payment error")
                
            case SKError.paymentCancelled:
                print("user cancelled payment")
                
            case SKError.paymentInvalid:
                print("The purchase id is invalid")
                
            case SKError.paymentNotAllowed:
                print("This device is not allowed to make purchases")
                
            default:
                break
            
            }
        }
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
    }
}

extension StoreManager:SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        
        // get products from response and loop through them
        let products = response.products 
        
        if products.count > 0 {
            
            for product in products {
                
                print("product exists: " + product.productIdentifier)
                productsFromStore.append(product) // add to array
                productsMap[product.productIdentifier] = product // add to map (get product by id)
            }
            
        } else {
            print("no products available")
        }
        
        // post a notification
        NotificationCenter.default.post(name: NSNotification.Name.init("SKProductsHaveLoaded"), object:nil)
        
        
        // get invalid products sent in the array purchasableProductIds
        let invalidProductIds = response.invalidProductIdentifiers
        
        for id in invalidProductIds {
            print("wrong product id", id)
        }
    }
    
    // func to execute payments
    func buy(product:SKProduct) {
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        
        print("buying " + product.productIdentifier)

    }
    
    func restoreAllPurchases() {
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print ("could not retrieve products from app store: ", error)
    }
}

extension StoreManager {
    
    
    func registerProductPurchasedLocally(product:SKProduct) {
        
        if !registeredLocally {
            
            // store it in user defaults only if it's a non-consumable (life time)
            if product.productIdentifier == Commons.lifetimeProductId {
                print("adding pro to local")
                
                UserDefaults.standard.set(true, forKey: Commons.lifetimeProductId)
                UserDefaults.standard.synchronize()
            }
            registeredLocally = true
            
        }
    }
    
    
    func isPurchased(id:String)->Bool{
        
        return UserDefaults.standard.bool(forKey: id)
    }
    
    func isSubscriptionActive()->Bool {
        return isPurchased(id: Commons.lifetimeProductId) || receiptManager.isSubscribed
    }
    
    
}
