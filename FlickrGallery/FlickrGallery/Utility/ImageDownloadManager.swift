//
//  ImageDownloadManager.swift
//  FlickrGallery
//
//  Created by Keshwendu on 22/10/18.
//  Copyright © 2018 Keshwendu. All rights reserved.
//

import UIKit

class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    
    private var inProgressTasks: [IndexPath: URLSessionDataTask] = [:]
    private let imageCache: URLCache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)

    private init(){}
    
    // Asynchronosly loads image from web  if not availablein chache
    func load(url: URL, forIndexPath indexPath: IndexPath, delegate: ImageDownloadDelegate) -> Data? {
        let request = URLRequest(url: url)
        if let data = imageCache.cachedResponse(for: request)?.data {
            return data
        } else {
            let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 404) == 200 {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.imageCache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.inProgressTasks[indexPath] = nil
                        delegate.imageDownloadCompleted(forIndexPath: indexPath, imageData: data)
                    }
                }
            })
            inProgressTasks[indexPath] = dataTask
            dataTask.resume()
        }
        return nil
    }
    
    func removeNotUsedPendingDataTask(forIndexPath indexPath: IndexPath) {
        self.inProgressTasks[indexPath]?.cancel()
        self.inProgressTasks[indexPath] = nil
    }
}

protocol ImageDownloadDelegate {
    func imageDownloadCompleted(forIndexPath indexPath: IndexPath, imageData: Data)
}
