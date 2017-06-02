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
    
    
    @IBOutlet weak var imageViewMyProfile: UIImageView!
    
    @IBOutlet weak var imageViewTC: UIImageView!
    
    @IBOutlet weak var imageViewPP: UIImageView!
    
    @IBOutlet weak var imageViewUpgrade: UIImageView!
    
    @IBOutlet weak var imageViewOurStory: UIImageView!
    
    
    @IBOutlet weak var imageViewContact: UIImageView!
    
    @IBOutlet weak var btnFacebook: UIButton!
    
    @IBOutlet weak var btnInstagram: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("user id is " + self.userId)
        self.ref = FIRDatabase.database().reference()
        
        
        // seach icon
        var searchImage = FAKFontAwesome.addressBookOIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        searchImage = searchImage?.imageWithColor(color: Commons.myColor)
        tabBarItem.image = searchImage
        
        

    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        setIcons()

    }
    
    func setIcons() {
        
        let fbImage = FAKFontAwesome.facebookSquareIcon(withSize: 40).image(with: CGSize(width: 60, height: 60))
        //fbImage = fbImage?.imageWithColor(color: UIColor.blue)
        btnFacebook.setImage(fbImage, for: .normal)
        
        let instagramImage = FAKFontAwesome.instagramIcon(withSize: 40).image(with: CGSize(width: 60, height: 60))
        //instagramImage = instagramImage?.imageWithColor(color: UIColor.brown)
        btnInstagram.setImage(instagramImage, for: .normal)
        
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
                
                CleverTapManager.shared.registerEvent(eventName: "Upgrade Clicked")
                
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

    
    func composeEmail(email:String) {
        
        guard let url = URL(string: "mailto:\(email)") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.indexPathForSelectedRow!
        
        if let contactUsCell = tableView.cellForRow(at: indexPath) {
            
            
            guard let label = contactUsCell.viewWithTag(1) as? UILabel else {
                self.tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            
            guard label.text == "Contact Us" else {
                self.tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            
            self.ref.child("contactemail").observeSingleEvent(of: .value, with: {
                
                
                if let email = $0.value as? String {
                    
                    self.composeEmail(email: email)
                    
                } else {
                    
                    self.composeEmail(email: "contact@prossimostylist.com")
                    
                }
            })
            
            
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            
            
            
        }
        
        
    }
    
    let upgradeSectionIndex = 1
    let upgradeRowIndex = 0
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 70.0;

        if StoreManager.shared.isSubscriptionActive() {
            
            if indexPath.section == self.upgradeSectionIndex && indexPath.row == upgradeRowIndex
            {
                height = 0.0;
            } else {
                height = 70.0;
            }
        }
        
        return height
    }
    
    
    @IBAction func facebookClick(_ sender: UIButton) {
        
        
        let fbUrlString = "fb://profile/225583714592844"
        let webUrlString = "https://www.facebook.com/prossimostylist"
        
        
        let application = UIApplication.shared
        
        guard let fbUrl = NSURL.init(string: fbUrlString) else { return }
        guard let webUrl = NSURL.init(string: webUrlString) else { return }

      
        if application.canOpenURL(fbUrl as URL) {
            application.openURL(fbUrl as URL)
        } else {
            application.openURL(webUrl as URL)
        }

    }
    
    
    @IBAction func instagramClick(_ sender: UIButton) {
        UIApplication.tryURL(urls: [
            "instagram://user?username=prossimostylist", // App
            "https://www.instagram.com/prossimostylist/" // Website if app fails
            ])
        
        let instagramUrlString = "instagram://user?username=prossimostylist"
        let webUrlString = "https://www.instagram.com/prossimostylist"
        
        let application = UIApplication.shared
        
        guard let instagramUrl = NSURL.init(string: instagramUrlString) else { return }
        guard let webUrl = NSURL.init(string: webUrlString) else { return }
        
        
        if application.canOpenURL(instagramUrl as URL) {
            application.openURL(instagramUrl as URL)
        } else {
            application.openURL(webUrl as URL)
        }
        
        
    }
    

}


extension InfoView: UpgradeDelegate {
    
    func subscriptionChangedToPro() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}


extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                application.openURL(URL(string: url)!)
                return
            }
        }
    }
}
