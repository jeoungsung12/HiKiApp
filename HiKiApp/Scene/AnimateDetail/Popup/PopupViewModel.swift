//
//  PopupViewModel.swift
//  UIKit_Week9_HA
//
//  Created by 정성윤 on 2/20/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol CreateReviewDelegate: AnyObject {
    func selectIcon()
}

final class PopupViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    weak var delegate: CreateReviewDelegate?
    
    var userReview: UserReview
    init(userReview: UserReview) {
        self.userReview = userReview
    }
    
    struct Input {
        let startBtnTrigger: PublishRelay<String>
    }
    
    struct Output {
        let startBtnResult: Driver<Void?>
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension PopupViewModel {
    
    func transform(_ input: Input) -> Output {
        let startResult: PublishRelay<Void?> = PublishRelay()
        input.startBtnTrigger
            .bind(with: self) { owner, review in
                owner.createReview(review)
                startResult.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            startBtnResult: startResult.asDriver(onErrorJustReturn: nil)
        )
    }
    
    //TODO: UserDefaultManager
    private func createReview(_ review: String) {
        var data = self.userReview
        data.review = review
        
        var userReview = UserDefaultManager.shared.userReview
        userReview.append(data)
        
        UserDefaultManager.shared.userReview = userReview
    }
    
}
