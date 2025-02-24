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

final class AnimateDetailViewModel: BaseViewModel {
    enum DetailType: CaseIterable {
        case poster
        case synopsis
        case teaser
        case characters
    }
    private let db = UserDefaultManager.shared
    private var disposeBag = DisposeBag()
    
    var id: Int
    init(id: Int) {
        print(#function, "SearchDetailViewModel")
        self.id = id
    }
    
    struct Input {
        let didLoadTrigger: PublishSubject<Void>
        let heartBtnTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let heartResult: Driver<Bool>
        let animeData: BehaviorRelay<AnimateDetailData>
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension AnimateDetailViewModel {
    
    func transform(_ input: Input) -> Output {
        let heartResult: BehaviorRelay<Bool> = BehaviorRelay(value: heartResult())
        input.heartBtnTrigger
            .bind(with: self) { owner, _ in
                owner.heartBtnTapped(self.id)
                heartResult.accept(owner.heartResult())
            }.disposed(by: disposeBag)
        
        let resultData: BehaviorRelay<AnimateDetailData> = BehaviorRelay(value: AnimateDetailData(synopsis: nil, teaser: nil, characters: nil))
        input.didLoadTrigger
            .bind(with: self) { owner, _ in
                Observable.zip(AnimateServices().getDetailAnime(id: self.id), AnimateServices().getTeaser(id: self.id), AnimateServices().getCharacters(id: self.id))
                    .map { response in
                        return AnimateDetailData(synopsis: response.0.data.toEntity(), teaser: response.1.toEntity(), characters: response.2.toEntity())
                    }
                    .subscribe(with: self) { owner, data in
                        resultData.accept(data)
                    } onError: { owner, error in
                        resultData.accept(resultData.value)
                    }.disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(
            heartResult: heartResult.asDriver(),
            animeData: resultData
        )
    }
    
    //TODO: Optimistic UI
    private func heartBtnTapped(_ id: Int) {
        var userInfo = db.userInfo
        if !userInfo.saveAnimateID.contains(id) {
            userInfo.saveAnimateID.append(id)
        } else {
            userInfo.saveAnimateID.removeAll(where: { $0 == id})
        }
        db.userInfo = userInfo
    }
    
    private func heartResult() -> Bool {
        return db.userInfo.saveAnimateID.contains(self.id)
    }
}
