//
//  Enums.swift
//  Prossimo
//
//  Created by Rawad Rifai on 6/26/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation
import EasyTipView

class TipViews {
    
    static let shared = TipViews()
    
    init() {
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont.boldSystemFont(ofSize: 17)//.systemFont(ofSize: 17)// UIFont(name: "Futura-Medium", size: 18)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hue:0, saturation:0, brightness:0, alpha:0.9)
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        
        EasyTipView.globalPreferences = preferences

    }
    
    
    let addClientText = "\nTap  '+'  to add new clients\n\nOK\n"
    let importClientText = "\nOr import from existing phone contacts\n\nOK\n"
    let newHcText = "\nTap here to add a new visit\n\nOK\n"
    let remindersText = "\nSchedule a text reminder for next visit\n\nOK\n"
    let favoritesText = "\nFilter by client's favorite haircuts\n\nOK\n"
    let priceText = "\nSelect or enter exact charge for the visit\n\nOK\n"
    let notesText = "\nEnter haircut notes\n\nOK\n"
    let stylesText = "\nSelect ready styles\n\nOK\n"
    let picturesText = "\nTap the camera to add photos\n\nOK\n"
    let addExpenseText = "\nTap  '+'  to add new expenses\n\nOK\n"
    let receiptsText = "\nTap the camera to add receipts\n\nOK\n"
    
    

    
}
