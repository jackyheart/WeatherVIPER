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
    var viewSpy: DetailViewSpy!
    
    override func setUp() {
        super.setUp()
        viewSpy = DetailViewSpy()
        sut = DetailPresenter()
        sut.view = viewSpy
    }
    
    override func tearDown() {
        viewSpy = nil
        sut = nil
        super.tearDown()
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
