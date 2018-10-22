//
//  API.Flickr.swift
//  FlickrGallery
//
//  Created by Keshwendu on 22/10/18.
//  Copyright © 2018 Keshwendu. All rights reserved.
//

import Foundation

extension API {
    enum Flickr {
        struct Search: APIFetchRequest {
            typealias FetchResult = FlickrSearchResponseModel
            
            let searchKeyword: String
            let page: Int
            
            var url: String {
                return "https://api.flickr.com/services/rest/"
            }
            
            var parameters: APIFetchRequest.Parameters? {
                return [
                    "method" : "flickr.photos.search",
                    "api_key" : "3e7cc266ae2b0e0d78e279ce8e361736",
                    "format": "json",
                    "nojsoncallback": "1",
                    "safe_search": "1",
                    "per_page": 50,
                    "page": page,
                    "text": searchKeyword
                ]
            }
        }
    }
}
