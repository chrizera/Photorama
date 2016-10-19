//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Christian Perrone on 18/10/16.
//  Copyright © 2016 Christian Perrone. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
         
            OperationQueue.main.addOperation({ 
                switch photosResult {
                case let .success(photos):
                    print("Successfully found \(photos.count) recent photos.")
                    self.photoDataSource.photos = photos
                    
                case let .failure(error):
                    self.photoDataSource.photos.removeAll()
                    print("Error fetching recent photos: \(error)")
                }
                self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            })
        }
    }
}
