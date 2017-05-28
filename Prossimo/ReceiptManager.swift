//
//  ReceiptManager.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/28/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation
import StoreKit


#if DEBUG
let isDebug = true
#else
let isDebug = false
#endif


enum ReceiptValidatingItunesURLS:String {
    case sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
    case production = "https://buy.itunes.apple.com/verifyReceipt"
    
    static var url:URL {
        if isDebug {
            return URL.init(string: self.sandbox.rawValue)!
        } else {
            return URL.init(string: self.production.rawValue)!
        }
    }
}

public class ReceiptManager:NSObject {
    
    public override init() {
        super.init()
        
        UserDefaults.standard.set(false, forKey: "didRefreshReceipt")
        self.startValidatingReceipts()
    }
    
    func startValidatingReceipts() {
        
        do {
        _ = try self.getReceiptURL()?.checkResourceIsReachable()
            
            do {
                let data = try Data(contentsOf: self.getReceiptURL()!)
                self.validateData(data: data)
                
            } catch {
                print("unable to read receipt")
            }
        } catch {
            
            // if receipt doesn't exist we refresh from app store
            
            guard UserDefaults.standard.bool(forKey: "didRefreshReceipt") == false else {
                print("Stopped after second attempt")
                return
            }
            
            UserDefaults.standard.set(true, forKey: "didRefreshReceipt")
            
            let receiptRequest = SKReceiptRefreshRequest()
            receiptRequest.delegate = self as! SKRequestDelegate
            receiptRequest.start()
            
            print("Receipt URL does not exist, refreshing from app store")
        }
    }
    
    func getReceiptURL() -> URL? {
        return Bundle.main.appStoreReceiptURL
    }
    
    func validateData(data:Data) {
        
        // encode data to base 64
        let receiptsString = data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        
        // wrap receipt with secret
        var dic:[String:AnyObject] = ["receipt-data":receiptsString as AnyObject]
        let sharedSecret = ""
        dic["password"] = sharedSecret as AnyObject?
        
        // convert to json object
        let json = try! JSONSerialization.data(withJSONObject: dic, options: [])
        
        // create url request object
        var urlRequest = URLRequest(url: ReceiptValidatingItunesURLS.url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = json
        
        
        // use url session to send request
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let receiptData = data  {
                self.handleData(data: receiptData)
            } else {
                print("error validating receipt with itunes connect")
                return
            }
            
            
            
        }
        
    }
    
    func handleData(data:Data) {
        
        // get json value of the data
        guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary else {
            print("not able to encode json object")
            return
        }
        
        // get status
        guard let status = json?["status"] as? NSNumber else {
            return
        }
        
        // status OK
        if status == 0 {
            
            // get receipt section of json
            let receipt = json?["receipt"] as! NSDictionary
            
            // get in app section
            guard let inApps = receipt["in_app"] as? [NSDictionary] else {
                print("no in-app purchases available")
                return
            }
            
            // loop through products
            for inApp in inApps {
                
                let prodID = inApp["product_id"]
                
                guard let expiryDate = inApp["expires_date_ms"] as? NSString else {
                    continue
                }
                
                self.checkSubscriptionStatu(date: Date.init(timeIntervalSince1970: expiryDate.doubleValue/1000))
            }
        
        } else {
            print("error validating receipts - data not correct")
        }
    }
}

extension ReceiptManager {
    
    func checkSubscriptionStatu(date:Date) {
        
        let calendar = Calendar.current
        let now = Date()
        let order = calendar.compare(now, to: date, toGranularity: .minute)
        
        switch order {
        case .orderedAscending:
            print("User subscribed")
        default:
            print("user subscription has expired")
        }
    }
    
    var isSubscribed:Bool {
        guard let currentActiveSubscription = UserDefaults.standard.value(forKey: "activeSubscriptionKey") as? Date else {
            return false
        }
        
        return currentActiveSubscription.timeIntervalSince1970 > Date().timeIntervalSince1970
    }
}

extension ReceiptManager {
    
    func saveActiveSubscriptions(date:Date) {
        
        UserDefaults.standard.set(date, forKey: "activeSubscriptionKey")
        UserDefaults.standard.synchronize()
    }
}

extension ReceiptManager:SKRequestDelegate {
    
    public func requestDidFinish(_ request: SKRequest) {
        self.startValidatingReceipts()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        //
    }
}
