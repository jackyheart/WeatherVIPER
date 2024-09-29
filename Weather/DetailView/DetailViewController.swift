//
//  DetailViewController.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func displayResult(result: DetailViewModel)
    func displayErrorAlert(error: Error?)
}

final class DetailViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureCelciusLabel: UILabel!
    @IBOutlet weak var celciusLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var interactor: DetailInteractorDelegate?
    var dataItem: ResultItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailConfigurator.configure(self)
        resetValues()
        displayNavigationTitle()
        self.activityIndicator.startAnimating()
        interactor?.onViewLoaded(withDataItem: dataItem)
    }
    
    private func resetValues() {
        self.cityLabel.text = ""
        self.countryLabel.text = ""
        self.temperatureCelciusLabel.text = ""
        self.celciusLabel.isHidden = true
        self.weatherImageView.image = nil
        self.weatherLabel.text = ""
        self.humidityLabel.text = ""
    }
    
    private func displayNavigationTitle() {
        let city = dataItem?.areaName.first?.value ?? ""
        let country = dataItem?.country.first?.value ?? ""
        self.title = "\(city), \(country)"
    }
}

extension DetailViewController: DetailViewControllerDelegate {
    
    func displayResult(result: DetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.cityLabel.text = result.city
            self?.countryLabel.text = result.country
            self?.temperatureCelciusLabel.text = result.temperatureCelcius
            self?.celciusLabel.isHidden = false
            self?.weatherImageView.load(urlString: result.imageURLString)
            self?.weatherLabel.text = result.weatherDescription
            self?.humidityLabel.text = result.humidityDisplay
        }
    }
    
    func displayErrorAlert(error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            UIAlertManager.displayErrorAlert(error: error, onViewController: self)
        }
    }
}
