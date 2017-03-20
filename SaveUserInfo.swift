import UIKit
import Firebase
import Google


class SaveUserInfo: UIViewController {

    var ref: FIRDatabaseReference!
    var userId:String = ""
    
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        self.ref = FIRDatabase.database().reference()
    }

    @IBAction func signInWithDeviceId(_ sender: UIButton) {
        
        if validateInput() {
            
            let defaults = UserDefaults.standard
            
            let userId = UIDevice.current.identifierForVendor!.uuidString
            
            var user = [String:String]()
            user["deviceId"] = userId
            user["name"] = txfName.text!
            user["phone"] = txfPhone.text!
            user["email"] = txfEmail.text!
            
            self.ref.child(userId).setValue(user) { (err, ref) in
                defaults.setValue("true", forKey: "loggedInBefore")
            }

            self.userId = userId
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            
        }
        
        
        
        
    }
    

    
    func validateInput() -> Bool {
        
        let clientName = txfName.text ?? ""
        let clientPhone = txfPhone.text ?? ""
        let clientEmail = txfEmail.text ?? ""
        
        // validate input
        if (clientName.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            clientEmail.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            clientPhone.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            
            alert(message: "Please fill out your info once")
            return false
        }
        
        return true
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
            }
        }
    }
    
    
 
    @IBAction func cancel(_ sender: UIButton) {
        
        let _ = self.navigationController?.popViewController(animated: true)

    }
    
    
    func alert(message output:String) {
        let alert = UIAlertController(title: "Invalid Input", message: output, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
