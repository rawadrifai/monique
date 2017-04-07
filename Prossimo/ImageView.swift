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
        makeProfilePicInteractive()
        imgView.sd_setImage(with: URL(string: image.imageUrl))
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    func makeProfilePicInteractive() {
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 4.0
        
//        let x = UISwipeGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        // make the profile picture interactive
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
          imgView.isUserInteractionEnabled = true
          imgView.addGestureRecognizer(tapGestureRecognizer)
        
        
        
//        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        self.view.addGestureRecognizer(swipeRight)
//        
//        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
//        swipeDown.direction = UISwipeGestureRecognizerDirection.down
//        self.view.addGestureRecognizer(swipeDown)
        
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: false) {}
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                self.dismiss(animated: false) {}
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
}
