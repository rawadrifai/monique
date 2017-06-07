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
    var filteredData = [Expense]()
    var plusClicked = false
    
    // search bar stuff
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    @IBOutlet weak var labelTotalExpenses: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        customizeSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getExpenses()
        plusClicked = false
    }

    
    @IBAction func plusClicked(_ sender: UIBarButtonItem) {
        
        plusClicked = true
        self.performSegue(withIdentifier: "expenseDetailsSegue", sender: self)
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // check what's the tableview passed
        if tableView == self.tableView {
            return expenses.count
        }
        else {
            return filteredData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = Bundle.main.loadNibNamed("ExpenseCell", owner: self, options: nil)?.first as? ExpenseCell
            
        {
            let expense = Expense()
            
            
            
            // check what's the tableview passed
            if tableView == self.tableView {
                
                
                expense.item = expenses[indexPath.row].item
                expense.price = expenses[indexPath.row].price
                expense.date = expenses[indexPath.row].date
                
            }
            else {

                expense.item = filteredData[indexPath.row].item
                expense.price = filteredData[indexPath.row].price
                expense.date = filteredData[indexPath.row].date
            }


            cell.labelItem.text = expense.item
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
                print(sender ?? "default")
                
               if plusClicked
                // if self.tableView.indexPathForSelectedRow ==
                    {
                    
                    // create a generic expense object with id and todays dates
                    let expense = Expense()
                    expense.id = UUID().uuidString
                    expense.date = Commons.getTodaysShortDate()
                    expense.sortingDate = Commons.getTodaysSortingDate()
                    
                    destination.expense = expense
                    destination.userId = self.userId
                    
                } else { // if a row is selected
                    
                    
                    

                    
                    // if there is text in the search bar
                    if ((searchController.searchBar.text) == "") {
                        
                        // get selected row
                        let selectedRow:Int = (self.tableView.indexPathForSelectedRow?.row)!
                        
                        // sometimes it crashes because index out of bounds, so this is to prevent that
                        guard selectedRow < self.expenses.count && selectedRow >= 0 else {
                            return
                        }
                        
                        destination.expense = expenses[selectedRow]
                        destination.userId = self.userId
                    }
                        // if no text is in the searchbar
                    else {
                        
                        let selectedRow:Int = (resultsController.tableView.indexPathForSelectedRow?.row)!
                        
                        // sometimes it crashes because index out of bounds, so this is to prevent that
                        guard selectedRow < filteredData.count && selectedRow >= 0 else {
                            return
                        }
                        
                        destination.expense = filteredData[selectedRow]
                        destination.userId = self.userId
                        
                   
                    }
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
                    
                    // get rest of the expense info
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
        
        let aggregateString = "$" + String(format: "%.2f", totalExpenses)
            + " TOTAL"
        
        self.labelTotalExpenses.text = aggregateString
        
        
    }

    
}

extension ExpensesTVC: UISearchResultsUpdating {
    

    // this func customizes the search controller provided by default
    func customizeSearchController() {
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.rowHeight = 90
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.autocapitalizationType = .none
        self.searchController.dimsBackgroundDuringPresentation = true
        
        // make the header = to the searchController
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        // eliminates white space between search bar and results
        definesPresentationContext = true
        
    }
    
    // function must exist if we implement UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
        // filter data
        self.filteredData = self.expenses.filter({ (data:Expense) -> Bool in
            
            if self.searchController.searchBar.text! == ""
            {return true}
            
            if data.item.lowercased().contains(self.searchController.searchBar.text!.lowercased()) {
                
                return true
            }
            else {
                return false
            }
        })
        
        // update tableview
        self.resultsController.tableView.reloadData()
    }
}



