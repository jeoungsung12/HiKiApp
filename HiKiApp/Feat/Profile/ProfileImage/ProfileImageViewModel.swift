//
//  ProfileImageViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import Foundation
import RxSwift
import RxCocoa

enum ProfileData: String, CaseIterable {
    case profile0 = "profile_0"
    case profile1 = "profile_1"
    case profile2 = "profile_2"
    case profile3 = "profile_3"
    case profile4 = "profile_4"
    case profile5 = "profile_5"
    case profile6 = "profile_6"
    case profile7 = "profile_7"
    case profile8 = "profile_8"
    case profile9 = "profile_9"
    case profile10 = "profile_10"
    case profile11 = "profile_11"
}

final class ProfileImageViewModel: BaseViewModel {

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
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.backButtonTrigger
            .bind(with: self, onNext: { owner, _ in
                output.backButtonResult.onNext(())
            }).disposed(by: disposeBag)
        
        return output
    }
    
}
