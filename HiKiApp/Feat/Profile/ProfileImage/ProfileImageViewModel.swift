//
//  ProfileImageViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import Foundation

final class ProfileImageViewModel: ViewModelType {
    let profileData = ProfileData.allCases
    
    struct Input {
        let backButtonTrigger: CustomObservable<Void>
    }
    
    struct Output {
        let backButtonResult: CustomObservable<Void> = CustomObservable(())
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension ProfileImageViewModel {
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.backButtonTrigger.lazyBind { _ in
            output.backButtonResult.value = ()
        }
        
        return output
    }
    
}
