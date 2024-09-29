//
//  DetailInteractorTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 28/9/24.
//

import XCTest
@testable import Weather

final class DetailInteractorTests: XCTestCase {
    var sut: DetailInteractor!
    var presenterSpy: DetailPresenterSpy!
    var mockRepositoryManager: MockRepositoryManager!
    var mockRepository: WeatherRepository!
    
    override func setUp() {
        super.setUp()
        presenterSpy = DetailPresenterSpy()
        mockRepositoryManager = MockRepositoryManager()
        mockRepository = mockRepositoryManager.getMockRepository()
        sut = DetailInteractor()
        sut.repository = mockRepository
        sut.presenter = presenterSpy
    }
    
    override func tearDown() {
        presenterSpy = nil
        mockRepositoryManager = nil
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    func testOnViewLoaded() {
        mockRepositoryManager.shouldRemoteServiceReturnSuccessResponse = true
        let searchResponse: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
        sut.onViewLoaded(withDataItem: searchResponse.searchApi.result.first)
        XCTAssertEqual(presenterSpy.dataItem?.areaName.first?.value, "London")
        XCTAssertEqual(presenterSpy.dataItem?.country.first?.value, "United Kingdom")
        XCTAssertEqual(presenterSpy.weatherResult?.tempC, "15")
        XCTAssertTrue(presenterSpy.weatherResult?.weatherIconUrl.first?.value.isEmpty == false)
        XCTAssertEqual(presenterSpy.weatherResult?.weatherDesc.first?.value, "Partly cloudy")
        XCTAssertEqual(presenterSpy.weatherResult?.humidity, "51")
        
        mockRepositoryManager.shouldRemoteServiceReturnSuccessResponse = false
        sut.onViewLoaded(withDataItem: searchResponse.searchApi.result.first)
        XCTAssertNotNil(presenterSpy.errorResult)
    }
}

final class DetailPresenterSpy: DetailPresenterDelegate {
    var dataItem: ResultItem?
    var weatherResult: WeatherCondition?
    var errorResult: Error?
    
    func presentWeatherResult(onDataItem dataItem: ResultItem?,
                              result: WeatherCondition?) {
        self.dataItem = dataItem
        weatherResult = result
    }
    
    func presentError(error: Error?) {
        errorResult = error
    }
}
