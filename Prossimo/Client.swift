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
    var expenses:[Expense]
    
    init() {
        self.clientId = ""
        self.clientName = ""
        self.clientEmail = ""
        self.clientPhone = ""
        self.profileImg = ImageObject()
        
        self.clientVisits = [ClientVisit]()
        self.expenses = [Expense]()
    }
    
    init(clientId:String, clientName:String, clientEmail:String, clientPhone:String) {
        self.clientId = clientId
        self.clientName = clientName
        self.clientEmail = clientEmail
        self.clientPhone = clientPhone
        self.profileImg = ImageObject()
        
        self.clientVisits = [ClientVisit]()
        self.expenses = [Expense]()
    }
    
    init(clientId:String, clientName:String, clientEmail:String, clientPhone:String, profileImg:ImageObject) {
        self.clientId = clientId
        self.clientName = clientName
        self.clientEmail = clientEmail
        self.clientPhone = clientPhone
        self.profileImg = profileImg
        
        self.clientVisits = [ClientVisit]()
        self.expenses = [Expense]()
    }
    
}

class Expense {

    var id:String
    var item:String
    var price:Double
    var date:String
    var sortingDate:String
    var receipts:[Receipt]
    
    init() {
        
        id = ""
        item = ""
        price = 0
        date = ""
        sortingDate = ""
        receipts = [Receipt]()
    }
    
    init(id:String, item:String, price:Double, date:String, sortingDate:String) {
        
        self.id = id
        self.item = item
        self.price = price
        self.date = date
        self.sortingDate = sortingDate
        self.receipts = [Receipt]()
    }
}

class Receipt {

    var id:String
    var imageUrl:String
    var uploadDate:String
    
    init() {
        id = ""
        imageUrl = ""
        uploadDate = ""
    }
    
    init(id:String, imageUrl:String, uploadDate:String) {
        self.id = id
        self.imageUrl = imageUrl
        self.uploadDate = uploadDate
    }

}

class ClientVisit {
    var visitDate:String
    var sortingDate:String
    var notes:String
    var images:[ImageObject]
    var options:[String:String]
    var starred:Bool
    var price:Double
    
    init() {
        visitDate = ""
        sortingDate = ""
        notes = ""
        images = [ImageObject]()
        options = [String:String]()
        starred=false
        price=0
    }
    
    init(visitDate:String, sortingDate:String, notes:String) {
        self.visitDate = visitDate
        self.sortingDate = sortingDate
        self.notes = notes
        self.images = [ImageObject]()
        options = [String:String]()
        starred=false
        price=0
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



