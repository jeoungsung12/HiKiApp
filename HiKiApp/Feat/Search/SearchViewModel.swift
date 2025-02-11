//
//  SearchViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/10/25.
//

import Foundation

final class SearchViewModel: ViewModelType {
    
    struct Input {
        let searchTrigger: Observable<SearchResponse>
    }
    
    struct Output {
        let searchResult: Observable<[AnimateData]> = Observable([])
    }
    
}

extension SearchViewModel {
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.searchTrigger.lazyBind { searchData in
            self.fetchData(searchData) { [weak self] result in
                switch result {
                case let .success(data):
                    print(data)
                case let .failure(error):
                    print(error)
                }
            }
        }
        
        return output
    }
    
    private func fetchData(_ searchData: SearchResponse, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        AnimateServices().searchAnime(searchData) { response in
            completion(response)
        }
    }
    
}

//
//switch response {
//case let .success(data):
//    self.checkPhase(data)
//    self.searchData.searchResult += data
//    self.loadingIndicator.stopAnimating()
//    
//case let .failure(error):
//    if error == .network {
//        self.errorPresent(error)
//    } else {
//        self.searchData.searchPhase = .notFound
//        self.resultLabel.text = self.searchData.searchPhase.message
//        self.loadingIndicator.stopAnimating()
//    }
//}
