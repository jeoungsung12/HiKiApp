//
//  SearchTableViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchTableViewModel: BaseViewModel {
    private let db = UserDefaultManager.shared
    private var disposeBag = DisposeBag()
    var id: Int?
    struct Input {
        let heartBtnTrigger: ControlEvent<Void>
        let heartLoadTrigger: PublishRelay<Int>
    }
    
    struct Output {
        let heartBtnResult: Driver<Bool>
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension SearchTableViewModel {
    
    func transform(_ input: Input) -> Output {
        let heartResult = PublishSubject<Bool>()
        input.heartLoadTrigger
            .bind(with: self) { owner, id in
                heartResult.onNext(owner.isContainedHeart(id))
            }
            .disposed(by: disposeBag)
        
        input.heartBtnTrigger
            .bind(with: self) { owner, _ in
                heartResult.onNext(owner.saveHeart())
            }
            .disposed(by: disposeBag)
        
        return Output(heartBtnResult: heartResult.asDriver(onErrorJustReturn: false))
    }
    
    private func isContainedHeart(_ id: Int) -> Bool {
        if db.userInfo.saveAnimateID.contains(id) {
            return true
        } else {
            return false
        }
    }
    
    private func saveHeart() -> Bool {
        guard let id = id else { return false }
        var data = db.userInfo.saveAnimateID
        if data.contains(id) {
            data.removeAll(where: { $0 == id })
            db.userInfo.saveAnimateID = data
            return false
        } else {
            data.append(id)
            db.userInfo.saveAnimateID = data
            return true
        }
    }
    
}
