//
//  ViewController.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/3/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.loadRequest(URLRequest(url: URL(string: "https://api.instagram.com/oauth/authorize/?client_id=de40e77d036c46b8a5521a76b193a55d&redirect_uri=http://www.clover-studio.com/&response_type=code")!))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var webView: UIWebView!

}
