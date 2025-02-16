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
    
    //TODO: 합치기
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
    
    func getDetailAnime(id: Int, completion: @escaping (Result<AnimateData,NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(AnimeRouter.detailAnime(id: id)) { (response: Result<AnimateDetailModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                completion(.success(data.data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getVideo(id: Int, completion: @escaping (Result<VideoData,NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(AnimeRouter.getAnimeVideos(id: id)) { (response: Result<AnimateVideoModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                completion(.success(data.data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getCharacters(id: Int, completion: @escaping (Result<[CharacterData],NetworkError.CustomError>) -> Void) {
        NetworkManager.shared.getData(AnimeRouter.characters(id: id)) { (response: Result<AnimateCharacterModel,NetworkError.CustomError>) in
            switch response {
            case let .success(data):
                completion(.success(data.data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
