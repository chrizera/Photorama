//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Christian Perrone on 18/10/16.
//  Copyright © 2016 Christian Perrone. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            
            switch photosResult {
                
            case let .success(photos):
                print("Successfully found \(photos.count) recent photos.")
                
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(photo: firstPhoto, completion: {
                        (imageResult) -> Void in
                        
                        switch imageResult {
                        case let .success(image):
                            OperationQueue.main.addOperation {
                                self.imageView.image = image
                            }
                        case let .failure(error):
                            print("Error downloading image: \(error)")
                        }
                    })
                }
                
            case let .failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
    }
}
