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
    static let lifetimeDiscountedProductIds = ["rifai.prossimo.ios.pp00", "rifai.prossimo.ios.pp70"]
    
    static let appStoreUrl = "itms-apps://itunes.apple.com/us/app/prossimo-hair-stylist-assistant/id1220990527?ls=1&mt=8"
    
    static func getHumanReadableDate(dateString:String) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let date = df.date(from: dateString)
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        
        
        let dateString = formatter.string(from: date!)
        return dateString.uppercased()
        
    }
    
    static func getTodaysShortDate() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let todaysDate = String(month) + "-" + String(day) + "-" + String(year)
        
        return todaysDate
        
    }
    
    static func getShortDate(from fromDate:Date) -> String {
        
    
        let calendar = Calendar.current
        let year = calendar.component(.year, from: fromDate)
        
        let month = calendar.component(.month, from: fromDate)
        let day = calendar.component(.day, from: fromDate)
        let date = String(month) + "-" + String(day) + "-" + String(year)
        
        return date
        
    }
    
    static func getTodaysSortingDate() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let yearString = String(format: "%04d", year)
        
        let month = calendar.component(.month, from: date)
        let monthString = String(format: "%02d", month)
        
        let day = calendar.component(.day, from: date)
        let dayString = String(format: "%02d", day)
        
        let sortingDate = yearString + "-" + monthString + "-" + dayString
        return sortingDate
        
    }
    
    static func getSortingDate(from fromDate:Date) -> String {
        
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: fromDate)
        let yearString = String(format: "%04d", year)
        
        let month = calendar.component(.month, from: fromDate)
        let monthString = String(format: "%02d", month)
        
        let day = calendar.component(.day, from: fromDate)
        let dayString = String(format: "%02d", day)
        
        let sortingDate = yearString + "-" + monthString + "-" + dayString
        return sortingDate
        
    }
    
}
