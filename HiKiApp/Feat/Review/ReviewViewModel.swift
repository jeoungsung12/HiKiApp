//
//  ReviewViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ReviewViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    
    enum ReviewPhase {
        case notRequest
        case success
        case endPage
    }
    
    struct Input {
        let reviewTrigger: PublishSubject<Int>
    }
    
    struct Output {
        let reviewPage: BehaviorRelay<Int> = BehaviorRelay(value: 1)
        let reviewResult: BehaviorRelay<[ReviewData]> = BehaviorRelay(value: [])
        let phaseResult: BehaviorSubject<ReviewPhase> = BehaviorSubject(value: .notRequest)
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}

extension ReviewViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.reviewTrigger
            .bind(with: self, onNext: { owner, page in
                AnimateServices().getReviews(page: page)
                    .subscribe { response in
                        let data = response.data
                        owner.checkPhase(data, output)
                        output.reviewResult.accept(output.reviewResult.value + data)
                    } onError: { error in
                        output.phaseResult.onNext(.endPage)
                    }
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func checkPhase(_ data: [ReviewData] ,_ output: Output) {
        if (data.isEmpty) {
            output.phaseResult.onNext(.endPage)
        } else {
            output.phaseResult.onNext(.success)
        }
    }
    
    func checkPaging(_ input: Input,_ output: Output) {
        let result = try? output.phaseResult.value()
        switch result {
        case .success:
            let page = output.reviewPage.value
            output.reviewPage.accept(page + 1)
        default:
            output.phaseResult.onNext(.notRequest)
        }
    }
    
}
