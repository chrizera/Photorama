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
    
    func fetchRecentPhotos() {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = NSURLRequest(url: url as URL)
        let task = session.dataTask(with: request as URLRequest) {
            
            (data, response, error) -> Void in
            
            if let jsonData = data {
                
                if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    print(jsonString)
                }
            }
            else if let requestError = error {
                print("Error fetching recent photos: \(requestError)")
            }
            else {
                print("Unexpected error with the request")
            }
        }
        task.resume()
    }
    
}