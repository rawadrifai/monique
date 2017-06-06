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
    var expenses = [Expense]()

    @IBOutlet weak var labelTotalExpenses: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getExpenses()
    }

    
    @IBAction func plusClicked(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "expenseDetailsSegue", sender: self)
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return expenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = Bundle.main.loadNibNamed("ExpenseCell", owner: self, options: nil)?.first as? ExpenseCell
            
        {
            let expense = Expense()
            
            
            expense.item = expenses[indexPath.row].item
            expense.price = expenses[indexPath.row].price
            expense.date = expenses[indexPath.row].date
            
            
            if expense.item == "" {
                cell.labelItem.text = "No Item"
            } else {
                cell.labelItem.text = expense.item
            }
            
            
            cell.labelPrice.text = "$" + String(format: "%.2f", expense.price)
            cell.labelDate.text = expense.date
            
            
            var icon = UIImage()
            icon = FAKFontAwesome.calendarIcon(withSize: 16).image(with: CGSize(width: 20, height: 20))
            icon = icon.imageWithColor(color: UIColor.lightGray)!
            cell.imageViewDate.image = icon
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _ = tableView.cellForRow(at: indexPath) {
            
            self.performSegue(withIdentifier: "expenseDetailsSegue", sender: self)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        // get an instance of the expense to be deleted
        let expenseToBeDeleted = self.expenses[indexPath.row] as Expense
        
        let deleteAlert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            self.ref = FIRDatabase.database().reference()
            
            // delete from firebase database, with completion block
            
            self.ref.child("users/" + self.userId + "/expenses/" + expenseToBeDeleted.id).removeValue(completionBlock: { (err, ref) in
                
                self.expenses.remove(at: indexPath.row)
                self.reloadTableDataFromUIThread()
                
                // delete from firebase
                let storageRef = FIRStorage.storage().reference().child(self.userId).child("expenses").child(expenseToBeDeleted.id)
                
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
        
        if segue.identifier == "expenseDetailsSegue" {
            
            if let destination = segue.destination as? ExpenseDetailsTVC {
                
                // if the plus sign is clicked
                if self.tableView.indexPathForSelectedRow == nil {
                    
                    // create a generic expense object with id and todays dates
                    let expense = Expense()
                    expense.id = UUID().uuidString
                    expense.date = Commons.getTodaysShortDate()
                    expense.sortingDate = Commons.getTodaysSortingDate()
                    
                    destination.expense = expense
                    destination.userId = self.userId
                    
                } else { // if a row is selected
                    
                    // get selected row
                    let selectedRow:Int = (self.tableView.indexPathForSelectedRow?.row)!
                    
                    // sometimes it crashes because index out of bounds, so this is to prevent that
                    guard selectedRow < expenses.count && selectedRow >= 0 else {
                        return
                    }
                    
                    destination.expense = expenses[selectedRow]
                    destination.userId = self.userId
                }
                
            }
        }

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
        
        self.expenses = [Expense]()
        
        ref = FIRDatabase.database().reference()
        self.ref.child("users/" + self.userId + "/expenses").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            // Expenses
            if let expenses = snapshot.value as? NSDictionary {
                
                // loop through visit keys (which are the expense ids)
                
                for e in (expenses.allKeys) {

                    let expense = Expense()
                    expense.id = e as! String
                    
                    // get rest of the client info
                    let expenseInfo = (expenses.value(forKey: expense.id) as? NSDictionary)!
                    
                    expense.item = expenseInfo.value(forKey: "item") as? String ?? ""
                    expense.price = expenseInfo.value(forKey: "price") as? Double ?? 0
                    expense.date = expenseInfo.value(forKey: "date") as? String ?? ""

                    expense.sortingDate = expenseInfo.value(forKey: "sortingDate") as? String ?? ""

                    
                    // get the images for each receipt
                    if let receipts = (expenseInfo.value(forKey: "receipts") as? NSDictionary) {
                        
                        for receipt in receipts.allValues {
                            
                            if let receiptInfo = receipt as? NSDictionary {
                                
                                let r = Receipt()
                                r.imageUrl = receiptInfo.value(forKey: "imageUrl") as! String
                                r.uploadDate = receiptInfo.value(forKey: "uploadDate") as! String
                                
                                
                                expense.receipts.append(r)
                            }
                        }
                        expense.receipts.sort { $0.uploadDate > $1.uploadDate }
                    }
                    self.expenses.append(expense)
                }
                self.expenses.sort { $0.sortingDate > $1.sortingDate }
                self.reloadTableDataFromUIThread()
            }
            
            self.setAggregates()
        
        }) { (error) in
            //print(error.localizedDescription)
        }
        
    }
    
    func setAggregates() {
        
        // calculate total expenses
        var totalExpenses:Double = 0
        
        for e in self.expenses {
            
            totalExpenses = totalExpenses + e.price
        }
        
        // hide label if total is 0
        if totalExpenses == 0 {
            self.labelTotalExpenses.isHidden = true
            return
        }
        let aggregateString = "$" + String(totalExpenses)
            + " TOTAL"
        self.labelTotalExpenses.text = aggregateString
        
        
    }

    
}

extension ExpensesTVC: ExpenseDetailsDelegate {
    
    func expenseChanged() {
        
//        self.getExpenses()
//        self.reloadTableDataFromUIThread()
    }
}



