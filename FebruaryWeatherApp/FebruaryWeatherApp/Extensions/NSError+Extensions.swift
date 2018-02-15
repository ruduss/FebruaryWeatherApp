//
//  FebruaryWeatherApp+ErrorExtension.swift
//  FebruaryWeatherApp
//
//  Created by nicole ruduss on 15/02/2018.
//  Copyright © 2018 Ruduss. All rights reserved.
//

import Foundation

extension NSError {
    
    class func weatherAppError(_ description: String) -> NSError {
        var dict = [String: AnyObject]()
        dict[NSLocalizedDescriptionKey] = description as AnyObject?
        return NSError(domain: "FebruaryWeatherApp", code: 999, userInfo: dict)
    }
}
