//
//  InstagramManager.swift
//  Prossimo
//
//  Created by Elrifai, Rawad on 4/3/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import Foundation
import UIKit


class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let kInstagramURL = "instagram://"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let documentInteractionController = UIDocumentInteractionController()

    
    // singleton manager
    class var sharedManager: InstagramManager {
        struct Singleton {
            static let instance = InstagramManager()
        }
        return Singleton.instance
    }

    
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) {
        

            let jpgPath = NSTemporaryDirectory().appending(kfileNameExtension)
            
            do {
                try UIImageJPEGRepresentation(imageInstagram, 1.0)?.write(to: URL(fileURLWithPath: jpgPath))
            }
            catch {
                print("exception happened")
            }
            
            let rect = CGRect.zero
            let fileURL = URL.init(fileURLWithPath: jpgPath)
            
            
            
            documentInteractionController.url = fileURL
            documentInteractionController.delegate = self
            documentInteractionController.uti = kUTI
            
            // adding caption for the image
            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
            documentInteractionController.presentOpenInMenu(from: rect, in: view, animated: true)

    }
}
