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
    
    @IBOutlet weak var labelNotes: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.labelNotes.layer.cornerRadius = 98 / 10;
        self.labelNotes.clipsToBounds = true;
        
        self.ref = FIRDatabase.database().reference()

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
            image.sd_setImage(with: URL(string: imgobj.imageUrl), completed: { (img, err, ct, url) in
                
            }) //.sd_setImage(with: URL(string: imgobj.imageUrl))
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        // get an instance of the image to be deleted
        let imageToBeDeleted = self.client.clientVisits[selectedVisitIndex].images[indexPath.row] as ImageObject
        
       
            self.ref = FIRDatabase.database().reference()
            
            // delete from firebase database, with completion block
        
            self.ref.child(self.userId + "/clients/" + self.client.clientId + "/visits/" + self.client.clientVisits[selectedVisitIndex].visitDate + "/images/" + imageToBeDeleted.imageName).removeValue { (err, ref) in
                
                self.client.clientVisits[self.selectedVisitIndex].images.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                // delete from firebase
                let storageRef = FIRStorage.storage().reference().child(self.userId + "/clients/" + self.client.clientId + "/visits/" + self.client.clientVisits[self.selectedVisitIndex].visitDate + "/images/" + imageToBeDeleted.imageName)
                
                
                storageRef.delete { (err) in
                    
                    if err != nil {
                        print("received an error: \(err?.localizedDescription)")
                    }
                }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "imageViewSegue" {
            
            if let destination = segue.destination as? ImageView {
            
                destination.image = self.client.clientVisits[selectedVisitIndex].images[tappedImageIndex] as ImageObject
                //destination.image = self.cli
            }
        }
    }
    
    var tappedImageIndex:Int!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _ = tableView.cellForRow(at: indexPath) {
            
            self.tappedImageIndex = indexPath.row
            self.performSegue(withIdentifier: "imageViewSegue", sender: self)
            
        }
    }
    
    
    
    func loadVisit() {
        
        self.txvNotes.text = self.client.clientVisits[selectedVisitIndex].notes
        
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let notes = txvNotes.text ?? ""
        
        let selectedVisit = self.client.clientVisits[selectedVisitIndex]
        
        self.client.clientVisits[selectedVisitIndex].notes = notes
        self.ref.child(userId + "/clients/" + self.client.clientId + "/visits/" + selectedVisit.visitDate + "/notes").setValue(notes)
            
            if let del = self.delegate {
                del.historyChanged(client: self.client)
            }
        
        
        // close window
        let _ = self.navigationController?.popViewController(animated: true)
                
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        
        let image = UIImagePickerController()
        image.allowsEditing = true
        image.delegate = self
        
        // set the source to photo library
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
        self.present(image, animated: true)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        

        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            // get the visit date
            let visitdate = self.client.clientVisits[selectedVisitIndex].visitDate
            
            // compress the image
            let compressedImageData = UIImageJPEGRepresentation(image, 0)
            
            uploadImageToFirebase(data: compressedImageData!, path: userId + "/clients/" + self.client.clientId + "/visits/" + visitdate + "/images/", fileName: UUID().uuidString)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
                imgobj.uploadDate = String(Date().timeIntervalSince1970)
                
                self.client.clientVisits[self.selectedVisitIndex].images.append(imgobj)
                
                
                self.ref.child(path + imgobj.imageName + "/imageUrl").setValue(imgobj.imageUrl)
                self.ref.child(path + imgobj.imageName + "/uploadDate").setValue(imgobj.uploadDate)
                    
                self.client.clientVisits[self.selectedVisitIndex].images.sort { $0.uploadDate > $1.uploadDate }
                self.tableView.reloadData()
                
                if let del = self.delegate {
                    del.historyChanged(client: self.client)
                }
                

            }
        }
    }
    
    
    func deleteImageFromFirebase(path: String, fileName: String) {
        
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        
        storageRef.delete { (err) in
            
            if err != nil {
                print("received an error: \(err?.localizedDescription)")
            }
            
        }
    }
}

protocol PictureTimeDelegate {
    func historyChanged(client: Client)
}

