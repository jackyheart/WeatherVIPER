//
//  DetailPresenterTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 28/9/24.
//

import XCTest
@testable import Weather

final class DetailPresenterTests: XCTestCase {
    var sut: DetailPresenter!
    var interactorSpy: DetailInteractorSpy!
    var viewSpy: DetailViewSpy!
    
    override func setUp() {
        super.setUp()
        interactorSpy = DetailInteractorSpy()
        viewSpy = DetailViewSpy()
        sut = DetailPresenter()
        sut.interactor = interactorSpy
        sut.view = viewSpy
    }
    
    override func tearDown() {
        interactorSpy = nil
        viewSpy = nil
        sut = nil
        super.tearDown()
    }
    
    func testOnViewLoaded() {
        let searchResponse: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
        let searchResults = searchResponse.searchApi.result
        sut.onViewLoaded(withDataItem: searchResults.first)
        XCTAssertEqual(interactorSpy.fetchWeatherDataWithDataItem?.weatherUrl.first?.value,
                       searchResults.first?.weatherUrl.first?.value)
    }
    
    func testPresentWeatherResult() {
        let searchResponse: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
        let weatherResponse: WeatherResponse = MockDataManager.fetchMockResponse(fileName: "weather")
        sut.presentWeatherResult(onDataItem: searchResponse.searchApi.result.first,
                                 result: weatherResponse.data.currentCondition.first)
        
        let resultViewModel = viewSpy.viewModel
        XCTAssertEqual(resultViewModel?.city, "London")
        XCTAssertEqual(resultViewModel?.country, "United Kingdom")
        XCTAssertEqual(resultViewModel?.temperatureCelcius, "15")
        XCTAssertFalse(resultViewModel?.imageURLString?.isEmpty == true)
        XCTAssertEqual(resultViewModel?.weatherDescription, "Partly cloudy")
    }
    
    func testPresentError() {
        sut.presentError(error: APIError.noData)
        XCTAssertNotNil(viewSpy.errorResult)
        
        sut.presentError(error: nil)
        XCTAssertNil(viewSpy.errorResult)
    }
}

final class DetailInteractorSpy: DetailInteractorDelegate {
    var fetchWeatherDataWithDataItem: ResultItem?
    
    func fetchWeatherData(withDataItem dataItem: ResultItem?) {
        fetchWeatherDataWithDataItem = dataItem
    }
}

final class DetailViewSpy: DetailViewControllerDelegate {
    var viewModel: DetailViewModel?
    var errorResult: Error?
    
    func displayResult(result: DetailViewModel) {
        viewModel = result
    }
    
    func displayErrorAlert(error: Error?) {
        errorResult = error
    }
}
