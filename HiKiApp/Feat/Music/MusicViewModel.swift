//
//  MusicViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import Foundation

final class MusicViewModel: ViewModelType {
    
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

extension MusicViewModel {
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}
