//
//  ExpenseDetailsTVC.swift
//  Prossimo
//
//  Created by Rawad Rifai on 6/3/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FontAwesomeKit
import FirebaseStorage

class ExpenseDetailsTVC: UITableViewController {

    var userId:String!
    var expense:Expense!
    var ref: FIRDatabaseReference!
    var delegate: ExpenseDetailsDelegate?
    
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var txfItem: UITextField!
    @IBOutlet weak var txfPrice: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var imageViewUp: UIImageView!
    
    @IBOutlet weak var imageViewDown: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setIcons()
        loadExpense()
    }
    
    func setIcons() {
        
        var cameraIconImage = FAKFontAwesome.cameraIcon(withSize: 35).image(with: CGSize(width: 40, height: 40))
        cameraIconImage = cameraIconImage?.imageWithColor(color: UIColor.black)
        btnCamera.setImage(cameraIconImage, for: .normal)
        
        var upIconImage = FAKFontAwesome.angleUpIcon(withSize: 12).image(with: CGSize(width: 12, height: 12))
        upIconImage = upIconImage?.imageWithColor(color: UIColor.black)
        imageViewUp.image = upIconImage

        
        var downIconImage = FAKFontAwesome.angleDownIcon(withSize: 12).image(with: CGSize(width: 12, height: 12))
        downIconImage = downIconImage?.imageWithColor(color: UIColor.black)
        imageViewDown.image = downIconImage

    }
    
    func loadExpense() {
        
        txfItem.text = expense.item
        txfPrice.text = String(expense.price)
        
        
        // get date and convert from string to date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: expense.date)!
        datePicker.date = date
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return expense.receipts.count
    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIScreen.main.bounds.width * 0.66
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        {
            let receipt = expense.receipts[indexPath.row]
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.gray)
            
            imageView.sd_setImage(with: URL(string: receipt.imageUrl), completed: { (img, err, ct, url) in
                
            })
            
            
            
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            
            
            // get an instance of the image to be deleted
            let receiptToBeDeleted = self.expense.receipts[indexPath.row]
            
            
            self.ref = FIRDatabase.database().reference()
            
            // delete from firebase database, with completion block
            
            self.ref.child("users/" + self.userId + "/expenses/" + self.expense.id).removeValue { (err, ref) in
                
                self.expense.receipts.remove(at: indexPath.row)
                
                
                self.tableView.reloadData()
                
                // delete from firebase
                let storageRef = FIRStorage.storage().reference().child("users/" + self.userId + "/expenses/" + self.expense.id + receiptToBeDeleted.id)
                
                
                storageRef.delete { (err) in
                    
                    if err != nil {
                        print("received an error: " + (err?.localizedDescription)!)
                    }
                }
            }
        }
        
        return [delete]
    }
    
    
    // this function must be implemented in order for the swipe options to work
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { }
    
    
    @IBAction func btnCameraClick(_ sender: UIButton) {
        
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
    
    
    
    func uploadImageToFirebase(data: Data, path: String, fileName: String) {
        
        // get storage service reference
        let storageRef = FIRStorage.storage().reference(withPath: path + fileName)
        storageRef.put(data, metadata: nil) { (metadata, err) in
            
            if err != nil {
                print("received an error: " + (err?.localizedDescription)!)
                return
            }
            
                guard metadata != nil else {
                    print("error occurred")
                    return
                }
                
                let receipt = Receipt()
                receipt.id = fileName
                receipt.imageUrl = (metadata?.downloadURL()?.absoluteString)!
                receipt.uploadDate = String(Date().timeIntervalSince1970)
                
                self.expense.receipts.append(receipt)
                
                
                self.ref.child(path + receipt.id + "/imageUrl").setValue(receipt.imageUrl)
                self.ref.child(path + receipt.id + "/uploadDate").setValue(receipt.uploadDate)
                
                self.expense.receipts.sort { $0.uploadDate > $1.uploadDate }
                
                
                self.tableView.reloadData()
                
                if let del = self.delegate {
                    del.expenseChanged()
                }
                
        }
    }
    
}

extension ExpenseDetailsTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
     
            // compress the image
            let compressedImageData = UIImageJPEGRepresentation(image, 0)
            
            uploadImageToFirebase(data: compressedImageData!, path: "users/" + userId + "/expenses/" + expense.id + "/", fileName: UUID().uuidString)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

protocol ExpenseDetailsDelegate {
    func expenseChanged()
}
