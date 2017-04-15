//
//  MoreView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 3/20/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class InfoView: UITableViewController {

    var ref: FIRDatabaseReference!
    var userId = String()
    var subscription = String()
    
   // @IBOutlet weak var upgradeCell: UITableViewCell!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.ref = FIRDatabase.database().reference()
        self.ref.child("users/" + self.userId + "/subscription/type").observeSingleEvent(of: .value, with: {
            
            if let val = $0.value as? String {
                
                print("subcription: " + val)
                self.subscription = val
                
                if val == "pro" {
                    
                    //self.upgradeCell.isHidden = true
                    //self.tableView.reloadData()

                }
                else {
                   // self.upgradeCell.isHidden = false
                }
                
            }
            
        })
        

    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        

    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.indexPathForSelectedRow!
        if let cellText = tableView.cellForRow(at: indexPath)?.textLabel?.text {
            
            if cellText == "Contact Us" {
                
                let email = "tuukinfo@gmail.com"
                if let url = URL(string: "mailto:\(email)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                        // Fallback on earlier versions
                    }
                }
            }
        }
    }
    
    let upgradeSectionIndex = 1
    let upgradeRowIndex = 0
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 70.0;
        
        if indexPath.section == self.upgradeSectionIndex && indexPath.row == upgradeRowIndex
        {
            height = 0.0;
        } else {
            height = 70.0;
        }
        
        return height
    }
    

}


