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
    func getTopAnime(request: AnimateRequest) -> Observable<[AnimateData]>
    func searchAnime(_ searchData: SearchViewModel.SearchRequest) -> Observable<[AnimateData]>
    func getRandomAnime(page: Int) -> Observable<[AnimateData]>
    func getReviews(page: Int) -> Observable<[ReviewData]>
    func getDetailAnime(id: Int) -> Observable<AnimateData>
    func getVideo(id: Int) ->  Observable<VideoData>
    func getCharacters(id: Int) -> Observable<[CharacterData]>
}

final class AnimateServices: AnimateServicesType {
    private var disposeBag = DisposeBag()
    
    func getTopAnime(request: AnimateRequest) -> Observable<[AnimateData]> {
        return Observable<[AnimateData]>.create { observer in
            
            NetworkManager.shared.getData((AnimeRouter.topAnime(request: AnimateRequest(page: request.page, rating: request.rating, filter: request.filter))))
                .subscribe { (response: AnimateModel) in
                    observer.onNext(response.data)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func searchAnime(_ searchData: SearchViewModel.SearchRequest) ->  Observable<[AnimateData]> {
        return Observable<[AnimateData]>.create { observer in
            
            NetworkManager.shared.getData(AnimeRouter.search(request: searchData))
                .subscribe { (response: AnimateModel) in
                    observer.onNext(response.data)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
    
    func getRandomAnime(page: Int) -> Observable<[AnimateData]> {
        return Observable.create { observer in
            
            NetworkManager.shared.getData(AnimeRouter.ranomAnime(page: page))
                .subscribe { (response: AnimateModel) in
                    observer.onNext(response.data)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    
    func getReviews(page: Int) -> Observable<[ReviewData]> {
        return Observable.create { observer in
            
            NetworkManager.shared.getData(AnimeRouter.topReview(page: page))
                .subscribe { (response: AnimateReviewModel) in
                    observer.onNext(response.data)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
            
    }
    
    func getDetailAnime(id: Int) -> Observable<AnimateData> {
        return Observable.create { observer in
            
            NetworkManager.shared.getData(AnimeRouter.detailAnime(id: id))
                .subscribe { (response: AnimateDetailModel) in
                    observer.onNext(response.data)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getVideo(id: Int) -> Observable<VideoData> {
        return Observable.create { observer in
            
            NetworkManager.shared.getData(AnimeRouter.getAnimeVideos(id: id))
                .subscribe { (response: AnimateVideoModel) in
                    observer.onNext(response.data)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
    }
    
    func getCharacters(id: Int) -> Observable<[CharacterData]> {
        return Observable.create { observer in
            
            NetworkManager.shared.getData(AnimeRouter.characters(id: id))
                .subscribe { (response: AnimateCharacterModel) in
                    observer.onNext(response.data)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
    }
    
}
