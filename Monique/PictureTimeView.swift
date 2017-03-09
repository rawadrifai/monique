//
//  PictureTimeView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 3/8/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class PictureTimeView: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var txvNotes: UITextView!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var imgView4: UIImageView!
    @IBOutlet weak var imgView5: UIImageView!
    @IBOutlet weak var imgView6: UIImageView!
    
    var img1: Data!
    var img2: Data!
    var img3: Data!
    var img4: Data!
    var img5: Data!
    var img6: Data!
    
    var imgIndex:Int?
    var userId = String()
    var client:Client!
    var ref: FIRDatabaseReference!
    
    var delegate: PictureTimeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makePicsInteractive()
    }

    
    func makePicsInteractive() {
        
        // make the profile picture interactive
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(img1Tapped(tapGestureRecognizer1:)))
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(img2Tapped(tapGestureRecognizer2:)))
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(img3Tapped(tapGestureRecognizer3:)))
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(img4Tapped(tapGestureRecognizer4:)))
        
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(img5Tapped(tapGestureRecognizer5:)))
        
        let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(img6Tapped(tapGestureRecognizer6:)))
        
        imgView1.tag = 1
        imgView1.isUserInteractionEnabled = true
        imgView1.addGestureRecognizer(tapGestureRecognizer1)
        
        imgView2.tag = 2
        imgView2.isUserInteractionEnabled = true
        imgView2.addGestureRecognizer(tapGestureRecognizer2)
        
        imgView3.tag = 3
        imgView3.isUserInteractionEnabled = true
        imgView3.addGestureRecognizer(tapGestureRecognizer3)
        
        imgView4.tag = 4
        imgView4.isUserInteractionEnabled = true
        imgView4.addGestureRecognizer(tapGestureRecognizer4)
        
        imgView5.tag = 5
        imgView5.isUserInteractionEnabled = true
        imgView5.addGestureRecognizer(tapGestureRecognizer5)
        
        imgView6.tag = 6
        imgView6.isUserInteractionEnabled = true
        imgView6.addGestureRecognizer(tapGestureRecognizer6)
        
    }
    
    
    func img1Tapped(tapGestureRecognizer1: UITapGestureRecognizer)
    {
        
        self.imgIndex = imgView1.tag
        
        let image = UIImagePickerController()
        image.allowsEditing = false
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(image, animated: true)
    }
    
    func img2Tapped(tapGestureRecognizer2: UITapGestureRecognizer)
    {
        
        self.imgIndex = imgView2.tag
        
        let image = UIImagePickerController()
        image.allowsEditing = false
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(image, animated: true)
    }
    
    func img3Tapped(tapGestureRecognizer3: UITapGestureRecognizer)
    {
        
        self.imgIndex = imgView3.tag
        
        let image = UIImagePickerController()
        image.allowsEditing = false
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(image, animated: true)
    }
    
    func img4Tapped(tapGestureRecognizer4: UITapGestureRecognizer)
    {
        
        self.imgIndex = imgView4.tag
        
        let image = UIImagePickerController()
        image.allowsEditing = false
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(image, animated: true)
    }
    
    func img5Tapped(tapGestureRecognizer5: UITapGestureRecognizer)
    {
        
        self.imgIndex = imgView5.tag
        
        let image = UIImagePickerController()
        image.allowsEditing = false
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(image, animated: true)
    }
    
    func img6Tapped(tapGestureRecognizer6: UITapGestureRecognizer)
    {
        
        self.imgIndex = imgView6.tag
        
        let image = UIImagePickerController()
        image.allowsEditing = false
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(image, animated: true)
    }
    

    // execute after picking the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            switch imgIndex! {
            case 1:
                self.imgView1.image = image
                self.img1 = UIImageJPEGRepresentation(image, 0.8) as Data!
                break
                
            case 2:
                imgView2.image = image
                self.img2 = UIImageJPEGRepresentation(image, 0.8) as Data!
                break
                
            case 3:
                imgView3.image = image
                self.img3 = UIImageJPEGRepresentation(image, 0.8) as Data!
                break
                
            case 4:
                imgView4.image = image
                self.img4 = UIImageJPEGRepresentation(image, 0.8) as Data!
                break
                
            case 5:
                imgView5.image = image
                self.img5 = UIImageJPEGRepresentation(image, 0.8) as Data!
                break
                
            case 6:
                imgView6.image = image
                self.img6 = UIImageJPEGRepresentation(image, 0.8) as Data!
                break
                
            default: break
                
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    
    // if user clicks cancel without selecting an image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let dateString = String(year) + "-" + String(month) + "-" + String(day)
        
        let notes = txvNotes.text ?? ""
        self.client.clientVisit = ClientVisit(visitDate: dateString, notes: notes)
        

        
        
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()
        
        // insert values
        self.ref.child(userId + "/clients/" + self.client.clientId + "/visits/" + self.client.clientVisit.visitDate).setValue(self.client.clientVisit.notes)
        
        
        print("writing successful")
        
        if self.img1 != nil {
            uploadImageToFirebase(data: self.img1, path: userId + "/clients/" + self.client.clientId + "/history/" + self.client.clientVisit.visitDate + "/", fileName: "1")
        }
        
        if self.img2 != nil {
            uploadImageToFirebase(data: self.img2, path: userId + "/clients/" + self.client.clientId + "/history/" + self.client.clientVisit.visitDate + "/", fileName: "2")
        }
        
        if self.img3 != nil {
            uploadImageToFirebase(data: self.img3, path: userId + "/clients/" + self.client.clientId + "/history/" + self.client.clientVisit.visitDate + "/", fileName: "3")
        }
        
        if self.img4 != nil {
            uploadImageToFirebase(data: self.img4, path: userId + "/clients/" + self.client.clientId + "/history/" + self.client.clientVisit.visitDate + "/", fileName: "4")
        }
        
        if self.img5 != nil {
            uploadImageToFirebase(data: self.img5, path: userId + "/clients/" + self.client.clientId + "/history/" + self.client.clientVisit.visitDate + "/", fileName: "5")
        }
        
        if self.img6 != nil {
            uploadImageToFirebase(data: self.img6, path: userId + "/clients/" + self.client.clientId + "/history/" + self.client.clientVisit.visitDate + "/", fileName: "6")
        }
        
        
        
        if let del = self.delegate {
            del.historyChanged(client: self.client)
        }
        
        // close window
        let _ = self.navigationController?.popViewController(animated: true)
        
        print("writing successful")

        
    }
    
    
    
    func uploadImageToFirebase(data: Data, path: String, fileName: String) {
        
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        storageRef.put(data, metadata: metaData) { (md, err) in
            
            if err != nil {
                print("received an error: \(err?.localizedDescription)")
            }
            else {
                print("upload complete! here's some meta data: \(md)")
            }
        }
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    
}

protocol PictureTimeDelegate {
    func historyChanged(client: Client)
}
