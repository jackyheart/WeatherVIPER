//
//  MockNavigationController.swift
//  WeatherTests
//
//  Created by Jacky Tjoa on 29/9/24.
//

import UIKit

class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
    }
}
