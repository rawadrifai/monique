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
    var allSKProducts = [SKProduct]()
    var sKproductToBuy = SKProduct()
    var productsInFirebase = Set<String>()
    var promoCodeToUse = PromoCode()
    var promoCodesInFirebase = [PromoCode]()
    
    
    @IBOutlet weak var txfPromo: UITextField!
    @IBOutlet weak var labelDiscountApplied: UILabel!
    @IBOutlet weak var btnUpgrade: UIButton!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        getProductsFromFirebase()
        getPromoCodesFromFirebase()
        
        
    }
    
    func getProductsFromFirebase() {
        
        self.ref.child("products").observeSingleEvent(of: .value, with: {
            
            if let val = $0.value as? NSDictionary {
                
                //var tmpSet = Set<String>()
                self.productsInFirebase = Set<String>()
                
                for v in val.allValues {
                    //  tmpSet.insert(String(describing: v))
                    self.productsInFirebase.insert(String(describing: v))
                }
                
                //   self.productsInFirebase = NSSet(set: tmpSet, copyItems: true)
                print(self.productsInFirebase)
                
                self.requestProductsFromAppStore()
            }
        })
        
    }
    
    func requestProductsFromAppStore() {
        
        // connect to the app store
        if(SKPaymentQueue.canMakePayments()) {
            
            print("IAP is enabled, loading")

            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productsInFirebase)

            request.delegate = self
            request.start()
            
        } else {
            print("please enable IAPS")
        }
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        
        let myProduct = response.products
        
        for product in myProduct {

            print(product.productIdentifier)
            allSKProducts.append(product)
        }
        
        btnUpgrade.isEnabled = true
        
        
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        print("transactions restored")
        
        for transaction in queue.transactions {
            
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
                
            case "rifai.prossimo.ios.pp":
                print("add coins to account")
                registerProInFirebase()
                
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
                
                print("BUY OK:")
                print(sKproductToBuy.productIdentifier)
                
                let prodID = sKproductToBuy.productIdentifier
                switch prodID {
                    
                case "rifai.prossimo.ios.pp":
                    
                    registerProInFirebase()
                    
                case "rifai.prossimo.ios.pp00":
                    
                    registerProInFirebase()
                    
                case "rifai.prossimo.ios.pp50":
                    
                    registerProInFirebase()
                    
                case "rifai.prossimo.ios.pp70":
                    
                    registerProInFirebase()
                    
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
    
    
    
    

    @IBAction func upgradeClick(_ sender: UIButton) {
        
        
        
        for product in allSKProducts {
            let prodID = product.productIdentifier
            if(prodID == "rifai.prossimo.ios.pp") {
                sKproductToBuy = product
                buyPro()
            }
        }
    }
    
    var applyPromo = false
    
    @IBAction func promoTextChanged(_ sender: UITextField) {
        
        if let enteredPromo = txfPromo.text {
            

            if enteredPromo.characters.count == 6 {
                
                for p in self.promoCodesInFirebase {
                    
                    if p.code == enteredPromo {
                        labelDiscountApplied.isHidden = false
                        self.applyPromo = true
                        promoCodeToUse.code = p.code
                        promoCodeToUse.product = p.product
                        break
                    }
                    else {
                        labelDiscountApplied.isHidden = true
                        self.applyPromo = false
                    }
                    
                }
            }
            else {
                labelDiscountApplied.isHidden = true
                self.applyPromo = false
            }
        }
        
    }
    
    
    func getPromoCodesFromFirebase() {
        
        self.ref.child("promocodes").observeSingleEvent(of: .value, with: {
            
            if let tmpPromos = $0.value as? NSDictionary {
                
                self.promoCodesInFirebase = [PromoCode]()
                
                for p in tmpPromos.allValues {
                    
                    if let v = p as? NSDictionary {
                        
                        let promo = PromoCode()
                        promo.code = v.value(forKey: "code") as! String
                        promo.product = v.value(forKey: "product") as! String
                        
                        self.promoCodesInFirebase.append(promo)
                    }
                }
                
            }
        })
    }
    
    
    func buyPro() {
        print("buy " + sKproductToBuy.productIdentifier)
        
        let pay = SKPayment(product: sKproductToBuy)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func registerProInFirebase() {
        print("adding pro")
        self.ref.child("products").setValue("pro")
        // self.ref.child("users/" + self.userId + "/subscription/promo").setValue("pro")
        
    }
    
    
}

class PromoCode {
    var code=String()
    var product=String()
}
