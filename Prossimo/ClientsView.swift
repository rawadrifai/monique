//
//  ContactsView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 2/19/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseDatabase
import Fabric
import Crashlytics
import Contacts
import ContactsUI
import FontAwesomeKit
import EasyTipView

extension ClientsView: EasyTipViewDelegate {

    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        
        switch tipView.text {
        case TipViews.shared.addClientText:
            
            EasyTipView.show(animated: true, forItem: btnImport, withinSuperview: self.navigationController?.view, text: TipViews.shared.importClientText, preferences: EasyTipView.globalPreferences, delegate: self)
            
            break
        default:
            break
        }
        
    }
}


class ClientsView: UITableViewController, UISearchResultsUpdating {
    
    
    
    var ref: FIRDatabaseReference!
    
    // search bar stuff
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    var userId:String!
    var cellData = [Client]()
    var filteredData = [Client]()
    var importClicked:Bool!
    
    @IBOutlet weak var btnAddClient: UIBarButtonItem!
    
    @IBOutlet weak var btnImport: UIBarButtonItem!
    
    @IBOutlet weak var labelClientCount: UILabel!
    
    
    // every time the page shows (including when going back to it from the nav)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // get all the user related data
        getUserData()
        
        importClicked = false
        setIcons()
        
        checkIfFirstTimeUse()
    }
    
    func checkIfFirstTimeUse() {
        
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        guard let lastVersionUsed = UserDefaults.standard.string(forKey: "ClientsView")
            else {
                // if first time user
                UserDefaults.standard.set(version, forKey: "ClientsView")

                EasyTipView.show(animated: true, forItem: btnAddClient, withinSuperview: self.navigationController?.view, text: TipViews.shared.addClientText, preferences: EasyTipView.globalPreferences, delegate: self)

                return
        }
        
        if version != lastVersionUsed {
            
            UserDefaults.standard.set(version, forKey: "ClientsView")
            
            EasyTipView.show(animated: true, forItem: btnAddClient, withinSuperview: self.navigationController?.view, text: TipViews.shared.addClientText, preferences: EasyTipView.globalPreferences, delegate: self)
        }
    }
    
    

    
    func setIcons() {
        var contactsIconImage = FAKFontAwesome.userPlusIcon(withSize: 22).image(with: CGSize(width: 35, height: 25))
        contactsIconImage = contactsIconImage?.imageWithColor(color: Commons.myColor)
        
        self.btnImport.image = contactsIconImage

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkForLatestVersion()
        
        // needed things for the search to work
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.rowHeight = 78
        
        customizeSearchController()
    }
    
    
    // this func customizes the search controller provided by default
    func customizeSearchController() {
        
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
        self.filteredData = cellData.filter({ (data:Client) -> Bool in
            
            if self.searchController.searchBar.text! == ""
            {return true}
            
            if data.clientName.lowercased().contains(self.searchController.searchBar.text!.lowercased()) ||
                data.clientPhone.lowercased().contains(self.searchController.searchBar.text!.lowercased()) ||
                data.clientEmail.lowercased().contains(self.searchController.searchBar.text!.lowercased()) {
                
                return true
            }
            else {
                return false
            }
        })
        
        // update tableview
        self.resultsController.tableView.reloadData()
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
        
        
        // get an instance of the client to be deleted
        let clientToBeDeleted = self.cellData[indexPath.row] as Client
        
        let deleteAlert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            self.ref = FIRDatabase.database().reference()
            
            // delete from firebase database, with completion block
            
            self.ref.child("users/" + self.userId + "/clients/" + clientToBeDeleted.clientId).removeValue(completionBlock: { (err, ref) in
                
                self.cellData.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                // delete from firebase
                let storageRef = FIRStorage.storage().reference().child(self.userId).child("clients").child(clientToBeDeleted.clientId)
                
                storageRef.delete { (err) in
                    
                    if err != nil {
                        //print("received an error: " + (err?.localizedDescription)!)
                    }
                    self.setAggregates()
                }
            })
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(deleteAlert, animated: true, completion: nil)
        
    }
    
    var contactToImport:CNContact?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "clientDetailsSegue" {
            
            if let destination = segue.destination as? ClientDetailView {
                
                
                // if there is text in the search bar
                if ((searchController.searchBar.text) == "") {
                    
                    // get selected row
                    let selectedRow:Int = (self.tableView.indexPathForSelectedRow?.row)!
                    
                    // sometimes it crashes because index out of bounds, so this is to prevent that
                    guard selectedRow < cellData.count && selectedRow >= 0 else {
                        return
                    }
                    
                    destination.client = cellData[selectedRow]
                    destination.userId = self.userId
                }
                    // if no text is in the searchbar
                else {
                    
                    let selectedRow:Int = (resultsController.tableView.indexPathForSelectedRow?.row)!
                    
                    // sometimes it crashes because index out of bounds, so this is to prevent that
                    guard selectedRow < filteredData.count && selectedRow >= 0 else {
                        return
                    }
                    
                    destination.client = filteredData[selectedRow]
                    destination.userId = self.userId
                }
            }
        }
            // set userId if we're going to add a client
        else if segue.identifier == "newClientSegue" {
            if let destination = segue.destination as? NewClientVC {
                destination.userId = self.userId
                destination.numberOfClients = self.tableView.numberOfRows(inSection: 0)
                destination.delegate = self
                
                if importClicked {
                    
                    destination.contact = contactToImport
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
    
    
    
    
    func getUserData() {
        
        self.cellData = [Client]()

        if (userId=="no user id") {return}
        
        ref = FIRDatabase.database().reference()
        self.ref.child("users/" + self.userId + "/clients").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
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
                    client.clientPhone = clientInfo.value(forKey: "clientPhone") as? String ?? ""
                    
                    // try to see if client has a profile image
                    if let profile = clientInfo.value(forKey: "profile") as? NSDictionary {
                        
                        client.profileImg.imageName = profile.value(forKey: "imageName") as? String ?? ""
                        client.profileImg.imageUrl = profile.value(forKey: "imageUrl") as? String ?? ""
                    }
                    
                    // Visits
                    if let clientVisits = clientInfo.value(forKey: "visits") as? NSDictionary {
                        
                      //  var tempClientVisits = [ClientVisit]()
                        
                        // loop through visits
                        for visit in (clientVisits.allKeys) {

                            
                            // create a client visit object and set the id to the key (visit date)
                            let clientVisit = ClientVisit()
                            clientVisit.visitDate = visit as! String
                            
                            // get the rest of the info
                            let visitInfo = (clientVisits.value(forKey: clientVisit.visitDate) as? NSDictionary)!
                            
                            clientVisit.notes = visitInfo.value(forKey: "notes") as? String ?? ""
                            clientVisit.sortingDate = visitInfo.value(forKey: "sortingDate") as? String ?? ""
                            clientVisit.starred = visitInfo.value(forKey: "starred") as? Bool ?? false
                            clientVisit.price = visitInfo.value(forKey: "price") as? Double ?? 0
                            
                            if let options = visitInfo.value(forKey: "options") as? [String : String]
                            {
                                clientVisit.options = options as [String:String]
                            }
                            
                            // get the images for each visit
                            if let visitImages = (visitInfo.value(forKey: "images") as? NSDictionary) {
                     
                                for image in visitImages.allKeys {
                                    
                                    if let imgInfo = (visitImages.value(forKey: image as! String) as? NSDictionary) {
                                        
                                        let imgObj = ImageObject()
                                        imgObj.imageName = image as! String
                                        imgObj.imageUrl = imgInfo.value(forKey: "imageUrl") as! String
                                        imgObj.uploadDate = imgInfo.value(forKey: "uploadDate") as! String
                                        

                                        clientVisit.images.append(imgObj)
                                    }
                                }
                                clientVisit.images.sort { $0.uploadDate > $1.uploadDate }
                            }
                            client.clientVisits.append(clientVisit)
                        }
                        client.clientVisits.sort { $0.sortingDate > $1.sortingDate }
                    }
                    
                    
                    
                    
                    
                    
                    
                    self.cellData.append(client)
                }
                self.cellData.sort { $0.clientName < $1.clientName }
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
        
        aggregateString = aggregateString + "$" + String(format: "%.2f", revenue)
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
    
    func openContacts() {
        self.importClicked = true
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true) {}
    }

}



extension ClientsView:NewClientDelegate {
    
    func dataChanged(client:Client) {
        
        for i in 0..<self.cellData.count {
            if cellData[i].clientId == client.clientId {
                cellData[i] = client
                break
            }
        }
    }
}


extension ClientsView:CNContactPickerDelegate {
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.importClicked = false
        picker.dismiss(animated: true) {}
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        self.contactToImport = contact
        self.performSegue(withIdentifier: "newClientSegue", sender: self)
    }
}

extension ClientsView {
    
    
    // check for latest version and prompt for upgrade if necessary
    
    func checkForLatestVersion() {
        
        self.ref = FIRDatabase.database().reference()

        self.ref.child("latestversion").observeSingleEvent(of: .value, with: {
            
            
            // get latest version from firebase
            guard let value = $0.value as? Double else {
                
                return
            }
            
            // get local version
            guard let versionText = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                return
            }
            
            // convert version to double for sake of comparison
            guard let versionDouble = Double(versionText) else {
                return
            }

            
            // if value in firebase is higher than local
            if value > versionDouble {
                
                self.ref.child("forceupdate").observeSingleEvent(of: .value, with: {
                    
                    
                    // if no force update value exists in firebase
                    guard let forceUpdate = $0.value else {
                        return
                    }
                    
                    if "1" == String(describing: forceUpdate) {
                        
                        self.redirectToAppStore()
                    }
                    
                    
                })
            } else {
                print("version is current")
            }
          
        })
    }
    

    func redirectToAppStore() {
        
        UIApplication.shared.openURL(URL(string: Commons.appStoreUrl)!)
        
    }
    
    
    
}


