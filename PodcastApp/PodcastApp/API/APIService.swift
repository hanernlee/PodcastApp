//
//  APIService.swift
//  PodcastApp
//
//  Created by Christopher Lee on 6/5/18.
//  Copyright © 2018 Christopher Lee. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    // Singleton
    
    static let shared = APIService()
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let url = "https://itunes.apple.com/search"
        let parameters = [
            "term": searchText,
            "media": "podcast"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to contact yahoo", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeError {
                print("Failed to decode", decodeError)
            }
        }
    }
}
