//
//  SearchViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    private(set) var db = DataBase.shared
    private var searchText: String = ""
    private var disposeBag = DisposeBag()
    
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
        let searchTrigger: PublishSubject<Int>
    }
    
    struct Output {
        var searchPage: BehaviorRelay<Int> = BehaviorRelay(value: 1)
        let phaseResult: BehaviorRelay<SearchPhase> = BehaviorRelay(value: .notRequest)
        var searchResult: BehaviorRelay<[AnimateDataEntity]> = BehaviorRelay(value: [])
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension SearchViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.searchTrigger
            .bind(with: self, onNext: { owner, page in
                owner.saveData(owner.searchText)
                
                let searchData = SearchRequest(searchPage: page, searchText: self.searchText)
                AnimateServices().searchAnime(searchData)
                    .subscribe(with: self) { owner, response in
                        let data = response.data.map { $0.toEntity() }
                        owner.checkPhase(data, output)
                        output.searchResult.accept(output.searchResult.value + data)
                    } onError: { owner, error in
                        output.phaseResult.accept(.notFound)
                        output.searchResult.accept([])
                    }
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func saveData(_ text: String) {
        //TODO: Property Wrapper
        self.db.recentSearch.append(text)
    }
    
    private func checkPhase(_ data: [AnimateDataEntity] ,_ output: Output) {
        if (data.isEmpty) && (output.searchPage.value == 1) {
            output.phaseResult.accept(.notFound)
        } else if (data.isEmpty) {
            output.phaseResult.accept(.endPage)
        } else {
            output.phaseResult.accept(.success)
        }
    }
}


extension SearchViewModel {
    
    func checkPaging(_ input: Input,_ output: Output) {
        switch output.phaseResult.value {
        case .success:
            let page = output.searchPage.value
            output.searchPage.accept(page + 1)
        default:
            output.phaseResult.accept(.notRequest)
        }
    }
    
    func initData(_ output: Output) {
        output.searchPage.accept(1)
        output.searchResult.accept([])
    }
    
    func setSearchText(_ text: String) {
        self.searchText = text
    }
    
}
