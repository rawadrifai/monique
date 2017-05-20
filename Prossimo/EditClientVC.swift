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


extension EditClientVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }

        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 12 // Bool
    }
}

class EditClientVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var delegate: EditClientDelegate?
    
    var userId:String!
    var client:Client!
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var labelChangePicture: UILabel!
    
    var imageChanged = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()
        self.txfPhone.delegate = self
        
        makeProfilePicInteractive()
        setBorders()
        resizeProfilePic()
        
        fillData()
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        save()
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
    
    func setBorders() {
        
        self.imgView.layer.cornerRadius = 100
        self.imgView.clipsToBounds = true
        
        self.txfName.layer.cornerRadius = 20
        self.txfPhone.layer.cornerRadius = 20
        self.txfEmail.layer.cornerRadius = 20
        
        
        
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
    
    func makeProfilePicInteractive() {
        
        // make the profile picture interactive
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        self.imgView.isUserInteractionEnabled = true
        self.imgView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        displayProfileImageAlert()
    }
    
    func displayProfileImageAlert() {
        
        let image = UIImagePickerController()
        image.allowsEditing = true
        image.delegate = self
        
        
        
        let profileImageAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        profileImageAlert.addAction(UIAlertAction(title: "Take a New Photo", style: .default, handler: { (action: UIAlertAction!) in
            
            image.sourceType = UIImagePickerControllerSourceType.camera
            self.present(image, animated: true)
            
        }))
        
        profileImageAlert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction!) in
            
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(image, animated: true)
            
        }))
        
        
        
        profileImageAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(profileImageAlert, animated: true, completion: nil)
    }

    
    func fillData() {
        
        txfName.text = client.clientName
        txfPhone.text = client.clientPhone
        txfEmail.text = client.clientEmail
        
        if client.profileImg.imageUrl != "" {
            self.imgView.sd_setShowActivityIndicatorView(true)
            self.imgView.sd_setIndicatorStyle(.gray)
            self.imgView.sd_setImage(with: URL(string: client.profileImg.imageUrl))
            self.labelChangePicture.isHidden = true
        }
        else {
            self.imgView.image = UIImage(imageLiteralResourceName: "icon-camera-32")
            self.labelChangePicture.isHidden = false
        }
    }
    
    
    
    func alert(message output:String) {
        let alert = UIAlertController(title: "Invalid Input", message: output, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func save() {
        
        if (validateInput()) {
            
            self.client.clientName = txfName.text!
            self.client.clientPhone = txfPhone.text!
            self.client.clientEmail = txfEmail.text!
            
            // insert values
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/clientName").setValue(self.client.clientName)
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/clientEmail").setValue(self.client.clientEmail)
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/clientPhone").setValue(self.client.clientPhone)
            
            if let del = self.delegate {
                del.dataChanged(client: self.client)
            }
            
            if imageChanged && self.imgView.image?.sd_imageData() != nil {
                
                let compressedImageData = UIImageJPEGRepresentation(self.imgView.image!, 0)
                
                uploadImageToFirebase(data: compressedImageData!, path: "users/" + self.userId + "/clients/" + self.client.clientId + "/profile/", fileName: UUID().uuidString)
            }
            
        }
    }
    
    func validateInput() -> Bool {
        
        let clientName = txfName.text ?? ""
        let clientPhone = txfPhone.text ?? ""
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
        if (clientPhone.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            alert(message: "Invalid Phone")
            return false
        }
        
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func uploadImageToFirebase(data: Data, path: String, fileName: String) {
        
        // get storage service reference
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        storageRef.put(data, metadata: nil) { (metadata, err) in
            
            if err != nil {
                // print("received an error: " + (err?.localizedDescription)!)
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
                    del.imageChanged(client:self.client)
                }
            }
        }
    }
    
    
    
    // execute after picking the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            
            self.imgView.image = UIImage(data: image.sd_imageData()!,scale: 0)
            imageChanged = true
            self.labelChangePicture.isHidden = true
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeView(_ sender: UIBarButtonItem) {
        
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}

protocol EditClientDelegate {
    func dataChanged(client: Client)
    func dataDeleted()
    func imageChanged(client: Client)
}
