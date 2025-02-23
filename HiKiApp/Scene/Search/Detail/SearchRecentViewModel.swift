//
//  SearchRecentViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/22/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchDelegate: AnyObject {
    func removeAll()
    func recentTapped()
    func removeTapped()
}

final class SearchRecentViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    weak var delegate: SearchDelegate?
    
    struct Input {
        let removeBtnTrigger: ControlEvent<Void>
//        let recentBtnTrigger: 
    }
    
    struct Output {
        
    }
    
}

extension SearchRecentViewModel {
    
    func transform(_ input: Input) -> Output {
        
        
        return Output()
    }
    
}
