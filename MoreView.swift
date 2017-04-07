//
//  MoreView.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/6/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MoreView: UIViewController {

    
    var selectedVisitIndex:Int!
    var userId:String!
    var client:Client!
    var ref: FIRDatabaseReference!
    
    var options =
            ["scissor":"0",
             "clipper":"0",
             "texturize":"0",
             "skin":"0",
             "0":"0",
             "1/2":"0",
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func btnDoneClick(_ sender: UIBarButtonItem) {
        
        
//        let selectedVisit = self.client.clientVisits[selectedVisitIndex]
//        
//        self.client.clientVisits[selectedVisitIndex].notes = notes
//        self.ref.child("users/" + userId + "/clients/" + self.client.clientId + "/visits/" + selectedVisit.visitDate + "/notes").setValue(notes)
//        
//        if let del = self.delegate {
//            del.historyChanged(client: self.client)
//        }
//        
//        
//        // close window
//        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnScissorClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnScissor.backgroundColor = UIColor.darkGray
                btnScissor.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnScissor.backgroundColor = UIColor.groupTableViewBackground
                btnScissor.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btnClipperClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnClipper.backgroundColor = UIColor.darkGray
                btnClipper.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnClipper.backgroundColor = UIColor.groupTableViewBackground
                btnClipper.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btnTexturizeClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnTexturize.backgroundColor = UIColor.darkGray
                btnTexturize.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnTexturize.backgroundColor = UIColor.groupTableViewBackground
                btnTexturize.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btnSkinClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnSkin.backgroundColor = UIColor.darkGray
                btnSkin.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnSkin.backgroundColor = UIColor.groupTableViewBackground
                btnSkin.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btn0Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btn0.backgroundColor = UIColor.darkGray
                btn0.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btn0.backgroundColor = UIColor.groupTableViewBackground
                btn0.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btn12Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btn12.backgroundColor = UIColor.darkGray
                btn12.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btn12.backgroundColor = UIColor.groupTableViewBackground
                btn12.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btn1Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btn1.backgroundColor = UIColor.darkGray
                btn1.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btn1.backgroundColor = UIColor.groupTableViewBackground
                btn1.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btn2Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btn2.backgroundColor = UIColor.darkGray
                btn2.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btn2.backgroundColor = UIColor.groupTableViewBackground
                btn2.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btn3Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btn3.backgroundColor = UIColor.darkGray
                btn3.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btn3.backgroundColor = UIColor.groupTableViewBackground
                btn3.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btn4Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btn4.backgroundColor = UIColor.darkGray
                btn4.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btn4.backgroundColor = UIColor.groupTableViewBackground
                btn4.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btn5Click(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btn5.backgroundColor = UIColor.darkGray
                btn5.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btn5.backgroundColor = UIColor.groupTableViewBackground
                btn5.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btnHighClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnHigh.backgroundColor = UIColor.darkGray
                btnHigh.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnHigh.backgroundColor = UIColor.groupTableViewBackground
                btnHigh.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btnLowClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnLow.backgroundColor = UIColor.darkGray
                btnLow.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnLow.backgroundColor = UIColor.groupTableViewBackground
                btnLow.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btnTaperClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnTaper.backgroundColor = UIColor.darkGray
                btnTaper.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnTaper.backgroundColor = UIColor.groupTableViewBackground
                btnTaper.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btnNaturalClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnNatural.backgroundColor = UIColor.darkGray
                btnNatural.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnNatural.backgroundColor = UIColor.groupTableViewBackground
                btnNatural.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btnRoundClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnRound.backgroundColor = UIColor.darkGray
                btnRound.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnRound.backgroundColor = UIColor.groupTableViewBackground
                btnRound.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btnSquareClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnSquare.backgroundColor = UIColor.darkGray
                btnSquare.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnSquare.backgroundColor = UIColor.groupTableViewBackground
                btnSquare.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    @IBAction func btnRoundedEdgesClick(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased()
        
        
        if let state = options[btnText!] {
            if state == "0" {
                options[btnText!] = "1"
                btnRoundedEdges.backgroundColor = UIColor.darkGray
                btnRoundedEdges.setTitleColor(UIColor.green, for: .normal)
            }
            else {
                options[btnText!] = "0"
                btnRoundedEdges.backgroundColor = UIColor.groupTableViewBackground
                btnRoundedEdges.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    

}
