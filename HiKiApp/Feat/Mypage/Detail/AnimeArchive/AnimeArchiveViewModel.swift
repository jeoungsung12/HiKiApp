//
//  AnimeArchiveViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class AnimeArchiveViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    private(set) var saveAnime: String = "Save animations you're interested in to watch later!"
    
    struct Input {
        let reloadTrigger: PublishSubject<Void>
    }
    
    struct Output {
        let dataResult: Driver<[AnimateDetailEntity]>
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}

extension AnimeArchiveViewModel {
    
    func transform(_ input: Input) -> Output {
        let dataResult: BehaviorRelay<[AnimateDetailEntity]> = BehaviorRelay(value: [])
        
        input.reloadTrigger
            .flatMapLatest { [weak self] _ -> Observable<[AnimateDetailResponseDTO]> in
                guard let self = self else { return .empty() }
                let saveData = self.getSaveAnimeData()
                
                let requests = saveData.map { id in
                    AnimateServices().getDetailAnime(id: id)
                        .delay(.milliseconds(350), scheduler: MainScheduler.instance)
                }
                
                return Observable.concat(requests)
                    .toArray()
                    .asObservable()
            }
            .bind(with: self) { owner, data in
                dataResult.accept(data.map { $0.toEntity() })
            }
            .disposed(by: disposeBag)
        
        return Output(
            dataResult: dataResult.asDriver()
        )
    }
    
    func getSaveAnimeData() -> [Int] {
        return UserDefaultManager.shared.userInfo.saveAnimateID
    }
    
}
