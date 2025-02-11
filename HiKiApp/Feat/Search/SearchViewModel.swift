//
//  SearchViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/10/25.
//

import Foundation

final class SearchViewModel: ViewModelType {
    private let db = DataBase.shared
    private var searchText: String = ""
    
    enum SearchPhase {
        case success
        case notRequest
        case notFound
        case endPage
        
        var message: String {
            switch self {
            case .success:
                ""
            case .notRequest:
                ""
            case .notFound:
                "원하는 검색결과를 찾지 못했습니다"
            case .endPage:
                "마지막 페이지 입니다"
            }
        }
    }

    struct SearchRequest {
        var searchPage: Int
        var searchText: String
    }
    
    struct Input {
        let phaseTrigger: Observable<SearchPhase>
        let searchTrigger: Observable<Int>
    }
    
    struct Output {
        var searchPage: Observable<Int> = Observable(1)
        let phaseResult: Observable<SearchPhase> = Observable(.notRequest)
        var searchResult: Observable<[AnimateData]> = Observable([])
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension SearchViewModel {
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.searchTrigger.lazyBind { [weak self] page in
            guard let text = self?.searchText else { return }
            self?.saveData(text)
            self?.fetchData(page) { [weak self] result in
                switch result {
                case let .success(data):
                    self?.checkPhase(data, output)
                    output.searchResult.value.append(contentsOf: data)
                case .failure:
                    output.phaseResult.value = .notFound
                    output.searchResult.value = []
                }
            }
        }
        
        return output
    }
    
    private func saveData(_ text: String) {
        //TODO: Property Wrapper
//        self.db.removeRecentSearch(text)
//        self.db.recentSearch.append(text)
    }
    
    private func checkPhase(_ data: [AnimateData] ,_ output: Output) {
        if (data.isEmpty) && (output.searchPage.value == 1) {
            output.phaseResult.value = .notFound
        } else if (data.isEmpty) {
            output.phaseResult.value = .endPage
        } else {
            output.phaseResult.value = .success
        }
    }
    
    private func fetchData(_ page: Int, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        let searchData = SearchRequest(searchPage: page, searchText: self.searchText)
        AnimateServices().searchAnime(searchData) { response in
            completion(response)
        }
    }
    
}


extension SearchViewModel {
    
    func checkPaging(_ input: Input,_ output: Output) {
        switch output.phaseResult.value {
        case .success:
            output.searchPage.value += 1
        default:
            output.phaseResult.value = .notRequest
        }
    }
    
    func initData(_ text: String,_ output: Output) {
        output.searchPage.value = 1
        output.searchResult.value = []
        self.searchText = ""
    }
    
    func setSearchText(_ text: String) {
        self.searchText = text
    }
    
}
