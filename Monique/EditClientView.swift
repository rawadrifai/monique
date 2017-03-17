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

class EditClientView: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var delegate: EditClientDelegate?
    
    var userId = String()
    var client:Client!
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgView.layer.cornerRadius = 175/4
        self.imgView.clipsToBounds = true;
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()
        
        fillData()
        
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

    
    func fillData() {
        
        txfName.text = client.clientName 
        txfPhone.text = client.clientId
        txfEmail.text = client.clientEmail
        imgView.sd_setImage(with: URL(string: client.profileImg.imageUrl))
        
    }
    
    
    
    func alert(message output:String) {
        let alert = UIAlertController(title: "Invalid Input", message: output, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
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
        
        
        
        if profileImageChanged && self.imgView.image?.sd_imageData() != nil {
            
            uploadImageToFirebase(data: (self.imgView.image?.sd_imageData())!, path: userId + "/clients/" + clientPhone! + "/profile/", fileName: UUID().uuidString)
        }
        
        if let del = self.delegate {
            del.dataChanged(client: self.client)
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
                
                self.client.profileImg.imageName = fileName
                self.client.profileImg.imageUrl = (metadata?.downloadURL()?.absoluteString)!
                
                self.ref.child(path + "/imageName").setValue(self.client.profileImg.imageName)
                self.ref.child(path + "imageUrl").setValue(self.client.profileImg.imageUrl)
                
                print(self.client.profileImg.imageUrl)
                
                if let del = self.delegate {
                    del.imageChanged(client:self.client)
                }
            }
        }
    }
    

    // when user click on select picture button
    @IBAction func selectPicture(_ sender: UIButton) {
        
        let image = UIImagePickerController()
        image.allowsEditing = false
        image.delegate = self
        
        // set the source to photo library
        image.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(image, animated: true)
        
    }
    
    var profileImageChanged = false
    
    // execute after picking the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            imgView.image = UIImage(data: image.sd_imageData()!,scale: 0)
            profileImageChanged = true
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeView(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteClient(_ sender: UIButton) {
        
        let deleteAlert = UIAlertController(title: "Confirm", message: "Positive?", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            self.ref = FIRDatabase.database().reference()
            self.ref.child(self.userId + "/clients/" + self.client.clientId).removeValue()
        
            print("delete successful")
            
            
            let storageRef = FIRStorage.storage().reference().child(self.userId).child("clients").child(self.client.clientId)
            
            storageRef.delete(completion: { (err) in
                print("received an error: \(err?.localizedDescription)")
            })
            
            if let del = self.delegate {
                del.dataDeleted()
            }
            
            let _ = self.navigationController?.popViewController(animated: true)
            
            
            
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(deleteAlert, animated: true, completion: nil)
        
        
      
    }
    
}

protocol EditClientDelegate {
    func dataChanged(client: Client)
    func dataDeleted()
    func imageChanged(client: Client)
}
