//
//  ClientDetailView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 2/22/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseStorage

class ClientDetailView: UITableViewController, EditClientDelegate {

    var userId = String()
    var client:Client!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgView.layer.cornerRadius = (self.imgView.image?.size.width)! / 5;
        self.imgView.clipsToBounds = true;
        
    }
    


    func fillData() {
        
        labelName.text = client.clientName
        labelPhone.text = client.clientId
        labelEmail.text = client.clientEmail
        
        loadImageFromFirebase(path: self.userId + "/clients/" + client.clientId + "/", fileName: "profile")
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editClientSegue" {
            
            // set the userId
            if let destination = segue.destination as? EditClientView {
                
                destination.userId = self.userId
                destination.client = self.client
                destination.delegate = self
            }
        }
        
    }
    
    
    
   
    func loadImageFromFirebase(path: String, fileName: String) {
        
        // get storage service reference
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        
        
        storageRef.data(withMaxSize: 5 * 1024 * 1024) { (data, err) in
       
            if data != nil {
                self.imgView.image = UIImage(data:data!,scale:1.0)
            }
            
            self.client.profileImg = self.imgView.image
        }
    }
    
    // Child Delegate
    func dataChanged(client: Client) {
        
        self.client = client
    }
    
    func dataDeleted() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imageChanged(client: Client) {
        self.imgView.image = client.profileImg
    }

}
