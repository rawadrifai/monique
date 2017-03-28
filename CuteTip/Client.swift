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
    var profileImg:ImageObject
    
    var clientVisits:[ClientVisit]
    
    init() {
        clientId = ""
        clientName = ""
        clientEmail = ""
        profileImg = ImageObject()
        
        clientVisits = []
    }
    
    init(clientId:String, clientName:String, clientEmail:String) {
        self.clientId = clientId
        self.clientName = clientName
        self.clientEmail = clientEmail
        self.profileImg = ImageObject()
        clientVisits = []
    }
    
    init(clientId:String, clientName:String, clientEmail:String, profileImg:ImageObject) {
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
    var images:[ImageObject]
    
    init() {
        visitDate = ""
        notes = ""
        images = [ImageObject]()
    }
    
    init(visitDate:String, notes:String) {
        self.visitDate = visitDate
        self.notes = notes
        self.images = [ImageObject]()
    }
    
    init(visitDate:String, notes:String, images:[ImageObject]) {
        self.visitDate = visitDate
        self.notes = notes
        self.images = images
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



