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
         "rifai.prossimo.ios.pp"]
    
    var productsFromStore = [SKProduct]()
    
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
        
        self.unlockContentForTransaction(transaction: transaction)
        
        // tell itunes that transaction is finished
        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
    
    func purchaseRestored(transaction:SKPaymentTransaction) {
        
        if self.purchasableProductIds.contains(transaction.payment.productIdentifier) {
            self.unlockContentForTransaction(transaction: transaction)
        }
        
        // tell itunes that transaction is finished
        SKPaymentQueue.default().finishTransaction(transaction)
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
    
    func unlockContentForTransaction(transaction:SKPaymentTransaction) {
        print(transaction.payment.productIdentifier + " unlocked")
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
                
                productsFromStore.append(product)
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
    
    
    func buy(product:SKProduct) {
        
        let productDict:[String: SKProduct] = ["product": product]
        //NotificationCenter.default.post(name: NSNotification.Name.init("SKProductPurchased"), object:nil)
        NotificationCenter.default.post(name: NSNotification.Name.init("SKProductPurchased"), object: nil, userInfo: productDict)

        
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
        
        print("buying " + product.productIdentifier)

    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        //
    }
}
