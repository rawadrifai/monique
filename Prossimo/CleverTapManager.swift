//
//  CleverTapManager.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/29/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation
import StoreKit


class CleverTapManager {
    
    static var shared:CleverTapManager = {
        return CleverTapManager()
    }()
    
    
    func registerProductPurchaseEvent(product:SKProduct) {
        
        
        let props = [
            "Product Name": product.productIdentifier,
            "Price": product.price,
            "Date": NSDate()
            ] as [String : Any]
        
        CleverTap.sharedInstance()?.recordEvent("Product purchased", withProps: props)
    }
    
    func registerProductRestoreEvent(product:SKProduct) {
        
        
        let props = [
            "Product Name": product.productIdentifier,
            "Price": product.price,
            "Date": NSDate()
            ] as [String : Any]
        
        CleverTap.sharedInstance()?.recordEvent("Product restored", withProps: props)
    }
    
    func registerEvent(eventName:String) {
        
        CleverTap.sharedInstance()?.recordEvent(eventName)
    }
}
