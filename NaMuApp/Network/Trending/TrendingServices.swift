//
//  TrendingServices.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation
import Alamofire

final class TrendingServices {
    
    func getTrending(completion: @escaping (Result<[SearchResult],NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(.trending) { (response: Result<SearchModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                completion(.success(data.results))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
