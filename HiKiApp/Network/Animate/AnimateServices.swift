//
//  TrendingServices.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation
import Alamofire
import RxSwift

protocol AnimateServicesType {
    func getTopAnime(request: AnimateRequest) -> Observable<AnimateModel>
    func searchAnime(_ searchData: SearchViewModel.SearchRequest) -> Observable<AnimateModel>
    func getRandomAnime(page: Int) -> Observable<AnimateModel>
    func getReviews(page: Int) -> Observable<AnimateReviewModel>
    func getDetailAnime(id: Int) -> Observable<AnimateDetailModel>
    func getTeaser(id: Int) ->  Observable<AnimateVideoModel>
    func getCharacters(id: Int) -> Observable<AnimateCharacterModel>
}

final class AnimateServices: AnimateServicesType {
    private var disposeBag = DisposeBag()
    
    func getTopAnime(request: AnimateRequest) -> Observable<AnimateModel> {
        return NetworkManager.shared.getData((AnimeRouter.topAnime(request: AnimateRequest(page: request.page, rating: request.rating, filter: request.filter))))
    }
    
    func searchAnime(_ searchData: SearchViewModel.SearchRequest) ->  Observable<AnimateModel> {
        return  NetworkManager.shared.getData(AnimeRouter.search(request: searchData))
    }
    
    func getRandomAnime(page: Int) -> Observable<AnimateModel> {
        return NetworkManager.shared.getData(AnimeRouter.ranomAnime(page: page))
    }
    
    func getReviews(page: Int) -> Observable<AnimateReviewModel> {
        return NetworkManager.shared.getData(AnimeRouter.topReview(page: page))
    }
    
    func getDetailAnime(id: Int) -> Observable<AnimateDetailModel> {
        return NetworkManager.shared.getData(AnimeRouter.detailAnime(id: id))
    }
    
    func getTeaser(id: Int) -> Observable<AnimateVideoModel> {
        return NetworkManager.shared.getData(AnimeRouter.getAnimeVideos(id: id))
    }
    
    func getCharacters(id: Int) -> Observable<AnimateCharacterModel> {
        return NetworkManager.shared.getData(AnimeRouter.characters(id: id))
    }
    
}
