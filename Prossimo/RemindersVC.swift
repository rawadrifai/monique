//
//  RemindersVC.swift
//  Prossimo
//
//  Created by Rawad Rifai on 6/21/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RemindersVC: UIViewController {

    var ref: FIRDatabaseReference!
    var client:Client!
    var userId:String!

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var txfMessage: UITextView!
    @IBOutlet weak var btn1week: UIButton!
    @IBOutlet weak var btn2weeks: UIButton!
    @IBOutlet weak var btn3weeks: UIButton!
    @IBOutlet weak var btn4weeks: UIButton!
    @IBOutlet weak var btn5weeks: UIButton!
    @IBOutlet weak var btn6weeks: UIButton!
    @IBOutlet weak var txfdays: UITextField!

    
    
    func setBorders() {
        
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        
        btn1week.layer.cornerRadius = 5
        btn1week.clipsToBounds = true
        btn1week.layer.borderColor = self.view.tintColor.cgColor
        btn1week.layer.borderWidth = 1
        
        btn2weeks.layer.cornerRadius = 5
        btn2weeks.clipsToBounds = true
        btn2weeks.layer.borderColor = self.view.tintColor.cgColor
        btn2weeks.layer.borderWidth = 1
        
        btn3weeks.layer.cornerRadius = 5
        btn3weeks.clipsToBounds = true
        btn3weeks.layer.borderColor = self.view.tintColor.cgColor
        btn3weeks.layer.borderWidth = 1
        
        btn4weeks.layer.cornerRadius = 5
        btn4weeks.clipsToBounds = true
        btn4weeks.layer.borderColor = self.view.tintColor.cgColor
        btn4weeks.layer.borderWidth = 1
        
        btn5weeks.layer.cornerRadius = 5
        btn5weeks.clipsToBounds = true
        btn5weeks.layer.borderColor = self.view.tintColor.cgColor
        btn5weeks.layer.borderWidth = 1
        
        btn6weeks.layer.cornerRadius = 5
        btn6weeks.clipsToBounds = true
        btn6weeks.layer.borderColor = self.view.tintColor.cgColor
        btn6weeks.layer.borderWidth = 1
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.ref = FIRDatabase.database().reference()

        setBorders()

    }
    
    func getDefaultMessage() {
        
        self.ref.child("defaultreminder").observeSingleEvent(of: .value, with: {
            
            if let message = $0.value as? String {
                
                self.txfMessage.text = message
            }
        })
    }
    
    func getUserInfo() {
        
        self.ref.child("users").child(self.userId).child("name").observeSingleEvent(of: .value, with: {
            
            if let name = $0.value as? String {
                
                
                let message = self.txfMessage.text.replacingOccurrences(of: "STYLIST", with: name)
                
                self.txfMessage.text = message
            }
        })
        
        self.ref.child("users").child(self.userId).child("businessPhone").observeSingleEvent(of: .value, with: {
            
            if let phone = $0.value as? String {
                
                
                let message = self.txfMessage.text.replacingOccurrences(of: "PHONE", with: phone)
                
                self.txfMessage.text = message
            }
        })
    }

    
    
    @IBAction func btn1weekClick(_ sender: UIButton) {
        
        btn1week.layer.backgroundColor = self.view.tintColor.cgColor
        btn1week.setTitleColor(UIColor.white, for: .normal)
        
        btn2weeks.layer.backgroundColor = UIColor.white.cgColor
        btn3weeks.layer.backgroundColor = UIColor.white.cgColor
        btn4weeks.layer.backgroundColor = UIColor.white.cgColor
        btn5weeks.layer.backgroundColor = UIColor.white.cgColor
        btn6weeks.layer.backgroundColor = UIColor.white.cgColor
        
        btn2weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn3weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn4weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn5weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn6weeks.setTitleColor(self.view.tintColor, for: .normal)
        
        txfdays.text = ""
    }

    @IBAction func btn2weeksClick(_ sender: UIButton) {
        
        btn2weeks.layer.backgroundColor = self.view.tintColor.cgColor
        btn2weeks.setTitleColor(UIColor.white, for: .normal)
        
        btn1week.layer.backgroundColor = UIColor.white.cgColor
        btn3weeks.layer.backgroundColor = UIColor.white.cgColor
        btn4weeks.layer.backgroundColor = UIColor.white.cgColor
        btn5weeks.layer.backgroundColor = UIColor.white.cgColor
        btn6weeks.layer.backgroundColor = UIColor.white.cgColor
        
        btn1week.setTitleColor(self.view.tintColor, for: .normal)
        btn3weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn4weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn5weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn6weeks.setTitleColor(self.view.tintColor, for: .normal)
        
        txfdays.text = ""
    }
    
    @IBAction func btn3weeksClick(_ sender: UIButton) {
        
        btn3weeks.layer.backgroundColor = self.view.tintColor.cgColor
        btn3weeks.setTitleColor(UIColor.white, for: .normal)
        
        btn2weeks.layer.backgroundColor = UIColor.white.cgColor
        btn1week.layer.backgroundColor = UIColor.white.cgColor
        btn4weeks.layer.backgroundColor = UIColor.white.cgColor
        btn5weeks.layer.backgroundColor = UIColor.white.cgColor
        btn6weeks.layer.backgroundColor = UIColor.white.cgColor
        
        btn2weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn1week.setTitleColor(self.view.tintColor, for: .normal)
        btn4weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn5weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn6weeks.setTitleColor(self.view.tintColor, for: .normal)
        
        txfdays.text = ""
    }
    
    @IBAction func btn4weeksClick(_ sender: UIButton) {
        
        btn4weeks.layer.backgroundColor = self.view.tintColor.cgColor
        btn4weeks.setTitleColor(UIColor.white, for: .normal)
        
        btn2weeks.layer.backgroundColor = UIColor.white.cgColor
        btn3weeks.layer.backgroundColor = UIColor.white.cgColor
        btn1week.layer.backgroundColor = UIColor.white.cgColor
        btn5weeks.layer.backgroundColor = UIColor.white.cgColor
        btn6weeks.layer.backgroundColor = UIColor.white.cgColor
        
        btn2weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn3weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn1week.setTitleColor(self.view.tintColor, for: .normal)
        btn5weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn6weeks.setTitleColor(self.view.tintColor, for: .normal)
        
        txfdays.text = ""
    }
    
    @IBAction func btn5weeksClick(_ sender: UIButton) {
        
        btn5weeks.layer.backgroundColor = self.view.tintColor.cgColor
        btn5weeks.setTitleColor(UIColor.white, for: .normal)
        
        btn2weeks.layer.backgroundColor = UIColor.white.cgColor
        btn3weeks.layer.backgroundColor = UIColor.white.cgColor
        btn4weeks.layer.backgroundColor = UIColor.white.cgColor
        btn1week.layer.backgroundColor = UIColor.white.cgColor
        btn6weeks.layer.backgroundColor = UIColor.white.cgColor
        
        btn2weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn3weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn4weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn1week.setTitleColor(self.view.tintColor, for: .normal)
        btn6weeks.setTitleColor(self.view.tintColor, for: .normal)
        
        txfdays.text = ""
    }
    
    @IBAction func btn6weeksClicks(_ sender: UIButton) {
        
        btn6weeks.layer.backgroundColor = self.view.tintColor.cgColor
        btn6weeks.setTitleColor(UIColor.white, for: .normal)
        
        btn2weeks.layer.backgroundColor = UIColor.white.cgColor
        btn3weeks.layer.backgroundColor = UIColor.white.cgColor
        btn4weeks.layer.backgroundColor = UIColor.white.cgColor
        btn5weeks.layer.backgroundColor = UIColor.white.cgColor
        btn1week.layer.backgroundColor = UIColor.white.cgColor
        
        btn2weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn3weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn4weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn5weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn1week.setTitleColor(self.view.tintColor, for: .normal)
        
        txfdays.text = ""
    }
    
    
    @IBAction func txfDaysTextChanged(_ sender: UITextField) {
        
        btn1week.layer.backgroundColor = UIColor.white.cgColor
        btn2weeks.layer.backgroundColor = UIColor.white.cgColor
        btn3weeks.layer.backgroundColor = UIColor.white.cgColor
        btn4weeks.layer.backgroundColor = UIColor.white.cgColor
        btn5weeks.layer.backgroundColor = UIColor.white.cgColor
        btn6weeks.layer.backgroundColor = UIColor.white.cgColor
        
        btn1week.setTitleColor(self.view.tintColor, for: .normal)
        btn2weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn3weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn4weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn5weeks.setTitleColor(self.view.tintColor, for: .normal)
        btn6weeks.setTitleColor(self.view.tintColor, for: .normal)
    }
    
    
    @IBAction func setReminderClick(_ sender: UIButton) {
        
        
    }

}
