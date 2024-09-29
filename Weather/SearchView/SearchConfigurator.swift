//
//  SearchConfigurator.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

final class SearchConfigurator {
    static func configure(_ viewController: SearchViewController) {
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        let repository = WeatherRepository()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.repository = repository
    }
}
