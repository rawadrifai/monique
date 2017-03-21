
import UIKit
import Firebase
import GoogleSignIn
import Google


class Login: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    var userId:String!
    var ref: FIRDatabaseReference!
    
  
    
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
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                
            }
            else {
                self.performSegue(withIdentifier: "saveUserInfoSegue", sender: self)
            }
            
        } else {
            self.performSegue(withIdentifier: "saveUserInfoSegue", sender: self)
        }
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
    
    
    
    @IBAction func resetclicked(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.setValue("false", forKey: "loggedInBefore")

    }
}
