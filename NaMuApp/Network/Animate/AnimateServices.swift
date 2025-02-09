//
//  TrendingServices.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation
import Alamofire

final class AnimateServices {
    
    func getTopAnime(request: AnimateRequest, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(.topAnime(request: AnimateRequest(page: request.page, rating: request.rating, filter: request.filter))) { (response: Result<AnimateModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                completion(.success(data.data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getRandomAnime(page: Int, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(.ranomAnime(page: page)) { (response: Result<AnimateModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                let group = DispatchGroup()
                var animateData: [AnimateData] = []
                for item in data.data {
                    group.enter()
                    self.getWatchAnime(id: item.mal_id) { response in
                        switch response {
                        case let .success(data):
                            animateData.append(contentsOf: data)
                        case let .failure(error):
                            completion(.failure(error))
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .global()) {
                    completion(.success(animateData))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func getWatchAnime(id: Int, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(.getAnimeVideos(id: id)) { (response: Result<AnimateModel,NetworkError.CustomError>) in
            
        }
    }
    
}
