//
//  SearchRouter.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

import UIKit

protocol SearchRouterDelegate {
    func navigateToDetailScreen(withDataItem dataItem: ResultItem?,
                                onView view: UIViewController?)
}

final class SearchRouter: SearchRouterDelegate {
    
    func navigateToDetailScreen(withDataItem dataItem: ResultItem?,
                                onView view: UIViewController?) {
        guard let detailVC = UIHelper.getViewControllerFromStoryboard(
            identifier: "DetailViewController") as? DetailViewController else {
            return
        }
        detailVC.dataItem = dataItem
        view?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
