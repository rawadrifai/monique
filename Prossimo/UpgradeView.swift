//
//  UpgradeView.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/12/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import StoreKit
import Firebase
import FirebaseDatabase

class UpgradeView: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var ref: FIRDatabaseReference!
    var userId = String()
    var list = [SKProduct]()
    var p = SKProduct()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        
        // connect to the app store
        if(SKPaymentQueue.canMakePayments()) {
            
            print("IAP is enabled, loading")
            let productID: NSSet = NSSet(objects: "rifai.prossimo.ios.pp")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
            
        } else {
            print("please enable IAPS")
        }
    }
    
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("product request")
        
        let myProduct = response.products
        
        for product in myProduct {
            
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product)
        }
        
        
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        print("transactions restored")
        
        for transaction in queue.transactions {
            
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
                
            case "rifai.prossimo.ios.pp":
                print("add coins to account")
                addPro()
                
            default:
                print("IAP not found")
            }
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        print("add payment")
        
        for transaction: AnyObject in transactions {
            
            let trans = transaction as! SKPaymentTransaction
            print(trans.error ?? "default")
            
            switch trans.transactionState {
            case .purchased:
                print("buy ok, unlock IAP HERE")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier
                switch prodID {
                    
                case "rifai.prossimo.ios.pp":
                    print("add coins to account")
                    addPro()
                default:
                    print("IAP not found")
                }
                
                queue.finishTransaction(trans)
                
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break
                
            default:
                print("Default")
                break
            }
        }
    }
    
    func addPro() {
        print("adding pro")
        self.ref.child("users/" + self.userId + "/subscription").setValue("pro")
    }
    
    

    
    func buyPro() {
        
        print("buy " + p.productIdentifier)
        
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }



}
