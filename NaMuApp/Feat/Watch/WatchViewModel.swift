//
//  WatchViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import Foundation

final class WatchViewModel: ViewModelType {
    
    struct Input {
        let dataTrigger: Observable<Int>
    }
    
    struct Output {
        let dataResult: Observable<[AnimateData]> = Observable([])
    }
    
}

extension WatchViewModel {
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.dataTrigger.bind { [weak self] page in
            self?.fetchData(page)
        }
        
        return output
    }
    
    private func fetchData(_ page: Int) -> [AnimateData] {
        
        return []
    }
    
}
