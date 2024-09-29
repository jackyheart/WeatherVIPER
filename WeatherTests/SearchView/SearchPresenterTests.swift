//
//  SearchPresenterTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 27/9/24.
//

import XCTest
@testable import Weather

final class SearchPresenterTests: XCTestCase {
    var sut: SearchPresenter!
    var interactorSpy: SearchInteractorSpy!
    var viewSpy: SearchViewSpy!
    var routerSpy: SearchRouterSpy!
    var resultItems: [ResultItem] = []
    
    override func setUp() {
        super.setUp()
        interactorSpy = SearchInteractorSpy()
        viewSpy = SearchViewSpy()
        routerSpy = SearchRouterSpy()
        sut = SearchPresenter()
        sut.interactor = interactorSpy
        sut.view = viewSpy
        sut.router = routerSpy
        prepareData()
    }
    
    override func tearDown() {
        resultItems.removeAll()
        interactorSpy = nil
        viewSpy = nil
        routerSpy = nil
        sut = nil
        super.tearDown()
    }
    
    func prepareData() {
        let searchResponse: SearchResponse = MockDataManager.fetchMockResponse(fileName: "search")
        resultItems = searchResponse.searchApi.result
    }
    
    func testOnSearchTextEntered() {
        sut.onSearchTextEntered(withSearchString: "searchString")
        XCTAssertEqual(interactorSpy.filterCitiesCalledWithSearchString, "searchString")
    }
    
    func testDidPressSearch() {
        sut.didPressSearch(withSearchString: "searchString")
        XCTAssertEqual(interactorSpy.searchCitesCalledWithSearchString, "searchString")
    }
    
    func testDidSelectItem() {
        sut.didSelectItem(onIndex: 0)
        XCTAssertEqual(interactorSpy.saveViewedCityCalledOnIndex, 0)
        
        sut.didSelectItem(onIndex: 1)
        XCTAssertEqual(interactorSpy.saveViewedCityCalledOnIndex, 1)
        
        sut.didSelectItem(onIndex: 100)
        XCTAssertEqual(interactorSpy.saveViewedCityCalledOnIndex, 100)
    }
    
    func testPresentLastViewedCities() {
        let viewDates = [
            "26 Sep 2024 09:48:13 AM",
            "27 Sep 2024 09:47:36 PM",
            "28 Sep 2024 09:31:24 PM"]
        
        let viewedItems = resultItems.enumerated().map { (index, element) in
            let dateString = viewDates[index]
            let date = DateUtil.shared.dateFromString(string: dateString)!
            let dataKey = DataModelConverter.constructDataKey(data: element)
            return DataModelConverter.convertDataModelToStorageModel(key: dataKey,
                                                                     data: element,
                                                                     dateViewed: date)
        }
        
        sut.presentLastViewedCities(results: viewedItems)
        
        let actualCityResults = viewSpy.cellModels.map { $0.displayText }
        let actualDateResults = viewSpy.cellModels.map { $0.noteText }
        
        let expectedCityResults = [
            "London, United Kingdom",
            "London, Canada",
            "Londonderry, United States of America"
        ]
        
        let expectedDateResults = [
            "Last viewed: 26 Sep 2024 09:48:13 AM",
            "Last viewed: 27 Sep 2024 09:47:36 PM",
            "Last viewed: 28 Sep 2024 09:31:24 PM"
        ]
        
        XCTAssertEqual(actualCityResults, expectedCityResults)
        XCTAssertEqual(actualDateResults, expectedDateResults)
    }
    
    func testPresentSearchedCityList() {
        sut.presentSearchedCityList(results: resultItems)
        
        let expectedCityList = [
            "London, United Kingdom",
            "London, Canada",
            "Londonderry, United States of America"
        ]
        
        let actualCityList = viewSpy.cellModels.map { $0.displayText }
        
        XCTAssertEqual(expectedCityList, actualCityList)
    }
    
    func testPresentError() {
        sut.presentError(error: APIError.noData)
        XCTAssertNotNil(viewSpy.errorResult)
        
        sut.presentError(error: nil)
        XCTAssertNil(viewSpy.errorResult)
    }
    
    func testOnDataSaved() {
        sut.onDataSaved(withDataItem: nil)
        XCTAssertTrue(routerSpy.navigateToDetailScreenCalled)
        XCTAssertEqual(routerSpy.passedInView, sut.view)
    }
}

final class SearchInteractorSpy: SearchInteractorDelegate {
    var fetchViewedCitiesCalled = false
    var filterCitiesCalledWithSearchString: String?
    var searchCitesCalledWithSearchString: String?
    var saveViewedCityCalledOnIndex: Int?
    
    func fetchViewedCities() {
        fetchViewedCitiesCalled = true
    }
    
    func filterCities(withSearchString searchString: String) {
        filterCitiesCalledWithSearchString = searchString
    }
    
    func searchCites(withSearchString searchString: String) {
        searchCitesCalledWithSearchString = searchString
    }
    
    func saveViewedCity(onIndex index: Int) {
        saveViewedCityCalledOnIndex = index
    }
}

final class SearchViewSpy: UIViewController & SearchViewDelegate {
    var cellModels: [SearchCellModel] = []
    var errorResult: Error?
    
    func displayResultList(_ results: [SearchCellModel]) {
        cellModels = results
    }
    
    func displayErrorAlert(error: Error?) {
        errorResult = error
    }
}

final class SearchRouterSpy: SearchRouterDelegate {
    var navigateToDetailScreenCalled = false
    var passedInView: UIViewController?
    
    func navigateToDetailScreen(withDataItem dataItem: ResultItem?,
                                onView view: UIViewController?) {
        navigateToDetailScreenCalled = true
        passedInView = view
    }
}
