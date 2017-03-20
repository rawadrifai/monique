
import UIKit
import Firebase
import GoogleSignIn
import Google


class Login: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    var userId:String!
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInButton.style = .wide
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()
    
    }
    
    
    
    // what to do when you sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
            
        } else {
            
            // print logged in email
            print("signed in as: ", user.profile.email ?? "no email address")

            self.userId = user.profile.email.replacingOccurrences(of: ".", with: "")
            
            self.ref.child(self.userId + "/name").setValue(user.profile.name)
            self.ref.child(self.userId + "/email").setValue(user.profile.email)
           
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            
            
        }
    }
    
    // when the user disconnects from the app
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        
        print("Lost connection with user")
        
    }
    
    
    @IBAction func signInUsignDeviceId(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        if let loggedInBefore = defaults.string(forKey: "loggedInBefore") {
            
            if loggedInBefore == "true" {
                self.userId = UIDevice.current.identifierForVendor!.uuidString
                self.ref.child(self.userId + "/deviceId").setValue(self.userId)
            
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
            else {
                defaults.setValue(nil, forKey: "loggedInBefore")
                showFields(visible: true)
            }
            
        } else {

            
            if labelEmail.isHidden {
                showFields(visible: true)
            }
            else {
                
                if validateInput() {
                    
                    self.userId = UIDevice.current.identifierForVendor!.uuidString
                    self.ref.child(self.userId + "/deviceId").setValue(self.userId)
                    self.ref.child(self.userId + "/name").setValue(txfName.text!)
                    self.ref.child(self.userId + "/email").setValue(txfEmail!)
                    self.ref.child(self.userId + "/phone").setValue(txfPhone!)
                    
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
                
            }
            defaults.setValue("true", forKey: "loggedInBefore")
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
    
    @IBOutlet weak var signInButton: GIDSignInButton!

    
    
    @IBAction func signOutClick(_ sender: UIButton)
    
    {
        let firebaseAuth = FIRAuth.auth()
        
        do {
            try firebaseAuth?.signOut()
            print ("signed out successfully")
        } catch  {
            print("Error signing out")
            return
        }
        
        signInButton.isEnabled = true
       
    }
    
    func showFields(visible:Bool) {
        
        txfName.isHidden = !visible
        txfEmail.isHidden = !visible
        txfPhone.isHidden = !visible
    
        labelName.isHidden = !visible
        labelEmail.isHidden = !visible
        labelEmail.isHidden = !visible
        
    }
    
    func alert(message output:String) {
        let alert = UIAlertController(title: "Invalid Input", message: output, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetclicked(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.setValue("false", forKey: "loggedInBefore")

    }
}
