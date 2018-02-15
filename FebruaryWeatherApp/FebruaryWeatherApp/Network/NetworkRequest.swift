//
//  NetworkRequest.swift
//  FebruaryWeatherApp
//
//  Created by nicole ruduss on 15/02/2018.
//  Copyright © 2018 Ruduss. All rights reserved.
//

import Foundation

struct APISettings {
    var queryString:String = ""
    var httpMethod: String = "GET"
    var baseUrlString: String = ""
}

protocol NetworkRequestProtocol {
    /**
     Sends an api request
     - parameters:
     - settings: the api settings object
     - completion: completion block for handling received responses and errors
     */
    func send(settings: APISettings, completion: @escaping ResponseResult)
}

protocol URLSessionProtocol {
    /**
     Creates a task that retrieves the contents of the specified URL
     - parameters:
     - url: The URL to be retrieved.
     - return value:
     - The new session data task URLSessionDataTask.
     */
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

typealias JSONDictionary = [String: Any]
typealias ResponseResult = (Data?, Error?) -> ()

class NetworkRequest: NetworkRequestProtocol {
    
    // MARK: - Properties
    var completion: ResponseResult?
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    init(){
        self.completion = nil
    }
    
    func send(settings: APISettings, completion: @escaping ResponseResult) {
        
        var urlString = settings.baseUrlString
        if settings.queryString != "" && settings.baseUrlString != "" {
            urlString = urlString + "?" + settings.queryString
        }
        
        guard let url = URL(string: urlString) as? URL else {
            completion(nil, NSError.fruitError("unsupported URL"))
            return
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, NSError.fruitError(error.localizedDescription))
            } else if let data = data,
                let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(nil, NSError.fruitError("response statusCode is not 200 it is \(response.statusCode)"))
                } else {
                    completion(data, nil)
                }
            }
            }.resume()
    }
}

extension URLSession: URLSessionProtocol { } // allows mocking in tests

