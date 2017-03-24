//
//  ImageView.swift
//  Monique
//
//  Created by Elrifai, Rawad on 3/23/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit

class ImageView: UIViewController, UIScrollViewDelegate {
    
    var image = ImageObject()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.sd_setImage(with: URL(string: image.imageUrl))
        makeProfilePicInteractive()
    }
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    func makeProfilePicInteractive() {
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 4.0
        
        // make the profile picture interactive
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
          imgView.isUserInteractionEnabled = true
          imgView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
}
