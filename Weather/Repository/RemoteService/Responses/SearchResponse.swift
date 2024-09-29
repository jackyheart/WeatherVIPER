//
//  SearchResponse.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

struct SearchResponse: Codable {
    let searchApi: SearchApi
    
    enum CodingKeys: String, CodingKey {
        case searchApi = "search_api"
    }
}

struct SearchApi: Codable {
    let result: [ResultItem]
}

struct ResultItem: Codable {
    let areaName: [ValueList]
    let country: [ValueList]
    let region: [ValueList]
    let latitude: String
    let longitude: String
    let weatherUrl: [ValueList]
}

struct ValueList: Codable {
    let value: String
}
