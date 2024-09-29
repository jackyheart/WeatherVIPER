//
//  WeatherAPI.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

enum WeatherAPI {
    case search
    case weather
}

struct WeatherAPIConstant {
    static let key = "3a0a9df34eb94e75b39132320242309"
    static let baseURL = "https://api.worldweatheronline.com/premium/v1/"
}

struct WeatherAPIEndpoint {
    static let search = "search.ashx"
    static let weather = "weather.ashx"
}
