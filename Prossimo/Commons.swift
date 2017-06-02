//
//  Constants.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/12/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation
import FontAwesomeKit

public class Commons {
    
    static let myColor = UIColor(red:0.38, green:0.87, blue:0.99, alpha:1.0)//UIColor(red:0.51, green:1.00, blue:0.86, alpha:1.0)
    static let myGrayColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
    static let myDarkGreenColor = UIColor(red:0.00, green:0.50, blue:0.25, alpha:1.0)
    static let myLightLightGrayColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
    static let myPinkColor = UIColor(red:1.00, green:0.72, blue:0.90, alpha:1.0)
    
    static let monthlyProductId = "rifai.prossimo.ios.ppmonthly"
    static let annualProductId = "rifai.prossimo.ios.ppannual"
    static let lifetimeProductId = "rifai.prossimo.ios.pp"
    
    static let monthlyLength = "monthly"
    static let annualLength = "ppannual"
    static let lifetimeLength = "lifetime"
    
    static func getHumanReadableDate(dateString:String) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let date = df.date(from: dateString)
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        
        
        let dateString = formatter.string(from: date!)
        return dateString.uppercased()
        
    }
    
}
