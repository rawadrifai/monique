//
//  FourthController.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/19/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit

class FourthVC: UIViewController {

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
    }



}
