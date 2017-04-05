//
//  ViewController.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/4/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: OAuthWebViewController, UIWebViewDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // var url = URL(string: "https://api.instagram.com/oauth/authorize/?client_id=c3cddf7f471640aca019d4bae0373c88&redirect_uri=https://rawadrifai.wixsite.com/prossimo&response_type=token")
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        authorize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var webview: UIWebView!
    
  ///  func handle(_ url: URL) {
        
       // let req = URLRequest(url: url)
       // self.webview.loadRequest(req)
    //}
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let url = request.url?.absoluteString {
            
            
            if url.contains("access_token") {
                
                print(url)
                let fragment = request.url?.fragment!
                
                let index = fragment?.index((fragment?.startIndex)!, offsetBy: 13)
                print(fragment?.substring(from: index!))

            }
        }
        
        return true
    }
    
    
    
    func authorize() {
        
        let oauthswift = OAuth2Swift(
            consumerKey:    "c3cddf7f471640aca019d4bae0373c88",
            consumerSecret: "6511502886404bdd8ac4e62766a3357a",
            authorizeUrl:   "https://api.instagram.com/oauth/authorize",
            responseType:   "token"
        )
        
        
        
//        oauthswift.authorizeURLHandler = self
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        
        let handle = oauthswift.authorize(
            withCallbackURL: URL(string: "https://rawadrifai.wixsite.com/prossimo")!,
            scope: "likes+comments", state:"INSTAGRAM",
            success: { credential, response, parameters in
                print(credential.oauthToken)
        },
            failure: { error in
                print(error.localizedDescription)
        }
        )
    }
    
    func makeRestCall()
    {
        
        
//        var url : String = "http://google.com?test=toto&test2=titi"
//        var request : NSMutableURLRequest = NSMutableURLRequest()
//        request.URL = NSURL(string: url)
//        request.HTTPMethod = "GET"
//        
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
//            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
//            
//            if (jsonResult != nil) {
//                // process jsonResult
//            } else {
//                // couldn't load JSON, look at error
//            }
//            
//            
//        })
//        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
