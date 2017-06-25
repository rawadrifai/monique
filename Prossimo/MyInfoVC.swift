//
//  MyInfoVC.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/17/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

extension MyInfoVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 12 // Bool
    }
}


class MyInfoVC: UIViewController {

    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfBusinessPhone: UITextField!
    
    
    var ref: FIRDatabaseReference!
    var userId:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.txfPhone.delegate = self
        self.txfBusinessPhone.delegate = self
        setBorders()
        loadData()
    }
    
    func setBorders() {
        self.txfName.layer.cornerRadius = 7
        self.txfName.clipsToBounds = true
        self.txfName.layer.borderColor = UIColor.lightGray.cgColor
        self.txfName.layer.borderWidth=1
        
        self.txfPhone.layer.cornerRadius = 7
        self.txfPhone.clipsToBounds = true
        self.txfPhone.layer.borderColor = UIColor.lightGray.cgColor
        self.txfPhone.layer.borderWidth=1
        
        self.txfBusinessPhone.layer.cornerRadius = 7
        self.txfBusinessPhone.clipsToBounds = true
        self.txfBusinessPhone.layer.borderColor = UIColor.lightGray.cgColor
        self.txfBusinessPhone.layer.borderWidth=1
        
        self.txfEmail.layer.cornerRadius = 7
        self.txfEmail.clipsToBounds = true
        self.txfEmail.layer.borderColor = UIColor.lightGray.cgColor
        self.txfEmail.layer.borderWidth=1
        
        self.btnSave.layer.cornerRadius = 7
        self.btnSave.clipsToBounds = true
        self.btnSave.clipsToBounds = true
    }
    
    func loadData() {
        
        self.ref.child("users/" + self.userId + "/name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let name = snapshot.value as? String {
                self.txfName.text = name
            }
        })
        
        self.ref.child("users/" + self.userId + "/phone").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let phone = snapshot.value as? String {
                self.txfPhone.text = phone
            }
        })
        
        self.ref.child("users/" + self.userId + "/email").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let email = snapshot.value as? String {
                self.txfEmail.text = email
            }
        })
        
        self.ref.child("users/" + self.userId + "/businessphone").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let businessPhone = snapshot.value as? String {
                self.txfBusinessPhone.text = businessPhone
            }
        })
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        
        if validateInput() {
            
    
            let name = txfName.text
            let phone = txfPhone.text
            let email = txfEmail.text
            let businessPhone = txfBusinessPhone.text
            
            self.ref.child("users").child(self.userId).child("name").setValue(name) { (err, ref) in }
            self.ref.child("users").child(self.userId).child("phone").setValue(phone) { (err, ref) in }
            self.ref.child("users").child(self.userId).child("email").setValue(email) { (err, ref) in }
            self.ref.child("users").child(self.userId).child("businessphone").setValue(businessPhone) { (err, ref) in }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    var tmpPhone=""
    
    @IBAction func txfPhoneEditingChanged(_ sender: UITextField) {
        
        if let phone = txfPhone.text {
            
            if (phone.characters.count > tmpPhone.characters.count) {
                
                if (phone.characters.count) == 3 {
                    
                    txfPhone.text = phone + "-"
                } else
                    if (phone.characters.count) == 7 {
                        
                        txfPhone.text = phone + "-"
                }
            }
            tmpPhone = txfPhone.text!
        }
    }
    
    var tmpBusinessPhone=""

    @IBAction func txfBusinessPhoneEditingChanged(_ sender: UITextField) {
        
        if let businessPhone = txfBusinessPhone.text {
            
            if (businessPhone.characters.count > tmpBusinessPhone.characters.count) {
                
                if (businessPhone.characters.count) == 3 {
                    
                    txfBusinessPhone.text = businessPhone + "-"
                } else
                    if (businessPhone.characters.count) == 7 {
                        
                        txfBusinessPhone.text = businessPhone + "-"
                }
            }
            tmpBusinessPhone = txfBusinessPhone.text!
        }
    }
    
    
    func validateInput() -> Bool {
        
        let clientName = txfName.text ?? ""
        let clientEmail = txfEmail.text ?? ""
        
        // validate input
        if (clientName.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            alert(message: "Invalid Name")
            return false
        }
        if (!isValidEmail(testStr: clientEmail)) {
            alert(message: "Invalid Email")
            return false
        }

        
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func alert(message output:String) {
        let alert = UIAlertController(title: "Invalid Input", message: output, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
}
