//
//  ExamplePhoto.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit
import NYTPhotoViewer

class ExamplePhoto: NSObject, NYTPhoto {

    var image: UIImage?
    var imageData: Data?
    var placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString?
    let attributedCaptionSummary: NSAttributedString? = NSAttributedString(string: "Prossimo (c)", attributes: [NSForegroundColorAttributeName: UIColor.gray])
    let attributedCaptionCredit: NSAttributedString? = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])

    init(image: UIImage? = nil, imageData: NSData? = nil, attributedCaptionTitle: NSAttributedString) {
        self.image = image
        self.imageData = imageData as Data?
        self.attributedCaptionTitle = attributedCaptionTitle
        super.init()
    }

}
