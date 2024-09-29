//
//  RemoteService.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

import Foundation

protocol RemoteServiceDelegate {
    func fetchData<T: Decodable>(urlString: String,
                                 success: @escaping (T?) -> Void,
                                 failure: @escaping (Error?) -> Void)
}

class RemoteService: RemoteServiceDelegate {
    var httpClient: HTTPClientProtocol? = HTTPClient()
    
    func fetchData<T: Decodable>(urlString: String,
                                 success: @escaping (T?) -> Void,
                                 failure: @escaping (Error?) -> Void) {
        httpClient?.fetchData(urlString: urlString,
                              completion: { data, error in
            guard let data = data else {
                failure(APIError.noData)
                return
            }
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                success(response)
            } catch {
                failure(APIError.dataError)
            }
        })
    }
}
