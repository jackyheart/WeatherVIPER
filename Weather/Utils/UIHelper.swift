//
//  UIHelper.swift
//  Weather
//
//  Created by Jacky Tjoa on 29/9/24.
//

import Foundation
import UIKit

class UIHelper {
    
    static func getViewControllerFromStoryboard<T: UIViewController>(identifier: String) -> T? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier) as? T
    }
}
