//
//  PhotoStore.swift
//  Photorama
//
//  Created by Christian Perrone on 18/10/16.
//  Copyright © 2016 Christian Perrone. All rights reserved.
//

import Foundation

class PhotoStore {
    
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
    
}
