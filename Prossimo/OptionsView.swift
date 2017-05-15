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
                btnScissor.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnClipper.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnClipper.backgroundColor = UIColor.darkGray
                btnClipper.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnTexturize.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnTexturize.backgroundColor = UIColor.darkGray
                btnTexturize.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnSkin.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnSkin.backgroundColor = UIColor.darkGray
                btnSkin.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btn0.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn0.backgroundColor = UIColor.darkGray
                btn0.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btn12.titleLabel?.text?.lowercased().replacingOccurrences(of: "/", with: "")
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn12.backgroundColor = UIColor.darkGray
                btn12.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btn1.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn1.backgroundColor = UIColor.darkGray
                btn1.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btn2.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn2.backgroundColor = UIColor.darkGray
                btn2.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btn3.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn3.backgroundColor = UIColor.darkGray
                btn3.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btn4.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn4.backgroundColor = UIColor.darkGray
                btn4.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btn5.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btn5.backgroundColor = UIColor.darkGray
                btn5.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnHigh.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnHigh.backgroundColor = UIColor.darkGray
                btnHigh.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnLow.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnLow.backgroundColor = UIColor.darkGray
                btnLow.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnTaper.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnTaper.backgroundColor = UIColor.darkGray
                btnTaper.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnNatural.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnNatural.backgroundColor = UIColor.darkGray
                btnNatural.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnRound.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnRound.backgroundColor = UIColor.darkGray
                btnRound.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnSquare.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnSquare.backgroundColor = UIColor.darkGray
                btnSquare.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
        btnText = btnRoundedEdges.titleLabel?.text?.lowercased()
        
        if let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] {
            if state == "1" {
                
                btnRoundedEdges.backgroundColor = UIColor.darkGray
                btnRoundedEdges.setTitleColor(Commons.myColor, for: .normal)
            }
        }
        
    }
    

    
    func saveOption(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased().replacingOccurrences(of: "/", with: "")
        
        
        guard let state = self.client.clientVisits[selectedVisitIndex].options[btnText!] else {
            
            self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
            sender.backgroundColor = UIColor.darkGray
            sender.setTitleColor(Commons.myColor, for: .normal)
            
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.selectedVisit.visitDate + "/options/" + btnText!).setValue("1")
            
            return
        }
        if state == "0" {
            self.client.clientVisits[selectedVisitIndex].options[btnText!] = "1"
            sender.backgroundColor = UIColor.darkGray
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

    
    @IBAction func btnScissorClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnClipperClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnTexturizeClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnSkinClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btn0Click(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btn12Click(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btn1Click(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btn2Click(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btn3Click(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btn4Click(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btn5Click(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnHighClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnLowClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnTaperClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnNaturalClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnRoundClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnSquareClick(_ sender: UIButton) {
        saveOption(sender)
    }
    
    @IBAction func btnRoundedEdgesClick(_ sender: UIButton) {
        saveOption(sender)    }
}
