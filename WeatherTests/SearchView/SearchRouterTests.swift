//
//  SearchRouterTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 29/9/24.
//

import XCTest
@testable import Weather

final class SearchRouterTests: XCTestCase {
    var sut: SearchRouter!
    var mockVC: MockSearchViewController!
    var mockNavVC: MockNavigationController!
    
    override func setUp() {
        super.setUp()
        mockVC = MockSearchViewController()
        mockNavVC = MockNavigationController()
        mockNavVC.setViewControllers([mockVC], animated: false)
        sut = SearchRouter()
    }
    
    override func tearDown() {
        mockVC = nil
        mockNavVC = nil
        sut = nil
        super.tearDown()
    }
    
    func testNavigateToDetailScreen() {
        sut.navigateToDetailScreen(withDataItem: nil, onView: mockVC)
        XCTAssertTrue(mockNavVC.pushedViewController is DetailViewController)
    }
}

final class MockSearchViewController: UIViewController & SearchViewDelegate {
    func displayResultList(_ results: [SearchCellModel]) {}
    func displayErrorAlert(error: Error?) {}
}
