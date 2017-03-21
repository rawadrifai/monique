//
//  MoreView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 3/20/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit

class MoreView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
}
