//
//  SearchDetailViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//

import Foundation
import RxSwift
import RxCocoa

struct AnimateDetailData {
    var synopsis: AnimateData?
    var teaser: [VideoPromo]?
    var characters: [CharacterData]?
}

final class SearchDetailViewModel: BaseViewModel {
    private let db = DataBase.shared
    
    enum DetailType: CaseIterable {
        case poster
        case synopsis
        case teaser
        case characters
    }
    
    struct Input {
        let detailTrigger: CustomObservable<Int>
        let heartBtnTrigger: CustomObservable<Void>
    }
    
    struct Output {
        let animeData: CustomObservable<AnimateDetailData?> = CustomObservable(nil)
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension SearchDetailViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        //TODO: Swift Concurency
        input.detailTrigger.bind { id in
            let group = DispatchGroup()
            var resultData = AnimateDetailData(synopsis: nil, teaser: nil, characters: nil)
            group.enter()
            AnimateServices().getDetailAnime(id: id) { response in
                switch response {
                case let .success(data):
                    resultData.synopsis = data
                case .failure:
                    resultData.synopsis = nil
                }
                group.leave()
            }
            group.enter()
            AnimateServices().getVideo(id: id) { response in
                switch response {
                case let .success(data):
                    resultData.teaser = data.promo
                case .failure:
                    resultData.teaser = nil
                }
                group.leave()
            }
            group.enter()
            AnimateServices().getCharacters(id: id) { response in
                switch response {
                case let .success(data):
                    resultData.characters = data
                case .failure:
                    resultData.characters = nil
                }
                group.leave()
            }
            group.notify(queue: .global()) {
                output.animeData.value = resultData
            }
        }
        
        return output
    }
    
}
