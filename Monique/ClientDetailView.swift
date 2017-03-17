//
//  ClientDetailView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 2/22/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseStorage

class ClientDetailView: UITableViewController, EditClientDelegate, PictureTimeDelegate {

    var userId = String()
    var client:Client!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    
    var storageHomePath:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set the user home path in firebase storage
        storageHomePath = self.userId + "/clients/" + client.clientId + "/"
        
        self.imgView.layer.cornerRadius = 175 / 4;
        self.imgView.clipsToBounds = true;
        
        fillData()
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
    
    var clientVisit:ClientVisit?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath) {
            
            // set date to selected row
            self.clientVisit = client.clientVisits[indexPath.row]
    
            self.performSegue(withIdentifier: "pictureTimeSegue", sender: self)
            
        }
        
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
                destination.clientVisit = self.clientVisit
                destination.delegate = self
            }
        }
        
    }
    

   
    
    
    
    
    @IBAction func moveToPictureTimeView(_ sender: UIButton) {
        
        // set visit date to today
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        self.clientVisit?.visitDate = String(year) + "-" + String(month) + "-" + String(day)
            + " " + String(hour) + ":" + String(minute) + ":" + String(second)
        
        self.performSegue(withIdentifier: "pictureTimeSegue", sender: self)
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
        self.tableView.reloadData()
    }

}
