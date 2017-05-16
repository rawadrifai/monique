//
//  Constants.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/12/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation

public class Commons {
    
    static let myColor = UIColor(red:0.51, green:1.00, blue:0.86, alpha:1.0)
    
    static let myGrayColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
    
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