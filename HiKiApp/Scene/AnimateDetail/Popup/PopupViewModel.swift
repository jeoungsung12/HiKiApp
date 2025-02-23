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
    
    struct Input {
        let startBtnTrigger: ControlEvent<Void>
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
        let startResult: PublishSubject<Void?> = PublishSubject()
        input.startBtnTrigger
            .bind(with: self) { owner, review in
                startResult.onNext(())
                
            }
            .disposed(by: disposeBag)
        
        return Output(
            startBtnResult: startResult.asDriver(onErrorJustReturn: nil)
        )
    }
    
    private func createReview() {
        
    }
    
}
