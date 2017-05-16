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

    var delegate: UpgradeDelegate?
    
    var ref: FIRDatabaseReference!
    var userId:String!
    var allSKProducts = [SKProduct]()
    var sKproductToBuy = SKProduct()
    var productsInFirebase = Set<String>()
    var promoCodeToUse = PromoCode()
    var promoCodesInFirebase = Dictionary<String, String>()
    
    @IBOutlet weak var txfPromo: UITextField!
    @IBOutlet weak var labelDiscountApplied: UILabel!
    @IBOutlet weak var btnUpgrade: UIButton!

    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var productSC: UISegmentedControl!
    
    @IBAction func productChanged(_ sender: UISegmentedControl) {
        
        // change the product when selection changes
        changeProduct(productName: self.availableProducts[productSC.selectedSegmentIndex])
        
    }
    
    // changes the selected products
    func changeProduct(productName:String) {
    
        for product in allSKProducts {
            
            let prodID = product.productIdentifier
            
            if(prodID == productName) {
                sKproductToBuy = product
                break
            }
        }
        
        txfPromo.text = ""
        promoCodeToUse = PromoCode()
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        getProductsFromFirebase()
        getPromoCodesFromFirebase()
        
        setBorders()
        changeProduct(productName: self.availableProducts[productSC.selectedSegmentIndex])
        
    }
    
    func setBorders() {
        self.btnUpgrade.layer.cornerRadius = 5
        self.btnUpgrade.clipsToBounds = true
        
        self.btnRestore.layer.cornerRadius = 5
        self.btnRestore.clipsToBounds = true
        
        
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
    
    let availableProducts:[String] = ["rifai.prossimo.ios.pp","rifai.prossimo.ios.pponeyear"]
        
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        
        let myProduct = response.products
        
        for product in myProduct {

            print(product.productIdentifier)
            allSKProducts.append(product)
            
            
            // pick the default product
            if product.productIdentifier == "rifai.prossimo.ios.pponeyear" {
                sKproductToBuy = product
                promoCodeToUse.code = "none"
                promoCodeToUse.product = product.productIdentifier
            }
        }
        
        btnUpgrade.isEnabled = true
        
        
    }
    
 //   func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
 //       print("transactions restored")
        
 //       for transaction in queue.transactions {
            
 //           let t: SKPaymentTransaction = transaction
 //           let prodID = t.payment.productIdentifier as String
            
            
            
 //       }
        
        
 //   }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        print("add payment")
        
        for transaction: AnyObject in transactions {
            
            let trans = transaction as! SKPaymentTransaction
            print(trans.error ?? "default error")
            
            switch trans.transactionState {
                
            case .restored:
                print("RESTORED")
                let p = PromoCode.init()
                p.product = "rifai.prossimo.ios.pp"
                p.code = "restored"
                registerProInFirebase(prodID: p.product, promoCode: p)
                
                
                if let del = self.delegate {
                    del.subscriptionChanged(subscription: "pro")
                }
                
                let _ = self.navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
                
                queue.finishTransaction(trans)
                
            case .purchased:
                
                print("BUY OK:")
                
                // send event to clever tap
                
                let props = [
                    "Product name": "Casio Chronograph Watch",
                    "Price": sKproductToBuy.price,
                    "Date": NSDate()
                ] as [String : Any]
                
                CleverTap.sharedInstance()?.recordEvent("Product purchase", withProps: props)
                
                print(sKproductToBuy.productIdentifier)
                
                registerProInFirebase(prodID: sKproductToBuy.productIdentifier, promoCode: self.promoCodeToUse)
                
                if let del = self.delegate {
                    del.subscriptionChanged(subscription: "pro")
                }
                
                let _ = self.navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
                
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
        
        buyPro()
    }
    
    func buyPro() {
        
        print("buy " + sKproductToBuy.productIdentifier)
        
        let pay = SKPayment(product: sKproductToBuy)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
        
    }
    
    var registeredInFirebase = false
    
    func registerProInFirebase(prodID:String, promoCode:PromoCode) {
        if !registeredInFirebase {
            print("adding pro")
            
            self.ref = FIRDatabase.database().reference()
            self.ref.child("users/" + self.userId + "/subscription/type").setValue("pro")
            self.ref.child("users/" + self.userId + "/subscription/promocode").setValue(promoCode.code)
            self.ref.child("users/" + self.userId + "/subscription/product").setValue(promoCode.product)
            
            registeredInFirebase = true
            
            
        }
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
                    
                    for product in allSKProducts {
                        if product.productIdentifier == c {
                            sKproductToBuy = product
                            break;
                        }
                    }
                    
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

protocol UpgradeDelegate {
    func subscriptionChanged(subscription: String)
}

class PromoCode {
    var code:String!
    var product:String!
    
    init() {
        code = ""
        product = ""
    }
}
