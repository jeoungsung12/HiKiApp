//
//  TrendingServices.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation
import Alamofire

final class TrendingServices {
    
    func getTrending(completion: @escaping (Result<[TrendingResult],Error>) -> Void) {
        NetworkManager.shared.getData(.trending) { (response: Result<TrendingModel,Error>) in
            switch response {
            case let .success(data):
                completion(.success(data.results))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
