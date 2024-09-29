//
//  SearchPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

import UIKit

enum ItemOrdering {
    case ascending
    case descending
}

protocol SearchPresenterDelegate: AnyObject {
    //inputs
    func onSearchTextEntered(withSearchString searchString: String)
    func didPressSearch(withSearchString searchString: String)
    func didSelectItem(onIndex index: Int)
    //outputs
    func presentLastViewedCities(results: [ViewedItem])
    func presentSearchedCityList(results: [ResultItem])
    func presentError(error: Error?)
    func onDataSaved(withDataItem dataItem: ResultItem?)
}

final class SearchPresenter: SearchPresenterDelegate {
    var interactor: SearchInteractorDelegate?
    var router: SearchRouterDelegate?
    weak var view: (UIViewController & SearchViewDelegate)?
    
    func onSearchTextEntered(withSearchString searchString: String) {
        interactor?.filterCities(withSearchString: searchString)
    }
    
    func didPressSearch(withSearchString searchString: String) {
        interactor?.searchCites(withSearchString: searchString)
    }
    
    func didSelectItem(onIndex index: Int) {
        interactor?.saveViewedCity(onIndex: index)
    }
    
    func presentLastViewedCities(results: [ViewedItem]) {
        let viewModelList = results.map {
            DataModelConverter.convertDataModelToViewModel(data: $0.data,
                                                           dateViewed: $0.dateViewed)
        }
        view?.displayResultList(viewModelList)
    }
    
    func presentSearchedCityList(results: [ResultItem]) {
        let viewModelList = results.map {
            DataModelConverter.convertDataModelToViewModel(data: $0,
                                                           dateViewed: nil)
        }
        view?.displayResultList(viewModelList)
    }
    
    func presentError(error: Error?) {
        view?.displayErrorAlert(error: error)
    }
    
    func onDataSaved(withDataItem dataItem: ResultItem?) {
        router?.navigateToDetailScreen(withDataItem: dataItem,
                                       onView: view)
    }
}
