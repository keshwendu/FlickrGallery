//
//  API.swift
//  FlickrGallery
//
//  Created by Keshwendu on 21/10/18.
//  Copyright © 2018 Keshwendu. All rights reserved.
//

import Foundation

/**
 API namespace
 */
enum API {}


/**
 Requests type
 */
enum HTTPMethod: String {
    case GET
    case POST
}

/**
 API fetch request
 */
protocol APIFetchRequest {
    associatedtype FetchResult: Decodable
    
    typealias Parameters = [String: Any]
    typealias HTTPHeaders = [String: String]
    typealias Mapping<T> = (Any) throws -> T?
    
    var url: String { get }
    var parameters: Parameters? { get }
    var httpHeaders: HTTPHeaders? { get }
    var method: HTTPMethod { get }
    //    var mapping: Mapping<FetchResult> { get }
}

extension APIFetchRequest {
    var parameters: Parameters? { return nil }
    var httpHeaders: HTTPHeaders? { return nil }
    var method: HTTPMethod { return .GET }
    
    func run(completion: @escaping (APIRequestResult<FetchResult>) -> Void) {
        var finalURLString: String = self.url
        
        // Get request handling
        if method == .GET, let p = parameters {
            if !url.contains("?") { finalURLString.append("?") }
            p.forEach { finalURLString.append("&\($0.key)=\($0.value)") }
            finalURLString = finalURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        
        var request = URLRequest(url: URL(string: finalURLString)!)
        
        // Post request handling
        if method == .POST, let p = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: p, options: [])
        }
        
        request.httpMethod = self.method.rawValue
        
        //Add HTTP Headers
        if let h = httpHeaders {
            h.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            var result: APIRequestResult<FetchResult>
            
            defer { completion(result) }
            
            if let e = error {
                result = .failure(e)
            } else {
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(FetchResult.self, from: data!)
                    result = .success(responseModel)
                } catch let decodeError {
                    let r =  String(data: data!, encoding: String.Encoding.utf8)
                    print("JSON Serialization error \(String(describing: r))")
                    result = .failure(decodeError)
                }
            }
        }).resume()
    }
}

/**
 Response result
 */
enum APIRequestResult<Value> {
    case success(Value)
    case failure(Error)
}
