//
//  MyPageViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/11/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageViewModel: BaseViewModel {
    private let db = UserDefaultManager.shared
    private(set) var profileData = ProfileData.allCases
    private var disposeBag = DisposeBag()
    
    enum MyPageCategoryType: String, CaseIterable {
        case aniBox = " Anime\nArchive"
        case profile = "  Edit\nProfile"
        
        var image: String {
            switch self {
            case .aniBox:
                "cube.box"
            case .profile:
                "person.text.rectangle"
            }
        }
    }
    
    enum MyPageButtonType: String, CaseIterable {
        case oftenQS = "Frequently Asked Questions"
        case feedback = "Send Feedback"
        case withdraw = "Unsubscribe"
    }
    
    struct Input {
        let profileTrigger: PublishSubject<Void>
        let listBtnTrigger: PublishRelay<MyPageButtonType>
        let categoryBtnTrigger: PublishRelay<MyPageCategoryType>
    }
    
    struct Output {
        let profileResult: BehaviorRelay<UserInfo>
        let listBtnResult: PublishRelay<MyPageButtonType>
        let categoryBtnResult: PublishRelay<MyPageCategoryType>
    }

    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension MyPageViewModel {
    
    func transform(_ input: Input) -> Output {
        let profileResult = BehaviorRelay(value: db.userInfo)
        input.profileTrigger
            .bind(with: self) { owner, _ in
                profileResult.accept(owner.db.userInfo)
            }
            .disposed(by: disposeBag)
        
        let categoryResult = PublishRelay<MyPageCategoryType>()
        input.categoryBtnTrigger
            .bind { value in
                categoryResult.accept(value)
            }.disposed(by: disposeBag)
        
        let btnResult = PublishRelay<MyPageButtonType>()
        input.listBtnTrigger
            .bind { value in
                btnResult.accept(value)
            }.disposed(by: disposeBag)
        
        return Output(
            profileResult: profileResult,
            listBtnResult: btnResult,
            categoryBtnResult: categoryResult)
    }
    
    func removeUserInfo() {
        db.removeUserDefault(.userInfo)
        db.removeUserDefault(.userReview)
        db.removeUserDefault(.recentSearch)
    }
    
    func getSaveAnime() -> String {
        return db.userInfo.saveAnimateID.count.formatted() + " in storage"
    }
    
}
