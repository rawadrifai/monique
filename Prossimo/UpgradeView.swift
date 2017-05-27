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
    var promoCodesInFirebase = [PromoCode]()
    var availableProducts = [Product]()

    
    @IBOutlet weak var txfPromo: UITextField!
    @IBOutlet weak var btnUpgrade: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var btnOneMonth: UIButton!
    @IBOutlet weak var btnOneMonthPrice: UIButton!
    @IBOutlet weak var btnOneYear: UIButton!
    @IBOutlet weak var btnRecommended: UIButton!
    @IBOutlet weak var btnOneYearPrice: UIButton!
    @IBOutlet weak var btnLifeTime: UIButton!
    @IBOutlet weak var btnLifeTimePrice: UIButton!
    @IBOutlet weak var imageCheck: UIImageView!
    
    let defaultProducts:[Product] = [
        Product(id: "rifai.prossimo.ios.ppmonthly", price: "6.99", description: "MONTH TO MONTH", length: "monthly"),
        Product(id: "rifai.prossimo.ios.ppannual", price: "54.99", description: "ANNUAL", length: "annual"),
        Product(id: "rifai.prossimo.ios.pp", price: "89.99", description: "LIFETIME", length: "lifetime")
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        requestProductsFromAppStore()
        
        self.ref = FIRDatabase.database().reference()
        getProductsFromFirebase()
        getPromoCodesFromFirebase()
        setBorders()
        
    }
    
    func setBorders() {
        
        self.btnUpgrade.layer.cornerRadius = 5
        self.btnUpgrade.clipsToBounds = true
        
        self.btnRestore.layer.cornerRadius = 5
        self.btnRestore.clipsToBounds = true
    }
    
    
    @IBAction func oneMonthClick(_ sender: UIButton) {
        
        for product in availableProducts {
            switch product.id {
            case defaultProducts[0].id:
                
                changeProduct(productName: product.id)
                selectPlan(productNumber: 1)
                clearPromo()
                break;
            default:
                break;
            }
        }
    }
    
    @IBAction func oneYearClick(_ sender: UIButton) {
        
        for product in availableProducts {
            switch product.id {
            case defaultProducts[1].id:
                
                changeProduct(productName: product.id)
                selectPlan(productNumber: 2)
                clearPromo()
                break;
                
            default:
                break;
            }
        }
    }
    
    @IBAction func lifeTimeClick(_ sender: UIButton) {
        
        for product in availableProducts {
            switch product.id {
            case defaultProducts[2].id:
                
                changeProduct(productName: product.id)
                selectPlan(productNumber: 3)
                clearPromo()
                break;
            default:
                break;
            }
        }
    }
    
    func clearPromo() {
        
        txfPromo.text = ""
        promoCodeToUse = PromoCode()
    }
    
    
    @IBAction func promoTextChanged(_ sender: UITextField) {
        
        guard let enteredPromo = txfPromo.text else {return}
        guard enteredPromo.characters.count == 6 else {return}
        
        
        for promo in self.promoCodesInFirebase {
            
            if enteredPromo == promo.code {
                
                // show the check
                imageCheck.isHidden = false
                
                self.promoCodeToUse = PromoCode(
                    code: enteredPromo,
                    productId: promo.productId,
                    price: promo.price,
                    length: promo.length
                )
                
                // change skProduct to buy
                
                changeProduct(productName: self.promoCodeToUse.productId)
                
                
                // display the proper selection and change the price displayed
                
                switch self.promoCodeToUse.length {
                    
                // monthly
                case self.defaultProducts[0].length:
                    selectPlan(productNumber: 1)
                    
                    btnOneMonthPrice.setTitle(String(describing: self.promoCodeToUse.price), for: .normal)
                    btnOneMonthPrice.setTitle(String(describing: self.promoCodeToUse.price), for: .selected)
                    break;
                    
                // annual
                case self.defaultProducts[1].length:
                    selectPlan(productNumber: 2)
                    
                    btnOneYearPrice.setTitle(String(describing: self.promoCodeToUse.price), for: .normal)
                    btnOneYearPrice.setTitle(String(describing: self.promoCodeToUse.price), for: .selected)
                    break;
                    
                // lifetime
                case self.defaultProducts[2].length:
                    selectPlan(productNumber: 3)
                    
                    btnLifeTimePrice.setTitle(String(describing: self.promoCodeToUse.price), for: .normal)
                    btnLifeTimePrice.setTitle(String(describing: self.promoCodeToUse.price), for: .selected)
                    break;
                    
                default:
                    break;
                }
                
                break;
            } else {
                
                // hide the check
                imageCheck.isHidden = true
            }
            
            imageCheck.isHidden = true
            
        }
        
        
    }
    
    
    // changes the selected products
    func changeProduct(productName:String) {
    
        for p in allSKProducts {
            
            let prodID = p.productIdentifier
            
            if(prodID == productName) {
                sKproductToBuy = p
                enableBtnUpgrade(enabled: true)
                break
            } else {
                enableBtnUpgrade(enabled: false)
            }
            
        }
        
        
    }

    func enableBtnUpgrade(enabled:Bool) {
        if enabled {
            btnUpgrade.isEnabled = true
            btnUpgrade.backgroundColor = Commons.myLightLightGrayColor
            btnUpgrade.setTitleColor(UIColor.lightGray, for: .normal)
        } else {
            btnUpgrade.isEnabled = false
            btnUpgrade.backgroundColor = Commons.myDarkGreenColor
            btnUpgrade.setTitleColor(Commons.myColor, for: .normal)
        }
    }
    
    
    func getProductsFromFirebase() {
        
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        
        
        availableProducts = [Product]()
        
        self.ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let productsDictionary = snapshot.value as? NSDictionary else { return }
            
            guard let product1Dictionary = productsDictionary["Product 1"] as? NSDictionary else { return }
            guard let product2Dictionary = productsDictionary["Product 2"] as? NSDictionary else { return }
            guard let product3Dictionary = productsDictionary["Product 3"] as? NSDictionary else { return }
            
            let product1 = Product(
                id: product1Dictionary["id"] as? String ?? self.defaultProducts[0].id,
                price: product1Dictionary["price"] as? String ?? self.defaultProducts[0].price,
                description: product1Dictionary["description"] as? String ?? self.defaultProducts[0].description,
                length: product1Dictionary["length"] as? String ?? self.defaultProducts[0].length
            )
            
            
            let product2 = Product(
                id: product2Dictionary["id"] as? String ?? self.defaultProducts[1].id,
                price: product2Dictionary["price"] as? String ?? self.defaultProducts[1].price,
                description: product2Dictionary["description"] as? String ?? self.defaultProducts[1].description,
                length: product2Dictionary["length"] as? String ?? self.defaultProducts[1].length
            )
            
            
            
            let product3 = Product(
                id: product3Dictionary["id"] as? String ?? self.defaultProducts[2].id,
                price: product3Dictionary["price"] as? String ?? self.defaultProducts[2].price,
                description: product3Dictionary["description"] as? String ?? self.defaultProducts[2].description,
                length: product3Dictionary["length"] as? String ?? self.defaultProducts[2].length
            )
            
            self.availableProducts.append(product1)
            self.availableProducts.append(product2)
            self.availableProducts.append(product3)
            
            self.resetPricesAndDescription()
            
        })
    }
    
    
    func resetPricesAndDescription() {
        
        print(String(describing: availableProducts[0].price))
        print(String(describing: availableProducts[1].price))
        print(String(describing: availableProducts[2].price))
    
        self.btnOneMonth.setTitle("   " + availableProducts[0].description.uppercased(), for: .normal)
        self.btnOneMonth.setTitle("   " + availableProducts[0].description.uppercased(), for: .selected)
        self.btnOneMonthPrice.setTitle(String(describing: availableProducts[0].price), for: .normal)
        self.btnOneMonthPrice.setTitle(String(describing: availableProducts[0].price), for: .selected)
        
        self.btnOneYear.setTitle("   " + availableProducts[1].description.uppercased(), for: .normal)
        self.btnOneYear.setTitle("   " + availableProducts[1].description.uppercased(), for: .selected)
        self.btnOneYearPrice.setTitle(String(describing: availableProducts[1].price), for: .normal)
        self.btnOneYearPrice.setTitle(String(describing: availableProducts[1].price), for: .selected)
        
        self.btnLifeTime.setTitle("   " + availableProducts[2].description.uppercased(), for: .normal)
        self.btnLifeTime.setTitle("   " + availableProducts[2].description.uppercased(), for: .selected)
        self.btnLifeTimePrice.setTitle(String(describing: availableProducts[2].price), for: .normal)
        self.btnLifeTimePrice.setTitle(String(describing: availableProducts[2].price), for: .selected)
        
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
        print(String(response.products.count) + " products loaded")
        
        for product in myProduct {

            print(product.productIdentifier)
            allSKProducts.append(product)
            
        }
        
        enableBtnUpgrade(enabled: true)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        print("add payment")
        
        for transaction: AnyObject in transactions {
            
            let trans = transaction as! SKPaymentTransaction
            print(trans.error ?? "default error")
            
            switch trans.transactionState {
                
            case .restored:
                print("RESTORED")
                let p = Product()
                p.id = "rifai.prossimo.ios.pp"
                p.length = "restored"
                registerProInFirebase(product: p, promoCode: PromoCode())
                
                
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
                    "Product name": sKproductToBuy.productIdentifier,
                    "Price": sKproductToBuy.price,
                    "Date": NSDate()
                ] as [String : Any]
                
                CleverTap.sharedInstance()?.recordEvent("Product purchased", withProps: props)
                
                print(sKproductToBuy.productIdentifier)
                
                let product = Product();
                product.id = sKproductToBuy.productIdentifier
                product.price = String(describing: sKproductToBuy.price)
                
                registerProInFirebase(product: product, promoCode: self.promoCodeToUse)
                
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
    
    func registerProInFirebase(product:Product, promoCode:PromoCode) {
        
        if !registeredInFirebase {
            
            print("adding pro")
            
            self.ref = FIRDatabase.database().reference()
            self.ref.child("users/" + self.userId + "/subscription/type").setValue("pro")
            self.ref.child("users/" + self.userId + "/subscription/promocode").setValue(promoCode.code)
            self.ref.child("users/" + self.userId + "/subscription/product").setValue(product.id)
            self.ref.child("users/" + self.userId + "/subscription/price").setValue(product.price)
            self.ref.child("users/" + self.userId + "/subscription/date").setValue(NSDate())
            
            registeredInFirebase = true
            
            
        }
    }
    
    
    func getPromoCodesFromFirebase() {
        
        self.ref.child("promocodes").observeSingleEvent(of: .value, with: {
            
            let formatter = NumberFormatter()
            formatter.generatesDecimalNumbers = true
            
            guard let promos = $0.value as? NSDictionary else { return }
            
            self.promoCodesInFirebase = [PromoCode]()
            
            for promo in promos.allValues {
                
                guard let promoValue = promo as? NSDictionary else { return }
         
                let promoCode = PromoCode(
                    code: promoValue.value(forKey: "code") as? String ?? "",
                    productId: promoValue.value(forKey: "productId") as? String ?? "",
                    price: promoValue.value(forKey: "price") as? String ?? "",
                    length: promoValue.value(forKey: "length") as! String
                )
                
                self.promoCodesInFirebase.append(promoCode)
            }
        })
    }
    
    
    
    
    
    @IBAction func restoreClicked(_ sender: UIButton) {
        
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    

    
    func selectPlan(productNumber:Int) {
        
        switch productNumber {
            
        case 1:
            
            btnOneMonth.backgroundColor = Commons.myGrayColor
            btnOneYear.backgroundColor = Commons.myLightLightGrayColor
            btnLifeTime.backgroundColor = Commons.myLightLightGrayColor
            btnRecommended.backgroundColor = Commons.myLightLightGrayColor
            btnOneMonthPrice.backgroundColor = Commons.myGrayColor
            btnOneYearPrice.backgroundColor = Commons.myLightLightGrayColor
            btnLifeTimePrice.backgroundColor = Commons.myLightLightGrayColor
            
            
            btnOneMonth.setTitleColor(UIColor.white, for: .normal)
            btnOneYear.setTitleColor(UIColor.lightGray, for: .normal)
            btnLifeTime.setTitleColor(UIColor.lightGray, for: .normal)
            btnRecommended.setTitleColor(UIColor.lightGray, for: .normal)
            btnOneMonthPrice.setTitleColor(UIColor.white, for: .normal)
            btnOneYearPrice.setTitleColor(UIColor.lightGray, for: .normal)
            btnLifeTimePrice.setTitleColor(UIColor.lightGray, for: .normal)

            break;
            
        case 2:
            
            btnOneMonth.backgroundColor = Commons.myLightLightGrayColor
            btnOneYear.backgroundColor = Commons.myGrayColor
            btnLifeTime.backgroundColor = Commons.myLightLightGrayColor
            btnRecommended.backgroundColor = Commons.myGrayColor
            btnOneMonthPrice.backgroundColor = Commons.myLightLightGrayColor
            btnOneYearPrice.backgroundColor = Commons.myGrayColor
            btnLifeTimePrice.backgroundColor = Commons.myLightLightGrayColor
            
            btnOneMonth.setTitleColor(UIColor.lightGray, for: .normal)
            btnOneYear.setTitleColor(UIColor.white, for: .normal)
            btnLifeTime.setTitleColor(UIColor.lightGray, for: .normal)
            btnRecommended.setTitleColor(UIColor.white, for: .normal)
            btnOneMonthPrice.setTitleColor(UIColor.lightGray, for: .normal)
            btnOneYearPrice.setTitleColor(UIColor.white, for: .normal)
            btnLifeTimePrice.setTitleColor(UIColor.lightGray, for: .normal)

            break;
            
        case 3:
            
            btnOneMonth.backgroundColor = Commons.myLightLightGrayColor
            btnOneYear.backgroundColor = Commons.myLightLightGrayColor
            btnLifeTime.backgroundColor = Commons.myGrayColor
            btnRecommended.backgroundColor = Commons.myLightLightGrayColor
            btnOneMonthPrice.backgroundColor = Commons.myLightLightGrayColor
            btnOneYearPrice.backgroundColor = Commons.myLightLightGrayColor
            btnLifeTimePrice.backgroundColor = Commons.myGrayColor
            
            btnOneMonth.setTitleColor(UIColor.lightGray, for: .normal)
            btnOneYear.setTitleColor(UIColor.lightGray, for: .normal)
            btnLifeTime.setTitleColor(UIColor.white, for: .normal)
            btnRecommended.setTitleColor(UIColor.lightGray, for: .normal)
            btnOneMonthPrice.setTitleColor(UIColor.lightGray, for: .normal)
            btnOneYearPrice.setTitleColor(UIColor.lightGray, for: .normal)
            btnLifeTimePrice.setTitleColor(UIColor.white, for: .normal)
            
            break;
            
        default:
            
            break;
        }
    }

    
}

protocol UpgradeDelegate {
    func subscriptionChanged(subscription: String)
}

