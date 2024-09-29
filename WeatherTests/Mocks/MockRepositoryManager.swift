//
//  MockRepositoryManager.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 28/9/24.
//

@testable import Weather

class MockRepositoryManager {
    let mockLocalStorageManager = LocalStorageManager()
    let mockRemoteServiceManager = MockRemoteServiceManager()
    var shouldRemoteServiceReturnSuccessResponse: Bool = true {
        didSet {
            mockRemoteServiceManager.shouldReturnSuccessResponse = shouldRemoteServiceReturnSuccessResponse
        }
    }
    
    init() {
        mockLocalStorageManager.localSource = MockLocalStorage()
    }
    
    func getMockRepository() -> WeatherRepository {
        let repository = WeatherRepository()
        repository.localSource = mockLocalStorageManager
        repository.remoteSource = mockRemoteServiceManager
        return repository
    }
}
