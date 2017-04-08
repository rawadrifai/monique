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
    var clientPhone:String
    var profileImg:ImageObject
    
    var clientVisits:[ClientVisit]
    
    init() {
        self.clientId = ""
        self.clientName = ""
        self.clientEmail = ""
        self.clientPhone = ""
        self.profileImg = ImageObject()
        
        self.clientVisits = []
    }
    
    init(clientId:String, clientName:String, clientEmail:String, clientPhone:String) {
        self.clientId = clientId
        self.clientName = clientName
        self.clientEmail = clientEmail
        self.clientPhone = clientPhone
        self.profileImg = ImageObject()
        self.clientVisits = []
    }
    
    init(clientId:String, clientName:String, clientEmail:String, clientPhone:String, profileImg:ImageObject) {
        self.clientId = clientId
        self.clientName = clientName
        self.clientEmail = clientEmail
        self.clientPhone = clientPhone
        self.profileImg = profileImg
        
        self.clientVisits = []
    }
    
}

class ClientVisit {
    var visitDate:String
    var sortingDate:String
    var notes:String
    var images:[ImageObject]
    var options:[String:String]
    
    init() {
        visitDate = ""
        sortingDate = ""
        notes = ""
        images = [ImageObject]()
        options = [String:String]()
    }
    
    init(visitDate:String, sortingDate:String, notes:String) {
        self.visitDate = visitDate
        self.sortingDate = sortingDate
        self.notes = notes
        self.images = [ImageObject]()
        options = [String:String]()
    }
}

class ImageObject {
    var imageName:String
    var imageUrl:String
    var uploadDate:String
    
    init() {
        self.imageName=""
        self.imageUrl=""
        self.uploadDate=""
    }
    
    init(imageName:String, imageUrl:String) {
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.uploadDate = ""
    }
    
    init(imageName:String, imageUrl:String, uploadDate:String) {
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.uploadDate = uploadDate
    }
}



