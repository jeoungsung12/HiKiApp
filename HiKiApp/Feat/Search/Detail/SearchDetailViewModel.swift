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
    enum DetailType: CaseIterable {
        case poster
        case synopsis
        case teaser
        case characters
    }
    private let db = DataBase.shared
    private var disposeBag = DisposeBag()
    
    var id: Int
    init(id: Int) {
        print(#function, "SearchDetailViewModel")
        self.id = id
    }
    
    struct Input {
        let heartBtnTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let animeData: BehaviorRelay<AnimateDetailData?> = BehaviorRelay(value: nil)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension SearchDetailViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.heartBtnTrigger
            .bind(with: self) { owner, _ in
                //TODO: HeartTapped
            }.disposed(by: disposeBag)
        
        //TODO: Swift Concurency
        let group = DispatchGroup()
        var resultData = AnimateDetailData(synopsis: nil, teaser: nil, characters: nil)
        group.enter()
        AnimateServices().getDetailAnime(id: self.id) { response in
            switch response {
            case let .success(data):
                resultData.synopsis = data
            case .failure:
                resultData.synopsis = nil
            }
            group.leave()
        }
        group.enter()
        AnimateServices().getVideo(id: self.id) { response in
            switch response {
            case let .success(data):
                resultData.teaser = data.promo
            case .failure:
                resultData.teaser = nil
            }
            group.leave()
        }
        group.enter()
        AnimateServices().getCharacters(id: self.id) { response in
            switch response {
            case let .success(data):
                resultData.characters = data
            case .failure:
                resultData.characters = nil
            }
            group.leave()
        }
        group.notify(queue: .main) {
            output.animeData.accept(resultData)
        }
        
        return output
    }
    
}
