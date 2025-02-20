//
//  TeaserTableViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/20/25.
//

import Foundation
import RxSwift
import RxCocoa

final class TeaserTableViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    
    struct Input {
        let inputTrigger: PublishSubject<[VideoPromo]>
    }
    
    struct Output {
        let teaserResult: BehaviorRelay<[VideoPromo]>
    }
    
}

extension TeaserTableViewModel {
    
    func transform(_ input: Input) -> Output {
        let output: BehaviorRelay<[VideoPromo]> = BehaviorRelay(value: [])
        
        input.inputTrigger
            .bind(to: output)
            .disposed(by: disposeBag)
        
        return Output(teaserResult: output)
    }
    
}
