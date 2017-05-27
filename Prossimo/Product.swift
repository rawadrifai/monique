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
    var price:String
    var description:String
    var length:String
    
    init() {
        id = ""
        price = ""
        description = ""
        length = ""
    }
    
    init(id:String, price:String, description:String, length:String) {
        self.id = id
        self.price = price
        self.description = description
        self.length = length
    }
}
