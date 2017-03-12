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
    
    var clientVisits:[ClientVisit]
    
    init() {
        clientId = ""
        clientName = ""
        clientEmail = ""
        profileImg = UIImage()
        
        clientVisits = []
    }
    
    init(clientId:String, clientName:String, clientEmail:String, profileImg:UIImage) {
        self.clientId = clientId
        self.clientName = clientName
        self.clientEmail = clientEmail
        self.profileImg = profileImg
        
        clientVisits = []
    }
    
}

class ClientVisit {
    var visitDate:String
    var notes:String
    var images:[String]
    
    init() {
        visitDate = ""
        notes = ""
        images = [String]()
    }
    
    init(visitDate:String, notes:String) {
        self.visitDate = visitDate
        self.notes = notes
        self.images = [String]()
    }
    
    init(visitDate:String, notes:String, images:[String]) {
        self.visitDate = visitDate
        self.notes = notes
        self.images = images
    }
    
    
}
