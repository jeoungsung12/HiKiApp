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
    func fetchTopAnime(request: AnimateRequest) -> Observable<AnimateDataResponseDTO> {
        return NetworkManager.shared.getData(AnimeRouter.topAnime(request: request))
    }

    func searchAnime(_ searchData: SearchViewModel.SearchRequest) -> Observable<AnimateDataResponseDTO> {
        return NetworkManager.shared.getData(AnimeRouter.search(request: searchData))
    }

    func fetchRandomAnime(page: Int) -> Observable<AnimateDataResponseDTO> {
        return NetworkManager.shared.getData(AnimeRouter.ranomAnime(page: page))
    }

    func fetchReviews(page: Int) -> Observable<AnimateReviewResponseDTO> {
        return NetworkManager.shared.getData(AnimeRouter.topReview(page: page))
    }

    func fetchDetailAnime(id: Int) -> Observable<AnimateDetailResponseDTO> {
        return NetworkManager.shared.getData(AnimeRouter.detailAnime(id: id))
    }

    func fetchTeaser(id: Int) -> Observable<AnimateVideoResponseDTO> {
        return NetworkManager.shared.getData(AnimeRouter.getAnimeVideos(id: id))
    }

    func fetchCharacters(id: Int) -> Observable<AnimateCharacterResponseDTO> {
        return NetworkManager.shared.getData(AnimeRouter.characters(id: id))
    }
}
