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
    var promoCodesInFirebase = Dictionary<String, String>()
    
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
                
                self.productsInFirebase = Set<String>()
                
                for v in val.allValues {
                    self.productsInFirebase.insert(String(describing: v))
                    
                }
                
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
            
            // pick the default product
            if product.productIdentifier == "rifai.prossimo.ios.pp" {
                sKproductToBuy = product
                promoCodeToUse.code = "none"
                promoCodeToUse.product = product.productIdentifier
            }
        }
        
        btnUpgrade.isEnabled = true
        
        
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        print("transactions restored")
        
        for transaction in queue.transactions {
            
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            registerProInFirebase(prodID: prodID, promoCode: promoCodeToUse)
            
        }
        
        
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        print("add payment")
        
        for transaction: AnyObject in transactions {
            
            let trans = transaction as! SKPaymentTransaction
            print(trans.error ?? "default error")
            
            switch trans.transactionState {
                
            case .restored:
                print("RESTORED")
                
            case .purchased:
                
                print("BUY OK:")
                print(sKproductToBuy.productIdentifier)
                
                registerProInFirebase(prodID: sKproductToBuy.productIdentifier, promoCode: self.promoCodeToUse)
                
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
            
            if(prodID == promoCodeToUse.product) {
                sKproductToBuy = product
                buyPro()
                break
            }
        }
    }
    
    func buyPro() {
        
        print("buy " + sKproductToBuy.productIdentifier)
        
        let pay = SKPayment(product: sKproductToBuy)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func registerProInFirebase(prodID:String, promoCode:PromoCode) {
        print("adding pro")
        self.ref.child("users/" + self.userId + "/subscription/type").setValue("pro")
        self.ref.child("users/" + self.userId + "/subscription/promocode").setValue(promoCode.code)
        self.ref.child("users/" + self.userId + "/subscription/product").setValue(promoCode.product)
        
        
        let _ = self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    var applyPromo = false
    
    @IBAction func promoTextChanged(_ sender: UITextField) {
        
        if let enteredPromo = txfPromo.text {
            

            if enteredPromo.characters.count == 6 {
                
                
                if let c = self.promoCodesInFirebase[enteredPromo] {
                    
                    labelDiscountApplied.isHidden = false
                    self.applyPromo = true
                    
                    self.promoCodeToUse.code = enteredPromo
                    self.promoCodeToUse.product = c
                    
                }
                else {
                    labelDiscountApplied.isHidden = true
                    self.applyPromo = false
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
                
                self.promoCodesInFirebase = Dictionary<String,String>()
                
                for p in tmpPromos.allValues {
                    
                    if let v = p as? NSDictionary {
                        
                        let promo = PromoCode()
                        promo.code = v.value(forKey: "code") as! String
                        promo.product = v.value(forKey: "product") as! String
                        
                        self.promoCodesInFirebase[promo.code] = promo.product
                    }
                }
                
            }
        })
    }
    
    
    
    
    
    @IBAction func restoreClicked(_ sender: UIButton) {
        
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
}

class PromoCode {
    var code=String()
    var product=String()
}
