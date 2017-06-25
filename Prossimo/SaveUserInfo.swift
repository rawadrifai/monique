import UIKit
import Firebase
import Google
import Fabric
import Crashlytics

extension SaveUserInfo: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 12 // Bool
    }
}

class SaveUserInfo: UIViewController {

    var ref: FIRDatabaseReference!
    var userId:String = ""
    
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txfBusinessPhone: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        self.txfPhone.delegate = self
        self.txfBusinessPhone.delegate = self
        setBorders()
    }
    
    func setBorders() {
        self.txfName.layer.cornerRadius = 7
        self.txfName.clipsToBounds = true
        self.txfName.layer.borderColor = UIColor.lightGray.cgColor
        self.txfName.layer.borderWidth=1
        
        self.txfPhone.layer.cornerRadius = 7
        self.txfPhone.clipsToBounds = true
        self.txfPhone.layer.borderColor = UIColor.lightGray.cgColor
        self.txfPhone.layer.borderWidth=1
        
        self.txfBusinessPhone.layer.cornerRadius = 7
        self.txfBusinessPhone.clipsToBounds = true
        self.txfBusinessPhone.layer.borderColor = UIColor.lightGray.cgColor
        self.txfBusinessPhone.layer.borderWidth=1
        
        self.txfEmail.layer.cornerRadius = 7
        self.txfEmail.clipsToBounds = true
        self.txfEmail.layer.borderColor = UIColor.lightGray.cgColor
        self.txfEmail.layer.borderWidth=1
        
        self.btnSave.layer.cornerRadius = 7
        self.btnSave.clipsToBounds = true
        self.btnSave.clipsToBounds = true
    }
    
    var tmpPhone=""
    
    @IBAction func txfPhoneEditingChanged(_ sender: UITextField) {
        
        if let phone = txfPhone.text {
            
            if (phone.characters.count > tmpPhone.characters.count) {
                
                if (phone.characters.count) == 3 {
                    
                    txfPhone.text = phone + "-"
                } else
                    if (phone.characters.count) == 7 {
                        
                        txfPhone.text = phone + "-"
                }
            }
            tmpPhone = txfPhone.text!
        }
        
    }
    
    var tmpBusinessPhone = ""
    
    @IBAction func txfBusinessPhoneEditingChanged(_ sender: UITextField) {
        
        if let businessPhone = txfBusinessPhone.text {
            
            if (businessPhone.characters.count > tmpBusinessPhone.characters.count) {
                
                if (businessPhone.characters.count) == 3 {
                    
                    txfBusinessPhone.text = businessPhone + "-"
                } else
                    if (businessPhone.characters.count) == 7 {
                        
                        txfBusinessPhone.text = businessPhone + "-"
                }
            }
            tmpBusinessPhone = txfBusinessPhone.text!
        }
    }
    
    
    
    @IBAction func signInWithDeviceId(_ sender: UIButton) {
        
        if validateInput() {
            
            
            
            var user = [String:String]()
            user["deviceId"] = self.userId
            user["name"] = txfName.text!
            user["phone"] = txfPhone.text!
            user["businessphone"] = txfBusinessPhone.text!
            user["email"] = txfEmail.text!
            
            self.ref.child("users").child(self.userId).setValue(user) { (err, ref) in

                // store crashlytics user info before signing in
                
                Crashlytics.sharedInstance().setUserIdentifier(user["deviceId"])
                Crashlytics.sharedInstance().setUserName(user["name"])
                Crashlytics.sharedInstance().setUserEmail(user["email"])
                
                // store clevertap info
                
                let profile: Dictionary<String, AnyObject> = [
                    "Name": user["name"] as AnyObject,                 // String
                    "Identity": self.userId as AnyObject,                   // String or number
                    "Email": user["email"] as AnyObject,              // Email address of the user
                    "Phone": user["phone"] as AnyObject,                // Phone (with the country code, starting with +)
                                       // optional fields. controls whether the user will be sent email, push etc.
                    
                    "MSG-push": true as AnyObject,                       // Enable push notifications
                    "MSG-sms": true as AnyObject                        // Disable SMS notifications
                ]
                
                CleverTap.sharedInstance()?.profilePush(profile)
                CleverTapManager.shared.registerEvent(eventName: "Sign Up")

                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
        
    }
    
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    
    func validateInput() -> Bool {
        
        let clientName = txfName.text ?? ""
        let clientEmail = txfEmail.text ?? ""
        
        // validate input
        if (clientName.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            alert(message: "Invalid Name")
            return false
        }
        if (!isValidEmail(testStr: clientEmail)) {
            alert(message: "Invalid Email")
            return false
        }

        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            
            // set the userId
            if let destinationTabBar = segue.destination as? UITabBarController {
                
                
                
                if let destinationNavigation = destinationTabBar.viewControllers!.first as? UINavigationController {
                    if let destinationClientsView = destinationNavigation.topViewController as? ClientsView {
                        destinationClientsView.userId = self.userId
                    }
                }
                
                if let moneyNavigation = destinationTabBar.viewControllers![1] as? UINavigationController {
                    if let moneyView = moneyNavigation.topViewController as? ExpensesTVC {
                        moneyView.userId = self.userId
                    }
                }
                
                if let d = destinationTabBar.viewControllers![2] as? UINavigationController {
                    if let infoView = d.topViewController as? InfoView {
                        infoView.userId = self.userId
                    }
                }
            }
        }
    }
    
    
    
    func alert(message output:String) {
        let alert = UIAlertController(title: "Invalid Input", message: output, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
