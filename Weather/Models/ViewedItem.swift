//
//  ViewedItem.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

struct ViewedItem: Codable {
    let key: String
    let data: ResultItem
    let dateViewed: Date
}
