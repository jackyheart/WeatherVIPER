//
//  HTTPClient.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

import Foundation

protocol HTTPClientProtocol {
    func fetchData(urlString: String, completion: @escaping (Data?, Error?) -> Void)
}

class HTTPClient: HTTPClientProtocol {
    func fetchData(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }
}
