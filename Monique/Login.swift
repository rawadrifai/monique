
import UIKit
import Firebase
import GoogleSignIn
import Google


class Login: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    var userId:String!
    
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
        
        
    
    }
    
    
    
    // what to do when you sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
            
        } else {
            
            // print logged in email
            print("signed in as: ", user.profile.email ?? "no email address")
            
            // set the logged in user for the whole session
            //UserDefaults.standard.set(user.profile.email, forKey: "userid")
            userId = user.profile.email.replacingOccurrences(of: ".", with: "")
            
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            
            
        }
    }
    
    // when the user disconnects from the app
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        
        print("Lost connection with user")
        
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
    @IBOutlet weak var signOutButton: UIButton!
    
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
        signOutButton.isEnabled = false
    }
    
}
