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
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgView.layer.cornerRadius = (self.imgView.image?.size.width)! / 5;
        self.imgView.clipsToBounds = true;
 
        
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
            
            self.img = UIImageJPEGRepresentation(image, 0.8) as Data!
            imgView.image = image
            
           // let tempImage = UIImage(data: self.img, scale: 200)
            
            
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    @IBAction func addClient(_ sender: UIButton) {
        

        
        let clientName = txfName.text
        let clientPhone = txfPhone.text
        let clientEmail = txfEmail.text
        
        // validate input
        if (clientName?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            clientEmail?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            clientPhone?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            
            alert(message: "Please fill out at least phone number")
            return
        }
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()

        // insert values
        self.ref.child(userId + "/clients/" + clientPhone! + "/clientName").setValue(clientName)
        self.ref.child(userId + "/clients/" + clientPhone! + "/clientEmail").setValue(clientEmail)
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
        
        // set meta data for file type
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        // put data
        storageRef.put(data, metadata: metaData) { (md, err) in
            
            if err != nil {
                print("received an error: \(err?.localizedDescription)")
                
            }
            else {
                print("upload complete! here's some meta data: \(md)")
                
            }
        }
        
    }
    
    func alert(message output:String) {
        let alert = UIAlertController(title: "Invalid Input", message: output, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

}
