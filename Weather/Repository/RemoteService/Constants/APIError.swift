//
//  APIError.swift
//  Weather
//
//  Created by Jacky Tjoa on 25/9/24.
//

import Foundation

struct APIError {
    private static let kDomain = "WeatherAPIError"
    static let kMessageKey = "message"
    static let noData = NSError(domain: kDomain, code: 1001, userInfo: [kMessageKey: "No data available"])
    static let dataError = NSError(domain: kDomain, code: 1002, userInfo: [kMessageKey: "Fetched data couldn't be read"])
}
