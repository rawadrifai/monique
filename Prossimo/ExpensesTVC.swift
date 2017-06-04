//
//  ContactsView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 2/19/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Fabric
import Crashlytics
import FontAwesomeKit

class ExpensesTVC: UITableViewController {
    
    var ref: FIRDatabaseReference!
    var userId:String!
    var expenses:[ClientExpense]

    @IBOutlet weak var btnImport: UIBarButtonItem!
    @IBOutlet weak var labelClientCount: UILabel!
    
    
    // every time the page shows (including when going back to it from the nav)
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // get all the user related data
        getUserData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getExpenses()

    }
    


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // check what's the tableview passed
        if tableView == self.tableView {
            return cellData.count
        }
        else {
            return filteredData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = Bundle.main.loadNibNamed("ClientCell", owner: self, options: nil)?.first as? ClientCell
            
        {
            let c = Client()
            
            // check what's the tableview passed
            if tableView == self.tableView {
                c.clientName = cellData[indexPath.row].clientName
                c.profileImg = cellData[indexPath.row].profileImg
                
                
            }
            else {
                c.clientName = filteredData[indexPath.row].clientName
                c.profileImg = filteredData[indexPath.row].profileImg
            }
            
            cell.labelClientName.text = c.clientName
            
            if c.profileImg.imageUrl != "" {
                cell.imageViewClient.sd_setImage(with: URL(string: c.profileImg.imageUrl))
            }
            else {
                cell.imageViewClient.image = UIImage(imageLiteralResourceName: "user")
                //cell.imageViewClient.layer.borderWidth = 1
            }
            
            // make image round
            cell.imageViewClient.layer.cornerRadius = 28
            cell.imageViewClient.clipsToBounds = true
            
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _ = tableView.cellForRow(at: indexPath) {
            
            self.performSegue(withIdentifier: "clientDetailsSegue", sender: self)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        // get an instance of the expense to be deleted
        let expenseToBeDeleted = self.expenses[indexPath.row] as ClientExpense
        
        let deleteAlert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            self.ref = FIRDatabase.database().reference()
            
            // delete from firebase database, with completion block
            
            self.ref.child("users/" + self.userId + "/expenses/" + expenseToBeDeleted).removeValue(completionBlock: { (err, ref) in
                
                self.cellData.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                // delete from firebase
                let storageRef = FIRStorage.storage().reference().child(self.userId).child("clients").child(clientToBeDeleted.clientId)
                
                storageRef.delete { (err) in
                    
                    if err != nil {
                        //print("received an error: " + (err?.localizedDescription)!)
                    }
                }
            })
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(deleteAlert, animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
    
    func reloadTableDataFromUIThread() {
        
        // update table view from the UI thread
        DispatchQueue.global(qos: .userInitiated).async {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    func getExpenses() {
        
        self.expenses = [ClientExpense]()
        
        ref = FIRDatabase.database().reference()
        self.ref.child("users/" + self.userId + "/expenses").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            // Expenses
            if let expenses = snapshot.value as? NSDictionary {
                
                // loop through visits
                for expense in (expenses.allValues) {
                    
                    let expenseInfo = expense as! NSDictionary
                    
                    let clientExpense = ClientExpense()
                    
                    clientExpense.item = expenseInfo.value(forKey: "item") as? String ?? ""
                    clientExpense.price = expenseInfo.value(forKey: "price") as? Double ?? 0
                    clientExpense.date = expenseInfo.value(forKey: "date") as? String ?? ""
                    
                    
                    // get the images for each receipt
                    if let receipts = (expenseInfo.value(forKey: "receipts") as? NSDictionary) {
                        
                        for receipt in receipts.allValues {
                            
                            if let receiptInfo = receipt as? NSDictionary {
                                
                                let r = Receipt()
                                r.imageUrl = receiptInfo.value(forKey: "imageUrl") as! String
                                r.uploadDate = receiptInfo.value(forKey: "uploadDate") as! String
                                
                                
                                clientExpense.receipts.append(r)
                            }
                        }
                        clientExpense.receipts.sort { $0.uploadDate > $1.uploadDate }
                    }
                    client.clientExpenses.append(clientExpense)
                }
                client.clientExpenses.sort { $0.sortingDate > $1.sortingDate }
            }
            
            
            
            self.expenses.sort { $0.clientName < $1.clientName }
                self.reloadTableDataFromUIThread()
            
            
            
            }
            self.setAggregates()
        
        }) { (error) in
            //print(error.localizedDescription)
        }
        
    }
    
    func setAggregates() {
        
        var aggregateString = ""
        
        aggregateString = String(self.cellData.count) + " CLIENTS - "
        
        
        // calculate total revenue
        var revenue:Double = 0
        
        for c in cellData {
            for v in c.clientVisits {
                revenue = revenue + v.price
            }
        }
        
        aggregateString = aggregateString + "$" + String(revenue)
            + " TOTAL REVENUE"
        self.labelClientCount.text = aggregateString
    }
    
    @IBAction func importClick(_ sender: UIBarButtonItem) {
        
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == .notDetermined {
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: entityType, completionHandler: { (success, nil) in
                if (success) {
                    self.openContacts()
                }
                
            })
        }
        else if authStatus == .authorized {
            self.openContacts()
        }
    }
    
}



