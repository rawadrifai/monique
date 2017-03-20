//
//  ClientDetailView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 2/22/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ClientDetailView: UITableViewController, EditClientDelegate, PictureTimeDelegate {

    var userId = String()
    var client:Client!
    var selectedVisitIndex:Int!
    var ref: FIRDatabaseReference!

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.client.clientVisits.sort { $0.visitDate > $1.visitDate }
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()
        
        self.imgView.layer.cornerRadius = 175 / 4;
        self.imgView.clipsToBounds = true;
        
        fillData()
    }
    

    @IBAction func newHaircut(_ sender: UIButton)
    {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        let visitdate = String(year) + "-" + String(month) + "-" + String(day)
            + " " + String(hour) + ":" + String(minute) + ":" + String(second)
        
        self.ref.child(userId + "/clients/" + self.client.clientId + "/visits/" + visitdate + "/notes").setValue("") { (err, ref) in
            
            self.client.clientVisits.append(ClientVisit(visitDate: visitdate, notes: ""))
            
            self.client.clientVisits.sort { $0.visitDate > $1.visitDate }
            self.tableView.reloadData()
        }
        
    }

    func fillData() {
        
        labelName.text = client.clientName
        labelPhone.text = client.clientId
        imgView.sd_setImage(with: URL(string: client.profileImg.imageUrl))
        
    }
    
    
    // must exist: returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.client.clientVisits.count
    }
    
    // must exist: customize each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        {
        
            cell.textLabel?.text = self.client.clientVisits[indexPath.row].visitDate
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath) {
            
            // set date to selected row
            self.selectedVisitIndex = indexPath.row
            self.performSegue(withIdentifier: "pictureTimeSegue", sender: self)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        // get an instance of the client to be deleted
        let visitToBeDeleted = self.client.clientVisits[indexPath.row] as ClientVisit
        
        let deleteAlert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            self.ref = FIRDatabase.database().reference()
            
            // delete from firebase database, with completion block
            
            self.ref.child(self.userId + "/clients/" + self.client.clientId + "/visits/" + visitToBeDeleted.visitDate).removeValue(completionBlock: { (err, ref) in
                
                self.client.clientVisits.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                // delete from firebase
                let storageRef = FIRStorage.storage().reference().child(self.userId + "/clients/" + self.client.clientId + "/visits/" + visitToBeDeleted.visitDate)
                
                
                storageRef.delete { (err) in
                    
                    if err != nil {
                        print("received an error: \(err?.localizedDescription)")
                    }
                }
            })
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(deleteAlert, animated: true, completion: nil)
        
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
        else if segue.identifier == "pictureTimeSegue" {
            
            // set the userId
            if let destination = segue.destination as? PictureTimeView {
                
                destination.userId = self.userId
                destination.client = self.client
                destination.selectedVisitIndex = self.selectedVisitIndex
                destination.delegate = self
            }
        }
        
    }
    



    
    // Child Delegate
    func dataChanged(client: Client) {
        
        self.client.clientId = client.clientId
        self.client.clientName = client.clientName
        self.client.clientEmail = client.clientEmail
        
        self.labelName.text = client.clientName
        self.labelPhone.text = client.clientId
        
    }
    
    func dataDeleted() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imageChanged(client: Client) {
        self.client.profileImg = client.profileImg
        imgView.sd_setImage(with: URL(string: client.profileImg.imageUrl))

    }
    
    func historyChanged(client: Client) {
        
        self.client.clientVisits = client.clientVisits
        self.client.clientVisits.sort { $0.visitDate > $1.visitDate }
        
        self.tableView.reloadData()
    }

}
