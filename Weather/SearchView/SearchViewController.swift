//
//  SearchViewController.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func displayResultList(_ results: [SearchCellModel])
    func displayErrorAlert(error: Error?)
}

final class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var presenter: SearchPresenterDelegate?
    private let kWeatherCell = "weatherCell"
    private let emptyView = SearchEmptyView()
    private var cellModels: [SearchCellModel] = []
    private var currentSearchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchConfigurator.configure(self)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onSearchTextEntered(withSearchString: currentSearchText)
    }
    
    private func setupUI() {
        searchBar.placeholder = "Search for a city"
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: kWeatherCell)
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Search"
    }
}

extension SearchViewController: SearchViewDelegate {
    func displayResultList(_ results: [SearchCellModel]) {
        cellModels = results
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    func displayErrorAlert(error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            UIAlertManager.displayErrorAlert(error: error, onViewController: self)
        }
    }
}

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellModels.count == 0 {
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kWeatherCell, for: indexPath)
        let data = cellModels[indexPath.row]
        cell.textLabel?.text = data.displayText
        cell.detailTextLabel?.text = data.noteText
        cell.detailTextLabel?.textColor = data.noteTextColor
        return cell
    }
}

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectItem(onIndex: indexPath.row)
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.currentSearchText = searchText
        presenter?.onSearchTextEntered(withSearchString: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        activityIndicator.startAnimating()
        presenter?.didPressSearch(withSearchString: searchText)
    }
}
