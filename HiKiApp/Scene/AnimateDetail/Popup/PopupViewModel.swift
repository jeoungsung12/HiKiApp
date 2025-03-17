//
//  PopupViewModel.swift
//  UIKit_Week9_HA
//
//  Created by 정성윤 on 2/20/25.
//

import Foundation
import RxSwift
import RxCocoa
struct PopModel {
    let review: String
    let reviewValue: Double
}

protocol CreateReviewDelegate: AnyObject {
    func selectIcon()
}

final class PopupViewModel: BaseViewModel {
    private var db = UserDefaultManager.shared
    private var disposeBag = DisposeBag()
    weak var delegate: CreateReviewDelegate?

    
    var userReview: UserReview
    private var review: UserReview?
    init(userReview: UserReview) {
        self.userReview = userReview
    }
    
    struct Input {
        let startBtnTrigger: PublishRelay<PopModel>
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
            .withUnretained(self)
            .flatMapLatest { owner, value in
                owner.review = self.userReview
                owner.review?.review = value.review
                owner.review?.reviewValue = value.reviewValue
                
                return ReviewServices().getReview(self.userReview)
                    .catch { error in
                        return Observable.empty()
                    }
            }
            .subscribe(with: self) { owner, answer in
                owner.createReview(answer.toEntity().content)
                startResult.accept(())
            } onError: { owner, error in
                startResult.accept(nil)
            }
            .disposed(by: disposeBag)
        
        return Output(
            startBtnResult: startResult.asDriver(onErrorJustReturn: nil)
        )
    }
    
    private func createReview(_ answer: String) {
        var userReview = db.userReview
        review?.answer = answer
        if let review = self.review {
            userReview.append(review)
            UserDefaultManager.shared.userReview = userReview
        }
    }
    
}
