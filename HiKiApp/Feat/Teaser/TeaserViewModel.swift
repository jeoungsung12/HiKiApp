//
//  WatchViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import Foundation
import RxSwift
import RxCocoa

final class TeaserViewModel: BaseViewModel {
    private var videosData: [AnimateData] = []
    private var disposeBag = DisposeBag()
    struct Input {
        let dataTrigger: BehaviorRelay<Int>
    }
    
    struct Output {
        let pageResult: BehaviorRelay<Int> = BehaviorRelay(value: 1)
        let dataResult: BehaviorRelay<[AnimateData]> = BehaviorRelay(value: [])
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension TeaserViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.dataTrigger
            .bind(with: self, onNext: { owner, page in
                AnimateServices().getRandomAnime(page: page)
                    .subscribe { response in
                        owner.videosData.append(contentsOf: response.data)
                        output.dataResult.accept(owner.videosData)
                    } onError: { error in
                        output.dataResult.accept([])
                    }
                    .disposed(by: owner.disposeBag)
            }).disposed(by: disposeBag)
        
        return output
    }
    
}
