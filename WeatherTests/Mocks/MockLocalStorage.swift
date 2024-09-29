//
//  MockLocalStorage.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 28/9/24.
//

import Foundation
@testable import Weather

class MockLocalStorage: LocalSourceDelegate {
    var dataDict: [String: Data] = [String: Data]()
    
    func read(key: String) -> Data? {
        return dataDict[key]
    }
    
    func write(value: Data, key: String) {
        dataDict[key] = value
    }
}
