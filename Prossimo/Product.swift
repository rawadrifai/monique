//
//  Product.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/23/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation

public class Product {
    
    var id:String
    var price:Double
    var description:String
    var length:String
    
    init() {
        id = ""
        price = 0
        description = ""
        length = ""
    }
    
    init(id:String, price:Double, description:String, length:String) {
        self.id = id
        self.price = price
        self.description = description
        self.length = length
    }
}
