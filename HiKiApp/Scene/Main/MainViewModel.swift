//
//  MainViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/8/25.
//

import Foundation
import RxSwift
import RxCocoa

struct SectionItem {
    var section: [HomeSection]
    var item: [[HomeItem]]
}

final class MainViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    struct Input {
        let dataLoadTrigger: BehaviorRelay<AnimateType>
    }
    
    struct Output {
        let dataLoadResult: BehaviorRelay<[[AnimateDataEntity]]?> = BehaviorRelay(value: nil)
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension MainViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        input.dataLoadTrigger
            .bind(with: self, onNext: { owner, type in
                Observable.zip(
                    AnimateServices().getTopAnime(request: AnimateRequest(page: 1, rating: "g", filter: type.filter)),
                    AnimateServices().getTopAnime(request: AnimateRequest(page: 2, rating: "g", filter: type.filter)),
                    AnimateServices().getTopAnime(request: AnimateRequest(page: 3, rating: "g", filter: type.filter))
                )
                .map { result in
                    return [result.0.data.map { $0.toEntity() }, result.1.data.map { $0.toEntity() }, result.2.data.map { $0.toEntity() }]
                }
                .subscribe { data in
                    output.dataLoadResult.accept(data)
                } onError: { error in
                    output.dataLoadResult.accept(nil)
                }
                .disposed(by: owner.disposeBag)
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func setData(_ data: [[AnimateDataEntity]]) -> SectionItem {
        let headerSection = HomeSection.header
        let semiHeaderSection = HomeSection.semiHeader(title: HomeSection.semiHeader(title: "").title)
        let middleSection = HomeSection.middle(title: HomeSection.middle(title: "").title)
        let semiFooterSection = HomeSection.middle(title: HomeSection.semiFooter(title: "").title)
        let footerSection = HomeSection.middle(title: HomeSection.footer(title: "").title)
        
        let section = [headerSection, semiHeaderSection, middleSection, semiFooterSection, footerSection]
        
        let totalData = data.flatMap({$0})
            .filter { $0.enTitle != nil }
        
        let sortedData = totalData
            .filter { $0.rank != nil }
            .sorted { $0.rank! < $1.rank! }
        
        let headerData = Set(sortedData.prefix(9)).compactMap {
            return HomeItem.poster(ItemModel(id: $0.id, title: $0.enTitle, synopsis: $0.synopsis, image: $0.imageURL, star: $0.score, genre: $0.genres)) }
        
        let semiHeaderData = Set(totalData.shuffled().prefix(10)).compactMap {
            return HomeItem.recommand(ItemModel(id: $0.id, title: $0.enTitle, synopsis: $0.synopsis, image: $0.imageURL, star: $0.score, genre: nil)) }
        
        let middleData = Set(totalData.filter({$0.score > 8.0})).compactMap {
            return HomeItem.rank(ItemModel(id: $0.id, title: $0.enTitle, synopsis: $0.synopsis, image: $0.imageURL, star: $0.score, genre: nil)) }
        
        let semiFooterData = Set(totalData.filter({$0.type.uppercased() == "TV"})).compactMap {
            return HomeItem.tvList(ItemModel(id: $0.id, title: $0.enTitle, synopsis: $0.synopsis, image: $0.imageURL, star: $0.score, genre: nil)) }
        
        let footerData = Set(totalData.filter({$0.type.uppercased() == "ONA"})).compactMap {
            return HomeItem.onaList(ItemModel(id: $0.id, title: $0.enTitle, synopsis: $0.synopsis, image: $0.imageURL, star: $0.score, genre: nil)) }
        
        let item = [headerData, semiHeaderData, middleData, semiFooterData, footerData]
        
        return SectionItem(section: section, item: item)
    }
}
