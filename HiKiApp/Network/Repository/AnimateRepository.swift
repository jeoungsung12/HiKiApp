//
//  AnimateRepository.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/21/25.
//

import Foundation
import Alamofire
import RxSwift

protocol AnimateRepositoryType {
    func fetchTopAnime(request: AnimateRequest) -> Observable<AnimateDataResponseDTO>
    func searchAnime(_ searchData: SearchViewModel.SearchRequest) -> Observable<AnimateDataResponseDTO>
    func fetchRandomAnime(page: Int) -> Observable<AnimateDataResponseDTO>
    func fetchReviews(page: Int) -> Observable<AnimateReviewResponseDTO>
    func fetchDetailAnime(id: Int) -> Observable<AnimateDetailResponseDTO>
    func fetchTeaser(id: Int) -> Observable<AnimateVideoResponseDTO>
    func fetchCharacters(id: Int) -> Observable<AnimateCharacterResponseDTO>
}

final class AnimateRepository: AnimateRepositoryType {
    private let networkManager: NetworkManagerType = NetworkManager.shared
    
    func fetchTopAnime(request: AnimateRequest) -> Observable<AnimateDataResponseDTO> {
        return networkManager.getData(AnimeRouter.topAnime(request: request))
    }

    func searchAnime(_ searchData: SearchViewModel.SearchRequest) -> Observable<AnimateDataResponseDTO> {
        return networkManager.getData(AnimeRouter.search(request: searchData))
    }

    func fetchRandomAnime(page: Int) -> Observable<AnimateDataResponseDTO> {
        return networkManager.getData(AnimeRouter.ranomAnime(page: page))
    }

    func fetchReviews(page: Int) -> Observable<AnimateReviewResponseDTO> {
        return networkManager.getData(AnimeRouter.topReview(page: page))
    }

    func fetchDetailAnime(id: Int) -> Observable<AnimateDetailResponseDTO> {
        return networkManager.getData(AnimeRouter.detailAnime(id: id))
    }

    func fetchTeaser(id: Int) -> Observable<AnimateVideoResponseDTO> {
        return networkManager.getData(AnimeRouter.getAnimeVideos(id: id))
    }

    func fetchCharacters(id: Int) -> Observable<AnimateCharacterResponseDTO> {
        return networkManager.getData(AnimeRouter.characters(id: id))
    }
}
