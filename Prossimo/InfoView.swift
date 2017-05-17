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
import FontAwesomeKit

class InfoView: UITableViewController {

    var ref: FIRDatabaseReference!
    var userId:String!
    var subscription:String!

    
    @IBOutlet weak var imageViewMyProfile: UIImageView!
    
    @IBOutlet weak var imageViewTC: UIImageView!
    
    @IBOutlet weak var imageViewPP: UIImageView!
    
    @IBOutlet weak var imageViewUpgrade: UIImageView!
    
    @IBOutlet weak var imageViewOurStory: UIImageView!
    
    
    @IBOutlet weak var imageViewContact: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("user id is " + self.userId)
        self.ref = FIRDatabase.database().reference()
        self.ref.child("users/" + self.userId + "/subscription/type").observeSingleEvent(of: .value, with: {
            
            if let val = $0.value as? String {
                
                print("subcription: " + val)
                self.subscription = val

            }
            
        })
        

    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        setIcons()

    }
    
    func setIcons() {
        
        var myProfileImage = FAKFontAwesome.addressCardOIcon(withSize: 18).image(with: CGSize(width: 30, height: 30))
        myProfileImage = myProfileImage?.imageWithColor(color: UIColor.gray)
        
        imageViewMyProfile.image = myProfileImage
        
        
        var tcImage = FAKFontAwesome.alignLeftIcon(withSize: 18).image(with: CGSize(width: 30, height: 30))
        tcImage = tcImage?.imageWithColor(color: UIColor.gray)
        
        imageViewTC.image = tcImage
        
        var privacyImage = FAKFontAwesome.userSecretIcon(withSize: 18).image(with: CGSize(width: 30, height: 30))
        privacyImage = privacyImage?.imageWithColor(color: UIColor.gray)
        
        imageViewPP.image = privacyImage
        
        var upgradeImage = FAKFontAwesome.arrowCircleOUpIcon(withSize: 20).image(with: CGSize(width: 30, height: 30))
        upgradeImage = upgradeImage?.imageWithColor(color: Commons.myDarkGreenColor)
        
        imageViewUpgrade.image = upgradeImage
        
        var outStoryImage = FAKFontAwesome.coffeeIcon(withSize: 18).image(with: CGSize(width: 30, height: 30))
        outStoryImage = outStoryImage?.imageWithColor(color: UIColor.gray)
        
        imageViewOurStory.image = outStoryImage
        
        var contactImage = FAKFontAwesome.envelopeOIcon(withSize: 18).image(with: CGSize(width: 30, height: 30))
        contactImage = contactImage?.imageWithColor(color: UIColor.gray)
        
        imageViewContact.image = contactImage
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "upgradeSegue" {
            
            // set the userId
            if let destination = segue.destination as? UpgradeView {
                
                destination.userId = self.userId
                destination.delegate = self
                
                CleverTap.sharedInstance()?.recordEvent("Upgrade clicked")
            }
        } else if segue.identifier == "myInfoSegue" {
            
            // set the userId
            if let destination = segue.destination as? MyInfoVC {
                
                destination.userId = self.userId
            }
        }
        else if segue.identifier == "signoutSegue" {
            
            if let _ = segue.destination as? Login {
                
                UserDefaults.standard.removeObject(forKey: "loggedInUser")
                
            }
        }
        
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.indexPathForSelectedRow!
        if let cellText = tableView.cellForRow(at: indexPath)?.textLabel?.text {
            
            if cellText == "Contact Us" {
                
                let email = "info.prossimo@gmail.com"
                if let url = URL(string: "mailto:\(email)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                        // Fallback on earlier versions
                    }
                }
                
                self.tableView.deselectRow(at: indexPath, animated: true)

            }
            
        }
    }
    
    let upgradeSectionIndex = 2
    let upgradeRowIndex = 0
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 70.0;

        if self.subscription == "pro" {
            
            if indexPath.section == self.upgradeSectionIndex && indexPath.row == upgradeRowIndex
            {
                height = 0.0;
            } else {
                height = 70.0;
            }
        }
        
        return height
    }
    

}


extension InfoView: UpgradeDelegate {
    
    func subscriptionChanged(subscription: String) {
        
        self.subscription = subscription
        self.tableView.reloadData()
    }
}
