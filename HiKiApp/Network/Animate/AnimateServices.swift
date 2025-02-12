//
//  TrendingServices.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation
import Alamofire

final class AnimateServices {
    //TODO: - Swift Concurrency
    func getTopAnime(request: AnimateRequest, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData((AnimeRouter.topAnime(request: AnimateRequest(page: request.page, rating: request.rating, filter: request.filter)))) { (response: Result<AnimateModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                completion(.success(data.data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func searchAnime(_ searchData: SearchViewModel.SearchRequest, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(AnimeRouter.search(request: searchData)) { (response: Result<AnimateModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                completion(.success(data.data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getRandomAnime(page: Int, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(AnimeRouter.ranomAnime(page: page)) { (response: Result<AnimateModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                let items = data.data
                completion(.success(items))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getReviews(page: Int, completion: @escaping (Result<[ReviewData],NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(AnimeRouter.topReview(page: page)) { (response: Result<AnimateReviewModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                let items = data.data
                completion(.success(items))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
