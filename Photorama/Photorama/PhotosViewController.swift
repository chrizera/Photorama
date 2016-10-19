//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Christian Perrone on 18/10/16.
//  Copyright © 2016 Christian Perrone. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo  = photoDataSource.photos[indexPath.row]
        
        store.fetchImageForPhoto(photo: photo) { (result) -> Void in
            OperationQueue.main.addOperation({ 
                
                let photoIndex = self.photoDataSource.photos.index(of: photo)!
                let photoIndexPath = NSIndexPath(row: photoIndex, section: 0)
                
                if let cell = self.collectionView.cellForItem(at: photoIndexPath as IndexPath) as? PhotoCollectionViewCell {
                    
                    cell.updateWithImage(image: photo.image)
                }
            })
        }
    }
    
}
