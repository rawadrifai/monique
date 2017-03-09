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
    
    var clientVisit:ClientVisit
    
    init() {
        clientId = ""
        clientName = ""
        clientEmail = ""
        profileImg = UIImage()
        clientVisit = ClientVisit()
    }
    
    init(clientId:String, clientName:String, clientEmail:String, profileImg:UIImage) {
        self.clientId = clientId
        self.clientName = clientName
        self.clientEmail = clientEmail
        self.profileImg = profileImg
        clientVisit = ClientVisit()
    }
    
}

class ClientVisit {
    var visitDate:String
    var notes:String
    
    init() {
        visitDate = ""
        notes = ""
    }
    
    init(visitDate:String, notes:String) {
        self.visitDate = visitDate
        self.notes = notes
    }
    
    
}
