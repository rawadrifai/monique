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

    
    var img1: Data!
    var img2: Data!
    var img3: Data!

    var clientVisit:ClientVisit!
    
    var imgIndex:Int?
    var userId = String()
    var client:Client!
    var ref: FIRDatabaseReference!
    
    var delegate: PictureTimeDelegate?
    var storageHomePath:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageHomePath = self.userId + "/clients/" + client.clientId + "/"

        makePicsInteractive()
        loadVisit()
        
        
    }
    
    func loadVisit() {
        
        self.txvNotes.text = self.clientVisit?.notes
        loadImages()
    }
    
    func loadImages() {
        
        for clientVisit in (client.clientVisits) {
            
            
                for image in clientVisit.images {
                    
     //todo               loadImageFromFirebase(path: storageHomePath, fileName: "visits/" + self.clientVisit.visitDate + "/" + image, image: image)
                }
            
        }
    }
    
    func loadImageFromFirebase(path: String, fileName: String, image:String) {
        
        // get storage service reference
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        
        
        storageRef.data(withMaxSize: 5 * 1024 * 1024) { (data, err) in
            
            if data != nil {
                
                switch image {
                case "1":
                    self.img1 = data
                    self.imgView1.image = UIImage(data: data!)
                    break
                case "2":
                    self.img2 = data
                    self.imgView2.image = UIImage(data: data!)
                    break
                case "3":
                    self.img3 = data
                    self.imgView3.image = UIImage(data: data!)
                    break
                default:
                    break
                }
            }
            
        }
    }
    

    
    func makePicsInteractive() {
        
        // make the profile picture interactive
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(img1Tapped(tapGestureRecognizer1:)))
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(img2Tapped(tapGestureRecognizer2:)))
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(img3Tapped(tapGestureRecognizer3:)))
        
      
        imgView1.tag = 1
        imgView1.isUserInteractionEnabled = true
        imgView1.addGestureRecognizer(tapGestureRecognizer1)
        
        imgView2.tag = 2
        imgView2.isUserInteractionEnabled = true
        imgView2.addGestureRecognizer(tapGestureRecognizer2)
        
        imgView3.tag = 3
        imgView3.isUserInteractionEnabled = true
        imgView3.addGestureRecognizer(tapGestureRecognizer3)
     }
    
    var img1Tapped = false
    var img2Tapped = false
    var img3Tapped = false
    
    
       
    // execute after picking the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            switch imgIndex! {
            case 1:
                self.imgView1.image = image
                img1Tapped = true
                self.img1 = UIImageJPEGRepresentation(image, 0) as Data!
                break
                
            case 2:
                imgView2.image = image
                img2Tapped = true
                self.img2 = UIImageJPEGRepresentation(image, 0) as Data!
                break
                
            case 3:
                imgView3.image = image
                img3Tapped = true
                self.img3 = UIImageJPEGRepresentation(image, 0) as Data!
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
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let notes = txvNotes.text ?? ""
        self.clientVisit.notes = notes
        
        var imageNames = [String]()
        
        // put visit dates in array
        var visitDates = [String]()
        for visit in client.clientVisits {
            visitDates.append(visit.visitDate)
        }
        
        
        // modify the current client in memory
        if !visitDates.contains(self.clientVisit.visitDate) {
            self.client.clientVisits.append(ClientVisit(visitDate: self.clientVisit.visitDate, notes: notes))
        }
        
        // save notes
        self.ref = FIRDatabase.database().reference()
        self.ref.child(userId + "/clients/" + self.client.clientId + "/visits/" + self.clientVisit.visitDate + "/notes").setValue(notes)
        
        
        print("writing successful")
        
        
        if self.imgView1.image != nil {
            
            if img1Tapped {
            uploadImageToFirebase(data: UIImageJPEGRepresentation(imgView1.image!, 0) as Data!, path: userId + "/clients/" + self.client.clientId + "/visits/" + self.clientVisit.visitDate + "/", fileName: "1")
            }
            
            imageNames.append("1")
        } else {
            if img1Tapped {
            deleteImageFromFirebase(path: userId + "/clients/" + self.client.clientId + "/visits/" + self.clientVisit.visitDate + "/", fileName: "1")
            }
        }
        
        
        
        
        if self.imgView2.image != nil {
            
            if img2Tapped {
            uploadImageToFirebase(data: UIImageJPEGRepresentation(imgView2.image!, 0) as Data!, path: userId + "/clients/" + self.client.clientId + "/visits/" + self.clientVisit.visitDate + "/", fileName: "2")
            }
            
            imageNames.append("2")
        } else {
            if img2Tapped {
            deleteImageFromFirebase(path: userId + "/clients/" + self.client.clientId + "/visits/" + self.clientVisit.visitDate + "/", fileName: "2")
            }
        }
        
        
        
        if self.imgView3.image != nil {
            if img3Tapped {
            uploadImageToFirebase(data: UIImageJPEGRepresentation(imgView3.image!, 0) as Data!, path: userId + "/clients/" + self.client.clientId + "/visits/" + self.clientVisit.visitDate + "/", fileName: "3")
            }
            
            imageNames.append("3")
            
        } else {
            if img3Tapped {
            deleteImageFromFirebase(path: userId + "/clients/" + self.client.clientId + "/visits/" + self.clientVisit.visitDate + "/", fileName: "3")
            }
        }
        
        
        img1Tapped = false
        img2Tapped = false
        img3Tapped = false
        
        // save image array
        self.ref.child(userId + "/clients/" + self.client.clientId + "/visits/" + self.clientVisit.visitDate + "/images").setValue(imageNames)
        
        
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
    
    func deleteImageFromFirebase(path: String, fileName: String) {
        
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        
        storageRef.delete { (err) in
            
            if err != nil {
                print("received an error: \(err?.localizedDescription)")
            }
            else {
                print("image deleted")
            }
        }
    }
    
    
    @IBAction func closeView(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    
}

protocol PictureTimeDelegate {
    func historyChanged(client: Client)
}
