//
//  DataModelConverter.swift
//  Weather
//
//  Created by Jacky Tjoa on 27/9/24.
//

import Foundation

class DataModelConverter {
    
    static func convertDataModelToViewModel(data: ResultItem,
                                            dateViewed: Date?) -> SearchCellModel {
        let displayText = "\(data.areaName.first?.value ?? ""), \(data.country.first?.value ?? "")"
        var noteText = ""
        if let dateViewed = dateViewed {
            let dateString = DateUtil.shared.formatDate(date: dateViewed)
            noteText = "Last viewed: \(dateString)"
        }
        let viewModel = SearchCellModel(displayText: displayText,
                                        noteText: noteText,
                                        noteTextColor: .gray)
        return viewModel
    }
    
    static func convertDataModelToStorageModel(key: String, data: ResultItem, dateViewed: Date) -> ViewedItem {
        let viewedItem = ViewedItem(key: key,
                                    data: data,
                                    dateViewed: dateViewed)
        return viewedItem
    }
    
    static func constructDataKey(data: ResultItem) -> String {
        //key is the combination of latitude and longitude to uniquely identify item
        return "\(data.latitude), \(data.longitude)"
    }
}
