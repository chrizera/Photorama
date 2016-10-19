//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Christian Perrone on 19/10/16.
//  Copyright © 2016 Christian Perrone. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        store.fetchImageForPhoto(photo: photo) { (result) -> Void in
            
            switch result {
                
            case let .success(image):
                OperationQueue.main.addOperation({ 
                    self.imageView.image = image
                })
                
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
}
