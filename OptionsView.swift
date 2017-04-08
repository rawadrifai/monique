//
//  MoreView.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/6/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseDatabase

class OptionsView: UIViewController {

    
    var selectedVisitIndex:Int!
    var userId:String!
    var client:Client!
    var ref: FIRDatabaseReference!

    @IBOutlet weak var btnScissor: UIButton!
    @IBOutlet weak var btnClipper: UIButton!
    @IBOutlet weak var btnTexturize: UIButton!
    @IBOutlet weak var btnSkin: UIButton!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn12: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btnHigh: UIButton!
    @IBOutlet weak var btnLow: UIButton!
    @IBOutlet weak var btnTaper: UIButton!
    @IBOutlet weak var btnNatural: UIButton!
    @IBOutlet weak var btnRound: UIButton!
    @IBOutlet weak var btnSquare: UIButton!
    @IBOutlet weak var btnRoundedEdges: UIButton!
    
    
    var selectedVisit = ClientVisit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        
        selectedVisit = self.client.clientVisits[selectedVisitIndex]
        loadOptions()
    }
    
    func emptyOptions() -> [String:String] {
        
        return
            ["scissor":"0",
             "clipper":"0",
             "texturize":"0",
             "skin":"0",
             "0":"0",
             "12":"0",
             "1":"0",
             "2":"0",
             "3":"0",
             "4":"0",
             "5":"0",
             "high":"0",
             "low":"0",
             "taper":"0",
             "natural":"0",
             "round":"0",
             "square":"0",
             "rounded edges":"0"]
    }
    
    func loadOptions() {
        
        if self.client.clientVisits[selectedVisitIndex].options.count == 0 {
            self.client.clientVisits[selectedVisitIndex].options = emptyOptions()
        }
        
        
        var btnText = btnScissor.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnScissor.backgroundColor = UIColor.darkGray
                btnScissor.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btnClipper.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnClipper.backgroundColor = UIColor.darkGray
                btnClipper.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btnTexturize.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnTexturize.backgroundColor = UIColor.darkGray
                btnTexturize.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btnSkin.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnSkin.backgroundColor = UIColor.darkGray
                btnSkin.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btn0.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn0.backgroundColor = UIColor.darkGray
                btn0.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btn12.titleLabel?.text?.lowercased().replacingOccurrences(of: "/", with: "")
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn12.backgroundColor = UIColor.darkGray
                btn12.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btn1.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn1.backgroundColor = UIColor.darkGray
                btn1.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btn2.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn2.backgroundColor = UIColor.darkGray
                btn2.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btn3.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn3.backgroundColor = UIColor.darkGray
                btn3.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btn4.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn4.backgroundColor = UIColor.darkGray
                btn4.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btn5.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn5.backgroundColor = UIColor.darkGray
                btn5.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btnHigh.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnHigh.backgroundColor = UIColor.darkGray
                btnHigh.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btnLow.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnLow.backgroundColor = UIColor.darkGray
                btnLow.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btnTaper.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnTaper.backgroundColor = UIColor.darkGray
                btnTaper.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btnNatural.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnNatural.backgroundColor = UIColor.darkGray
                btnNatural.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btnRound.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnRound.backgroundColor = UIColor.darkGray
                btnRound.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btnSquare.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnSquare.backgroundColor = UIColor.darkGray
                btnSquare.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
        btnText = btnRoundedEdges.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnRoundedEdges.backgroundColor = UIColor.darkGray
                btnRoundedEdges.setTitleColor(UIColor.green, for: .normal)
            }
        }
        
    }
    
    
    
    @IBAction func btnScissorClick(_ sender: UIButton) {
        
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            
            if state == "0" {
                
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btnScissor.backgroundColor = UIColor.darkGray
                btnScissor.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnScissor.backgroundColor = UIColor.groupTableViewBackground
                btnScissor.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }

        }
    }
    
    @IBAction func btnClipperClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btnClipper.backgroundColor = UIColor.darkGray
                btnClipper.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnClipper.backgroundColor = UIColor.groupTableViewBackground
                btnClipper.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }

        }
    }
    
    @IBAction func btnTexturizeClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btnTexturize.backgroundColor = UIColor.darkGray
                btnTexturize.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnTexturize.backgroundColor = UIColor.groupTableViewBackground
                btnTexturize.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btnSkinClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"//.setValue("1", forKey: btnText!)
                btnSkin.backgroundColor = UIColor.darkGray
                btnSkin.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnSkin.backgroundColor = UIColor.groupTableViewBackground
                btnSkin.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btn0Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btn0.backgroundColor = UIColor.darkGray
                btn0.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btn0.backgroundColor = UIColor.groupTableViewBackground
                btn0.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btn12Click(_ sender: UIButton) {
        
        
        let btnText = sender.titleLabel?.text?.lowercased().replacingOccurrences(of: "/", with: "")
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btn12.backgroundColor = UIColor.darkGray
                btn12.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btn12.backgroundColor = UIColor.groupTableViewBackground
                btn12.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btn1Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btn1.backgroundColor = UIColor.darkGray
                btn1.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btn1.backgroundColor = UIColor.groupTableViewBackground
                btn1.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btn2Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btn2.backgroundColor = UIColor.darkGray
                btn2.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btn2.backgroundColor = UIColor.groupTableViewBackground
                btn2.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btn3Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btn3.backgroundColor = UIColor.darkGray
                btn3.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btn3.backgroundColor = UIColor.groupTableViewBackground
                btn3.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btn4Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btn4.backgroundColor = UIColor.darkGray
                btn4.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btn4.backgroundColor = UIColor.groupTableViewBackground
                btn4.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btn5Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btn5.backgroundColor = UIColor.darkGray
                btn5.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btn5.backgroundColor = UIColor.groupTableViewBackground
                btn5.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btnHighClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btnHigh.backgroundColor = UIColor.darkGray
                btnHigh.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnHigh.backgroundColor = UIColor.groupTableViewBackground
                btnHigh.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btnLowClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btnLow.backgroundColor = UIColor.darkGray
                btnLow.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnLow.backgroundColor = UIColor.groupTableViewBackground
                btnLow.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btnTaperClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btnTaper.backgroundColor = UIColor.darkGray
                btnTaper.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnTaper.backgroundColor = UIColor.groupTableViewBackground
                btnTaper.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btnNaturalClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btnNatural.backgroundColor = UIColor.darkGray
                btnNatural.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnNatural.backgroundColor = UIColor.groupTableViewBackground
                btnNatural.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btnRoundClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btnRound.backgroundColor = UIColor.darkGray
                btnRound.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnRound.backgroundColor = UIColor.groupTableViewBackground
                btnRound.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btnSquareClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btnSquare.backgroundColor = UIColor.darkGray
                btnSquare.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnSquare.backgroundColor = UIColor.groupTableViewBackground
                btnSquare.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
    
    @IBAction func btnRoundedEdgesClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "0" {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
                btnRoundedEdges.backgroundColor = UIColor.darkGray
                btnRoundedEdges.setTitleColor(UIColor.green, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            }
            else {
                self.client.clientVisits[selectedVisitIndex].options[btnText!] = "0"
                btnRoundedEdges.backgroundColor = UIColor.groupTableViewBackground
                btnRoundedEdges.setTitleColor(UIColor.lightGray, for: .normal)
                
                self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("0")
            }
        }
    }
}
