//
//  MainViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/8/25.
//

import Foundation

final class MainViewModel: ViewModelType {
    
    struct Input {
        let dataLoadTrigger: Observable<AnimeType>
    }
    
    struct Output {
        let dataLoadResult: Observable<[[AnimateData]]?> = Observable([])
    }
    
}

extension MainViewModel {
    
    func transform(input: Input) -> Output {
        let output = Output()
        var resultData: [[AnimateData]]? = []
        input.dataLoadTrigger.bind { [weak self] type in
            let group = DispatchGroup()
            group.enter()
            self?.fetchData(type: type, page: 1, rating: "g", group: group) { result in
                switch result {
                case .success(let success):
                    resultData?.append(success)
                case .failure:
                    resultData = nil
                }
            }
            group.enter()
            self?.fetchData(type: type, page: 2, rating: "g", group: group) { result in
                switch result {
                case .success(let success):
                    resultData?.append(success)
                case .failure:
                    resultData = nil
                }
            }
            group.enter()
            self?.fetchData(type: type, page: 3, rating: "g", group: group) { result in
                switch result {
                case .success(let success):
                    resultData?.append(success)
                case .failure:
                    resultData = nil
                }
            }
            group.notify(queue: .global()) {
                output.dataLoadResult.value = resultData
            }
        }
        
        return output
    }
 
    private func fetchData(type: AnimeType, page: Int, rating: String, group: DispatchGroup, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        AnimateServices().getTopAnime(request: AnimateRequest(page: page, rating: "g", filter: type.filter)) { response in
            completion(response)
            group.leave()
        }
    }
}
