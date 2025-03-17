//
//  TrendingServices.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation
import Alamofire
import RxSwift

final class AnimateServices {
    private let repository: AnimateRepositoryType
    
    init(repository: AnimateRepositoryType = AnimateRepository()) {
        self.repository = repository
    }
    
    func getTopAnime(request: AnimateRequest) -> Observable<AnimateDataResponseDTO> {
        return repository.fetchTopAnime(request: request)
    }

    func searchAnime(_ searchData: SearchViewModel.SearchRequest) -> Observable<AnimateDataResponseDTO> {
        return repository.searchAnime(searchData)
    }

    func getRandomAnime(page: Int) -> Observable<AnimateDataResponseDTO> {
        return repository.fetchRandomAnime(page: page)
    }

    func getReviews(page: Int) -> Observable<AnimateReviewResponseDTO> {
        return repository.fetchReviews(page: page)
    }

    func getDetailAnime(id: Int) -> Observable<AnimateDetailResponseDTO> {
        return repository.fetchDetailAnime(id: id)
    }

    func getTeaser(id: Int) -> Observable<AnimateVideoResponseDTO> {
        return repository.fetchTeaser(id: id)
    }

    func getCharacters(id: Int) -> Observable<AnimateCharacterResponseDTO> {
        return repository.fetchCharacters(id: id)
    }
}
