//
//  UIAlertManager.swift
//  Weather
//
//  Created by Jacky Tjoa on 29/9/24.
//

import Foundation
import UIKit

class UIAlertManager {
    
    static func displayErrorAlert(error: Error?, 
                                  onViewController viewController: UIViewController?) {
        let nsError = error as? NSError
        let message = nsError?.userInfo[APIError.kMessageKey] as? String
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        viewController?.present(alert, animated: true)
    }
}
