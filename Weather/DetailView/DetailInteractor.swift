//
//  DetailInteractor.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

protocol DetailInteractorDelegate {
    func onViewLoaded(withDataItem dataItem: ResultItem?)
}

final class DetailInteractor: DetailInteractorDelegate {
    var repository: WeatherRepositoryDelegate?
    var presenter: DetailPresenterDelegate?
    
    func onViewLoaded(withDataItem dataItem: ResultItem?) {
        let latitude = dataItem?.latitude ?? ""
        let longitude = dataItem?.longitude ?? ""
        let query = "\(latitude),\(longitude)"
        
        repository?.fetchWeather(queryString: query,
                                 success: { response in
            self.presenter?.presentWeatherResult(onDataItem: dataItem,
                                                 result: response?.data.currentCondition.first)
        }, failure: { [weak self] error in
            self?.presenter?.presentError(error: error)
        })
    }
}
