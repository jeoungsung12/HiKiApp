//
//  ReviewViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import Foundation

final class ReviewViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
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
        return Output()
    }
    
}
