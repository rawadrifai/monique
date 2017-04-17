
import UIKit
import Firebase
import GoogleSignIn
import Google
import Fabric
import Crashlytics
import LocalAuthentication

class Login: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    var userId:String!
    var ref: FIRDatabaseReference!


    func logUser(userEmail:String, userIdentifier:String, userName:String) {

        Crashlytics.sharedInstance().setUserEmail(userEmail)
        Crashlytics.sharedInstance().setUserIdentifier(userIdentifier)
        Crashlytics.sharedInstance().setUserName(userName)
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInButton.style = .iconOnly
        
        // get reference to database
        self.ref = FIRDatabase.database().reference()
        
        
        checkForLatestVersion()
        
        
        
    }
    
    func checkForLatestVersion() {
        
        self.ref.child("latestversion").observeSingleEvent(of: .value, with: {
            
            
            if let value = $0.value {
                
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                {
                    if version != String(describing: value) {
                        self.displayVersionAlert()
                    }
                }
            }
        })
    }
    
    func displayVersionAlert() {
        
        let versionAlert = UIAlertController(title: "New Version Available", message: "Please download the latest version", preferredStyle: UIAlertControllerStyle.alert)
        
        versionAlert.addAction(UIAlertAction(title: "Download", style: .default, handler: { (action: UIAlertAction!) in
            
            UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/us/app/prossimo-hair-stylist-assistant/id1220990527?ls=1&mt=8")!)
            
        }))
        
        versionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            
            
            self.ref.child("forceupdate").observeSingleEvent(of: .value, with: {
                
                
                if let value = $0.value {
                    
                    if "1" == String(describing: value) {
                        self.displayVersionAlert()
                    }
                    
                }
            })
            
            
            
        }))
        
        present(versionAlert, animated: true, completion: nil)
    }
    
    // what to do when you sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
            //print("\(error.localizedDescription)")
            
        } else {
            
            // print logged in email
            print("signed in as: ", user.profile.email ?? "no email address")
            
            self.userId = user.profile.email.replacingOccurrences(of: ".", with: "")
            
            self.ref.child("users/" + self.userId + "/name").setValue(user.profile.name)
            self.ref.child("users/" + self.userId + "/email").setValue(user.profile.email)
            
            // log crashlytics users
            self.logUser(userEmail: user.profile.email, userIdentifier: self.userId, userName: user.profile.name)
            
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            
            
        }
    }
    
    // when the user disconnects from the app
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        
        print("Lost connection with user")
        
    }
    
    var subscription:String!
    
    @IBAction func signInUsignDeviceId(_ sender: UIButton) {
        
        
        //self.userId = UIDevice.current.identifierForVendor!.uuidString
        self.userId = KeychainManager.sharedInstance.getDeviceIdentifierFromKeychain()
        
        Crashlytics.sharedInstance().setUserIdentifier(self.userId)
        
        self.ref.child("users/" + userId + "/deviceId").observeSingleEvent(of: .value, with: {
            
            if let value = $0.value {
                if String(describing: value) == self.userId {
                    
                    // store crashlytics user before signing in
                    
                    
                    
                    self.ref.child("users/" + self.userId + "/email").observeSingleEvent(of: .value, with: {
                        Crashlytics.sharedInstance().setUserEmail($0.value as? String)
                    })
                    
                    self.ref.child("users/" + self.userId + "/name").observeSingleEvent(of: .value, with: {
                        Crashlytics.sharedInstance().setUserName($0.value as? String)
                    })
                    
                    self.ref.child("users/" + self.userId + "/subscription/type").observeSingleEvent(of: .value, with: {
                        
                        if let val = $0.value as? String {
                            
                            print("subscription: " + val)
                            self.subscription = val
                            self.performSegue(withIdentifier: "loginSegue", sender: self)

                        }
                        else {
                            self.subscription="trial"
                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                        }
                        
                    })
                    

                    

                }
                else {
                    self.performSegue(withIdentifier: "saveUserInfoSegue", sender: self)
                }
            }
            else {
                self.performSegue(withIdentifier: "saveUserInfoSegue", sender: self)
            }
        })
        
        

        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            
            // set the userId
            if let destinationTabBar = segue.destination as? UITabBarController {
                
                if let destinationNavigation = destinationTabBar.viewControllers!.first as? UINavigationController {
                    if let destinationClientsView = destinationNavigation.topViewController as? ClientsView {
                        destinationClientsView.userId = self.userId
                        destinationClientsView.subscription = self.subscription
                    }
                }
                
                if let d = destinationTabBar.viewControllers![1] as? UINavigationController {
                    if let infoView = d.topViewController as? InfoView {
                        infoView.userId = self.userId
                        infoView.subscription = self.subscription
                    }
                }
            }
        } else if segue.identifier == "saveUserInfoSegue" {
            
            // set the userId
            if let destinationViewController = segue.destination as? UIViewController {
                
                
                if let destinationView = destinationViewController as? SaveUserInfo {
                    destinationView.userId = self.userId
                }
                
            }
        }
        
    }
}
