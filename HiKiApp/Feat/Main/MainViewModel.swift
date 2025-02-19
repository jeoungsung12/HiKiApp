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
        let dataLoadResult: BehaviorRelay<[[AnimateData]]?> = BehaviorRelay(value: nil)
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
        var resultData: [[AnimateData]]? = []
        input.dataLoadTrigger
            .bind(with: self, onNext: { owner, type in
                let group = DispatchGroup()
                group.enter()
                //TODO: Swift Concurrency
                owner.fetchData(type: type, page: 1, rating: "g", group: group) { result in
                    switch result {
                    case .success(let success):
                        resultData?.append(success)
                    case .failure:
                        resultData = nil
                    }
                }
                if !(type == .upcoming) {
                    group.enter()
                    owner.fetchData(type: type, page: 2, rating: "g", group: group) { result in
                        switch result {
                        case .success(let success):
                            resultData?.append(success)
                        case .failure:
                            resultData = nil
                        }
                    }
                    group.enter()
                    owner.fetchData(type: type, page: 3, rating: "g", group: group) { result in
                        switch result {
                        case .success(let success):
                            resultData?.append(success)
                        case .failure:
                            resultData = nil
                        }
                    }
                }
                group.notify(queue: .global()) {
                    output.dataLoadResult.accept(resultData)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
 
    private func fetchData(type: AnimateType, page: Int, rating: String, group: DispatchGroup, completion: @escaping (Result<[AnimateData],NetworkError.CustomError>) -> Void) {
        AnimateServices().getTopAnime(request: AnimateRequest(page: page, rating: "g", filter: type.filter)) { response in
            completion(response)
            group.leave()
        }
    }
    
    func setData(_ data: [[AnimateData]]) -> SectionItem {
        let headerSection = HomeSection.header
        let semiHeaderSection = HomeSection.semiHeader(title: HomeSection.semiHeader(title: "").title)
        let middleSection = HomeSection.middle(title: HomeSection.middle(title: "").title)
        let semiFooterSection = HomeSection.middle(title: HomeSection.semiFooter(title: "").title)
        let footerSection = HomeSection.middle(title: HomeSection.footer(title: "").title)
        
        let section = [headerSection, semiHeaderSection, middleSection, semiFooterSection, footerSection]
        
        let totalData = data.flatMap({$0})
            .filter { $0.title_english != nil }
        
        let sortedData = totalData
            .filter { $0.rank != nil }
            .sorted { $0.rank! < $1.rank! }
        
        let headerData = Set(sortedData.prefix(9)).compactMap {
            return HomeItem.poster(ItemModel(id: $0.mal_id, title: $0.title_english, synopsis: $0.synopsis, image: $0.images.jpg.image_url, star: $0.score ?? 0.0, genre: $0.genres?.compactMap({$0}))) }
        
        let semiHeaderData = Set(totalData.shuffled().prefix(10)).compactMap {
            return HomeItem.recommand(ItemModel(id: $0.mal_id, title: $0.title_english, synopsis: $0.synopsis, image: $0.images.jpg.image_url, star: $0.score ?? 0.0, genre: nil)) }
        
        let middleData = Set(totalData.filter({$0.score ?? 0 > 8.0})).compactMap {
            return HomeItem.rank(ItemModel(id: $0.mal_id, title: $0.title_english, synopsis: $0.synopsis, image: $0.images.jpg.image_url, star: $0.score ?? 0.0, genre: nil)) }
        
        let semiFooterData = Set(totalData.filter({$0.type?.uppercased() == "TV"})).compactMap {
            return HomeItem.tvList(ItemModel(id: $0.mal_id, title: $0.title_english, synopsis: $0.synopsis, image: $0.images.jpg.image_url, star: $0.score ?? 0.0, genre: nil)) }
        
        let footerData = Set(totalData.filter({$0.type?.uppercased() == "ONA"})).compactMap {
            return HomeItem.onaList(ItemModel(id: $0.mal_id, title: $0.title_english, synopsis: $0.synopsis, image: $0.images.jpg.image_url, star: $0.score ?? 0.0, genre: nil)) }
        
        let item = [headerData, semiHeaderData, middleData, semiFooterData, footerData]
        
        return SectionItem(section: section, item: item)
    }
}
