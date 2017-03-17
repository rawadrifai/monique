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

class NewClientView: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    

    var userId = String()
    var ref: FIRDatabaseReference!
    var img: Data!
    var client = Client()
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        self.imgView.layer.cornerRadius = 175 / 4;
        self.imgView.clipsToBounds = true;
 
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()
        
        makeProfilePicInteractive()
    }
    
    func makeProfilePicInteractive() {
        
        // make the profile picture interactive
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let image = UIImagePickerController()
        image.allowsEditing = false
        image.delegate = self
        
        // set the source to photo library
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        
        self.present(image, animated: true)
    }
    

    // if user clicks cancel without selecting an image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // when user click on select picture button
    @IBAction func selectPicture(_ sender: UIButton) {
        
        let image = UIImagePickerController()
        image.allowsEditing = false
        image.delegate = self
        
        // set the source to photo library
        image.sourceType = UIImagePickerControllerSourceType.camera//.photoLibrary
    
        
        self.present(image, animated: true)
            
        
        
    }
    
    // execute after picking the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            self.img = UIImageJPEGRepresentation(image, 0) as Data!
            imgView.image = image
            
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func addClient(_ sender: UIBarButtonItem) {
        

        
        let clientName = txfName.text
        let clientPhone = txfPhone.text
        let clientEmail = txfEmail.text
        
        // validate input
        if (clientPhone?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            
            alert(message: "Please fill out at least phone number")
            return
        }
        
        self.client.clientName = clientName!
        self.client.clientId = clientPhone!
        self.client.clientEmail = clientEmail!
        
        

        // insert values
        self.ref.child(userId + "/clients/" + self.client.clientId + "/clientName").setValue(self.client.clientName)
        self.ref.child(userId + "/clients/" + self.client.clientId + "/clientEmail").setValue(self.client.clientEmail)
        print("writing successful")
        
        
        
        if self.img != nil {
            uploadImageToFirebase(data: self.img, path: userId + "/clients/" + clientPhone! + "/", fileName: "profile")
        }
        // close window
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    func uploadImageToFirebase(data: Data, path: String, fileName: String) {

        // get storage service reference
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        storageRef.put(data, metadata: nil) { (metadata, err) in
            
            if err != nil {
                print("received an error: \(err?.localizedDescription)")
            }
            else {
                guard metadata != nil else {
                    print("error occurred")
                    return
                }
                
                let uuid = UUID().uuidString
                self.client.profileImg.imageName = uuid
                self.client.profileImg.imageUrl = (metadata?.downloadURL()?.absoluteString)!
                
                self.ref.child(self.userId + "/clients/" + self.client.clientId + "/profile/imageName").setValue(self.client.profileImg.imageName)
                self.ref.child(self.userId + "/clients/" + self.client.clientId + "/profile/imageUrl").setValue(self.client.profileImg.imageUrl)
  
                print(self.client.profileImg.imageUrl)
            }
        }
    }
    
    func alert(message output:String) {
        let alert = UIAlertController(title: "Invalid Input", message: output, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeView(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }


}
