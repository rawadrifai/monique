//
//  CrashController.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/10/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import Crashlytics


class CrashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func crashClick(_ sender: UIButton) {
         Crashlytics.sharedInstance().crash()
    }
    

}
