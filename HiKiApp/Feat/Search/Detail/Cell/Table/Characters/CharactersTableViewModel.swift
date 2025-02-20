//
//  CharactersTableViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/19/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CharactersTableViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    
    struct Input {
        let inputTrigger: PublishSubject<[CharacterData]>
    }
    
    struct Output {
        let charactersResult: BehaviorRelay<[CharacterData]>
    }
    
}

extension CharactersTableViewModel {
    
    func transform(_ input: Input) -> Output {
        let output: BehaviorRelay<[CharacterData]> = BehaviorRelay(value: [])
        
        input.inputTrigger
            .bind(to: output)
            .disposed(by: disposeBag)
        
        return Output(charactersResult: output)
    }
    
}
