//
//  PhotoStore.swift
//  Photorama
//
//  Created by Christian Perrone on 18/10/16.
//  Copyright © 2016 Christian Perrone. All rights reserved.
//

import UIKit

class PhotoStore {
    
    enum ImageResult {
        
        case success(UIImage)
        case failure(Error)
    }
    
    enum PhotoError: Error {
        case imageCreationError
    }
    
    let session: URLSession = {
        
        let config = URLSessionConfiguration.default
        
        return URLSession(configuration: config)
    }()
    
    func fetchRecentPhotos(completition: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = NSURLRequest(url: url as URL)
        let task = session.dataTask(with: request as URLRequest) {
            
            (data, response, error) -> Void in
            
           let result = self.processRecentPhotosRequest(data: data as NSData?, error: error)
            
           completition(result)
        }
        task.resume()
    }
    
    func processRecentPhotosRequest(data: NSData?, error: Error?) -> PhotosResult {
        
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return FlickrAPI.photosFromJSONData(data: jsonData)
    }
    
    func fetchImageForPhoto(photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        let photoURL = photo.remoteURL
        let request = NSURLRequest(url: photoURL as URL)
        
        let task = session.dataTask(with: request as URLRequest) {
            
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data as NSData?, error: error as NSError?)
            
            if case let .success(image) = result {
                photo.image = image
            }
            
            completion(result)
            
        }
        task.resume()
    }
    
    func processImageRequest(data: NSData?, error: NSError?) -> ImageResult {
        
        guard let imageData = data, let image = UIImage(data: imageData as Data) else {
            
            if data  == nil {
                return .failure(error!)
            }
            else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        
        return .success(image)
    }
    
}
