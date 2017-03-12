//
//  ContactsView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 2/19/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
//import Google
import GoogleSignIn
import Firebase
import FirebaseDatabase

class ClientsView: UITableViewController, UISearchResultsUpdating {


    var ref: FIRDatabaseReference!

    // search bar stuff
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    
    var userId = String()
    var cellData = [Client]()
    var filteredData = [Client]()
    
    
    
    func getUserData() {
        
        self.cellData = [Client]()
        
        if (userId=="no user id") {return}
        
        ref = FIRDatabase.database().reference()
        
        // get data from "email/clients" (async call)
        ref.child(userId + "/clients").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            
            // Get a list of users, keys are client ids (or phone numbers)
            if let clientsDictionary = snapshot.value as? NSDictionary {
                
                
                // loop through ids and get rest of the info
                for clientItem in (clientsDictionary.allKeys) {
                    
                    // create a client and set the id to the key
                    let client = Client()
                    client.clientId = clientItem as! String
                    
                    
                    // get rest of the client info
                    let clientInfo = (clientsDictionary.value(forKey: client.clientId) as? NSDictionary)!
                    client.clientName = clientInfo.value(forKey: "clientName") as? String ?? ""
                    client.clientEmail = clientInfo.value(forKey: "clientEmail") as? String ?? ""
                    
                    
                    // try to see if client has any visits already
                    if let clientVisits = clientInfo.value(forKey: "visits") as? NSDictionary {
                        
                        // loop through the client visits
                        for visit in (clientVisits.allKeys) {
                            
                            // create a client visit object and set the id to the key (visit date)
                            let clientVisit = ClientVisit()
                            clientVisit.visitDate = visit as! String
                            
                            
                            // get the rest of the info
                            let visitInfo = (clientVisits.value(forKey: clientVisit.visitDate) as? NSDictionary)!
                            
                            clientVisit.notes = visitInfo.value(forKey: "notes") as? String ?? ""
                            clientVisit.images = visitInfo.value(forKey: "images") as? [String] ?? [String]()
                            
                            client.clientVisits.append(clientVisit)
                            
                        }
                    }
  
                    
                    // add client to array
                    self.cellData.append(client)
                }
                
            }
            
            
            
            // update table view from the UI thread
            DispatchQueue.global(qos: .userInitiated).async {
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    // every time the page shows (including when going back to it from the nav)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // get all the user related data
        getUserData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // needed things for the search to work
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        customizeSearchController()
        
    }
    
    // this func customizes the search controller provided by default
    func customizeSearchController() {
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.autocapitalizationType = .none
        self.searchController.dimsBackgroundDuringPresentation = false
        
        // make the header = to the searchController
        self.tableView.tableHeaderView = self.searchController.searchBar

        
        // eliminates white space between search bar and results
        definesPresentationContext = true
        
    }
    
    // function must exist if we implement UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
        // filter data
        self.filteredData = cellData.filter({ (data:Client) -> Bool in
            
            if self.searchController.searchBar.text! == ""
            {return true}
            
            if data.clientName.lowercased().contains(self.searchController.searchBar.text!.lowercased()) {
                return true
            }
            else {
                return false
            }
        })
        
        // update tableview
        self.resultsController.tableView.reloadData()
    }

    // must exist: returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // check what's the tableview passed
        if tableView == self.tableView {
            return cellData.count
        }
        else {
            return filteredData.count
        }
        
    }

    // must exist: customize each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        {
            // check what's the tableview passed
            if tableView == self.tableView {
                cell.textLabel?.text = cellData[indexPath.row].clientName
            }
            else {
                cell.textLabel?.text = filteredData[indexPath.row].clientName
            }
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
        
    }
    
    //let cell = self.tableView.cellForRow(at: self.tableView.indexPathForSelectedRow!)
    //destination.title = (cell?.textLabel?.text!)!
    // prepare data before switching views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "clientDetailsSegue" {
            
            if let destination = segue.destination as? ClientDetailView {
  
                
                // if there is text in the search bar
                if ((searchController.searchBar.text) == "") {
                    
                    // get selected row
                    let selectedRow:Int = (self.tableView.indexPathForSelectedRow?.row)!
                    destination.client = cellData[selectedRow]
                    destination.userId = self.userId
                }
                // if no text is in the searchbar
                else {
                    
                    let selectedRow:Int = (resultsController.tableView.indexPathForSelectedRow?.row)!
                    destination.client = filteredData[selectedRow]
                    destination.userId = self.userId
                }
            }
        }
        // set userId if we're going to add a client
        else if segue.identifier == "newClientSegue" {
            if let destination = segue.destination as? NewClientView {
                destination.userId = self.userId
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath) {
        
            self.performSegue(withIdentifier: "clientDetailsSegue", sender: self)
            
        }
        
    }
    

}
