//
//  ClientDetailView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 2/22/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FontAwesomeKit

extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

}

class ClientDetailView: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    var userId:String!
    var client:Client!
    var selectedVisitIndex:Int!
    var ref: FIRDatabaseReference!

    
    @IBOutlet weak var btnNewHC: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelName: UILabel!

    @IBOutlet weak var btnText: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var labelChangePicture: UILabel!
    
    @IBOutlet weak var labelHistory: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()
        
        makeUIChanges()
        fillData()
        resizeProfilePic()
        
        self.btnText.layer.cornerRadius = 20
        self.btnText.contentMode = .scaleAspectFill
        
        
        self.btnPhone.layer.cornerRadius = 20
        self.btnPhone.contentMode = .scaleAspectFill
        
    }
    
    func makeUIChanges() {

        if self.client.clientVisits.count == 0 {
            self.labelHistory.text = ""
        }
        
        setIcons()
        makeProfilePicInteractive()
        setBorders()
    }
    
    func makeProfilePicInteractive() {
        
        // make the profile picture interactive
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        self.imgView.isUserInteractionEnabled = true
        self.imgView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    func resizeProfilePic() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        //self.imgView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width * 0.66)
        
        self.imgView.frame = CGRect(x: screenSize.width/2, y: 30, width: screenSize.width/2, height: screenSize.width/2)
        
        self.imgView.layer.cornerRadius = 100
        self.imgView.contentMode = .scaleAspectFill
        
        // if there's an image
    //    if (self.client.profileImg.imageUrl != nil && self.client.profileImg.imageUrl != "") {
    //        self.imgView.contentMode = .scaleAspectFill
    //    }
            // if there's no image (small camera icon, we want it to be center)
   //     else {
   //         self.imgView.contentMode = .center
    //    }
        self.imgView.clipsToBounds = true
    }
    
    func setBorders() {

        self.btnNewHC.layer.cornerRadius = 5
        self.btnNewHC.clipsToBounds = true
    }

    let myColor = UIColor(red:0.51, green:1.00, blue:0.86, alpha:1.0)
    
    func setIcons() {
        
        
        // phone icon
        var cameraIconImage = FAKFontAwesome.cameraIcon(withSize: 60).image(with: CGSize(width: 60, height: 60))
        cameraIconImage = cameraIconImage?.imageWithColor(color: UIColor.black)
        imgView.image = cameraIconImage
        //btnPhone.setImage(phoneIconImage, for: .normal)
        
        
        // phone icon
        var phoneIconImage = FAKFontAwesome.phoneIcon(withSize: 25).image(with: CGSize(width: 40, height: 40))
        phoneIconImage = phoneIconImage?.imageWithColor(color: myColor)
        btnPhone.setImage(phoneIconImage, for: .normal)
        
        
        // sms icon
        
        var smsIconImage = FAKFontAwesome.commentingIcon(withSize: 25).image(with: CGSize(width: 40, height: 40))
        smsIconImage = smsIconImage?.imageWithColor(color: myColor)
        btnText.setImage(smsIconImage, for: .normal)
        
        
    }
    
    @IBAction func phoneClick(_ sender: UIButton) {
        
        let phoneAlert = UIAlertController(title: client.clientPhone, message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        phoneAlert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action: UIAlertAction!) in
            
            UIApplication.shared.openURL(URL(string: "tel://" + self.client.clientPhone)!)
            
        }))
        
        
        phoneAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(phoneAlert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func messageClick(_ sender: UIButton) {
        
        UIApplication.shared.openURL(URL(string: "sms://" + self.client.clientPhone)!)

    }
    

    @IBAction func newHaircut(_ sender: UIButton)
    {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        let visitdate = String(month) + "-" + String(day) + "-" + String(year)
        let sorteddate = String(year) + "-" + String(month) + "-" + String(day)
        
        
        // if visit date exists then don't add it
        for v in client.clientVisits {
            if v.visitDate == visitdate {
                
                self.selectedVisitIndex = 0
                
                displayNewHCAlert()
                
                return
            }
        }
        
        self.ref.child("users/" + userId + "/clients/" + self.client.clientId + "/visits/" + visitdate + "/sortingDate").setValue(sorteddate)
        
        self.ref.child("users/" + userId + "/clients/" + self.client.clientId + "/visits/" + visitdate + "/notes").setValue("") { (err, ref) in
            
            self.labelHistory.text = "VISITS"
            self.client.clientVisits.append(ClientVisit(visitDate: visitdate, sortingDate: sorteddate, notes: ""))
            
            self.client.clientVisits.sort { $0.sortingDate > $1.sortingDate }
            self.tableView.reloadData()
         
            self.selectedVisitIndex = 0
            self.performSegue(withIdentifier: "pictureTimeSegue", sender: self)
        }
        
    }

    func fillData() {
        
        labelName.text = client.clientName
        btnPhone.setTitle(client.clientPhone, for: .normal)
        
        if client.profileImg.imageUrl != "" {
            self.imgView.sd_setShowActivityIndicatorView(true)
            self.imgView.sd_setIndicatorStyle(.gray)
            self.imgView.sd_setImage(with: URL(string: client.profileImg.imageUrl))
            self.labelChangePicture.isHidden = true
        }
        else {
            self.imgView.image = UIImage(imageLiteralResourceName: "icon-camera-32")
            self.labelChangePicture.isHidden = false
        }
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath) {
            
            // set date to selected row
            self.selectedVisitIndex = indexPath.row
            self.performSegue(withIdentifier: "pictureTimeSegue", sender: self)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        // get an instance of the client to be deleted
        let visitToBeDeleted = self.client.clientVisits[indexPath.row] as ClientVisit
        
        let deleteAlert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            self.ref = FIRDatabase.database().reference()
            
            // delete from firebase database, with completion block
            
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + visitToBeDeleted.visitDate).removeValue(completionBlock: { (err, ref) in
                
                self.client.clientVisits.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                // delete from firebase
                let storageRef = FIRStorage.storage().reference().child(self.userId + "/clients/" + self.client.clientId + "/visits/" + visitToBeDeleted.visitDate)
                
                
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
        
        
        
        if segue.identifier == "editClientSegue" {
            
            // set the userId
            if let destination = segue.destination as? EditClientVC {
                
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
                destination.selectedVisitIndex = self.selectedVisitIndex
                destination.delegate = self
            }
        }
    }
    


    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let image = UIImagePickerController()
        image.allowsEditing = true
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera

        self.present(image, animated: true)
    }
    
    
    func uploadImageToFirebase(data: Data, path: String, fileName: String) {
        
        // get storage service reference
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        storageRef.put(data, metadata: nil) { (metadata, err) in
            
            if err != nil {
                //print("received an error: " + (err?.localizedDescription)!)
            }
            else {
                guard metadata != nil else {
                    print("error occurred")
                    return
                }
                
                self.client.profileImg.imageName = fileName
                self.client.profileImg.imageUrl = (metadata?.downloadURL()?.absoluteString)!
                
                self.ref.child(path + "/imageName").setValue(self.client.profileImg.imageName)
                self.ref.child(path + "/imageUrl").setValue(self.client.profileImg.imageUrl)
                
            }
        }
    }
    
    
    
    // execute after picking the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            self.imgView.image = UIImage(data: image.sd_imageData()!,scale: 0)
            self.labelChangePicture.isHidden = true

            let compressedImageData = UIImageJPEGRepresentation(self.imgView.image!, 0)
            
            uploadImageToFirebase(data: compressedImageData!, path: "users/" + self.userId + "/clients/" + self.client.clientId + "/profile/", fileName: UUID().uuidString)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func displayPhoneAlert() {
        
        let phoneAlert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        phoneAlert.addAction(UIAlertAction(title: "Call " + client.clientPhone, style: .default, handler: { (action: UIAlertAction!) in
            
            UIApplication.shared.openURL(URL(string: "tel://" + self.client.clientPhone)!)
            
        }))
        
  
        
        phoneAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(phoneAlert, animated: true, completion: nil)
    }
    
    func displayNewHCAlert() {
        
        let alert = UIAlertController(title: "Haircut Exists", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    

}



extension ClientDetailView: EditClientDelegate {
    
    func dataDeleted() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imageChanged(client: Client) {
        self.client.profileImg = client.profileImg
        self.imgView.sd_setShowActivityIndicatorView(true)
        self.imgView.sd_setIndicatorStyle(.gray)
        self.imgView.sd_setImage(with: URL(string: self.client.profileImg.imageUrl))
        self.labelChangePicture.isHidden=true
        
    }
    
    // Child Delegate
    func dataChanged(client: Client) {
        
        self.client.clientPhone = client.clientPhone
        self.client.clientName = client.clientName
        self.client.clientEmail = client.clientEmail
        
        self.labelName.text = client.clientName
        btnPhone.setTitle(client.clientPhone, for: .normal)
        
    }
    
}

extension ClientDetailView: PictureTimeDelegate {
    
    func historyChanged(client: Client) {
        
        self.client.clientVisits = client.clientVisits
        self.client.clientVisits.sort { $0.sortingDate > $1.sortingDate }
        
        self.tableView.reloadData()
    }
}

