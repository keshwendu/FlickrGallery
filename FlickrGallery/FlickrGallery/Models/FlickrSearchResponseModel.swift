//
//  FlickrSearchResponseModel.swift
//  FlickrGallery
//
//  Created by Keshwendu on 22/10/18.
//  Copyright © 2018 Keshwendu. All rights reserved.
//

import Foundation

struct FlickrSearchResponseModel: Codable {
    let photos: FlickrPhotosPaginationModel
    let stat: String
}

struct FlickrPhotosPaginationModel: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [FlickrPhotoModel]
}

struct FlickrPhotoModel: Codable {
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    
    var imageUrl: URL? {
        return URL(string: "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg")
    }
}


