//
//  AppDelegate.swift
//  Monique
//
//  Created by Elrifai, Rawad on 2/19/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//
//import Firebase
import UIKit
import Google
import GoogleSignIn
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        FIRApp.configure()

        Fabric.with([Crashlytics.self])
        CleverTap.autoIntegrate()
        
        StoreManager.shared.setup()
        IQKeyboardManager.sharedManager().enable = true
        
        UITabBar.appearance().tintColor = Commons.myColor
        
        
        return true
    }
    
    // for redirecting after signing in back to the app
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

                return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    // open url for 9.0 and before
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
  
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
       // let urlString = url.absoluteString
        
        
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "loginSB") as? UINavigationController
            self.window?.rootViewController?.present(loginVC!, animated: true, completion: nil)
        
        
        return true
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            
            print("\(error.localizedDescription)")
            return
            
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("disconnected with user")
    }
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

