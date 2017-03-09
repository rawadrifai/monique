//
//  Client.swift
//  Monique
//
//  Created by Elrifai, Rawad on 2/22/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation
import UIKit

class Client {
    
    var clientId:String
    var clientName:String
    var clientEmail:String
    var profileImg:UIImage?
    
    init() {
        clientId = ""
        clientName = ""
        clientEmail = ""
        profileImg = UIImage()
    }
    
    init(clientId:String, clientName:String, clientEmail:String, profileImg:UIImage) {
        self.clientId = clientId
        self.clientName = clientName
        self.clientEmail = clientEmail
        self.profileImg = profileImg
    }
}

class ClientVisit {
    
}
