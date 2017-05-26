//
//  PromoCode.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/24/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation

public class PromoCode {
    var code:String
    var productId:String
    var price:Double
    var length:String
    
    init() {
        code = ""
        productId = ""
        price = 0
        length = ""
    }
    
    init(code:String, productId:String, price:Double, length:String) {
        self.code = code
        self.productId = productId
        self.price = price
        self.length = length
    }
}
