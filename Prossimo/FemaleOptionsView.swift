//
//  MoreView.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/6/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FemaleOptionsView: UIViewController {
    
    
    var selectedVisitIndex:Int!
    var userId:String!
    var client:Client!
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var btnLong: UIButton!
    @IBOutlet weak var btnMedium: UIButton!
    @IBOutlet weak var btnShort: UIButton!
    @IBOutlet weak var btnBlunt: UIButton!
    @IBOutlet weak var btnTexturized: UIButton!
    @IBOutlet weak var btnInnerLayers: UIButton!
    @IBOutlet weak var btnBangs: UIButton!
    @IBOutlet weak var btnFaceFraming: UIButton!
    @IBOutlet weak var btnColor: UIButton!
    @IBOutlet weak var btnBlowDry: UIButton!
    
    
    var selectedVisit = ClientVisit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        
        selectedVisit = self.client.clientVisits[selectedVisitIndex]
        loadOptions()
    }
    
    func emptyOptions() -> [String:String] {
        
        return
            ["long":"0",
             "medium":"0",
             "short":"0",
             "blunt":"0",
             "texturized":"0",
             "inner layers":"0",
             "bangs":"0",
             "face framing":"0",
             "color":"0",
             "blow dry":"0"]
    }
    
    func loadOptions() {
        
        if self.client.clientVisits[selectedVisitIndex].options.count == 0 {
            self.client.clientVisits[selectedVisitIndex].options = emptyOptions()
        }
        
        
        var btnText = btnLong.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnLong.backgroundColor = Commons.myGrayColor
                btnLong.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnMedium.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnMedium.backgroundColor = Commons.myGrayColor
                btnMedium.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnShort.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnShort.backgroundColor = Commons.myGrayColor
                btnShort.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnBlunt.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnBlunt.backgroundColor = Commons.myGrayColor
                btnBlunt.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnTexturized.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnTexturized.backgroundColor = Commons.myGrayColor
                btnTexturized.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnInnerLayers.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnInnerLayers.backgroundColor = Commons.myGrayColor
                btnInnerLayers.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnBangs.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnBangs.backgroundColor = Commons.myGrayColor
                btnBangs.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnFaceFraming.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnFaceFraming.backgroundColor = Commons.myGrayColor
                btnFaceFraming.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnColor.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnColor.backgroundColor = Commons.myGrayColor
                btnColor.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnBlowDry.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnBlowDry.backgroundColor = Commons.myGrayColor
                btnBlowDry.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        
    }
    
    
    
    func saveOption(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        guard let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] else {
            
            self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
            sender.backgroundColor = Commons.myGrayColor
            sender.setTitleColor(Commons.myColor, for: .normal)
            
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            
            return
        }
        if state == "0" {
            self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
            sender.backgroundColor = Commons.myGrayColor
            sender.setTitleColor(Commons.myColor, for: .normal)
            
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
        }
        else {
            self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
            sender.backgroundColor = UIColor.groupTableViewBackground
            sender.setTitleColor(UIColor.lightGray, for: .normal)
            
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
        }
        
    }
    
    
    @IBAction func btnLongClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnMediumClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnShortClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnBluntClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnTexturizedClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnInnerLayersClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnBangsClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnFaceFramingClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnColorClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnBlowDryClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
}
