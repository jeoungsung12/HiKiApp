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
    
    func searchAnime(_ searchData: SearchResponse, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
//        NetworkManager.shared.getData(<#T##api: APIEndpoint##APIEndpoint#>, completion: <#T##(Result<Decodable, NetworkError.CustomError>) -> Void#>)
    }
    
    func getRandomAnime(page: Int, completion: @escaping (Result<[WatchVideo],NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(.ranomAnime(page: page)) { (response: Result<AnimateModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                let items = data.data
                var videos: [WatchVideo] = []
                let group = DispatchGroup()
                
                for (index, item) in items.enumerated() {
                    group.enter()
                    DispatchQueue.global().asyncAfter(deadline: .now() + Double(index) * (1.0 / 3.0)) {
                        self.getWatchAnime(id: item.mal_id) { response in
                            switch response {
                            case let .success(data):
                                if let data = data.data {
                                    let itemVideos = data.promo.compactMap({ $0.trailer })
                                    videos.append(contentsOf: itemVideos)
                                }
                            case let .failure(error):
                                completion(.failure(error))
                            }
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(videos))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func getWatchAnime(id: Int, completion: @escaping (Result<WatchModel,NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(.getAnimeVideos(id: id)) { (response: Result<WatchModel,NetworkError.CustomError>) in
            completion(response)
        }
    }
    
}
