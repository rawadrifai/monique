//
//  NewClientView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 2/21/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

extension NewClientVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 12 // Bool
    }
}

class NewClientVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var delegate: NewClientDelegate?
    
    var userId:String!
    var ref: FIRDatabaseReference!
    var client = Client()
    var subscription:String!
    var numberOfClients:Int!
    var trialClientsLimit:Int!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var labelChangePicture: UILabel!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    
    var imageChanged = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()
        
        getTrialClientsLimitFromFirebase()
        makeProfilePicInteractive()
        setBorders()
        resizeProfilePic()
        
        
        
    }
    
    func resizeProfilePic() {
        
        
        
        // if there's an image
        if (self.client.profileImg.imageUrl != "") {
            self.imgView.contentMode = .scaleAspectFill
        }
            // if there's no image (small camera icon, we want it to be center)
        else {
            self.imgView.contentMode = .center
        }
        
        self.imgView.layer.cornerRadius = 100
        self.imgView.clipsToBounds = true
    }
    
    func makeProfilePicInteractive() {
        
        // make the profile picture interactive
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func setBorders() {

        self.txfName.layer.cornerRadius = 20
        self.txfPhone.layer.cornerRadius = 20
        self.txfEmail.layer.cornerRadius = 20
    }
    
    func getTrialClientsLimitFromFirebase() {
        
        if self.subscription != "pro" {
            
            self.ref.child("triallimit").observeSingleEvent(of: .value, with: {
                
                if let val = $0.value as? Int {
                    
                    self.trialClientsLimit = val
                    
                    if self.numberOfClients >= val {
                        self.btnSave.isEnabled = false
                        self.alertAboutClients(title: "Upgrade Required", message: "Upgrade to Pro for UNLIMITED storage!")
                    }
                    else {
                        self.btnSave.isEnabled = true
                    }
                }
            })
        }
        
    }
    
    
    
    
    var tmpPhone=""
    
    @IBAction func txfPhoneEditingChanged(_ sender: Any) {
        
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
    
    
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let image = UIImagePickerController()
        image.allowsEditing = true
        image.delegate = self
        
        // set the source to photo library
        image.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(image, animated: true)
    }
    
    
    // if user clicks cancel without selecting an image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // execute after picking the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            imgView.image = image
            self.labelChangePicture.isHidden = true
            imageChanged = true
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func validateInput() -> Bool {
        
        let clientName = txfName.text ?? ""
        let clientPhone = txfPhone.text ?? ""
        let clientEmail = txfEmail.text ?? ""
        
        // validate input
        if (clientName.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            alert(title: "Invalid Input", message: "Invalid Name")
            return false
        }
        if (!isValidEmail(testStr: clientEmail)) {
            alert(title: "Invalid Input", message: "Invalid Email")
            return false
        }
        if (clientPhone.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            alert(title: "Invalid Input", message: "Invalid Phone")
            return false
        }
        
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func addClient(_ sender: UIBarButtonItem) {
        
        if (validateInput()) {
            
            
            self.client.clientId = UUID().uuidString
            
            self.client.clientName = txfName.text!
            self.client.clientPhone = txfPhone.text!
            self.client.clientEmail = txfEmail.text!
            
            // insert values
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/clientName").setValue(self.client.clientName)
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/clientEmail").setValue(self.client.clientEmail)
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/clientPhone").setValue(self.client.clientPhone)
            
            
            if imageChanged && self.imgView.image?.sd_imageData() != nil {
                
                let compressedImageData = UIImageJPEGRepresentation(self.imgView.image!, 0)
                
                uploadImageToFirebase(data: compressedImageData!, path: "users/" + self.userId + "/clients/" + self.client.clientId + "/profile/", fileName: UUID().uuidString)
            }
            
            // record clever tap event
            CleverTap.sharedInstance()?.recordEvent("Client added")
            
            
            if self.subscription != "pro" {
                let clientsLeft = self.trialClientsLimit - numberOfClients - 1
                self.alertAboutClients(title: "You have " + String(clientsLeft) + " free client(s)", message: "Upgrade to Pro for UNLIMITED storage! Keep your clients backed up everywhere you go.")
            }
                // if subsc is pro
            else {
                let _ = self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    func uploadImageToFirebase(data: Data, path: String, fileName: String) {
        
        // get storage service reference
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        storageRef.put(data, metadata: nil) { (metadata, err) in
            
            if err != nil {
                //print("received an error: " + (err?.localizedDescription)!)
            }
            else {
                guard metadata != nil else {
                    print("error occurred")
                    return
                }
                
                
                self.client.profileImg.imageName = fileName
                self.client.profileImg.imageUrl = (metadata?.downloadURL()?.absoluteString)!
                
                self.ref.child(path + "/imageName").setValue(self.client.profileImg.imageName)
                self.ref.child(path + "/imageUrl").setValue(self.client.profileImg.imageUrl)
                
                if let del = self.delegate {
                    del.dataChanged(client: self.client)
                }
            }
        }
    }
    
    func alertAboutClients(title:String, message output:String) {
        let alert = UIAlertController(title: title, message: output, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            
            let _ = self.navigationController?.popViewController(animated: true)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert(title:String, message output:String) {
        let alert = UIAlertController(title: title, message: output, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeView(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}

protocol NewClientDelegate {
    func dataChanged(client:Client)
}
