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

    

    var selectedVisitIndex:Int!
    var userId:String!
    var client:Client!
    var ref: FIRDatabaseReference!
    
    var delegate: PictureTimeDelegate?
    var storageHomePath:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageHomePath = self.userId + "/clients/" + client.clientId + "/"

        
        loadVisit()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.client.clientVisits[selectedVisitIndex].images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        {
           
            let imgobj = self.client.clientVisits[selectedVisitIndex].images[indexPath.row]
    
            let image = cell.viewWithTag(1) as! UIImageView
            image.sd_setImage(with: URL(string: imgobj.imageUrl))

            
    
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
        
    }
    
    
    
    
    
    
    func loadVisit() {
        
        self.txvNotes.text = self.client.clientVisits[selectedVisitIndex].notes
        
    }
    
    
    // if user clicks cancel without selecting an image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let notes = txvNotes.text ?? ""
        self.client.clientVisits[selectedVisitIndex].notes = notes
        
        saveImages()
        
        
        if let del = self.delegate {
            del.historyChanged(client: self.client)
        }
        
        // close window
        let _ = self.navigationController?.popViewController(animated: true)
        
        print("writing successful")

    }
    
    
    
    func saveImages() {
        
        // clean the image list
        self.client.clientVisits[selectedVisitIndex].images = [ImageObject]()
        
        for cell in tableView.visibleCells {
        
            let imgview = cell.viewWithTag(1) as! UIImageView
            let imgdata = imgview.image?.sd_imageData()
            let visitdate = self.client.clientVisits[selectedVisitIndex].visitDate
            let uuid = UUID().uuidString
            
            uploadImageToFirebase(data: imgdata!, path: userId + "/clients/" + self.client.clientId + "/visits/" + visitdate + "/", fileName: uuid)
            
        }
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
                
                let imgobj = ImageObject()
                imgobj.imageName = fileName
                imgobj.imageUrl = (metadata?.downloadURL()?.absoluteString)!
                
                self.client.clientVisits[self.selectedVisitIndex].images.append(imgobj)
                
                self.ref.child(path).setValue(imgobj.imageName)
                self.ref.child(path).setValue(imgobj.imageUrl)
                
                print(self.client.profileImg.imageUrl)
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
