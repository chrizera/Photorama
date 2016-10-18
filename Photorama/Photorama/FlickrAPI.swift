//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Christian Perrone on 18/10/16.
//  Copyright © 2016 Christian Perrone. All rights reserved.
//

import Foundation

enum Method: String {
    
    case recentPhotos = "flickr.photos.getRecent"
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> NSURL {
        
        let components  = NSURLComponents(string: baseURLString)!
        var queryItems = [NSURLQueryItem]()
        let baseParams = ["method" : method.rawValue,
                          "format" : "json",
                          "nojsoncallback" : "1",
                          "api_key" : APIKey]
        
        for (key, value) in baseParams {
            
            let item = NSURLQueryItem(name: key, value: value)
            
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            
            for (key, value) in additionalParams {
                
                let item  = NSURLQueryItem(name: key, value: value)
                
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems as [URLQueryItem]?
        
        return components.url! as NSURL
    }
    
    static func recentPhotosURL() -> NSURL {
        
        return flickrURL(method: .recentPhotos, parameters: ["extras" : "url_h,date_taken"])
    }

}




