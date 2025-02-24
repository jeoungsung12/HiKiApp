//
//  MineReviewViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MineReviewViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    private let shared = UserDefaultManager.shared
    
    struct Input {
        let loadTrigger: PublishRelay<Void>
    }
    
    struct Output {
        let dataResult: Driver<[UserReview]>
    }
    
}

extension MineReviewViewModel {
    
    func transform(_ input: Input) -> Output {
        var dataResult = BehaviorRelay(value: shared.userReview)
        
        input.loadTrigger
            .bind(with: self) { owner, _ in
                dataResult.accept(owner.shared.userReview)
            }
            .disposed(by: disposeBag)
        
        return Output(
            dataResult: dataResult.asDriver()
        )
    }
    
    private func removeReview(_ review: UserReview) {
        var data = shared.userReview
        data.removeAll(where: { $0 == review })
        shared.userReview = data
    }
    
}
