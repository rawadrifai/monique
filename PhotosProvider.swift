//
//  PhotosProvider.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit
import NYTPhotoViewer

/**
*   In Swift 1.2, the following file level constants can be moved inside the class for better encapsulation
*/
let CustomEverythingPhotoIndex = 1, DefaultLoadingSpinnerPhotoIndex = 3, NoReferenceViewPhotoIndex = 4
let PrimaryImageName = "NYTimesBuilding"
let PlaceholderImageName = "NYTimesBuildingPlaceholder"

class PhotosProvider: NSObject {

    private var photos = [ExamplePhoto]()
    
    override init() {
    //    self.images = [UIImage]()
    }
    
    init(images:[UIImage]) {
        //super.init()
        //self.images = images
        
        self.photos = {
            
            var mutablePhotos: [ExamplePhoto] = []
            var image = UIImage()
            let numberOfPhotos = images.count
            
            func shouldSetImageOnIndex(photoIndex: Int) -> Bool {
                return photoIndex != CustomEverythingPhotoIndex && photoIndex != DefaultLoadingSpinnerPhotoIndex
            }
            
            for photoIndex in 0 ..< numberOfPhotos {
                
                image = images[photoIndex]
                let title = NSAttributedString(string: "Photo " + String(photoIndex+1) + " of " + String(numberOfPhotos), attributes: [NSForegroundColorAttributeName: UIColor.white])
                
                let photo = shouldSetImageOnIndex(photoIndex: photoIndex) ? ExamplePhoto(image: image, attributedCaptionTitle: title) : ExamplePhoto(attributedCaptionTitle: title)
                
                if photoIndex == CustomEverythingPhotoIndex {
                    photo.placeholderImage = UIImage(named: PlaceholderImageName)
                }
                
                mutablePhotos.append(photo)
            }
            
            return mutablePhotos
        }()
    }
    
    public func getPhotos() -> [ExamplePhoto] {
        return self.photos
    }
    
    
}
