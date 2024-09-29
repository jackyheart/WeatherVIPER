//
//  URLBuilder.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

class URLBuilder {
    static func buildURL(api: WeatherAPI, query: String) -> String {
        var baseURL = WeatherAPIConstant.baseURL
        switch api {
        case .search:
            baseURL.append(WeatherAPIEndpoint.search)
        case .weather:
            baseURL.append(WeatherAPIEndpoint.weather)
        }
        return baseURL + "?key=" + WeatherAPIConstant.key + "&q=" + query + "&format=json"
    }
}
