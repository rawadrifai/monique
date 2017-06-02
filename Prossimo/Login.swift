
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import Google
import Fabric
import Crashlytics
import LocalAuthentication


class Login: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    var userId:String!
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    
    
    
    func logUserInCrashlytics(userEmail:String, userIdentifier:String, userName:String) {
        
        Crashlytics.sharedInstance().setUserEmail(userEmail)
        Crashlytics.sharedInstance().setUserIdentifier(userIdentifier)
        Crashlytics.sharedInstance().setUserName(userName)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animateIndicator(animate: false)
        customizeSignInBtns()
        
        
        self.ref = FIRDatabase.database().reference()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        checkForLatestVersion()
        checkIfFirstTimeUse()
        checkIfAlreadySignedIn()

    }
    
    func customizeSignInBtns() {
        
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInButton.style = .iconOnly
        
        btnSignIn.layer.cornerRadius = 10
        btnSignIn.layer.borderColor = UIColor.lightGray.cgColor
        btnSignIn.layer.borderWidth = 1
        btnSignIn.clipsToBounds = true
    }
    
    
    func checkIfAlreadySignedIn() {
        
        
        // get last logged in user
        guard let loggedInUser = UserDefaults.standard.value(forKey: "loggedInUser") as? String else {
            return
        }
        
        self.lockButtons(lock: true)
        self.animateIndicator(animate: true)
    
        self.userId = loggedInUser
        
        // store crashlytics user before signing in
        
        self.ref.child("users/" + self.userId + "/email").observeSingleEvent(of: .value, with: {
            Crashlytics.sharedInstance().setUserEmail($0.value as? String)
            
            // register email in firebase
            self.ref.child("emails/" + self.userId).setValue($0.value as? String)

        })
        
        self.ref.child("users/" + self.userId + "/name").observeSingleEvent(of: .value, with: {
            Crashlytics.sharedInstance().setUserName($0.value as? String)
        })
        
        
        
        self.performSegue(withIdentifier: "loginSegue", sender: self)
        
        
        
    }
    
    // display tutorial if first time use
    
    func checkIfFirstTimeUse() {
        
      //  UserDefaults.standard.removeObject(forKey: "prossimoLastVersionUsed")
        
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        
        
        guard let lastVersionUsed = UserDefaults.standard.string(forKey: "prossimoLastVersionUsed")
            else {
                UserDefaults.standard.set(version, forKey: "prossimoLastVersionUsed")
                self.performSegue(withIdentifier: "tutorialSegue", sender: self)
                return
        }
        
//        if let lastVersionUsed = UserDefaults.standard.string(forKey: "prossimoLastVersionUsed")
//        {
//            UserDefaults.standard.set(version, forKey: "prossimoLastVersionUsed")
        
            if version != lastVersionUsed {
                
                UserDefaults.standard.set(version, forKey: "prossimoLastVersionUsed")
                self.performSegue(withIdentifier: "tutorialSegue", sender: self)
            }
//        } else {
//            self.performSegue(withIdentifier: "tutorialSegue", sender: self)
//
//        }
        
        
        
    }
    
    
    // check for latest version and prompt for upgrade if necessary
    
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
                        
                        self.displayImportUpdateAlert()
                        self.displayVersionAlert()
                    }
                    
                }
            })
            
        }))
        
        present(versionAlert, animated: true, completion: nil)
    }
    
    func displayImportUpdateAlert() {
        
        let alert = UIAlertController(title: "This is an important update", message: "Please download the updates", preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            
            // do nothing
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func GIDClicked(_ sender: GIDSignInButton) {
        
        print("gid clicked")
        
        // start animating indicator
        self.animateIndicator(animate: true)
        self.lockButtons(lock: true)
    }
    
    // what to do when you sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if error != nil {
            print("\(error.localizedDescription)")
            return
            
        }
        
        // prepare user id for firebase
        self.userId = user.profile.email.replacingOccurrences(of: ".", with: "")
        
        // log crashlytics users
        self.logUserInCrashlytics(userEmail: user.profile.email, userIdentifier: self.userId, userName: user.profile.name)
        
        
        // this is to authenticate with firebase
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (u, e) in
            
            
            if e != nil {
                print("\(String(describing: e?.localizedDescription))")
                return
            }
            
            
            
            
            // update profile info in firebase
            
            self.userId = user.profile.email.replacingOccurrences(of: ".", with: "")
            
            self.ref.child("users/" + self.userId + "/name").setValue(user.profile.name)
            self.ref.child("users/" + self.userId + "/email").setValue(user.profile.email)
            
            // register email in emails table
            self.ref.child("emails/" + self.userId).setValue(user.profile.email)

            self.performSegue(withIdentifier: "loginSegue", sender: self)
            
        })
    }
    
    // when the user disconnects from the app
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        
        print("Lost connection with user")
        
    }
    
    func signInFirebase(uid:String) {
        
        self.ref.child("users/" + uid + "/deviceId").observeSingleEvent(of: .value, with: {
            
            if let value = $0.value {
                if String(describing: value) == uid {
                    
                    // store crashlytics user before signing in
                    
                    self.ref.child("users/" + uid + "/email").observeSingleEvent(of: .value, with: {
                        Crashlytics.sharedInstance().setUserEmail($0.value as? String)
                        
                        // register email in emails table
                        self.ref.child("emails/" + uid).setValue($0.value as? String)

                    })
                    
                    self.ref.child("users/" + uid + "/name").observeSingleEvent(of: .value, with: {
                        Crashlytics.sharedInstance().setUserName($0.value as? String)
                    })
                    
                    
                    
                    // logged in
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
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
    
    
    func lockButtons(lock: Bool) {
        
        if lock {
            
            self.btnSignIn.isEnabled = false
            self.btnSignIn.setTitleColor(UIColor.darkGray, for: .normal)
            
            
            self.signInButton.isEnabled = false
            


        } else {

            self.btnSignIn.isEnabled = true
            self.btnSignIn.setTitleColor(UIColor.lightGray, for: .normal)
            
            
            self.signInButton.isEnabled = true
            

        }
        
    }
    
    func animateIndicator(animate: Bool) {
        
        if animate {

            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        } else {

            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    
    }
    
    @IBAction func signInUsignDeviceId(_ sender: UIButton) {
        
        // start animating indicator
        self.animateIndicator(animate: true)
        self.lockButtons(lock: true)
        
        
        self.userId = KeychainManager.sharedInstance.getDeviceIdentifierFromKeychain()
        
        Crashlytics.sharedInstance().setUserIdentifier(self.userId)
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            
            if error != nil {
                return
            }
            

            self.signInFirebase(uid: self.userId)
        })
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // stop animating indicator
        self.animateIndicator(animate: false)
        self.lockButtons(lock: false)
        
        if segue.identifier == "loginSegue" {
            
            // set the userId
            if let destinationTabBar = segue.destination as? UITabBarController {
                
                if let destinationNavigation = destinationTabBar.viewControllers!.first as? UINavigationController {
                    if let destinationClientsView = destinationNavigation.topViewController as? ClientsView {
                        destinationClientsView.userId = self.userId
                    }
                }
                
                if let d = destinationTabBar.viewControllers![1] as? UINavigationController {
                    if let infoView = d.topViewController as? InfoView {
                        infoView.userId = self.userId
                    }
                }
            }
            
            // log the user to the device, so that next time no log in will be required
            UserDefaults.standard.set(self.userId, forKey: "loggedInUser")
            
            CleverTapManager.shared.registerEvent(eventName: "Sign In")
            

            
        } else if segue.identifier == "saveUserInfoSegue" {
            
            // set the userId
            let destinationViewController = segue.destination
            
            
            if let destinationView = destinationViewController as? SaveUserInfo {
                destinationView.userId = self.userId
            }
        }
        
    }
}
