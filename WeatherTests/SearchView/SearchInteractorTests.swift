//
//  SearchInteractorTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 27/9/24.
//

import XCTest
@testable import Weather

final class SearchInteractorTests: XCTestCase {
    var sut: SearchInteractor!
    var presenterSpy: SearchPresenterSpy!
    var mockRepositoryManager: MockRepositoryManager!
    var mockRepository: WeatherRepository!
    
    override func setUp() {
        super.setUp()
        presenterSpy = SearchPresenterSpy()
        mockRepositoryManager = MockRepositoryManager()
        mockRepository = mockRepositoryManager.getMockRepository()
        sut = SearchInteractor()
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
    
    func storeMockItems() {
        let searchResponse: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
        let resultItems = searchResponse.searchApi.result
        for item in resultItems {
            mockRepository.storeViewedCity(data: item)
        }
    }
    
    func testfetchViewedCities() {
        var dateViewedOrder: [Date] = []
        
        // no data initially
        sut.fetchViewedCities()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 0)
        
        // store 3 mock items, should expect 3 viewed items from local storage
        storeMockItems()
        sut.fetchViewedCities()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        // by default, date is ordered by descending order
        dateViewedOrder = presenterSpy.lastViewedResults.map { $0.dateViewed }
        
        // check item limit
        sut.kLastViewedLimit = 1
        sut.fetchViewedCities()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 1)
        XCTAssertEqual(presenterSpy.lastViewedResults[0].dateViewed, dateViewedOrder[0])
        
        sut.kLastViewedLimit = 2
        sut.fetchViewedCities()
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 2)
        XCTAssertEqual(presenterSpy.lastViewedResults[0].dateViewed, dateViewedOrder[0])
        XCTAssertEqual(presenterSpy.lastViewedResults[1].dateViewed, dateViewedOrder[1])
        
        // check ascending order, date order should be reversed from previous retrieval
        sut.itemOrdering = .ascending
        sut.kLastViewedLimit = 3
        sut.fetchViewedCities()
        let ascendingDateOrder: [Date] = presenterSpy.lastViewedResults.map { $0.dateViewed }
        XCTAssertEqual(ascendingDateOrder, dateViewedOrder.reversed())
    }
    
    func testOnSearchTextEntered() {
        storeMockItems()
        sut.fetchViewedCities()
        
        sut.filterCities(withSearchString: "Lon")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.filterCities(withSearchString: "lon")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.filterCities(withSearchString: "")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 3)
        
        sut.filterCities(withSearchString: "Londonderry")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 1)
        
        sut.filterCities(withSearchString: "randomText")
        XCTAssertEqual(presenterSpy.lastViewedResults.count, 0)
    }
    
    func testDidPressSearch() {
        mockRepositoryManager.shouldRemoteServiceReturnSuccessResponse = true
        sut.searchCites(withSearchString: "someSearchString")
        XCTAssertEqual(presenterSpy.searchResults.count, 3)
        
        mockRepositoryManager.shouldRemoteServiceReturnSuccessResponse = false
        sut.searchCites(withSearchString: "someSearchString")
        XCTAssertNotNil(presenterSpy.errorResult)
    }
    
    func testDidSelectItem() {
        sut.searchCites(withSearchString: "someSearchString")
        
        sut.saveViewedCity(onIndex: 0)
        var viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 1)
        
        sut.saveViewedCity(onIndex: 1)
        viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 2)
        
        sut.saveViewedCity(onIndex: 2)
        viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 3)
        
        //test out-of-bounds
        sut.saveViewedCity(onIndex: 100)
        viewedItems = mockRepository.retrieveViewedCities(limit: 10, ordering: .descending)
        XCTAssertEqual(viewedItems.count, 3)
    }
}

final class SearchPresenterSpy: SearchPresenterDelegate {
    var lastViewedResults: [ViewedItem] = []
    var searchResults: [ResultItem] = []
    var errorResult: Error?
    
    func onViewWillAppear() {}
    func onSearchTextEntered(withSearchString searchString: String) {}
    func didPressSearch(withSearchString searchString: String) {}
    func didSelectItem(onIndex index: Int) {}
    func onDataSaved(withDataItem dataItem: ResultItem?) {}
    
    func presentLastViewedCities(results: [ViewedItem]) {
        lastViewedResults = results
    }
    
    func presentSearchedCityList(results: [ResultItem]) {
        searchResults = results
    }
    
    func presentError(error: Error?) {
        errorResult = error
    }
}
