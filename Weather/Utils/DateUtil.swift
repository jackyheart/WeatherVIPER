//
//  DateUtil.swift
//  Weather
//
//  Created by Jacky Tjoa on 27/9/24.
//

import Foundation

class DateUtil {
    static let shared = DateUtil()
    private let kDateFormat = "dd MMM yyyy hh:mm:ss a"
    private let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = kDateFormat
    }
    
    func formatDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func dateFromString(string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}
