//
//  SearchServices.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation

final class SearchServices {
    
    func getSearch(_ model: SearchResponse, completion: @escaping (Result<[SearchResult],Error>) -> Void) {
        NetworkManager.shared.getData(.search(model: model)) { (response: Result<SearchModel,Error>) in
//            print(response)
            switch response {
            case let .success(data):
                completion(.success(data.results))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
