//
//  ProfileImageViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileImageViewModel: ViewModelType {
    let profileData = ProfileData.allCases
    private var disposeBag = DisposeBag()
    
    struct Input {
        let backButtonTrigger: PublishSubject<Void>
    }
    
    struct Output {
        let backButtonResult: PublishSubject<Void> = PublishSubject()
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
        
        input.backButtonTrigger
            .bind(with: self, onNext: { owner, _ in
                output.backButtonResult.onNext(())
            }).disposed(by: disposeBag)
        
        return output
    }
    
}
