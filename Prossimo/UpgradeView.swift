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


class UpgradeView: UIViewController {

    var delegate: UpgradeDelegate?
    
    var ref: FIRDatabaseReference!
    var userId:String!
    var sKproductToBuy = SKProduct()
    var promoCodeToUse = PromoCode()
    var promoCodesInFirebase = [PromoCode]()
    var registeredLocally = false
    var registeredInFirebase = false
    
    
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
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        registerNotifications()
        
        self.ref = FIRDatabase.database().reference()
        getPromoCodesFromFirebase()
        setBorders()
        

       // let receiptManager = ReceiptManager()

        
        
        productsFinishedLoading()
        
    }

    func registerNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.productsFinishedLoading), name: NSNotification.Name.init("SKProductsHaveLoaded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.productPurchased), name: NSNotification.Name.init("SKProductPurchased"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.productRestored), name: NSNotification.Name.init("SKProductRestored"), object: nil)
        
    }
    
    
    // after the products finish loading, we need to set the prices and enable the upgrade button
    func productsFinishedLoading() {
        
        for product in StoreManager.shared.productsFromStore {
            
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceLocale
            
            
            switch product.productIdentifier {
                
            case Commons.lifetimeProductId:
                btnLifeTimePrice.setTitle(formatter.string(from: product.price), for: .normal)
                break;
                
            case Commons.monthlyProductId:
                btnOneMonthPrice.setTitle(formatter.string(from: product.price), for: .normal)
                break;
                
            case Commons.annualProductId:
                btnOneYearPrice.setTitle(formatter.string(from: product.price), for: .normal)
                break;
            default:
                break;
            }
        }
        
        enableBtnUpgrade(enabled: true)
    }

    
    func productPurchased(notification:NSNotification) {
        
        // get purchased product from notification
        let productDict = notification.userInfo
        guard let productPurchased = productDict?["product"] as? SKProduct else {
            return
        }
        
        // register event in clever tap
        CleverTapManager.shared.registerProductPurchaseEvent(product: productPurchased)
        
        // store registration on local device (only if lifetime)
        registerProLocallyForever(product: productPurchased)
        
        // update firebase
        registerProInFirebase(product: productPurchased, promoCode: self.promoCodeToUse)
        
        
        // fire the delegate back to info view
        if let del = self.delegate {
            del.subscriptionChanged(subscription: "pro")
        }
        
        let _ = self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
        
        print("product purchased is " + productPurchased.productIdentifier)
    }
    
    func productRestored(notification:NSNotification) {
        
        // get purchased product from notification
        let productDict = notification.userInfo
        guard let productPurchased = productDict?["product"] as? SKProduct else {
            return
        }
        
        // register event in clever tap
        CleverTapManager.shared.registerProductRestoreEvent(product: productPurchased)
        
        // store registration on local device (only if lifetime)
        registerProLocallyForever(product: productPurchased)
        
        // update firebase
        registerProInFirebase(product: productPurchased, promoCode: self.promoCodeToUse)
        
        
        // fire the delegate back to info view
        if let del = self.delegate {
            del.subscriptionChanged(subscription: "pro")
        }
        
        let _ = self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
        
        print("product restored is " + productPurchased.productIdentifier)
    }
    
    func setBorders() {
        
        self.btnUpgrade.layer.cornerRadius = 5
        self.btnUpgrade.clipsToBounds = true
        
        self.btnRestore.layer.cornerRadius = 5
        self.btnRestore.clipsToBounds = true
    }
    
    
    @IBAction func oneMonthClick(_ sender: UIButton) {
        
        for product in StoreManager.shared.productsFromStore {
            switch product.productIdentifier {
            case Commons.monthlyProductId:
                
                changeProduct(productName: product.productIdentifier)
                selectPlan(productId: product.productIdentifier)
                clearPromo()
                break;
            default:
                break;
            }
        }
    }
    
    @IBAction func oneYearClick(_ sender: UIButton) {
        
        for product in StoreManager.shared.productsFromStore {
            switch product.productIdentifier {
            case Commons.annualProductId:
                
                changeProduct(productName: product.productIdentifier)
                selectPlan(productId: product.productIdentifier)
                clearPromo()
                break;
            default:
                break;
            }
        }
    }
    
    @IBAction func lifeTimeClick(_ sender: UIButton) {
        
        for product in StoreManager.shared.productsFromStore {
            switch product.productIdentifier {
            case Commons.lifetimeProductId:
                
                changeProduct(productName: product.productIdentifier)
                selectPlan(productId: product.productIdentifier)
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
                    productToApplyPromoOn: promo.productToApplyPromoOn
                )
                
                // change skProduct to buy
                changeProduct(productName: promo.productId)
                
                // change selection
                selectPlan(productId: promo.productToApplyPromoOn)
                
                // display the proper selection and change the price displayed
                
                switch self.promoCodeToUse.productToApplyPromoOn {
                    
                // monthly
                case Commons.monthlyProductId:
                    
                    btnOneMonthPrice.setTitle(String(describing: self.promoCodeToUse.price), for: .normal)
                    btnOneMonthPrice.setTitle(String(describing: self.promoCodeToUse.price), for: .selected)
                    break;
                    
                // annual
                case Commons.annualProductId:
                    
                    btnOneYearPrice.setTitle(String(describing: self.promoCodeToUse.price), for: .normal)
                    btnOneYearPrice.setTitle(String(describing: self.promoCodeToUse.price), for: .selected)
                    break;
                    
                // lifetime
                case Commons.lifetimeProductId:
                    
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
    
        for p in StoreManager.shared.productsFromStore {
            
            let prodID = p.productIdentifier
            
            if(prodID == productName) {
                sKproductToBuy = p
                break
            }
        }
        
        
    }

    func enableBtnUpgrade(enabled:Bool) {
        if enabled {
            btnUpgrade.isEnabled = true
            btnUpgrade.setTitleColor(Commons.myColor, for: .normal)
        } else {
            btnUpgrade.isEnabled = false
            btnUpgrade.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    
    
   
    
    
    
    
    
    
    

    @IBAction func upgradeClick(_ sender: UIButton) {

        StoreManager.shared.buy(product: sKproductToBuy)
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
                    productToApplyPromoOn: promoValue.value(forKey: "productToApplyPromoOn") as! String
                )
                
                self.promoCodesInFirebase.append(promoCode)
            }
        })
    }
    
    
    
    
    
    @IBAction func restoreClicked(_ sender: UIButton) {
        
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    

    
    func selectPlan(productId:String) {
        
        switch productId {
            
        case Commons.monthlyProductId:
            
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
            
        case Commons.annualProductId:
            
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
            
        case Commons.lifetimeProductId:
            
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








extension UpgradeView {
    
    
    
    func registerProLocallyForever(product:SKProduct) {
        
        if !registeredLocally {
            
            if product.productIdentifier == "rifai.prossimo.ios.pp" {
                print("adding pro to local")
                
                UserDefaults.standard.set(true, forKey: "ppLifeTimeActive")
                UserDefaults.standard.synchronize()
            }
            registeredLocally = true
            
        }
    }
    
    
    func registerProInFirebase(product:SKProduct, promoCode:PromoCode) {
        
        if !registeredInFirebase {
            
            print("adding pro")
            
            self.ref = FIRDatabase.database().reference()
            self.ref.child("users/" + self.userId + "/subscription/type").setValue("pro")
            self.ref.child("users/" + self.userId + "/subscription/promocode").setValue(promoCode.code)
            self.ref.child("users/" + self.userId + "/subscription/product").setValue(product.productIdentifier)
            self.ref.child("users/" + self.userId + "/subscription/price").setValue(product.price)
            self.ref.child("users/" + self.userId + "/subscription/date").setValue(NSDate())
            
            registeredInFirebase = true
            
            
        }
    }

    
}

protocol UpgradeDelegate {
    func subscriptionChanged(subscription: String)
}

