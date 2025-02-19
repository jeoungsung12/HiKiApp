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
                owner.fetchData(page) { result in
                    switch result {
                    case let .success(data):
                        owner.videosData.append(contentsOf: data)
                        output.dataResult.accept(owner.videosData)
                    case .failure:
                        output.dataResult.accept([])
                    }
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
    private func fetchData(_ page: Int, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        AnimateServices().getRandomAnime(page: page) { result in
            completion(result)
        }
    }
    
}
