//
//  SearchInteractor.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

protocol SearchInteractorDelegate {
    func fetchViewedCities()
    func filterCities(withSearchString searchString: String)
    func searchCites(withSearchString searchString: String)
    func saveViewedCity(onIndex index: Int)
}

final class SearchInteractor: SearchInteractorDelegate {
    var repository: WeatherRepositoryDelegate?
    weak var presenter: SearchPresenterDelegate?
    var kLastViewedLimit = 10
    var kLengthStartSearch = 1
    var itemOrdering: ItemOrdering = .descending
    private var dataList: [ResultItem] = []
    private var viewedDataList: [ViewedItem] = []
    
    private func retrieveViewedCities() -> [ViewedItem] {
        let lastViewedCities = repository?.retrieveViewedCities(limit: kLastViewedLimit,
                                                                ordering: itemOrdering) ?? []
        return lastViewedCities
    }
    
    func fetchViewedCities() {
        self.viewedDataList = retrieveViewedCities()
        self.dataList = viewedDataList.map { $0.data }
    }
    
    func filterCities(withSearchString searchString: String) {
        var filteredViewedDataList: [ViewedItem] = []
        if searchString.isEmpty {
            filteredViewedDataList = viewedDataList
        } else if searchString.count >= kLengthStartSearch {
            filteredViewedDataList = viewedDataList.filter {
                $0.data.areaName.first?.value.lowercased()
                    .hasPrefix(searchString.lowercased()) == true
            }
        } else {
            return
        }
        
        self.dataList = filteredViewedDataList.map { $0.data }
        presenter?.presentLastViewedCities(results: filteredViewedDataList)
    }
    
    func searchCites(withSearchString searchString: String) {
        repository?.fetchCityList(searchString: searchString,
                                  success: { [weak self] response in
            let resultList = response?.searchApi.result ?? []
            self?.dataList = resultList
            self?.presenter?.presentSearchedCityList(results: resultList)
        }, failure: { [weak self] error in
            self?.dataList.removeAll()
            self?.presenter?.presentError(error: error)
        })
    }
    
    func saveViewedCity(onIndex index: Int) {
        if index < dataList.count {
            let dataItem = dataList[index]
            repository?.storeViewedCity(data: dataItem)
            presenter?.onDataSaved(withDataItem: dataItem)
        }
    }
}
