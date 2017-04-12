//
//  NetworkActivityIndicatorManager.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/11/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation

class NetworkActivityIndicatorManager : NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    class func networkOperationFinished(){
        if loadingCount > 0 {
            loadingCount -= 1
            
        }
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
    }
}
