//
//  MockRemoteServiceManager.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 28/9/24.
//

@testable import Weather

class MockRemoteServiceManager: RemoteServiceManagerDelegate {
    var shouldReturnSuccessResponse = true
    
    func fetchCityList(searchString: String,
                       success: @escaping (SearchResponse?) -> Void,
                       failure: @escaping (Error?) -> Void) {
        if shouldReturnSuccessResponse {
            let data: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
            success(data)
        } else {
            failure(APIError.noData)
        }
    }
    
    func fetchWeather(queryString: String, 
                      success: @escaping (WeatherResponse?) -> Void,
                      failure: @escaping (Error?) -> Void) {
        if shouldReturnSuccessResponse {
            let data: WeatherResponse = MockDataManager.fetchMockResponse(fileName: "weather")
            success(data)
        } else {
            failure(APIError.noData)
        }
    }
}
