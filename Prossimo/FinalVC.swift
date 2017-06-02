//
//  SixthVC.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/22/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit

class FinalVC: UIViewController {

    
    @IBOutlet weak var btnGetStarted: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnGetStarted.layer.borderWidth = 1
        btnGetStarted.layer.cornerRadius = 7
        btnGetStarted.clipsToBounds = true
    }

   
}
