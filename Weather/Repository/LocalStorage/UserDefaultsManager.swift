//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import Foundation

protocol LocalSourceDelegate {
    func read(key: String) -> Data?
    func write(value: Data, key: String)
}

class UserDefaultsManager: LocalSourceDelegate {
    let userDefaults = UserDefaults.standard
    
    func read(key: String) -> Data? {
        return userDefaults.object(forKey: key) as? Data
    }
    
    func write(value: Data, key: String) {
        userDefaults.set(value, forKey: key)
    }
}
