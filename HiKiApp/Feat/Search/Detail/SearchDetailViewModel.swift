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
    var synopsis: AnimateDataEntity?
    var teaser: [AnimateVideoEntity]?
    var characters: [AnimateCharacterEntity]?
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
        
        let resultData = AnimateDetailData(synopsis: nil, teaser: nil, characters: nil)
        Observable.zip(AnimateServices().getDetailAnime(id: self.id), AnimateServices().getTeaser(id: self.id), AnimateServices().getCharacters(id: self.id))
            .map { response in
                return AnimateDetailData(synopsis: response.0.data.toEntity(), teaser: response.1.toEntity(), characters: response.2.toEntity())
            }
            .subscribe(with: self) { owner, data in
                output.animeData.accept(data)
            } onError: { owner, error in
                output.animeData.accept(resultData)
            }.disposed(by: disposeBag)
        
        return output
    }
    
}
