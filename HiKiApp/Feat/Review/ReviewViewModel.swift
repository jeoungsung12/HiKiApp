//
//  ReviewViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import Foundation

final class ReviewViewModel: ViewModelType {
    
    enum ReviewPhase {
        case notRequest
        case success
        case endPage
    }
    
    struct Input {
        let reviewTrigger: Observable<Int>
    }
    
    struct Output {
        let reviewPage: Observable<Int> = Observable(1)
        let reviewResult: Observable<[ReviewData]> = Observable([])
        let phaseResult: Observable<ReviewPhase> = Observable(.notRequest)
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}

extension ReviewViewModel {
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.reviewTrigger.bind { [weak self] page in
            self?.fetchData(page) { [weak self] data in
                switch data {
                case let .success(data):
                    self?.checkPhase(data, output)
                    output.reviewResult.value.append(contentsOf: data)
                case .failure:
                    output.phaseResult.value = .endPage
                }
            }
        }
        
        return output
    }
    
    private func checkPhase(_ data: [ReviewData] ,_ output: Output) {
        if (data.isEmpty) {
            output.phaseResult.value = .endPage
        } else {
            output.phaseResult.value = .success
        }
    }
    
    private func fetchData(_ page: Int, completion: @escaping (Result<[ReviewData],NetworkError.CustomError>) -> Void) {
        AnimateServices().getReviews(page: page) { response in
            completion(response)
        }
    }
    
    func checkPaging(_ input: Input,_ output: Output) {
        switch output.phaseResult.value {
        case .success:
            output.reviewPage.value += 1
        default:
            output.phaseResult.value = .notRequest
        }
    }
    
}
