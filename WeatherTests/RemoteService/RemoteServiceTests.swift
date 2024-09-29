//
//  RemoteServiceTests.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 26/9/24.
//

import XCTest
@testable import Weather

final class RemoteServiceTests: XCTestCase {
    var sut: RemoteService!
    var mockHTTPClient: MockHTTPClient!
    
    override func setUp() {
        super.setUp()
        sut = RemoteService()
        mockHTTPClient = MockHTTPClient()
        sut.httpClient = mockHTTPClient
    }
    
    override func tearDown() {
        mockHTTPClient = nil
        sut = nil
        super.tearDown()
    }
    
    func testFetchData() {
        mockHTTPClient.fileName = "search"
        sut.fetchData<SearchResponse>(urlString: "someURLString") { (result: SearchResponse?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.searchApi.result.count, 3)
        } failure: { error in
            XCTAssertNil(error)
        }
        
        mockHTTPClient.fileName = "empty"
        sut.fetchData<SearchResponse>(urlString: "someURLString") { (result: SearchResponse?) -> Void in
            XCTAssertNil(result)
        } failure: { error in
            XCTAssertNotNil(error)
        }
        
        mockHTTPClient.fileName = ""
        sut.fetchData<SearchResponse>(urlString: "someURLString") { (result: SearchResponse?) -> Void in
            XCTAssertNil(result)
        } failure: { error in
            XCTAssertNotNil(error)
        }
    }
}

final class MockHTTPClient: HTTPClientProtocol {
    var fileName: String = ""
    
    func fetchData(urlString: String,
                   completion: @escaping (Data?, (any Error)?) -> Void) {
        if fileName.isEmpty {
            completion(nil, APIError.noData)
        } else {
            let data = MockDataManager.getJsonDataFromFile(fileName: fileName)
            completion(data, nil)
        }
    }
}
