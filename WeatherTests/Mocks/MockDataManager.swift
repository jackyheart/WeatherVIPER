//
//  MockDataManager.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 27/9/24.
//

import Foundation

class MockDataManager {
    
    static func getJsonDataFromFile(fileName: String) -> Data {
        let bundle = Bundle(for: MockDataManager.self)
        let path = bundle.path(forResource: fileName, ofType: "json")!
        let content = try! String(contentsOfFile: path)
        return Data(content.utf8)
    }
    
    static func fetchMockResponse<T: Decodable>(fileName: String) -> T {
        let data = getJsonDataFromFile(fileName: fileName)
        let response = try! JSONDecoder().decode(T.self, from: data)
        return response
    }
}
