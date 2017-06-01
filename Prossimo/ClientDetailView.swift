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

    
    @IBOutlet weak var labelLastVisit: UILabel!
    
    @IBOutlet weak var btnText: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    
    @IBOutlet weak var labelCalendar: UILabel!
    
    @IBOutlet weak var labelChangePicture: UILabel!
    
    @IBOutlet weak var btnAllVisits: UIButton!
    @IBOutlet weak var btnStarred: UIButton!

    @IBOutlet weak var line: UIView!
    
    @IBOutlet weak var labelClientAggregate: UILabel!
    
    
    
    
    var starredVisits = [ClientVisit]()
    
    var originalLinePosition:CGRect?
    var isStarredSelected = false
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()
        
        
        makeUIChanges()
        resizeProfilePic()
        
        // get the original CGRect for the line
        originalLinePosition = line.frame
        
        fillData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        // get the starred visits
        self.starredVisits = [ClientVisit]()
        
        for visit in self.client.clientVisits {
            if visit.starred {
                self.starredVisits.append(visit)
            }
        }
        
        self.tableView.reloadData()
    }
    
    func makeUIChanges() {

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
        
        // if there's an image
        if (self.client.profileImg.imageUrl != "" || imgTapped) {
            self.imgView.contentMode = .scaleAspectFill
        }
            // if there's no image (small camera icon, we want it to be center)
        else {
            self.imgView.contentMode = .center
        }
        
        self.imgView.layer.cornerRadius = 75
        self.imgView.clipsToBounds = true
    }
    
    
    func setBorders() {

        self.btnNewHC.layer.cornerRadius = 5
        self.btnNewHC.clipsToBounds = true
        
        self.btnText.layer.cornerRadius = 20
        self.btnText.contentMode = .scaleAspectFill
        
        self.btnEmail.layer.cornerRadius = 20
        self.btnEmail.contentMode = .scaleAspectFill
        
        
        self.btnPhone.layer.cornerRadius = 20
        self.btnPhone.contentMode = .scaleAspectFill
    }

    
    func setIcons() {
        
        
        // camera icon
        var cameraIconImage = FAKFontAwesome.cameraIcon(withSize: 60).image(with: CGSize(width: 60, height: 60))
        cameraIconImage = cameraIconImage?.imageWithColor(color: Commons.myColor)
        imgView.image = cameraIconImage
        
        
        // phone icon
        var phoneIconImage = FAKFontAwesome.phoneIcon(withSize: 20).image(with: CGSize(width: 40, height: 40))
        phoneIconImage = phoneIconImage?.imageWithColor(color: Commons.myColor)
        btnPhone.setImage(phoneIconImage, for: .normal)
        
        
        // sms icon
        var smsIconImage = FAKFontAwesome.commentingOIcon(withSize: 20).image(with: CGSize(width: 40, height: 40))
        smsIconImage = smsIconImage?.imageWithColor(color: Commons.myColor)
        btnText.setImage(smsIconImage, for: .normal)
        
        
        // email icon
        var emailIconImage = FAKFontAwesome.envelopeOIcon(withSize: 20).image(with: CGSize(width: 40, height: 40))
        emailIconImage = emailIconImage?.imageWithColor(color: Commons.myColor)
        btnEmail.setImage(emailIconImage, for: .normal)
        
        
        // all visits icon
        var allVisitsIconImage = FAKFontAwesome.listUlIcon(withSize: 10).image(with: CGSize(width: 10, height: 10))
        allVisitsIconImage = allVisitsIconImage?.imageWithColor(color: Commons.myColor)
        btnAllVisits.setImage(allVisitsIconImage, for: .normal)
        
        // starred visits icon
        var starredIconImage = FAKFontAwesome.starOIcon(withSize: 10).image(with: CGSize(width: 10, height: 10))
        starredIconImage = starredIconImage?.imageWithColor(color: Commons.myColor)
        btnStarred.setImage(starredIconImage, for: .normal)
        
        
        
        
        
        
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
    
    @IBAction func emailClick(_ sender: UIButton) {
        
        UIApplication.shared.openURL(URL(string: "mailto://" + self.client.clientEmail)!)
    }

    
    @IBAction func newHaircut(_ sender: UIButton)
    {
        

        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let yearString = String(format: "%04d", year)
        
        let month = calendar.component(.month, from: date)
        let monthString = String(format: "%02d", month)
        
        let day = calendar.component(.day, from: date)
        let dayString = String(format: "%02d", day)

        
        let visitdate = String(month) + "-" + String(day) + "-" + String(year)
        let sorteddate = yearString + "-" + monthString + "-" + dayString
        
        
        // if visit date exists then don't add it
        for v in client.clientVisits {
            if v.visitDate == visitdate {
                
                displayNewHCAlert()
                
                return
            }
        }
        
        self.ref.child("users/" + userId + "/clients/" + self.client.clientId + "/visits/" + visitdate + "/sortingDate").setValue(sorteddate)
        
        self.ref.child("users/" + userId + "/clients/" + self.client.clientId + "/visits/" + visitdate + "/notes").setValue("") { (err, ref) in
            
            self.client.clientVisits.append(ClientVisit(visitDate: visitdate, sortingDate: sorteddate, notes: ""))
            
            self.client.clientVisits.sort { $0.sortingDate > $1.sortingDate }
            self.tableView.reloadData()
            self.setLastVisit()
            
            self.selectedVisitIndex = 0
            self.performSegue(withIdentifier: "pictureTimeSegue", sender: self)
        }
        
    }
    
  
    func moveLine(position:Int) {
        
        
                UIView.animate(withDuration: 0.25) {
        
                    self.line.frame = CGRect(
                        x: self.originalLinePosition!.minX + (CGFloat(position) * self.line.frame.width),
                        y: self.line.frame.minY,
                        width: self.line.frame.width,
                        height: self.line.frame.height)
        
                    
                }
        
    }
    
    @IBAction func visitsClicked(_ sender: UIButton) {
        moveLine(position: 0)
        isStarredSelected = false
        btnAllVisits.setTitleColor(Commons.myColor, for: .normal)// UIColor.white, for: .normal)
        btnStarred.setTitleColor(UIColor.lightGray, for: .normal)
        self.tableView.reloadData()
    }
    
    
    @IBAction func starClicked(_ sender: UIButton) {
        moveLine(position: 1)
        isStarredSelected = true
        btnAllVisits.setTitleColor(UIColor.lightGray, for: .normal)
        btnStarred.setTitleColor(Commons.myColor, for: .normal)//(UIColor.white, for: .normal)
        self.tableView.reloadData()

        
    }

    func setLastVisit() {
        
        if client.clientVisits.count == 0 { return }
        
        let stringLastVisit = client.clientVisits[0].visitDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateLastVisit = dateFormatter.date(from:stringLastVisit)!
        
        let sinceLastVisit = Date().days(from: dateLastVisit).description
        
        labelLastVisit.text = sinceLastVisit + " days ago"
        

    }
    
    func fillData() {
        
        labelName.text = client.clientName
        
        setLastVisit()
        
        if client.profileImg.imageUrl != "" {
            self.imgView.sd_setShowActivityIndicatorView(true)
            self.imgView.sd_setIndicatorStyle(.gray)
            self.imgView.sd_setImage(with: URL(string: client.profileImg.imageUrl))
            self.labelChangePicture.isHidden = true
            
            self.resizeProfilePic()
        }
        else {
            self.imgView.image = UIImage(imageLiteralResourceName: "icon-camera-32")
            self.labelChangePicture.isHidden = false
        }
        
        var aggregate = ""
        
        aggregate = String(self.client.clientVisits.count) + " VISITS - "
        
        var revenue:Double = 0
        for v in self.client.clientVisits {
            revenue = revenue + v.price
        }
        
        aggregate = aggregate + "$" + String(revenue)
        
        
        self.labelClientAggregate.text = aggregate
        
        // hide the footer if no visits
        if self.client.clientVisits.count == 0 {
            self.labelClientAggregate.isHidden = true
        }
    }
    
    
    // must exist: returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isStarredSelected {
            return self.starredVisits.count
        } else {
            return self.client.clientVisits.count
        }
    }
    
    // must exist: customize each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = Bundle.main.loadNibNamed("ClientDetailsCell", owner: self, options: nil)?.first as? ClientDetailsCell

        
        //if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ClientDetailsTableViewCell
        {
            var humanReadableDate = ""
            var notes = ""
            var price = ""
            var icon = UIImage()
            
        
            
            // get date from starred visits
            if isStarredSelected {
                
                humanReadableDate = Commons.getHumanReadableDate(dateString: self.starredVisits[indexPath.row].visitDate)
                notes = self.starredVisits[indexPath.row].notes
                price = "$" + String(self.starredVisits[indexPath.row].price)
                icon = FAKFontAwesome.starIcon(withSize: 16).image(with: CGSize(width: 20, height: 20))
                
            } else { // get date from all visits
            
                humanReadableDate = Commons.getHumanReadableDate(dateString: self.client.clientVisits[indexPath.row].visitDate)
                
                notes = self.client.clientVisits[indexPath.row].notes
                price = "$" + String(self.client.clientVisits[indexPath.row].price)
                icon = FAKFontAwesome.calendarIcon(withSize: 16).image(with: CGSize(width: 20, height: 20))
            }
            
            cell.labelVisitDate.text = humanReadableDate
            cell.labelNotes.text = notes
            cell.labelPrice.text = price
            
            icon = icon.imageWithColor(color: UIColor.gray)!
            cell.imageViewIcon.image = icon
            
            return cell
        }
        
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.indexPathForSelectedRow!
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let selectedLabel = cell.viewWithTag(1) as? UILabel
            
            // set date to selected row
            if isStarredSelected {
                
                for i in 0..<self.client.clientVisits.count {
                    
                    let v = self.client.clientVisits[i]
                    
                    if Commons.getHumanReadableDate(dateString: v.visitDate) == selectedLabel?.text {
                        self.selectedVisitIndex = i
                        break
                    }
                }
                
            } else {
                self.selectedVisitIndex = indexPath.row
            }
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
                self.setLastVisit()
                
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
    

    var imgTapped = false

    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
    
        imgTapped = true
        displayProfileImageAlert()
        
        
    }
    
    func displayProfileImageAlert() {
        
        let image = UIImagePickerController()
        image.allowsEditing = true
        image.delegate = self
        
        
        
        let profileImageAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        profileImageAlert.addAction(UIAlertAction(title: "Take a New Photo", style: .default, handler: { (action: UIAlertAction!) in
            
            image.sourceType = UIImagePickerControllerSourceType.camera
            self.present(image, animated: true)
            
        }))
        
        profileImageAlert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction!) in
            
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(image, animated: true)
            
        }))
        
        
        
        profileImageAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(profileImageAlert, animated: true, completion: nil)
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
            self.resizeProfilePic()
            
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
        
        let alert = UIAlertController(title: "There is already a haircut for today", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
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
        
        self.resizeProfilePic()
        
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
        setLastVisit()
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    
}

