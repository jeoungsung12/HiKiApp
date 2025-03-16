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
        let removeTrigger: PublishRelay<UserReview>
    }
    
    struct Output {
        let dataResult: BehaviorRelay<[UserReview]>
    }
    
}

extension MineReviewViewModel {
    
    func transform(_ input: Input) -> Output {
        let dataResult = BehaviorRelay(value: shared.userReview)
        
        input.loadTrigger
            .bind(with: self) { owner, _ in
                dataResult.accept(owner.shared.userReview)
            }
            .disposed(by: disposeBag)
        
        input.removeTrigger
            .withUnretained(self)
            .map { owner, value in
                return owner.removeReview(value)
            }
            .bind(with: self) { owner, value in
                dataResult.accept(owner.shared.userReview)
            }
            .disposed(by: disposeBag)
        
        return Output(
            dataResult: dataResult
        )
    }
    
    private func removeReview(_ review: UserReview) {
        var data = shared.userReview
        data.removeAll(where: { $0 == review })
        shared.userReview = data
    }
    
}
