//
//  DetailPresenter.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

protocol DetailPresenterDelegate: AnyObject {
    //inputs
    func onViewLoaded(withDataItem dataItem: ResultItem?)
    //outputs
    func presentWeatherResult(onDataItem dataItem: ResultItem?, result: WeatherCondition?)
    func presentError(error: Error?)
}

final class DetailPresenter: DetailPresenterDelegate {
    var interactor: DetailInteractorDelegate?
    weak var view: DetailViewControllerDelegate?
    
    func onViewLoaded(withDataItem dataItem: ResultItem?) {
        interactor?.fetchWeatherData(withDataItem: dataItem)
    }
    
    func presentWeatherResult(onDataItem dataItem: ResultItem?, result: WeatherCondition?) {
        let viewModel = DetailViewModel(city: dataItem?.areaName.first?.value,
                                        country: dataItem?.country.first?.value,
                                        temperatureCelcius: result?.tempC,
                                        imageURLString: result?.weatherIconUrl.first?.value,
                                        weatherDescription: result?.weatherDesc.first?.value, 
                                        humidityDisplay: "humidity: \(result?.humidity ?? "")%")
        view?.displayResult(result: viewModel)
    }
    
    func presentError(error: Error?) {
        view?.displayErrorAlert(error: error)
    }
}
