//
//  RemoteServiceManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

protocol RemoteServiceManagerDelegate {
    func fetchCityList(searchString: String, 
                       success: @escaping (SearchResponse?) -> Void,
                       failure: @escaping (Error?) -> Void)
    func fetchWeather(queryString: String, 
                      success: @escaping (WeatherResponse?) -> Void,
                      failure: @escaping (Error?) -> Void)
}

final class RemoteServiceManager: RemoteServiceManagerDelegate {
    var service: RemoteServiceDelegate? = RemoteService()
    
    func fetchCityList(searchString: String, 
                       success: @escaping (SearchResponse?) -> Void,
                       failure: @escaping (Error?) -> Void) {
        let urlString = URLBuilder.buildURL(api: .search, query: searchString)
        service?.fetchData(urlString: urlString, success: success, failure: failure)
    }
    
    func fetchWeather(queryString: String,
                      success: @escaping (WeatherResponse?) -> Void,
                      failure: @escaping (Error?) -> Void) {
        let urlString = URLBuilder.buildURL(api: .weather, query: queryString)
        service?.fetchData(urlString: urlString, success: success, failure: failure)
    }
}
