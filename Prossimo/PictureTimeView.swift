//
//  PictureTimeView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 3/8/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Social
import FontAwesomeKit
import NYTPhotoViewer


class PictureTimeView: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {


    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var txvNotes: UITextView!
    var selectedVisitIndex:Int!
    var userId:String!
    var client:Client!
    var ref: FIRDatabaseReference!
    var delegate: PictureTimeDelegate?
    
    @IBOutlet weak var btnStar: UIBarButtonItem!
    @IBOutlet weak var labelNotes: UILabel!
    @IBOutlet weak var txfPrice: UITextField!
    @IBOutlet weak var btnPrice1: UIButton!
    @IBOutlet weak var btnPrice2: UIButton!
    @IBOutlet weak var btnPrice3: UIButton!
    
    var price1Selected = false
    var price2Selected = false
    var price3Selected = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        self.ref = FIRDatabase.database().reference()
        loadVisit()
        setBorders()
        setIcons()
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        save()
    }
    
    func setStarIcon(selected:Bool) {
        var starIconImage = UIImage()
        
        if selected {
            starIconImage = FAKFontAwesome.starIcon(withSize: 25).image(with: CGSize(width: 35, height: 25))

        } else {
            starIconImage = FAKFontAwesome.starOIcon(withSize: 25).image(with: CGSize(width: 35, height: 25))
        }
        
        starIconImage = starIconImage.imageWithColor(color: Commons.myColor)!
        btnStar.image = starIconImage
        
    }
    
    func setBorders() {
        
       // self.btnHaircutDetails.layer.borderWidth = 0.5
       // self.btnHaircutDetails.layer.borderColor = UIColor.lightGray.cgColor
        
        self.txvNotes.layer.borderWidth = 0.5
        self.txvNotes.layer.borderColor = UIColor.gray.cgColor
        self.txvNotes.layer.cornerRadius = 10
        self.txvNotes.clipsToBounds = true
    }
    
    func setIcons() {
        
        
      
        // male icon
        var maleIconImage = FAKFontAwesome.marsIcon(withSize: 28).image(with: CGSize(width: 40, height: 40))
        maleIconImage = maleIconImage?.imageWithColor(color: Commons.myColor)
        btnMale.setImage(maleIconImage, for: .normal)
        
        
        // female icon
        var femaleIconImage = FAKFontAwesome.venusIcon(withSize: 28).image(with: CGSize(width: 40, height: 40))
        femaleIconImage = femaleIconImage?.imageWithColor(color: Commons.myColor)
        btnFemale.setImage(femaleIconImage, for: .normal)
        
        
        
        
    }

    
    func selectBtn(_ sender:UIButton, status:Bool) {
        
        if status {
            sender.backgroundColor = Commons.myGrayColor
            sender.setTitleColor(Commons.myColor, for: .normal)
        } else {
            sender.backgroundColor = UIColor.groupTableViewBackground
            sender.setTitleColor(UIColor.lightGray, for: .normal)
        }
        
    }
    
    func savePrice(price:Double) {
        
        self.client.clientVisits[selectedVisitIndex].price = price
        
        let selectedVisit = self.client.clientVisits[selectedVisitIndex]

        self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + selectedVisit.visitDate + "/price").setValue(price)
        
    }
    
    
    
    @IBAction func btnPrice1Clicked(_ sender: UIButton) {
        
        
        let btnText = sender.titleLabel?.text?.lowercased().replacingOccurrences(of: "$", with: "")
        
        
        if price1Selected {
            
            price1Selected = false
            selectBtn(btnPrice1, status: false)
            savePrice(price: 0)
            
        } else {
            
            price1Selected = true
            price2Selected = false
            price3Selected = false
            
            selectBtn(btnPrice1, status: true)
            selectBtn(btnPrice2, status: false)
            selectBtn(btnPrice3, status: false)
            txfPrice.text = ""
            
            savePrice(price: Double(btnText!)!)
        }
        
    }
    
    @IBAction func btnPrice2Clicked(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased().replacingOccurrences(of: "$", with: "")
        
        
        if price2Selected {
            
            price2Selected = false
            selectBtn(btnPrice2, status: false)
            savePrice(price: 0)
            
        } else {
            
            price1Selected = false
            price2Selected = true
            price3Selected = false
            
            selectBtn(btnPrice1, status: false)
            selectBtn(btnPrice2, status: true)
            selectBtn(btnPrice3, status: false)
            txfPrice.text = ""
            
            savePrice(price: Double(btnText!)!)
        }
    }
    
    
    @IBAction func btnPrice3Clicked(_ sender: UIButton) {
        
        let btnText = sender.titleLabel?.text?.lowercased().replacingOccurrences(of: "$", with: "")
        
        
        if price3Selected {
            
            price3Selected = false
            selectBtn(btnPrice3, status: false)
            savePrice(price: 0)
            
        } else {
            
            price1Selected = false
            price2Selected = false
            price3Selected = true
            
            selectBtn(btnPrice1, status: false)
            selectBtn(btnPrice2, status: false)
            selectBtn(btnPrice3, status: true)
            txfPrice.text = ""
            
            savePrice(price: Double(btnText!)!)
        }
    }
    
    @IBAction func priceChanged(_ sender: UITextField) {
        
        
        guard let price = txfPrice.text?.replacingOccurrences(of: "$", with: "")
            else {
                return
        }
        
        price1Selected = false
        price2Selected = false
        price3Selected = false
        
        selectBtn(btnPrice1, status: false)
        selectBtn(btnPrice2, status: false)
        selectBtn(btnPrice3, status: false)
        
        if price == "" {
            txfPrice.text = ""
        }
        else {
            txfPrice.text = "$" + price
        }
        
        let priceDouble = Double(price) ?? 0
        savePrice(price: priceDouble)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.client.clientVisits[selectedVisitIndex].images.count
    }
    
    let upgradeSectionIndex = 1
    let upgradeRowIndex = 0
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIScreen.main.bounds.width * 0.66
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        {
            let imgobj = self.client.clientVisits[selectedVisitIndex].images[indexPath.row]
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.gray)
            
            imageView.sd_setImage(with: URL(string: imgobj.imageUrl), completed: { (img, err, ct, url) in
                
            })
            
            
            
            
            // create radiant effect
            let bottomGradientLayer = CAGradientLayer()
            
            let bottomLine = cell.viewWithTag(3)!
            
            // 1
            bottomLine.backgroundColor = UIColor.black
            
            // 2
            bottomGradientLayer.frame = bottomLine.bounds
            
            // 3
            let color1 = UIColor.black.cgColor
            let color2 = UIColor.darkGray.cgColor
            let color3 = UIColor.lightGray.cgColor
            
            bottomGradientLayer.colors = [color3, color2, color1]
            
            // 4
            bottomGradientLayer.locations = [0.1, 0.5, 1]
            
            // 5
            bottomLine.layer.addSublayer(bottomGradientLayer)

            
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // share button
        
        let share = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Share") { action, index in
            
            let imageView = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as! UIImageView
            let image = imageView.image
            
            InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: image!, instagramCaption: "Posted from Prossimo", view: self.view)
            
        }
        
        
        
        
        
        
        
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            
            
            // get an instance of the image to be deleted
            let imageToBeDeleted = self.client.clientVisits[self.selectedVisitIndex].images[indexPath.row] as ImageObject
            
            
            self.ref = FIRDatabase.database().reference()
            
            // delete from firebase database, with completion block
            
            self.ref.child("users/" + self.userId + "/clients/" + self.client.clientId + "/visits/" + self.client.clientVisits[self.selectedVisitIndex].visitDate + "/images/" + imageToBeDeleted.imageName).removeValue { (err, ref) in
                
                self.client.clientVisits[self.selectedVisitIndex].images.remove(at: indexPath.row)
                
                
                self.tableView.reloadData()
                
                // delete from firebase
                let storageRef = FIRStorage.storage().reference().child(self.userId + "/clients/" + self.client.clientId + "/visits/" + self.client.clientVisits[self.selectedVisitIndex].visitDate + "/images/" + imageToBeDeleted.imageName)
                
                
                storageRef.delete { (err) in
                    
                    if err != nil {
                        print("received an error: " + (err?.localizedDescription)!)
                    }
                }
            }
        }
        
        return [delete, share]
    }
    
    
    // this function must be implemented in order for the swipe options to work
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
         if segue.identifier == "moreSegue1" {
            
            // set the userId
            if let destination = segue.destination as? OptionsView {
                
                destination.userId = self.userId
                destination.client = self.client
                destination.selectedVisitIndex = self.selectedVisitIndex

            }
        }
    }
    

    
    var photos = [ExamplePhoto]()
    var images = [UIImage]()
    
    var tappedImageIndex:Int!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _ = tableView.cellForRow(at: indexPath) {
            
            self.tappedImageIndex = indexPath.row
    
            
            // empty and refill the images array
            self.images = [UIImage]()
            
            for i in self.client.clientVisits[selectedVisitIndex].images {
                
                let imgView = UIImageView()
                
                imgView.sd_setImage(with: URL(string: i.imageUrl))
                self.images.append(imgView.image!)
            }
            
            
            // create a photo provider, it will give us an array of ExamplePhoto
            let photosProvider = PhotosProvider(images: self.images)
            self.photos = photosProvider.getPhotos()
            
            
            // create a photos view controller, and set the initial photo to the tapped one
            let photosViewController = NYTPhotosViewController(photos: self.photos, initialPhoto: self.photos[indexPath.row])
            
            
            present(photosViewController, animated: true, completion: nil)
            
            updateImagesOnPhotosViewController(photosViewController: photosViewController, afterDelayWithPhotos: photos)
            
            
        }
    }
    
    var count = 0
    func updateImagesOnPhotosViewController(photosViewController: NYTPhotosViewController, afterDelayWithPhotos: [ExamplePhoto]) {
        
        count = 0
        let deadlineTime = DispatchTime.now() + .seconds(0)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            
            for photo in self.photos {
                
                print(String(self.count))
                
                
                if photo.image == nil {
                    
                    photo.image = self.images[self.count]
                    photosViewController.updateImage(for: photo)
                }
                
                self.count = self.count + 1
            }
        }
    }
    
    func loadVisit() {
        // set notes, star and title
        self.txvNotes.text = self.client.clientVisits[selectedVisitIndex].notes
        setStarIcon(selected: self.client.clientVisits[selectedVisitIndex].starred)
        self.title = Commons.getHumanReadableDate(dateString: self.client.clientVisits[selectedVisitIndex].visitDate)
        
        
        let priceDouble = self.client.clientVisits[selectedVisitIndex].price
        
        
        switch priceDouble {
        case 25:
            price1Selected = true
            selectBtn(btnPrice1, status: true)
            break
            
        case 30:
            price2Selected = true
            selectBtn(btnPrice2, status: true)
            break
            
        case 40:
            price3Selected = true
            selectBtn(btnPrice3, status: true)
            break
            
        default:
            if priceDouble != 0 {
                self.txfPrice.text = "$" + String(priceDouble)
            }
            break
        }
    }
    
    
    func save() {
        
        let notes = txvNotes.text ?? ""
        
        let selectedVisit = self.client.clientVisits[selectedVisitIndex]
        
        self.client.clientVisits[selectedVisitIndex].notes = notes
        self.ref.child("users/" + userId + "/clients/" + self.client.clientId + "/visits/" + selectedVisit.visitDate + "/notes").setValue(notes)
            
        if let del = self.delegate {
            del.historyChanged(client: self.client)
        }
    }
    
    
    @IBAction func cameraClick(_ sender: UIBarButtonItem) {
        
        displayImageAlert()
        
    }
    
    func displayImageAlert() {
        
        let image = UIImagePickerController()
        image.allowsEditing = true
        image.delegate = self
        
        
        
        let imageAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        imageAlert.addAction(UIAlertAction(title: "Take a New Photo", style: .default, handler: { (action: UIAlertAction!) in
            
            image.sourceType = UIImagePickerControllerSourceType.camera
            self.present(image, animated: true)
            
        }))
        
        imageAlert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction!) in
            
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(image, animated: true)
            
        }))
        
        
        
        imageAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(imageAlert, animated: true, completion: nil)
    }
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        

        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            // get the visit date
            let visitdate = self.client.clientVisits[selectedVisitIndex].visitDate
            
            // compress the image
            let compressedImageData = UIImageJPEGRepresentation(image, 0)
            
            uploadImageToFirebase(data: compressedImageData!, path: "users/" + userId + "/clients/" + self.client.clientId + "/visits/" + visitdate + "/images/", fileName: UUID().uuidString)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func starClicked(_ sender: UIBarButtonItem) {
        
        //flip it
        self.client.clientVisits[selectedVisitIndex].starred = !self.client.clientVisits[selectedVisitIndex].starred
        setStarIcon(selected: self.client.clientVisits[selectedVisitIndex].starred)
        
        let selectedVisit = self.client.clientVisits[selectedVisitIndex]

        self.ref.child("users/" + userId + "/clients/" + self.client.clientId + "/visits/" + selectedVisit.visitDate + "/starred").setValue(self.client.clientVisits[selectedVisitIndex].starred)
        
        if let del = self.delegate {
            del.historyChanged(client: self.client)
        }
    }
    
    
    func uploadImageToFirebase(data: Data, path: String, fileName: String) {
        
        // get storage service reference
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        storageRef.put(data, metadata: nil) { (metadata, err) in
            
            if err != nil {
                print("received an error: " + (err?.localizedDescription)!)

            }
            else {
                guard metadata != nil else {
                    print("error occurred")
                    return
                }
                
                let imgobj = ImageObject()
                imgobj.imageName = fileName
                imgobj.imageUrl = (metadata?.downloadURL()?.absoluteString)!
                imgobj.uploadDate = String(Date().timeIntervalSince1970)
                
                self.client.clientVisits[self.selectedVisitIndex].images.append(imgobj)
                
                
                self.ref.child(path + imgobj.imageName + "/imageUrl").setValue(imgobj.imageUrl)
                self.ref.child(path + imgobj.imageName + "/uploadDate").setValue(imgobj.uploadDate)
                    
                self.client.clientVisits[self.selectedVisitIndex].images.sort { $0.uploadDate > $1.uploadDate }
                
                
                self.tableView.reloadData()
                
                if let del = self.delegate {
                    del.historyChanged(client: self.client)
                }
                

            }
        }
    }
    
    
    func deleteImageFromFirebase(path: String, fileName: String) {
        
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        
        storageRef.delete { (err) in
            
            if err != nil {
                print("received an error: " + (err?.localizedDescription)!)
            }
            
        }
    }

    
}


protocol PictureTimeDelegate {
    func historyChanged(client: Client)
}

