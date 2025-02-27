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
    private var disposeBag = DisposeBag()
    weak var delegate: CreateReviewDelegate?

    
    var userReview: UserReview
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
            .flatMapLatest { value in
                var data = self.userReview
                data.review = value.review
                print(data)
                return ReviewServices().getReview(data)
            }
            .subscribe(with: self) { owner, answer in
                owner.createReview(answer.toEntity().content)
                startResult.accept(())
            } onError: { owner, error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        return Output(
            startBtnResult: startResult.asDriver(onErrorJustReturn: nil)
        )
    }
    
    //TODO: UserDefaultManager
    private func createReview(_ answer: String) {
        var data = self.userReview
        data.answer = answer
        
        var userReview = UserDefaultManager.shared.userReview
        userReview.append(data)
        
        UserDefaultManager.shared.userReview = userReview
        dump(UserDefaultManager.shared.userReview)
    }
    
}
